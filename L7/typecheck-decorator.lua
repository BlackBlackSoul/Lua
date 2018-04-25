--
-- Created by CLion.
-- User: Tooster   Date: 25.04.2018   Time: 13:26
--

local floor = math.floor

function typecheckDecorator(f, ...)
    local t = table.pack(...)

    print(t.n)

    local function isInt(x) return floor(x) == x end

    if #t == 0 then
        error("Redundant typecheck-operator")
    else
        local retval = t[1]
        local retbegin = 2
        if type(t[1] ~= "Number") then retval = 1; retbegin = 1 end
        local funretvals = { n = i }
        for i = 1, retval do funretvals[i] = t[retbegin + i - 1] end
        local funargs = { n = 0 }
        for k, v in pairs(args) do
            if true then end -- TODO
        end
        return decorate(args)
    end

    local function decorate(f, funretvals, funargs)
        return f -- TODO
    end
end