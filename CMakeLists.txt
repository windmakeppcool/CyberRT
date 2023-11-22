cmake_minimum_required(VERSION 3.14.0)

project(cyber VERSION 8.0.0) # Apollo Version
# glob setting
set(CMAKE_SYSROOT "/usr/local/mdc_sdk_llvm/dp_gea/mdc_cross_compiler/sysroot")
set(BUILD_SYSROOT "/usr/local/mdc_sdk_llvm/dp_gea/mdc_cross_compiler/sysroot")

# Toolchain settings
set(C_COMPILER         $ENV{CC})
set(CXX_COMPILER       $ENV{CXX})
if (NOT DEFINED C_COMPILER)
    set(CMAKE_C_COMPILER clang)
    message(STATUS "Environment variable 'CC' is not set, using 'clang' as default")
endif()
if (NOT DEFINED CXX_COMPILER)
    set(CMAKE_CXX_COMPILER clang++)
    message(STATUS "Environment variable 'CXX' is not set, using 'clang++' as default")
endif()
# cpp 17
set(CMAKE_CXX_STANDARD 17)
set(TARGET_NAME ${PROJECT_NAME})
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Debug) # Debug/Release
endif()

# 开启汇编
enable_language(ASM)

# Project build settings if needed
SET(CMAKE_STRIP        llvm-strip)
add_compile_options(-O2)

set(ARCH "aarch64")
add_compile_definitions(__aarch64__) 

# third party
find_package(gflags REQUIRED)
# find_package(Python REQUIRED)
# find_package(Poco REQUIRED COMPONENTS Foundation)
# find_package(Protobuf REQUIRED)


# cyber croutine
if(ARCH STREQUAL "x86_64")
  set(CROUTINE_FILE "${CMAKE_CURRENT_SOURCE_DIR}/cyber/croutine/detail/swap_x86_64.S")
  message("### SYSTEM_PROCESSOR: ${ARCH} ${CROUTINE_FILE}")
else()
  set(CROUTINE_FILE "${CMAKE_CURRENT_SOURCE_DIR}/cyber/croutine/detail/swap_aarch64.S")
  message("### SYSTEM_PROCESSOR: ${ARCH} ${CROUTINE_FILE}")
endif()

# message
message(STATUS "gflags include path: ${GFLAGS_INCLUDE_DIR}")

# include
set(DEPENCENCY_INCLUDE_DIRS
)

include_directories(
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${DEPENCENCY_INCLUDE_DIRS}
)

# lib/lib64
set(DEPENCENCY_LIB_DIRS
)   
link_directories(${DEPENCENCY_LIB_DIRS})

# proto
file(GLOB CYBER_PROTO_FILES
    "${CMAKE_CURRENT_SOURCE_DIR}/modules/common_msgs/**/*.proto"
    "${CMAKE_CURRENT_SOURCE_DIR}/cyber/proto/*.proto"
    "${CMAKE_CURRENT_SOURCE_DIR}/cyber/examples/proto/*.proto"
)

set(CYBER_MSGS_CACHE ON CACHE BOOL "generate cyber proto msgs flag.")
set(PROTOBUF_PROTOC_EXECUTABLE /usr/local/bin/protoc)
if(${CYBER_MSGS_CACHE})
  set(CYBER_MSGS_CACHE OFF CACHE BOOL "generate cyber proto msgs flag." FORCE)
  FOREACH(FIL ${CYBER_PROTO_FILES})
    message("### generate proto file: ${FIL}")
    GET_FILENAME_COMPONENT(FIL_WE ${FIL} NAME_WE)
    string(REGEX REPLACE ".+/(.+)\\..*" "\\1" FILE_NAME ${FIL})
    string(REGEX REPLACE "(.+)\\${FILE_NAME}.*" "\\1" FILE_PATH ${FIL})
    EXECUTE_PROCESS(
        COMMAND
        ${PROTOBUF_PROTOC_EXECUTABLE}
        -I${CMAKE_CURRENT_SOURCE_DIR}
        --cpp_out=${CMAKE_CURRENT_SOURCE_DIR}
        ${FIL}
    )
  ENDFOREACH()
endif(${CYBER_MSGS_CACHE})

file(GLOB CYBER_PROTO_SRCS
    "${CMAKE_CURRENT_SOURCE_DIR}/cyber/proto/*.pb.cc"
    "${CMAKE_CURRENT_SOURCE_DIR}/cyber/proto/*.pb.h"
    "${CMAKE_CURRENT_SOURCE_DIR}/cyber/examples/proto/*.pb.cc"
    "${CMAKE_CURRENT_SOURCE_DIR}/cyber/examples/proto/*.pb.h"
    "${CMAKE_CURRENT_SOURCE_DIR}/modules/common_msgs/**/*.pb.cc"
    "${CMAKE_CURRENT_SOURCE_DIR}/modules/common_msgs/**/*.pb.h"
)

