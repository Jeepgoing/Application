
# Constructor with a directory-inferred name
macro(platform_library)
  platform_library_get_current_dir_lib_name(lib_name)
  platform_library_named(${lib_name})
endmacro()

# Determines what the current directory's lib name would be and writes
# it to the argument "lib_name"
macro(platform_library_get_current_dir_lib_name lib_name)
  file(RELATIVE_PATH name ${PLATFORM_BASE} ${CMAKE_CURRENT_LIST_FILE})

  get_filename_component(name ${name} DIRECTORY)

  string(REGEX REPLACE "/" "__" name ${name})

  set(${lib_name} ${name})
endmacro()

# Constructor with an explicitly given name.
macro(platform_library_named name)
  # This is a macro because we need add_library() to be executed
  # within the scope of the caller.
  set(PLATFORM_CURRENT_LIBRARY ${name})
  add_library(${name} STATIC "")

  platform_append_cmake_library(${name})

  target_link_libraries(${name} PUBLIC platform_interface)
endmacro()

function(platform_append_cmake_library library)
    set_property(GLOBAL APPEND PROPERTY PLATFORM_LIBS ${library})
endfunction()

# https://cmake.org/cmake/help/latest/command/target_include_directories.html
function(platform_include_directories)
  foreach(arg ${ARGV})
    if(IS_ABSOLUTE ${arg})
      set(path ${arg})
    else()
      set(path ${CMAKE_CURRENT_SOURCE_DIR}/${arg})
    endif()
    target_include_directories(platform_interface INTERFACE ${path})
  endforeach()
endfunction()

# https://cmake.org/cmake/help/latest/command/target_compile_options.html
function(platform_compile_options)
  target_compile_options(platform_interface INTERFACE ${ARGV})
endfunction()

# 2.2 Misc
#
# Parse a KConfig formatted file (typically named *.config) and
# introduce all the CONF_ variables into the CMake namespace
function(import_kconfig config_file)
  # Parse the lines prefixed with CONFIG_ in ${config_file}
  file(
    STRINGS
    ${config_file}
    DOT_CONFIG_LIST
    REGEX "^CONFIG_"
    ENCODING "UTF-8"
  )

  foreach (CONFIG ${DOT_CONFIG_LIST})
    # CONFIG looks like: CONFIG_NET_BUF=y

    # Match the first part, the variable name
    string(REGEX MATCH "[^=]+" CONF_VARIABLE_NAME ${CONFIG})

    # Match the second part, variable value
    string(REGEX MATCH "=(.+$)" CONF_VARIABLE_VALUE ${CONFIG})
    # The variable name match we just did included the '=' symbol. To just get the
    # part on the RHS we use match group 1
    set(CONF_VARIABLE_VALUE ${CMAKE_MATCH_1})

    if("${CONF_VARIABLE_VALUE}" MATCHES "^\"(.*)\"$") # Is surrounded by quotes
      set(CONF_VARIABLE_VALUE ${CMAKE_MATCH_1})
    endif()

    set("${CONF_VARIABLE_NAME}" "${CONF_VARIABLE_VALUE}" PARENT_SCOPE)
  endforeach()
endfunction()

