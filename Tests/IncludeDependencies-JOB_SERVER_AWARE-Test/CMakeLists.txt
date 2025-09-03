cmake_minimum_required(VERSION 2.8.7)

if(POLICY CMP0054 AND CMAKE_VERSION VERSION_LESS "4.0")
  cmake_policy(SET CMP0054 OLD)
endif()

project(IncludeDependencies-JOB_SERVER_AWARE-Test NONE)

#-----------------------------------------------------------------------------
option(BUILD_EXTERNAL_PROJECTS "Build ${PROJECT_NAME} and the projects it depends on." ON)

#-----------------------------------------------------------------------------
set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../../" ${CMAKE_MODULE_PATH})
if(BUILD_EXTERNAL_PROJECTS)
  set(EXTERNAL_PROJECT_DIR ${CMAKE_CURRENT_BINARY_DIR}/Externals)
  file(REMOVE_RECURSE ${EXTERNAL_PROJECT_DIR})
  file(MAKE_DIRECTORY ${EXTERNAL_PROJECT_DIR})
else()
  set(EXTERNAL_PROJECT_DIR ${CMAKE_CURRENT_BINARY_DIR}/../Externals)
endif()

include(ExternalProject)
include(ExternalProjectDependency)


#-----------------------------------------------------------------------------
include(${CMAKE_CURRENT_SOURCE_DIR}/../ArtichokeTestUtility.cmake)

# |-JobAware
# | \-JobAware-LibA
# | \-JobAware-LibB

set(p JobAware) # Use a shorter project name

set(expected_${p}_ALL_DEPENDS ${p}-LibA ${p}-LibB)
set(expected_${p}_REQUIRED_DEPENDS ${p}-LibA ${p}-LibB)
set(expected_${p}_OPTIONAL_DEPENDS )

foreach(dep ${p} ${expected_${p}_ALL_DEPENDS})

  # Set expected_<dep>_DEPENDS variable
  set(expected_${dep}_DEPENDS ${expected_${dep}_OPTIONAL_DEPENDS} ${expected_${dep}_REQUIRED_DEPENDS})

  # Set (optional_|required_)<dep> variables
  set(required_${dep} 1)
  foreach(opt "${expected_${dep}_OPTIONAL_DEPENDS}")
    set(optional_${opt} 1)
    set(required_${opt})
  endforeach()

endforeach()

if(BUILD_EXTERNAL_PROJECTS)
  check_variable_defined("TEST_JOB_SERVER_AWARE_STEP")
  if(NOT "${TEST_JOB_SERVER_AWARE_STEP}" MATCHES "^(BUILD)$")
    message(FATAL_ERROR "TEST_JOB_SERVER_AWARE_STEP is expected to be set to BUILD")
  endif()
  if(TEST_JOB_SERVER_AWARE_STEP STREQUAL "BUILD")
    set(EXTERNAL_PROJECT_ADDITIONAL_OPTIONS_CONFIG
      BUILD_COMMAND ${CMAKE_COMMAND} --build . --target install
      LOG_BUILD 1
      )
  else()
    message(FATAL_ERROR "TEST_JOB_SERVER_AWARE_STEP is expected to be set to BUILD")
  endif()
  if(CMAKE_VERSION VERSION_EQUAL "3.14" OR CMAKE_VERSION VERSION_GREATER "3.14")
    list(APPEND EXTERNAL_PROJECT_ADDITIONAL_OPTIONS_CONFIG
      LOG_OUTPUT_ON_FAILURE 1
      )
  endif()
  configure_external_projects_for_test(${p})

  check_variable_defined("EXPECTED_PARALLEL_LEVEL")
  mark_as_superbuild(
    VARS
      EXPECTED_PARALLEL_LEVEL
      TEST_JOB_SERVER_AWARE_STEP
    PROJECTS
      ${p}-LibA
      ${p}-LibB
    )
endif()

macro(superbuild_is_external_project_includable possible_proj output_var)
  set(${output_var} 1)
  if(optional_${possible_proj})
    set(${output_var} 0)
  endif()
endmacro()

#-----------------------------------------------------------------------------
set(${p}_DEPENDS ${expected_${p}_DEPENDS})

ExternalProject_Include_Dependencies(${p}
  PROJECT_VAR p
  SUPERBUILD_VAR BUILD_EXTERNAL_PROJECTS
  )

if(BUILD_EXTERNAL_PROJECTS)
  set(${p}_EP_ADDED 1)
endif()

#-----------------------------------------------------------------------------

check_variable(p "JobAware")

# Check that _DEPENDS variable has been updated
check_variable(${p}_DEPENDS "${expected_${p}_REQUIRED_DEPENDS}")

# Check properties internally set by ExternalProject_Include_Dependencies
foreach(dep ${p} ${expected_${p}_ALL_DEPENDS})
  get_property(prop_SB_${dep}_DEPENDS GLOBAL PROPERTY SB_${dep}_DEPENDS)
  check_variable(prop_SB_${dep}_DEPENDS "${expected_${dep}_DEPENDS}")

  get_property(prop_SB_${dep}_REQUIRED_DEPENDS GLOBAL PROPERTY SB_${dep}_REQUIRED_DEPENDS)
  check_variable(prop_SB_${dep}_REQUIRED_DEPENDS "${expected_${dep}_REQUIRED_DEPENDS}")

  if(BUILD_EXTERNAL_PROJECTS)
    check_variable(${dep}_EP_ADDED "${required_${dep}}")
  endif()
endforeach()
#-----------------------------------------------------------------------------
if(BUILD_EXTERNAL_PROJECTS)
  ExternalProject_Add(${p}
    ${${p}_EP_ARGS}
    DOWNLOAD_COMMAND ""
    CMAKE_CACHE_ARGS
      -DBUILD_EXTERNAL_PROJECTS:BOOL=OFF
    SOURCE_DIR ${${PROJECT_NAME}_SOURCE_DIR}
    BINARY_DIR ${${PROJECT_NAME}_BINARY_DIR}/${p}-build
    BUILD_COMMAND ""
    INSTALL_COMMAND ""
    DEPENDS
      ${${p}_DEPENDS}
    )
  return()
endif()

#-----------------------------------------------------------------------------
foreach(dep ${expected_${p}_REQUIRED_DEPENDS})
  get_filename_component(expected "${CMAKE_CURRENT_BINARY_DIR}/../${dep}-build" REALPATH)
  check_variable(${dep}_DIR ${expected})
endforeach()
