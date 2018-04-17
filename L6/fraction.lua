
local Frac = {mt={}}

local abs = math.abs
local modf = math.modf
local floor = math.floor 
local precision = 30
local FMT = {}
FMT.__call = function (_, ...)
  return Frac.new(...)
end
setmetatable(Frac, FMT)

function Frac.new(num, den) 
    if den == 0 then error "denominator cannot be 0" end
    local frac = {num = num,den = den}
    setmetatable(frac, Frac.mt)
    return Frac.normalize(frac)
end

Frac.mt.__unm = function (f1)
    f1 = Frac.toFrac(f1)
    f1.num = f1.num*(-1)
    return f1
end

Frac.mt.__add = function (f1, f2)
  f1 = Frac.toFrac(f1)
  f2 = Frac.toFrac(f2)
  return Frac(f1.num*f2.den + f2.num*f1.num, f1.den*f2.den)
end

Frac.mt.__sub = function (f1, f2) 
  f1 = Frac.toFrac(f1)
  f2 = Frac.toFrac(f2)
  return f1+(-f2) end

Frac.mt.__mul = function (f1, f2)
  f1 = Frac.toFrac(f1)
  f2 = Frac.toFrac(f2)
  return Frac(f1.num*f2.num, f1.den*f2.den)
end

Frac.mt.__div = function (f1, f2)
  f1 = Frac.toFrac(f1)
  f2 = Frac.toFrac(f2)
  f2.num, f2.den = f2.den, f2.num
  return f1*f2
end

Frac.mt.__tostring = function (f1)  
  f1 = Frac.toFrac(f1)
  return (f1.num).."/"..(f1.den) 
end

Frac.mt.__eq = function(f1, f2)  
  f1 = Frac.toFrac(f1)
  f2 = Frac.toFrac(f2)
  return f1.num == f2.num and f1.den == f2.den end

Frac.mt.__lt = function(f1, f2)  
  f1 = Frac.toFrac(f1)
  f2 = Frac.toFrac(f2)
  return f1.num*f2.den < f2.num*f1.den end

Frac.mt.__le = function(f1, f2)  
  f1 = Frac.toFrac(f1)
  f2 = Frac.toFrac(f2)
  return not f2 < f1 end

Frac.mt.__concat = function(f1, f2)  
  f1 = Frac.toFrac(f1)
  f2 = Frac.toFrac(f2)
  return tostring(f1)..tostring(f2) end

Frac.mt.__pow = function(f, exp)
  f = Frac.toFrac(f)
  if type(exp) ~= "number" then error("Exponent must be a number.") end
  return Frac(f.num^exp, f.den^exp)
end

function Frac.toFloat(f1)
  return f1.num/f1.den
end

function Frac.gcd(m, n)
    while m ~= 0 do m, n = (n % m), m; end
    return n;
end

function Frac.normalize(frac)
  local _num = frac.num  local _den = frac.den
  local sgn = (_num/abs(_num))*(_den/abs(_den))
  _num = abs(_num) _den = abs(_den)
  local gcd = Frac.gcd(_num, _den)
  frac.num = sgn*_num/gcd
  frac.den = _den/gcd
  return frac
end

function Frac.toFrac(d) 
  if getmetatable(d) == Frac.mt then return d end
  local sgn = d/abs(d)
  d = abs(d)
  local num1, num2 = modf(d, d+100)
  local rem = string.sub(tostring(num2), 3)
  num1 = num1 * (10^(#rem))
  num2 = tonumber(rem)
  local den = 1
  return Frac(sgn*(num1 + num2), den * (10^(#rem)))
end
return Frac
