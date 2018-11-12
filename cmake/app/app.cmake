# CMake version 3.8.2 is the real minimum supported version.
#
# Unfortunately CMake requires the toplevel CMakeLists.txt file to
# define the required version, not even invoking it from an included
# file, like boilerplate.cmake, is sufficient. It is however permitted
# to have multiple invocations of cmake_minimum_required.
#
# Under these restraints we use a second 'cmake_minimum_required'
# invocation in every toplevel CMakeLists.txt.
cmake_minimum_required(VERSION 3.5)

set(APPLICATION_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR} CACHE PATH "Application Source Directory")
set(APPLICATION_BINARY_DIR ${CMAKE_CURRENT_BINARY_DIR} CACHE PATH "Application Binary Directory")

set(__build_dir ${CMAKE_CURRENT_BINARY_DIR}/platform)

set(PROJECT_BINARY_DIR ${__build_dir})
set(PROJECT_SOURCE_DIR $ENV{PLATFORM_BASE})

set(PLATFORM_BINARY_DIR ${PROJECT_BINARY_DIR})
set(PLATFORM_BASE ${PROJECT_SOURCE_DIR})

set(AUTOCONF_H ${__build_dir}/include/generated/autoconf.h)
# Re-configure (Re-execute all CMakeLists.txt code) when autoconf.h changes
set_property(DIRECTORY APPEND PROPERTY CMAKE_CONFIGURE_DEPENDS ${AUTOCONF_H})

include(${PLATFORM_BASE}/cmake/extensions.cmake)
include(${PLATFORM_BASE}/cmake/kconfig.cmake)
include(${PLATFORM_BASE}/cmake/toolchain.cmake)

platform_executable(app)

add_subdirectory(${PLATFORM_BASE} ${__build_dir})

get_property(PLATFORM_LIBS_PROPERTY GLOBAL PROPERTY PLATFORM_LIBS)
foreach(platform_lib ${PLATFORM_LIBS_PROPERTY})
  target_link_libraries(app PUBLIC ${platform_lib})
endforeach()



