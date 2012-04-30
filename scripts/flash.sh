flash_modem()
{
    MODEM_PATH=/mnt/modem/modem_proc/build/ms/bin
    echo "using ${ANDROID_BUILD_TOP} as root"
    fastboot flash sbl1 ${MODEM_PATH}/AAABQNBG/sbl1.mbn
    fastboot flash sbl2 ${MODEM_PATH}/AAABQNBG/sbl2.mbn
    fastboot flash sbl3 ${MODEM_PATH}/AAABQNBG/sbl3.mbn
    fastboot flash rpm ${MODEM_PATH}/AAABQNBG/rpm.mbn
    fastboot flash tz ${MODEM_PATH}/AAABQNBG/tz.mbn
    fastboot flash modem ${MODEM_PATH}/PIL_IMAGES/MSM_FATIMAGE_AAABQNLG/NON-HLOS.bin
    fastboot flash aboot ${ANDROID_BUILD_TOP}/out/target/product/${TARGET_PRODUCT}/emmc_appsboot.mbn
}

flash_app()
{
    echo "using ${ANDROID_BUILD_TOP} as root"
    fastboot flash system ${ANDROID_BUILD_TOP}/out/target/product/${TARGET_PRODUCT}/system.img.ext4
    fastboot flash userdata ${ANDROID_BUILD_TOP}/out/target/product/${TARGET_PRODUCT}/userdata.img.ext4
    fastboot flash boot ${ANDROID_BUILD_TOP}/out/target/product/${TARGET_PRODUCT}/boot.img
    fastboot flash persist ${ANDROID_BUILD_TOP}/out/target/product/${TARGET_PRODUCT}/persist.img.ext4
}
flashall()
{
    flash_modem
    flash_app
}
