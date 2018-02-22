--
-- Created by Tooster on 22.02.2018 00:53
--

function map(tab, fun)
  tmp = {}
  if type(tab) ~= "table" then 
    return tmp 
  end 
  for i=1, #tab do
    tmp[i] = fun(tab[i])
  end
  return tmp
end