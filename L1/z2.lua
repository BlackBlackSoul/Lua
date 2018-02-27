--
-- Created by Tooster on 22.02.2018 00:53
--

function map(tab, fun)
  tmp = {}
  if type(tab) ~= "table" then 
    return tmp 
  end 
  for k,v in pairs(tab) do
    tmp[k] = fun(v)
  end
  return tmp
end