
project_setup_no_update()
{
    export PROJECT_TAG_REBUILD="0";
    project_setup $1 -q
}

project_setup_update()
{
    export PROJECT_TAG_REBUILD="1";
    project_setup $1
}

project_setup()
{
    local DIR
    local TEMP
    if [ -z "$1" ]; then
        DIR=`pwd`
    else
        DIR=$1
    fi
	export CSCOPE_DB=${DIR}/cscope.out
    export CURRENT_PROJECT=$DIR
    if [ ! -e ${DIR}/cscope.out ]; then
        TEMP=${PROJECT_TAG_REBUILD}
        export PROJECT_TAG_REBUILD="1"
        build_tags.sh $2
        export PROJECT_TAG_REBUILD=$TEMP
    fi
}

android_setup()
{
	# Setup project specific cscope database
	. build/envsetup.sh
	choosecombo 1 1 msm8660_surf 3
    project_setup_no_update ${ANDROID_BUILD_TOP}
}

adreno_work()
{
    local DIR=${ANDROID_BUILD_TOP}/vendor/qcom/proprietary/gles/adreno200
	# Setup project specific cscope database
    cd $DIR
    project_setup_update $DIR
}

android_work()
{
    local DIR=${ANDROID_BUILD_TOP}
    project_setup_no_update $DIR
}
