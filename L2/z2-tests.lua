--
-- TESTS
-----------

local test = require "uwr/Lua/frameworks/u-test"
require "uwr/Lua/L2/z2"

function compareTabs(t1, t2)
  for i, v in pairs(t1) do if t2[i] == nil or v ~= t2[i] then return false end end
  for i, v in pairs(t2) do if t1[i] == nil or v ~= t1[i] then return false end end
  return true
end

test.empty = function () 
  ret, ix = isseq({})
  test.equal(ret, false)
  test.equal(compareTabs(ix, {}), true)
end

test.singleSeq = function ()
  seq = {1,2,3,4,5}
  ret, ix = isseq(seq)
  test.equal(ret, true)
  test.equal(compareTabs(ix, {5}), true)
end

test.multiSeqDifferentTypes = function ()
  seq = {1,nil,3,4,nil,6,7,'a', {1,2,nil}, 10, nil, -1}
  ret, ix = isseq(seq)
  test.equal(ret, false)
  test.equal(compareTabs(ix, {1,4,10,12}), true)
end

test.nullSeq = function ()
  seq = {nil,nil,nil}
  ret, ix = isseq(seq)
  test.equal(ret, false)
  test.equal(compareTabs(ix, {}), true)
end

test.nullStartingContinSeq = function ()
  seq = {nil,-2,-3,-4,-5,-5,-7,-8,-9}
  ret, ix = isseq(seq)
  test.equal(ret, false)
  test.equal(compareTabs(ix, {9}), true)
end

test.nullStartingMuliSeq = function ()
  seq = {nil,-2,-3,nil,nil,-5,-7,-8,nil,nil}
  ret, ix = isseq(seq)
  test.equal(ret, false)
  test.equal(compareTabs(ix, {3,8}), true)
end

test.paramListSeq = function ()
  ret, ix = isseq(7)
  test.equal(ret, true)
  test.equal(compareTabs(ix, {1}), true)
end

test.paramListContinuesSeq = function ()
  ret, ix = isseq(7,8,2,1,2)
  test.equal(ret, true)
  test.equal(compareTabs(ix, {5}), true)
end

test.paramListMultiSeq = function ()
  ret, ix = isseq(1,2,3,nil,5,6,nil,8,nil)
  test.equal(ret, false)
  test.equal(compareTabs(ix, {3,6,8}), true)
end

test.nullStartingParamListSeq = function ()
  ret, ix = isseq(nil,nil,1,2,3,nil,5,6,nil,8,nil)
  test.equal(ret, false)
  test.equal(compareTabs(ix, {5,8,10}), true)
end

test.tableStartingParamListSeq = function ()
  ret, ix = isseq({1,2,3},2,3,nil,5,6,nil,8,nil)
  test.equal(ret, false)
  test.equal(compareTabs(ix, {3,6,8}), true)
end

test.summary()
