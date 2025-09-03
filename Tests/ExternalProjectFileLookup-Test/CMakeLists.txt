cmake_minimum_required(VERSION 2.8.7)

if(POLICY CMP0054 AND CMAKE_VERSION VERSION_LESS "4.0")
  cmake_policy(SET CMP0054 OLD)
endif()

project(ExternalProjectFileLookup-Test NONE)

set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../../" ${CMAKE_MODULE_PATH})
set(EXTERNAL_PROJECT_DIR ${CMAKE_CURRENT_SOURCE_DIR}/TheExternals)
set(EXTERNAL_PROJECT_ADDITIONAL_DIR ${CMAKE_CURRENT_SOURCE_DIR}/TheAdditionalExternals)
set(EXTERNAL_PROJECT_ADDITIONAL_DIRS
  ${CMAKE_CURRENT_SOURCE_DIR}/TheAdditionalExternals1
  ${CMAKE_CURRENT_SOURCE_DIR}/TheAdditionalExternals2
  )
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
  set(MAIN_PROJECT_VAR "MainProject")
  mark_as_superbuild(MAIN_PROJECT_VAR)

  foreach(lib LibA LibB LibC LibD LibE LibF LibG LibH)
    set(${lib}_VAR ${lib})
    mark_as_superbuild(VARS ${lib}_VAR PROJECTS ${lib})
  endforeach()
endif()

set(${PROJECT_NAME}_DEPENDS LibG LibD)

ExternalProject_Include_Dependencies(${PROJECT_NAME} PROJECT_VAR PROJECT_NAME)

if(${PROJECT_NAME}_SUPERBUILD)
  ExternalProject_Add(${PROJECT_NAME}
    ${${PROJECT_NAME}_EP_ARGS}
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

include(${CMAKE_CURRENT_SOURCE_DIR}/../ArtichokeTestUtility.cmake)

check_variable(MAIN_PROJECT_VAR "MainProject")
