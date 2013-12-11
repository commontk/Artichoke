cmake_minimum_required(VERSION 2.8.7)

project(LibA NONE)

include(${CMAKE_CURRENT_SOURCE_DIR}/../ArtichokeCheckVariable.cmake)

check_variable(LibA_VAR "LibA")

check_variable(LibA_EP_LABEL_LABEL_A "LibA_VAR_WITH_LABELS")

check_variable(MULTIPROJECT_VAR "MultiProjectVar")

check_variable(LibA_EP_LABEL_MULTIPROJECT "MULTIPROJECT_VAR_WITH_LABELS")
check_variable(MULTIPROJECT_VAR_WITH_LABELS "MultiProjectVarWithLabels")

check_variable(ALL_PROJECTS_VAR "AllProjectsVar")