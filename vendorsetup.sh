#
#	This file is part of the OrangeFox Recovery Project
# 	Copyright (C) 2025 The OrangeFox Recovery Project
#
#	OrangeFox is free software: you can redistribute it and/or modify
#	it under the terms of the GNU General Public License as published by
#	the Free Software Foundation; either version 3 of the License, or
#	any later version.
#
#	OrangeFox is distributed in the hope that it will be useful,
#	but WITHOUT ANY WARRANTY; without even the implied warranty of
#	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#	GNU General Public License for more details.
#
# 	This software is released under GPL version 3 or any later version.
#	See <http://www.gnu.org/licenses/>.
#
# 	Please maintain this if you use this script or any part of it
#

#device
# FOX_TARGET_DEVICES is left unset on purpose: it then inherits TARGET_OTA_ASSERT_DEVICE
# (TECNO-KL5,TECNO-KL5n,KL5,KL5n) from BoardConfig.mk, which covers both KL5 variants.
export TARGET_DEVICE_ALT=KL5n

# maintainer avatar (OF_MAINTAINER is in fox.mk; OrangeFox_A14.sh never copies the avatar itself)
OF_MAINTAINER_TREE="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
export OF_MAINTAINER_AVATAR="$OF_MAINTAINER_TREE/maintainer_avatar.png"
OF_THEME_ABOUT="$(gettop 2>/dev/null || true)/bootable/recovery/gui/theme/portrait_hdpi/images/Default/About"
if [ -f "$OF_MAINTAINER_AVATAR" ] && [ -d "$OF_THEME_ABOUT" ]; then
	cp -f "$OF_MAINTAINER_AVATAR" "$OF_THEME_ABOUT/maintainer.png"
fi

# other
export FOX_VIRTUAL_AB_DEVICE=1
export FOX_ENABLE_APP_MANAGER=1
export FOX_VENDOR_BOOT_RECOVERY=1
# 1 = swap only the recovery ramdisk inside the device's own vendor_boot (this is
# OrangeFox_A14.sh:581's default, and what the booting c44cc93 build + the working
# LH8n tree both use). 0 makes the zip overwrite the whole vendor_boot partition by
# writing recovery.img to vendor_boot_a/_b, which a virtual-A/B device does not have.
export FOX_INSTALLER_VENDOR_BOOT_RAMDISK_INSTALL=1
export FOX_RECOVERY_VENDOR_BOOT_PARTITION="/dev/block/by-name/vendor_boot"
export FOX_RECOVERY_SYSTEM_PARTITION="/dev/block/mapper/system"
export FOX_RECOVERY_VENDOR_PARTITION="/dev/block/mapper/vendor"
export FOX_USE_XZ_UTILS=1
export FOX_USE_BASH_SHELL=1
export FOX_ASH_IS_BASH=1
export FOX_USE_TAR_BINARY=1
export FOX_USE_LZ4_BINARY=1
export FOX_USE_SED_BINARY=1
export FOX_USE_ZSTD_BINARY=1
export FOX_USE_NANO_EDITOR=1
export FOX_USE_UPDATED_MAGISKBOOT=1
export FOX_DELETE_AROMAFM=1
export FOX_USE_DATE_BINARY=1
# system/system_ext/product/vendor are erofs
export FOX_USE_FSCK_EROFS_BINARY=1
# FOX_MOVE_MAGISK_INSTALLER_TO_RAMDISK is left unset: it copies the 11 MiB Magisk.zip
# into the ramdisk and overflows vendor_boot (64 MiB). Magisk still installs from /sdcard.
export FOX_BUILD_TYPE="stable"

# KSU, etc.
	export FOX_ENABLE_KERNELSU_SUPPORT=1
	export FOX_ENABLE_KERNELSU_NEXT_SUPPORT=1
	export FOX_ENABLE_SUKISU_SUPPORT=1
