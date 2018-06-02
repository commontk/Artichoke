cmake_minimum_required(VERSION 2.8.7)

if(POLICY CMP0054)
  cmake_policy(SET CMP0054 OLD)
endif()

project(MarkAsSuperBuild-WithNotFoundVariable-Test NONE)

set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../../" ${CMAKE_MODULE_PATH})
set(EXTERNAL_PROJECT_DIR ${CMAKE_CURRENT_SOURCE_DIR}/TheExternals)
set(EXTERNAL_PROJECT_FILE_PREFIX "TheExternal_")
include(ExternalProject)
include(ExternalProjectDependency)

option(${PROJECT_NAME}_SUPERBUILD "Build ${PROJECT_NAME} and the projects it depends" ON)
mark_as_advanced(${PROJECT_NAME}_SUPERBUILD)

# Set variables needed for '*_CMAKE_ARGS' case
if(NOT CMAKE_CONFIGURATION_TYPES)
  set(CMAKE_CFG_INTDIR MyConfig)
  set(CMAKE_CONFIGURATION_TYPES ${CMAKE_CFG_INTDIR})
  set(EXPECTED_CMAKE_CFG_INTDIR ${CMAKE_CFG_INTDIR})
else()
  set(EXPECTED_CMAKE_CFG_INTDIR Release)
endif()

if(${PROJECT_NAME}_SUPERBUILD)
  set(VAR "VAR_VALUE")
  mark_as_superbuild(VAR)

  set(PROJECT_SPECIFIC_VAR "PROJECT_SPECIFIC_VAR_VALUE")
  mark_as_superbuild(
    VARS
      PROJECT_SPECIFIC_VAR:STRING
    PROJECTS ${PROJECT_NAME}
    )

  set(ALL_PROJECTS_VAR "ALL_PROJECTS_VAR_VALUE")
  mark_as_superbuild(
    VARS
      ALL_PROJECTS_VAR:STRING
    ALL_PROJECTS
    )
endif()

set(${PROJECT_NAME}_DEPENDS )

ExternalProject_Include_Dependencies(${PROJECT_NAME}
  EP_ARGS_VAR MYTEST_EP_ARGS_VAR
  )

include(${CMAKE_CURRENT_SOURCE_DIR}/../ArtichokeTestUtility.cmake)

check_variable_defined("${PROJECT_NAME}_SUPERBUILD")

if(${PROJECT_NAME}_SUPERBUILD)
  check_variable_defined("MYTEST_EP_ARGS_VAR")

  ExternalProject_Add(${PROJECT_NAME}
    ${MYTEST_EP_ARGS_VAR}
    DOWNLOAD_COMMAND ""
    CMAKE_CACHE_ARGS
      -D${PROJECT_NAME}_SUPERBUILD:BOOL=OFF
      -DCMAKE_CFG_INTDIR_FILE:FILEPATH=${CMAKE_CFG_INTDIR_FILE}
    SOURCE_DIR ${${PROJECT_NAME}_SOURCE_DIR}
    BINARY_DIR ${${PROJECT_NAME}_BINARY_DIR}/${PROJECT_NAME}-build
    BUILD_COMMAND ""
    INSTALL_COMMAND ""
    DEPENDS
      ${${PROJECT_NAME}_DEPENDS}
    )
  return()
endif()

check_variable_defined("VAR")
check_variable(VAR "VAR_VALUE")

check_variable_defined("PROJECT_SPECIFIC_VAR")
check_variable(PROJECT_SPECIFIC_VAR "PROJECT_SPECIFIC_VAR_VALUE")

check_variable_defined("ALL_PROJECTS_VAR")
check_variable(ALL_PROJECTS_VAR "ALL_PROJECTS_VAR_VALUE")

