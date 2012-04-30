#!/bin/bash

GFX_DIR=vendor/qcom/proprietary/gles/adreno200

rm -f ${GFX_DIR}/Android.mk
rm -rf ${GFX_DIR}/s3d
rm -f ${GFX_DIR}/os/user/src/linux/os_lib.c
rm -rf vendor/qcom/proprietary/QualcommSettings/
rm -f device/qcom/msm8660_surf/BoardConfig.mk
rm -f device/qcom/msm8660_surf/egl-s3d.cfg
rm -f ${GFX_DIR}/egl14/src/linux/eglLinux.c
svn co --force svn://simionv-linux/local/mnt/workspace/simionv/s3d_repo .
