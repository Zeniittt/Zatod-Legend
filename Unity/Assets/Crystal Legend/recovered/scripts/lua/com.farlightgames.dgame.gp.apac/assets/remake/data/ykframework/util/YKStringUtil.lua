local string = string
string.Empty = ""
local _byte = string.byte
local _char = string.char
local _substr = string.sub
local _gsub = string.gsub
local _upper = string.upper
local table = table
local _insert = table.insert
local _concat = table.concat
local type = type
local error = error
local tonumber = tonumber
local tostring = tostring
local debug = debug
local pairs = pairs
local ipairs = ipairs
local me = me
local StringUtils = {}
local mt = getmetatable("")
local nCharCode = 0
local _index = mt.__index
local idx = {}
local i, len, beg = 0, 0, 0

function mt.__index(str, ...)
  local k = (...)
  if "number" == type(k) then
    return _index.sub(str, k, k)
  elseif "string" == type(k) then
    if string[k] then
      return string[k]
    end
    i, len, beg = 1, #k, 0
    idx[1], idx[2], idx[3] = nil, nil, nil
    while i <= len do
      if k[i] == ":" then
        local num = tonumber(_substr(k, beg, i - 1))
        idx[#idx + 1] = num and num or false
        beg = i + 1
      else
        nCharCode = _byte(k, i)
        if (nCharCode < 48 or 57 < nCharCode) and nCharCode ~= 45 then
          error("can not index a string value: " .. str .. "[" .. k .. "]" .. debug.traceback())
        end
      end
      i = i + 1
    end
    idx[#idx + 1] = tonumber(_substr(k, beg))
    idx[1] = idx[1] or 1
    idx[2] = idx[2] or #str
    idx[3] = idx[3] or 1
    return _substr(str, idx[1], idx[2])
  elseif "table" == type(k) then
    k[1] = k[1] or 1
    k[2] = k[2] or #str
    k[3] = k[3] or 1
    return _substr(str, k[1], k[2])
  else
    return _index[k]
  end
end

function mt.__mul(str, nRep)
  if type(nRep) == "number" then
    local ret = ""
    while 0 < nRep do
      ret = ret .. str
      nRep = nRep - 1
    end
    return ret
  end
  return str .. nRep
end

function mt.__sub(stra, strb)
  if type(stra) == "string" then
    strb = tostring(strb)
    return _gsub(stra, strb, "")
  end
  return stra
end

function string.htmlspecialchars(input)
  input = input or ""
  for k, v in pairs(string._htmlspecialchars_set) do
    input = _gsub(input, k, v)
  end
  return input
end

string._htmlspecialchars_set = {}
string._htmlspecialchars_set["&"] = "&amp;"
string._htmlspecialchars_set["\""] = "&quot;"
string._htmlspecialchars_set["'"] = "&#039;"
string._htmlspecialchars_set["<"] = "&lt;"
string._htmlspecialchars_set[">"] = "&gt;"

function string.nl2br(input)
  return _gsub(input, "\n", "<br />")
end

function string.text2html(input)
  input = _gsub(input, "\t", "    ")
  input = string.htmlspecialchars(input)
  input = _gsub(input, " ", "&nbsp;")
  input = string.nl2br(input)
  return input
end

function string.split(str, delimiter, plain)
  if not str then
    return {}
  end
  if delimiter == "" then
    return false
  end
  if plain == nil then
    plain = true
  end
  local pos, arr = 0, {}
  for st, sp in function()
    return string.find(str, delimiter, pos, plain)
  end, nil, nil do
    _insert(arr, _substr(str, pos, st - 1))
    pos = sp + 1
  end
  _insert(arr, _substr(str, pos))
  return arr
end

function string.ltrim(str)
  return _gsub(str, "^[ \t\n\r]+", "")
end

function string.rtrim(str)
  return _gsub(str, "[ \t\n\r]+$", "")
end

function string.trim(str)
  str = _gsub(str, "^[ \t\n\r]+", "")
  return _gsub(str, "[ \t\n\r]+$", "")
end

function string.ucfirst(str)
  return _upper(_substr(str, 1, 1)) .. _substr(str, 2)
end

function string.urlencodeChar(char)
  return "%" .. string.format("%02X", _byte(c))
end

function string.urlencode(str)
  str = _gsub(tostring(str), "\n", "\r\n")
  str = _gsub(str, "([^%w%.%- ])", string.urlencodeChar)
  return _gsub(str, " ", "+")
end

function string.utf8len(str)
  local len = #str
  local left = len
  local cnt = 0
  local arr = {
    0,
    192,
    224,
    240,
    248,
    252
  }
  while left ~= 0 do
    local tmp = _byte(str, -left)
    local i = #arr
    while arr[i] do
      if tmp >= arr[i] then
        left = left - i
        break
      end
      i = i - 1
    end
    cnt = cnt + 1
  end
  return cnt
end

function string.len2(str)
  local len = #str
  local left = len
  local cnt = 0
  local arr = {
    0,
    192,
    224,
    240,
    248,
    252
  }
  while left ~= 0 do
    local tmp = _byte(str, -left)
    local i = #arr
    while arr[i] do
      if tmp >= arr[i] then
        left = left - i
        break
      end
      i = i - 1
    end
    cnt = cnt + 1
    if 127 < tmp then
      cnt = cnt + 1
    end
  end
  return cnt
end

function string.formatNumberThousands(num)
  local formatted = tostring(tonumber(num))
  while true do
    formatted, k = _gsub(formatted, "^(-?%d+)(%d%d%d)", "%1,%2")
    if k == 0 then
      break
    end
  end
  return formatted
end

function string.startsWith(value, prefix, toffset)
  if value and prefix then
    toffset = (toffset or 1) > 0 and toffset or 1
    return _substr(value, toffset, toffset + #prefix - 1) == prefix
  end
  return false
end

function string.endsWith(value, suffix)
  if value and suffix then
    return _substr(value, -#suffix) == suffix
  end
  return false
end

function string.title(value)
  return _upper(_substr(value, 1, 1)) .. _substr(value, 2, #value)
end

function string.charAt(value, position)
  if value and position and 0 < position then
    local b = _byte(value, position, position + 1)
    return b and _char(b) or b
  end
end

function string.isWhitespace(value)
  if value then
    local len = #value
    for i = 1, len do
      local char = string.charAt(value, i)
      if char ~= " " and char ~= "\t" then
        return false
      end
    end
    return true
  end
  return false
end

function string.toArray(value)
  local ret = {}
  if value then
    local idx = 1
    local count = #value
    while idx <= count do
      local b = _byte(value, idx, idx + 1)
      if 127 < b then
        _insert(ret, _substr(value, idx, idx + 1))
        idx = idx + 2
      else
        _insert(ret, _char(b))
        idx = idx + 1
      end
    end
  end
  return ret
end

function _bytecode(value)
  if value then
    local bytes = {}
    local idx = 1
    local count = #value
    while idx <= count do
      local b = _byte(value, idx, idx + 1)
      if 100 <= b then
        _insert(bytes, "\\" .. b)
      else
        _insert(bytes, "\\0" .. b)
      end
      idx = idx + 1
    end
    local code, ret = pcall(loadstring(string.format("do local _='%s' return _ end", _concat(bytes))))
    if code then
      return ret
    end
  end
  return ""
end

function string.substr(value, startIndex, endIndex)
  if value then
    local ret = {}
    local idx = startIndex
    local count = endIndex or #value
    while idx <= count do
      local b = _byte(value, idx, idx + 1)
      if not b then
        break
      end
      if 127 < b then
        _insert(ret, _substr(value, idx, idx + 1))
        idx = idx + 2
      else
        _insert(ret, _char(b))
        idx = idx + 1
      end
    end
    return _concat(ret)
  end
end

local lpeg = lpeg
local match = lpeg.match
local P = lpeg.P
local S = lpeg.S
local R = lpeg.R
local C = lpeg.C
local Ct = lpeg.Ct
local sp = P(" ") ^ 0

local function space(pat)
  return sp * pat * sp
end

local function list(pat)
  pat = space(pat)
  return pat * ("," * pat) ^ 0
end

local function f1(s)
  return _substr(s, 1, 1)
end

local function f2(s)
  return _substr(s, 1, 2)
end

local function f3(s)
  return _substr(s, 1, 3)
end

local function f4(s)
  return _substr(s, 1, 4)
end

local cont = lpeg.R("\128\191")
local utf8 = lpeg.R("\000\127") / f1 + lpeg.R("\194\223") * cont / f2 + lpeg.R("\224\239") * cont * cont / f3 + lpeg.R("\240\244") * cont * cont * cont / f4
local words = Ct(utf8 ^ 1)

function string.getWords(str)
  return lpeg.match(words, str) or {}
end

function string.isNullOrEmpty(str)
  return str == nil or str == string.Empty
end

return StringUtils
