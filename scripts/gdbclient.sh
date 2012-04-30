gdbclient ()
{
    local OUT_ROOT=.;
    local OUT_SYMBOLS=${ANDROID_BUILD_TOP}/out/target/product/${TARGET_PRODUCT}/symbols;
    local OUT_SO_SYMBOLS=${ANDROID_BUILD_TOP}/out/target/product/${TARGET_PRODUCT}/symbols/system/lib:${ANDROID_BUILD_TOP}/out/target/product/${TARGET_PRODUCT}/symbols/system/lib/egl:${ANDROID_BUILD_TOP}/out/target/product/${TARGET_PRODUCT}/symbols/system/lib/hw
    local OUT_EXE_SYMBOLS=${ANDROID_BUILD_TOP}/out/target/product/${TARGET_PRODUCT}/symbols/system/bin;
    local PREBUILTS=$(get_abs_build_var ANDROID_PREBUILTS);
   if [ "$1" == "--help" ]; then
     echo "usage gdbclient EXE(app_process) PORT APP_NAME ARMv7:1/0 DDD:1/0"
     return
   fi
   if [ $# -ne 2 ]; then
     echo "usage gdbclient EXE(app_process) PORT APP [ARMv7:1/0] [DDD:1/0]"
     return
   fi
   if [ "$OUT_ROOT" -a "$PREBUILTS" ]; then

       # Assign executable name
       local EXE="$1"
       # Assign a port
       local PORT="$2"

       local PID
       local PROG="$3"
       # Select debugger server/client armv7 support or not
       local SERVER="gdbserver"
       local CLIENT="arm-eabi-gdb"
       # Check if ARMv7 argument is set to 1
       if [ "$4" -eq 1 ]; then
           SERVER="gdbserver-armv7"
           CLIENT="gdb-armv7"
       fi
       local DDD
       # Check if DDD argument is set to 1
       if [ "$5" == "1" ]; then
           DDD="ddd --debugger"
       fi
       
       adb forward "tcp$PORT" "tcp$PORT"
       # Start adb forwarding and spawn gdb server on app
       if [ "$PROG" ] ; then
           # Kill previous debug server
           SERVER_PID=`pid $SERVER`
           if [ -n "$SERVER_PID" ]; then
               adb shell kill -9 $SERVER_PID
           fi
           APP_PID=`pid $PROG`
           if [ -z "$APP_PID" ]; then
            echo "FAILED: make sure the app is running or the app name is correct"
            return
           fi
           echo "server:$SERVER port$PORT pid:$APP_PID"
           echo "adb shell gdbserver tcp$PORT --attach $APP_PID &"
           adb shell gdbserver tcp$PORT --attach $APP_PID &
           sleep 2
       else
               echo ""
               echo "If you haven't done so already, do this first on the device:"
               echo "    gdbserver $PORT /system/bin/$EXE"
                   echo " or"
               echo "    gdbserver $PORT --attach $APP_PID"
               echo ""
       fi

       echo >|"$OUT_ROOT/gdbclient.cmds" "set solib-absolute-prefix $OUT_SYMBOLS"
       echo >>"$OUT_ROOT/gdbclient.cmds" "set solib-search-path $OUT_SO_SYMBOLS"
       echo >>"$OUT_ROOT/gdbclient.cmds" "target remote $PORT"
       echo >>"$OUT_ROOT/gdbclient.cmds" "shared"
       echo >>"$OUT_ROOT/gdbclient.cmds" ""

       $DDD $CLIENT -x "$OUT_ROOT/gdbclient.cmds" "$OUT_EXE_SYMBOLS/$EXE"
  else
       echo "Unable to determine build system output dir."
   fi

}
