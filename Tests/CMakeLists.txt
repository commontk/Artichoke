cmake_minimum_required(VERSION 2.8.7)

project(ArtichokeTest NONE)

include(CTest)

#
# Helper macros
#
macro(add_cmakescript_test name script)
  set(testname ${name}-Test)
  add_test(${testname} ${CMAKE_COMMAND}
    -DTEST_${name}_test:BOOL=ON
    -P ${tests_source_dir}/${script}.cmake)
  set_tests_properties(${testname} PROPERTIES
    LABELS CMake
    PASS_REGULAR_EXPRESSION "SUCCESS")
endmacro()

set(CMAKE_TEST_GENERATOR "${CMAKE_GENERATOR}")
set(CMAKE_TEST_GENERATOR_TOOLSET "${CMAKE_GENERATOR_TOOLSET}")
set(CMAKE_TEST_MAKEPROGRAM "${CMAKE_MAKE_PROGRAM}")

set(build_generator_args
  --build-generator ${CMAKE_TEST_GENERATOR}
  --build-makeprogram ${CMAKE_TEST_MAKEPROGRAM}
  )
if(CMAKE_TEST_GENERATOR_TOOLSET)
  list(APPEND build_generator_args
    --build-generator-toolset ${CMAKE_TEST_GENERATOR_TOOLSET}
    )
endif()

macro(add_project_test name label)
  set(testname ${name}-Test)
  set(_project ${testname})
  set(_dir ${_project})

  add_test(${_prefix}${testname}_clean ${CMAKE_COMMAND}
      -E remove_directory ${tests_binary_dir}/${_dir}
      )

  add_test(${testname} ${CMAKE_CTEST_COMMAND}
      --build-and-test
      "${tests_source_dir}/${_dir}"
      "${tests_binary_dir}/${_dir}"
      ${build_generator_args}
      --build-project ${project}
      --build-exe-dir "${tests_binary_dir}/${_dir}"
      --force-new-ctest-process
      --test-command ${CMAKE_CTEST_COMMAND} -V
      )

  set_tests_properties(${testname}
      PROPERTIES
        DEPENDS ${testname}_clean
        LABELS "CMake;${label}"
      )
endmacro()


#
# Add 'CMake script' Tests
#
set(tests_binary_dir ${CMAKE_BINARY_DIR})

set(tests_source_dir ${CMAKE_SOURCE_DIR})
add_cmakescript_test(_sb_list_to_string ArtichokeTest)
add_cmakescript_test(_sb_cmakevar_to_cmakearg ArtichokeTest)
add_cmakescript_test(_sb_extract_varname_and_vartype ArtichokeTest)
add_cmakescript_test(_sb_extract_varname_and_vartype ArtichokeTest)

set(tests_source_dir ${CMAKE_SOURCE_DIR})
add_project_test(MarkAsSuperBuild SuperBuild)
add_project_test(IncludeDependencies-SUPERBUILD_VAR SuperBuild)
