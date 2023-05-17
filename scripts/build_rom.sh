#!/bin/bash

cd ~
cd ${ROM_NAME}
export USE_CCACHE=1

export CCACHE_EXEC=/usr/bin/ccache
ccache -M 100G
source build/envsetup.sh;
export SKIP_ABI_CHECKS=true
lunch $PRODUCT_NAME-$VARIANT
$TARGET
exit 0;
