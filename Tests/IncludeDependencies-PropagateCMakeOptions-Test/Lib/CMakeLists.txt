cmake_minimum_required(VERSION 2.8.7)

if(POLICY CMP0054)
  cmake_policy(SET CMP0054 OLD)
endif()

include(${CMAKE_CURRENT_SOURCE_DIR}/../../ArtichokeTestUtility.cmake)

get_filename_component(_project_name ${CMAKE_BINARY_DIR} NAME_WE)
string(REPLACE "-build" "" _project_name ${_project_name})

project(${_project_name} NONE)
message(STATUS "Configuring project ${PROJECT_NAME}")
message(STATUS "  CMAKE_EXPORT_COMPILE_COMMANDS: ${CMAKE_EXPORT_COMPILE_COMMANDS}")

set(expected_CMAKE_EXPORT_COMPILE_COMMANDS "ON")
check_variable("CMAKE_EXPORT_COMPILE_COMMANDS" "${expected_CMAKE_EXPORT_COMPILE_COMMANDS}")

