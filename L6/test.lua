local fractions = require("L6/fraction")
require("math")

local f1 = fractions.new(1,2)
local f2 = fractions.new(2,3)

print(math.modf(5,3))
print(f1+f2)