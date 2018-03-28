local min = math.min

iizip = function (t)
  t.it = t.it + 1
  local vars = {}
  for _, v in ipairs(t[1]) do
    if t.it > #v then return nil end
    vars[#vars + 1] = v[t.it]
  end
  return table.unpack(vars)
end
  
izip = function (...)
  return iizip, {{...}, it = 0}, 0
end

local test = require("frameworks.u-test")
print ("Two separate executions on different data:")
print (izip({1,2,3}, {4,5,6}))
print (izip({1,'x'}, {2, 'y',5}))

test.sameLength = function()
  local t = {'a', 'x', 'b', 'y', 'c', 'z'}
  local it = 1;
  for x, y in izip({'a','b','c'}, {'x','y','z'}) do
    test.equal(t[it], x); it = it + 1
    test.equal(t[it], y); it = it + 1
  end
  test.equal(it-1, #t)
end

test.differentLength1 = function()
  local t = {7, 'x', 8, 'y', 9, 'z'}
  local it = 1;
  for x, y in izip({7,8,9,10,11}, {'x','y','z'}) do
    test.equal(t[it], x); it = it + 1
    test.equal(t[it], y); it = it + 1
  end
  test.equal(it-1, #t)
end

test.differentLength2 = function()
  local t = {7, 'x', 8, 'y', 9, 'z'}
  local it = 1;
  for x, y in izip({7,8,9}, {'x','y','z','u'}) do
    test.equal(t[it], x); it = it + 1
    test.equal(t[it], y); it = it + 1
  end
  test.equal(it-1, #t)
end

test.oneEmpty = function()
  local t = {}
  local it = 1;
  for x, y in izip({}, {'x','y','z'}) do
    test.equal(t[it], x); it = it + 1
    test.equal(t[it], y); it = it + 1
  end
  test.equal(it-1, #t)
end

test.threeZip = function()
  local t = {1, 'x', 'a', 2, 'y', 'b', 3, 'z', 'c' }
  local it = 1;
  for x, y, z in izip({1,2,3}, {'x','y','z'},{'a','b','c'}) do
    test.equal(t[it], x); it = it + 1
    test.equal(t[it], y); it = it + 1
    test.equal(t[it], z); it = it + 1
  end
  test.equal(it-1, #t)
end
