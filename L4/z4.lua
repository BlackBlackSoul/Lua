function add(calendar, event) 
  for dat, evt in pairs(calendar) do
    if os.time(event.st) <= os.time(evt.fin) and os.time(event.fin) >= os.time(evt.st) then return nil, dat end
  end
  calendar[#calendar + 1] = event
  table.sort(calendar, function(s1, s2) return os.time(s1.st) < os.time(s2.st) end)
  for k,evt in pairs(calendar) do 
    if os.time(evt.st) == os.time(event.st) then return k end 
  end
end

function show(calendar, all)
  now = os.time()
  table.sort(calendar, function(s1, s2) return s1.st < s2.st end)
  for _, evt in pairs(calendar) do
    if all or (evt.st > now) then print(event.desc) end 
  end
end

c = {}
add(c, {st = os.time(),fin = os.time() + 100}, "1st")
show(c, all)