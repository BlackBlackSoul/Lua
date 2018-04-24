//
// Created by Tooster on 24.04.2018.
//

#ifndef LUA_STACKDUMP_HPP
#define LUA_STACKDUMP_HPP

#include "lua.hpp"
#include <iostream>

void stackDump(lua_State *L, std::ostream &out = std::cout) {
    out << "+-------+\n";
    out << "+ STACK \n";
    out << "+-------+-------+-------+--------\n";
    out << "| BOT\t| TOP\t| TYPE\t| VALUE\n";
    out << "+-------+-------+-------+--------\n";
    int top = lua_gettop(L);
    for (int i = top; i >= 1; --i) {
        out << "| " << i << " \t| " << -(top-i+1) << " \t| ";
        int t = lua_type(L, i);
        switch (t) {
            case LUA_TSTRING:
                out << "STR\t| " << "'" << lua_tostring(L, i) << "'";
                break;
            case LUA_TBOOLEAN:
                out << "BOOL\t| " << (lua_toboolean(L, i) ? "true" : "false");
                break;
            case LUA_TNUMBER:
                if (lua_isinteger(L, i)) out << "INT\t| " << lua_tointeger(L, i);
                else out << "NUM\t| " << lua_tonumber(L, i);
                break;
            case LUA_TFUNCTION:
                out << "FUN\t| " << lua_tocfunction(L, i);
                break;
            case LUA_TNIL:
                out << "NIL\t| " << "----";
                break;
            case LUA_TTABLE:
                out << "TAB\t| " << "----";
                break;
            case LUA_TNONE:
                out << "NONE\t| " << "----";
                break;
            default:
                out << lua_typename(L, t) << "\t ????";
                break;
        }
        out << "\n";
    }
    out << "+-------+-------+-------+--------\n";
    out.flush();
}

#endif //LUA_STACKDUMP_HPP
