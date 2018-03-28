chain = function (...)
  return function (t) 
    while t.j > #t[1][t.i] do 
      t.i = t.i+1; t.j = 1 
      if t.i > #t[1] then 
        return nil
      end
    end
    t.j = t.j+1
    return t[1][t.i][t.j-1]
  end, {{...}, i=1, j=1}, 0
end

local test = require("frameworks.u-test")
print ("Two separate executions on different data:")
print (chain({1,2,3}, {4,5,6}, {'a','b'}))
print (chain({1,2,3}))

test.continous = function ()
  local t = {1,2,3,4,5,6,'a','b'}
  local it = 1;
  for x in chain({1,2,3}, {4,5,6}, {'a','b'}) do
    test.equal(x, t[it])
    it = it + 1
  end
end


test.emptySeqs = function ()
  local t = {'a', 'b', 'c', 40, 50, 6, 7}
  local it = 1;
  for x in chain({'a', 'b', 'c'}, {40, 50}, {}, {6, 7}) do
    test.equal(x, t[it])
    it = it + 1
  end
end

test.emptySeqsMultiple = function ()
  local t = {5,4,3,2,1}
  local it = 1;
  for x in chain({5,4,3}, {}, {}, {2}, {}, {1}) do
    test.equal(x, t[it])
    it = it + 1
  end
end
