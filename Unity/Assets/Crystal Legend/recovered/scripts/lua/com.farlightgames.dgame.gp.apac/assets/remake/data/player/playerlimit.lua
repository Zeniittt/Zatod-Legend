local playerlimit = newclass()
ed.playerlimit = playerlimit
playerlimit.module_switch = {}

function isModuleOpen(key)
  if playerlimit.module_switch[key] == "close" then
    return false
  end
  if key == "MagicStone" and not ed.MagicStoneManager.isOpen() then
    return false
  end
  return true
end

local function closeModule(key)
  playerlimit.module_switch[key] = "close"
end

playerlimit.closeModule = closeModule
ed.closeModule = closeModule

local function getTable()
  return ed.getDataTable("PlayerLevel")
end

playerlimit.getTable = getTable

local function row(level)
  local plt = getTable()
  level = level or ed.player:getLevel()
  return plt[level]
end

playerlimit.row = row

local function heroLevelLimit()
  return row()["Max Hero Level"]
end

playerlimit.heroLevelLimit = heroLevelLimit

local function maxVitality()
  local oldValue, oldLevel
  local level = ed.player:getLevel()
  if oldLevel ~= level then
    local plt = getTable()
    oldValue = plt[level]["Max Vitality"]
    oldLevel = level
    if ed.player:isMonthCardValid("payed") then
      local add = 0
      local monthTb = ed.getDataTable("MonthCard")
      for k, v in pairs(monthTb) do
        if k == "Payed" then
          add = v["Vitality Max Up"]
        end
      end
      oldValue = math.floor(oldValue + add)
    end
  end
  return oldValue
end

playerlimit.maxVitality = maxVitality

local function maxShadowRunes()
  local t = ed.getDataTable("ExcavateServerData")
  return t[1]["Excavate Vitality Max"]
end

playerlimit.maxShadowRunes = maxShadowRunes

local function maxBreads()
  local t = ed.getDataTable("OfflineQuestConfig")
  return t[1]["Max Bread"]
end

playerlimit.maxBreads = maxBreads
local runeMaxtimes

local function maxBuyShadowRunesTimes()
  if not runeMaxtimes then
    local t = ed.getDataTable("GradientPrice")
    for i, v in ipairs(t) do
      if v["Excavate Vitality"] == nil or v["Excavate Vitality"] == 0 then
        runeMaxtimes = i - 1
        return i
      end
    end
  end
  return runeMaxtimes
end

playerlimit.maxBuyShadowRunesTimes = maxBuyShadowRunesTimes

