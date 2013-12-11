#
# LibD
#

set(proj_libd LibD)
set(depends LibF LibG)

superbuild_include_dependencies(${proj_libd}
  PROJECT_VAR proj_libd
  DEPENDENCIES_VAR depends
  EP_ARGS_VAR ep_args
  USE_SYSTEM_VAR ${CMAKE_PROJECT_NAME}_USE_SYSTEM_${proj_libd}
  )

include(${CMAKE_CURRENT_SOURCE_DIR}/ArtichokeCheckVariable.cmake)
check_variable(proj_libd "LibD")
check_variable(depends "LibF;LibG")
check_variable(${CMAKE_PROJECT_NAME}_USE_SYSTEM_${proj_libd} 1)

if(${CMAKE_PROJECT_NAME}_USE_SYSTEM_${proj_libd})
  unset(LibD_DIR CACHE)
endif()

# Sanity checks
if(DEFINED LibD_DIR AND NOT EXISTS ${LibD_DIR})
  message(FATAL_ERROR "LibD_DIR variable is defined but corresponds to non-existing directory")
endif()

if(NOT DEFINED LibD_DIR AND NOT ${CMAKE_PROJECT_NAME}_USE_SYSTEM_${proj_libd})

  message(FATAL_ERROR "Disabling ${CMAKE_PROJECT_NAME}_USE_SYSTEM_${proj_libd} is not supported !")

else()
  superbuild_add_empty_external_project(${proj_libd} "${depends}")
endif()

