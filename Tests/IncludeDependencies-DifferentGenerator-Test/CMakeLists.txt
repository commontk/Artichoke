cmake_minimum_required(VERSION 2.8.7)

if(POLICY CMP0054)
  cmake_policy(SET CMP0054 OLD)
endif()

project(IncludeDependencies-DifferentGenerator-Test NONE)

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

# |-DiffGen
# | \-DiffGen-LibA
# | |-DiffGen-LibB

set(p DiffGen) # Use a shorter project name

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
  # Setting variable <projectname>_EXTERNAL_PROJECT_INCLUDE_DEPENDENCIES_EXTRA_ARGS allows
  # to pass additional arguments to the ExternalProject_Include_Dependencies call.
  set(${p}-LibA_EXTERNAL_PROJECT_INCLUDE_DEPENDENCIES_EXTRA_ARGS
    "CMAKE_GENERATOR \"CodeBlocks - Ninja\""
    )
  set(${p}-LibB_EXTERNAL_PROJECT_INCLUDE_DEPENDENCIES_EXTRA_ARGS
    "CMAKE_GENERATOR \"CodeLite - Unix Makefiles\""
    )
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

if(BUILD_EXTERNAL_PROJECTS)
  set(${p}_EP_ADDED 1)
endif()

#-----------------------------------------------------------------------------
set(expected_${PROJECT_NAME}_CMAKE_GENERATOR "Unix Makefiles") # XXX Fix this on windows
set(expected_${p}-LibA_CMAKE_GENERATOR "CodeBlocks - Ninja")
set(expected_${p}-LibB_CMAKE_GENERATOR "CodeLite - Unix Makefiles")
check_variable("_sb_CMAKE_GENERATOR" "${expected_${PROJECT_NAME}_CMAKE_GENERATOR}")

#-----------------------------------------------------------------------------

check_variable(p "DiffGen")

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

