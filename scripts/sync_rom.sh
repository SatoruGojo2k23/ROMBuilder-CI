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

#fw/native patch
cd frameworks/native || exit 1
curl https://github.com/begonia-dev/android_frameworks_native/commit/629aa1b40ceb83b57c8bd4803036013029586e11.patch | git am -3
cd ../..

#adding patch fw/base
rm -rf frameworks/base && git clone --depth=1 https://github.com/SatoruGojo2k23/CrDroid-android_frameworks_base frameworks/base;

#adding patch fw/av
rm -rf frameworks/av && git clone --depth=1 https://github.com/SatoruGojo2k23/CrDroid-android_frameworks_av frameworks/av;

#adding patch packages/apps
cd packages/apps/Settings || exit 1
curl https://github.com/begonia-dev/android_packages_apps_Settings/commit/a88066cb1451edb42e75eb66d3b6b8a3dbcba9a6.patch | git am -3 
cd ../../..

#adding patch wifi
cd packages/modules/Wifi && git fetch https://github.com/AOSP-13-RMX2020/packages_modules_Wifi && git cherry-pick 1315ccb757bd2d7c63b4815ab77e04535d2b7750^..6b341eefeb1127a97dc3b77a853e30ed7630be30 && cd ../../..

exit 0;
