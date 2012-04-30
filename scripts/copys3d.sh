#!/bin/bash

LIBDIR=${ANDROID_BUILD_TOP}/out/target/product/msm8660_surf/system/lib/
echo "using ${ANDROID_BUILD_TOP} as top"
adb shell mount -o remount,rw /dev/block/mmcblk0p12 /system
adb push ${LIBDIR}/egl/libGLESv1_CM_s3d.so /system/lib/egl

adb shell stop 
adb shell start

