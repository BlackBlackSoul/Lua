--
-- Created by Tooster on 28.02.2018 00:14
--

function maxtab(tab)
    local next = next
    if next(tab) == nil then return nil end
    local _max
    local max = math.max
    for k, v in pairs(tab) do
      if _max == nil then
        _max = v
      else
        _max = math.max(_max, v) 
      end
    end
    return _max
end