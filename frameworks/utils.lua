local utils = {}

local mobdebug = require('mobdebug')

local function red(str) return '\27[1;31m' .. str .. '\27[0m' end

local function reloadMod(mod)
    package.loaded[mod] = nil;
    return require(mod)
end

local function tabTostring(tab)
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

local function tabsEqual(t1, t2)
  for i, v in pairs(t1) do if t2[i] == nil or v ~= t2[i] then return false end end
  for i, v in pairs(t2) do if t1[i] == nil or v ~= t1[i] then return false end end
  return true
end

-- TYPECHECK
local invalidArgMsg = "invalid argument to typecheck decorator - acceptable:\n" ..
        "> keyword ::=  'table[*]' | \n" ..
        "`              'string[*][:pattern]' |\n" ..
        "`              'function[*]' |\n" ..
        "`              'bool[*]' |\n" ..
        "`              'number[*]' |\n" ..
        "`              'integer[*]' |\n" ..
        "`              'float[*]' |\n" ..
        "`              'nil'\n" ..
        "> nil\n" ..
        "> {keyword [, keyword]}"

local function typecode(x)
    if type(x) == 'number' then return math.type(x) end
    return type(x)
end

local function addEntry(tab, entry)
    if string.match(entry, '^nil$') or -- for key nil, or asterix, allow nil value
            string.match(entry, '^string%*') or
            string.match(entry, '^function%*') or
            string.match(entry, '^bool%*') or
            string.match(entry, '^number%*') or
            string.match(entry, '^integer%*') or
            string.match(entry, '^float%*') then tab['nil'] = true
    end

    if string.match(entry, '^table%*?$') then tab['table'] = true
    elseif string.match(entry, '^function%*?$') then tab['function'] = true
    elseif string.match(entry, '^bool%*?$') then tab['boolean'] = true
    elseif string.match(entry, '^number%*?$') then tab['integer'] = true; tab['float'] = true
    elseif string.match(entry, '^integer%*?$') then tab['integer'] = true
    elseif string.match(entry, '^float%*?$') then tab['float'] = true
    elseif string.match(entry, '^string%*?$') then tab['string'] = true
    elseif string.match(entry, 'string%*?:.*') then tab['PATTERN'] = string.gsub(entry, '^string%*?:', '', 1)
    else error(red(invalidArgMsg) .. '\n' .. red("given: '") .. red(tostring(entry) .. "'."))
    end
end

local function parseEntries(t)
    local entries = { n = t.n }
    for i = 1, t.n do
        if t[i] == nil then -- on nil, every type is allowed
            entries[i] = { ['table'] = true, ['string'] = true, ['function'] = true, ['bool'] = true, ['integer'] = true, ['float'] = true, ['nil'] = true }
        elseif type(t[i]) == 'table' then -- subset if table
            entries[i] = {};
            for _, v in ipairs(t[i]) do
                if type(v) ~= 'string' then error(red(invalidArgMsg) .. '\n ' .. red('given: ' .. tostring(v))) end
                addEntry(entries[i], v)
            end
        elseif type(t[i]) == 'string' then -- single key
            entries[i] = {}; addEntry(entries[i], t[i])
        else error(red(invalidArgMsg) .. '\n' .. red('given: ' .. tostring(t[i])))
        end
    end
    return entries
end

local function checkEntries(t, entries)
    for i = 1, entries.n do -- instead of continue negate condition
        local code = typecode(t[i])
        local matched = entries[i][code] -- entries have true for all acceptable codes
        if not matched and code == 'string' and entries[i]["PATTERN"] then -- pattern matching
            matched = t[i] == string.match(t[i], entries[i]["PATTERN"])
        end
        if not matched then -- error if not matching
            local expected = {}
            for k, v in pairs(entries[i]) do
                if k ~= 'n' and v then expected[#expected + 1] = k end
                if k == 'PATTERN' then expected[#expected] = expected[#expected] .. ':' .. v end
            end
            return true, "at position " .. i .. " given: (" .. code .. ")" .. "'" .. tostring(t[i]) .. "' expected one of {'" .. table.concat(expected, "','") .. "'}."
        end
    end
    return false
end

local function typecheck(f, ...)
    local t = table.pack(...)

    if type(t[1]) ~= 'number' then -- normalize to have number at the begining
        table.move(t, 1, t.n, 2)
        t[1] = 1
        t.n = t.n + 1
    elseif t[1] < 0 then error(red('Number of return values cannot be less than zero.'))
    elseif t.n - 1 < t[1] then error(red('Too few return values given, expected ' .. t[1] .. ' given ' .. (t.n - 1) .. '.'))
    end


    local funRetEntries = { n = 0 }; local funArgEntries = { n = 0 }
    for it = 2, 1 + t[1] do funRetEntries[funRetEntries.n + 1] = t[it]; funRetEntries.n = funRetEntries.n + 1 end
    for it = 2 + t[1], t.n do funArgEntries[funArgEntries.n + 1] = t[it]; funArgEntries.n = funArgEntries.n + 1 end

    funRetEntries = parseEntries(funRetEntries); funArgEntries = parseEntries(funArgEntries)

    return function(...)
        local funArgs = table.pack(...)
        local fail, errmsg = checkEntries(funArgs, funArgEntries)
        if fail then error(red("Function call: invalid argument " .. errmsg)) end

        local funRets = table.pack(f(...))
        fail, errmsg = checkEntries(funRets, funRetEntries)
        if fail then error(red("Function call: invalid return type " .. errmsg)) end

        return table.unpack(funRets)
    end
end

-- TYPECHECK END

local function display(...)
    local t = table.pack(...)
    for i = 1, t.n do print(mobdebug.line(t[i])) end
end

local function deepCopy(t) -- deep-copy a table
    if type(t) ~= "table" then return t end
    local meta = getmetatable(t)
    local target = {}
    for k, v in pairs(t) do
        if type(v) == "table" then
            target[k] = deepCopy(v)
        else
            target[k] = v
        end
    end
    setmetatable(target, meta)
    return target
end

local function shallowCopy(t) -- shallow-copy a table
    if type(t) ~= "table" then return t end
    local meta = getmetatable(t)
    local target = {}
    for k, v in pairs(t) do target[k] = v end
    setmetatable(target, meta)
    return target
end

--
utils.reloadMod = reloadMod
utils.tabTostring = tabTostring
utils.display = display
utils.tabsEqual = tabsEqual
utils.typecheck = typecheck
utils.deepCopy = deepCopy
utils.shallowCopy = shallowCopy
return utils