# Fuses all target .cc sources in a single file.
#-----------------------------------------------

function(fuse_target _target_name)

  set(output_file_name "${_target_name}.cc")
  set(output_file "${PROJECT_BINARY_DIR}/src_fused/${output_file_name}")

  # Get all target sources.
  get_property(target_source_files TARGET ${_target_name} PROPERTY SOURCES)

  foreach(src_file ${target_source_files})
    if(IS_ABSOLUTE ${src_file})
        file(RELATIVE_PATH src_file ${CMAKE_CURRENT_LIST_DIR} ${src_file})
    endif()
    list(APPEND relative_target_source_files ${src_file})
  endforeach()

  add_custom_command(
    OUTPUT ${output_file}
    DEPENDS ${target_source_files}
            ${PROJECT_SOURCE_DIR}/build-utils/cmake/fuse_target_script.cmake
    COMMAND ${CMAKE_COMMAND} -Dozz_fuse_output_file="${output_file}" -Dozz_target_source_files="${relative_target_source_files}" -Dozz_fuse_target_dir="${CMAKE_CURRENT_LIST_DIR}" -Dozz_fuse_src_dir="${PROJECT_SOURCE_DIR}" -P "${PROJECT_SOURCE_DIR}/build-utils/cmake/fuse_target_script.cmake")

  add_custom_target(BUILD_FUSE_${_target_name} ALL DEPENDS ${output_file})
  set_target_properties(BUILD_FUSE_${_target_name} PROPERTIES FOLDER "NauEngine/3rdparty/ozz/fuse")

  if (NOT TARGET BUILD_FUSE_ALL)
    add_custom_target(BUILD_FUSE_ALL ALL)
    set_target_properties(BUILD_FUSE_ALL PROPERTIES FOLDER "NauEngine/3rdparty/ozz/fuse")
  endif()

  add_dependencies(BUILD_FUSE_ALL BUILD_FUSE_${_target_name})

endfunction()
