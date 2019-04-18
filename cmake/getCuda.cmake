# ----------------------------------------------------------------------------
# Cross compilation
# ----------------------------------------------------------------------------

if (CMAKE_CROSSCOMPILING)
  find_package(CUDA)
  # force usage of cross-compiled target libraries
  if(ANDROID)
    set (CUDA_TOOLKIT_TARGET_DIR ${CUDA_TOOLKIT_ROOT_DIR}/targets/${CMAKE_SYSTEM_PROCESSOR}-linux-androideabi)
    unset(CUDA_LIBRARIES)
    find_library(CUDA_LIBRARIES NAMES "cudart" PATHS ${CUDA_TOOLKIT_TARGET_DIR}/lib NO_DEFAULT_PATH)
    include_directories(${CUDA_TOOLKIT_TARGET_DIR}/include ${CUDA_TOOLKIT_ROOT_DIR}/samples/common/inc ${CUDA_TOOLKIT_ROOT_DIR}/extras/CUPTI/include)
  else(ANDROID)
    set (CUDA_TOOLKIT_TARGET_DIR ${CUDA_TOOLKIT_ROOT_DIR}/targets/${CUDA_TARGET})
    unset(CUDA_LIBRARIES)
    find_library(CUDA cuda PATHS ${CUDA_TOOLKIT_TARGET_DIR}/lib/stubs NO_DEFAULT_PATH NO_CMAKE_FIND_ROOT_PATH)
    find_library(CUDA_LIBRARIES NAMES "cudart" PATHS ${CUDA_TOOLKIT_TARGET_DIR}/lib NO_DEFAULT_PATH NO_CMAKE_FIND_ROOT_PATH)
    include_directories(${CUDA_TOOLKIT_TARGET_DIR}/include)
  endif(ANDROID)
else(CMAKE_CROSSCOMPILING)
  file(STRINGS "${CMAKE_SOURCE_DIR}/cuda.version" CUDA_VERSION)
  message(STATUS "CUDA VERSION: ${CUDA_VERSION}")
  set(CUDA_INSTALL "$ENV{CUDA_INSTALL}")
  if(WINDOWS)
    if(NOT CUDA_INSTALL)
      set(CUDA_INSTALL "C:/Program Files/NVIDIA GPU Computing Toolkit/CUDA")
    endif(NOT CUDA_INSTALL)
    set(CUDA_TOOLKIT_ROOT_DIR "${CUDA_INSTALL}/v${CUDA_VERSION}")
    set($ENV{PATH} "${CUDA_TOOLKIT_ROOT_DIR}/bin;${CUDA_TOOLKIT_ROOT_DIR}/libnvvp;$ENV{PATH}")
  endif(WINDOWS)
  if(LINUX)
    if(NOT CUDA_INSTALL)
      set(CUDA_INSTALL "/usr/local")
    endif(NOT CUDA_INSTALL)
    set(CUDA_TOOLKIT_ROOT_DIR "${CUDA_INSTALL}/cuda-${CUDA_VERSION}")
    set(LINUX_CUDA_PATH "${CUDA_TOOLKIT_ROOT_DIR}/lib64")
  endif(LINUX)
  if(APPLE)
    if(NOT CUDA_INSTALL)
      set(CUDA_INSTALL "/usr/local")
    endif(NOT CUDA_INSTALL)
    set(CUDA_TOOLKIT_ROOT_DIR "${CUDA_INSTALL}/cuda-${CUDA_VERSION}")
    if(NOT EXISTS "${CUDA_TOOLKIT_ROOT_DIR}")
      set(CUDA_TOOLKIT_ROOT_DIR "${CUDA_INSTALL}/cuda")
    endif(NOT EXISTS "${CUDA_TOOLKIT_ROOT_DIR}")
    set(MAC_CUDA_PATH "${CUDA_TOOLKIT_ROOT_DIR}/lib")
  endif(APPLE)
  message(STATUS "CUDA PATH: ${CUDA_TOOLKIT_ROOT_DIR}")
  find_package(CUDA EXACT "${CUDA_VERSION}")
  find_package(OpenGL REQUIRED)
endif(CMAKE_CROSSCOMPILING)
