#!/bin/bash
find ${CURRENT_QPROJECT} -path ./out/ -prune -o \( -name "*.c" -o -name "*.h" -o -name "*.cpp" -o -name "*.java" \) -print > cscope.files
cscope -b -q -k -f ${CURRENT_QPROJECT}/cscope.out
