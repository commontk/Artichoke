cmake_minimum_required(VERSION 2.8.7)

if(POLICY CMP0054)
  cmake_policy(SET CMP0054 OLD)
endif()

project(ExternalProject_SetIfNotDefined-Cache-Test NONE)

set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../../" ${CMAKE_MODULE_PATH})
include(ExternalProjectDependency)

include(${CMAKE_CURRENT_SOURCE_DIR}/../ArtichokeTestUtility.cmake)

# prefix
set(p "ExternalProject_SetIfNotDefined-Cache-Test")

# Check that cache variable is not overridden
set(${p}_BLUE "cache-blue" CACHE STRING "")
check_variable(${p}_BLUE "cache-blue")
ExternalProject_SetIfNotDefined(${p}_BLUE "default-blue")
check_variable(${p}_BLUE "cache-blue")

# Check that env variable is not overridden
set(ENV{${p}_RED} "env-red")
check_env_variable(${p}_RED "env-red")
check_variable_not_defined(${p}_RED)
ExternalProject_SetIfNotDefined(${p}_RED "default-red")
check_variable(${p}_RED "env-red")

# Check that local variable is not overridden
set(${p}_GREEN "local-green")
check_variable(${p}_GREEN "local-green")
ExternalProject_SetIfNotDefined(${p}_GREEN "default-green")
check_variable(${p}_GREEN "local-green")

# Check that local variable still has precedence over cache variable
set(${p}_CYAN "cache-cyan" CACHE STRING "")
check_variable(${p}_CYAN "cache-cyan")
set(${p}_CYAN "local-cyan")
ExternalProject_SetIfNotDefined(${p}_CYAN "default-cyan")
check_variable(${p}_CYAN "local-cyan")
