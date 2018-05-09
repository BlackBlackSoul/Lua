--
-- Created by CLion.
-- User: Tooster   Date: 09.05.2018   Time: 12:57
--


local function opponent(x) if x == 'X' then return 'O' else return 'X' end end

local function wins(board)
    for i = 1, 3 do if board[i][1] ~= ' ' and board[i][1] == board[i][2] and board[i][1] == board[i][3] then return board[i][1] end end
    for i = 1, 3 do if board[1][i] ~= ' ' and board[1][i] == board[2][i] and board[1][i] == board[3][i] then return board[1][i] end end
    if board[1][i] ~= ' ' and board[1][1] == board[2][2] and board[1][1] == board[3][3] then return board[1][1] end
    if board[1][3] ~= ' ' and board[1][3] == board[2][2] and board[1][3] == board[3][1] then return board[1][3] end
    return nil
end

local function fitness(me, board, row, col)
    board[row][col] = me
    local val = 0;
    local winner = wins(board)
    if winner == me then val = 1 elseif winner == opponent(me) then val = -1 end

    for i = 1, 3 do
        for j = 1, 3 do
            if board[i][j] == ' ' then val = val - 0.1 * fitness(opponent(me), board, i, j) end
        end
    end

    board[row][col] = ' '
    return val
end

function AI(me, board)
    local row
    local col
    local val = 0

    for i = 1, 3 do
        for j = 1, 3 do
            if board[i][j] == ' ' then
                row = row or i
                col = col or j
                f = fitness(me, board, i, j)
                if f > val then
                    val = f
                    row = i
                    col = j
                end
            end
        end
    end
    return row, col
end

print(fitness('X', {
    { ' ', ' ', ' ' },
    { ' ', ' ', ' ' },
    { ' ', ' ', ' ' }
}, 0, 0))