local function maxChapter(mode)
  local c = row().Chapter
  local chapter = c[#c]
  local level = ed.player:getLevel()
  while (chapter or 0) < 1 do
    level = level - 1
    c = row(level).Chapter
    chapter = c[#c]
  end
  mode = mode or "normal"
  local max_chapter
  if mode == "elite" then
    max_chapter = ed.parameter.max_elite_chapter
  elseif mode == "guild" then
    max_chapter = ed.parameter.max_guild_chapter
  else
    max_chapter = ed.parameter.max_normal_chapter
  end
  return math.min(chapter, max_chapter), ed.parameter.max_stage_chapter
end

playerlimit.maxChapter = maxChapter

local function maxVipLevel()
  local vt = ed.getDataTable("VIP")
  local index = 0
  while vt[index] do
    index = index + 1
  end
  return index - 1
end

playerlimit.maxVipLevel = maxVipLevel

local function chapterUnlockLevel(c)
  local plt = getTable()
  for lv, plinfo in ipairs(plt) do
    if ed.isElementInTable(c, plt[lv].Chapter or {}) then
      return lv
    end
  end
end

playerlimit.chapterUnlockLevel = chapterUnlockLevel

local function chapterJumpLevel(chapter)
  local function getJumpLv(chapter)
    local ul = playerlimit.chapterUnlockLevel(chapter)
    
    if ul then
      return ul
    else
      return getJumpLv(chapter - 1)
    end
  end
  
  return getJumpLv(chapter)
end

playerlimit.chapterJumpLevel = chapterJumpLevel
local pltTable = {}
setmetatable(pltTable, {__mode = "kv"})
pltTable[1] = nil

local function getAreaUnlockLevel(key)
  local plt
  if not pltTable[1] then
    pltTable[1] = getTable()
  end
  plt = pltTable[1]
  local index = 1
  while plt[index] do
    local row = plt[index]
    local unlock = row.Unlock
    for k, v in pairs(unlock) do
      if v == key then
        return index
      end
    end
    index = index + 1
  end
  return 0
end

playerlimit.getAreaUnlockLevel = getAreaUnlockLevel

local function getAreaUnlockStage(key)
  local us = {
    shop = 39,
    ChaosTower = 382,
    ChallengeMode = 303,
    RaceTower = 400,
    CampCrystal = 400,
    MagicStone = 400
  }
  local s = us[key]
  s = s or 0
  return s
end

playerlimit.getAreaUnlockStage = getAreaUnlockStage

local function getPreAreaUnlockStage(key)
  local us = {shop = 18, chaos_tower = 362}
  local s = us[key]
  s = s or 0
  return s
end

playerlimit.getPreAreaUnlockStage = getPreAreaUnlockStage

local function getAreaUnlockvip(key)
  local vt = ed.getDataTable("VIP")
  local index = 0
  while vt[index] do
    if vt[index][key] then
      return index
    end
    index = index + 1
  end
  return index
end

playerlimit.getAreaUnlockvip = getAreaUnlockvip

local function getAreaShowvip(key)
  local vip = getAreaUnlockvip(key)
  vip = math.max(vip - 2, 0)
  return vip
end

playerlimit.getAreaShowvip = getAreaShowvip

local function unlockRequire(key)
  local ur = {
    SkillUpgrade = "playerlevel",
    Elite = "playerlevel",
    PVP = "playerlevel",
    TopPvp = "playerlevel",
    Midas = "playerlevel",
    COT = "playerlevel",
    Enhance = "playerlevel",
    Exercise = "playerlevel",
    sshop = "playerlevel",
    ssshop = "playerlevel",
    Crusade = "playerlevel",
    Guild = "playerlevel",
    Excavate = "playerlevel",
    Awake = "playerlevel",
    Spring = "playerlevel",
    ThroneTower = "playerlevel",
    ActivitySweep = "playerlevel",
    Dreamland = "playerlevel",
    WarBuilding = "playerlevel",
    RealArena = "playerlevel",
    RankFastUpgrade = "playerlevel",
    MileStone = "playerlevel",
    Nightmare = "playerlevel",
    MultiArena = "playerlevel",
    GuildClash = "playerlevel",
    Tradehouse = "playerlevel",
    Titan = "playerlevel",
    shop = "stage",
    ChallengeMode = "elitestage",
    CupArena = "playerlevel",
    Myth = "playerlevel",
    FiveBoss = "playerlevel",
    RaceTower = "playerlevelandstage",
    CampCrystal = "playerlevelandstage",
    ["Skill Upgrade CD Reset"] = "vip",
    ["Item One-Click-Upgrade"] = "vip",
    ["Raid One Function"] = "vip",
    ["Raid Ten Function"] = "vip",
    ["Magic Soul Box"] = "vip",
    ["Multiple Midas"] = "vip",
    ["Fashion Box"] = "vip",
    Tarot = "playerlevel",
    Babel = "playerlevel",
    multistage = "playerlevel",
    StarGate = "playerlevel",
    starshop = "playerlevel",
    ChaosTower = "stage",
    GuildMount = "playerlevel",
    MagicStone = "playerlevelandstage",
    LostLand = "playerlevel",
    SevenDayAssist = "playerlevel",
    FancyAbyss = "playerlevel"
  }
  if not isModuleOpen(key) then
    return 0, {type = "notopen"}
  end
  local state = ur[key] or "playerlevel"
  if state == "playerlevel" then
    return getAreaUnlockLevel(key), {
      type = "playerlevel",
      current = ed.player:getLevel() or 0
    }
  elseif state == "stage" then
    return getAreaUnlockStage(key), {
      type = "stage",
      current = ed.player:getStageProgress() - 1
    }
  elseif state == "vip" then
    return getAreaUnlockvip(key), {
      type = "vip",
      current = ed.player:getvip()
    }
  elseif state == "unlockhero" then
    local heroid = ed.getAwakeHero()
    if heroid == nil then
      return 1, {type = "awake", current = 0}
    else
      return 0, {type = "awake", current = 1}
    end
  elseif state == "elitestage" then
    return getAreaUnlockStage(key), {
      type = "elitestage",
      current = ed.player:getEliteStageProgress()
    }
  elseif state == "playerlevelandstage" then
    local unlockLevel = getAreaUnlockLevel(key)
    local unlockStage = getAreaUnlockStage(key)
    local curLevel = ed.player:getLevel()
    local curStage = ed.player:getStageProgress() - 1
    local limit = unlockLevel * 1000 + unlockStage
    local current = curLevel * 1000 + curStage
    local chapterId = ed.getDataTable("Stage")[unlockStage]["Chapter ID"]
    return limit, {
      type = "playerlevelandstage",
      current = current,
      unlockLevel = unlockLevel,
      unlockStage = unlockStage,
      unlockChapter = chapterId
    }
  end
  return nil
end

playerlimit.unlockRequire = unlockRequire

local function checkAreaUnlock(key)
  local limit, addition = unlockRequire(key)
  addition = addition or {}
  local current = addition.current
  local state = addition.type
  if state == "notopen" then
    return false
  elseif limit > current then
    return false
  else
    return true
  end
end

playerlimit.checkAreaUnlock = checkAreaUnlock

local function getAreaUnlockPrompt(key)
  local limit, addition = unlockRequire(key)
  local state = addition.type
  if checkAreaUnlock(key) then
    return nil
  end
  if state == "notopen" then
    return T("\232\175\165\229\138\159\232\131\189\230\154\130\230\156\170\229\188\128\230\148\190")
  elseif state == "playerlevelandstage" then
    return T("\233\128\154\229\133\179\231\172\172%s\231\171\160\229\144\142\229\188\128\230\148\190", ed.getCNStyleDigits(addition.unlockChapter))
  elseif state == "playerlevel" then
    return T("\230\136\152\233\152\159\231\173\137\231\186\167\232\190\190\229\136\176%d\231\186\167\229\188\128\230\148\190", limit)
  elseif state == "stage" then
    if key == "shop" then
      return T("\233\128\154\229\133\179\231\172\172\228\186\140\231\171\160\229\144\142\229\188\128\230\148\190")
    end
    return T("\233\128\154\232\191\135%d\229\133\179\229\144\142\229\188\128\230\148\190", limit)
  elseif state == "vip" then
    return T("VIP\231\173\137\231\186\167\232\190\190\229\136\176%d\229\188\128\230\148\190", limit), {type = "vip", limit = limit}
  elseif state == "awake" then
    return T("\232\135\179\229\176\145\229\174\140\230\136\144\228\184\128\228\184\170\232\139\177\233\155\132\231\154\132\232\167\137\233\134\146")
  end
end

playerlimit.getAreaUnlockPrompt = getAreaUnlockPrompt
local modulesOpenLevelCache

local function doModulesOpenLevelCache()
  if modulesOpenLevelCache then
    return
  end
  modulesOpenLevelCache = {}
  for _, v in ipairs(getTable()) do
    local modules = v.Unlock
    if modules then
      for i, m in ipairs(modules) do
        if not modulesOpenLevelCache[m] then
          modulesOpenLevelCache[m] = v.Level
        end
      end
    end
  end
  local unlockLevel = ed.getDataTable("DungeonConfig").OpenLevel.Value[1]
  modulesOpenLevelCache.AwakeDungeon = unlockLevel
end

function playerlimit:getModuleUnlockLevel(module)
  doModulesOpenLevelCache()
  return modulesOpenLevelCache[module] or 1
end

function playerlimit:getLevelUpOpenedModules(lv, newlv)
  local modules = {}
  for i = lv + 1, newlv do
    local tb = row(i)
    if tb.Unlock then
      for j, m in ipairs(tb.Unlock) do
        table.insert(modules, {
          m,
          tb["Unlock Name"][j] or m
        })
      end
    end
  end
  return modules
end

function playerlimit:moduleIsOpened(module)
  return ed.player:getLevel() >= playerlimit:getModuleUnlockLevel(module)
end
