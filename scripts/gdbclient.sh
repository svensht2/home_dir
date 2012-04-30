# Shell-script to simplify starting up GDBserver on the remote target and then GDB on the local host PC.
# This is an adaptation of the Google Android gdbclient function from the 
# "build/envsetup.sh" script to help debug Qualcomm Android/Linux Graphics software.
# For more info, see http://community.qualcomm.com/docs/DOC-8202#Starting_GDB_with_gdbclientsh
# Authors: Simion Venshtain (simionv@quicinc.com), Michael Offenbecher (michaelo@quicinc.com)
# Version 1.2

qc_gdbclient ()
{
   # If requesting help or if not enough arguments given, then display usage.
   if [ "$1" == "--help" -o $# -lt 2 ]; then
     echo "Usage: qc_gdbclient EXE(app_process) PORT APP_NAME [UseDDD]"
     return
   fi
   
    local OUT_ROOT=.;
    local OUT_SYMBOLS=${ANDROID_BUILD_TOP}/out/target/product/${TARGET_PRODUCT}/symbols;
    local OUT_SYMBOLS_SO=${OUT_SYMBOLS}/system/lib:${OUT_SYMBOLS}/system/lib/egl
#   local OUT_SYMBOLS_SO=${OUT_SYMBOLS}/system/lib:${OUT_SYMBOLS}/symbols/system/lib/egl:${OUT_SYMBOLS}/symbols/system/lib/hw
    local OUT_SYMBOLS_EXE=${OUT_SYMBOLS}/system/bin;
    local PREBUILTS=$(get_abs_build_var ANDROID_PREBUILTS);
    

   if [ -z "$OUT_ROOT" -o  -z "$PREBUILTS" ]; then
       echo "Unable to determine build system output dir."
   else
       # Assign the executable name
       local EXE="$1"
       # Assign the port
       local PORT="$2"

       # Initialize GDBserver and GDB client
       local SERVER="gdbserver"
       local CLIENT="arm-eabi-gdb"


       # Start ADB port forwarding
       echo "Setting up ADB port forwarding over TCP...."
       adb forward "tcp$PORT" "tcp$PORT"
       

       # Start GDBserver on the app's process
       local APP_PID
       local APP_NAME="$3"
       if [ -n "$APP_NAME" ] ; then
           # Kill previous debug server
           SERVER_PID=`pid $SERVER`
           if [ -n "$SERVER_PID" ]; then
               echo "Killing previous $SERVER..."
               adb shell kill -9 $SERVER_PID
           fi
           APP_PID=`pid $APP_NAME`
           if [ -z "$APP_PID" ]; then
                #echo "FAILED: make sure the app is running or the app name is correct"
                echo "App is not started yet, starting $APP_NAME now..."
                adb shell $SERVER tcp$PORT $APP_NAME &
                sleep 2
           else
                # App is running, so attach to its process:
                echo "server:$SERVER, port$PORT, pid:$APP_PID"
                echo "adb shell $SERVER tcp$PORT --attach $APP_PID &"
                adb shell $SERVER tcp$PORT --attach $APP_PID &
                sleep 2
           fi
       else
               echo ""
               echo "If you haven't done so already, do this first on the device:"
               echo "    $SERVER $PORT /system/bin/$EXE"
               echo " or"
               echo "    $SERVER $PORT --attach $APP_PID"
               echo ""
       fi


       # Create GDB command file:
       echo >|"$OUT_ROOT/gdbclient.cmds" "set solib-absolute-prefix $OUT_SYMBOLS"
       echo >>"$OUT_ROOT/gdbclient.cmds" "set solib-search-path $OUT_SYMBOLS_SO"
       echo >>"$OUT_ROOT/gdbclient.cmds" "target remote $PORT"
       echo >>"$OUT_ROOT/gdbclient.cmds" "shared"
       echo >>"$OUT_ROOT/gdbclient.cmds" ""

       local DDD
       # Check if UseDDD argument is set to "DDD"
       if [ "$4" == "DDD" ]; then
           DDD="ddd --debugger"
           echo "Starting DDD..."
       else
           echo "Starting GDB..."
       fi
       $DDD $CLIENT -x "$OUT_ROOT/gdbclient.cmds" "$OUT_SYMBOLS_EXE/$EXE"
   fi

}
