local insert = table.insert
local format = string.format
local tostring = tostring
local type = type

function serialize(t)
  local mark = {}
  local assign = {}
  local tb_cache = {}
  
  local function tb(len)
    if tb_cache[len] then
      return tb_cache[len]
    end
    local ret = ""
    while 1 < len do
      ret = ret .. "       "
      len = len - 1
    end
    if 1 <= len then
      ret = ret .. "\226\148\156\226\148\132\226\148\132"
    end
    tb_cache[len] = ret
    return ret
  end
  
  local function proto2Str(t, parent, deep)
    deep = deep or 0
    mark[t] = parent
    local ret = {}
    table.foreach(t, function(f, v)
      local k = type(f) == "number" and "[" .. f .. "]" or tostring(f)
      local t = type(v)
      if t == "userdata" or t == "function" or t == "thread" or t == "proto" or t == "upval" then
        insert(ret, format("%s=%q", k, tostring(v)))
      elseif t == "table" then
        local dotkey = parent .. (type(f) == "number" and k or "." .. k)
        if mark[v] then
          insert(assign, dotkey .. "=" .. mark[v])
        else
          insert(ret, format("%s=%s", k, proto2Str(v, dotkey, deep + 1)))
        end
      elseif t == "string" then
        insert(ret, format("%s=%q", k, v))
      elseif t == "number" then
        if v == math.huge then
          insert(ret, format("%s=%s", k, "math.huge"))
        elseif v == -math.huge then
          insert(ret, format("%s=%s", k, "-math.huge"))
        else
          insert(ret, format("%s=%s", k, tostring(v)))
        end
      else
        insert(ret, format("%s=%s", k, tostring(v)))
      end
    end)
    local pb_msg_name = t.__pb_msg__n_ or ""
    return "{\n" .. tb(deep + 2) .. pb_msg_name .. table.concat(ret, ",\n" .. tb(deep + 2)) .. "\n" .. tb(deep + 1) .. "}"
  end
  
  local function table2str(t, parent, deep)
    if type(t) == "table" then
      if t.__pb_msg__b_ then
        return proto2Str(t, parent, deep)
      end
      if t.__tostring then
        return tostring(t)
      end
    end
    deep = deep or 0
    mark[t] = parent
    local ret = {}
    table.foreach(t, function(f, v)
      local k = type(f) == "number" and "[" .. f .. "]" or tostring(f)
      local t = type(v)
      if t == "userdata" or t == "function" or t == "thread" or t == "proto" or t == "upval" then
        insert(ret, format("%s=%q", k, tostring(v)))
      elseif t == "table" then
        local dotkey = parent .. (type(f) == "number" and k or "." .. k)
        if mark[v] then
          insert(assign, dotkey .. "=" .. mark[v])
        else
          insert(ret, format("%s=%s", k, table2str(v, dotkey, deep + 1)))
        end
      elseif t == "string" then
        insert(ret, format("%s=%q", k, v))
      elseif t == "number" then
        if v == math.huge then
          insert(ret, format("%s=%s", k, "math.huge"))
        elseif v == -math.huge then
          insert(ret, format("%s=%s", k, "-math.huge"))
        else
          insert(ret, format("%s=%s", k, tostring(v)))
        end
      else
        insert(ret, format("%s=%s", k, tostring(v)))
      end
    end)
    return "{\n" .. tb(deep + 2) .. table.concat(ret, ",\n" .. tb(deep + 2)) .. "\n" .. tb(deep + 1) .. "}"
  end
  
  if type(t) == "table" then
    if t.__pb_msg__b_ then
      return proto2Str(t, "_")
    end
    if t.__tostring then
      return tostring(t)
    end
    local str = format("%s%s", table2str(t, "_"), table.concat(assign, " "))
    return [[

<<table>>]] .. str
  else
    return tostring(t)
  end
end

function handler(func, self)
  return function(...)
    if not func then
      return
    end
    return func(self, ...)
  end
end

function tonum(v, base, def)
  return tonumber(v, base) or def or 0
end

function toint(val)
  if 0 < val then
    return math.floor(val)
  end
  return math.ceil(val)
end

function tobool(v)
  return v ~= nil and v ~= false
end

function totable(v)
  if type(v) ~= "table" then
    v = {}
  end
  return v
end

function isset(arr, key)
  local t = type(arr)
  return (t == "table" or t == "userdata") and arr[key] ~= nil
end

function require2(path)
  local oldPath = path
  path = path:gsub("%.", "/")
  path = path .. ".lua"
  local content = io.readfile(path)
  content = string.gsub(content, "switch%s*%(([%w_]+)%)%s*%{(.-)%}", function(caseWord, content)
    local str = ""
    local first = true
    string.gsub(content, "case%s*([%w_'\"]+)%s*:(.-)break", function(key, val)
      if key ~= "default" then
        if first then
          str = str .. format([[
if %s == %s then
	%s
]], caseWord, key, val)
        else
          str = str .. format([[
elseif %s == %s then
	%s
]], caseWord, key, val)
        end
      elseif first then
        str = str .. format([[
if true then
	%s
]], val)
      else
        str = str .. format([[
else
	%s
]], val)
      end
      first = false
      return ""
    end)
    str = str .. "end\n"
    return str
  end)
  local ret, err = loadstring(content)
  if ret then
    ret, val = xpcall(ret, __G__TRACKBACK__)
    if ret then
      package.loaded[path] = val
      return val
    end
    return ret
  else
    err = format([[

lua: erroe loading module '%s' from file '%s':
]], oldPath, path) .. err
    error(err)
    return false
  end
end

local function utf8CharSize(char)
  if not char then
    return 0
  elseif 240 < char then
    return 4
  elseif 225 < char then
    return 3
  elseif 192 < char then
    return 2
  else
    return 1
  end
end

function getStringTable(str)
  if type(str) ~= "string" then
    error("bad argument #1 to 'utf8len' (string expected, got " .. type(str) .. ")")
  end
  local pos = 1
  local len = str:len()
  local strTab = {}
  while pos <= len do
    local char = string.byte(str, pos)
    local delta = utf8CharSize(char)
    table.insert(strTab, str:sub(pos, pos + delta - 1))
    pos = pos + delta
  end
  return strTab
end

function printNullInfo(data, string, value)
  if data == nil then
    print(string, value)
  end
end
