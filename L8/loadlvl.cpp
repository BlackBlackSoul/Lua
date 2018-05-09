//
// Created by Tooster on 08.05.2018.
//

#include <lua.hpp>
#include "../L7/stackDump.hpp"

using namespace std;

void error(lua_State *L, const char *fmt, ...) {
    va_list argp;
    va_start(argp, fmt);
    vfprintf(stderr, fmt, argp);
    va_end(argp);
    lua_close(L);
    exit(1);
}

void loadConfig(lua_State *L, const char *fname) {
    if (luaL_loadfile (L, fname) | lua_pcall (L, 0, 0, 0))
        error(L, "cannot load config: %s", lua_tostring (L, -1));
}

/// @note Name must start with 'level_'.
int display_level(lua_State *L, string name) {

    auto invalid_level = [L, &name]() -> void { error(L, "Invalid level: '%s'\n", name.substr(6).c_str()); };
    lua_getglobal(L, name.c_str());
    if (lua_isnil(L, -1)) return 1;
    if (!lua_istable(L, -1)) invalid_level();

    lua_pushnil(L); // key for row traversal
    while (lua_next(L, -2) != 0) { // pushes key and value to -2 and -1
        if (!lua_istable(L, -1))
            invalid_level();

        lua_pushnil(L); // column traversal, row at -2, key -1
        while (lua_next(L, -2) != 0) { // key -2 value -1
            if (!lua_isstring(L, -1))
                invalid_level();
            cout << "[" << lua_tostring(L, -1) << "]\t";
            lua_pop(L, 1); // pop value, key = -1
        }
        cout << endl;
        lua_pop(L, 1); // pop row, key = -1
    }
    lua_pop(L, 1);
    return 0;
}

int main() {
    lua_State *L = luaL_newstate();
    luaL_openlibs(L);

    loadConfig(L, "levels.lua");
    do {
        cout << "Enter name to display, '*ALL' for all or Ctrl+D to end" << endl;
        string name;
        cin >> name;
        if (cin.eof()) break;
        if (name == "*ALL") {
            lua_pushglobaltable(L);
            lua_pushnil(L);
            while (lua_next(L, -2) != 0) { // traverse globals
                name = lua_tostring(L, -2);
                lua_pop(L, 1);
                if (name.length() > 6 && name.compare(0, 6, "level_") == 0) {
                    cout << name << ":" << endl;
                    display_level(L, name);
                }
            }
            lua_pop(L, 1);

        } else if (display_level(L, "level_" + name))
            cout << "Map '" << name << "' not present in config file." << endl;

        cout.flush();
    } while (true);


    lua_close(L);
    return 0;
}