ed.serverTimeZone = 8
ed.serverTimeDst = false
ed.timestamps = {}

local function setServerTimeZone(zone)
  if zone then
    ed.serverTimeZone = zone
  end
  print("set server time zone success ", zone)
end

ed.setServerTimeZone = setServerTimeZone

local function setServerTimestamp(timestamps)
  if ed.timestamps == nil or #ed.timestamps == 0 then
    ListenEvent("applicationWillEnterForeground", function()
      if not ed.getUserid() then
        return
      end
      ed.requestServerTimestamps(5)
    end)
  end
  ed.timestamps = {}
  local i = 1
  local timestamps = timestamps or {}
  for k, v in pairs(timestamps) do
    ed.timestamps[i] = {
      next_day_5am = v._next_day_ts,
      next_week_5am = v._next_week_ts,
      next_month_5am = v._next_month_ts
    }
    i = i + 1
  end
  if ed.startNext5AmTimer then
    ed.startNext5AmTimer()
  end
end

ed.setServerTimestamp = setServerTimestamp

local function requestSyncServerTimestamps(days)
  local days = days or 2
  local msg = ed.upmsg.sync_timestamps()
  msg._days = days
  ed.send(msg, "sync_timestamps")
end

ed.requestServerTimestamps = requestSyncServerTimestamps

local function getTime()
  local year, month, day, hour, minute, second, time, million = EDTime()
  return {
    year = year,
    month = month,
    day = day,
    hour = hour,
    minute = minute,
    second = second,
    time = time,
    million = million
  }
end

ed.getTime = getTime

local function systemTime2hms()
  local time = ed.getTime()
  return string.format("%02d:%02d:%02d", time.hour, time.minute, time.second)
end

ed.systemTime2hms = systemTime2hms

local function getSystemTime()
  local time = ed.getTime()
  return time.time
end

ed.getSystemTime = getSystemTime

local function getMillionTime()
  local time = ed.getTime()
  return time.million
end

ed.getMillionTime = getMillionTime

local function time2dhm(t)
  local str = ""
  if 86400 <= t then
    local d = math.floor(t / 86400)
    local h = math.floor((t - d * 86400) / 3600)
    str = tostring(d) .. T("\229\164\169")
    if 0 < h then
      str = str .. tostring(h) .. T("\229\176\143\230\151\182")
    end
  elseif 3600 <= t then
    local h = math.floor(t / 3600)
    local m = math.floor((t - h * 3600) / 60)
    str = tostring(h) .. T("\229\176\143\230\151\182")
    if 0 < m then
      str = str .. tostring(m) .. T("\229\136\134")
    end
  else
    local m = math.floor(t / 60)
    local s = math.floor(t % 60)
    if 0 < m then
      str = tostring(m) .. T("\229\136\134")
    elseif 0 < s then
      str = T("1\229\136\134")
    else
      str = T("0\229\136\134")
    end
  end
  return str
end

ed.time2dhm = time2dhm

local function time2dhmOnly(t)
  local str = ""
  if 86400 <= t then
    local d = math.floor(t / 86400)
    local h = math.floor((t - d * 86400) / 3600)
    str = tostring(d) .. T("\229\164\169")
    return str
  elseif 3600 <= t then
    local h = math.floor(t / 3600)
    local m = math.floor((t - h * 3600) / 60)
    str = tostring(h) .. T("\229\176\143\230\151\182")
    return str
  else
    local m = math.floor(t / 60)
    local s = math.floor(t % 60)
    if 0 < m then
      str = tostring(m) .. T("\229\136\134")
    elseif 0 < s then
      str = "1" .. T("\229\136\134")
    else
      str = "0" .. T("\229\136\134")
    end
  end
  return str
end

ed.time2dhmOnly = time2dhmOnly

local function time2dhms(t)
  local str = ""
  if 86400 <= t then
    local d = math.floor(t / 86400)
    local h = math.floor((t - d * 86400) / 3600)
    str = tostring(d) .. T("\229\164\169")
    if 0 < h then
      str = str .. tostring(h) .. T("\229\176\143\230\151\182")
    end
  elseif 3600 <= t then
    local h = math.floor(t / 3600)
    local m = math.floor((t - h * 3600) / 60)
    str = tostring(h) .. T("\229\176\143\230\151\182")
    if 0 < m then
      str = str .. tostring(m) .. T("\229\136\134")
    end
  else
    local m = math.floor(t / 60)
    local s = math.floor(t % 60)
    if 0 < m then
      str = tostring(m) .. T("\229\136\134")
    end
    if 0 < s or m == 0 then
      str = str .. tostring(s) .. T("\231\167\146")
    end
  end
  return str
