module("ed", package.seeall)
Record = {}
Record.__index = Record
local record_type_map = {
  killMonster = "KillMonster",
  farmStage = "FarmStage",
  farmChapter = "FarmChapter",
  farmpveStage = "FarmPVEStage",
  farmElitepveStage = "FarmElitePVEStage",
  pvpBattle = "PVPBattle",
  pvpWin = "PVPWin",
  skillUpgradeSuccess = "SkillUpgradeSuccess",
  enhanceLevelup = "EnhanceLevelUp",
  midasUse = "MidasUse",
  tavernGroupUse = "TavernGroupUse",
  completeCrusadeStage = "CompleteCrusadeStage",
  sendMercenary = "SendMercenary",
  enterRaid = "EnterRaid",
  equipItem = "EquipItem",
  farmStageWith = "FarmStageWith",
  farmStageNoDie = "FarmStageNoDie",
  farmStageAlone = "FarmStageAlone",
  enterTower = "EnterTower",
  awakeAttributeChange = "AwakeAttributeChange",
  TowerComplete = "TowerComplete",
  AstrolabePray = "AstrolabePray"
}

function Record.create()
  local record = {}
  setmetatable(record, Record)
  record.keys = {
    "killMonster",
    "farmStage",
    "farmChapter",
    "farmpveStage",
    "farmElitepveStage",
    "pvpBattle",
    "pvpWin",
    "skillUpgradeSuccess",
    "enhanceLevelup",
    "midasUse",
    "tavernGroupUse",
    "completeCrusadeStage",
    "sendMercenary",
    "enterRaid",
    "excavateSearch",
    "enterTower",
    "equipItem",
    "farmStageWith",
    "farmStageNoDie",
    "farmStageAlone"
  }
  record.login = {}
  record.today = {}
  return record
end

record = Record.create()

function Record:todayReset()
  if checkTwoDateod() then
    for k in pairs(self.today) do
      self.today[k] = nil
    end
    self.lastResetTime = getServerTime()
  end
end

function Record:refresh(...)
  self:todayReset()
  local l = self.login
  local t = self.today
  local key = select(2, ...)
  if not isElementInTable(key, self.keys) then
    print("invalid key of record:", key)
  end
  local value = select(1, ...)
  local amount = select("#", ...)
  for i = 2, amount - 1 do
    local key = select(i, ...)
    l[key] = l[key] or {}
    t[key] = t[key] or {}
    l = l[key] or {}
    t = t[key] or {}
  end
  local key = select(amount, ...)
  l[key] = (l[key] or 0) + value
  t[key] = (t[key] or 0) + value
end

function Record:increase(...)
  local a = select(1, ...)
  if type(a) == "number" then
    self:refresh(...)
  else
    self:refresh(1, ...)
  end
end

function Record:get(...)
  local r = self.login
  local b = 1
  local k = select(1, ...)
  if isElementInTable(k, {"login", "today"}) then
    if k == "today" then
      self:todayReset()
    end
    r = self[k]
    b = 2
  end
  local amount = select("#", ...)
  for i = b, amount - 1 do
    local key = select(i, ...)
    r = r[key] or {}
  end
  local key = select(amount, ...)
  return r[key] or 0
end

function Record:reset(...)
  local isResetLogin, isResetToday
  local l = self.login
  local t = self.today
  local k = select(1, ...)
  if isElementInTable(k, {"login", "today"}) then
    if k == "today" then
      isResetToday = true
    elseif k == "login" then
      isResetLogin = true
    else
      isResetToday = true
      isResetLogin = true
    end
  end
  local amount = select("#", ...)
  for i = 1, amount - 1 do
    local key = select(i, ...)
    l = l[key] or {}
    t = t[key] or {}
  end
  local key = select(amount, ...)
  if isResetLogin then
    l[key] = 0
  end
  if isResetToday then
    t[key] = 0
  end
end

local function increaseTaskCountRecord(record, name, id, times)
  times = times or 1
  record:increase(times, name, id)
  player:increaseTaskCount({
    type = record_type_map[name] or name,
    id = id,
    add = times
  })
