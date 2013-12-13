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
foreach(p ProjectA ProjectB)
  message("-----------------------------------------------------------------------------")

# |-<project>
# | \-<project>-LibA [Optional]
# | |-<project>-LibB
# | | \-<project>-LibC
# | | |-<project>-LibD
# | | | \-<project>-LibE
# | | | \-<project>-LibF
# | |-<project>-LibG
# | | \-<project>-LibE
# | |-<project>-LibH
# | | |-<project>-LibD
# | | | \-<project>-LibE
# | | | \-<project>-LibF

  set(expected_${p}_ALL_DEPENDS
    ${p}-LibA ${p}-LibB ${p}-LibC ${p}-LibD ${p}-LibE ${p}-LibF ${p}-LibG ${p}-LibH)

  set(optional_${p}_DEPENDS ${p}-LibA)

  foreach(dep ${optional_${p}_DEPENDS})
    set(optional_${dep} 1)
  endforeach()

  set(expected_${p}_REQUIRED_DEPENDS ${p}-LibB ${p}-LibG ${p}-LibH)
  list(APPEND expected_${p}_DEPENDS ${optional_${p}_DEPENDS})
  list(APPEND expected_${p}_DEPENDS ${expected_${p}_REQUIRED_DEPENDS})
  set(expected_${p}-LibA_DEPENDS "")
  set(expected_${p}-LibB_DEPENDS ${p}-LibC ${p}-LibD)
  set(expected_${p}-LibC_DEPENDS "")
  set(expected_${p}-LibD_DEPENDS ${p}-LibE ${p}-LibF)
  set(expected_${p}-LibE_DEPENDS "")
  set(expected_${p}-LibF_DEPENDS "")
  set(expected_${p}-LibG_DEPENDS ${p}-LibE)
  set(expected_${p}-LibH_DEPENDS ${p}-LibD)

  configure_external_projects_for_test(${p})

  macro(superbuild_is_external_project_includable possible_proj output_var)
    set(${output_var} 1)
    if(optional_${possible_proj})
      set(${output_var} 0)
    endif()
  endmacro()

  set(${p}_DEPENDS ${expected_${p}_DEPENDS})

  set(proj ${p})
  ExternalProject_Include_Dependencies(${proj}
    SUPERBUILD_VAR BUILD_EXTERNAL_PROJECTS
    )

  foreach(varname SB_FIRST_PASS SB_SECOND_PASS _sb_SB_VAR)
    if(DEFINED ${varname})
      message(FATAL_ERROR "${varname} should NOT be defined !")
    endif()
  endforeach()

  check_variable(${p}_DEPENDS "${expected_${p}_REQUIRED_DEPENDS}")

  # Check properties internally set by ExternalProject_Include_Dependencies
  foreach(dep ${expected_${p}_ALL_DEPENDS})
    get_property(prop_SB_${dep}_DEPENDS GLOBAL PROPERTY SB_${dep}_DEPENDS)
    check_variable(prop_SB_${dep}_DEPENDS "${expected_${dep}_DEPENDS}")
  endforeach()
  get_property(prop_SB_${p}_DEPENDS GLOBAL PROPERTY SB_${p}_DEPENDS)
  check_variable(prop_SB_${p}_DEPENDS "${expected_${p}_REQUIRED_DEPENDS}")

endforeach()

#-----------------------------------------------------------------------------
if(BUILD_EXTERNAL_PROJECTS)

  foreach(p ProjectA ProjectB)
    ExternalProject_Add(${p}
      ${${p}_EP_ARGS}
      DOWNLOAD_COMMAND ""
      CMAKE_CACHE_ARGS
        -DBUILD_EXTERNAL_PROJECTS:BOOL=OFF
        -DINNER_PROJECT_NAME:STRING=${p}
      SOURCE_DIR ${${PROJECT_NAME}_SOURCE_DIR}
      BINARY_DIR ${${PROJECT_NAME}_BINARY_DIR}/${p}-build
      BUILD_COMMAND ""
      INSTALL_COMMAND ""
      DEPENDS
        ${${p}_DEPENDS}
      )
  endforeach()

  return()
endif()

#-----------------------------------------------------------------------------
foreach(dep ${expected_${PROJECT_NAME}_REQUIRED_DEPENDS})
  get_filename_component(expected "${CMAKE_CURRENT_BINARY_DIR}/../${INNER_PROJECT_NAME}-${dep}-build" REALPATH)
  check_variable(${INNER_PROJECT_NAME}-${dep}_DIR ${expected})
endforeach()
