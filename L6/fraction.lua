
local fractions = {mt={}}

require("math")

function fractions.new(numerator, denominator) 
    if denominator == 0 then error "denominator cannot be 0" end
    local gcd = fractions.gcd(numerator,denominator)
    local frac = {num = numerator/gcd,den = denominator/gcd}
    setmetatable(frac, fractions.mt)
    return frac
end

function fractions.add(f1, f2)
  local _num = f1.num*f2.den + f2.num*f1.num
  local _den = f1.den*f2.den
  local gcd = fractions.gcd(_num, _den)
  return fractions.new(_num/gcd, _den/gcd)
end

fractions.mt.__add = fractions.add

function fractions.gcd(m, n)
    while m ~= 0 do m, n = (n % m), m; end
    return n;
end

return fractions
