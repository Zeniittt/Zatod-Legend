local class = {
  mt = {}
}
class.mt.__index = class
ed.localnotify = class
local data = {
  {
    timePoint = "12:00",
    iKey = "am_vit",
    iTag = "day",
    iDate = nil,
    iText = T("\232\177\170\229\141\142\229\141\136\233\164\144\230\151\182\233\151\180\229\136\176\228\186\134\239\188\140\228\189\160\233\151\187\229\136\176\233\184\161\232\133\191\231\154\132\233\166\153\229\145\179\228\186\134\228\185\136\239\188\159"),
    id = 161,
    ticker = T("\232\177\170\229\141\142\229\141\136\233\164\144\230\151\182\233\151\180\229\136\176\228\186\134\239\188\129"),
    title = T("\232\177\170\229\141\142\229\141\136\233\164\144"),
    text = T("\229\141\136\233\164\144\230\151\182\233\151\180\229\136\176\228\186\134\239\188\140\228\189\160\233\151\187\229\136\176\233\184\161\232\133\191\231\154\132\233\166\153\229\145\179\228\186\134\228\185\136\239\188\159"),
    tag = "repeated",
    triggerAtMillis = nil,
    intervalAtMillis = 86400
  },
  {
    timePoint = "18:00",
    iKey = "pm_vit",
    iTag = "day",
    iDate = nil,
    iText = T("\232\177\170\229\141\142\230\153\154\233\164\144\230\151\182\233\151\180\229\136\176\228\186\134\239\188\140\228\189\160\233\151\187\229\136\176\233\184\161\232\133\191\231\154\132\233\166\153\229\145\179\228\186\134\228\185\136\239\188\159"),
    id = 162,
    ticker = T("\232\177\170\229\141\142\230\153\154\233\164\144\230\151\182\233\151\180\229\136\176\228\186\134\239\188\129"),
    title = T("\232\177\170\229\141\142\230\153\154\233\164\144"),
    text = T("\230\153\154\233\164\144\230\151\182\233\151\180\229\136\176\228\186\134\239\188\140\228\189\160\233\151\187\229\136\176\233\184\161\232\133\191\231\154\132\233\166\153\229\145\179\228\186\134\228\185\136\239\188\159"),
    tag = "repeated",
    triggerAtMillis = nil,
    intervalAtMillis = 86400
  },
  {
    iKey = "vit_full",
    iTag = "",
    iDate = nil,
    iText = T("\230\136\152\233\152\159\228\189\147\229\138\155\229\183\178\229\155\158\229\164\141\230\187\161\239\188\140\228\189\160\231\154\132\232\139\177\233\155\132\228\187\172\229\183\178\230\140\137\230\141\186\228\184\141\228\189\143\228\186\134\239\188\129"),
    id = 165,
    ticker = T("\230\136\152\233\152\159\228\189\147\229\138\155\229\183\178\229\155\158\229\164\141\230\187\161"),
    title = T("\228\189\147\229\138\155\229\183\178\229\155\158\229\164\141\230\187\161"),
    text = T("\230\136\152\233\152\159\228\189\147\229\138\155\229\183\178\229\155\158\229\164\141\230\187\161\239\188\140\228\189\160\231\154\132\232\139\177\233\155\132\228\187\172\229\183\178\230\140\137\230\141\186\228\184\141\228\189\143\228\186\134\239\188\129"),
    tag = "once",
    triggerAtMillis = nil
  },
  {
    timePoint = "9:00",
    iKey = "am_shop",
    iTag = "day",
    iDate = nil,
    iText = T("\229\184\140\229\168\156\231\154\132\229\176\143\229\186\151\232\180\167\231\137\169\229\183\178\230\155\180\230\150\176\239\188\140\229\191\171\230\157\165\233\128\137\232\180\173\229\144\167\239\188\129"),
    id = 163,
    ticker = T("\229\149\134\229\186\151\232\180\167\231\137\169\229\183\178\230\155\180\230\150\176"),
    title = T("\229\149\134\229\186\151\232\180\167\231\137\169\229\183\178\230\155\180\230\150\176"),
    text = T("\229\184\140\229\168\156\231\154\132\229\176\143\229\186\151\232\180\167\231\137\169\229\183\178\230\155\180\230\150\176\239\188\140\229\191\171\230\157\165\233\128\137\232\180\173\229\144\167\239\188\129"),
    tag = "repeated",
    triggerAtMillis = nil,
    intervalAtMillis = 86400
  },
  {
    timePoint = "21:00",
    iKey = "pm_shop",
    iTag = "day",
    iDate = nil,
    iText = T("\229\164\156\229\174\181\230\151\182\233\151\180\229\136\176\228\186\134\239\188\140\228\189\160\228\184\128\229\174\154\233\165\191\228\186\134\229\144\167\239\188\159"),
    id = 164,
    ticker = T("\232\177\170\229\141\142\229\164\156\229\174\181\230\151\182\233\151\180\229\136\176\228\186\134\239\188\129"),
    title = T("\232\177\170\229\141\142\229\164\156\229\174\181"),
    text = T("\229\164\156\229\174\181\230\151\182\233\151\180\229\136\176\228\186\134\239\188\140\228\189\160\228\184\128\229\174\154\233\165\191\228\186\134\229\144\167\239\188\159"),
    tag = "repeated",
    triggerAtMillis = nil,
    intervalAtMillis = 86400
  },
  {
    iKey = "skill_full",
    iTag = "",
    iDate = nil,
    iText = T("\230\138\128\232\131\189\231\130\185\229\183\178\230\129\162\229\164\141\230\187\161\239\188\140\232\191\153\230\172\161\232\166\129\230\143\144\229\141\135\229\147\170\228\189\141\232\139\177\233\155\132\229\145\162\239\188\159"),
    id = 166,
    ticker = T("\230\138\128\232\131\189\231\130\185\229\183\178\230\187\161"),
    title = T("\230\138\128\232\131\189\231\130\185\229\183\178\230\129\162\229\164\141\230\187\161"),
    text = T("\230\138\128\232\131\189\231\130\185\229\183\178\230\129\162\229\164\141\230\187\161\239\188\140\232\191\153\230\172\161\232\166\129\230\143\144\229\141\135\229\147\170\228\189\141\232\139\177\233\155\132\229\145\162\239\188\159"),
    tag = "once",
    triggerAtMillis = nil
  }
}
class.data = data

