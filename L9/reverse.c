//
// Created by Tooster on 22.05.2018.
//

#include "lua.h"
#include "lauxlib.h"

static inline void swap_table(lua_State *L, int i, int j) {
    lua_geti(L, 1, i);
    lua_geti(L, 1, j);
    lua_seti(L, 1, i);
    lua_seti(L, 1, j);
}

static int l_reverse(lua_State *L) {
    if (!lua_istable(L, 1))
        luaL_error(L, "First argument must be a 1 argument lambda.");
    size_t n = lua_rawlen(L, 1);
    for (int i = 0; i < n / 2; ++i)
        swap_table(L, i + 1, (int) (n - i));
    return 1;
}

static const struct luaL_Reg reverse[] = {
        {"reverse", l_reverse},
        {NULL, NULL}
};

int luaopen_reverse(lua_State *L) {
    luaL_newlib(L, reverse);
    return 1;
}