#/bin/bash

if [ -z  "$CURRENT_PROJECT" ]; then
    echo "YOU DID SOMETHING BAD, YOUR CURRENT_PROJECT IS NOT DEFINED!!!!"
    exit
fi

# check if the project is to big to be rebuild every edit
if [ "${PROJECT_TAG_REBUILD}" == "0" ]; then
    exit
fi

USER_PARAMS=$1
DIR=${CURRENT_PROJECT}
FILES=${DIR}/cscope.files

#if [ ! -e "$FILES" ]; then
    find ${DIR} -path ./out/ -prune -o \( -name "*.c" -o -name "*.h" -o -name "*.cpp" -o -name "*.java" \) -print >  $FILES
#fi

# build cscope database for refernce lookup
#echo "Creating CSCOPE DB"
cscope ${USER_PARAMS} -i $FILES -b -k -f ${DIR}/cscope.out 1>>/dev/null 2>>/dev/null
cscope -i $FILES -b -k -f ${DIR}/cscope.out 1>>/dev/null 2>>/dev/null
# build ctags database for autocomplete
#echo "Creating CTAGS DB"
ctags -L $FILES --c++-kinds=+p --fields=+iaS --extra=+q -f ${DIR}/tags 1>>/dev/null 2>>/dev/null &

