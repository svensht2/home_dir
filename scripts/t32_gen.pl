#!/usr/bin/perl
###############################################################################
# Creator: Simion Venstain
# Descirption: This script will generate a cmm script for trace32 android
#              userspace and kernel debugging
#
#
# Date: 06/30/11
###############################################################################




use strict;
use warnings;
use Env qw(ANDROID_BUILD_TOP TARGET_PRODUCT);

my $app_pid;

my @app_maps;
my $app_map;
# store the libs aready processed to prevent duplicates
my @libs;

if ( $#ARGV < 0) {
    print "usage: gen_t32.sh pid\n";
    exit;
} else {
    $app_pid = $ARGV[0];
}


# Check for app existance
if ($app_pid eq "") {
    print "FAILED: make sure the app is running or the app name is correct\n";
    exit;
}


open (FILE, "> ${ANDROID_BUILD_TOP}/debug_script.cmm") or die $!;

# Print a bunch of common init stuff

print FILE ";; Declare local variables\n";
print FILE "ENTRY &AndroidRoot\n";

print FILE "local &kernelPath\n";
print FILE "local &T32Path\n";

print FILE ";; Break if already running\n";
print FILE "if run()\n";
print FILE "(\n";
print FILE "    break\n";
print FILE ")\n";

print FILE ";; Setup Windows\n";
print FILE "  winclear\n";
print FILE "  ; Display code listing\n";
print FILE "  WINPOS 0.0 0.0 68% 65% 12. 1. W000\n";
print FILE "  DATA.list\n";
print FILE "\n";
print FILE "  ; Display register window\n";
print FILE "  WINPOS 68% 0. 32% 50% 0. 0. W002\n";
print FILE "  register /spotlight\n";
print FILE "\n";
print FILE "  ; Display variables in HEX and with symbol names\n";
print FILE "  setup.var %open.on %hex\n";
print FILE "\n";
print FILE "  ; Display stackframe with local variables\n";
print FILE "  WINPOS  68% 50% 32% 48% 0. 0. W003\n";
print FILE "  Var.Frame /Locals /Caller\n";
print FILE "\n";
print FILE ";; Setup window area to display messages when setting this up\n";
print FILE "WINPOS 0% 65% 34% 35% 0. 0. W001\n";
print FILE "Area.create MAIN\n";
print FILE "Area.clear MAIN\n";
print FILE "Area.view MAIN\n";
print FILE "Area.select MAIN\n";
print FILE "\n";
print FILE "print \"   _   _  _ ___  ___  ___ ___ ___  \"\n";
print FILE "print \"  /_\ | \| |   \| _ \/ _ \_ _|   \ \"\n";
print FILE "print \" / _ \| .` | |) |   / (_) | || |) |\"\n";
print FILE "print \"/_/ \_\_|\_|___/|_|_\\___/___|___/ \"\n";
print FILE "print \" \"\n";
print FILE "print \"ANDROID root directory: &AndroidRoot\"\n";
print FILE "\n";
print FILE "&kernelPath=\"&AndroidRoot/kernel\"\n";
print FILE "&T32LinuxScriptPath=\"c:/T32/demo/arm/kernel/linux\"\n";
print FILE "\n";
print FILE "; Generic start-up\n";
print FILE "Break.Delete        ; remove any breakpoints\n";
print FILE "MAP.RESet       ; reset debuggers memory mapping\n";
print FILE "MMU.RESet       ; reset debuggers MMU\n";
print FILE "sYmbol.RESet        ; remove any symbols\n";
print FILE "\n";
print FILE "; Linux start-up\n";
print FILE "TrOnchip.Set DABORT OFF     ; turn off breakpoint on data abort\n";
print FILE "TrOnchip.Set PABORT OFF     ; turn off breakpoint on program abort\n";
print FILE "TrOnchip.Set UNDEF OFF      ; turn off breakpoint on undefined instruction\n";
print FILE "SYStem.Option MMUSPACES ON  ; enable space ids to virtual addresses\n";
print FILE "\n";
print FILE "print \"Loading Linux kernel symbols...\"\n";
print FILE "data.load.elf \"&AndroidRoot/out/target/product/${TARGET_PRODUCT}/obj/KERNEL_OBJ/vmlinux\" /nocode /gnu\n";
print FILE "\n";
print FILE "; Declare the MMU format to the debugger\n";
print FILE " ; - table format is \"LINUX\"\n";
print FILE " ; - table base address is at label \"swapper_pg_dir\"\n";
print FILE " ; - kernel address translation\n";
print FILE " ; Map the virtual kernel symbols to physical addresses to give\n";
print FILE " ; the debugger access to it before CPU MMU is initialized\n";
print FILE "\n";
print FILE "MMU.RESET\n";
print FILE "MMU.FORMAT LINUX swapper_pg_dir 0xC0000000--0xffffffff 0x20000000\n";
print FILE "MMU.COMMON 0xC00000000--0xCFFFFFFF\n";
print FILE "MMU.AUTOSCAN ON\n";
print FILE "MMU.TABLEWALK ON\n";
print FILE "MMU.ON\n";
print FILE "\n";
print FILE "\n";
print FILE "; Configure Trace32 for Linux debugging\n";
print FILE "TASK.CONFIG \"&T32LinuxScriptPath/linux.t32\"     ; Load Linux awareness\n";
print FILE "MENU.ReProgram \"&T32LinuxScriptPath/linux.men\"      ; Load Linux menu\n";
print FILE "HELP.FILTER.Add rtoslinux               ; Add linux awareness manual to help filter\n";
print FILE "\n";
print FILE "TASK.sYmbol.Option MMUSCAN OFF              ; not necessary with table walk\n";
print FILE "\n";
print FILE "sYmbol.AutoLoad.CHECKLINUX \"do &LinuxT32ScriptPath/autoload \"   ; Switch on symbol autoloader\n";
print FILE "\n";
print FILE "GROUP.Create \"kernel\" 0xC00000000--0xFFFFFFFFF /RED\n";
print FILE "\n";
print FILE "\n";
print FILE "; Configure Autoloader to automatically load symbols for process debugging\n";
print FILE "Task.SYMBOL.Option Autoload Process\n";
print FILE "\n";
print FILE "; Display Linux processes\n";
print FILE "WINPOS  34% 65% 34% 35% 0. 0. W003\n";
print FILE "task.dtask\n";
print FILE "mode.hll\n";
print FILE "\n";
print FILE ";; Setup break points in linux kernel to ease debugging\n";
print FILE "b.s \\\\vmlinux\\panic\\panic\n";
print FILE "\n";
print FILE "&symbolPath=\"&AndroidRoot/out/target/product/${TARGET_PRODUCT}/symbols/system/lib\"\n";

