#include "lua.h"
#include "lauxlib.h"

static int l_summation(lua_State *L) {
    lua_Number sum = 0;
    while (lua_gettop(L) > 0) {
        sum += luaL_checknumber(L, -1); // handles errors
        lua_pop(L, 1);
    }
    lua_pushnumber(L, sum);
    return 1;
}

static const struct luaL_Reg summation[] = {
        {"summation", l_summation},
        {NULL, NULL}
};

int luaopen_summation(lua_State *L) {
    luaL_newlib(L, summation);
    return 1;
}