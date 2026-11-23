require("edebug")
require("tools")
require("stringbuffer")
require("debug.serialize")
require("debug.dump")
require("util/localstorage")

function ccc3()
end

require("../btcheck-config")
os.execute("mkdir -p bclog")
local insert = table.insert
local ipairs = ipairs
local TASK_ID = _G.ID or 0
local ed = ed
ed.run_with_scene = false
CCNode = {}
CCSprite = {}
CCLabelTTF = {}

function ccp(x, y)
  return {x = x, y = y}
end

ed.HpBar = {}
local curJob, protobuf_mt
protobuf_mt = {
  __index = function(t, key)
    local direct_value = rawget(t, key)
    if direct_value ~= nil then
      return direct_value
    end
    local data_field = rawget(t, ".data")
    if data_field and type(data_field) == "table" then
      local value = rawget(data_field, key)
      if value ~= nil then
        if type(value) == "table" and getmetatable(value) == nil then
          setmetatable(value, protobuf_mt)
        end
        return value
      end
    end
    return nil
  end
}

local function dumpErrorMsg(from, result)
  from = from or "dump"
  result = result or ""
  if "cheat" ~= from then
    local fmt = string.format
    local suffix = curJob and fmt("%s%i", curJob.type, curJob.msg._checkid) or os.date("%Y-%m-%d %H-%M-%S")
    eddebug.dump("bclog", suffix .. "_task" .. TASK_ID)
  end
  if curJob then
    local msg = curJob.msg
    local file = io.open(string.format("bclog/%s_%s_%s%i_task%i.bclog", from, result, curJob.type, msg._checkid, TASK_ID), "w")
    if file then
      file:write(getBtlog())
      file:close()
    end
    file = io.open(string.format("bclog/%s_%s_%s%i_task%imsg.lua", from, result, curJob.type, msg._checkid, TASK_ID), "w")
    if file then
      ed.exportLuaModule(file, msg, ".data")
    end
  end
end

local function logMsg(msg, logfile)
  logfile = logfile or "info_task" .. TASK_ID .. ".log"
  local file = io.open(logfile, "a")
  if file then
    file:write(os.date(), " ", msg, "\n")
    file:close()
  end
end

local battle_type = {}
local result_map = {
  [1] = "honest",
  [2] = "cheat",
  [3] = "victory",
  [4] = "defeat",
  [5] = "timeout"
}
local winRound = {
  [1] = 1,
  [3] = 2,
  [5] = 3,
  [7] = 4,
  [9] = 5
}
local defaultBattleCsvTable = {
  "AnimDuration",
  "AnimAtkFrame",
  "AnimDurationSp",
  "AnimAtkFrameSp",
  "Battle",
  "Buff",
  "equip",
  "hero_equip",
  "Skill",
  "SkillGroup",
  "Stage",
  "Unit",
  "UnitRank",
  "Puppet",
  "TitanEquipLevel",
  "TarotCard",
  "TarotAbilitySP",
  "TarotAbility"
}
xpcall(function()
  require("resource_manager")
  require("datatable")
  require("gamedatatables/gamedatatables")
  require("gamedatatables/battlemetatable")
  require("gamedatatables/herotasktable")
  require("gamedatatables/skillgrouptable")
  require("gamedatatables/challengetable")
  require("gamedatatables/unittable")
  require("gamedatatables/chessunittable")
  require("gamedatatables/dotunittable")
  require("battle/edp")
  require("battle/battle_engine")
  require("battle/AutoChessBattleEngine")
  require("battle/SoloBattleEngine")
  require("pb")
  require("battle/battle_check")
  require("helloserver/job_handler")
  require("helloserver/log_handler")
  require("helloserver/queue")
  require("pet/pet")
  for i = 1, #defaultBattleCsvTable do
    local csvFile = defaultBattleCsvTable[i]
    local csvTable = ed.getDataTable(csvFile)
  end
  
  local function combineSomeTables()
    local tb1 = ed.getDataTable("AnimDuration") or {}
    local tb2 = ed.getDataTable("AnimDurationSp") or {}
    for k, v in pairs(tb2) do
      tb1[k] = {}
      for k1, v1 in pairs(v) do
        tb1[k][k1] = v1
      end
    end
  end
  
  combineSomeTables()
  local isBclogOnly = false
  collectgarbage("collect")
  collectgarbage("setpause", 100)
  collectgarbage("setstepmul", 5000)
end, function(msg)
  if enable_debug then
    EDDebug(msg)
  else
    dumpErrorMsg("dump")
  end
end)
local playerIdx

function task_job_begin(job, player_idx)
  local success = false
  xpcall(function()
    playerIdx = player_idx
    curJob = job
    setmetatable(curJob, protobuf_mt)
    success = true
  end, function(msg)
    logMsg(tostring(msg))
    dumpErrorMsg("dump")
  end)
  return success
end

function task_job_run(last_tick_boss_damages)
  local success = false
  local battle_finish = false
  local boss_damage = 0
  xpcall(function()
    if ed.engine.running then
      ed.engine:damageToBossFOP(last_tick_boss_damages, playerIdx)
      ed.engine:tick()
    else
      battle_finish = true
    end
    success = true
  end, function(msg)
    logMsg(tostring(msg))
    dumpErrorMsg("dump")
  end)
  return success, battle_finish, boss_damage
end

function task_job_end()
  local success = false
  local battleResult = {}
  xpcall(function()
    playerIdx = nil
    curJob = nil
    success = true
  end, function(msg)
    logMsg(tostring(msg))
    dumpErrorMsg("dump")
  end)
  return success, battleResult
end
