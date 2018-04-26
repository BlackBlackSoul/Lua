require("L7/typecheck")

--- [[
local function testfunction(t, s, sp, f, b, i, fl, n, all, any) return t, s, sp, f, b, i, fl, n, all, any end

local f = typecheck(testfunction, 10, 'table', 'string', 'string:[abc]*', 'function', 'bool', 'integer', 'float', 'number', nil, { 'string*', 'integer' },
    'table', 'string', 'string:[abc]*', 'function', 'bool', 'integer', 'float', 'number', nil, { 'string*', 'integer' })

print(f({}, 'x', 'bac', function() end, true, 3, 4.7, 1, 'e', 3))
print(f({}, 'x', 'bac', function() end, true, 3, 4.7, 1, {}, 'x'))
print(f, {}, 'x', 'bac', function() end, true, 3, 4.7, 1, function() end, nil)
--]]

local function tableF(t) return t end

local f = typecheck(tableF, 'string', { 'string:test', 'integer' })
print(f('test'))
print(pcall(f, 7))

local function fun(x, y)
    return x + y < 10, x > 0 and { x, x + y, x + 2 * y } or print
end

local tcfun = typecheck(fun, 2, 'bool', 'table', 'integer', { 'number', 'string' })

tcfun(10, 20)
tcfun(10, '20.0')
print(pcall(tcfun, 10.0, '20.0'))
print(pcall(tcfun, 10.0, nil))
print(pcall(tcfun, -5, 20))

tcf = typecheck(function(p, v, s) return 3 end, 'integer', nil, 'number*', 'string:[rgb]')
tcf({}, nil, 'r')
print(pcall(tcf, {}, nil, 'R'))
print(pcall(tcf, 127, 23.5, 'rgb'))

print(pcall(typecheck, f, -1))
typecheck(f, 0)
print(pcall(typecheck, f, 10))

print(pcall(typecheck, f, 'x'))

fx = typecheck(function(x) return x end, nil, nil, nil)
fx(1, 3, nil)



