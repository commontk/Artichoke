cmake_minimum_required(VERSION 2.8.7)

if(POLICY CMP0054 AND CMAKE_VERSION VERSION_LESS "4.0")
  cmake_policy(SET CMP0054 OLD)
endif()

project(ExternalProjectFileLookup-Test NONE)

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
  set(MAINPROJECT_INNER_BUILD_DIR ${${PROJECT_NAME}_BINARY_DIR}/${PROJECT_NAME}-build)
  mark_as_superbuild(
    VARS
      MAINPROJECT_INNER_BUILD_DIR
    ALL_PROJECTS
    )
endif()

set(${PROJECT_NAME}_DEPENDS LibA LibB)

ExternalProject_Add_Dependencies(${PROJECT_NAME} DEPENDS LibC)

ExternalProject_Include_Dependencies(${PROJECT_NAME} PROJECT_VAR PROJECT_NAME)

if(${PROJECT_NAME}_SUPERBUILD)
  ExternalProject_Add(${PROJECT_NAME}
    ${${PROJECT_NAME}_EP_ARGS}
    DOWNLOAD_COMMAND ""
    CMAKE_CACHE_ARGS
      -D${PROJECT_NAME}_SUPERBUILD:BOOL=OFF
      -DCMAKE_CFG_INTDIR_FILE:FILEPATH=${CMAKE_CFG_INTDIR_FILE}
    SOURCE_DIR ${${PROJECT_NAME}_SOURCE_DIR}
    BINARY_DIR ${MAINPROJECT_INNER_BUILD_DIR}
    BUILD_COMMAND ""
    INSTALL_COMMAND ""
    DEPENDS
      ${${PROJECT_NAME}_DEPENDS}
    )
  return()
endif()

include(${CMAKE_CURRENT_SOURCE_DIR}/../ArtichokeTestUtility.cmake)

# Check that each external project generate "<project_name>.txt" file.
foreach(p LibA LibB LibC LibD LibE LibF)
  if(NOT EXISTS ${MAINPROJECT_INNER_BUILD_DIR}/${p}.txt)
    message(FATAL_ERROR "Problem configuring ${p}: File '${MAINPROJECT_INNER_BUILD_DIR}/${p}.txt' do not exist!")
  endif()
endforeach()

