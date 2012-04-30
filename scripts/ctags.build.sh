#!/bin/bash
find ${CURRENT_QPROJECT} -path ./out/ -prune -o \( -name "*.c" -o -name "*.h" -o -name "*.cpp" -o -name "*.java" -o -name "*.mk" \) -print > ctags.files
ctags -L ctags.files --c++-kinds=+p --fields=+iaS --extra=+q -f ${CURRENT_QPROJQCT}/tags
