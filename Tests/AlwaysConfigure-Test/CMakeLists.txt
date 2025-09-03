cmake_minimum_required(VERSION 2.8.7)

if(POLICY CMP0054 AND CMAKE_VERSION VERSION_LESS "4.0")
  cmake_policy(SET CMP0054 OLD)
endif()

project(AlwaysConfigure-Test NONE)

set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../../" ${CMAKE_MODULE_PATH})
include(ExternalProject)
include(ExternalProjectDependency)

option(${PROJECT_NAME}_SUPERBUILD "Build ${PROJECT_NAME} and the projects it depends" ON)
mark_as_advanced(${PROJECT_NAME}_SUPERBUILD)

if(${PROJECT_NAME}_SUPERBUILD)
  ExternalProject_Add(${PROJECT_NAME}
    DOWNLOAD_COMMAND ""
    CMAKE_CACHE_ARGS
      -D${PROJECT_NAME}_SUPERBUILD:BOOL=OFF
    SOURCE_DIR ${${PROJECT_NAME}_SOURCE_DIR}
    BINARY_DIR ${${PROJECT_NAME}_BINARY_DIR}/${PROJECT_NAME}-build
    BUILD_COMMAND ""
    INSTALL_COMMAND ""
    DEPENDS
      ${${PROJECT_NAME}_DEPENDS}
    )
  ExternalProject_AlwaysConfigure(${PROJECT_NAME})

  include(CTest)
  add_test(build ${CMAKE_COMMAND} --build ${CMAKE_BINARY_DIR} --config Release)
  set_tests_properties(build PROPERTIES PASS_REGULAR_EXPRESSION "inner build configured")

  return()
endif()

message(STATUS "inner build configured")