local function getNotifyDateByTimeString(str)
  local date = ed.getTimeByTodayHMS(str)
  local svr_zone = resource_config.local_notify_with_server_time_zone
  if svr_zone then
    local date = ed.getTimeByTodayHMSWithServer(str)
    date = date - svr_zone * 3600
  end
  local nt = ed.getServerTime()
  if date <= nt then
    return date + 86400
  end
  return date
end

class.getNotifyDateByTimeString = getNotifyDateByTimeString

local function getVitalityFullDate()
  local max = ed.playerlimit.maxVitality()
  local current = ed.player:getVitality()
  local lack = math.max(max - current - 1, 0)
  local gap = ed.parameter.sync_vitality_gap
  local vn = ed.player:getVitalityNextUpdate()
  if max <= current then
    return 0
  end
  return gap * lack + vn + ed.getServerTime()
end

class.getVitalityFullDate = getVitalityFullDate

local function getSkillFullDate()
  return 0
end

class.getSkillFullDate = getSkillFullDate

local function getNotifyDate(id)
  if ed.isElementInTable(id, {
    1,
    2,
    4,
    5
  }) then
    return getNotifyDateByTimeString(class.data[id].timePoint)
  elseif id == 3 then
    return getVitalityFullDate()
  elseif id == 6 then
    return getSkillFullDate()
  end
end

class.getNotifyDate = getNotifyDate

local function setSwitch(id)
  local data = ed.loadNotificationData()
  local isOn
  for k, v in pairs(data) do
    if v == id then
      table.remove(data, k)
      isOn = true
      break
    end
  end
  if not isOn then
    table.insert(data, id)
  end
  ed.saveNotificationData(data)
  class.refresh()
end

class.setSwitch = setSwitch

local function getSwitch(id)
  return false
end

class.getSwitch = getSwitch

local function refreshAndroid()
  local nInfo = {
    data = {}
  }
  for i = 1, #class.data do
    local nd = class.data[i]
    local date = getNotifyDate(i)
    nd.iDate = date
    nd.triggerAtMillis = date
    if 0 < date and getSwitch(i) then
      table.insert(nInfo.data, nd)
    end
  end
  EDAndroidExtra("setAlarmData", ed.getJson(nInfo))
end

class.refreshAndroid = refreshAndroid

local function refreshIOS()
  for i = 1, #class.data do
    local nd = class.data[i]
    local date = getNotifyDate(i)
    local key = nd.iKey
    local text = nd.iText
    local tag = nd.iTag
    if 0 < date and getSwitch(i) then
      EDCancelNotification(key)
      EDAddNotification(key, text, tag, date)
    else
      EDCancelNotification(key)
    end
  end
end

class.refreshIOS = refreshIOS

local function refresh()
  if EDFLAGANDROID then
    refreshAndroid()
  end
  if EDFLAGIOS then
    refreshIOS()
  end
end

class.refresh = refresh

local function init()
  if EDFLAGANDROID then
    local ids = {
      piids = {}
    }
    for i = 1, #class.data do
      table.insert(ids.piids, class.data[i].id)
    end
    EDAndroidExtra("clearAlarm", ed.getJson(ids))
  end
  if EDFLAGIOS then
  end
  refresh()
end

class.init = init
