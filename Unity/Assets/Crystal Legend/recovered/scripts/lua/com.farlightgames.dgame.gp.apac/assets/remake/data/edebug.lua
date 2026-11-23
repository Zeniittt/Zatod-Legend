local _tostring = tostring
local _print = print

function tostring(o, limit)
  if limit and limit < 0 then
    return ""
  end
  if type(o) == "userdata" then
    local mt = getmetatable(o)
    if mt then
      if mt == CCPoint then
        return "ccp(" .. o.x .. ", " .. o.y .. ")"
      elseif mt == ccColor3B then
        return "ccc3(" .. o.r .. ", " .. o.g .. ", " .. o.b .. ")"
      elseif mt == ccColor4B then
        return "ccc4(" .. o.r .. ", " .. o.g .. ", " .. o.b .. ", " .. o.a .. ")"
      elseif mt == CCSize then
        return "size(" .. o.width .. ", " .. o.height .. ")"
      elseif mt == CCRect then
        return "[" .. tostring(o.origin) .. ", " .. tostring(o.size) .. "]"
      end
    end
  elseif type(o) == "table" then
    local mt = getmetatable(o)
    if not mt or not mt.__tostring then
      local s = ""
      if not limit then
        s = _tostring(o)
        limit = 40
      end
      s = s .. "["
      for k, v in pairs(o) do
        local sk = tostring(k, limit)
        limit = limit - string.len(sk) - 1
        local sv = tostring(v, limit)
        limit = limit - string.len(sv) - 1
        s = s .. sk .. "=" .. sv .. ","
        if limit < 0 then
          break
        end
      end
      if limit < 0 then
        s = string.sub(s, 1, limit - 1) .. "..."
      end
      s = s .. "]"
      return s
    end
  end
  return _tostring(o)
end

function p(o, raw)
  if type(o) == "table" then
    local mt = getmetatable(o)
    if not raw and (mt or mt == nil) and o.__p then
      o:__p()
      return
    end
    local fields = {}
    for k, v in pairs(o) do
      local what = type(v)
      table.insert(fields, {
        what,
        k,
        v
      })
    end
    table.sort(fields, function(a, b)
      local ta = type(a[2])
      local tb = type(b[2])
      if ta ~= tb then
        return ta < tb
      elseif ta == "table" then
        return tostring(a[2]) < tostring(b[2])
      else
        return a[2] < b[2]
      end
    end)
    for i, v in ipairs(fields) do
      print("\t", v[1], v[2], "\t", v[3])
    end
  else
    print(o)
  end
end

pp = p

function praw(o)
  p(o, true)
end

local function descFrame(info)
  local funcname = info.name or "?"
  local short_src = info.short_src or "nil"
  local linedefined = info.linedefined or -1
  local currentline = info.currentline or -1
  if funcname ~= "?" then
    funcname = "'" .. funcname .. "'"
  else
    funcname = string.format("<%s:%i>", short_src, linedefined)
  end
  return string.format("%s:%i: in function %s", short_src, currentline, funcname)
end

function l(level)
  level = level or 0
  level = level + 5
  local info = debug.getinfo(level)
  print(descFrame(info))
  print("local values:")
  local i = 1
  local n, v
  repeat
    n, v = debug.getlocal(level, i)
    if n then
      _G[n] = v
      xpcall(function()
        print("\t", n, "\t", v)
      end, function(msg)
        print(msg)
      end)
    end
    i = i + 1
  until n == nil
  print("up values:")
  local i = 1
  local n, v
  repeat
    n, v = debug.getupvalue(info.func, i)
    if n then
      _G[n] = v
      xpcall(function()
        print("\t", n, "\t", v)
      end, function(msg)
        print(msg)
      end)
    end
    i = i + 1
  until n == nil
end

enable_dump = EDFLAGIOS

