#Kommando zum bauen: ros2 run micro_ros_setup build_firmware.sh $(pwd)/xemio_custom_toolchain.cmake $(pwd)/xemio_custom_colcon.meta

#zum sourcen der bash im microros_ws-Verzeichnis: 
#source install/local_setup.bash 
#source /opt/ros/humble/setup.bash

#project(MyProjectName LANGUAGES C CXX) #Eigene Ergänzung. Anscheinend wird dadurch C aktiviert... erzeugt aber Fehler...

set(CMAKE_SYSTEM_NAME Generic)	   			#okay, da Cross-Compiling
set(CMAKE_CROSSCOMPILING 1)				#okay, aktiviert Cross-Compiling-Modus
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)	#okay, Anweisung, dass static lib erstellt werden soll

message(STATUS "Verwende das Toolchain File von BittlT 0")

# SET HERE THE PATH TO YOUR C99 AND C++ COMPILERS
#set(CMAKE_C_COMPILER "/opt/tricore_494_linux/tricore_494_linux/bin/tricore-elf-gcc")
set(CMAKE_C_COMPILER "/opt/tricore_940_linux/tricore_940_linux/bin/tricore-elf-gcc")
#set(CMAKE_CXX_COMPILER "/opt/tricore_494_linux/tricore_494_linux/bin/tricore-elf-g++")

set(CMAKE_C_COMPILER_WORKS 1 CACHE INTERNAL "")	#hier wird C-Compiler-Funktionsüberprüfung deaktiviert. Möchte ich aber, da aktuell errors...
#set(CMAKE_CXX_COMPILER_WORKS 1 CACHE INTERNAL "")	#C++ Compiler wird nicht benötigt

# SET HERE YOUR BUILDING FLAGS
#ursprünglich von der micro-ROS Vorlage: set(FLAGS "-O2 -ffunction-sections -fdata-sections -fno-exceptions -mcpu=cortex-m3 -nostdlib -mthumb --param max-inline-insns-single=500 -DF_CPU=84000000L -D'RCUTILS_LOG_MIN_SEVERITY=RCUTILS_LOG_MIN_SEVERITY_NONE'" CACHE STRING "" FORCE)
#set(CMAKE_C_FLAGS_INIT "-std=c11 ${FLAGS} -DCLOCK_MONOTONIC=0 -D'__attribute__(x)='" CACHE STRING "" FORCE)

#von XEMIO
#set(FLAGS "-msmall-const=0 -Wall -Wextra -Wdiv-by-zero -Warray-bounds -Wcast-align -Wignored-qualifiers -Wformat -Wformat-security -mcpu=$(GNU_MCPU) -mversion-info -fno-common -fno-short-enums -fshort-double -fsingle-precision-constant -fstrict-volatile-bitfields -ffunction-sections -fdata-sections -std=c99 -g")

# Versuch1: best of Vorlage + XEMIO: 
#set(FLAGS "-nostdlib -DCLOCK_MONOTONIC=0 -D'__attribute__(x)=' -msmall-const=0 -Wall -Wextra -Wdiv-by-zero -Warray-bounds -Wcast-align -Wignored-qualifiers -Wformat -Wformat-security -mcpu=tc39xx -mversion-info -fno-common -fno-short-enums -fshort-double -fsingle-precision-constant -fstrict-volatile-bitfields -ffunction-sections -fdata-sections -std=c99 -g" CACHE STRING "" FORCE)

message(STATUS "Verwende das Toolchain File von BittlT  1")


#verwendet - Versuch2: jetzt nur wesentliches von XEMIO:
set(CMAKE_C_FLAGS "-msmall-const=0 -Wdiv-by-zero -Warray-bounds -Wcast-align -Wignored-qualifiers -Wformat -Wformat-security -mcpu=tc39xx -std=c99 -mversion-info -fno-common -fno-short-enums -fshort-double -fsingle-precision-constant -fstrict-volatile-bitfields -ffunction-sections -fdata-sections -g -DCLOCK_MONOTONIC=0" CACHE STRING "" FORCE)
#-Wall,  -Wextra und  entfernt, weil diese Flag automatisch von CMAke gesetzt wird. Doppelsetzung vermeiden
# alle Flags, die CMake noch zusätzlich setzt: -Wall -Wextra -Wpedantic -std=gnu99 -MD -MT

#Versuch 3: möglichst wenig Flags verwenden von Xemio:

#message(STATUS "Using toolchain file: BittlT 2")


#set(CMAKE_CXX_FLAGS_INIT "-std=c++11 ${FLAGS} -fno-rtti -DCLOCK_MONOTONIC=0 -D'__attribute__(x)='" CACHE STRING "" FORCE)

#set(__BIG_ENDIAN__ 0) ist HW-Architektur-Spezifisch und vermutlich nicht für TriCore ausgelegt
