local class = newclass()
ed.ui.readconfig = class

local function set(key, value)
  if type(value) ~= "string" then
    print("wrong type of value!")
    return
  end
  local uid = ed.getDeviceId()
  local ip = game_server_id
  ed.storage.setValue(string.format("%s-%s-%s", ip, uid, key), value)
end

class.set = set

local function get(key)
  local uid = ed.getDeviceId()
  local ip = game_server_id
  return ed.storage.getString(string.format("%s-%s-%s", ip, uid, key))
end

class.get = get

local function setTeamString(key, value)
  if type(value) ~= "string" then
    print("wrong type of value!")
    return
  end
  local uid = ed.player:getUUID()
  ed.storage.setValue(string.format("%s-%s", uid, key), value)
end

class.set = set

local function getTeamString(key)
  local uid = ed.player:getUUID()
  return ed.storage.getString(string.format("%s-%s", uid, key))
end

class.get = get

local function getTeamData(key)
  local str = getTeamString(key)
  local team = {}
  for s in string.gfind(str, "%d+,") do
    local id = string.gsub(s, ",", "")
    local number = tonumber(id)
    if ed.player.heroes[number] == nil and number < 100000 then
    else
      table.insert(team, number)
    end
  end
  return team
end

class.getTeamData = getTeamData

local function setTeamData(key, data)
  local str = ""
  for i = 1, #(data or {}) do
    str = str .. data[i] .. ","
  end
  setTeamString(key, str)
end

class.setTeamData = setTeamData
local visit_team_handler = {
  common = "td_cm",
  pvp = "td_pp",
  nophysical = "td_np",
  nomagical = "td_nm",
  female = "td_fm",
  exp = "td_exp",
  gold = "td_gold",
  toppvp_1 = "td_tpp_1",
  toppvp_2 = "td_tpp_2",
  toppvp_3 = "td_tpp_3",
  spring1 = "td_s1",
  spring2 = "td_s2",
  spring3 = "td_s3",
  spring4 = "td_s4",
  spring5 = "td_s5",
  spring6 = "td_s6",
  spring7 = "td_s7",
  ancients = "td_an",
  thronetower = "td_tht",
  dreamland = "td_dl",
  artifact1 = "td_a1",
  artifact2 = "td_a2",
  artifact3 = "td_a3",
  artifact4 = "td_a4",
  nightmare1 = "nt_1",
  nightmare2 = "nt_2",
  artifactprepare = "artf_1",
  legendpvp_1 = "td_lep_1",
  legendpvp_2 = "td_lep_2",
  legendpvp_3 = "td_lep_3",
  legendpvp_4 = "td_lep_4",
  legendpvp_5 = "td_lep_5",
  legendpvp_6 = "td_lep_6",
  legendpvp_7 = "td_lep_7",
  multistage = "multistage",
  share_fight = "share_fight",
  HadesHeat = "HadesHeat",
  AwakeStage = "AwakeStage",
  rogueFight = "rogueFight"
}

function ed.setTeamData(type, data)
  local key = visit_team_handler[type] or type
  setTeamData(key, data)
end

function ed.getTeamData(type)
  local key = visit_team_handler[type] or type
  return getTeamData(key)
end

function ed.resetNotificationData()
  local key = "nt_nt"
  set(key, "")
end

function ed.saveNotificationData(data)
  local tKey = "nt_fn"
  local key = "nt_nt"
  local str = ""
  for k, v in pairs(data) do
    if v then
      str = str .. v .. ","
    end
  end
  set(tKey, "fls")
  set(key, str)
end

function ed.loadNotificationData()
  local tKey = "nt_fn"
  local key = "nt_nt"
  local tag = get(tKey)
  local str = get(key)
  local data = {}
  for s in string.gfind(str, "%d+,") do
    local id = string.gsub(s, ",", "")
    id = tonumber(id)
    table.insert(data, id)
  end
  return data, tag
end

function ed.saveSoundSwitch()
  local v = ed.soundSwitch and "y" or "n"
  ed.storage.setValue("swq_s", v)
  local v = ed.soundEffect and "y" or "n"
  ed.storage.setValue("swq_s_ef", v)
end

function ed.loadSoundSwitch()
  ed.soundSwitch = ed.storage.getString("swq_s") ~= "n"
  ed.soundEffect = ed.storage.getString("swq_s_ef") ~= "n"
  EDSetSoundSwitch(ed.soundEffect and 0 or 1)
end

function ed.saveLegendEquip()
  local v = ed.off_legendEquipOp and "y" or "n"
  ed.storage.setValue("swq_legend", v)
end

function ed.loadLegendEquip()
  ed.off_legendEquipOp = ed.storage.getString("swq_legend") ~= "n"
end

function ed.checkFirstUncompress()
  if EDFLAGANDROID then
    local versionCode = EDGetVersionCode()
    local c = ed.storage.getString("fuc_" .. versionCode)
    if c == "done" then
      return true
    else
      return false
    end
  end
  return nil
end

function ed.doneFirstUncompress()
  local versionCode = EDGetVersionCode()
  ed.storage.setValue("fuc_" .. versionCode, "done")
end

function ed.hasSaveLanguage()
  local language = ed.storage.getString("dt_lang") or ""
  if language == "" then
    return false
  end
  return true
end

function ed.saveLanguage(language)
  EDLog("-->>set language : " .. language)
  language = language or ""
  ed.storage.setValue("dt_lang", language)
end

function ed.loadLanguage()
  local language = ed.storage.getString("dt_lang")
  if (language or "") == "" then
    language = default_language or ""
  end
  return string.lower(language)
end

function ed.saveDefinition(definition)
  EDLog("-->>set definition : " .. definition)
  local defaultDefinition = ""
  if multi_definition then
    defaultDefinition = default_definition
  end
  definition = definition or defaultDefinition
  ed.storage.setValue("dt_definition", definition)
  EDSynchronizeUserDefault()
end

function ed.loadDefinition()
  local definition = ed.storage.getString("dt_definition")
  local defaultDefinition = ""
  if multi_definition then
    defaultDefinition = default_definition
  end
  if (definition or "") == "" then
    definition = defaultDefinition
  end
  return definition
end
