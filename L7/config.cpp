
#include <lua.hpp>
#include "stackDump.hpp"

struct Character {
    std::string _name = "non";
    std::string _race = "non";
    std::string _class = "non";
    std::string _born = "non";
    float _height = 0;
    float _sarcasmFactor = 0;
    int _age = 0;
    std::string _eyes = "non";
    std::string _hair = "non";
    bool _hat = false;
    enum LANGS {
        HUMAN, ELVES, BEAST
    };
    bool _langs[3] = {false, false, false};
    std::string _staffName = "non";
};

void error(lua_State *L, const char *fmt, ...) {
    va_list argp;
    va_start(argp, fmt);
    vfprintf(stderr, fmt, argp);
    va_end(argp);
    stackDump(L, std::cerr);
    lua_close(L);
    exit(1);
}

void loadConfig(lua_State *L, const char *fname) {
    if (luaL_loadfile (L, fname) | lua_pcall (L, 0, 0, 0))
        error(L, "cannot load config: %s", lua_tostring (L, -1));
}

void loadPlayer(lua_State *L, Character *player) {

    loadConfig(L, "player_cfg.lua");

    enum TYPE {
        STR, NUM, INT, BOOL
    };
    auto pgetglobal = [=](std::string name, TYPE type, void *var) -> void {
        lua_getglobal(L, name.c_str());
        if ((type == STR && lua_type(L, -1) != LUA_TSTRING) ||
            (type == BOOL && lua_type(L, -1) != LUA_TBOOLEAN) ||
            (type == NUM && lua_type(L, -1) != LUA_TNUMBER) ||
            (type == INT && !lua_isinteger(L, -1)))
            error(L, (std::string("invalid field: ") + name).c_str());
        if (type == BOOL) *(bool *) var = (bool) lua_toboolean(L, -1);
        if (type == STR) *(std::string *) var = std::string(lua_tostring(L, -1));
        if (type == NUM) *(float *) var = (float) lua_tonumber(L, -1);
        if (type == INT) *(int *) var = (int) lua_tointeger(L, -1);
        lua_pop(L, -1);
    };

    pgetglobal("name", STR, &player->_name);
    pgetglobal("race", STR, &player->_race);
    pgetglobal("class", STR, &player->_class);
    pgetglobal("born", STR, &player->_born);
    pgetglobal("height", NUM, &player->_height);
    pgetglobal("sarcasmFactor", NUM, &player->_sarcasmFactor);
    pgetglobal("age", INT, &player->_age);
    pgetglobal("eyes", STR, &player->_eyes);
    pgetglobal("hair", STR, &player->_hair);
    pgetglobal("hat", BOOL, &player->_hat);
    pgetglobal("langHumans", BOOL, &player->_langs[0]);
    pgetglobal("langElves", BOOL, &player->_langs[1]);
    pgetglobal("langBeasts", BOOL, &player->_langs[2]);
    pgetglobal("staffName", STR, &player->_staffName);

}

void displayPlayer(Character *player) {
    std::cout << std::boolalpha;
    std::cout << "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-\n"
              << "| name:\t" << player->_name << "\n"
              << "| race:\t" << player->_race << "\n"
              << "| class:\t" << player->_class << "\n"
              << "| born:\t" << player->_born << "\n"
              << "| height:\t" << player->_height << "\n"
              << "| sarcasm factor:\t" << player->_sarcasmFactor << "\n"
              << "| age:\t" << player->_age << "\n"
              << "| eyes:\t" << player->_eyes << "\n"
              << "| hair:\t" << player->_hair << "\n"
              << "| hat:\t" << player->_hat << "\n"
              << "| languages:\n"
              << "| \thumans: \t" << player->_langs[Character::LANGS::HUMAN] << "\n"
              << "| \telves:  \t" << player->_langs[Character::LANGS::ELVES] << "\n"
              << "| \tbeasts: \t" << player->_langs[Character::LANGS::BEAST] << "\n"
              << "| staff name:\t" << player->_staffName << "\n"
              << "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-\n";
};

int main() {
    lua_State *L = luaL_newstate();
    luaL_openlibs(L);


    Character player;
    loadPlayer(L, &player);
    displayPlayer(&player);

    // modify state
    std::cout << "Set LVL to 45...\n";
    lua_pushinteger(L, 45); // push LVL 45
    lua_setglobal(L, "LVL");
    loadPlayer(L, &player);
    displayPlayer(&player);

    // modify again...
    std::cout << "Set LVL to 80...\n";
    lua_pushinteger(L, 80); // push LVL 45
    lua_setglobal(L, "LVL");
    loadPlayer(L, &player);
    lua_pushstring(L, "mighty stick");
    lua_setglobal(L, "staffName");
    lua_getglobal(L, "staffName");
    player._staffName = lua_tostring(L, -1);
    lua_pop(L, -1);
    displayPlayer(&player);
    stackDump(L);

    lua_close(L);
    return 0;
}