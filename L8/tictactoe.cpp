//
// Created by Tooster on 08.05.2018.
//

#include "lua.hpp"
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
    if (luaL_loadfile (L, fname) || lua_pcall (L, 0, 0, 0))
        error(L, "Cannot load AI: %s.\n", lua_tostring (L, -1));
}

/// board in form abcdfghi where each letter is next cell
void printMove(string before, string after) {
    auto fmt = [](char x) -> string { return "[" + string(1, x) + "]"; };
    cout << fmt(before[0]) << fmt(before[1]) << fmt(before[2]) << "\t\t" << fmt(after[0]) << fmt(after[1])
         << fmt(after[2]) << "\n";
    cout << fmt(before[3]) << fmt(before[4]) << fmt(before[5]) << "\t~~>\t" << fmt(after[3]) << fmt(after[4])
         << fmt(after[5]) << "\n";
    cout << fmt(before[6]) << fmt(before[7]) << fmt(before[8]) << "\t\t" << fmt(after[6]) << fmt(after[7])
         << fmt(after[8]) << "\n" << endl;
}

/// gets 2 ret vals from function and modifies board
string nextState(lua_State *L, const string &player, string board) {
    // setup stack
    lua_getglobal(L, "AI");
    lua_pushstring(L, player.c_str()); // push player tag
    lua_createtable(L, 3, 0); // push new board table
    for (unsigned int i = 0; i < 3; ++i) {
        lua_createtable(L, 3, 0); // create row table on top of stack
        lua_pushstring(L, board.substr(i * 3 + 0, 1).c_str()); // 1st column
        lua_seti(L, -2, 1); // pops value from stack setting t[i] = v
        lua_pushstring(L, board.substr(i * 3 + 1, 1).c_str());
        lua_seti(L, -2, 2);
        lua_pushstring(L, board.substr(i * 3 + 2, 1).c_str());
        lua_seti(L, -2, 3);
        lua_seti(L, -2, i + 1); // row set and popped
    }

    // invoke AI method
    auto result = lua_pcall(L, 2, 2, 0);
    if (result != LUA_OK)
        error(L, "Error in AI function call for player '%s'.\n error msg: %s\n", player.c_str(), lua_tostring(L, -1));



    // deserialize state
    if (!lua_isnumber(L, -2) || !lua_isnumber(L, -1))
        error(L, "Error in AI function - return values must be two integers indicating row and column");

    lua_Integer row = lua_tointeger(L, -2) - 1;
    lua_Integer col = lua_tointeger(L, -1) - 1;
    lua_pop(L, 2);
    // setup next board

    if (row < 0 || row > 2 || col < 0 | col > 2 || board[3 * row + col] != ' ')
        error(L, "AI error: cannot place '%s' at row %d column %d", player.c_str(), row, col);

    board[3 * row + col] = player[0];
    return board;

}

string whoWon(const string &board) {
    for (unsigned int i = 0; i < 3; ++i) // horizontal
        if (board[3 * i + 0] != ' ' && board[3 * i + 0] == board[3 * i + 1] &&
            board[3 * i + 0] == board[3 * i + 2])
            return board.substr(3 * i, 1);
    for (unsigned int i = 0; i < 3; ++i) // vertical
        if (board[i] != ' ' && board[i] == board[i + 3] && board[i] == board[i + 6]) return board.substr(i, 1);
    if (board[0] != ' ' && board[0] == board[4] && board[0] == board[8]) return board.substr(0, 1);
    if (board[2] != ' ' && board[2] == board[4] && board[2] == board[6]) return board.substr(2, 1);
    return "";
}

int main() {
    lua_State *L1 = luaL_newstate();
    luaL_openlibs(L1);

    lua_State *L2 = luaL_newstate();
    luaL_openlibs(L2);

    string f1, f2;
    cout << "Input names of two *.lua files with tic-tac-toe AI function." << endl;
    cin >> f1 >> f2;

    loadConfig(L1, f1.c_str());
    loadConfig(L2, f2.c_str());


#define opponent(x) ((x) == "X" ? "O" : "X")

    string player = "X";
    string won;
    string board = "         ";
    int ctr = 9; // left
    while (ctr-- && won.empty()) { // 9 moves or until someone moves
        lua_State *L = (player == "X" ? L1 : L2);

        auto next_board = nextState(L, player, board);
        printMove(board, next_board);
        won = whoWon(next_board);
        if (!won.empty()) break;
        board = next_board;
        player = opponent(player);
    }
    if (won.empty()) cout << "TIE" << endl;
    else cout << "WON: " << player << endl;

    lua_close(L1);
    lua_close(L2);
    return 0;
}