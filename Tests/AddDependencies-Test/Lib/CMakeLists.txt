cmake_minimum_required(VERSION 2.8.7)

if(POLICY CMP0054)
  cmake_policy(SET CMP0054 OLD)
endif()

get_filename_component(_project_name ${CMAKE_BINARY_DIR} NAME_WE)
string(REPLACE "-build" "" _project_name ${_project_name})

project(${_project_name} NONE)
message(STATUS "Configuring project ${PROJECT_NAME}")

include(${CMAKE_CURRENT_SOURCE_DIR}/../../ArtichokeTestUtility.cmake)

check_variable_defined("MAINPROJECT_INNER_BUILD_DIR")

file(WRITE ${MAINPROJECT_INNER_BUILD_DIR}/${PROJECT_NAME}.txt "")