@app_maps = split('\n',`adb shell cat /proc/$app_pid/maps`);

print FILE ";; Load libraries\n";
print FILE "print \"Loading Android library symbols...\"\n";

foreach $app_map (@app_maps) {
    chomp($app_map);
	if ($app_map =~ m/^(\S+)-\S+ \S+ \S+ \S+ \d+        \/system\/lib\/(\S+)/) {
        my $lib_path = $2;
        my $lib_addr = $1;
        my $lib_name;
        my $lib_exists = 0;
        foreach $lib_name (@libs) {
            if ( $lib_name eq $lib_path ){
                $lib_exists = 1;
                last;
            }
        }
        if (!$lib_exists) {
		    print FILE "data.load.elf &symbolPath/${lib_path} 0x${lib_addr} /gnu /nocode /noclear\n";
            push(@libs, ${lib_path});
        }
	}
}

print FILE ";Source Paths for libraries\n";
print FILE "print \"Adding default source paths...\"\n";
print FILE "y.spath.srd \"&AndroidRoot/kernel\"\n";
print FILE "y.spath.srd \"&AndroidRoot/hardware/msm7k\"\n";
print FILE "y.spath.srd \"&AndroidRoot/frameworks/base\"\n";
print FILE "y.spath.srd \"&AndroidRoot/system/core\"\n";
print FILE "y.spath.srd \"&AndroidRoot/vendor/qcom/proprietary/gles/adreno200\"\n";
print FILE "\n";
print FILE "print \"Done.\"\n";
print FILE "END\n";

close(FILE);

exit 0;

