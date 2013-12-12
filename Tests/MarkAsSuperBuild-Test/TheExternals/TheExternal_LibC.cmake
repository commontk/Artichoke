#
# LibC
#

set(proj LibC)
set(depends LibD)

superbuild_include_dependencies(${proj}
  PROJECT_VAR proj
  DEPENDS_VAR depends
  EP_ARGS_VAR ep_args
  USE_SYSTEM_VAR ${CMAKE_PROJECT_NAME}_USE_SYSTEM_${proj}
  )

include(${CMAKE_CURRENT_SOURCE_DIR}/../ArtichokeTestUtility.cmake)
check_variable(proj "LibC")
check_variable(depends "LibD")
check_variable(${CMAKE_PROJECT_NAME}_USE_SYSTEM_${proj} 1)

if(${CMAKE_PROJECT_NAME}_USE_SYSTEM_${proj})
  unset(LibC_DIR CACHE)
endif()

# Sanity checks
if(DEFINED LibC_DIR AND NOT EXISTS ${LibC_DIR})
  message(FATAL_ERROR "LibC_DIR variable is defined but corresponds to non-existing directory")
endif()

if(NOT DEFINED LibC_DIR AND NOT ${CMAKE_PROJECT_NAME}_USE_SYSTEM_${proj})

   message(FATAL_ERROR "Disabling ${CMAKE_PROJECT_NAME}_USE_SYSTEM_${proj} is not supported !")

else()
  superbuild_add_empty_external_project(${proj} DEPENDS "${depends}")
endif()

