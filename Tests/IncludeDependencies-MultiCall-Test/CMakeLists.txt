cmake_minimum_required(VERSION 2.8.7)

project(IncludeDependencies-MultiCall-Test NONE)

set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../../" ${CMAKE_MODULE_PATH})
set(EXTERNAL_PROJECT_DIR ${CMAKE_CURRENT_BINARY_DIR}/Externals)
file(REMOVE_RECURSE ${EXTERNAL_PROJECT_DIR})
file(MAKE_DIRECTORY ${EXTERNAL_PROJECT_DIR})

include(ExternalProject)
include(Artichoke)

include(${CMAKE_CURRENT_SOURCE_DIR}/../ArtichokeTestUtility.cmake)


option(BUILD_EXTERNAL_PROJECTS "Build ${PROJECT_NAME} and the projects it depends on." ON)


#-----------------------------------------------------------------------------
foreach(_p ProjectA ProjectB)
  message("-----------------------------------------------------------------------------")

  set(expected_${_p}_ALL_DEPENDS
    ${_p}-LibA ${_p}-LibB ${_p}-LibC ${_p}-LibD ${_p}-LibE ${_p}-LibF ${_p}-LibG ${_p}-LibH)

  set(optional_${_p}_project ${_p}-LibA)
  set(expected_${_p}_REQUIRED_DEPENDS ${_p}-LibB ${_p}-LibG ${_p}-LibH)
  set(expected_${_p}_DEPENDS ${optional_${_p}_project})
  list(APPEND  expected_${_p}_DEPENDS ${expected_${_p}_REQUIRED_DEPENDS})
  set(expected_${_p}_LibA_DEPENDS "")
  set(expected_${_p}_LibB_DEPENDS ${_p}-LibC ${_p}-LibD)
  set(expected_${_p}_LibC_DEPENDS "")
  set(expected_${_p}_LibD_DEPENDS ${_p}-LibE ${_p}-LibF)
  set(expected_${_p}_LibE_DEPENDS "")
  set(expected_${_p}_LibF_DEPENDS "")
  set(expected_${_p}_LibG_DEPENDS ${_p}-LibE)
  set(expected_${_p}_LibH_DEPENDS ${_p}-LibD)

  configure_external_projects_for_test("${expected_${_p}_ALL_DEPENDS}")

  set(${_p}_DEPENDS ${expected_${_p}_DEPENDS})

  macro(superbuild_is_external_project_includable possible_proj output_var)
    set(${output_var} 1)
    if(${possible_proj} STREQUAL "${optional_${_p}_project}")
      set(${output_var} 0)
    endif()
  endmacro()

  set(proj ${_p})
  superbuild_include_dependencies(${proj}
    SUPERBUILD_VAR BUILD_EXTERNAL_PROJECTS
    )

  foreach(varname SB_FIRST_PASS SB_SECOND_PASS _sb_SB_VAR)
    if(DEFINED ${varname})
      message(FATAL_ERROR "${varname} should NOT be defined !")
    endif()
  endforeach()

  check_variable(${_p}_DEPENDS "${expected_${_p}_REQUIRED_DEPENDS}")

  # Check properties internally set by superbuild_include_dependencies
  foreach(dep ${expected_${_p}_ALL_DEPENDS})
    get_property(prop_SB_${dep}_DEPENDS GLOBAL PROPERTY SB_${dep}_DEPENDS)
    check_variable(prop_SB_${dep}_DEPENDS "${expected_${dep}_DEPENDS}")
  endforeach()
  get_property(prop_SB_${_p}_DEPENDS GLOBAL PROPERTY SB_${_p}_DEPENDS)
  check_variable(prop_SB_${_p}_DEPENDS "${expected_${_p}_REQUIRED_DEPENDS}")

endforeach()

#-----------------------------------------------------------------------------
if(BUILD_EXTERNAL_PROJECTS)

  foreach(_p ProjectA ProjectB)
    ExternalProject_Add(${_p}
      ${${_p}_EP_ARGS}
      DOWNLOAD_COMMAND ""
      CMAKE_CACHE_ARGS
        -DBUILD_EXTERNAL_PROJECTS:BOOL=OFF
        -DINNER_PROJECT_NAME:STRING=${_p}
      SOURCE_DIR ${${PROJECT_NAME}_SOURCE_DIR}
      BINARY_DIR ${${PROJECT_NAME}_BINARY_DIR}/${_p}-build
      BUILD_COMMAND ""
      INSTALL_COMMAND ""
      DEPENDS
        ${${_p}_DEPENDS}
      )
  endforeach()

  return()
endif()

#-----------------------------------------------------------------------------
foreach(dep ${expected_${PROJECT_NAME}_REQUIRED_DEPENDS})
  get_filename_component(expected "${CMAKE_CURRENT_BINARY_DIR}/../${INNER_PROJECT_NAME}-${dep}-build" REALPATH)
  check_variable(${INNER_PROJECT_NAME}-${dep}_DIR ${expected})
endforeach()
