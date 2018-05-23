
set(CTEST_PROJECT_NAME Transposer)
set(CTEST_CONFIGURATION_TYPE Release)

if (PLATFORM MATCHES osx)
  set(ARGS
    -DRUN=EXE
  )
endif()

include("$ENV{CROSS_PATH}/core/cmake/platforms.cmake")
