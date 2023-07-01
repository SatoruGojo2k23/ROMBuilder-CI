#!/bin/bash

cd ~;
mkdir $ROM_NAME;
cd $ROM_NAME;
git config --global user.name "$USERNAME";
git config --global user.email "$USERMAIL";

# Initialize RED source
repo init --depth=1 --no-repo-verify -u $ROM_REPO -b $ROM_BRANCH -g default,-mips,-darwin,-notdefault;

# Sync RED source
repo sync -c -j$(nproc --all) --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync;

# Clone GREEN source
git clone $DEVICE_REPO --depth=1 -b $DEVICE_BRANCH "device/$OEM/$CODENAME";
git clone $VENDOR_REPO --depth=1 -b $VENDOR_BRANCH "vendor/$OEM/$CODENAME";
git clone $KERNEL_REPO --depth=1 -b $KERNEL_BRANCH "kernel/$OEM/$CODENAME";

#clone mtk hardware
git clone --depth=1 https://github.com/ArrowOS/android_hardware_mediatek hardware/mediatek;

#clone Sepolicy
git clone --depth=1 https://github.com/ArrowOS/android_device_mediatek_sepolicy_vndr -b arrow-13.1 device/mediatek/sepolicy_vndr;

#Clone Clang
git clone --depth=1 https://github.com/sarthakroy2002/android_prebuilts_clang_host_linux-x86_clang-r437112 prebuilts/clang/host/linux-x86/clang-r437112;

#Clone Ims
git clone --depth=1 https://github.com/ArrowOS-Devices/android_vendor_realme_RMX2020-ims vendor/realme/RMX2020-ims;

exit 0;