end

function Record:refreshKillMonster(id)
  self.killMonster = self.killMonster or {}
  local battleTable = getDataTable("Battle")
  local battle = battleTable[id]
  for _, v in pairs(battle) do
    for i = 1, 5 do
      local mid = v[string.format("Monster %d ID", i)]
      if 0 < (mid or 0) then
        increaseTaskCountRecord(self, "killMonster", mid, 1)
      end
    end
  end
end

function Record:refreshWearEquip(id)
  local ret = false
  if id then
    self:increase(1, "equipItem")
    ret = ed.player:increaseTaskCount({
      type = "EquipItem",
      id = id,
      add = 1
    })
  end
  return ret
end

function Record:refreshTowerComplete(currentFloorIndex)
  local type = "TowerComplete"
  local target = math.max(currentFloorIndex, ed.player:queryTaskPressWithType(type))
  ed.player:refreshTaskPress(type, target)
end

function Record:successWinBattle(id, times)
  player:increaseTaskCount({
    type = "FarmStageWith",
    id = id,
    add = times
  })
  player:increaseTaskCount({
    type = "FarmStageNoDie",
    id = id,
    add = times
  })
  player:increaseTaskCount({
    type = "FarmStageAlone",
    id = id,
    add = times
  })
  player:increaseTaskCount({
    type = "FarmStageDamage",
    id = id,
    add = times
  })
  player:increaseTaskCount({
    type = "FarmStageKill",
    id = id,
    add = times
  })
end

local stage_record_map = {
  normal = {
    "farmpveStage"
  },
  elite = {
    "farmpveStage",
    "farmElitepveStage"
  },
  pvp = {"pvpWin"},
  top_pvp = {"pvpWin"},
  challenge = {
    "farmpveStage"
  }
}

local function increaseDailyJobCountRecord(record, name, times)
  times = times or 1
  record:increase(times, name)
  player:increaseDailyjobCount({
    type = record_type_map[name] or name,
    add = times
  })
end

function Record:successFarmStage(id, times)
  times = times or 1
  local st = getDataTable("Stage")
  local row = st[id]
  local chapter = row["Chapter ID"]
  self:refreshKillMonster(id)
  increaseTaskCountRecord(self, "farmStage", id, times)
  self:increase(times, "farmChapter", chapter)
  player:increaseDailyjobCount({
    type = "FarmChapter",
    add = times,
    pid = chapter
  })
  local st = stageType(id)
  if stage_record_map[st] ~= nil then
    for _, record_name in ipairs(stage_record_map[st]) do
      increaseDailyJobCountRecord(self, record_name, times)
    end
  end
end

function Record:chaosFarmStage(id, times)
  times = times or 1
  local st = stageType(id)
  if st == "pvp" or st == "top_pvp" or st == "legendArena" then
    increaseDailyJobCountRecord(self, "pvpBattle", times)
  end
end

function Record:enterChapterBattle(id, times)
  times = times or 1
  local st = stageType(id)
  if st == "dreamland" or st == "king" then
    local st = getDataTable("Stage")
    local row = st[id]
    local chapter = row["Chapter ID"]
    player:increaseDailyjobCount({
      type = "EnterChapter",
      add = times,
      pid = chapter
    })
  end
end

local use_item_ID = {
  [1] = 217
}

function Record:useItemCount1(items)
  for _, value in ipairs(items) do
    local amount = ed.bits(value, 16, 16) or 1
    local id = ed.bits(value, 0, 11)
    for _, v in ipairs(use_item_ID) do
      if v == id then
        player:increaseDailyjobCount({
          type = "ItemUse",
          add = amount,
          pid = id
        })
      end
    end
  end
end

function Record:useItemCount(id, times)
  times = times or 1
  for i, v in ipairs(use_item_ID) do
    if v == id then
      player:increaseDailyjobCount({
        type = "ItemUse",
        add = times,
        pid = id
      })
    end
  end
end

function Record:refreshCommonRecord(type, times)
  times = times or 1
  increaseDailyJobCountRecord(self, type, times)
end
