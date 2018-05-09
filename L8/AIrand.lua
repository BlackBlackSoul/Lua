--
-- Created by CLion.
-- User: Tooster   Date: 08.05.2018   Time: 23:50
--

--local function opponent(me) if me == 'X' then return 'O' end return 'X' end
--

math.randomseed(os.time())
local function rng() return math.random(3) end

AI = function(mysymbol, board)
    while true do
        local x, y = rng(), rng()
        if board[x][y] == ' ' then
            return x, y
        end
    end
end