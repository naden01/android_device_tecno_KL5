/*
 * Copyright (C) 2020 MediaTek Inc.
 * SPDX-License-Identifier: Apache-2.0
 */

#include <cstdint>
#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <android-base/logging.h>

#if !defined(ARCH_X86)
#include <mmc-mtk-ioctl.h>
#include <ufs-mtk-ioctl.h>
#include <sys/ioctl.h>
#endif

#include "boot_region_control_private.h"

namespace android {
namespace bootable {
#if !defined(ARCH_X86)

#define CMD_ARG(b3, b2, b1, b0) (((b3) << 24) | ((b2) << 16) | ((b1) << 8) | (b0))

static int mmc_read_ext_csd(int fd, uint8_t* ext_csd) {
    struct mmc_ioc_cmd cmd;
    memset(&cmd, 0, sizeof(cmd));
    memset(ext_csd, 0, 512);

    cmd.blocks = 1;
    cmd.blksz = 512;
    cmd.opcode = MMC_SEND_EXT_CSD;
    cmd.flags = MMC_CMD_ADTC | MMC_RSP_R1;
    mmc_ioc_cmd_set_data(cmd, ext_csd);

    if (ioctl(fd, MMC_IOC_CMD, &cmd) < 0) {
        LOG(ERROR) << "Failed to read ext csd: " << errno;
        return -errno;
    }
    return 0;
}

static bool emmc_set_active_boot_part(int boot) {
    uint8_t ext_csd[512];
    int fd = open("/dev/block/mmcblk0", O_RDWR);
    if (fd < 0) {
        LOG(ERROR) << "Failed to open /dev/block/mmcblk0: " << errno;
        return false;
    }

    if (mmc_read_ext_csd(fd, ext_csd) < 0) {
        close(fd);
        return false;
    }

    uint8_t cur = (ext_csd[EXT_CSD_PART_CONFIG] >> 3) & 0x07;
    if (cur == static_cast<uint8_t>(boot)) {
        close(fd);
        return true;
    }

    uint8_t arg = (ext_csd[EXT_CSD_PART_CONFIG] & ~(0x38)) | ((boot & 0x07) << 3);
    struct mmc_ioc_cmd cmd;
    memset(&cmd, 0, sizeof(cmd));
    cmd.opcode = MMC_SWITCH;
    cmd.arg = CMD_ARG(MMC_SWITCH_MODE_WRITE_BYTE, EXT_CSD_PART_CONFIG, arg, EXT_CSD_CMD_SET_NORMAL);
    cmd.flags = MMC_CMD_AC | MMC_RSP_R1B;
    mmc_ioc_cmd_set_data(cmd, ext_csd);

    bool ok = true;
    if (ioctl(fd, MMC_IOC_CMD, &cmd) < 0) {
        LOG(ERROR) << "MMC_IOC_CMD switch bootpart failed: " << errno;
        ok = false;
    }
    close(fd);
    return ok;
}

static bool ufs_set_active_boot_part(int boot) {
    struct ufs_ioctl_query_data idata;
    unsigned char buf[1];
    int fd = open("/dev/block/sdc", O_RDWR);
    if (fd < 0) {
        LOG(ERROR) << "open /dev/block/sdc failed, err: " << errno;
        return false;
    }

    buf[0] = static_cast<unsigned char>(boot); /* 1: BootLU A, 2: BootLU B */
    idata.opcode = UPIU_QUERY_OPCODE_WRITE_ATTR;
    idata.idn = QUERY_ATTR_IDN_BOOT_LUN_EN;
    idata.idx = 0;
    idata.buf_ptr = &buf[0];
    idata.buf_byte = 1;

    bool ret = true;
    if (ioctl(fd, UFS_IOCTL_QUERY, &idata) < 0) {
        LOG(ERROR) << "ufs_set boot_part fail: " << errno;
        ret = false;
    }
    close(fd);
    return ret;
}

bool BootControlExt::SetBootRegionSlot(unsigned int slot) {
    LOG(INFO) << "setActiveBootSlot SetBootRegionSlot " << slot;
    if (slot >= 2) {
        LOG(ERROR) << "Wrong Slot value " << slot;
        return false;
    }
    int boot_part = slot ? 2 : 1;
    if (access("/dev/block/mmcblk0", F_OK) == 0) {
        return emmc_set_active_boot_part(boot_part);
    }
    return ufs_set_active_boot_part(boot_part);
}
#else
bool BootControlExt::SetBootRegionSlot(unsigned int slot) {
    (void)slot;
    return true;
}
#endif
}  // namespace bootable
}  // namespace android
