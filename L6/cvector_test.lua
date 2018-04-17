local CVector = require("L6/cvector")
local test = require("frameworks/u-test")

local a = CVector{7,8,nil,9}
local b = CVector(a)
local c = CVector{1,2,3}

for k, v in ipairs(a) do print ("ipairs: a["..k.."]=", v) end

print("at: a[1]=", a:at(1))
print(a)
print(c)

test.outOfBoundsError = function() 
  local a = CVector{1}
  test.equal(pcall(a.__index, a, -1), false)
  test.equal(pcall(a.__index, a, 0), true)
  test.equal(pcall(a.__index, a, 1), false)
end

test.clearAndEmpty = function()
  local a = CVector{1,2,3}
  test.equal(a:empty(), false)
  local elems = 0
  a:clear()
  test.equal(a:size(), 0)
  for k, v in ipairs(a) do lems = elems + 1 end
  test.equal(elems, 0)
  test.equal(a:empty(), true)
end

test.erase = function() 
  local a = CVector{1,2,3,4,5}
  a:erase(1,2)
  test.equal(a[1], 3)
  test.equal(a:size(), 4)
  a:erase(2)
  test.equal(a:size(), 2)
  test.equal(a[1], 3)
end

test.insert = function ()
  local t = CVector{'a', 'b', 'c'}
  local x = CVector{9,9}
  t:insert(3, {'x', 'x'})
  t:insert(0, x)
  t:insert(2, {1,2,3})
  t:insert(3, 3)
  test.equal("{9, 9, 1, 3, 2, 3, a, b, c, x, x}", tostring(t))
end

test.push_pop_front_back = function ()
  local t = CVector{}
  t:push_back(1)
  t:push_back(2)
  t:push_back(7)
  t:push_back(8)
  t:push_back(13)
  test.equal(t:size(), 5)
  test.equal(t:pop_back(), 13)
  test.equal(t:pop_back(), 8)
  test.equal(tostring(t), "{1, 2, 7}")
  test.equal(t:front(), 1)
  test.equal(t:back(), 7)
  t:pop_back();t:pop_back();t:pop_back()
  test.equal(pcall(t.pop_back, t),false) -- error on pop
  t:push_back(nil);
  test.is_nil(t[0])
end

test.concat = function ()
  local a = CVector{1,2,3}
  local b = CVector{7,8,9}
  test.equal(tostring(a..b), "{1, 2, 3, 7, 8, 9}")
end

---[[ nasty debugger bug, gotta fix the stringify_results
test.len = function ()
  local a = CVector{9,8,7}
  test.equal(#a, 3)
  test.equal(7, a[#a-1])
end
--]]
