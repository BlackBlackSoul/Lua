//
// Created by Tooster on 23.05.2018.
//

#include "lua.h"
#include "lauxlib.h"

static int l_splitAt(lua_State *L) {
    if (!lua_istable(L, 1))
        luaL_error(L, "First argument must be a 1 argument lambda.");
    return 1;
}

static const struct luaL_Reg splitAt[] = {
        {"splitAt", l_splitAt},
        {NULL, NULL}
};

int luaopen_splitAt(lua_State *L) {
    luaL_newlib(L, splitAt);
    return 1;
}