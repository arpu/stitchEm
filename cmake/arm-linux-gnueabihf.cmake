#
# CMake defines to cross-compile to ARM/Linux from https://github.com/Itseez/opencv/blob/master/platforms/linux/arm-gnueabi.toolchain.cmake
#
set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_VERSION 1)
set(CMAKE_SYSTEM_PROCESSOR aarch64)

set(GCC_COMPILER_VERSION "4.9" CACHE STRING "GCC Compiler version")
set(GNU_MACHINE "arm-linux-gnueabi" CACHE STRING "GNU compiler triple")
set(CUDA_TARGET "armv7-linux-gnueabihf")

set(FLOAT_ABI_SUFFIX "")
if (NOT SOFTFP)
  set(FLOAT_ABI_SUFFIX "hf")
endif()

find_program(CMAKE_C_COMPILER NAMES arm-linux-gnueabi${FLOAT_ABI_SUFFIX}-gcc-${GCC_COMPILER_VERSION})
find_program(CMAKE_CXX_COMPILER NAMES arm-linux-gnueabi${FLOAT_ABI_SUFFIX}-g++-${GCC_COMPILER_VERSION})
set(ARM_LINUX_SYSROOT /usr/arm-linux-gnueabi${FLOAT_ABI_SUFFIX} CACHE PATH "ARM cross compilation system root")

set(CMAKE_CXX_FLAGS           ""                    CACHE STRING "c++ flags")
set(CMAKE_C_FLAGS             ""                    CACHE STRING "c flags")
set(CMAKE_SHARED_LINKER_FLAGS ""                    CACHE STRING "shared linker flags")
set(CMAKE_MODULE_LINKER_FLAGS ""                    CACHE STRING "module linker flags")
set(CMAKE_EXE_LINKER_FLAGS    "-Wl,-z,nocopyreloc"  CACHE STRING "executable linker flags")

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -mthumb -fdata-sections -Wa,--noexecstack -fsigned-char -Wno-psabi -march=armv8-a")
set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS} -mthumb -fdata-sections -Wa,--noexecstack -fsigned-char -Wno-psabi -march=armv8-a")

#for Jetson TX1, only static libraries are available and linking fails for shared libraries
#set(CMAKE_SHARED_LINKER_FLAGS "-Wl,--fix-cortex-a8 -Wl,--no-undefined -Wl,--gc-sections -Wl,-z,noexecstack -Wl,-z,relro -Wl,-z,now ${CMAKE_SHARED_LINKER_FLAGS}")
set(CMAKE_SHARED_LINKER_FLAGS "-Wl,--fix-cortex-a8                    -Wl,--gc-sections -Wl,-z,noexecstack -Wl,-z,relro -Wl,-z,now ${CMAKE_SHARED_LINKER_FLAGS}")
set(CMAKE_MODULE_LINKER_FLAGS "-Wl,--fix-cortex-a8 -Wl,--no-undefined -Wl,--gc-sections -Wl,-z,noexecstack -Wl,-z,relro -Wl,-z,now ${CMAKE_MODULE_LINKER_FLAGS}")
set(CMAKE_EXE_LINKER_FLAGS    "-Wl,--fix-cortex-a8 -Wl,--no-undefined -Wl,--gc-sections -Wl,-z,noexecstack -Wl,-z,relro -Wl,-z,now ${CMAKE_EXE_LINKER_FLAGS}")

if(USE_NEON)
  message(WARNING "You use obsolete variable USE_NEON to enable NEON instruction set. Use -DENABLE_NEON=ON instead." )
  set(ENABLE_NEON TRUE)
elseif(USE_VFPV3)
  message(WARNING "You use obsolete variable USE_VFPV3 to enable VFPV3 instruction set. Use -DENABLE_VFPV3=ON instead." )
  set(ENABLE_VFPV3 TRUE)
endif()

set(CMAKE_FIND_ROOT_PATH ${CMAKE_FIND_ROOT_PATH} ${ARM_LINUX_SYSROOT})

if(EXISTS ${CUDA_TOOLKIT_ROOT_DIR})
    set(CMAKE_FIND_ROOT_PATH ${CMAKE_FIND_ROOT_PATH} ${CUDA_TOOLKIT_ROOT_DIR})
endif()

set( CMAKE_SKIP_RPATH TRUE CACHE BOOL "If set, runtime paths are not added when using shared libraries." )
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM ONLY)

set( CMAKE_C_SIZEOF_DATA_PTR 8 FORCE CACHE STRING "size of data pointer")
set( CMAKE_CXX_SIZEOF_DATA_PTR ${CMAKE_C_SIZEOF_DATA_PTR} CACHE FORCE STRING "size of data pointer")

# macro to find programs on the host OS
macro( find_host_program )
 set( CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER )
 set( CMAKE_FIND_ROOT_PATH_MODE_LIBRARY NEVER )
 set( CMAKE_FIND_ROOT_PATH_MODE_INCLUDE NEVER )
 if( CMAKE_HOST_WIN32 )
  SET( WIN32 1 )
  SET( UNIX )
 elseif( CMAKE_HOST_APPLE )
  SET( APPLE 1 )
  SET( UNIX )
 endif()
 find_program( ${ARGN} )
 SET( WIN32 )
 SET( APPLE )
 SET( UNIX 1 )
 set( CMAKE_FIND_ROOT_PATH_MODE_PROGRAM ONLY )
 set( CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY )
 set( CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY )
endmacro()

# macro to find packages on the host OS
macro( find_host_package )
 set( CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER )
 set( CMAKE_FIND_ROOT_PATH_MODE_LIBRARY NEVER )
 set( CMAKE_FIND_ROOT_PATH_MODE_INCLUDE NEVER )
 if( CMAKE_HOST_WIN32 )
  SET( WIN32 1 )
  SET( UNIX )
 elseif( CMAKE_HOST_APPLE )
  SET( APPLE 1 )
  SET( UNIX )
 endif()
 find_package( ${ARGN} )
 SET( WIN32 )
 SET( APPLE )
 SET( UNIX 1 )
 set( CMAKE_FIND_ROOT_PATH_MODE_PROGRAM ONLY )
 set( CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY )
 set( CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY )
endmacro()

