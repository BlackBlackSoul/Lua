//
// Created by Tooster on 23.05.2018.
//

#include "lua.h"
#include "lauxlib.h"

static int l_splitAt(lua_State *L) {
    if (!lua_istable(L, 1))
        luaL_error(L, "First argument must be a table.");
    size_t n = lua_rawlen(L, 1);
    for (int elem = 2, it = 1; elem <= lua_gettop(L); elem++) { // <= ? < ?
        lua_newtable(L);
        int tab = lua_gettop(L); // table on stack
        lua_Integer m = lua_tointeger(L, elem); // number of elements for table
        for (int i = 1; i <= m && it <= n; ++i, ++it) {
            lua_geti(L, 1, it);
            lua_seti(L, tab, i);
        }
    }
    return (int) n;
}

static const struct luaL_Reg splitAt[] = {
        {"splitAt", l_splitAt},
        {NULL, NULL}
};

int luaopen_splitAt(lua_State *L) {
    luaL_newlib(L, splitAt);
    return 1;
}