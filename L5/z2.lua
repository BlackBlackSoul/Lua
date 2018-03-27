local min = math.min

zip = function (t1, t2)
  return function (t, i)
    t.it = t.it + 1
    if t.it > min(#t[1], #t[2]) then return nil end
    return t[1][t.it], t[2][t.it]
  end, {t1, t2, it = 0}
end

local test = require("frameworks.u-test")
print ("Two separate executions on different data:")
print (zip({1,2,3}, {4,5,6}))
print (zip({1,'x'}, {2, 'y',5}))

test.sameLength = function()
  local t = {'a', 'x', 'b', 'y', 'c', 'z'}
  local it = 1;
  for x, y in zip({'a','b','c'}, {'x','y','z'}) do
    test.equal(t[it], x); it = it + 1
    test.equal(t[it], y); it = it + 1
  end
end

test.differentLength1 = function()
  local t = {7, 'x', 8, 'y', 9, 'z'}
  local it = 1;
  for x, y in zip({7,8,9,10,11}, {'x','y','z'}) do
    test.equal(t[it], x); it = it + 1
    test.equal(t[it], y); it = it + 1
  end
end

test.differentLength2 = function()
  local t = {7, 'x', 8, 'y', 9, 'z'}
  local it = 1;
  for x, y in zip({7,8,9}, {'x','y','z','u'}) do
    test.equal(t[it], x); it = it + 1
    test.equal(t[it], y); it = it + 1
  end
end

test.oneEmpty = function()
  local t = {}
  local it = 1;
  for x, y in zip({}, {'x','y','z'}) do
    test.equal(t[it], x); it = it + 1
    test.equal(t[it], y); it = it + 1
  end
end

