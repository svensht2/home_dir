#/bin/bash

if [ $# -ne 1 ]; then
    echo "usage: gen_t32.sh app_name"
    return
fi

echo "Using ${ANDROID_BUILD_TOP} android tree"

# get PID
PID=`pid $1`

if [ -z "$PID" ]; then
    echo "FAILED: make sure the app is running or the app name is correct"
    return
fi

# get adreno lib maps
adb shell "cat /proc/$PID/maps | grep adreno"
echo "data.load.elf ${ANROID_BUILD_TOP}\out\target\product\${TARGET_PRODUCT}/symbols/system/lib/"
