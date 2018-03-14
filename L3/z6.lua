--
-- Created by CLion.
-- User: Tooster   Date: 11.03.2018   Time: 21:44
--

function lreverser(source, target)
  local fin
  if source == nil  then fin = io.stdin
                    else fin = assert(io.open(source, "r"))
  end
  io.input(fin)
  
  local buffer = {}
  for line in io.lines() do
    buffer[#buffer+1] = line
  end
  
  local fout = io.stdout
  if target ~= nil then -- open target
    
    fout = io.open(target, "r")
    if fout ~= nil then -- file exists
      io.output(io.stdout) print "File will be overriden. Proceed? [y/n]"
      io.input(io.stdin) local ans = io.read("*l")
      if ans:find("n") then print "Aborted." return end
      io.close(fout)
    end
    fout = io.open(target, "w")

  end
  
  io.output(fout) -- write to file
  for i=#buffer, 1, -1 do io.write(buffer[i].."\n") end
  io.flush()
  io.close(fout)
  io.input(io.stdin)  io.output(io.stdout)

end

lreverser("test.txt", "test_o.txt")