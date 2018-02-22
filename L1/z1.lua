--
-- Created by Tooster on 21.02.2018 13:36
--

function printtab(tab)
    local function buildtab(tab)
        local str = '{'
        for i = 1, #tab do
            if type(tab[i]) == "table" then
                str = str .. buildtab(tab[i])
            else 
              str = str .. tostring(tab[i])
            end
            if i < #tab then
                str = str ..', '
            end
        end
        return str..'}'
    end

    local str = buildtab(tab)
    print(str)
end