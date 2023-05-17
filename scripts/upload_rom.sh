#!/bin/bash

cd ~
cd $ROM_NAME
cd out/target/product/$CODENAME;
curl -T $OUTPUT temp.sh
exit 0;