end

ed.time2dhms = time2dhms

local function time2dhmsV2(t, show_min)
  local str = ""
  if 86400 <= t then
    local d = math.floor(t / 86400)
    local h = math.floor((t - d * 86400) / 3600)
    str = tostring(d) .. T("\229\164\169")
    if 0 < h then
      str = str .. tostring(h) .. T("\229\176\143\230\151\182")
    end
    if show_min then
      local m = math.floor((t - d * 86400 - h * 3600) / 60)
      if 0 < m then
        str = str .. tostring(m) .. T("\229\136\134")
      end
    end
  elseif 3600 <= t then
    local h = math.floor(t / 3600)
    local m = math.floor((t - h * 3600) / 60)
    str = tostring(h) .. T("\229\176\143\230\151\182")
    if 0 < m then
      str = str .. tostring(m) .. T("\229\136\134")
    end
  elseif 60 <= t then
    local m = math.floor(t / 60)
    if 0 < m then
      str = tostring(m) .. T("\229\136\134")
    end
  else
    str = T("\229\176\143\228\186\1421\229\136\134\233\146\159")
  end
  return str
end

ed.time2dhmsV2 = time2dhmsV2

local function time2hm(t)
  local h = math.floor(t / 3600)
  local m = math.floor((t - h * 3600) / 60)
  return tostring(h) .. T("\229\176\143\230\151\182") .. tostring(m) .. T("\229\136\134")
end

ed.time2hm = time2hm

local function getClientTimeZone()
  local zoneTime = os.date("*t", os.time())
  local zoneYear = zoneTime.year
  local zoneYDay = zoneTime.yday
  local zoneDst = zoneTime.isdst
  local zoneH = zoneTime.hour
  local zoneMin = zoneTime.min
  local zeroTime = os.date("!*t", os.time())
  local zeroYear = zeroTime.year
  local zeroYDay = zeroTime.yday
  local zeroDst = zeroTime.isdst
  local zeroH = zeroTime.hour
  local zeroMin = zeroTime.min
  if zoneYear > zeroYear then
    zoneH = zoneH + 24
  elseif zoneYear < zeroYear then
    zeroH = zeroH + 24
  elseif zoneYDay > zeroYDay then
    zoneH = zoneH + 24
  elseif zoneYDay < zeroYDay then
    zeroH = zeroH + 24
  end
  if zoneDst then
    zeroH = zeroH + 1
  end
  local zoneOffsetHours = zoneH - zeroH
  local zoneOffsetMinutes = zoneMin - zeroMin
  if zoneOffsetMinutes < 0 then
    zoneOffsetHours = zoneOffsetHours - 1
    zoneOffsetMinutes = zoneOffsetMinutes + 60
  end
  return zoneOffsetHours, zoneDst, zoneOffsetMinutes
end

ed.getClientTimeZone = getClientTimeZone

local function getTimeDiff2Server()
  local serverZone = ed.serverTimeZone
  local zone, zoneDst, zoneMin = getClientTimeZone()
  if zoneDst then
    zone = zone + 1
  end
  local serverTimeEqualZone, clientTimeEqualZone = serverZone, zone
  local diff = serverTimeEqualZone - clientTimeEqualZone
  return diff * 3600 - zoneMin * 60
end

ed.getTimeDiff2Server = getTimeDiff2Server

local function getFitTime(time)
  local time = time or ed.getServerTime()
  time = time + ed.getTimeDiff2Server()
  return time, ed.time2YMD(time)
end

local function getServerTime()
  local diff = ed.player.time_diff or 0
  local time = ed.getSystemTime() + diff
  return time, ed.time2YMD(time + ed.getTimeDiff2Server())
end

ed.getServerTime = getServerTime

local function getFitServerTime()
  return getFitTime()
end

ed.getFitServerTime = getFitServerTime

local function time2China(time)
  return getFitTime(time)
end

ed.time2China = time2China

local function time2Server(time)
  return getFitTime(time)
end

ed.time2Server = time2Server

local function getServerMillionTime()
  local diff = ed.player.time_diff
  local time = ed.getTime().million + diff
  return time
end

ed.getServerMillionTime = getServerMillionTime

local function serverTime2HMS(time)
  local h, m, s = ed.time2HMS(time)
  return string.format("%02d:%02d:%02d", h, m, s)
