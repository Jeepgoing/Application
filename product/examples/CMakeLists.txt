cmake_minimum_required(VERSION 3.5)

include($ENV{PLATFORM_BASE}/cmake/app/app.cmake NO_POLICY_SCOPE)
project(hello_world)

target_sources(app PRIVATE src/main.c)

target_link_libraries(app PUBLIC /usr/lib/libEGL.so)
target_link_libraries(app PUBLIC /usr/lib/libGLESv2.so)