file(GLOB CYBER_SRCS
    "cyber/base/*.cc"
    "cyber/blocker/*.cc"
    "cyber/class_loader/*.cc"
    "cyber/class_loader/*/*.cc"
    "cyber/common/*.cc"
    "cyber/component/*.cc"
    "cyber/croutine/*.cc"
    "cyber/croutine/*/*.cc"
    "cyber/data/*.cc"
    "cyber/event/*.cc"
    "cyber/io/*.cc"
    "cyber/logger/*.cc"
    "cyber/message/*.cc"
    "cyber/node/*.cc"
    "cyber/parameter/*.cc"
    "cyber/record/*.cc"
    "cyber/record/*/*.cc"
    "cyber/scheduler/*.cc"
    "cyber/scheduler/*/*.cc"
    "cyber/service/*.cc"
    "cyber/service_discovery/*.cc"
    "cyber/service_discovery/*/*.cc"
    "cyber/task/*.cc"
    "cyber/time/*.cc"
    "cyber/timer/*.cc"
    "cyber/transport/*.cc"
    "cyber/transport/*/*.cc"
    "cyber/*.cc"
    "cyber/sysmo/*.cc"
    ${CROUTINE_FILE}
)

list(FILTER CYBER_SRCS EXCLUDE REGEX .*test[.]cc)

add_library(${TARGET_NAME} SHARED
    ${CYBER_PROTO_SRCS}
    ${CYBER_SRCS}
)

target_link_libraries(${TARGET_NAME}
    fastrtps
    fastcdr
    uuid
    protobuf
    glog
    gflags
)

add_subdirectory(cyber/mainboard)
add_subdirectory(cyber/examples)
# add_subdirectory(cyber/python)
add_subdirectory(cyber/tools)

# --------------------------------------------------------------
#                      CPack
# --------------------------------------------------------------
include(InstallRequiredSystemLibraries)
# set (CPACK_GENERATOR        "ZIP")
set (CPACK_GENERATOR        "TGZ;ZIP")
set (CPACK_SOURCE_GENERATOR "TGZ;ZIP")

set(CPACK_PACKAGE_ARCHITECTURE "aarch64")

set(CPACK_PACKAGE_NAME   "${TARGET_NAME}")
set(CPACK_PACKAGE_CONTACT "job@minhang.me")
set(CPACK_PACKAGE_VERSION "${PROJECT_VERSION}")
set(CPACK_PACKAGE_VERSION_MAJOR "${PROJECT_VERSION_MAJOR}")
set(CPACK_PACKAGE_VERSION_MINOR "${PROJECT_VERSION_MINOR}")
set(CPACK_PACKAGE_VERSION_PATCH "${PROJECT_VERSION_PATCH}")
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "Apollo CyberRT")
set(CPACK_INSTALL_PREFIX              "${CMAKE_INSTALL_PREFIX}")
set(CPACK_OUTPUT_FILE_PREFIX          "packages")
set(CPACK_PACKAGE_RELOCATABLE         TRUE)
set(CPACK_MONOLITHIC_INSTALL          TRUE)
set(CPACK_PACKAGING_INSTALL_PREFIX ${CMAKE_INSTALL_PREFIX})
set(CPACK_RPM_PACKAGE_GROUP "Development/Libraries")
set(CPACK_RPM_PACKAGE_LICENSE "MIT")
set(CPACK_DEBIAN_PACKAGE_HOMEPAGE "https://github.com/minhanghuang/CyberRT")
set(CPACK_PACKAGE_FILE_NAME   "lib${CPACK_PACKAGE_NAME}")
set(CPACK_PACKAGE_FILE_NAME   "${CPACK_PACKAGE_FILE_NAME}_${CPACK_PACKAGE_VERSION}_${CPACK_PACKAGE_ARCHITECTURE}")

message(STATUS "CPACK install: ${CMAKE_INSTALL_PREFIX}")
include(CPack)
# --------------------------------------------------------------
#                       package
# --------------------------------------------------------------
# cyber .h files
# install(DIRECTORY cyber/
#     DESTINATION include/cyber/
#     FILES_MATCHING
#     PATTERN "*.h"
# )

# apollo conf
file(COPY cyber/conf/
  DESTINATION ${CMAKE_BINARY_DIR}/share/conf/
)
install(DIRECTORY ${CMAKE_BINARY_DIR}/share/conf/
  DESTINATION share/conf/
)

# lib
install(FILES
    "${CMAKE_SYSROOT}/usr/lib/libglog.so"
    "${CMAKE_SYSROOT}/usr/lib/libglog.so.0"
    "${CMAKE_SYSROOT}/usr/lib/libglog.so.0.5.0"
    "${CMAKE_SYSROOT}/usr/lib/libfastcdr.so"
    "${CMAKE_SYSROOT}/usr/lib/libfastcdr.so.1"
    "${CMAKE_SYSROOT}/usr/lib/libfastcdr.so.1.0.7"
    "${CMAKE_SYSROOT}/usr/lib/libfastrtps.so"
    "${CMAKE_SYSROOT}/usr/lib/libfastrtps.so.1"
    "${CMAKE_SYSROOT}/usr/lib/libfastrtps.so.1.5.0"
    DESTINATION lib
)

configure_file("setup.sh.in" "/home/faw/codepath/setup.sh" @ONLY)
install(FILES 
    "/home/faw/codepath/setup.sh"
    DESTINATION .
)

message(STATUS "bin dir: ${CMAKE_BINARY_DIR}")
install(DIRECTORY
    "${CMAKE_BINARY_DIR}/bin/cyber/mainboard"
    "${CMAKE_BINARY_DIR}/bin/cyber/tools"
    DESTINATION bin)
install(TARGETS ${TARGET_NAME}
    EXPORT ${TARGET_NAME}
    ARCHIVE DESTINATION lib
    LIBRARY DESTINATION lib
    RUNTIME DESTINATION bin
)