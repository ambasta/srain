find_program(GLIB_COMPILE_RESOURCES_EXECUTABLE NAMES glib-compile-resources)
mark_as_advanced(GLIB_COMPILE_RESOURCES_EXECUTABLE)

include(CMakeParseArguments)

function(GLIB_COMPILE_RESOURCES output)
  cmake_parse_arguments(ARGS
                        ""
                        ""
                        "SOURCE"
                        ${ARGN})
  set(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR})
  set(out_files "")

  foreach(src ${ARGS_SOURCE} ${ARGS_UNPARSED_ARGUMENTS})
    set(in_file "${CMAKE_CURRENT_SOURCE_DIR}/${src}")
    get_filename_component(WORKING_DIR ${in_file} PATH)
    string(REPLACE ".xml"
                   ".c"
                   src
                   ${src})
    set(out_file "${DIRECTORY}/${src}")
    get_filename_component(OUTPUT_DIR ${out_file} PATH)
    file(MAKE_DIRECTORY ${OUTPUT_DIR})
    list(APPEND out_files "${DIRECTORY}/${src}")

    execute_process(COMMAND ${GLIB_COMPILE_RESOURCES_EXECUTABLE}
                            "--generate-dependencies" ${in_file}
                    WORKING_DIRECTORY ${WORKING_DIR}
                    OUTPUT_VARIABLE in_file_dep)
    string(REGEX
           REPLACE "(\r?\n)"
                   ";"
                   in_file_dep
                   "${in_file_dep}")
    set(in_file_dep_path "")
    foreach(dep ${in_file_dep})
      list(APPEND in_file_dep_path "${WORKING_DIR}/${dep}")
    endforeach(dep ${in_file_dep})

    message("Adding custom command ${GLIB_COMPILE_RESOURCES_EXECUTABLE}")
    add_custom_command(OUTPUT ${out_file}
                       WORKING_DIRECTORY ${WORKING_DIR}
                       COMMAND ${GLIB_COMPILE_RESOURCES_EXECUTABLE}
                               ARGS
                               "--generate-source"
                               "--target=${out_file}"
                               ${in_file}
                       DEPENDS ${in_file};${in_file_dep_path})
    message("Outputs ${out_file}")
  endforeach(src ${ARGS_SOURCE} ${ARGS_UNPARSED_ARGUMENTS})
  set(${output} ${out_files} PARENT_SCOPE)
endfunction(GLIB_COMPILE_RESOURCES output)
