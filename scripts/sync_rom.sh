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

# Clone RealmeParts
git clone --depth=1 https://github.com/Realme-G70-Series/android_packages_apps_RealmeParts -b lineage-18.1 packages/apps/RealmeParts;

# Clone RealmeDirac
git clone --depth=1 https://github.com/Realme-G70-Series/android_packages_apps_RealmeDirac -b lineage-18.1 packages/apps/RealmeDirac;

# Selinux
cd external/selinux && curl -L http://ix.io/2FhM > sasta.patch && git am sasta.patch && cd ../..

# Audio
cd frameworks/av && wget https://github.com/phhusson/platform_frameworks_av/commit/624cfc90b8bedb024f289772960f3cd7072fa940.patch && patch -p1 < *.patch && cd -

exit 0;
