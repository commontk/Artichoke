cmake_minimum_required(VERSION 2.8.7)

if(POLICY CMP0054 AND CMAKE_VERSION VERSION_LESS "4.0")
  cmake_policy(SET CMP0054 OLD)
endif()

get_filename_component(_project_name ${CMAKE_BINARY_DIR} NAME_WE)
string(REPLACE "-build" "" _project_name ${_project_name})

project(${_project_name} NONE)
message(STATUS "Configuring project ${PROJECT_NAME}")

include(${CMAKE_CURRENT_SOURCE_DIR}/../../ArtichokeTestUtility.cmake)

if(PROJECT_NAME STREQUAL "LibA")
  check_variable(LibA_VAR "LibA")

elseif(PROJECT_NAME STREQUAL "LibB")
  check_variable(LibB_VAR "LibB")

elseif(PROJECT_NAME STREQUAL "LibC")
  check_variable(LibC_VAR "LibC")

elseif(PROJECT_NAME STREQUAL "LibD")
  check_variable(LibD_VAR "LibD")

elseif(PROJECT_NAME STREQUAL "LibE")
  check_variable(LibE_VAR "LibE")

elseif(PROJECT_NAME STREQUAL "LibF")
  check_variable(LibF_VAR "LibF")

elseif(PROJECT_NAME STREQUAL "LibG")
  check_variable(LibG_VAR "LibG")

elseif(PROJECT_NAME STREQUAL "LibH")
  check_variable(LibH_VAR "LibH")

else()
  message(FATAL_ERROR "Unknown project name: ${PROJECT_NAME}")
endif()

