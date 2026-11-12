#
#	This file is part of the OrangeFox Recovery Project
# 	Copyright (C) 2024-2025 The OrangeFox Recovery Project
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
# make-time OrangeFox variables (read by bootable/recovery/orangefox.mk, and inherited
# through twrp_KL5.mk). The shell exports - FOX_* and anything the build script consumes -
# stay in vendorsetup.sh.
#

# maintainer
OF_MAINTAINER := Nazephyrus

# screen settings
OF_SCREEN_H := 2400
OF_STATUS_H := 95
OF_STATUS_INDENT_LEFT := 48
OF_STATUS_INDENT_RIGHT := 48
OF_CLOCK_POS := 1

# other stuff
OF_QUICK_BACKUP_LIST := /boot;/data;
OF_ENABLE_LPTOOLS := 1
OF_NO_TREBLE_COMPATIBILITY_CHECK := 1
OF_FLASHLIGHT_ENABLE := 1
# /of_flashlight is a fake dir in the ramdisk; init.recovery.mt6768.rc links its
# brightness to the torch level node (OrangeFox expects "$OF_FL_PATH1/brightness")
OF_FL_PATH1 := /of_flashlight
OF_FORCE_CASEFOLDING := 1
OF_DYNAMIC_FULL_SIZE := 9125756928

# number of list options before scrollbar creation
OF_OPTIONS_LIST_NUM := 9

# ----- data format stuff -----
# ensure that /sdcard is bind-unmounted before f2fs data repair or format
OF_UNBIND_SDCARD_F2FS := 1

# Called just before formatting /data; only useful for devices/ROMs that have dynamic partitions
OF_USE_DMCTL := 1

# automatically wipe /metadata after data format
OF_WIPE_METADATA_AFTER_DATAFORMAT := 1

# avoid MTP issues after data format
OF_BIND_MOUNT_SDCARD_ON_FORMAT := 1

# don't spam the console with loop errors
OF_LOOP_DEVICE_ERRORS_TO_LOG := 1

# lz4 compression
OF_USE_LZ4_COMPRESSION := 1

# build all the partition tools
OF_ENABLE_ALL_PARTITION_TOOLS := 1

# Set this to 1 to include an addon for removing factory reset protection (FRP)
OF_ENABLE_FRP_ADDON := 1

# keymaster
OF_DEFAULT_KEYMASTER_VERSION=4.1
