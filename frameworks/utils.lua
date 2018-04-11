function tabToString(tab)
    local function buildtab(tab)
        local temp = {}
        for k,v in pairs(tab) do
            if type(v) == "table" then
              temp[#temp+1] = buildtab(v)
            else 
              temp[#temp+1] = tostring(v)
            end
        end
        return '{'..table.concat(temp, ', ')..'}'
    end
    local str = buildtab(tab)
    return str
end

function compareTabs(t1, t2)
  for i, v in pairs(t1) do if t2[i] == nil or v ~= t2[i] then return false end end
  for i, v in pairs(t2) do if t1[i] == nil or v ~= t1[i] then return false end end
  return true
end

function reloadMod(mod) 
  package.loaded[mod] = nil;
  return require(mod) 
end