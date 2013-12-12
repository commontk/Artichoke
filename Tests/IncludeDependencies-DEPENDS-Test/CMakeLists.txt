cmake_minimum_required(VERSION 2.8.7)

project(IncludeDependencies-DEPENDS-Test NONE)

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
include(Artichoke)

#-----------------------------------------------------------------------------
include(${CMAKE_CURRENT_SOURCE_DIR}/../ArtichokeTestUtility.cmake)

set(expected_ALL_DEPENDS LibA LibB LibC LibD LibE LibF LibG LibH)

set(optional_project LibA)
set(expected_${PROJECT_NAME}_REQUIRED_DEPENDS LibB LibG LibH)
set(expected_${PROJECT_NAME}_DEPENDS ${optional_project})
list(APPEND  expected_${PROJECT_NAME}_DEPENDS ${expected_${PROJECT_NAME}_REQUIRED_DEPENDS})
set(expected_LibA_DEPENDS "")
set(expected_LibB_DEPENDS LibC LibD)
set(expected_LibC_DEPENDS "")
set(expected_LibD_DEPENDS LibE LibF)
set(expected_LibE_DEPENDS "")
set(expected_LibF_DEPENDS "")
set(expected_LibG_DEPENDS LibE)
set(expected_LibH_DEPENDS LibD)
if(BUILD_EXTERNAL_PROJECTS)
  configure_external_projects_for_test("${expected_ALL_DEPENDS}")
endif()

macro(superbuild_is_external_project_includable possible_proj output_var)
  set(${output_var} 1)
  if(${possible_proj} STREQUAL "${optional_project}")
    set(${output_var} 0)
  endif()
endmacro()


#-----------------------------------------------------------------------------
set(${PROJECT_NAME}_DEPENDS LibA LibB LibG LibH)

superbuild_include_dependencies(${PROJECT_NAME}
  PROJECT_VAR PROJECT_NAME
  SUPERBUILD_VAR BUILD_EXTERNAL_PROJECTS
  )

#-----------------------------------------------------------------------------
check_variable(${PROJECT_NAME}_DEPENDS "${expected_${PROJECT_NAME}_REQUIRED_DEPENDS}")

# Check properties internally set by superbuild_include_dependencies
foreach(dep ${expected_ALL_DEPENDS})
  get_property(prop_SB_${dep}_DEPENDS GLOBAL PROPERTY SB_${dep}_DEPENDS)
  check_variable(prop_SB_${dep}_DEPENDS "${expected_${dep}_DEPENDS}")
endforeach()
get_property(prop_SB_${PROJECT_NAME}_DEPENDS GLOBAL PROPERTY SB_${PROJECT_NAME}_DEPENDS)
check_variable(prop_SB_${PROJECT_NAME}_DEPENDS "${expected_${PROJECT_NAME}_REQUIRED_DEPENDS}")

#-----------------------------------------------------------------------------
if(BUILD_EXTERNAL_PROJECTS)
  ExternalProject_Add(${PROJECT_NAME}
    ${${PROJECT_NAME}_EP_ARGS}
    DOWNLOAD_COMMAND ""
    CMAKE_CACHE_ARGS
      -DBUILD_EXTERNAL_PROJECTS:BOOL=OFF
    SOURCE_DIR ${${PROJECT_NAME}_SOURCE_DIR}
    BINARY_DIR ${${PROJECT_NAME}_BINARY_DIR}/${PROJECT_NAME}-build
    BUILD_COMMAND ""
    INSTALL_COMMAND ""
    DEPENDS
      ${${PROJECT_NAME}_DEPENDS}
    )
  return()
endif()

#-----------------------------------------------------------------------------
foreach(dep ${expected_${PROJECT_NAME}_REQUIRED_DEPENDS})
  get_filename_component(expected "${CMAKE_CURRENT_BINARY_DIR}/../${dep}-build" REALPATH)
  check_variable(${dep}_DIR ${expected})
endforeach()
