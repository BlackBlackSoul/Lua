--
-- Created by CLion.
-- User: Tooster   Date: 23.05.2018   Time: 02:04
--

local A = require 'summation'
local B = require 'reverse'
local C = require 'merge'
--local D = require 'splitAt'

local function ttstr(t) return "{" .. table.concat(t, ",") .. "}" end

local function mtstr(m) local s = {} for k, v in pairs(m) do s[#s + 1] = k .. "=" .. tostring(v) end return ttstr(s) end

local t = { 1, 2, 3, 4, 5, 6, 10 }
print(A.summation(table.unpack(t)))
print(ttstr(B.reverse(t)))
print(mtstr(C.merge({ apple = 7, banana = 3 }, { apple = 2, orange = 11 }, { apple = 1, banana = 12, carrot = -1 })))
--print(ttstr(D.splitAt({1,2,3,4,5,6,7,8},3,5)))