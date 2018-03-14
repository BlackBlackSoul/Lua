--
-- Created by CLion.
-- User: Tooster   Date: 11.03.2018   Time: 16:24
--


string.split = function(str, w)
    w = w or " "
    local splits = {0}
    for i = 1, #str do
        if str:sub(i, i+#w-1) == w then
            splits[#splits+1] = i
        end
    end
    splits[#splits+1] = str:len()+1
    local tokens = {}
    for i=1, #splits-1 do
        tokens[#tokens+1] = str:sub(splits[i]+#w, splits[i+1]-1)
    end
    return tokens
end