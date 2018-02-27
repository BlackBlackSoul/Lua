--
-- Created by Tooster on 21.02.2018 13:36
--

function printtab(tab)
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
    print(str)
end