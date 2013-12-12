#
# LibE
#

set(proj LibE)
set(${proj}_DEPENDS "LibA")

superbuild_include_dependencies(${proj}
  PROJECT_VAR proj
  )




include(${CMAKE_CURRENT_SOURCE_DIR}/../ArtichokeCheckVariable.cmake)
check_variable(proj "LibE")
check_variable(${proj}_DEPENDS "LibA")
check_variable(${CMAKE_PROJECT_NAME}_USE_SYSTEM_${proj} "")

if(${CMAKE_PROJECT_NAME}_USE_SYSTEM_${proj})
  message(FATAL_ERROR "Enabling ${CMAKE_PROJECT_NAME}_USE_SYSTEM_${proj} is not supported !")
endif()

# Sanity checks
if(DEFINED LibE_DIR AND NOT EXISTS ${LibE_DIR})
  message(FATAL_ERROR "LibE_DIR variable is defined but corresponds to non-existing directory")
endif()

if(NOT DEFINED LibE_DIR AND NOT ${CMAKE_PROJECT_NAME}_USE_SYSTEM_${proj})

  ExternalProject_Add(${proj}
    ${${proj}_EP_ARGS}
    SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/Lib
    BINARY_DIR ${proj}-build
    DOWNLOAD_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ""
    DEPENDS ${${proj}_DEPENDS}
    )
  set(LibE_DIR ${CMAKE_BINARY_DIR}/${proj}-build)

else()
  superbuild_add_empty_external_project(${proj} DEPENDS "${${proj}_DEPENDS}")
endif()

mark_as_superbuild(
  VARS LibE_DIR:PATH
  LABELS "FIND_PACKAGE"
  )
