local ed = ed
local reduceTable = {
  a = "battle/heroes/",
  b = "UI/alpha/1080P/",
  c = "UI/art/",
  d = "UI/DOTA%-HERO/",
  e = "UI/DOTA%-ITEM/",
  f = "UI/HERO%-NAME/",
  g = "UI/body/",
  h = "sound_menu/heroes_voice/",
  i = "proto/effect/",
  j = "UI/portrait/"
}
local rawpairs = pairs

function pairs(t)
  local m = getmetatable(t)
  local f = m and m.__pairs or rawpairs
  return f(t)
end

local rawipairs = ipairs

function ipairs(t)
  local m = getmetatable(t)
  local f = m and m.__ipairs or rawipairs
  return f(t)
end

local function recoverColum(value)
  if not value then
    return nil
  end
  local str = string.sub(value, 1, 1)
  for i, v in pairs(reduceTable) do
    if str == i and not string.match(value, v) then
      value = string.gsub(value, i, v, 1)
      return value
    end
  end
  return value
end

ed.recoverColum = recoverColum

local function reduceValue(v)
  if type(v) ~= "string" then
    error("try reduce a type that is not  string:", v)
  end
  local isString = true
  v = v ~= "" and v or nil
  if not v then
    return nil, isString
  end
  for i, str in pairs(reduceTable) do
    if string.match(v, str) then
      v = string.gsub(v, str, i)
      break
    end
  end
  return v, isString
end

local function setValueForKeyChain(t, chain, v, table_name)
  if #chain == 0 then
    EDDebug("Primary key not found on table: " .. table_name)
  end
  local k = chain[1]
  if #chain == 1 then
    if t[k] then
      EDDebug("Primary key '" .. (k or "nil") .. "' duplicated on table: " .. table_name)
    end
    t[k] = v
  else
    if not t[k] then
      t[k] = {}
    end
    table.remove(chain, 1)
    setValueForKeyChain(t[k], chain, v, table_name)
  end
end

local datatable_cache = {}
local ref_count_list = {}
local insert = table.insert
local gmatch = string.gmatch

