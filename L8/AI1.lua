--
-- Created by CLion.
-- User: Tooster   Date: 09.05.2018   Time: 12:57
--

function wins(board)
    for i = 1, 7, 3 do if board[i][1] ~= ' ' and board[i][1] == board[i][2] and board[i][1] == board[i][3] then return board[i][1] end end
    for i = 1, 3 do if board[1][i] ~= ' ' and board[1][i] == board[2][i] and board[1][i] == board[3][i] then return board[1][i] end end
    if board[1][i] ~= ' ' and board[1][1] == board[2][2] and board[1][1] == board[3][3] then return board[1][1] end
    if board[1][3] ~= ' ' and board[1][3] == board[2][2] and board[1][3] == board[3][1] then return board[1][3] end
    return nil
end

function AI(me, board)
    local row
    local col

    for i = 1, 3 do
        for j = 1, 3 do
            if board[i][j] == ' ' then
                row = row or i
                col = col or j
            end
        end
    end
    return row, col
end