end

ed.serverTime2HMS = serverTime2HMS

local function getTodayOriginTime()
  local st = ed.getServerTime()
  local h, m, s = ed.time2HMS()
  return st - (3600 * h + 60 * m + s)
end

ed.getTodayOriginTime = getTodayOriginTime

local function getTodayOriginTimeWithServer()
  local st = ed.getFitServerTime()
  local h, m, s = ed.time2HMS(st)
  return st - (3600 * h + 60 * m + s)
end

ed.getTodayOriginTimeWithServer = getTodayOriginTimeWithServer

local function getTimeByTodayHMS(t)
  local ot = ed.getTodayOriginTime()
  local h, m, s = 0, 0, 0
  if type(t) == "table" then
    h, m, s = t.h, t.m, t.s
  elseif type(t) == "string" then
    h, m, s = ed.hmsNString2HMS(t)
  end
  return ot + (3600 * h + 60 * m + s)
end

ed.getTimeByTodayHMS = getTimeByTodayHMS

local function getTimeByTodayHMSWithServer(t)
  local ot = ed.getTodayOriginTimeWithServer()
  local h, m, s = 0, 0, 0
  if type(t) == "table" then
    h, m, s = t.h, t.m, t.s
  elseif type(t) == "string" then
    h, m, s = ed.hmsNString2HMS(t)
  end
  return ot + (3600 * h + 60 * m + s)
end

ed.getTimeByTodayHMSWithServer = getTimeByTodayHMSWithServer

local function getTimeByYMDHMS(t)
  local y, mon, d, h, m, s = 1970, 1, 1, 24, 0, 0
  if type(t) == "table" then
    y, mon, d, h, m, s = t.y, t.mon, t.d, t.h, t.m, t.s
  elseif type(t) == "string" then
    y, mon, d, h, m, s = ed.ymdhmsNString2YMDHMS(t)
  end
  return os.time({
    day = d,
    month = mon,
    year = y,
    hour = h,
    min = m,
    sec = s
  })
end

ed.getTimeByYMDHMS = getTimeByYMDHMS

local function hmsNString2HMS(s, timeFix)
  timeFix = timeFix or 0
  local t = {}
  for k in string.gfind(s, "%d+") do
    table.insert(t, k)
  end
  local h = tonumber(t[1]) or 0
  local m = tonumber(t[2]) or 0
  local s = tonumber(t[3]) or 0
  h = h + timeFix / 3600
  m = m + timeFix % 3600 / 60
  s = s + timeFix % 3600 % 60
  return h, m, s
end

ed.hmsNString2HMS = hmsNString2HMS

local function ymdhmsNString2YMDHMS(s, timeFix)
  timeFix = timeFix or 0
  local t = {}
  for k in string.gfind(s, "%d+") do
    table.insert(t, k)
  end
  local y = tonumber(t[1]) or 0
  local mon = tonumber(t[2]) or 0
  local d = tonumber(t[3]) or 0
  local h = tonumber(t[4]) or 0
  local m = tonumber(t[5]) or 0
  local s = tonumber(t[6]) or 0
  return y, mon, d, h, m, s
end

ed.ymdhmsNString2YMDHMS = ymdhmsNString2YMDHMS

local function time2YMDHMS(time)
  time = time or ed.getFitServerTime()
  return os.date("%Y", time), os.date("%m", time), os.date("%d", time), os.date("%H", time), os.date("%M", time), os.date("%S", time)
end

ed.time2YMDHMS = time2YMDHMS

local function time2YMD(time)
  local y, m, d, h, min, sec = time2YMDHMS(time)
  return y, m, d
end

ed.time2YMD = time2YMD

local function time2HMS(time)
  local y, m, d, h, min, sec = time2YMDHMS(time)
  return h, min, sec
end

ed.time2HMS = time2HMS

local function getMDHTime(time)
  time = time or ed.getFitServerTime()
  local y, mon, d, h, m, s = ed.time2YMDHMS(time)
  return string.format(T("%d\230\156\136%d\230\151\165%d\230\151\182"), mon, d, h)
end

ed.getMDHTime = getMDHTime

local function getMDYTime(time)
  time = time or ed.getFitServerTime()
  local y, mon, d, h, m, s = ed.time2YMDHMS(time)
  return string.format("%d-%d-%d", mon, d, y)
end

ed.getMDYTime = getMDYTime