local function loadCSV1(path)
  local ret = {}
  local file_content = EDGetFileData(path)
  local column_list, type_list
  if not file_content then
    print(path)
  end
  
  local function parseValue(v, t)
    local sub = string.sub
    local gmatch = string.gmatch
    local insert = table.insert
    local tonumber = tonumber
    local toboolean = ed.toboolean
    local lower = string.lower
    local char = sub(t, 1, 1)
    t = sub(t, 2)
    local iskey = false
    local isString = false
    local isIgnore = false
    if char == "K" then
      iskey = true
      char = sub(t, 1, 1)
      t = sub(t, 2)
    end
    if char == "A" then
      local ret = {}
      for token in gmatch(v, "[^;]*") do
        if token ~= "" then
          local e = parseValue(token, t)
          insert(ret, e)
        end
      end
      v = ret
    elseif char == "S" then
      isString = true
      v = v ~= "" and v or nil
    elseif char == "N" then
      v = tonumber(v) or 0
    elseif char == "B" then
      v = toboolean(lower(v))
    elseif char == "O" then
      isIgnore = true
      v = nil
    elseif char == "X" then
      isIgnore = true
      v = nil
    elseif char == "R" then
      v, isString = reduceValue(v)
    elseif char == "U" then
      return parseValue(v, t)
    end
    return v, iskey, isString, isIgnore
  end
  
  local function csvLineSplit(s)
    s = s .. ","
    local t = {}
    local fieldstart = 1
    local findfuc = string.find
    local subfuc = string.sub
    local gsubfuc = string.gsub
    local stringlen = string.len
    repeat
      if findfuc(s, "^\"", fieldstart) then
        local a, c
        local i = fieldstart
        repeat
          a, i, c = findfuc(s, "\"(\"?)", i + 1)
        until c ~= "\""
        if not i then
          error("unmatched \"")
        end
        local f = subfuc(s, fieldstart + 1, i - 1)
        t[#t + 1] = gsubfuc(f, "\"\"", "\"")
        fieldstart = findfuc(s, ",", i) + 1
      else
        local nexti = findfuc(s, ",", fieldstart)
        t[#t + 1] = subfuc(s, fieldstart, nexti - 1)
        fieldstart = nexti + 1
      end
    until fieldstart > stringlen(s)
    return t
  end
  
  local columnInfo = {}
  local keyCnt = 0
  local keyInit = false
  for line in gmatch(file_content, "[^\r\n]*") do
    if line ~= "" then
      local value_list = csvLineSplit(line)
      if not type_list then
        type_list = value_list
      elseif not column_list then
        column_list = value_list
      else
        local line_table = {}
        local key = {}
        local idx = 1
        for i = 1, #column_list do
          local t = type_list[i]
          if t and 0 < #t then
            local k = column_list[i]
            local v = value_list[i]
            local vv, iskey, isString, isIgnore = parseValue(v, t)
            if not isIgnore then
              if not keyInit then
                columnInfo[idx] = k
              end
              line_table[k] = vv
              idx = idx + 1
              if iskey then
                key[#key + 1] = vv
              end
            end
          end
        end
        keyInit = true
        keyCnt = #key
        setValueForKeyChain(ret, key, line_table, path)
      end
    end
  end
  local table_name = string.match(path, "[^/\\]*$")
  table_name = string.gsub(table_name, ".csv", "")
  if ed.formatDataTable then
    ed.formatDataTable(ret, table_name)
  else
  end
  return ret, columnInfo, keyCnt
end

ed.loadCSV1 = loadCSV1

local function loadCSV(path)
  local ret = {}
  local file_content = EDGetFileData(path)
  local column_list, type_list
  if not file_content then
    print(path)
  end
  
  local function parseValue(v, t)
    local sub = string.sub
    local gmatch = string.gmatch
    local insert = table.insert
    local tonumber = tonumber
    local toboolean = ed.toboolean
    local lower = string.lower
    local char = sub(t, 1, 1)
    t = sub(t, 2)
    local iskey = false
    local isString = false
    local isIgnore = false
    if char == "K" then
      iskey = true
      char = sub(t, 1, 1)
      t = sub(t, 2)
    end
    if char == "A" then
      local ret = {}
      for token in gmatch(v, "[^;]*") do
        if token ~= "" then
          local e = parseValue(token, t)
          insert(ret, e)
        end
      end
      v = ret
    elseif char == "S" then
      isString = true
      v = v ~= "" and v or nil
    elseif char == "N" then
      v = tonumber(v) or 0
    elseif char == "B" then
      v = toboolean(lower(v))
    elseif char == "O" then
      isIgnore = true
      v = nil
    elseif char == "X" then
      isIgnore = true
      v = nil
    elseif char == "R" then
      v, isString = reduceValue(v)
    elseif char == "U" then
      return parseValue(v, t)
    end
    return v, iskey, isString, isIgnore
  end
  
  local function csvLineSplit(s)
    s = s .. ","
    local t = {}
    local fieldstart = 1
    local findfuc = string.find
    local subfuc = string.sub
    local gsubfuc = string.gsub
    local stringlen = string.len
    repeat
      if findfuc(s, "^\"", fieldstart) then
        local a, c
        local i = fieldstart
        repeat
          a, i, c = findfuc(s, "\"(\"?)", i + 1)
        until c ~= "\""
        if not i then
          error("unmatched \"")
        end
        local f = subfuc(s, fieldstart + 1, i - 1)
        t[#t + 1] = gsubfuc(f, "\"\"", "\"")
        fieldstart = findfuc(s, ",", i) + 1
      else
        local nexti = findfuc(s, ",", fieldstart)
        t[#t + 1] = subfuc(s, fieldstart, nexti - 1)
        fieldstart = nexti + 1
      end
    until fieldstart > stringlen(s)
    return t
  end
  
  for line in gmatch(file_content, "[^\r\n]*") do
    if line ~= "" then
      local value_list = csvLineSplit(line)
      if not type_list then
        type_list = value_list
      elseif not column_list then
        column_list = value_list
      else
        local line_table = {}
        local key = {}
        for i = 1, #column_list do
          local t = type_list[i]
          if t and 0 < #t then
            local k = column_list[i]
            local v = value_list[i]
            local vv, iskey, isString, isIgnore = parseValue(v, t)
            if not isIgnore then
              line_table[k] = vv
              if iskey then
                key[#key + 1] = vv
              end
            end
          end
        end
        setValueForKeyChain(ret, key, line_table, path)
        local name = line_table.Name
        if name then
          ret[name] = line_table
        end
      end
    end
  end
  local table_name = string.match(path, "[^/\\]*$")
  table_name = string.gsub(table_name, ".csv", "")
  if ed.formatDataTable then
    ed.formatDataTable(ret, table_name)
  else
  end
  return ret
end

ed.loadCSV = loadCSV

local function getDataTable(table_name)
  local ret = datatable_cache[table_name]
  ed.resetDatatableReleaseCount(table_name)
  if ret then
    return ret
  end
  if not EDFLAGWIN32 then
    pcall(function()
      local tblInfo = require(table_name)
      local tblData = tblInfo[1]
      local keyMap = tblInfo[2]
      local keyCnt = tblInfo[3]
      ret = ed.setTableMetatable(tblData, keyMap, keyCnt)
      if EDCurLanguage ~= "cn" and ed.formatDataTable then
        ed.formatDataTable(ret, table_name, keyMap)
      end
    end)
  end
  if not ret then
    if EDFLAGSVR then
      local path = "csv/" .. table_name .. ".csv"
      ret = loadCSV(path)
    else
      local tblInfo = require("csvlua/" .. table_name)
      if tblInfo then
        local tblData = tblInfo[1]
        local keyMap = tblInfo[2]
        local keyCnt = tblInfo[3]
        ret = ed.setTableMetatable(tblData, keyMap, keyCnt)
        if EDCurLanguage ~= "cn" and ed.formatDataTable then
          ed.formatDataTable(ret, table_name, keyMap)
        end
      else
        local path = "csv/" .. table_name .. ".csv"
        ret = loadCSV(path)
      end
    end
  end
  datatable_cache[table_name] = ret
  return ret
end

ed.getDataTable = getDataTable
local select = select

local function lookupDataTable(table_name, column_name, ...)
  local dt = ed.getDataTable(table_name)
  for i = 1, select("#", ...) do
    local key = select(i, ...)
    dt = dt[key]
    if not dt then
      return
    end
  end
  if column_name then
    return dt[column_name]
  else
    return dt
  end
end

ed.lookupDataTable = lookupDataTable
local ref_collect_gap = 999999
local ref_release_gap = 999999
local collect_count = 0

function ed.initDatatableGCGap(gap)
  ref_collect_gap = gap
end

function ed.initDatatableReleaseGap(gap)
  ref_release_gap = gap
end

function ed.resetDatatableReleaseCount(name)
  ref_count_list[name] = ref_release_gap
end

local protected_list = {
  "Unit",
  "Skill",
  "Stage",
  "Battle",
  "hero_equip",
  "equip",
  "SkillGroup",
  "UnitRank"
}

function ed.checkDatatableReleaseCount()
  local bRelease
  for k, v in pairs(datatable_cache) do
    ref_count_list[k] = math.max(ref_count_list[k] - ref_collect_gap, 0)
    if ref_count_list[k] <= 0 and not ed.isElementInTable(k, protected_list) then
      datatable_cache[k] = nil
      bRelease = true
    end
  end
  if bRelease then
    local temp = {}
    for k, v in pairs(datatable_cache) do
      temp[k] = v
    end
    datatable_cache = temp
  end
end

function ed.datatableGC(dt)
  collect_count = collect_count + dt
  if collect_count > ref_collect_gap then
    ed.checkDatatableReleaseCount()
    collectgarbage("collect")
    collect_count = 0
  end
end

function ed.setTableMetatable(table, keyMap, keyCnt)
  local mt = {
    __index = function(t, k)
      if not k then
        return
      end
      return t[keyMap[k]]
    end,
    __newindex = function(t, k, v)
      local tk = keyMap[k] or k
      rawset(t, tk, v)
    end,
    __pairs = function(t)
      local function iterator(t, idx)
        local k, v = next(keyMap, idx)
        
        if v ~= nil then
          return k, t[v]
        end
      end
      
      return iterator, t, nil
    end
  }
  local mt1 = {
    __index = function(t, k)
      if not k then
        return
      end
      local v = t.data[k]
      if v then
        local keyCnt = rawget(t, "keyCnt")
        if keyCnt == 1 then
          setmetatable(v, mt)
          return v
        else
          local tt = {
            keyCnt = keyCnt - 1,
            data = v
          }
          setmetatable(tt, getmetatable(t))
          return tt
        end
      end
      return v
    end,
    __pairs = function(t)
      local function iter(t, idx)
        local k, v = next(t.data, idx)
        
        if v then
          local keyCnt = rawget(t, "keyCnt")
          if keyCnt == 1 then
            setmetatable(v, mt)
            return k, v
          else
            local w = {
              keyCnt = keyCnt - 1,
              data = v
            }
            setmetatable(w, getmetatable(t))
            return k, w
          end
        end
        return k, v
      end
      
      return iter, t, nil
    end,
    __ipairs = function(t)
      local idx = 0
      
      local function iter()
        idx = idx + 1
        local v = t.data[idx]
        if v then
          local keyCnt = rawget(t, "keyCnt")
          if keyCnt == 1 then
            setmetatable(v, mt)
            return idx, v
          else
            local w = {
              keyCnt = keyCnt - 1,
              data = v
            }
            setmetatable(w, getmetatable(t))
            return idx, w
          end
        end
      end
      
      return iter
    end
  }
  local ret = {keyCnt = keyCnt, data = table}
  setmetatable(ret, mt1)
  return ret
end
