project(Platform)
enable_language(C CXX ASM)

add_library(platform_interface INTERFACE)

#platform_library_named(zephyr)

platform_include_directories(
  include
  ${PROJECT_BINARY_DIR}/include/generated
)

# We need to set an optimization level.
# Default to -Os
# unless CONFIG_NO_OPTIMIZATIONS is set, then it is -O0
# or unless CONFIG_DEBUG is set, then it is -Og
#
# also, some toolchain's break with -Os, and some toolchain's break
# with -Og so allow them to override what flag to use
#
# Finally, the user can use Kconfig to add compiler options that will
# come after these options and override them
set(OPTIMIZE_FOR_NO_OPTIMIZATIONS_FLAG "-O0")
set(OPTIMIZE_FOR_DEBUG_FLAG            "-Og")
set(OPTIMIZE_FOR_SIZE_FLAG             "-Os")
set(OPTIMIZE_FOR_SPEED_FLAG            "-O2")

if(CONFIG_NO_OPTIMIZATIONS)
  set(OPTIMIZATION_FLAG ${OPTIMIZE_FOR_NO_OPTIMIZATIONS_FLAG})
elseif(CONFIG_DEBUG_OPTIMIZATIONS)
  set(OPTIMIZATION_FLAG ${OPTIMIZE_FOR_DEBUG_FLAG})
elseif(CONFIG_SPEED_OPTIMIZATIONS)
  set(OPTIMIZATION_FLAG ${OPTIMIZE_FOR_SPEED_FLAG})
else()
  set(OPTIMIZATION_FLAG ${OPTIMIZE_FOR_SIZE_FLAG}) # Default
endif()

platform_compile_options(
  ${OPTIMIZATION_FLAG} # Usually -Os
  -g # TODO: build configuration enough?
  -Wall
  -Wformat
  -Wformat-security
  -Wno-format-zero-length
  -imacros ${AUTOCONF_H}
  -ffreestanding
  -Wno-main
  ${NOSTDINC_F}
  ${TOOLCHAIN_C_FLAGS}
)

add_subdirectory(components)
add_subdirectory(lib)
add_subdirectory(subsys)

# Read list content
get_property(PLATFORM_LIBS_PROPERTY GLOBAL PROPERTY PLATFORM_LIBS)

foreach(platform_lib ${PLATFORM_LIBS_PROPERTY})
  add_dependencies(${platform_lib} offsets_h)

  get_target_property(lib_imported ${platform_lib} IMPORTED)
  get_target_property(lib_sources  ${platform_lib} SOURCES)
  if(lib_sources STREQUAL lib_sources-NOTFOUND
      AND (NOT (${platform_lib} STREQUAL app))
      AND (NOT lib_imported)
      )
    # app is not checked because it's sources are added to it after
    # this CMakeLists.txt file has been processed
    message(FATAL_ERROR "\
The Platform library '${platform_lib}' was created without source files.")
  endif()
endforeach()

