local Vector = {dimension=0}
Vector.__index = Vector

local max = math.max
local sqrt = math.sqrt

Vector.__pairs = function (v)
  local i = 0
  return function()
    i = i + 1
    if i <= v.dimension then  return i, v[i]
    else return nil end
  end
end

Vector.__ipairs = function (v)
  local i = 0
  return function()
    i = i + 1
    if i <= v.dimension then
      local u = Vector.newZero(v.dimension)
      u[i] = 1
      return u, v[i]
    else return nil end
  end
end

Vector.__unm = function (v)
  for i=1, v.dimension do v[i] = -v[i] end
  return v
end

Vector.__add = function (v, w)
  if type(v) == "number" then v, w = w, v end
  if type(w) == "number" then w = Vector.expand(w, v.dimension) end
  local u = Vector.newZero(max(v.dimension, w.dimension))
  for i=1, v.dimension do u[i] = u[i] + v[i] end
  for i=1, w.dimension do u[i] = u[i] + w[i] end
  return u
end

Vector.__sub = function (v, w) 
  return v + (- w)  
end

Vector.__mul = function (v, w) -- scalar and dot product at once
  if type(v) == "number" then v, w = w, v end
  if type(w) == "number" then w = Vector.expand(w, v.dimension) end
  local u = Vector.newUnit( max(v.dimension, w.dimension))
  for i=1, v.dimension do u[i] = u[i] * v[i] end
  for i=1, w.dimension do u[i] = u[i] * w[i] end
  return u
end

Vector.__div = function (v, w)
  if type(v) == "number" then v = Vector.expand(v, w.dimension) end
  if type(w) == "number" then w = Vector.expand(w, v.dimension) end
  for i, val in pairs(w) do
    if val == 0 then error("Cannot divide by zero") end
    w[i] = 1/val
  end
  return v * w
end

Vector.__len = function (v) 
  local ret = 0
  for _, v in pairs(v) do ret = ret + v^2 end
  return sqrt(ret)
end

Vector.__tostring = function (v)
  local t = {}
  for _, v in pairs(v) do t[#t+1] = tostring(v) end
  return "{"..table.concat(t, ", ").."}"
end

Vector.__concat = function (v, w) 
  return tostring(v)..tostring(w)
end

Vector.__eq = function (v,w) 
  if getmetatable(v) ~= getmetatable(w) or
      v.dimension ~= w.dimension then return false end
  for i=1, v.dimension do if v[i] ~= w [i] then return false end end
  return true
end

function Vector.new(o)
  local r = {}
  if getmetatable(o) == Vector then 
    for i, val in pairs(o) do r[i] = val end
    r.dimension = o.dimension
  else 
    r.dimension = #o
    for i,val in ipairs(o) do r[i] = val end
  end
  return setmetatable(r, Vector)
end

function Vector.newZero(dim)
  local t = {}
  for i=1, dim do t[i] = 0 end
  return Vector.new(t)
end

function Vector.newUnit(dim)
  local t = {}
  for i=1, dim do t[i] = 1 end
  return Vector.new(t)
end

function Vector.expand(length, dim)
  local t = {}
  for i=1, dim do t[i] = length end
  return Vector.new(t)
end


setmetatable(Vector, {__call = function(_, ...) return Vector.new(...) end})

return Vector