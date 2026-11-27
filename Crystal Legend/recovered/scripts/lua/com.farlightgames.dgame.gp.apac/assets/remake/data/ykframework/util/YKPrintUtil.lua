local p = print

function printT(...)
  local n = select("#", ...)
  local tb = {}
  local dbg = debug.getinfo(2)
  local path = string.split(dbg.source, "/")
  local detais = "[" .. path[#path] .. "#Line:" .. dbg.currentline .. "]"
  table.insert(tb, detais)
  for i = 1, n do
    local v = select(i, ...)
    local str = serialize(v)
    table.insert(tb, str)
  end
  local ret = table.concat(tb, "  ")
  p(ret)
  return ret
end

if EDFLAGWIN32 then
  print = printT
end
