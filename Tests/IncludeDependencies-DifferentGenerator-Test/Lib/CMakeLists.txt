cmake_minimum_required(VERSION 2.8.7)

if(POLICY CMP0054)
  cmake_policy(SET CMP0054 OLD)
endif()

include(${CMAKE_CURRENT_SOURCE_DIR}/../../ArtichokeTestUtility.cmake)

get_filename_component(_project_name ${CMAKE_BINARY_DIR} NAME_WE)
string(REPLACE "-build" "" _project_name ${_project_name})

project(${_project_name} NONE)
message(STATUS "Configuring project ${PROJECT_NAME}")
message(STATUS "  CMAKE_GENERATOR: ${CMAKE_GENERATOR}")
message(STATUS "  CMAKE_EXTRA_GENERATOR: ${CMAKE_EXTRA_GENERATOR}")

set(p "DiffGen")

set(expected_${p}-LibA_CMAKE_GENERATOR "Ninja")
set(expected_${p}-LibA_CMAKE_EXTRA_GENERATOR "CodeBlocks")

set(expected_${p}-LibB_CMAKE_GENERATOR "Unix Makefiles")
set(expected_${p}-LibB_CMAKE_EXTRA_GENERATOR "CodeLite")

check_variable("CMAKE_GENERATOR" "${expected_${_project_name}_CMAKE_GENERATOR}")
check_variable("CMAKE_EXTRA_GENERATOR" "${expected_${_project_name}_CMAKE_EXTRA_GENERATOR}")
