local Vector = require("L6/vector_t")
local test = require("frameworks/u-test")

local a = Vector{1, 2, 3}
local b = Vector.expand(3, 3)
local c = a+b
local d = Vector(b)
print(a*b)
print("|a "..a.." a|b "..b.." b|c "..c.." c|")

for k, v in ipairs(Vector{1,23,2,7,9,3,1}) do print(k, '->' ,v) end

test.equality = function () 
  test.not_equal(a, b)
  test.equal(Vector.expand(0, 3), Vector{0,0,0})
end

test.access = function () 
  local a = Vector{3,4,5,6}
  a[3] = 12
  test.equal(a[3], 12)
end

test.norm = function () 
  test.equal(#Vector{4,3}, 5)
end

test.unm = function () 
  local a = Vector{3,4,5,6}
  test.equal(-a, Vector{-3,-4,-5,-6})
end

test.add = function () 
  local a = Vector{3,4,5,6}
  test.equal(a+5, Vector{8,9,10,11})
  test.equal(a+5, 5+a)
end

test.mul = function () 
  local a = Vector{3,4,5,6}
  test.equal(a*5, Vector{15,20,25,30})
  test.equal(a*5, 5*a)
end

test.div = function () 
  local a = Vector{2,4,6,8}
  test.equal(a/2, Vector{1,2,3,4})
  test.equal(a/2, a/Vector{2,2,2,2})
end

test.tostring = function ()
  local a = Vector{2,3}
  test.equal(tostring(a), "{2, 3}")
end