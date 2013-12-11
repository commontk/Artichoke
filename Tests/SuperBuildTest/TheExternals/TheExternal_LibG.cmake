#
# LibG
#

set(LibG_DEPENDENCIES "LibF")

superbuild_include_dependencies(LibG)


include(${CMAKE_CURRENT_SOURCE_DIR}/ArtichokeCheckVariable.cmake)
check_variable(proj "LibG")
check_variable(${proj}_DEPENDENCIES "LibF")
check_variable(${CMAKE_PROJECT_NAME}_USE_SYSTEM_${proj} 1)

if(${CMAKE_PROJECT_NAME}_USE_SYSTEM_${proj_libd})
  unset(LibG_DIR CACHE)
endif()

# Sanity checks
if(DEFINED LibG_DIR AND NOT EXISTS ${LibG_DIR})
  message(FATAL_ERROR "LibG_DIR variable is defined but corresponds to non-existing directory")
endif()

if(NOT DEFINED LibD_DIR AND NOT ${CMAKE_PROJECT_NAME}_USE_SYSTEM_${proj})

  message(FATAL_ERROR "Disabling ${CMAKE_PROJECT_NAME}_USE_SYSTEM_${proj} is not supported !")

else()
  superbuild_add_empty_external_project(${proj} DEPENDS "${${proj}_DEPENDENCIES}")
endif()

mark_as_superbuild(
  VARS LibG_DIR:PATH
  LABELS "FIND_PACKAGE"
  )
