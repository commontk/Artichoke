cmake_minimum_required(VERSION 2.8.7)

if(POLICY CMP0054)
  cmake_policy(SET CMP0054 OLD)
endif()

project(IncludeDependencies-PropagateCMakeOptions-Test NONE)

#-----------------------------------------------------------------------------
option(BUILD_EXTERNAL_PROJECTS "Build ${PROJECT_NAME} and the projects it depends on." ON)

if(BUILD_EXTERNAL_PROJECTS)
  if(CMAKE_EXPORT_COMPILE_COMMANDS)
    message(FATAL_ERROR "CMAKE_EXPORT_COMPILE_COMMANDS should be OFF [${CMAKE_EXPORT_COMPILE_COMMANDS}]!")
  endif()
  set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

  if(CMAKE_JOB_POOLS OR CMAKE_JOB_POOL_COMPILE OR CMAKE_JOB_POOL_LINK)
    message(FATAL_ERROR "CMAKE_JOB_* variables should not be set !")
  endif()
  set(CMAKE_JOB_POOL_COMPILE "compile")
  set(CMAKE_JOB_POOL_LINK "link")
  set(CMAKE_JOB_POOLS "compile=5;link=2")
endif()

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

# |-PropagCMakeOpts
# | \-PropagCMakeOpts-LibA
# | |-PropagCMakeOpts-LibB

set(p PropagCMakeOpts) # Use a shorter project name

set(expected_${p}_ALL_DEPENDS ${p}-LibA ${p}-LibB)
set(expected_${p}_REQUIRED_DEPENDS ${p}-LibA ${p}-LibB)
set(expected_${p}_OPTIONAL_DEPENDS )


foreach(dep ${p} ${expected_${p}_ALL_DEPENDS})

  # Set expected_<dep>_DEPENDS variable
  set(expected_${dep}_DEPENDS ${expected_${dep}_OPTIONAL_DEPENDS} ${expected_${dep}_REQUIRED_DEPENDS})

  # Set (optional_|required_)<dep> variables
  set(required_${dep} 1)
  foreach(opt ${expected_${dep}_OPTIONAL_DEPENDS})
    set(optional_${opt} 1)
    set(required_${opt})
  endforeach()

endforeach()

if(BUILD_EXTERNAL_PROJECTS)
  configure_external_projects_for_test(${p})
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



