cmake_minimum_required(VERSION 2.8.7)

project(IncludeDependencies-SUPERBUILD_VAR-Test NONE)

set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../../" ${CMAKE_MODULE_PATH})
set(EXTERNAL_PROJECT_DIR ${CMAKE_CURRENT_BINARY_DIR}/Externals)
file(REMOVE_RECURSE ${EXTERNAL_PROJECT_DIR})
file(MAKE_DIRECTORY ${EXTERNAL_PROJECT_DIR})

include(ExternalProject)
include(Artichoke)

#
# Helper function(s)
#
function(_configure_external_projects depends)
  foreach(dep ${depends})
    set(PROJECT_NAME_CONFIG ${dep})
    configure_file(../External_Lib.cmake.in
      ${EXTERNAL_PROJECT_DIR}/External_${dep}.cmake @ONLY
      )
  endforeach()
endfunction()

option(BUILD_EXTERNAL_PROJECTS "Build ${PROJECT_NAME} and the projects it depends on." ON)

#-----------------------------------------------------------------------------
set(${PROJECT_NAME}_DEPENDS LibA LibB)
_configure_external_projects("${${PROJECT_NAME}_DEPENDS}")

superbuild_include_dependencies(${PROJECT_NAME}
  PROJECT_VAR PROJECT_NAME
  SUPERBUILD_VAR BUILD_EXTERNAL_PROJECTS
  )

#-----------------------------------------------------------------------------
if(BUILD_EXTERNAL_PROJECTS)
  message(${PROJECT_NAME}_DEPENDS:${${PROJECT_NAME}_DEPENDS})
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
include(${CMAKE_CURRENT_SOURCE_DIR}/../ArtichokeCheckVariable.cmake)

foreach(dep LibA LibB)
  get_filename_component(expected "${CMAKE_CURRENT_BINARY_DIR}/../${dep}-build" REALPATH)
  check_variable(${dep}_DIR ${expected})
endforeach()
