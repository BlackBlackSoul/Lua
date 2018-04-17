local fractions = require("L6/fraction")

local f1 = fractions(1,2)
local f2 = fractions(2,3)

local x = getmetatable(f1)

print(f1+f2)
print(f1-f2)
print(f1*f2)
print(f1/f2)
print(f1^2)

print(f1+10.0)
print(f1-10.0)
print(f1*10.0)
print(f1/10.0)
print(f1^2)

print(fractions.toFloat(f1))

print(fractions.toFrac(120.123))