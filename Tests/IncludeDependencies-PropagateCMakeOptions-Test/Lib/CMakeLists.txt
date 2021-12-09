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
message(STATUS "  CMAKE_FIND_PACKAGE_NO_PACKAGE_REGISTRY: ${CMAKE_FIND_PACKAGE_NO_PACKAGE_REGISTRY}")
message(STATUS "  CMAKE_FIND_USE_PACKAGE_REGISTRY: ${CMAKE_FIND_USE_PACKAGE_REGISTRY}")
message(STATUS "  CMAKE_JOB_POOL_COMPILE: ${CMAKE_JOB_POOL_COMPILE}")
message(STATUS "  CMAKE_JOB_POOL_LINK: ${CMAKE_JOB_POOL_LINK}")
message(STATUS "  CMAKE_JOB_POOLS: ${CMAKE_JOB_POOLS}")

set(expected_CMAKE_EXPORT_COMPILE_COMMANDS "ON")
check_variable("CMAKE_EXPORT_COMPILE_COMMANDS" "${expected_CMAKE_EXPORT_COMPILE_COMMANDS}")

if(CMAKE_VERSION VERSION_LESS "3.16")
  set(expected_CMAKE_FIND_PACKAGE_NO_PACKAGE_REGISTRY "ON")
else()
  set(expected_CMAKE_FIND_PACKAGE_NO_PACKAGE_REGISTRY "")
endif()
check_variable("CMAKE_FIND_PACKAGE_NO_PACKAGE_REGISTRY" "${expected_CMAKE_FIND_PACKAGE_NO_PACKAGE_REGISTRY}")

if(CMAKE_VERSION VERSION_LESS "3.16")
  set(expected_CMAKE_FIND_USE_PACKAGE_REGISTRY "")
else()
  set(expected_CMAKE_FIND_USE_PACKAGE_REGISTRY "OFF")
endif()
check_variable("CMAKE_FIND_USE_PACKAGE_REGISTRY" "${expected_CMAKE_FIND_USE_PACKAGE_REGISTRY}")

set(expected_CMAKE_JOB_POOL_COMPILE "compile")
check_variable("CMAKE_JOB_POOL_COMPILE" "${expected_CMAKE_JOB_POOL_COMPILE}")

set(expected_CMAKE_JOB_POOL_LINK "link")
check_variable("CMAKE_JOB_POOL_LINK" "${expected_CMAKE_JOB_POOL_LINK}")

set(expected_CMAKE_JOB_POOLS "compile=5;link=2")
check_variable("CMAKE_JOB_POOLS" "${expected_CMAKE_JOB_POOLS}")
