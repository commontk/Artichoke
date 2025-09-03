cmake_minimum_required(VERSION 2.8.7)

if(POLICY CMP0054 AND CMAKE_VERSION VERSION_LESS "4.0")
  cmake_policy(SET CMP0054 OLD)
endif()

# To ensure "ArtichokeTestUtility.cmake" is included when processing
# this script in either the project or script mode (see custom target
# added below), use "CMAKE_CURRENT_LIST_DIR".
include(${CMAKE_CURRENT_LIST_DIR}/../../ArtichokeTestUtility.cmake)

check_variable_defined("CMAKE_GENERATOR")
check_variable_defined("EXPECTED_PARALLEL_LEVEL")
check_variable_defined("TEST_JOB_SERVER_AWARE_STEP")

#-----------------------------------------------------------------------------
if(DEFINED CHECK_MAKEFLAGS_ENVVAR)
  message(STATUS "Building target ${PROJECT_NAME}")
  message(STATUS "  CMAKE_GENERATOR: ${CMAKE_GENERATOR}")
  message(STATUS "  TEST_JOB_SERVER_AWARE_STEP: ${TEST_JOB_SERVER_AWARE_STEP}")
  message(STATUS "  ENV{MAKEFLAGS}: $ENV{MAKEFLAGS}")
  if(TEST_JOB_SERVER_AWARE_STEP STREQUAL "BUILD" AND CMAKE_GENERATOR STREQUAL "Unix Makefiles")
    if(NOT "$ENV{MAKEFLAGS}" MATCHES "-j${EXPECTED_PARALLEL_LEVEL}")
      message(FATAL_ERROR "MAKEFLAGS environment variable expected to include -j${EXPECTED_PARALLEL_LEVEL}. MAKEFLAGS value is [$ENV{MAKEFLAGS}]")
    endif()
  endif()
  return()
endif()

#-----------------------------------------------------------------------------
get_filename_component(_project_name ${CMAKE_BINARY_DIR} NAME_WE)
string(REPLACE "-build" "" _project_name ${_project_name})

project(${_project_name} NONE)
message(STATUS "Configuring project ${PROJECT_NAME}")
message(STATUS "  CMAKE_GENERATOR: ${CMAKE_GENERATOR}")

set(custom_target_common_args
  -DCHECK_MAKEFLAGS_ENVVAR:STRING=custom1
  -DCMAKE_GENERATOR:STRING=${CMAKE_GENERATOR}
  -DEXPECTED_PARALLEL_LEVEL:STRING=${EXPECTED_PARALLEL_LEVEL}
  -DTEST_JOB_SERVER_AWARE_STEP:STRING=${TEST_JOB_SERVER_AWARE_STEP}
  )

add_custom_target(custom1 ALL
  COMMAND ${CMAKE_COMMAND}
    ${custom_target_common_args}
    -P ${CMAKE_CURRENT_LIST_FILE}
  VERBATIM
)
add_custom_target(custom2 ALL
  COMMAND ${CMAKE_COMMAND}
    ${custom_target_common_args}
    -P ${CMAKE_CURRENT_LIST_FILE}
  VERBATIM
)
install(CODE "")
