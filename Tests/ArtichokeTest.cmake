
if(POLICY CMP0054)
  cmake_policy(SET CMP0054 OLD)
endif()

set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/../ ${CMAKE_MODULE_PATH})
include(ExternalProjectDependency)

#
# cmake -DTEST__sb_cmakevar_to_cmakearg_test:BOOL=ON -P ArtichokeTest.cmake
#
function(_sb_cmakevar_to_cmakearg_test)
  function(check_test_result id current_output expected_output
      current_has_cfg_intdir expected_has_cfg_intdir
      current_varname expected_varname
      current_vartype expected_vartype)
    if(NOT "${current_output}" STREQUAL "${expected_output}")
      message(FATAL_ERROR "Problem with _sb_cmakevar_to_cmakearg() - See testcase: ${id}\n"
                          "current_output:${current_output}\n"
                          "expected_output:${expected_output}")
    endif()
    if(NOT "${current_has_cfg_intdir}" STREQUAL "${expected_has_cfg_intdir}")
      message(FATAL_ERROR "Problem with _sb_cmakevar_to_cmakearg() - See testcase: ${id}\n"
                          "current_has_cfg_intdir:${current_has_cfg_intdir}\n"
                          "expected_has_cfg_intdir:${expected_has_cfg_intdir}")
    endif()
    if(NOT "${current_varname}" STREQUAL "${expected_varname}")
      message(FATAL_ERROR "Problem with _sb_cmakevar_to_cmakearg() - See testcase: ${id}\n"
                          "current_varname:${current_varname}\n"
                          "expected_varname:${expected_varname}")
    endif()
    if(NOT "${current_vartype}" STREQUAL "${expected_vartype}")
      message(FATAL_ERROR "Problem with _sb_cmakevar_to_cmakearg() - See testcase: ${id}\n"
                          "current_vartype:${current_vartype}\n"
                          "expected_vartype:${expected_vartype}")
    endif()
  endfunction()

  function(check_variable id var_name expected_value)
    if(NOT "x${${var_name}}" STREQUAL "x${expected_value}")
      message(FATAL_ERROR "Problem with _sb_cmakevar_to_cmakearg() - See testcase: ${id}\n"
                          "CMake variable [${var_name}] has wrong value !\n"
                          "current:${${var_name}}\n"
                          "expected:${expected_value}")
    endif()
  endfunction()

  set(id 1)
  set(case${id}_input "Hello")
  set(case${id}_expected_varname "")
  set(case${id}_expected_vartype "")
  set(case${id}_expected_cmake_arg_var "-Dcase${id}_input:STRING=${case${id}_input}")
  set(case${id}_expected_has_cfg_intdir_var FALSE)
  _sb_cmakevar_to_cmakearg("case${id}_input:STRING"
      case${id}_cmake_arg_var case${id}_has_cfg_intdir_var
      )
  check_test_result(${id}
      "${case${id}_cmake_arg_var}" "${case${id}_expected_cmake_arg_var}"
      "${case${id}_has_cfg_intdir_var}" "${case${id}_expected_has_cfg_intdir_var}"
      "${case${id}_varname}" "${case${id}_expected_varname}"
      "${case${id}_vartype}" "${case${id}_expected_vartype}")
  check_variable(${id} case${id}_input "Hello")

  set(id 2)
  set(case${id}_input "Hello")
  set(case${id}_expected_varname "case${id}_input")
  set(case${id}_expected_vartype "STRING")
  set(case${id}_expected_cmake_arg_var "-Dcase${id}_input:STRING=${case${id}_input}")
  set(case${id}_expected_has_cfg_intdir_var FALSE)
  _sb_cmakevar_to_cmakearg("case${id}_input:STRING"
      case${id}_cmake_arg_var case${id}_has_cfg_intdir_var
      case${id}_varname case${id}_vartype)
  check_test_result(${id}
      "${case${id}_cmake_arg_var}" "${case${id}_expected_cmake_arg_var}"
      "${case${id}_has_cfg_intdir_var}" "${case${id}_expected_has_cfg_intdir_var}"
      "${case${id}_varname}" "${case${id}_expected_varname}"
      "${case${id}_vartype}" "${case${id}_expected_vartype}")
  check_variable(${id} case${id}_input "Hello")

  set(id 3)
  set(case${id}_input Hello World)
  set(case${id}_expected_varname "case${id}_input")
  set(case${id}_expected_vartype "STRING")
  set(case${id}_expected_cmake_arg_var "-Dcase${id}_input:STRING=${case${id}_input}")
  set(case${id}_expected_has_cfg_intdir_var FALSE)
  _sb_cmakevar_to_cmakearg("case${id}_input:STRING"
      case${id}_cmake_arg_var case${id}_has_cfg_intdir_var
      case${id}_varname case${id}_vartype)
  check_test_result(${id}
      "${case${id}_cmake_arg_var}" "${case${id}_expected_cmake_arg_var}"
      "${case${id}_has_cfg_intdir_var}" "${case${id}_expected_has_cfg_intdir_var}"
      "${case${id}_varname}" "${case${id}_expected_varname}"
      "${case${id}_vartype}" "${case${id}_expected_vartype}")
  check_variable(${id} case${id}_input "Hello;World")

  # Initialize case 4
  if(NOT CMAKE_CONFIGURATION_TYPES)
    set(CMAKE_CONFIGURATION_TYPES Release Debug)
    set(SAVED_CMAKE_CFG_INTDIR ${CMAKE_CFG_INTDIR})
    set(CMAKE_CFG_INTDIR "$(OutDir)")
  endif()

  set(id 4)
  set(case${id}_input Hello ${CMAKE_CFG_INTDIR})
  set(case${id}_expected_varname "case${id}_input")
  set(case${id}_expected_vartype "STRING")
  set(case${id}_expected_cmake_arg_var "-Dcase${id}_input:STRING=Hello^^${CMAKE_CFG_INTDIR}")
  set(case${id}_expected_has_cfg_intdir_var TRUE)
  _sb_cmakevar_to_cmakearg("case${id}_input:STRING"
      case${id}_cmake_arg_var case${id}_has_cfg_intdir_var
      case${id}_varname case${id}_vartype)
  check_test_result(${id}
      "${case${id}_cmake_arg_var}" "${case${id}_expected_cmake_arg_var}"
      "${case${id}_has_cfg_intdir_var}" "${case${id}_expected_has_cfg_intdir_var}"
      "${case${id}_varname}" "${case${id}_expected_varname}"
      "${case${id}_vartype}" "${case${id}_expected_vartype}")
  check_variable(${id} case${id}_input "Hello;${CMAKE_CFG_INTDIR}")

  # Finalize case 4
  if(NOT CMAKE_CONFIGURATION_TYPES)
    set(CMAKE_CFG_INTDIR ${SAVED_CMAKE_CFG_INTDIR})
    unset(SAVED_CMAKE_CFG_INTDIR)
    unset(CMAKE_CONFIGURATION_TYPES)
  endif()

  message("SUCCESS")
