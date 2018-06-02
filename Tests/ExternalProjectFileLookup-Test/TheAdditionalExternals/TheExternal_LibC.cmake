#
# LibC
#

set(proj LibC)
set(depends "")

ExternalProject_Include_Dependencies(${proj}
  PROJECT_VAR proj
  DEPENDS_VAR depends
  EP_ARGS_VAR ep_args
  USE_SYSTEM_VAR ${CMAKE_PROJECT_NAME}_USE_SYSTEM_${proj}
  )

include(${CMAKE_CURRENT_SOURCE_DIR}/../ArtichokeTestUtility.cmake)
check_variable(proj "LibC")
check_variable(depends "")
check_variable(${CMAKE_PROJECT_NAME}_USE_SYSTEM_${proj} "")

if(${CMAKE_PROJECT_NAME}_USE_SYSTEM_${proj})
  message(FATAL_ERROR "Enabling ${CMAKE_PROJECT_NAME}_USE_SYSTEM_${proj} is not supported !")
endif()

# Sanity checks
if(DEFINED LibC_DIR AND NOT EXISTS ${LibC_DIR})
  message(FATAL_ERROR "LibC_DIR variable is defined but corresponds to non-existing directory")
endif()

if(NOT DEFINED LibC_DIR AND NOT ${CMAKE_PROJECT_NAME}_USE_SYSTEM_${proj})

  ExternalProject_Add(${proj}
    ${ep_args}
    SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/Lib
    BINARY_DIR ${proj}-build
    DOWNLOAD_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ""
    DEPENDS ${depends}
    )
  set(LibC_DIR ${CMAKE_BINARY_DIR}/${proj}-build)

else()
  ExternalProject_Add_Empty(${proj} DEPENDS "${depends}")
endif()

mark_as_superbuild(
  VARS LibC_DIR:PATH
  LABELS "FIND_PACKAGE"
  )
