#
# Copyright (C) 2022 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from TEcno-KL5 device
$(call inherit-product, device/tecno/KL5/device.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/aosp_base.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)

# Include Fox props
$(call inherit-product, device/tecno/KL5/fox.mk)

# Inherit some common TWRP stuff.
$(call inherit-product, vendor/twrp/config/common.mk)

PRODUCT_DEVICE := KL5
PRODUCT_NAME := twrp_KL5
PRODUCT_BRAND := TECNO
PRODUCT_MODEL := TECNO KL5
PRODUCT_MANUFACTURER := tecno

PRODUCT_GMS_CLIENTID_BASE := android-tecno