local function getYMDTime(time)
  time = time or ed.getFitServerTime()
  local y, mon, d, h, m, s = ed.time2YMDHMS(time)
  return string.format("%d-%d-%d", y, mon, d)
end

ed.getYMDTime = getYMDTime

local function second2hms(second)
  local h, m, s = 0, 0, 0
  h = math.floor(second / 3600)
  m = math.floor(second % 3600 / 60)
  s = second % 3600 % 60
  return h, m, s
end

ed.second2hms = second2hms

local function getYMDHMS(time)
  time = time or ed.getFitServerTime()
  local y, mon, d, h, m, s = ed.time2YMDHMS(time)
  local t = {
    year = y,
    month = mon,
    day = d,
    hour = h,
    minute = m,
    second = s
  }
  return t
end

ed.getYMDHMS = getYMDHMS

local function getYMDHMSTime(time, mode)
  time = time or ed.getYMDHMS()
  if type(time) ~= "table" then
    time = ed.getYMDHMS(time)
  end
  if mode == "mail" then
    return string.format("%d/%d/%d %d:%d", time.year, time.month, time.day, time.hour, time.minute)
  end
  if mode == "eqipe" and time.minute then
    local minute = tonumber(time.minute)
    if minute < 10 then
      return string.format(T("%d\229\185\180%d\230\156\136%d\230\151\165 %d:0%d"), time.year, time.month, time.day, time.hour, time.minute)
    else
      return string.format(T("%d\229\185\180%d\230\156\136%d\230\151\165 %d:%d"), time.year, time.month, time.day, time.hour, time.minute)
    end
  end
  if mode == "goback" then
    return string.format("%d.%d.%d", time.year, time.month, time.day)
  end
  if mode == "standard" then
    return string.format("%d-%d-%d %02d:%02d:%02d", time.year, time.month, time.day, time.hour, time.minute, time.second)
  end
  return string.format("%d-%d-%d %d:%d:%d", time.year, time.month, time.day, time.hour, time.minute, time.second)
end

ed.getYMDHMSTime = getYMDHMSTime

local function getCurrentHMS()
  local time = ed.getFitServerTime()
  local h, m, s = os.date("%H", time), os.date("%M", time), os.date("%S", time)
  return h, m, s
end

ed.getCurrentHMS = getCurrentHMS

local function hms2Second(h, m, s)
  return 3600 * h + 60 * m + s
end

ed.hms2Second = hms2Second

local function isTimeAfter(front)
  local now = ed.hms2Second(ed.getCurrentHMS())
  return front < now
end

ed.isTimeAfter = isTimeAfter

local function isTimeBefore(after)
  local now = ed.hms2Second(ed.getCurrentHMS())
  return after > now
end

ed.isTimeBefore = isTimeBefore

local function isTimeBetween(front, back)
  return isTimeAfter(front) and isTimeBefore(back)
end

ed.isTimeBetween = isTimeBetween

local function getdhmsCString(second, showSecond)
  local h, m, s = ed.second2hms(second)
  local d = math.floor(h / 24)
  local h = h % 24
  local time = ""
  local dotStr = resource_config.is_break_work_with_space and " " or ""
  if 0 < d then
    time = time .. d .. dotStr .. T("\229\164\169")
  end
  if 0 < h then
    time = time .. h .. dotStr .. T("\229\176\143\230\151\182")
  end
  if 0 < m then
    time = time .. m .. dotStr .. T("\229\136\134\233\146\159")
  end
  if showSecond or time == "" then
    time = time .. s .. dotStr .. T("\231\167\146")
  end
  return time
end

ed.getdhmsCString = getdhmsCString

local function gethmsCString(second)
  local h, m, s = ed.second2hms(second)
  local time = ""
  if 0 < h then
    time = time .. h .. T("\229\176\143\230\151\182")
  end
  if 0 < h or 0 < m then
    time = time .. m .. T("\229\136\134\233\146\159")
  end
  if h <= 0 then
    time = time .. s .. T("\231\167\146")
  end
  return time
end

ed.gethmsCString = gethmsCString

local function gethmsNString(second)
  local h, m, s = ed.second2hms(second)
  return string.format("%02d:%02d:%02d", h, m, s)
end

ed.gethmsNString = gethmsNString

local function getmsNString(second)
  local h, m, s = ed.second2hms(second)
  return string.format("%02d:%02d", m, s)
end

ed.getmsNString = getmsNString

