cmake_minimum_required(VERSION 3.8)
project(Lua)

set(CMAKE_C_STANDARD 11)

set(FOLDER L9)
add_executable(Lua ${FOLDER}/summation.c ${FOLDER}/reverse.c ${FOLDER}/merge.c ${FOLDER}/splitAt.c)

find_package(Lua 5.2 REQUIRED)
include_directories(${LUA_INCLUDE_DIR})
target_link_libraries(Lua ${LUA_LIBRARIES})


if (${LUA_VERSION_MINOR} LESS 3)
    message(ERROR "LUA VERSION BELOW 5.3... !")
endif ()

if (LUA_FOUND)
    message("Loaded Lua: ${LUA_VERSION_STRING}")
else ()
    message("Lua libraries: ${LUA_LIBRARIES}")
    message("Lua include dir: ${LUA_INCLUDE_DIR}")
endif ()

configure_file(${CMAKE_CURRENT_SOURCE_DIR}/frameworks/utils.lua frameworks/utils.lua COPYONLY)