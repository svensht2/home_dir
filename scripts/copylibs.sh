#!/bin/bash

echo "using ${ANDROID_BUILD_TOP} as top, on platform $TARGET_PRODUCT"
adb remount
#adb push $OUT/system/lib/egl/egl.cfg /system/lib/egl
#adb push $OUT/system/lib/egl/libEGL_adreno200.so /system/lib/egl
adb push $OUT/system/lib/egl/libGLESv2_adreno200.so /system/lib/egl
#adb push $OUT/system/lib/egl/libGLESv1_CM_adreno200.so /system/lib/egl
#adb push $OUT/system/lib/egl/libq3dtools_adreno200.so /system/lib/egl
#adb push $OUT/system/lib/egl/eglsubAndroid.so /system/lib/egl
#adb push $OUT/system/lib/libgsl.so /system/lib/
#adb push $OUT/system/lib/libC2D2.so /system/lib/
#adb push $OUT/system/lib/libOpenVG.so /system/lib/
#adb push $OUT/system/lib/libsc-a2xx.so /system/lib/
#adb push $OUT/system/etc/firmware/a225p5_pm4.fw /system/etc/firmware
#adb push $OUT/system/etc/firmware/a225_pfp.fw  /system/etc/firmware
#adb push $OUT/system/etc/firmware/a225_pm4.fw  /system/etc/firmware
#adb push $OUT/system/etc/firmware/leia_pfp_470.fw  /system/etc/firmware
#adb push $OUT/system/etc/firmware/leia_pm4_470.fw  /system/etc/firmware
#adb shell stop
#adb shell start