function EDDebug(msg)
  print = _print
  if (EDFLAGIOS or EDFLAGANDROID) and buglyReportLuaException then
    buglyReportLuaException(tostring(msg), debug.traceback())
  end
  if enable_dump then
    if senddumpfile then
      local text = _tostring(msg) .. "\n" .. debug.traceback()
      senddumpfile(text)
    end
    enable_dump = false
  end
  local p = EDLog and EDLog or print
  if ed.enableBotMode then
    p = print
  end
  local debugWindow
  if ed.debug_mode and not EDFLAGWIN32 and debugError then
    local _p = p
    
    function p(msg)
      _p(msg)
      debugWindow = debugError.showError(msg)
    end
  end
  if ed.open_debug then
    EDDebug2(msg)
  end
  local local_msg = string.format("LUA ERROR: %s", tostring(msg or ""))
  p("----------------------------------------")
  if msg then
    p(local_msg)
  end
  local i = 2
  local info = debug.getinfo(i)
  local_msg = string.format([[
%s
%s]], local_msg, "Stack traceback:")
  p("Stack traceback:")
  repeat
    local_msg = string.format([[
%s
[%i]	%s]], local_msg, i - 2, descFrame(info))
    p(string.format("[%i]\t%s", i - 2, descFrame(info)))
    if debugWindow then
      debugWindow:getStackValues(i)
    end
    i = i + 1
    info = debug.getinfo(i)
  until not info
  p("----------------------------------------")
  if ed.debug_mode and not EDFLAGWIN32 then
    saveLocalError(local_msg)
  end
  local errMsg = string.format("LUA ERROR: %s\n", msg or "")
  if errReport then
    errReport("crash_dump", errMsg)
  end
  if EDFLAGWIN32 then
    EDConsoleEnable(0)
    debug.debug()
    EDConsoleEnable(1)
  elseif EDFLAGSVR then
    debug.debug()
  end
end

local log_index = 1

function EDDebug2(msg)
  local text = tostring(msg) .. "\n" .. debug.traceback()
  local compressData = CCFileUtils:sharedFileUtils():compressDataQuickLz(text)
  if compressData then
    local battle_msg = ed.upmsg.report_battle()
    battle_msg._id = tonumber(ed.getUserid()) + log_index * 100000
    battle_msg._data = compressData
    ed.send(battle_msg, "report_battle", true)
  end
  log_index = log_index + 1
end

function saveLocalError(text)
  local cur_index = ed.storage.getString("current_local_error_key")
  if not cur_index or cur_index == "" then
    cur_index = 0
  else
    cur_index = tonumber(cur_index) or 0
  end
  cur_index = cur_index + 1
  ed.storage.setValue("current_local_error_key", tostring(cur_index))
  text = string.format([[
current index %d
uid : %s  devID: %s  time: %s
%s]], cur_index, tostring(ed.getUserid()), tostring(ed.getDeviceId()), os.date("%Y-%m-%d-%H-%M-%S"), text)
  local folder = CCFileUtils:sharedFileUtils():getWritablePath()
  local dumpfile = string.format("%s/dump_local_error_%s.txt", folder, tostring(cur_index))
  local data = io.open(dumpfile, "wb")
  if data then
    data:write(text)
    data:close()
  end
end

function showLocalError(index)
  local cur_index = ed.storage.getString("current_local_error_key")
  if not cur_index or cur_index == "" then
    ed.showToast(T("\230\156\172\229\156\176\230\178\161\230\156\137error\230\150\135\228\187\182"))
    return
  end
  if not index or index == "" or tonumber(index) < 1 or tonumber(index) > tonumber(cur_index) then
    index = tonumber(cur_index)
  end
  local folder = CCFileUtils:sharedFileUtils():getWritablePath()
  local dumpfile = string.format("%s/dump_local_error_%s.txt", folder, tostring(index))
  local data = io.open(dumpfile, "rb")
  if data then
    local content = data:read("*a")
    local debugWindow = debugError.showLocalFileError(content)
    data:close()
  end
end

function EDBuglySetUser(userId)
  if (EDFLAGIOS or EDFLAGANDROID) and buglySetUserId then
    userId = userId or "Unknown#role_id"
    buglySetUserId(userId)
  end
end

function EDBuglySetTag(tag)
  if (EDFLAGIOS or EDFLAGANDROID) and buglySetTag then
    buglySetTag(tag)
  end
end

function EDBuglyLog(log)
  if (EDFLAGIOS or EDFLAGANDROID) and buglyLog then
    buglyLog(log)
  end
end

function EDEngineVersion()
  if EDGetEngineVersion then
    return EDGetEngineVersion()
  else
    return 0
  end
end
