require("frameworks/utils")
local test = require("frameworks/u-test")

path = "K:/hidden-name/Teaching/2016_Lua/[Lab]/Lecture 04.pdf"

function unpath(path)
  local p = {}
  for s in path:gmatch("([^/]+)/") do p[#p+1] = s end
  p[#p+1] = {path:match("/([^/]+)%.([^.]+)$")}
  return p
end

print(tabtostring(unpath(path)))

test.one = function() 
    test.equal(tabtostring(unpath(path)),
               tabtostring( {"K:", "hidden-name", "Teaching", "2016_Lua","[Lab]", {"Lecture 04", "pdf"}}))
end