endfunction()
if(TEST__sb_cmakevar_to_cmakearg_test)
  _sb_cmakevar_to_cmakearg_test()
endif()

#
# cmake -DTEST__sb_extract_varname_and_vartype_test:BOOL=ON -P ArtichokeTest.cmake
#
function(_sb_extract_varname_and_vartype_test)
  function(check_test_result id current_varname expected_varname
      current_vartype expected_vartype)
    if(NOT "${current_varname}" STREQUAL "${expected_varname}")
      message(FATAL_ERROR "Problem with _sb_extract_varname_and_vartype() - See testcase: ${id}\n"
                          "current_varname:${current_varname}\n"
                          "expected_varname:${expected_varname}")
    endif()
    if(NOT "${current_vartype}" STREQUAL "${expected_vartype}")
      message(FATAL_ERROR "Problem with _sb_extract_varname_and_vartype() - See testcase: ${id}\n"
                          "current_vartype:${current_vartype}\n"
                          "expected_vartype:${expected_vartype}")
    endif()
  endfunction()

  set(id 1)
  set(case${id}_input "VAR:STRING")
  set(case${id}_expected_varname "VAR")
  set(case${id}_expected_vartype "STRING")
  _sb_extract_varname_and_vartype("${case${id}_input}"
      case${id}_varname case${id}_vartype)
  check_test_result(${id}
      "${case${id}_varname}" "${case${id}_expected_varname}"
      "${case${id}_vartype}" "${case${id}_expected_vartype}")

  set(id 2)
  set(case${id}_input "VAR:STRING")
  set(case${id}_expected_varname "VAR")
  set(case${id}_expected_vartype "")
  _sb_extract_varname_and_vartype("${case${id}_input}"
      case${id}_varname)
  check_test_result(${id}
      "${case${id}_varname}" "${case${id}_expected_varname}"
      "${case${id}_vartype}" "${case${id}_expected_vartype}")

  message("SUCCESS")
