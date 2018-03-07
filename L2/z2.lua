function isseq(...)
  local args = {...}
  if #args == 1 and type(args[1]) == "table" then args = args[1] end
  local ix = {}
  
  for i,_ in pairs(args) do ix[#ix+1] = i end
  table.sort(ix)
  for i=2, #ix do 
    if ix[i-1] + 1 == ix[i] then ix[i-1] = nil end
  end
  ret = {}
  for _,v in pairs(ix) do ret[#ret+1] = v end
  return #ret == 1 and args[1] ~= nil, ret
end
