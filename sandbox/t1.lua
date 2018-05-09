local utils = require('frameworks/utils')
local x = utils.typecheck(function(...) return table.pack(...) end, 'table')

a = x(1, 2, 3)
utils.display(a)
utils.display(12, 3, { 'x', 'y', 'z' }, nil, 7)