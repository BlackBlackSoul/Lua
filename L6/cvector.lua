local CVector = {}

local max = math.max
local min = math.min
local red -- color red
local properKey -- check if key is in bounds, true if is, false + error otherwise

CVector.__index = function (vector, key)
  if type(key) == "number" then 
    if properKey(vector, key) then
      return vector.container[key+1]
    end
    else return CVector[key] end
end

CVector.__newindex = function(vector, key, val) 
  if type(key) == "number" then
    if properKey(vector,key) then
      vector.container[key+1] = val
    end
  end
end


local function ipairs_iter(t) 
    t.i = t.i + 1
    if t.i > t.val.n then return nil
    else return t.i-1, t.val.container[t.i] end
end
  
CVector.__ipairs = function (...)
  return ipairs_iter, {val = ..., i=0}, 0
end



---[[ produces bug in debugger: 'watch' has value of properKey error msg
CVector.__len = function (vector)
  return vector.n
end 
--]]

CVector.__tostring = function (vector) 
  local t = {}
  for k, v in ipairs(vector) do 
    t[#t+1] = tostring(v) 
  end
  return "{"..table.concat(t, ", ").."}"
end

CVector.__concat = function (v1, v2)
  v1:insert(v1:size(), v2)
  return v1
end

function CVector.new (...) 
  local o = {n=0, container = {}}
  setmetatable(o, CVector)
  local t = ...
  if getmetatable(t) == CVector then
    o.n = t.n
    for i=1, t.n do o.container[i] = t.container[i] end 
  else 
    local maxK = 0
    for k, v in pairs(t) do
      if type(k) == "number" then maxK = max(maxK, k) end
      o.container[k] = v
    end
    o.n = maxK
  end
  return o
end

function CVector:at(idx)
  if type(idx) ~= "number" then error(red("Index must be a number")) end
  return self[idx]
end

function CVector:size()
  return self.n
end

function CVector:empty()
  return self.n == 0
end

function CVector:clear() 
  for k, v in ipairs(self) do 
    self[k] = nil 
  end
  self.n = 0
end

function CVector:erase(from, to) -- passed as range [from, to)
  to = to or self.n
  if properKey(self, from) and properKey(self, to-1) then
    from = from + 1; -- to lua indexing
    table.move(self.container,to+1,self:size(), from)
    local oldsz = self.n
    self.n = self.n - (to + 1 - from)
    for i=self.n+1, oldsz do self.container[i] = nil end
  end
end

function CVector:insert(idx, e) 
  if type(e) == "number" then e = CVector{e} end
  if type(e) == "table" and getmetatable(e) ~= CVector then e = CVector.new(e) end
  if idx == self.n or properKey(self, idx) then
    idx = idx+1
    table.move(self.container, idx, self.n, idx + e.n)
    table.move(e.container, 1, e.n, idx, self.container)
    self.n = self.n + e.n
  end  
end

function CVector:push_back(val)
  table.insert(self.container, val)
  self.n = self.n + 1
end

function CVector:pop_back(val)
  if self:size() == 0 then error(red("Cannot pop from empty vector.")) end
  local ret = self.container[self.n]
  self.container[self.n] = nil
  self.n = self.n - 1
  return ret
end

function CVector:front()
  if self:empty() then error (red("Vector is empty.")) end
  return self.container[1]  
end

function CVector:back()
  if self:empty() then error (red("Vector is empty.")) end
  return self.container[self.n]  
end

--------------------------------------------------------------------------------------
-- INTERNAL
red = function(str) return "\27[1;31m"..str.."\27[0m" end

properKey = function(vector, key) 
  if key < 0 or key >= vector:size() then
      -- print(debug.traceback())
      error(red("CVector: Index '"..key.."' out of bounds."))
  end
  return true
end
--------------------------------------------------------------------------------------
setmetatable(CVector, {__call = function(_, ...) return CVector.new(...) end})
return CVector