--
-- Created by Tooster on 22.02.2018 01:34
--

function count(tab, x)
  cntr = 0
  for k,v in pairs(tab) do
    if v == x then cntr=cntr+1 end
  end
  if cntr == 0 then return nil end
  return cntr
end