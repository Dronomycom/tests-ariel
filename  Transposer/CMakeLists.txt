cmake_minimum_required (VERSION 3.2.2)

project(Transposer)

set(BOOST_ROOT "$ENV{CROSS_PATH}/tree/boost/${PLATFORM}")
set(EXIV2_ROOT "$ENV{EXIV2_PATH}")

set(INCLUDE_DIRS
  "${BOOST_ROOT}/include"
  "${EXIV2_ROOT}/macosx/include"
)

set(LIBRARIES
  "${BOOST_ROOT}/lib/libboost_system.a"
  "${BOOST_ROOT}/lib/libboost_filesystem.a"
  "${EXIV2_ROOT}/macosx/lib/libxmp.a"
  "${EXIV2_ROOT}/macosx/lib/libexiv2.dylib"
)

set(SRC_FILES
  src/main.cpp
  src/Image.cpp
  src/GeoConv.cpp
)

include("$ENV{CROSS_PATH}/core/cmake/test.cmake")
