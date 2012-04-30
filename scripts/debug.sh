#/bin/bash

addr2line ()
{
    if [ $# -ne 2 ]
    then
        echo "Usage addr2line LIB ADDR"
        return
    fi
    arm-eabi-addr2line -f -e  ${ANDROID_BUILD_TOP}/out/target/product/${TARGET_PRODUCT}/obj/SHARED_LIBRARIES/${1}_intermediates/LINKED/${1}.so $2

}
