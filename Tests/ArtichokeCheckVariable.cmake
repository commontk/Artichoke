function(check_variable var_name expected_value)
  if(NOT "x${${var_name}}" STREQUAL "x${expected_value}")
    message(FATAL_ERROR "CMake variable [${var_name}] is incorrectly set !\n"
                        "current:${${var_name}}\n"
                        "expected:${expected_value}")
  endif()
endfunction()