local function getWeekdayIndex(time)
  local index = {
    Monday = 1,
    Tuesday = 2,
    Wednesday = 3,
    Thursday = 4,
    Friday = 5,
    Saturday = 6,
    Sunday = 7
  }
  local name = ed.getWeekdayName(time)
  return index[name]
end

ed.getWeekdayIndex = getWeekdayIndex

local function getWeekdayCnName(time)
  local index = {
    Monday = T("\230\152\159\230\156\159\228\184\128"),
    Tuesday = T("\230\152\159\230\156\159\228\186\140"),
    Wednesday = T("\230\152\159\230\156\159\228\184\137"),
    Thursday = T("\230\152\159\230\156\159\229\155\155"),
    Friday = T("\230\152\159\230\156\159\228\186\148"),
    Saturday = T("\230\152\159\230\156\159\229\133\173"),
    Sunday = T("\230\152\159\230\156\159\230\151\165")
  }
  time = time or ed.getFitServerTime()
  local name = os.date("%A", time)
  return index[name]
end

ed.getWeekdayCnName = getWeekdayCnName

local function getWeekdayName(time)
  local time = time or ed.getFitServerTime()
  return os.date("%A", time)
end

ed.getWeekdayName = getWeekdayName

local function getNextWeekdayName()
  local time = ed.getFitServerTime() + 86400
  return os.date("%A", time)
end

ed.getNextWeekdayName = getNextWeekdayName

local function getPreWeekdayName()
  local time = ed.getFitServerTime() - 86400
  return os.date("%A", time)
end

ed.getPreWeekdayName = getPreWeekdayName

local function getRefreshWeek()
  local week = ed.getWeekdayIndex()
  if ed.checkBOA() == "before" then
    week = week - 1
    if week < 0 then
      week = 7
    end
  end
  return week
end

ed.getRefreshWeek = getRefreshWeek
local reset_time = {h = 5, m = 0}

local function checkTwoDateom(lt, nt)
  local d1 = ed.getYMDHMS(lt)
  local y1 = tonumber(d1.year)
  local m1 = tonumber(d1.month)
  local d2 = ed.getYMDHMS(nt)
  local y2 = tonumber(d2.year)
  local m2 = tonumber(d2.month)
  local t = math.max(lt, nt)
  local d = ed.getYMDHMS(t)
  local day = tonumber(d.day)
  if day == 1 and ed.checkTwoDateod(lt, nt) then
    return true
  end
end

ed.checkTwoDateom = checkTwoDateom

local function checkTodayom()
  local nt = ed.getServerTime()
  local lt = nt - 86400
  return checkTwoDateom(lt, nt)
end

ed.checkTodayom = checkTodayom

local function checkTwoDateow(lt, nt)
  local record = ed.record
  record.lastResetTime = record.lastResetTime or ed.player._last_login
  local lt = lt or record.lastResetTime
  local nt = nt or ed.getServerTime()
  local weekSpaceTime = 604800
  if weekSpaceTime < math.abs(nt - lt) then
    return true
  end
  if ed.timestamps and #ed.timestamps > 1 then
    for i = 1, #ed.timestamps do
      local next_week_5am = ed.timestamps[i].next_week_5am
      local curweek5am = next_week_5am - weekSpaceTime
      if lt < curweek5am and nt >= curweek5am then
        return true
      end
      if lt < next_week_5am and nt >= next_week_5am then
        return true
      end
    end
    return false
  end
  lt = getFitTime(lt)
  nt = getFitTime(nt)
  local y, m, d, h, mi, s = ed.time2YMDHMS(nt)
  local dayIndex = ed.getWeekdayIndex(nt)
  local resetTime = nt - (dayIndex - 1) * 86400 - (h * 3600 + mi * 60 + s) + (reset_time.h * 3600 + reset_time.m * 60)
  return lt < resetTime
end

ed.checkTwoDateow = checkTwoDateow

