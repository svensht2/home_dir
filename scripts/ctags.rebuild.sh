#!/bin/bash
ctags -R --c++-kinds=+p --fields=+iaS --extra=+q -f ${ANDROID_BUILD_TOP}/tags .
