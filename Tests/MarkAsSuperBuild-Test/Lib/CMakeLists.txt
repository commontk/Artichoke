cmake_minimum_required(VERSION 2.8.7)

if(POLICY CMP0054)
  cmake_policy(SET CMP0054 OLD)
endif()

get_filename_component(_project_name ${CMAKE_BINARY_DIR} NAME_WE)
string(REPLACE "-build" "" _project_name ${_project_name})

project(${_project_name} NONE)
message(STATUS "Configuring project ${PROJECT_NAME}")

include(${CMAKE_CURRENT_SOURCE_DIR}/../../ArtichokeTestUtility.cmake)

if(PROJECT_NAME STREQUAL "LibA")

  check_variable(LibA_VAR "LibA")

  check_variable(LibA_EP_LABEL_LABEL_A "LibA_VAR_WITH_LABELS")

  check_variable(MULTIPROJECT_VAR "MultiProjectVar")

  check_variable(MULTIPROJECT_VAR_WITH_LABELS "MultiProjectVarWithLabels")
  check_variable(LibA_EP_LABEL_MULTIPROJECT "MULTIPROJECT_VAR_WITH_LABELS")

elseif(PROJECT_NAME STREQUAL "LibB")

  check_variable(LibB_VAR "LibB")

  check_variable(MULTIPROJECT_VAR "MultiProjectVar")

  check_variable(MULTIPROJECT_VAR_WITH_LABELS "MultiProjectVarWithLabels")
  check_variable(LibB_EP_LABEL_MULTIPROJECT "MULTIPROJECT_VAR_WITH_LABELS")

elseif(PROJECT_NAME STREQUAL "LibE")

  check_variable(LibE_VAR "LibE")

else()
  message(FATAL_ERROR "Unknown project name: ${PROJECT_NAME}")
endif()


# mark_as_superbuild: Test use of ALL_PROJECTS
check_variable(ALL_PROJECTS_VAR "AllProjectsVar")

set(_ALL_PROJECT_IDENTIFIER "ALLALLALL")

# mark_as_superbuild: Test use of ALL_PROJECTS with LABELS
check_variable(${_ALL_PROJECT_IDENTIFIER}_EP_LABEL_ALLPROJECT "ALL_PROJECTS_VAR_WITH_LABELS")
check_variable(ALL_PROJECTS_VAR_WITH_LABELS "AllProjectsVarWithLabels")
