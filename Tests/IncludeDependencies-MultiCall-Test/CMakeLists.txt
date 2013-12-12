cmake_minimum_required(VERSION 2.8.7)

project(IncludeDependencies-MultiCall-Test NONE)

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

include(${CMAKE_CURRENT_SOURCE_DIR}/../ArtichokeCheckVariable.cmake)


option(BUILD_EXTERNAL_PROJECTS "Build ${PROJECT_NAME} and the projects it depends on." ON)

#-----------------------------------------------------------------------------
foreach(proj ProjectA ProjectB)
  message("-----------------------------------------------------------------------------")

  set(${proj}_DEPENDS ${proj}-LibA ${proj}-LibB)
  _configure_external_projects("${${proj}_DEPENDS}")

  superbuild_include_dependencies(${proj}
    SUPERBUILD_VAR BUILD_EXTERNAL_PROJECTS
    )

  foreach(varname SB_FIRST_PASS SB_SECOND_PASS _sb_SB_VAR)
    if(DEFINED ${varname})
      message(FATAL_ERROR "${varname} should NOT be defined !")
    endif()
  endforeach()

endforeach()

#-----------------------------------------------------------------------------
if(BUILD_EXTERNAL_PROJECTS)

  foreach(proj ProjectA ProjectB)
    ExternalProject_Add(${proj}
      ${${proj}_EP_ARGS}
      DOWNLOAD_COMMAND ""
      CMAKE_CACHE_ARGS
        -DBUILD_EXTERNAL_PROJECTS:BOOL=OFF
        -DINNER_PROJECT_NAME:STRING=${proj}
      SOURCE_DIR ${${PROJECT_NAME}_SOURCE_DIR}
      BINARY_DIR ${${PROJECT_NAME}_BINARY_DIR}/${proj}-build
      BUILD_COMMAND ""
      INSTALL_COMMAND ""
      DEPENDS
        ${${proj}_DEPENDS}
      )
  endforeach()

  return()
endif()

#-----------------------------------------------------------------------------
foreach(dep LibA LibB)
  get_filename_component(expected "${CMAKE_CURRENT_BINARY_DIR}/../${INNER_PROJECT_NAME}-${dep}-build" REALPATH)
  check_variable(${INNER_PROJECT_NAME}-${dep}_DIR ${expected})
endforeach()
