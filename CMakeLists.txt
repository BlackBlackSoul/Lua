cmake_minimum_required(VERSION 3.8)
project(Lua)

set(CMAKE_CXX_STANDARD 11)

add_executable(Lua L7/config.cpp)

find_package(Lua 5.3 REQUIRED)
include_directories(${LUA_INCLUDE_DIR})
target_link_libraries(Lua ${LUA_LIBRARIES})


if (${LUA_VERSION_MINOR} LESS 3)
    message(ERROR "LUA VERSION BELOW 5.3... !")
endif ()

if(LUA_FOUND)
    message("Loaded Lua: ${LUA_VERSION_STRING}")
else()
    message("Lua libraries: ${LUA_LIBRARIES}")
    message("Lua include dir: ${LUA_INCLUDE_DIR}")
endif()

configure_file(${CMAKE_CURRENT_SOURCE_DIR}/L7/player_cfg.lua player_cfg.lua COPYONLY)