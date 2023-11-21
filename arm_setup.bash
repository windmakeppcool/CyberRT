export CC=/usr/local/mdc_sdk_llvm/dp_gea/mdc_cross_compiler/bin/clang
export CXX=/usr/local/mdc_sdk_llvm/dp_gea/mdc_cross_compiler/bin/clang++
export SYSROOT=/usr/local/mdc_sdk_llvm/dp_gea/mdc_cross_compiler/sysroot
export CMAKE_INCLUDE_PATH=${SYSROOT}/usr/include
export PATH=/usr/local/mdc_sdk_llvm/dp_gea/mdc_cross_compiler/bin:$PATH
export CMAKE_PREFIX_PATH=${SYSROOT}/usr/lib/cmake:${SYSROOT}/usr/share:${SYSROOT}/usr/lib64/cmake
export CMAKE_LIBRARY_PATH=${SYSROOT}/usr/lib64:${SYSROOT}/usr/lib
