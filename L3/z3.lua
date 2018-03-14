--
-- Created by CLion.
-- User: Tooster   Date: 11.03.2018   Time: 01:24
--

utf8.normalize = function(str)
    local it = 1
    local ret = {}
    for _, v in ipairs(table.pack(utf8.codepoint(str, 1, -1))) do
        if v < 128 then
            ret[it] = v
            it = it + 1
        end
    end
    return string.char(table.unpack(ret))
end