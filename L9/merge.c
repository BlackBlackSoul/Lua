//
// Created by Tooster on 23.05.2018.
//

#include "lua.h"
#include "lauxlib.h"

// t1, t2 indexes of tables on stack
static inline void append_table(lua_State *L, int t1, int t2) {
    lua_pushnil(L); // begin t2 traversal
    while (lua_next(L, t2) != 0) { // [..., k, v]
        lua_pushvalue(L, -2); // [..., k, v, k]
        lua_gettable(L, t1); // [..., k, v, t1[k]]
        if (lua_isnil(L, -1)) { // t1[k] == nil
            lua_pop(L, 1); // pop t1[k]
            lua_pushvalue(L, -2); // [..., k, v, k]
            lua_insert(L, -2);  // [..., k, k, v]
            lua_settable(L, t1);  // t1[k] = v   [..., k]
        } else
            lua_pop(L, 2); // pop t1[k], v
    }
}

static int l_merge(lua_State *L) {
    int i = 0;
    while (lua_gettop(L) > 1) {
        if (!lua_istable(L, 2)) luaL_error(L, "Argument %d is not a table", i);
        append_table(L, 1, 2);
        lua_remove(L, 2);
        ++i;
    }
    return (lua_gettop(L) == 0 ? 0 : 1);
}

static const struct luaL_Reg merge[] = {
        {"merge", l_merge},
        {NULL, NULL}
};

int luaopen_merge(lua_State *L) {
    luaL_newlib(L, merge);
    return 1;
}