local function checkTwoDateod(lt, nt)
  local record = ed.record
  record.lastResetTime = record.lastResetTime or ed.player._last_login
  local lt = lt or record.lastResetTime
  local nt = nt or ed.getServerTime()
  if math.abs(nt - lt) > 86400 then
    return true
  end
  if ed.timestamps and #ed.timestamps > 1 then
    for i = 1, #ed.timestamps do
      local next_day_5am = ed.timestamps[i].next_day_5am
      local today5am = next_day_5am - 86400
      if lt < today5am and nt >= today5am then
        return true
      end
      if lt < next_day_5am and nt >= next_day_5am then
        return true
      end
    end
    return false
  end
  local rt = reset_time
  local y, m, d, h, mi, s = ed.time2YMDHMS(lt + ed.getTimeDiff2Server())
  local ltt = {
    y = tonumber(y),
    mon = tonumber(m),
    d = tonumber(d),
    h = tonumber(h),
    m = tonumber(mi),
    s = tonumber(s),
    t = lt
  }
  y, m, d, h, mi, s = ed.time2YMDHMS(nt + ed.getTimeDiff2Server())
  local ntt = {
    y = tonumber(y),
    mon = tonumber(m),
    d = tonumber(d),
    h = tonumber(h),
    m = tonumber(mi),
    s = tonumber(s),
    t = nt
  }
  local nttboa = ed.checkBOA(ntt)
  local lttboa = ed.checkBOA(ltt)
  if ltt.d == ntt.d then
    if nttboa ~= lttboa then
      return true
    end
  elseif nttboa == lttboa then
    return true
  end
  return false
end

ed.checkTwoDateod = checkTwoDateod

local function checkBOA(t, refer)
  local rt = refer or reset_time
  local h, m
  if t then
    h = tonumber(t.h)
    m = tonumber(t.m)
  else
    h, m = ed.getCurrentHMS()
  end
  local rh = rt.h
  local rm = rt.m
  if 60 * h + m >= 60 * rh + rm then
    return "after"
  end
  return "before"
end

ed.checkBOA = checkBOA

local function getTimeBeforeResetTime()
  local nt, y, m, d = ed.getFitServerTime()
  local e = {
    year = y,
    month = m,
    day = d,
    hour = 5,
    min = 0,
    sec = 0
  }
  e = os.time(e)
  local e2 = e + 86400
  if nt < e then
    return e - nt
  else
    return e2 - nt
  end
end

ed.getTimeBeforeResetTime = getTimeBeforeResetTime

local function checkTimeBetween(param)
  local nt = param.time or ed.getServerTime()
  local rangeString = param.rangeString
  if rangeString then
    for k, v in pairs(rangeString) do
      local tt = {}
      for s in string.gfind(v, "%d+:%d+") do
        local ctt = {}
        for cs in string.gfind(s, "%d+") do
          table.insert(ctt, cs)
        end
        table.insert(tt, {
          h = ctt[1],
          m = ctt[2]
        })
      end
      if ed.checkBOA(nil, tt[1]) == "after" and ed.checkBOA(nil, tt[2]) == "before" then
        return true
      end
    end
  end
  return false
end

ed.checkTimeBetween = checkTimeBetween

local function checkBetweenTwoDate(b, e)
  b = os.time(b)
  e = os.time(e)
  local n = os.time()
  if b <= n and e >= n then
    return true
  end
  return false
end

ed.checkBetweenTwoDate = checkBetweenTwoDate

local function formatTime(time)
  time = ed.time2China(time)
  local wTime = os.date(T("%Y\229\185\180%m\230\156\136%d\230\151\165%H\230\151\182"), time)
  return wTime
end

ed.formatTime = formatTime

local function formatTimeStr(formatStr, time, withUTC)
  time = time or ed.getServerTime()
  time = ed.time2China(time)
  if withUTC then
    formatStr = formatStr .. ed.getUTCLabel()
  end
  local wTime = os.date(formatStr, time)
  return wTime
end

ed.formatTimeStr = formatTimeStr

function ed.timeSchedule(node, callback, delay)
  if not tolua.isnull(node) then
    local array = ccArrayMake(CCDelayTime:create(delay), CCCallFunc:create(callback))
    local sequence = CCSequence:create(array)
    local action = CCRepeatForever:create(sequence)
    node:runAction(action)
    return action
  end
end

function ed.dateStringToTime(dateStr)
  local year, month, day, hour, minutes, second = string.match(dateStr, "(%d+)/(%d+)/(%d+)%s+(%d+):(%d+):(%d+)")
  return os.time({
    day = day,
    month = month,
    year = year,
    hour = hour,
    min = minutes,
    sec = second
  })
end

function ed.dateStringToServerTime(dateStr)
  local year, month, day, hour, minutes, second = string.match(dateStr, "(%d+)/(%d+)/(%d+)%s+(%d+):(%d+):(%d+)")
  return os.time({
    day = day,
    month = month,
    year = year,
    hour = hour,
    min = minutes,
    sec = second
  }) - ed.getTimeDiff2Server()
end

function ed.getUTCLabel()
  if ed.isAreaOverSea() then
    return " (UTC)"
  end
  return ""
end
