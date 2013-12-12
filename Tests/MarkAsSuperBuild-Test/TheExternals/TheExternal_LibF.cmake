#
# LibF
#

set(proj LibF)
set(${proj}_DEPENDS "")

superbuild_include_dependencies(${proj})




include(${CMAKE_CURRENT_SOURCE_DIR}/../ArtichokeCheckVariable.cmake)
check_variable(proj "LibF")
check_variable(${proj}_DEPENDS "")
check_variable(${CMAKE_PROJECT_NAME}_USE_SYSTEM_${proj} 1)

if(${CMAKE_PROJECT_NAME}_USE_SYSTEM_${proj_libd})
  unset(LibF_DIR CACHE)
endif()

# Sanity checks
if(DEFINED LibF_DIR AND NOT EXISTS ${LibF_DIR})
  message(FATAL_ERROR "LibF_DIR variable is defined but corresponds to non-existing directory")
endif()

if(NOT DEFINED LibD_DIR AND NOT ${CMAKE_PROJECT_NAME}_USE_SYSTEM_${proj})

  message(FATAL_ERROR "Disabling ${CMAKE_PROJECT_NAME}_USE_SYSTEM_${proj} is not supported !")

else()
  superbuild_add_empty_external_project(${proj} DEPENDS "${${proj}_DEPENDS}")
endif()

mark_as_superbuild(
  VARS LibF_DIR:PATH
  LABELS "FIND_PACKAGE"
  )