endfunction()
if(TEST__sb_extract_varname_and_vartype_test)
  _sb_extract_varname_and_vartype_test()
endif()

#
# cmake -DTEST__sb_list_to_string_test:BOOL=ON -P ArtichokeTest.cmake
#
function(_sb_list_to_string_test)

  function(_sb_list_to_string_test_check id current_output expected_output)
    if(NOT "${current_output}" STREQUAL "${expected_output}")
      message(FATAL_ERROR "Problem with _sb_list_to_string() - See testcase: ${id}\n"
                          "current_output:${current_output}\n"
                          "expected_output:${expected_output}")
    endif()
  endfunction()

  set(id 1)
  set(case${id}_input "")
  set(case${id}_expected_output "")
  _sb_list_to_string("^^" "${case${id}_input}" case${id}_current_output)
  _sb_list_to_string_test_check(${id} "${case${id}_current_output}" "${case${id}_expected_output}")

  set(id 2)
  set(case${id}_input item1)
  set(case${id}_expected_output "item1")
  _sb_list_to_string("^^" "${case${id}_input}" case${id}_current_output)
  _sb_list_to_string_test_check(${id} "${case${id}_current_output}" "${case${id}_expected_output}")

  set(id 3)
  set(case${id}_input item1 item2)
  set(case${id}_expected_output "item1^^item2")
  _sb_list_to_string("^^" "${case${id}_input}" case${id}_current_output)
  _sb_list_to_string_test_check(${id} "${case${id}_current_output}" "${case${id}_expected_output}")

  set(id 4)
  set(case${id}_input item1 item2 item3)
  set(case${id}_expected_output "item1^^item2^^item3")
  _sb_list_to_string("^^" "${case${id}_input}" case${id}_current_output)
  _sb_list_to_string_test_check(${id} "${case${id}_current_output}" "${case${id}_expected_output}")

  set(id 5)
  set(case${id}_input item1 item2 item3 item4)
  set(case${id}_expected_output "item1^^item2^^item3^^item4")
  _sb_list_to_string("^^" "${case${id}_input}" case${id}_current_output)
  _sb_list_to_string_test_check(${id} "${case${id}_current_output}" "${case${id}_expected_output}")

  set(id 6)
  set(case${id}_input item1 "" item3 item4)
  set(case${id}_expected_output "item1^^item3^^item4")
  _sb_list_to_string("^^" "${case${id}_input}" case${id}_current_output)
  _sb_list_to_string_test_check(${id} "${case${id}_current_output}" "${case${id}_expected_output}")

  set(id 7)
  set(case${id}_input item1 ^^item2 item3 item4)
  set(case${id}_expected_output "item1^^^^item2^^item3^^item4")
  _sb_list_to_string("^^" "${case${id}_input}" case${id}_current_output)
  _sb_list_to_string_test_check(${id} "${case${id}_current_output}" "${case${id}_expected_output}")

  set(id 8)
  set(case${id}_input item1 item2 item3 item4)
  set(case${id}_expected_output "item1item2item3item4")
  _sb_list_to_string("" "${case${id}_input}" case${id}_current_output)
  _sb_list_to_string_test_check(${id} "${case${id}_current_output}" "${case${id}_expected_output}")

  set(id 9)
  set(case${id}_input item1 item2 item3 item4)
  set(case${id}_expected_output "item1 item2 item3 item4")
  _sb_list_to_string(" " "${case${id}_input}" case${id}_current_output)
  _sb_list_to_string_test_check(${id} "${case${id}_current_output}" "${case${id}_expected_output}")

  message("SUCCESS")
endfunction()
if(TEST__sb_list_to_string_test)
  _sb_list_to_string_test()
endif()
