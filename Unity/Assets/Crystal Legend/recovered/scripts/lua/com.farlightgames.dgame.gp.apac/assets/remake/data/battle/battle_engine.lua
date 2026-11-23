require("battle.init")
local table = table
local ipairs = ipairs
local pairs = pairs
local math = math
local string = string
local ed = ed
local unit_list_names = {
  "unit_list",
  "projectile_list",
  "npc_list",
  "FieldNpc_list"
}
local m2s = {
  arena_mode = "pvp",
  crusade_mode = "tbc",
  wca_mode = "wca",
  guildInstance_mode = "guildist",
  custom_mode = "pvp",
  peakArena_mode = "peakArena",
  cupArena_mode = "cupArena",
  guildClash_mode = "guildClash",
  crevicedefend_mode = "crevicedefend"
}
ed.tick_interval = 0.125
local print_battle_log = false
local initial_position = {
  {0, 0},
  {-80, -40},
  {-160, 0},
  {-240, -40},
  {-320, 0},
  {-400, -40},
  {-40, 40},
  {-120, 40},
  {-200, 40},
  {-280, 40},
  {-360, 40},
  {-420, 40},
  {-440, 0},
  {-460, -40},
  {-480, 40},
  {-500, 0}
}
local position_config_1 = {
  {200, 0},
  {280, -40},
  {360, 0},
  {440, -40},
  {520, 0},
  {600, -40},
  {160, 40},
  {240, 40},
  {320, 40},
  {400, 40}
}
local scrolls_wave_position = {
  {300, 0},
  {240, -40},
  {160, 0},
  {100, -40},
  {40, 0}
}
ed.scrolls_wave_position = scrolls_wave_position
local Engine = newclass("g")
ed.EngineClass = Engine
local Instance = {}
setmetatable(Instance, Engine.mt)
ed.commonEngine = Instance
ed.engine = Instance
Engine.push_interval_tick = 4

function Engine.mt:__tostring()
  local logtb = {
    "---------------------------------------\n",
    string.format("tick %d\n", self.ticks or 0)
  }
  local idx = 1
  if self.unit_list then
    for i = 1, #self.unit_list do
      local unit = self.unit_list[i]
      if unit:isAlive() then
        logtb[2 + idx] = tostring(self.unit_list[i])
        idx = idx + 1
      end
    end
  end
  return table.concat(logtb)
end

function ed.setBattleEngine(engine)
  ed.battleEngine = engine
end

function ed.getBattleEngine()
  return ed.battleEngine or ed.commonEngine
end

require("battle/battle_engine_extra")

function Engine.btResult2String()
  local result = ed.engine.battleResult
  local list = {
    "victory",
    "defeat",
    "canceled",
    "timeout",
    "cheat",
    "honest"
  }
  return list[result + 1]
end

function Engine:ctMode2String()
  for k, v in pairs(m2s) do
    if self[k] then
      return v
    end
  end
  return "stage"
end

function Engine:resetStage()
  if ed.player then
    ed.player.loots = {}
    ed.player.hpLoots = {}
  end
  self.extra_ratio_DPS = 1
  self.extra_ratio_IMU = 1
  self.playerKaelHero = nil
  self.enemyKaelHero = nil
  self.enabled = true
  self.stage_ended = false
  self.stage_info = nil
  self.arena_mode = nil
  self.share_fight = nil
  self.crusade_mode = nil
  self.ancients_mode = nil
  self.throne_tower_mode = nil
  self.guildClash_mode = nil
  self.replayMode = nil
  self.guildInstance_mode = nil
  self.wca_mode = nil
  self.toppvp_mode = nil
  self.gmMode = nil
  self.multiarena_mode = nil
  self.battle_manager = nil
  self.gvg_mode = nil
  self.manualbt_mode = nil
  self.multi_mode = nil
  self.gcw_mode = nil
  self.stage_type = nil
  self.quest_mode = nil
  self.energyBeanNumber = 0
  self.useEnergyBeanNumber = 0
  self.energyBean_mode = false
  self.timeLimitMode = nil
  self.battle_check_arena_mode = nil
  self.battle_check_stage_mode = nil
  self.siegeMode = nil
  self.unitScale = 1
  self.siegeBattleState = nil
  self.superAwakeHero = nil
  self.superAwakeHeroID = nil
  self.nightmareMode = nil
  self.assassinateMode = nil
  self.babelMode = nil
  self.multiplayerMode = nil
  self.nianMode = nil
  self.manualMode = nil
  self.legendArena_mode = nil
  self.starGate_mode = nil
  self.multistage_mode = nil
  self.multistageTeamwork_mode = nil
  self.autoChessMode = nil
  self.arcanaTrialMode = nil
  self.cupArena_mode = nil
  self.myth_mode = nil
  self.mythBossMode = nil
  self.campBossMode = nil
  self.campTowerMode = nil
  self.guildMountBossMode = nil
  self.seasonArena_mode = nil
  self.seasonTowerMode = nil
  self.fancyTowerMode = nil
  self.crevicedefend_mode = nil
  self.peakArena_mode = nil
  self.fancyAbyssMode = nil
  self.activityAdventureMode = nil
  self.hadesMode = nil
  self.hadesGroupId = nil
  self.activeHeat = {}
  self.echoSkillMgr = nil
  self.rogue_mode = nil
  self.rogueSkillMgr = nil
  self.rogueChapterBattleInfo = nil
  self.awakeStageMode = nil
  self.awakeStageBuff = nil
  self.die_units = {}
  self.bot_mode = nil
  self.videoplayer_mode = nil
  self.enemyLenght = 0
  self.stageManager = nil
  self.custom_mode = nil
  self.stage_rect = {
    minX = 0,
    maxX = 800,
    minY = -120,
    maxY = 120
  }
  self.ticks = 0
  ed.tick_interval = 0.125
  self.tick_interval = ed.tick_interval
  self.operation_list = {}
  self.next_operation_index = 1
  self.unit_list = {}
  self:resetBattle()
  self.hero_id_list = {}
  self.battleConditionList = {}
  self.loot_count = 0
  self.gold_count = 0
  self.death_count = 0
  self.speed_rate = 1
  self.enableHPSAndMPS = true
  self.pvpActivityId = 0
  self.crusadeActivityId = 0
  self.peakAreanSkillId = 0
  self.star1 = false
  self.star2 = false
  self.star3 = false
  self.push_interval_tick = 4
  self.heroTaskHid = -1
  do_battle_log = not do_battle_log and not ed.debug_mode and not ed.open_debug and ed.run_with_scene and ed.storage.getBool("FORCE_BATTLE_REPORT_FLAG")
  if ed.run_with_scene and not do_battle_log then
    math.randomseed(os.time())
    do_battle_log = math.random(100) <= 10
  end
  self.battleLog = nil
  self.rect_cut = EngineRectCut
  self.rect_cut.reset()
  self.origin_enemy_team = nil
  self.deliveredBallSlots = {}
  self.usedDeliveredBallSlots = {}
  self.battleDataCollect = nil
  self:setUnitFilter()
  battle_tick.init(true)
  battle_tick.initMp()
end

function Engine:disableHPSAndMPS()
  self.enableHPSAndMPS = false
end

function Engine.genHeroBackground(scenename, time, isBoss)
  if scenename ~= nil and time ~= nil then
    return {
      [1] = scenename,
      [2] = time,
      [3] = isBoss
    }
  else
    return {
      [1] = "dummy",
      [2] = 9999,
      [3] = nil
    }
  end
end

function Engine:resetBattle()
  self.manualMode = ed.ManualMode.Manager:Create()
  self.next_tick = 0
  if self.guildInstance_mode == true or self.arcanaTrialMode == true then
    self.time_limit = self.time_limit or 90
  elseif self.hadesMode then
    self.time_limit = 90 + self:getChooseHeatAddTime()
  elseif self.awakeStageMode then
    if 0 < self.stage_info["Battle Time"] then
      self.time_limit = self.stage_info["Battle Time"]
    else
      self.time_limit = 90
    end
  elseif self.crevicedefend_mode then
    local battleTime = self.custom_data_battle["Battle Time"]
    if battleTime and type(battleTime) == "number" and battleTime ~= 0 then
      self.time_limit = battleTime
    else
      self.time_limit = 90
    end
  else
    self.time_limit = 90
  end
  self.projectile_list = {}
  self.npc_list = {}
  self.FieldNpc_list = {}
  self.alive_alliance_count = 0
  self.alive_enemy_count = 0
  self.dead_alliance_count = 0
  self.dead_enemy_count = 0
  self.hero_background = Engine.genHeroBackground()
  self.freeze_level = 0
  self.freeze_camp = nil
  self.supplied = false
  self.running = true
  self.beingEnd = false
  self.firstEnemyDie = false
  self.dayandnightMode = false
  self.dayandnightStructure = {}
  self.dayandnightState = {}
  self.energyIncrement = 0
  local old = self.unit_list
  self.unit_list = {}
  self.alive_units = {
    [ed.emCampPlayer] = {},
    [ed.emCampEnemy] = {},
    [ed.emCampBoth] = {},
    [ed.emCampNeither] = {}
  }
  if old then
    for _, unit in ipairs(old) do
      if unit.camp == ed.emCampPlayer then
        self:addUnit(unit)
      end
    end
  end
end

local function setUpConfigEstimateInfo(config, tid, is_bot)
  if ed.enableMaxAttStrategy then
    local uinfo = ed.getDataTable("Unit")[tid]
    if uinfo["Unit Type"] == "Monster" then
      config.estimate_rank = is_bot
      config.estimate_skill = is_bot
      config.estimate_max_rank = false
    else
      config.estimate_rank = false
      config.estimate_skill = false
      config.estimate_max_rank = true
    end
  else
    config.estimate_rank = is_bot
    config.estimate_skill = is_bot
    config.estimate_max_rank = false
  end
end

function Engine:resetUnitList()
  for i, unit in ipairs(self.unit_list) do
    unit:reset()
  end
end

function Engine:resetFieldNpcList()
  for __, fieldNpc in ipairs(self.FieldNpc_list) do
    fieldNpc:reset()
  end
end

local function getMonsterPosition(index, position_config)
  position_config = position_config or initial_position
  local position = position_config[index] or {100, 0}
  position = {
    ed.engine.stage_rect.maxX - position[1],
    position[2]
  }
  return position
end

Engine.getMonsterPosition = getMonsterPosition

function Engine.getPlayerInitialPosition()
  return initial_position
end

function Engine:addEnergy(num)
  self.energyBeanNumber = self.energyBeanNumber + num
end

local selectors = {
  maxad = function(unit)
    return unit.fixed_attribs.AD
  end,
  maxap = function(unit)
    return unit.fixed_attribs.AP
  end,
  maxstr = function(unit)
    return unit.fixed_attribs.STR
  end,
  maxagi = function(unit)
    return unit.fixed_attribs.AGI
  end,
  maxint = function(unit)
    return unit.fixed_attribs.INT
  end,
  maxhp = function(unit)
    return unit.hp
  end,
  maxarm = function(unit)
    return unit.fixed_attribs.ARM
  end,
  maxmr = function(unit)
    return unit.fixed_attribs.MR
  end,
  minad = function(unit)
    return -unit.fixed_attribs.AD
  end,
  minap = function(unit)
    return -unit.fixed_attribs.AP
  end,
  minstr = function(unit)
    return -unit.fixed_attribs.STR
  end,
  minagi = function(unit)
    return -unit.fixed_attribs.AGI
  end,
  minint = function(unit)
    return -unit.fixed_attribs.INT
  end,
  minhp = function(unit)
    return -unit.hp
  end,
  minarm = function(unit)
    return -unit.fixed_attribs.ARM
  end,
  minmr = function(unit)
    return -unit.fixed_attribs.MR
  end
}

function Engine.getFixedAttribSelector(type)
  type = string.lower(type)
  return selectors[type]
end

function Engine.selectUnit(unitArray, selector)
  local max = -math.huge
  local index
  for i = 1, #unitArray do
    local unit = unitArray[i]
    local v = selector(unit)
    if v and max < v then
      max = v
      index = i
    end
  end
  if index then
    return unitArray[index], index
  end
end

function Engine.getTargetUnitArray(unitArray, targetType)
  local selector = Engine.getFixedAttribSelector(targetType)
  if not selector then
    return unitArray
  end
  local targetUnit = Engine.selectUnit(unitArray, selector)
  return {targetUnit}
end

function Engine:setupBattle(battle, hp_info, param)
  self:resetBattle()
  self.wave_id = battle["Wave ID"] or 1
  self.stage_type = battle["Stage Type"]
  if self.stage_type == "dreamland" and self.stage_info["Add Energy"] then
    self.energyBean_mode = true
    self.energyBeanNumber = 0
  end
  self.extra_ratio_DPS = battle["Camp extra ratio UDPS"] or 1
  self.extra_ratio_IMU = battle["Camp extra ratio UIMU"] or 1
  self:createMonster(battle, hp_info)
  for i, hero in ipairs(self.alive_units[ed.emCampPlayer]) do
    hero.position = {
      initial_position[i][1],
      initial_position[i][2]
    }
  end
  self:resetUnitList()
  local script = ed.getStageScript(self.stage_info["Stage ID"], self.wave_id)
  if script then
    script(self)
  end
  self:addEnterBattleBuff()
  self:addChooseHeatBuff()
  self:addAwakeDungeonBuff()
  self:addRogueChapterBuff()
  self:initBattleTime()
  self:setupRogueManager()
  if ed.run_with_scene and self:canEnterBattleStage() then
    ListenTimer(Timer:Once(2), function()
      if self.awakeStageMode or self.rogue_mode then
        return
      end
      FireEvent("EnterBattleStage", self.stage_info["Stage ID"], self.wave_id)
    end)
  end
end

function Engine:setupScrollBattle(battle)
  self.projectile_list = {}
  self.running = true
  self.wave_id = battle["Wave ID"] or 1
  self.stage_type = battle["Stage Type"]
  local monsterList = self:createMonster(battle, nil, initial_position)
  for index, monster in ipairs(monsterList) do
    monster:reset()
  end
  for i, hero in ipairs(self.alive_units[ed.emCampPlayer]) do
    if hero:isAlive() and hero.actor then
      hero.position = {
        scrolls_wave_position[i][1],
        scrolls_wave_position[i][2]
      }
      local bid = 99000004
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, hero, hero)
      hero:addBuff(buff, hero)
    end
  end
end

function Engine:createMonster(battle_info, hp_info, position_config)
  local function modify(old, modifier, default)
    default = default or 100
    
    modifier = modifier or default
    if modifier == 0 then
      modifier = default
    end
    return old * modifier / 100
  end
  
  self.monsterNum = 0
  local boss_idx = battle_info["Boss Position"]
  local monsterPosIndex = 0
  local battleBonus
  if battle_info["Camp Level"] and 0 < battle_info["Camp Level"] then
    battleBonus = {
      _camps = {}
    }
    for i = 1, 5 do
      table.insert(battleBonus._camps, {
        _id = i,
        _level = battle_info["Camp Level"]
      })
    end
  end
  local unitArray = {}
  for i = 1, 20 do
    local id = battle_info["Monster " .. i .. " ID"]
    if id and 0 < id then
      self.monsterNum = self.monsterNum + 1
      if not hp_info or hp_info[i]._hp_perc ~= 0 then
        local monster = self:createOneMonster(i, id, battle_info, hp_info, battleBonus)
        if monster.hp and monster.hp ~= 0 then
          monsterPosIndex = monsterPosIndex + 1
        end
        monster.position = getMonsterPosition(monsterPosIndex, position_config)
        self:addUnit(monster)
        table.insert(unitArray, monster)
      end
    end
  end
  return unitArray
end

function Engine:createOneMonster(i, id, battle_info, hp_info, battleBonus)
  local function modify(old, modifier, default)
    default = default or 100
    
    modifier = modifier or default
    if modifier == 0 then
      modifier = default
    end
    return old * modifier / 100
  end
  
  local boss_idx = battle_info["Boss Position"]
  local level
  if self.hadesMode or self.activityAdventureMode then
    local maxLevel = battle_info["MaxLevel " .. i]
    local minLevel = battle_info["MinLevel " .. i]
    local difficultyRatio = self.difficultyRatio or 0
    level = math.floor(difficultyRatio * (maxLevel - minLevel) + minLevel)
  elseif self.rogue_mode then
    level = self.rogueLevelBonusCfg.Level + self.rogueWaveBonusCfg.Level
  else
    level = battle_info["Level " .. i]
  end
  if self.crevicedefend_mode then
    if i == battle_info["Boss Position"] then
      level = battle_info.MonsterLevel
    else
      level = battle_info.BossLevel
    end
  end
  level = level and level + self:getChooseHeatMonsterLevel()
  if not level then
    EDDebug("Monster level missing")
  end
  local rank = battle_info["Rank " .. i]
  local stars
  if self.rogue_mode then
    stars = self.rogueLevelBonusCfg.Stars
  else
    stars = battle_info["Stars " .. i] or 1
  end
  local config = {
    is_monster = true,
    is_boss = false,
    hp_mod = modify(1, battle_info["Monster HP%"]),
    dps_mod = modify(1, battle_info["Monster DPS%"]),
    arm_mod = modify(1, battle_info["Monster ARM%"]),
    mr_mod = modify(1, battle_info["Monster MR%"]),
    size_mod = 1,
    money = battle_info["Money Reward " .. i],
    estimate_rank = true,
    estimate_skill = true,
    estimate_max_rank = false
  }
  if i == boss_idx then
    config.is_boss = true
    config.hp_mod = modify(config.hp_mod, battle_info["Boss HP%"])
    config.dps_mod = modify(config.dps_mod, battle_info["Boss DPS%"])
    config.size_mod = modify(config.size_mod, battle_info["BOSS SIZE%"], 120)
    config.arm_mod = modify(config.arm_mod, battle_info["Boss ARM%"])
    config.mr_mod = modify(config.mr_mod, battle_info["Boss MR%"])
  end
  if self.rogue_mode then
    local rogueMonsterCoeCfg = ed.getDataTable("RogueMonsterCoe")[id] or {}
    config.hp_mod = (modify(1, self.rogueLevelBonusCfg["HP%"], 0) + modify(1, battle_info["Basic HP%"])) * modify(1, self.rogueWaveBonusCfg["HP%"]) * modify(1, rogueMonsterCoeCfg["HP%"])
    config.dps_mod = (modify(1, self.rogueLevelBonusCfg["DPS%"], 0) + modify(1, battle_info["Basic DPS%"])) * modify(1, self.rogueWaveBonusCfg["DPS%"]) * modify(1, rogueMonsterCoeCfg["DPS%"])
    config.size_mod = modify(1, battle_info[string.format("Monster %s Size", i)], 100)
  end
  local slevel = level
  local arousalInfo
  if battle_info["Awake" .. i] then
    arousalInfo = {_status = 1}
  end
  local shard
  local shardId = battle_info["Shard ID " .. i]
  local shardLevel = battle_info["Shard Level " .. i]
  if shardId and 0 < shardId then
    local shardToHeroCfg = ed.getDataTable("ShardToHero")[shardId]
    if shardToHeroCfg and shardToHeroCfg["Hero ID"] == id then
      shard = {_id = shardId, _level = shardLevel}
    end
  end
  local hero_rune
  local proto = {
    _tid = id,
    _level = level,
    _stars = stars,
    _arousal = arousalInfo,
    _hero_rune = hero_rune,
    _rank = rank,
    _shard = shard
  }
  local specialBonus = {}
  if self.rogue_mode then
    specialBonus.rogueWaveBonus = self.rogueWaveBonusCfg
  end
  local monster = ed.UnitCreate(proto, ed.emCampEnemy, config, hp_info and hp_info[i] or nil, nil, nil, battleBonus, specialBonus)
  local mp = battle_info["MP " .. i]
  monster.mp = mp or 0
  monster.monster_idx = i
  return monster
end

function Engine:getChooseHeat()
  local allChooseHeat = {}
  local totalHeat = 0
  for _, heatData in ipairs(self.activeHeat or {}) do
    if 0 < heatData._times then
      table.insert(allChooseHeat, {
        _heat_id = heatData._heat_id,
        _times = heatData._times
      })
      totalHeat = totalHeat + ed.getDataTable("Heat")[heatData._heat_id].HeatValue1 * heatData._times
    end
  end
  local passiveHeat = self:getPassiveHeat()
  for _, heatData in ipairs(passiveHeat) do
    table.insert(allChooseHeat, {
      _heat_id = heatData._heat_id,
      _times = heatData._times
    })
    totalHeat = totalHeat + ed.getDataTable("Heat")[heatData._heat_id].HeatValue1 * heatData._times
  end
  return allChooseHeat, totalHeat
end

function Engine:getPassiveHeat()
  local heatGroupCfg = ed.getDataTable("HeatGroup")[self.hadesGroupId]
  if not heatGroupCfg then
    return {}
  end
  local passiveHeat = heatGroupCfg["Heat Passive"]
  local passiveHeatList = {}
  for _, heatId in ipairs(passiveHeat or {}) do
    local heatCfg = ed.getDataTable("Heat")[heatId]
    if heatCfg and heatCfg.Type == "Survivor" then
      local allSurvivor = true
      for i, unit in ipairs(self.unit_list) do
        if unit.camp == ed.emCampPlayer and unit:isHero() and unit.config.is_summoned ~= true and not unit:isAlive() then
          allSurvivor = false
          break
        end
      end
      if allSurvivor then
        table.insert(passiveHeatList, {
          _heat_id = heatId,
          _times = heatCfg.MaxLevel
        })
      end
    elseif heatCfg and heatCfg.Type == "CurrentHero" then
      local targetHeroId = heatCfg.ScriptArg1
      local maxLevel = heatCfg.MaxLevel
      for i, unit in ipairs(self.unit_list) do
        if unit.camp == ed.emCampPlayer and unit.tid == targetHeroId then
          table.insert(passiveHeatList, {_heat_id = heatId, _times = maxLevel})
          break
        end
      end
    end
  end
  return passiveHeatList
end

function Engine:getChooseHeatMonsterLevel()
  local addLevel = 0
  for _, heatData in ipairs(self.activeHeat or {}) do
    local heatId = heatData._heat_id
    local times = heatData._times
    local heatCfg = ed.getDataTable("Heat")[heatId]
    if heatCfg and heatCfg.Type == "Level" then
      addLevel = addLevel + heatCfg.ScriptArg1 * times
    end
  end
  return addLevel
end

function Engine:getChooseHeatAddTime()
  local addTime = 0
  for _, heatData in ipairs(self.activeHeat or {}) do
    local heatId = heatData._heat_id
    local times = heatData._times
    local heatCfg = ed.getDataTable("Heat")[heatId]
    if heatCfg and heatCfg.Type == "Time" then
      addTime = addTime - heatCfg.ScriptArg1 * times
    end
  end
  return addTime
end

function Engine:getEchoSkillMgr()
  return self.echoSkillMgr
end

function Engine:getRogueSkillMgr()
  return self.rogueSkillMgr
end

function Engine:getBattleCsvName()
  if self.seasonTowerMode then
    return "SeasonTowerBattle"
  elseif self.fancyTowerMode then
    return "FancyTowerBattle"
  elseif self.fancyAbyssMode then
    return "FancyAbyssBattle"
  elseif self.activityAdventureMode then
    return "ActivityAdventureBattle"
  elseif self.awakeStageMode then
    return "DungeonBattle"
  elseif self.hadesMode then
    return "HeatBattle"
  elseif self.rogue_mode then
    return "RogueBattle"
  end
  return "Battle"
end

function Engine:initStageManager(stageSkill)
  local stageid = self.stage_info["Stage ID"]
  local battleInfo = ed.lookupDataTable(self:getBattleCsvName(), nil, stageid, self.wave_id)
  if stageSkill then
    battleInfo["Stage Skill ID"] = stageSkill
  end
  self.stageManager = ed.battle.stageManager.create(battleInfo)
  self.stageManager:manage(self)
  self:resetFieldNpcList()
end

function Engine:initBattleDataCollect()
  self.battleDataCollect = ed.battleDataCollect.create()
end

function Engine:initSpecialCondition(conditionIdList)
  self.battleConditionList = {}
  for index, conditionId in ipairs(conditionIdList or {}) do
    local specialConditionCfg = ed.getDataTable("BattleSpecialCondition")[conditionId]
    local type = specialConditionCfg["Condition Type"]
    local conditionClass = require("battle/battleResultCondition/" .. type)
    local condition = conditionClass.create(specialConditionCfg)
    condition.info = specialConditionCfg
    self.battleConditionList[conditionId] = condition
  end
end

function Engine:canEnterBattleStage()
  if self.multiplayerMode or self.multistageTeamwork_mode then
    return false
  end
  return true
end

function Engine:checkDefaultBuffCondition(unit, type, detail)
  if type == "Gender" then
    return unit.info.Gender == detail
  elseif type == "Boss" and unit.config.is_boss then
    return true
  elseif type == "Camp" then
    return tostring(unit.camp) == detail
  end
  return false
end

function Engine:addEnterBattleBuff()
  local stage = self.stage_info
  local type1 = stage["Buff 1 Requirement Type"]
  local detail1 = stage["Buff 1 Requirement Detail"]
  local bid1 = stage["Buff 1 ID"]
  if bid1 then
    self.enterBattleBuff1_Id = bid1
    local info1 = ed.getDataTable("Buff")[bid1]
    for i, unit in ipairs(self.unit_list) do
      if self:checkDefaultBuffCondition(unit, type1, detail1) then
        unit:addBuff(info1, unit)
      end
    end
  end
  local type2 = stage["Buff 2 Requirement Type"]
  local detail2 = stage["Buff 2 Requirement Detail"]
  local bid2 = stage["Buff 2 ID"]
  if bid2 then
    self.enterBattleBuff2_Id = bid2
    local info2 = ed.getDataTable("Buff")[bid2]
    for i, unit in ipairs(self.unit_list) do
      if self:checkDefaultBuffCondition(unit, type2, detail2) then
        unit:addBuff(info2, unit)
      end
    end
  end
end

function Engine:addChooseHeatBuff()
  for _, heatData in ipairs(self.activeHeat or {}) do
    local heatId = heatData._heat_id
    local times = heatData._times
    local headCfg = ed.getDataTable("Heat")[heatId]
    if headCfg and headCfg.Type == "Buff" and 0 < times then
      local heatBuffCfg = ed.getDataTable("HeatBuffLevel")[heatId][times]
      local buffId = heatBuffCfg.BuffID
      local buffTarget = heatBuffCfg.Target
      local buffCaster = heatBuffCfg.Caster
      local buffInfo = ed.getDataTable("Buff")[buffId]
      local casterUnit
      if buffCaster == "BOSS" then
        for i, unit in ipairs(self.unit_list) do
          if unit.camp == ed.emCampEnemy and unit.config.is_boss then
            casterUnit = unit
            break
          end
        end
      end
      for i, unit in ipairs(self.unit_list) do
        casterUnit = casterUnit or unit
        if unit.camp == ed.emCampEnemy and unit.config.is_boss and buffTarget == "BOSS" then
          local buff = ed.BuffCreate(buffInfo, unit, casterUnit)
          unit:addBuff(buff, unit)
        elseif unit.camp == ed.emCampPlayer and buffTarget == "SELF" then
          local buff = ed.BuffCreate(buffInfo, unit, casterUnit)
          unit:addBuff(buff, unit)
        elseif unit.camp == ed.emCampEnemy and buffTarget == "ENEMY" then
          local buff = ed.BuffCreate(buffInfo, unit, casterUnit)
          unit:addBuff(buff, unit)
        end
      end
    end
  end
end

function Engine:addAwakeDungeonBuff(unitList)
  if not self.awakeStageMode or not self.awakeStageBuff then
    return
  end
  local buffId = self.awakeStageBuff.buffId
  if buffId == 0 then
    return
  end
  local targetCamp = self.awakeStageBuff.targetCamp
  if unitList then
    for index, unit in ipairs(unitList) do
      local buffInfo = ed.getDataTable("Buff")[buffId]
      local buff = ed.BuffCreate(buffInfo, unit, unit)
      unit:addBuff(buff, unit)
    end
  else
    for unit in self:foreachAliveUnit(targetCamp) do
      local buffInfo = ed.getDataTable("Buff")[buffId]
      local buff = ed.BuffCreate(buffInfo, unit, unit)
      unit:addBuff(buff, unit)
    end
  end
end

function Engine:addRogueChapterBuff()
  if not self.rogue_mode or not self.rogueChapterBattleInfo then
    return
  end
  local chapterId = self.rogueChapterBattleInfo.chapterId
  local chapterDiff = self.rogueChapterBattleInfo.chapterDiff
  local crisisDiff = self.rogueChapterBattleInfo.crisisDiff or 0
  local rogueChapterCfg = ed.getDataTable("RogueChapter")[chapterId][chapterDiff]
  for index, chapterBuffId in ipairs(rogueChapterCfg["Chapter Buff"] or {}) do
    local targetCamp = rogueChapterCfg["Buff Target"][index]
    if not targetCamp then
      break
    end
    for unit in self:foreachAliveUnit(targetCamp) do
      local exist = false
      for _, curBuff in ipairs(unit.buff_list or {}) do
        if curBuff.info.ID == chapterBuffId then
          exist = true
          break
        end
      end
      if not exist then
        local buffInfo = ed.getDataTable("Buff")[chapterBuffId]
        local buff = ed.BuffCreate(buffInfo, unit, unit)
        unit:addBuff(buff, unit)
      end
    end
  end
  local crisisGroupId = rogueChapterCfg["Crisis Group"] or 0
  if 0 < crisisGroupId and 0 < crisisDiff then
    local crisisCfg = ed.getDataTable("RogueCrisis")[crisisGroupId][crisisDiff]
    for index = 1, 20 do
      local crisisBuffId = crisisCfg[string.format("Buff %d ID", index)]
      if not crisisBuffId or crisisBuffId == 0 then
        break
      end
      local targetCamp = crisisCfg[string.format("Target %d Camp", index)]
      for unit in self:foreachAliveUnit(targetCamp) do
        local exist = false
        for _, curBuff in ipairs(unit.buff_list or {}) do
          if curBuff.info.ID == crisisBuffId then
            exist = true
            break
          end
        end
        if not exist then
          local buffInfo = ed.getDataTable("Buff")[crisisBuffId]
          local buff = ed.BuffCreate(buffInfo, unit, unit)
          unit:addBuff(buff, unit)
        end
      end
    end
  end
end

function Engine:initBattleTime()
  local stage = self.stage_info
  local battleTime = stage["Battle Time"]
  if battleTime and type(battleTime) == "number" and battleTime ~= 0 then
    self.time_limit = battleTime
  end
end

function Engine:setupRogueManager()
  if self.rogueSkillMgr then
    self.rogueSkillMgr:reset()
  end
end

local function withBattleHero(self, id)
  local heroes = self.hero_list
  for k, hero in pairs(heroes) do
    if hero._tid == id then
      return true
    end
  end
  return false
end

Engine.withBattleHero = withBattleHero

function Engine:getStageId()
  local stageId = self.stage_info["Stage ID"]
  if stageId then
    return stageId
  else
    return -1
  end
end

local function arenaMode(self)
  if self.bot_mode then
    return true
  end
  if self.custom_mode or self.arena_mode or self.toppvp_mode or self.gvg_mode or self.gcw_mode or self.quest_mode or self.battle_check_arena_mode or self.legendArena_mode or self.starGate_mode or self.cupArena_mode or self.peakArena_mode or self.guildClash_mode then
    return true
  end
  if self.awakeStageMode and self.stage_info["Ally Num"] > 5 then
    return true
  end
  return false
end

Engine.arenaMode = arenaMode

local function stopFreezeMode(self)
  if self:isAwakeStageMultiMode() then
    return true
  end
  return false
end

Engine.stopFreezeMode = stopFreezeMode

local function isAwakeStageMultiMode(self)
  if self.awakeStageMode and self.stage_info["Ally Num"] > 5 then
    return true
  end
  return false
end

Engine.isAwakeStageMultiMode = isAwakeStageMultiMode

local function specialPveMode(self, owner)
  if self.crevicedefend_mode and owner and owner.camp == ed.emCampPlayer then
    return true
  end
  return false
end

Engine.specialPveMode = specialPveMode

function Engine:manualBtMode()
  return self.manualbt_mode
end

local function pveMode(self)
  if self.custom_mode then
    return false
  end
  if self.arena_mode then
    return false
  end
  if self.crusade_mode then
    return false
  end
  if self.guildInstance_mode then
    return false
  end
  if self.wca_mode then
    return false
  end
  return true
end

local function range(hid)
  local autoAttack = ed.lookupDataTable("Unit", "Basic Skill", hid)
  return ed.lookupDataTable("Skill", "Max Range", autoAttack, 0)
end

local function sortHeroList(list)
  table.sort(list, function(a, b)
    local ra = range(a._tid)
    local rb = range(b._tid)
    if ra == rb then
      return a._tid < b._tid
    end
    return ra < rb
  end)
  if ed.engine:getStageId() ~= 20105 or not ed.engine:withBattleHero(10001) then
    return
  end
  local index = 1
  for i, hero in ipairs(list) do
    if hero._tid == 10001 then
      index = i
      break
    end
  end
  if index ~= 1 then
    list[1], list[index] = list[index], list[1]
  end
end

Engine.sortHeroList = sortHeroList

local function sortUnitList(list)
  local function range(unit)
    local autoAttack = ed.lookupDataTable("Unit", "Basic Skill", unit.tid)
    
    return ed.lookupDataTable("Skill", "Max Range", autoAttack, 0)
  end
  
  table.sort(list, function(a, b)
    if range(a) == range(b) then
      return a.tid < b.tid
    end
    return range(a) < range(b)
  end)
end

local function combineBaseDyna(base, dyna)
  local data = {}
  for i, v in ipairs(base) do
    data[i] = {
      base = v,
      dyna = dyna[i]
    }
  end
  return data
end

local function initUnitMercenaryData(unit, hero)
  if nil == unit or nil == hero then
    return
  end
  if ed.run_with_scene and hero.getMercenaryData then
    unit:setMercenaryData(hero:getMercenaryData())
  end
end

local function initSelfHero(self, hero_list, isbot, warschool, bookReadingLevel, param)
  if nil == hero_list then
    return
  end
  self.hero_list = hero_list
  sortHeroList(hero_list)
  local unitArray = {}
  for i = 1, #hero_list do
    local proto = hero_list[i]
    local hero = self:createSelfHero(proto, isbot, param)
    table.insert(self.unit_list, hero)
    table.insert(self.hero_id_list, proto._tid)
    table.insert(unitArray, hero)
  end
  for i = 1, #unitArray do
    local bonusInfos = param.exBonus
    if bonusInfos then
      local unit = unitArray[i]
      unit:initExBonus(bonusInfos)
    end
  end
end

Engine.initSelfHero = initSelfHero

local function createSelfHero(self, proto, isbot, param)
  param = param or {}
  local battleBonus = param.battleBonus
  if battle_tick.getMpTimePvp() then
    battleBonus = param.bonusInfo and param.bonusInfo[proto._tid] or nil
  end
  local hero
  if ed.enableMaxAttStrategy then
    hero = ed.UnitCreate(proto, ed.emCampPlayer, {
      estimate_rank = false,
      estimate_skill = false,
      estimate_max_rank = ed.enableMaxAttStrategy
    }, nil, nil, 0, param.battleBonus, {
      awakeStageBonus = param.awakeStageBonus
    })
  else
    local mode
    if self.guildInstance_mode then
      mode = "guildraid"
    end
    local meal = {
      mode = mode,
      time = ed.startBattleTime
    }
    local dps_mod = self:getUnitDPSMod(proto._tid)
    local imu_mod = self:getUnitIMUMod(proto._tid)
    local config = {
      meal = meal,
      estimate_rank = isbot,
      estimate_skill = isbot,
      estimate_max_rank = ed.enableMaxAttStrategy,
      dps_mod = dps_mod,
      imu_mod = imu_mod,
      rank_limit = param.rank_limit,
      ignore_legend_equip = param.ignore_legend_equip,
      ignore_equip = param.ignore_equip
    }
    hero = ed.UnitCreate(proto, ed.emCampPlayer, config, nil, nil, 0, param.battleBonus, {
      awakeStageBonus = param.awakeStageBonus
    })
  end
  if not self.crevicedefend_mode then
    initUnitMercenaryData(hero, proto)
  end
  hero.ai.will_cast_manual_skill = isbot
  return hero
end

Engine.createSelfHero = createSelfHero

function Engine:heroReborn(unit)
  if self.awakeStageMode then
    local hero
    if unit.camp == ed.emCampPlayer then
      hero = self:createSelfHero(unit.proto, false, {
        awakeStageBonus = self.awakeStageBonus,
        rank_limit = self.stage_info["Rank Limit"],
        ignore_equip = self.stage_info["Rank Limit"] > 0,
        ignore_legend_equip = self.stage_info["Ignore LegendEquip"]
      })
      hero.position = {150, 0}
    elseif unit.camp == ed.emCampEnemy then
      local battle = ed.lookupDataTable("DungeonBattle", nil, self.stage_info["Stage ID"], self.wave_id)
      hero = self:createOneMonster(unit.monster_idx, unit.proto._tid, battle)
      hero.position = {650, 0}
    end
    if not hero then
      return
    end
    hero:reset()
    hero.die_unique_id = unit.unique_id
    unit.reborn_unique_id = hero.unique_id
    self:addUnit(hero)
    hero.battledata = unit.battledata
    hero:setMP(1000)
    for index, buffId in ipairs({99000001, 99000002}) do
      local info = ed.getDataTable("Buff")[buffId]
      local buff = ed.BuffCreate(info, hero, hero)
      hero:addBuff(buff, hero)
    end
    for _, skill in ipairs(hero.skill_list or {}) do
      if skill.info["Outside Screen"] == true then
        skill.cd_remaining = skill.info.CD
      end
    end
  end
end

local function enterStage(self, stage_info, hero_list, isbot, startWaveId, warschool, bookReadingLevel, params)
  startWaveId = startWaveId or 1
  self:resetStage()
  self.myth_mode = params and params.mode or nil
  if do_battle_log then
    logBeforeBt(hero_list, nil, nil, 0, params)
  end
  self.stage_info = stage_info
  self.wave_id = 1
  local battle
  local battleBonus = params and params.battleBonus or nil
  local param
  if self.myth_mode == "crevicedefend" then
    self.crevicedefend_mode = true
    battle = ed.lookupDataTable("CreviceDefendBattle", nil, params.stageid, startWaveId)
    param = {stageType = "dreamland", battleBonus = battleBonus}
    self.custom_data_battle = battle
  else
    battle = ed.lookupDataTable("Battle", nil, stage_info["Stage ID"], startWaveId)
    param = {
      stageType = battle["Stage Type"],
      battleBonus = battleBonus
    }
  end
  initSelfHero(self, hero_list, isbot, nil, 0, param)
  self:dealPveBattleBonus(battleBonus)
  if params then
    self.manualbt_mode = params.manualBattle
  end
  self:setupBattle(battle)
  if param.stageType == "dreamland" and params.stageBuff then
    self:initStageManager(params.stageBuff)
  end
  self.mp_bonus = self.stage_info["MP Bonus"]
end

Engine.enterStage = enterStage

local function enterSeasonArena(self, stage_info, hero_list, isbot, startWaveId, warschool, bookReadingLevel, params)
  startWaveId = startWaveId or 1
  self:resetStage()
  self.mode = "SeasonArena"
  self.stage_info = stage_info
  self.wave_id = 1
  local battle = ed.lookupDataTable("Battle", nil, stage_info["Stage ID"], startWaveId)
  local battleBonus = params and params.battleBonus or nil
  local param = {
    stageType = battle["Stage Type"],
    battleBonus = battleBonus
  }
  initSelfHero(self, hero_list, isbot, nil, 0, param)
  self:dealPveBattleBonus(battleBonus)
  self:setupBattle(battle)
  self.mp_bonus = self.stage_info["MP Bonus"]
end

Engine.enterSeasonArena = enterSeasonArena

function Engine:getEnemyHpInfo()
  local enemyHpInfo = {}
  local donePercent = 0
  for i, unit in ipairs(self.unit_list) do
    if unit.config.is_summoned ~= true and unit.camp == ed.emCampEnemy and unit.monster_idx then
      local percernt = math.ceil(unit.hp / unit.attribs.HP * 10000)
      enemyHpInfo[unit.monster_idx] = percernt
      donePercent = donePercent + percernt
    end
  end
  for i = 1, 5 do
    if enemyHpInfo[i] == nil then
      enemyHpInfo[i] = 0
    end
  end
  return enemyHpInfo, donePercent
end

local function getEnemyInfo(self)
  local enemyInfo = {}
  for i, unit in ipairs(self.unit_list) do
    if unit.config.is_summoned ~= true and unit.camp == ed.emCampEnemy and unit.monster_idx then
      local enemy = {}
      if unit.hp < 0 then
        enemy._hp_perc = 0
      else
        enemy._hp_perc = math.ceil(unit.hp / unit.attribs.HP * 10000)
      end
      if unit.attribs.MP == 0 then
        enemy._mp_perc = 0
      else
        enemy._mp_perc = math.ceil(unit.mp / unit.attribs.MP * 10000)
      end
      enemy._custom_data = unit.custom_data
      enemyInfo[unit.monster_idx] = enemy
    end
  end
  for i = 1, self.enemyLenght do
    if enemyInfo[i] == nil then
      enemyInfo[i] = {_hp_perc = 0, _mp_perc = 0}
    end
  end
  return enemyInfo
end

Engine.getEnemyInfo = getEnemyInfo

local function getStageProgress(self)
  local maxPercent = 10000
  local donePercent = 0
  local totalPercent = 0
  local totalWaves = self.stage_info.Waves
  for i = 1, totalWaves do
    local battle = ed.lookupDataTable("Battle", nil, self.stage_info["Stage ID"], i)
    local weight = battle["Raid Wave Weight"] or 0
    totalPercent = totalPercent + weight
    if i < self.wave_id then
      donePercent = donePercent + weight
    elseif self.wave_id == i then
      local hpInfo, percent = self:getEnemyHpInfo()
      local totalPercent = self.monsterNum * maxPercent
      donePercent = donePercent + (totalPercent - percent) / totalPercent * weight
    end
  end
  return math.floor(donePercent / totalPercent * maxPercent)
end

function Engine:getAwakeStageProgress(result)
  local maxPercent = 10000
  local donePercent = 0
  local totalPercent = 0
  local totalWaves = self.stage_info.Waves
  for i = 1, totalWaves do
    local battle = ed.lookupDataTable(self:getBattleCsvName(), nil, self.stage_info["Stage ID"], i)
    local weight = battle["Raid Wave Weight"] or 1
    totalPercent = totalPercent + weight
    if i < self.wave_id then
      donePercent = donePercent + weight
    elseif self.wave_id == i then
      local hpInfo, percent = self:getEnemyHpInfo()
      local totalPercent = self.monsterNum * maxPercent
      donePercent = donePercent + (totalPercent - percent) / totalPercent * weight
    end
  end
  local ratio = donePercent / totalPercent
  if self.stage_info["Stage Category"] == "Boss" then
    local unitPercent = 2500
    return math.floor((self.stage_info["Boss Difficulty"] - 1) * unitPercent + ratio * unitPercent)
  elseif self.stage_info["Stage Category"] == "Special" and 0 == result then
    return maxPercent
  else
    return math.floor(ratio * maxPercent)
  end
end

function Engine:convertAwakeStageProgressToShow(progress)
  if self.stage_info["Stage Category"] == "Boss" then
    local unitPercent = 2500
    progress = progress - (self.stage_info["Boss Difficulty"] - 1) * unitPercent
    return math.floor(progress / unitPercent * 10000)
  else
    return progress
  end
end

local function enterGuildInstance(self, stage_info, hero_list, guildInstanceInfo, isbot)
  if guildInstanceInfo == nil then
    return
  end
  self:resetStage()
  if do_battle_log then
    logBeforeBt(hero_list, nil, nil, nil, {})
  end
  self.stage_info = stage_info
  self.mp_bonus = 1
  self.guildInstance_mode = true
  initSelfHero(self, hero_list, isbot, nil, nil, {})
  local battle = ed.lookupDataTable("Battle", nil, stage_info["Stage ID"], guildInstanceInfo.wave)
  local hpData
  if guildInstanceInfo.hpInfo then
    hpData = {}
    for i, v in ipairs(guildInstanceInfo.hpInfo) do
      local hpInfo = {}
      hpInfo._hp_perc = v
      table.insert(hpData, hpInfo)
    end
  end
  self:setupBattle(battle, hpData)
end

Engine.enterGuildInstance = enterGuildInstance

local function initUnitList(self, isSelf, hero_list, hero_is_bot, hero_dyna, manual_skill, warschool, book_reading_level, battleBonus)
  sortHeroList(hero_list)
  local unitlist = {}
  for i = 1, #hero_list do
    local isAlive = true
    if hero_dyna and hero_dyna[i]._hp_perc <= 0 then
      isAlive = false
    end
    if isAlive then
      local proto = hero_list[i]
      local hp_coefficient_key = "Arena HP Mult"
      if self.wca_mode or self.multiarena_mode then
        hp_coefficient_key = "PVP HP Mult"
      end
      local config = {
        hp_mod = ed.lookupDataTable("Levels", hp_coefficient_key, proto._level)
      }
      setUpConfigEstimateInfo(config, proto._tid, hero_is_bot)
      local dyna
      if hero_dyna then
        dyna = hero_dyna[i]
      end
      local mode
      if self.babelMode then
        mode = "babel"
      elseif self.multiplayerMode then
        mode = "dreamland"
      elseif self.guildInstance_mode then
        mode = "guildraid"
      elseif self.arena_mode and not isSelf then
        mode = "pvp"
      elseif self.multistageTeamwork_mode or self.multistage_mode then
        mode = "multistage"
      end
      local meal = {
        mode = mode,
        time = ed.startBattleTime
      }
      config.meal = meal
      local unit
      if isSelf then
        unit = ed.UnitCreate(proto, ed.emCampPlayer, config, dyna, nil, 0)
      else
        unit = ed.UnitCreate(proto, ed.emCampEnemy, config, dyna, nil, 0)
      end
      unit.index_in_team = i
      if isSelf then
        if self.crusade_mode or manual_skill then
          unit.ai.will_cast_manual_skill = false
        end
        initUnitMercenaryData(unit, proto)
      end
      if self.wca_mode then
        unit.ai.will_cast_manual_skill = false
      end
      if self.multiarena_mode then
        unit.ai.will_cast_manual_skill = true
      end
      self:addUnit(unit)
      table.insert(unitlist, unit)
    end
  end
  return unitlist
end

Engine.initUnitList = initUnitList

local function initUnitInfo(self, self_unit, enemy_unit)
  for i, v in ipairs(self_unit) do
    v.position = {
      initial_position[i][1],
      initial_position[i][2]
    }
    table.insert(self.hero_id_list, v.tid)
  end
  for i, v in ipairs(enemy_unit) do
    local position = initial_position[i]
    v.position = {
      ed.engine.stage_rect.maxX - position[1],
      position[2]
    }
  end
  self:resetUnitList()
end

Engine.initUnitInfo = initUnitInfo

local function initLordUnit(self, hero_list, enemy_list, bookReadingLevels)
  bookReadingLevels = {}
  local hp_coefficient_key = "PVP HP Mult"
  for i = 1, #hero_list do
    local proto = hero_list[i]
    local config = {
      hp_mod = ed.lookupDataTable("Levels", hp_coefficient_key, proto._level)
    }
    local camp = ed.emCampPlayer
    if not battle_tick.getHost() then
      camp = ed.emCampEnemy
    end
    local ws_books, book_level, battleBonus = self.battle_manager:GetTeamLordWSChools(true)
    local hero = ed.lordUnitCreate(proto, camp, config, nil, nil, 0, battleBonus)
    hero.ai.will_cast_manual_skill = true
    self:addUnit(hero)
    hero.position = {
      ed.multiArena.locked_host_pos_x,
      0
    }
    table.insert(self.hero_id_list, proto._tid)
  end
  for i = 1, #enemy_list do
    local proto = enemy_list[i]
    local config = {
      hp_mod = ed.lookupDataTable("Levels", hp_coefficient_key, proto._level)
    }
    local camp = ed.emCampEnemy
    if not battle_tick.getHost() then
      camp = ed.emCampPlayer
    end
    local ws_books, book_level, battleBonus = self.battle_manager:GetTeamLordWSChools(true)
    local enemy = ed.lordUnitCreate(proto, camp, config, nil, ws_books, book_level, battleBonus)
    enemy.ai.will_cast_manual_skill = true
    self:addUnit(enemy)
    enemy.position = {
      self.stage_rect.maxX - ed.multiArena.locked_host_pos_x,
      0
    }
  end
  self:resetUnitList()
end

Engine.initLordUnit = initLordUnit

local function initHeroInfo(self, hero_list, hero_is_bot, enemy_list, enemy_is_bot, self_crusade, enemy_crusade, indexList, param)
  param = param or {}
  local hp_coefficient_key = "Arena HP Mult"
  if self.wca_mode or self.multiarena_mode then
    hp_coefficient_key = "PVP HP Mult"
  end
  local rogueTechBonus = param.rogueTechBonus or {}
  for i = 1, #hero_list do
    local proto = hero_list[i]
    local config = {
      hp_mod = ed.lookupDataTable("Levels", hp_coefficient_key, proto._level)
    }
    setUpConfigEstimateInfo(config, proto._tid, hero_is_bot)
    local crusade
    if self_crusade then
      crusade = self_crusade[proto._tid]
    end
    local camp = ed.emCampPlayer
    if battle_tick.getRealTimePvp() and not battle_tick.getHost() then
      camp = ed.emCampEnemy
    end
    local mode
    if self.babelMode then
      mode = "babel"
    elseif self.multiplayerMode then
      mode = "dreamland"
    elseif self.guildInstance_mode then
      mode = "guildraid"
    elseif self.arena_mode and camp == ed.emCampEnemy then
      mode = "pvp"
    elseif self.multistageTeamwork_mode or self.multistage_mode then
      mode = "multistage"
    end
    local meal = {
      mode = mode,
      time = ed.startBattleTime
    }
    config.meal = meal
    local hero = ed.UnitCreate(proto, camp, config, crusade, nil, 0, nil, {rogueTechBonus = rogueTechBonus})
    if self.crusade_mode or self.wca_mode or self.throne_tower_mode or self.chaos_tower_mode or self.assassinateMode or self.rogue_mode then
      hero.ai.will_cast_manual_skill = false
    end
    if self.multiarena_mode then
      hero.ai.will_cast_manual_skill = true
    end
    initUnitMercenaryData(hero, proto)
    self:addUnit(hero)
    hero.position = {
      initial_position[i][1],
      initial_position[i][2]
    }
    table.insert(self.hero_id_list, proto._tid)
  end
  for i = 1, #enemy_list do
    local proto = enemy_list[i]
    local config = {
      hp_mod = ed.lookupDataTable("Levels", hp_coefficient_key, proto._level)
    }
    setUpConfigEstimateInfo(config, proto._tid, enemy_is_bot)
    local crusade
    if enemy_crusade then
      if indexList then
        crusade = enemy_crusade[indexList[proto]]
      else
        crusade = enemy_crusade[proto._tid]
      end
    end
    local camp = ed.emCampEnemy
    if battle_tick.getRealTimePvp() and not battle_tick.getHost() then
      camp = ed.emCampPlayer
    end
    local mode
    if self.multiplayerMode then
      mode = "dreamland"
    elseif self.guildInstance_mode then
      mode = "guildraid"
    elseif self.arena_mode and camp == ed.emCampEnemy then
      mode = "pvp"
    end
    local meal = {
      mode = mode,
      time = ed.startBattleTime
    }
    config.meal = meal
    local oppoBonus
    local enemy = ed.UnitCreate(proto, camp, config, crusade, nil, 0)
    if self.wca_mode then
      enemy.ai.will_cast_manual_skill = false
    end
    self:addUnit(enemy)
    local position = initial_position[i]
    enemy.position = {
      ed.engine.stage_rect.maxX - position[1],
      position[2]
    }
  end
  self:resetUnitList()
end

Engine.initHeroInfo = initHeroInfo

local function jumpToTick(self, tick)
  for i = 1, tick do
    self:tick()
  end
end

Engine.jumpToTick = jumpToTick

local function enterArena(self, hero_list, enemy_list, hero_is_bot, enemy_is_bot, warschool, bookReadingLevels, isFootHold, pvpActivityId, bonusInfo, isShareFight, background)
  self:resetStage()
  if do_battle_log then
    logBeforeBt(hero_list, enemy_list, nil, 0, bonusInfo)
  end
  self.arena_mode = true
  self.share_fight = isShareFight
  self.pvpIsFootHold = isFootHold
  self.pvpActivityId = pvpActivityId
  self.stage_info = ed.lookupDataTable("Stage", -1)
  self.hero_list = hero_list
  sortHeroList(hero_list)
  sortHeroList(enemy_list)
  self.wave_id = 1
  initHeroInfo(self, hero_list, hero_is_bot, enemy_list, enemy_is_bot, nil, nil, nil, nil, 0)
  self:dealPvpBattleBonusInfo(bonusInfo)
  self:initStageManager()
  self.mp_bonus = 1
end

Engine.enterArena = enterArena

local function enterShareFight(self, hero_list, enemy_list, hero_is_bot, enemy_is_bot, warschool, bookReadingLevels, isFootHold, pvpActivityId, bonusInfo)
  self:resetStage()
  if do_battle_log then
    logBeforeBt(hero_list, enemy_list, nil, 0, bonusInfo)
  end
  self.pvpIsFootHold = isFootHold
  self.stage_info = ed.lookupDataTable("Stage", -1)
  self.hero_list = hero_list
  sortHeroList(hero_list)
  sortHeroList(enemy_list)
  self.wave_id = 1
  initHeroInfo(self, hero_list, hero_is_bot, enemy_list, enemy_is_bot, nil, nil, nil, nil, 0)
  self:dealPvpBattleBonusInfo(bonusInfo)
  self:initStageManager()
  self.mp_bonus = 1
end

Engine.enterShareFight = enterShareFight

function Engine.writeBattleLog(param)
  local heroList = param.heroList
  local enemyList = param.enemyList
  if do_battle_log then
    logBeforeBt(heroList, enemyList, nil, 0)
  else
    print("Warning: do_battle_log flag is close!")
  end
end

local function modify(old, modifier, default)
  default = default or 100
  modifier = modifier or default
  if modifier == 0 then
    modifier = default
  end
  return old * modifier / 100
end

function Engine:getMonsterCofig(param)
  local battleCofig = param.config
  local config = {
    is_monster = true,
    is_boss = false,
    estimate_rank = true,
    estimate_skill = true,
    estimate_max_rank = false,
    hp_mod = modify(1, battleCofig["Monster HP%"]),
    dps_mod = modify(1, battleCofig["Monster DPS%"]),
    arm_mod = modify(1, battleCofig["Monster ARM%"]),
    mr_mod = modify(1, battleCofig["Monster MR%"]),
    money = battleCofig["Money Reward " .. param.index]
  }
  if param.isBoss then
    config.is_boss = true
    config.hp_mod = modify(1, battleCofig["Boss HP%"])
    config.dps_mod = modify(1, battleCofig["Boss DPS%"])
    config.size_mod = modify(1, battleCofig["BOSS SIZE%"], 120) * self.unitScale
    config.arm_mod = modify(1, battleCofig["Boss ARM%"])
    config.mr_mod = modify(1, battleCofig["Boss MR%"])
  end
  return config
end

function Engine:getMonsterProto(param)
  local battleCofig = param.config
  local level = battleCofig["Level " .. param.index]
  local stars = battleCofig["Stars " .. param.index] or 1
  local proto = {
    _tid = param.id,
    _level = level,
    _stars = stars,
    _arousal = battleCofig["Awake" .. param.index] and {_status = 1}
  }
  return proto
end

function Engine:onUnitBeKilled(unit, killer_unit)
  if unit.camp ~= ed.emCampEnemy then
    return
  end
  local energy = self.currentEnergy
  if unit.is_monster then
    self.currentEnergy = energy + self.killEnemyEnergy
  end
  if unit.is_boss then
    self.currentEnergy = energy + self.killBossEnergy
  end
end

function Engine:canJionBattle()
  local totalUnit = 0
  for unit in self:foreachAliveUnit(ed.emCampPlayer) do
    if unit:isHero() then
      totalUnit = totalUnit + 1
    end
  end
  return totalUnit < MaxMonsterLimit
end

function Engine:hasNextWaveMonster()
  if self.nextWaveLeftEnemyIndex <= #self.leftEnemyJoinTime then
    return true
  end
  if self.nextWaveRightEnemyIndex <= #self.rightEnemyJoinTime then
    return true
  end
  return false
end

function Engine:updateNextWaveMonster()
  if self.nextWaveLeftEnemyIndex <= #self.leftEnemyJoinTime then
    self:nextWaveMonster("left")
  end
  if self.nextWaveRightEnemyIndex <= #self.rightEnemyJoinTime then
    self:nextWaveMonster("right")
  end
end

function Engine:nextWaveMonster(direction)
  local curIndex, time, stageId, camp
  if "left" == direction then
    curIndex = self.nextWaveLeftEnemyIndex
    time = self.leftEnemyJoinTime[curIndex]
    stageId = self.leftEnemyStageIDs[curIndex]
  end
  if "right" == direction then
    curIndex = self.nextWaveRightEnemyIndex
    time = self.rightEnemyJoinTime[curIndex]
    stageId = self.rightEnemyStageIDs[curIndex]
  end
  if self.ticks >= time / ed.tick_interval then
    if "left" == direction then
      self.nextWaveLeftEnemyIndex = curIndex + 1
    end
    if "right" == direction then
      self.nextWaveRightEnemyIndex = curIndex + 1
    end
  end
end

function Engine:updateStageNextWave()
  local refreshTimeList = self.stage_info["Refresh Time"]
  local waveId
  for index, time in ipairs(refreshTimeList or {}) do
    if self.ticks == time / ed.tick_interval then
      waveId = index + 1
      break
    end
  end
  if waveId then
    local stageId = self.stage_info["Stage ID"]
    local battle = ed.lookupDataTable(self:getBattleCsvName(), nil, stageId, waveId)
    self.wave_id = battle["Wave ID"]
    self.stage_type = battle["Stage Type"]
    local unitList = self:createMonster(battle, nil, position_config_1)
    for index, unit in ipairs(unitList) do
      local oldPositionX, oldPositionY = unit.position[1], unit.position[2]
      unit:reset()
      local info = ed.getDataTable("Buff")[99000001]
      local buff = ed.BuffCreate(info, unit, unit)
      unit:addBuff(buff, unit)
      for _, skill in ipairs(unit.skill_list or {}) do
        if skill.info["Outside Screen"] == true then
          skill.cd_remaining = skill.info.CD
        end
      end
      unit.position = {oldPositionX, oldPositionY}
    end
    if self.awakeStageMode then
      self:addAwakeDungeonBuff(unitList)
    end
  end
end

function Engine:updateHeroReborn()
  local rebornTime = self.stage_info["Reborn Time"]
  if rebornTime == 0 then
    return
  end
  local new_die_units = {}
  for index, dieUnit in ipairs(self.die_units) do
    local die_tick = dieUnit.die_tick
    if rebornTime <= (self.ticks - die_tick) * ed.tick_interval then
      self:heroReborn(dieUnit)
    else
      table.insert(new_die_units, dieUnit)
    end
  end
  self.die_units = new_die_units
end

function Engine:getAllyHeroIndexById(hid)
  for index, hero in ipairs(self.siegeBattleHeroes) do
    if hero._tid == hid then
      return index
    end
  end
end

function Engine:getAllyHeroIdByIndex(index)
  for idx, hero in ipairs(self.siegeBattleHeroes) do
    if idx == index then
      return hero._tid
    end
  end
end

function Engine:placeAllyHero(info)
  if ed.IsMultiArena() then
    local hindex = ed.multiArena.HeroId2Index(info.hid)
    local oppration = {
      op = ed.opJoinHeroBattle,
      tick = self.ticks,
      hid = hindex,
      ext = info.pos,
      isHost = battle_tick.getHost() and battle_tick.HOST or battle_tick.GUEST
    }
    battle_tick.addSelfOperation(oppration)
  else
    local index = self:getAllyHeroIndexById(info.hid)
    if not index then
      return
    end
    local oppration = {
      op = ed.opJoinHeroBattle,
      tick = self.ticks,
      hid = index,
      ext = {0, 0},
      isHost = 0
    }
    local pos = info.pos
    table.insert(self.allyBattlePosInfos, {
      _index = index,
      _x = pos.x,
      _y = pos.y
    })
    battle_tick.addSelfOperation(oppration)
  end
end

function Engine:placeMagic(info)
  local index = ed.multiArena.MagicId2Index(info.id)
  local oppration = {
    op = ed.opJoinMagicBattle,
    tick = self.ticks,
    hid = index,
    ext = info.pos,
    isHost = battle_tick.getHost() and battle_tick.HOST or battle_tick.GUEST
  }
end

function Engine:manualEchoSkill(echoId)
  local oppration = {
    op = ed.opJoinEchoSkill,
    tick = self.ticks,
    echoId = echoId
  }
  battle_tick.addSelfOperation(oppration)
end

function Engine:setAllyBattlePosInfo(posinfos)
  self.allyBattlePosInfos = posinfos
end

function Engine:getAllyBattlePosById(hid)
  local index = self:getAllyHeroIndexById(hid)
  for _, posinfo in ipairs(self.allyBattlePosInfos) do
    if posinfo._index == index then
      if ed.IsMultiArena() then
        return posinfo.pos
      else
        return {
          posinfo._x,
          posinfo._y
        }
      end
    end
  end
end

function Engine:initReadyAndWaitBattleUnits()
  local readyUnits = {
    nil,
    nil,
    nil,
    nil,
    nil
  }
  local battleHeroes = self.siegeBattleHeroes
  for idx = 1, 5 do
    readyUnits[idx] = battleHeroes[idx]
  end
  self.readyForBattleUnits = readyUnits
  local waitUnits = {
    nil,
    nil,
    nil,
    nil,
    nil
  }
  for idx = 6, #battleHeroes do
    waitUnits[#waitUnits + 1] = battleHeroes[idx]
  end
  local len = #waitUnits
  for idx = 1, len do
    local jdx = ed.rand() * len + 1
    jdx = math.floor(jdx)
    waitUnits[idx], waitUnits[jdx] = waitUnits[jdx], waitUnits[idx]
  end
  self.waitForBattleUnits = waitUnits
end

local MaxAllyHeroCount = 8

function Engine:getBattleStageId()
  return self.stage_info["Stage ID"]
end

function Engine:getCurrentEnemyWaveIndex()
  return self.currentEnemyWaveIndex
end

function Engine:getNightmareDeadMonsters()
  return self.nightmareDeadMonsters
end

function Engine:isTowerWarsMode()
  if self.siegeMode then
    return true
  end
  if self.nightmareMode then
    return true
  end
  return false
end

function Engine:battleCheck(param)
  self:resetStage()
  local type = param.type
  if type == "pvp" then
    local hero_list = param.selfTeam
    local enemy_list = param.oppoTeam
    if do_battle_log then
      logBeforeBt(hero_list, enemy_list, nil, 0)
    end
    self.battle_check_arena_mode = true
    self.stage_info = ed.lookupDataTable("Stage", -1)
    self.hero_list = hero_list
    sortHeroList(hero_list)
    sortHeroList(enemy_list)
    self.wave_id = 1
    initHeroInfo(self, hero_list, false, enemy_list, true, nil, nil, nil, nil, 0)
    self.mp_bonus = 1
  elseif type == "guild" or type == "dreamland" then
    local startWaveId = 1
    local hero_list = param.selfTeam
    local stageInfo = param.stageInfo
    if do_battle_log then
      logBeforeBt(hero_list, enemy_list, nil, 0)
    end
    self.battle_check_stage_mode = true
    self.stage_info = stageInfo
    initSelfHero(self, hero_list, false, nil, 0)
    local battle = ed.lookupDataTable("Battle", nil, stageInfo["Stage ID"], startWaveId)
    self:setupBattle(battle)
    self.mp_bonus = self.stage_info["MP Bonus"]
  end
end

local function enterWCA(self, left_list, right_list, isHost, bonusInfo)
  self:resetStage()
  self.wca_mode = true
  self.stage_info = ed.lookupDataTable("Stage", -27)
  self.hero_list = left_list
  sortHeroList(left_list)
  sortHeroList(right_list)
  self.wave_id = 1
  battle_tick.setRealTimePvp(true)
  battle_tick.setHost(isHost)
  initHeroInfo(self, left_list, nil, right_list, nil, nil, nil, nil, nil, nil, bonusInfo)
  self:dealPvpBattleBonusInfo(bonusInfo)
  if not isHost then
    self.hero_list = right_list
    self.hero_id_list = {}
    for i = 1, #self.hero_list do
      local proto = self.hero_list[i]
      table.insert(self.hero_id_list, proto._tid)
    end
  end
  self.mp_bonus = 1
end

Engine.enterWCA = enterWCA

local function enterCrusade(self, hero_list, enemy_list, enemy_is_bot, self_crusade, enemy_crusade, stage_id, extraMode, warschool, bookReadingLevels, energyBeanNumber, bonusInfo, crusadeActivityId)
  self:resetStage()
  if do_battle_log then
    logBeforeBt(hero_list, enemy_list, {}, 0, bonusInfo)
  end
  self.crusadeActivityId = crusadeActivityId
  self.energyBeanNumber = energyBeanNumber or 0
  self.energyBean_mode = self.energyBeanNumber ~= 0
  self.crusade_mode = true
  self.stage_info = ed.lookupDataTable("Stage", stage_id)
  self.hero_list = hero_list
  sortHeroList(hero_list)
  sortHeroList(enemy_list)
  self.wave_id = 1
  initHeroInfo(self, hero_list, false, enemy_list, enemy_is_bot, self_crusade, enemy_crusade)
  self.mp_bonus = 1
  if extraMode == "hell" then
    self:disableHPSAndMPS()
  end
  self:initStageManager()
end

Engine.enterCrusade = enterCrusade

function Engine:addUnitBuffByCamp(camp, buffs)
  for i, buff_id in ipairs(buffs or {}) do
    local info = ed.getDataTable("Buff")[buff_id]
    for unit in self:foreachAliveUnit(camp) do
      local buff = ed.BuffCreate(info, unit, unit)
      buff:setPercentAttribs()
      unit:addBuff(buff, unit)
    end
  end
end

local function enterRelay(self, param)
  param = param or {}
  self:resetStage()
  self.replayMode = true
  self.stage_info = ed.lookupDataTable("Stage", param.stage_id)
  self.wave_id = 1
  self.battleBOType = param.battleBOType
  self.arena_mode = param.mode == "pvp"
  self.quest_mode = param.mode == "quest"
  self.wca_mode = param.mode == "real_pvp"
  self.pvpActivityId = param.ladder_buff_id
  self.crusade_mode = param.mode == "tbc"
  self.peakArena_mode = param.mode == "peakArena"
  self.cupArena_mode = param.mode == "cupArena"
  self.guildClash_mode = param.mode == "guildClash"
  self.crevicedefend_mode = param.mode == "crevicedefend"
  local self_manual, enemy_manual
  if param.mode == "real_pvp" then
    enemy_manual = true
    self_manual = true
    battle_tick.setRealTimePvp(true)
    battle_tick.setHost(true)
    battle_tick:enterReplayMode()
    for i, v in ipairs(battle_tick.rebuildOperation(param.operations or {})) do
      battle_tick.setSelfOperation(v._tick, v._operation)
    end
    for i, v in ipairs(battle_tick.rebuildOperation(param.right_operations or {})) do
      battle_tick.setTargetOperation(v._tick, v._operation)
    end
  else
    if param.oppoUserid == ed.getUserid() then
      if param.operations then
        enemy_manual = true
      end
    elseif param.operations then
      self_manual = true
    end
    self:setOperationList(param.operations)
  end
  if param.mode == "tbc" then
    self.energyBeanNumber = 100
    self.energyBean_mode = true
    if param.selfBonus then
      self.crusadeActivityId = param.selfBonus._buff_id
    end
  end
  local selfBonus = param.selfBonus
  local oppoBonus = param.oppoBonus
  local selfUnit = self:initUnitList(true, ed.copyProto(param.hero_list), param.hero_is_bot, param.self_dyna_list, self_manual, nil, 0, selfBonus)
  local enemyUnit = self:initUnitList(false, ed.copyProto(param.enemy_list), param.enemy_is_bot, param.enemy_dyna_list, enemy_manual, nil, 0, oppoBonus)
  if do_battle_log then
    logBeforeBt(param.hero_list, param.enemy_list, nil, nil)
  end
  self:initUnitInfo(selfUnit, enemyUnit)
  if self.guildClash_mode then
    self:addGuildClashBuff(selfUnit, enemyUnit, param.winTimes)
    self.guildClashWinTimes = param.winTimes
  end
  if self.peakArena_mode then
    self.peakAreanSkillId = param.seasonBuffIds
  end
  self:dealPvpBattleBonus(selfBonus, oppoBonus)
  self.mp_bonus = 1
  if self.starGate_mode then
    if param.trigger_buf then
      self:initStageManager()
    end
  else
    self:initStageManager()
  end
  if self.gcw_mode then
    self:disableHPSAndMPS()
    self:addUnitBuffByCamp(ed.emCampPlayer, param.self_buffs)
    self:addUnitBuffByCamp(ed.emCampEnemy, param.oppo_buffs)
  end
end

Engine.enterRelay = enterRelay

local function enterRelay2(self, param)
  param = param or {}
  self:resetStage()
  self.stage_info = ed.lookupDataTable("Stage", param.stage_id)
  self.wave_id = 1
  self.battleIdx = param.battleIdx or 1
  self.battleBOType = param.battleBOType
  self.replayMode = false
  self.peakArena_mode = param.mode == "peakArena"
  self.cupArena_mode = param.mode == "cupArena"
  self.guildClash_mode = param.mode == "guildClash"
  self.crevicedefend_mode = param.mode == "crevicedefend"
  self:setOperationList(param.operations)
  local selfUnit = self:initUnitList(true, ed.copyProto(param.hero_list), param.hero_is_bot, param.self_dyna_list, false, nil, 0)
  local enemyUnit = self:initUnitList(false, ed.copyProto(param.enemy_list), param.enemy_is_bot, param.enemy_dyna_list, false, nil, 0)
  if do_battle_log then
    logBeforeBt(param.hero_list, param.enemy_list, nil, nil)
  end
  self:initUnitInfo(selfUnit, enemyUnit)
  if self.peakArena_mode then
    self.peakAreanSkillId = param.seasonBuffIds
  end
  self.mp_bonus = 1
  self:initStageManager()
end

Engine.enterRelay2 = enterRelay2

local function battleSupply(self, bSupplyEnemy)
  for unit in self:foreachAliveUnit(bSupplyEnemy and ed.emCampEnemy or ed.emCampPlayer) do
    local coefficient = 1
    if self.stage_info["Mps Restraint"] and self.stage_info["Mps Restraint"] > 0 then
      coefficient = self.stage_info["Mps Restraint"] / 100
    end
    unit:battleSupply(coefficient)
    unit:removeAllBuffs()
  end
  if not bSupplyEnemy then
    self.supplied = true
  end
end

Engine.battleSupply = battleSupply

local function nextBattle(self)
  if not self.supplied then
    self:battleSupply()
  end
  local battle = ed.lookupDataTable(self:getBattleCsvName(), nil, self.stage_info["Stage ID"], self.wave_id + 1)
  if self.awakeStageMode and self.stage_info["Scrolls Waves"] then
    self:setupScrollBattle(battle)
  else
    self:setupBattle(battle)
  end
  if self.fancyAbyssMode then
    self:initStageManager()
  end
  ed.engine.usedDeliveredBallSlots = {}
end

Engine.nextBattle = nextBattle

local function findMonster(self, IDorName)
  local list = {}
  for i, unit in ipairs(self.unit_list) do
    if unit.camp == ed.emCampEnemy and (unit.id == IDorName or unit.name == IDorName) then
      table.insert(list, unit)
    end
  end
  if #list == 1 then
    return list[1]
  else
    EDDebug("WTF!")
  end
end

Engine.findMonster = findMonster

local function findBoss(self)
  for i, unit in ipairs(self.unit_list) do
    if unit.camp == ed.emCampEnemy and unit.config.is_boss then
      return unit
    end
  end
  return false
end

Engine.findBoss = findBoss

local function findHero(self, IDorName)
  for i, unit in ipairs(self.unit_list) do
    if unit.camp == ed.emCampPlayer and (unit.id == IDorName or unit.name == IDorName) then
      return unit
    end
  end
end

Engine.findHero = findHero

local function setSpeedRate(self, rate)
  self.speed_rate = rate
end

Engine.setSpeedRate = setSpeedRate

local function getSpeedRate(self)
  return self.speed_rate
end

Engine.getSpeedRate = getSpeedRate

local function update(self, dt)
  if not self.running then
    return
  end
  self.next_tick = self.next_tick - dt * self.speed_rate
  if self.next_tick <= 0 then
    self:tick()
    while self.next_tick <= 0 do
      self.next_tick = self.next_tick + self.tick_interval
    end
  end
end

Engine.update = update

local function runScriptString()
  if EDGetScriptString then
    local temp = EDGetScriptString()
    if temp ~= nil then
      local func = loadstring(temp)
      if func ~= nil then
        xpcall(func, EDDebug)
      end
    end
  end
end

local function tick(self)
  if ed.enableBotMode then
    runScriptString()
  end
  if not self.running then
    return
  end
  local tick_interval = self.tick_interval
  self.time_limit = self.time_limit - tick_interval
  self:updateDayandnightState(tick_interval)
  battle_tick.submitOperation(self.ticks)
  battle_tick.submitMpOperation(self.ticks)
  self:runCurTickOperations()
  if not self.running then
    return
  end
  local alive_alliance_count, alive_enemy_count = 0, 0
  local dead_alliance_count, dead_enemy_count = 0, 0
  local player_list, enemy_list = {}, {}
  for _, list_name in ipairs(unit_list_names) do
    local list = self[list_name]
    local is_unit_list = list_name == "unit_list"
    for _, entity in ipairs(list) do
      if is_unit_list then
        local isAlive = entity:isAlive()
        local camp = entity.camp
        if entity.controlledTarget then
          camp = -camp
        end
        if camp == ed.emCampPlayer then
          if isAlive then
            alive_alliance_count = alive_alliance_count + 1
            table.insert(player_list, entity)
          else
            dead_alliance_count = dead_alliance_count + 1
          end
        elseif isAlive then
          alive_enemy_count = alive_enemy_count + 1
          table.insert(enemy_list, entity)
        else
          dead_enemy_count = dead_enemy_count + 1
        end
      end
      local frozen_model = entity.frozen_model
      if not entity.terminated and not frozen_model then
        entity:update(tick_interval)
      end
    end
  end
  for _, list_name in ipairs(unit_list_names) do
    local list = self[list_name]
    local new_list = {}
    for _, entity in ipairs(list) do
      if not entity.terminated then
        table.insert(new_list, entity)
      end
    end
    self[list_name] = new_list
  end
  self.alive_alliance_count = alive_alliance_count
  self.alive_enemy_count = alive_enemy_count
  self.dead_alliance_count = dead_alliance_count
  self.dead_enemy_count = dead_enemy_count
  self.alive_units[ed.emCampPlayer] = player_list
  self.alive_units[ed.emCampEnemy] = enemy_list
  if self.battle_manager then
    self.battle_manager:Update(ed.tick_interval)
  end
  if self.battleDataCollect then
    self.battleDataCollect:update(ed.tick_interval)
  end
  if self.hero_background[1] and 0 <= self.hero_background[2] then
    self.hero_background[2] = self.hero_background[2] - tick_interval
  end
  if 0 > self.hero_background[2] then
    self.hero_background = Engine.genHeroBackground()
    if ed.run_with_scene and not ed.IsMultiArena() then
      ed.scene:onBackgroundAppear(1, ed.scene.backgroundPathFirst)
    end
  end
  if ed.engine.ticks % self.push_interval_tick == 0 then
    self:updatePush(ed.emCampPlayer, tick_interval)
    self:updatePush(ed.emCampEnemy, tick_interval)
  end
  if self:isTowerWarsMode() then
    local energy = self.currentEnergy
    energy = energy + self.energyIncrement
    self.currentEnergy = math.min(energy, self.maxEnergy)
    local siegeTotalTime, buffTime = 180, 30
    if self.siegeMode and self.ticks > (siegeTotalTime - buffTime) / ed.tick_interval then
      local buff = self.superAwakeHero:getBuffById(536)
      if buff then
        buff.owner:removeBuff(buff)
      end
    end
    self:updateNextWaveMonster()
  elseif self.awakeStageMode then
    self:updateStageNextWave()
    self:updateHeroReborn()
  end
  self.ticks = self.ticks + 1
  if do_battle_log then
    btlog(tostring(self))
  end
  if self.autoChessMode then
    if ed.run_with_scene and not ed.run_chess_check then
      self:autoChessBattleEndCheck()
    else
      self:chessBattleEndCheckNew()
    end
  else
    self:defaultBattleEndCheck()
  end
end

Engine.tick = tick

function Engine:updatePush(camp, dt)
  local list = self.alive_units[camp]
  local length = #list
  for i = 1, length do
    local unit1 = list[i]
    if not unit1.flying then
      local movable = not unit1.buff_effects.immoblilize
      local isWalking = unit1.state == ed.emUnitState_Walk
      local isIdle = unit1.state == ed.emUnitState_Idle
      if movable and (isWalking or isIdle) then
        local pushVelocity = 0
        local position = unit1.position
        local collideWith = ed.Entity.collideWith
        local isBuilding = unit1.buff_effects.building or unit1.buff_effects.building_notfix
        local stage_rect = self.stage_rect
        for j = i + 1, length do
          local unit2 = list[j]
          if not unit2.flying and collideWith(unit1, unit2) and not isBuilding then
            pushVelocity = pushVelocity + (0 < position[2] - unit2.position[2] and 30 or -30)
          end
        end
        if position[2] > stage_rect.maxY and 0 < pushVelocity then
          pushVelocity = 0
        end
        if position[2] < stage_rect.minY and pushVelocity < 0 then
          pushVelocity = 0
        end
        if pushVelocity ~= 0 then
          unit1.push = true
          position[2] = position[2] + pushVelocity * dt
          if isIdle then
            unit1:setAction("Move", true)
          end
        else
          unit1.push = false
          if isIdle then
            unit1:setAction(unit1.idleName, true)
          end
        end
      end
    end
  end
end

function Engine:runCurTickOperations()
  if self.autoChessMode then
    return
  end
  local ulist = self.unit_list
  
  local function doOpCall(opp)
    local op = opp.op
    if op == ed.opJoinMagicBattle then
      local pos = ed.toLogicalPosition(ccp(opp.ext[1], opp.ext[2]), 0)
      local id = ed.multiArena.Index2MagicId(opp.hid)
      local info = {
        id = id,
        pos = pos,
        isHost = opp.isHost,
        teamIndex = opp.teamIndex
      }
      self:onJoinMagic(info)
      return
    end
    if opp.op == ed.opJoinEchoSkill then
      if self.echoSkillMgr then
        self.echoSkillMgr:createEchoSkill(opp.echoId)
      elseif self.rogueSkillMgr then
        self.rogueSkillMgr:executeRogueSkill(opp.echoId)
      end
      return
    end
    if opp.op == ed.opExitBattle then
      self:exitStage(0, true)
    end
    local unit = ulist[opp.unit_index]
    if not unit then
      return
    end
    if op == ed.opManualSkill then
      unit:castSkillBySolt(opp.slot, true)
      return
    end
    if opp.op == ed.opEnergyBean then
      unit:energyBeanGainMp()
      return
    end
    if opp.op == ed.opKaelTapBall and unit.tapBall then
      unit:tapBall(opp.ext)
    end
    if opp.op == ed.opControlTarget then
      local pos = ccp(opp.ext[1] * 10, opp.ext[2] * 10)
      local logical_pos = ed.toLogicalPosition(pos)
      local controlTarget = unit.controlTarget
      if controlTarget then
        controlTarget:walkTowards(logical_pos)
      end
    end
    if opp.op == ed.opControlTouch then
      local pos = ccp(opp.ext[1] * 10, opp.ext[2] * 10)
      local logical_pos = ed.toLogicalPosition(pos)
      unit:touchPositionHandler(logical_pos)
    end
    if opp.op == ed.opDamageToBoss then
    end
  end
  
  local curtick = self.ticks
  local oplist = self.operation_list
  local opindex = self.next_operation_index
  while oplist[opindex] do
    local opp = oplist[opindex]
    if opp.tick == curtick then
      doOpCall(opp)
      opindex = opindex + 1
    else
      break
    end
  end
  self.next_operation_index = opindex
end

function Engine:timeoutBattleRecheck()
  local alive_enemy_count, alive_alliance_count = 0, 0
  local dead_enemy_count, dead_alliance_count = 0, 0
  for _, list_name in ipairs(unit_list_names) do
    local list = self[list_name]
    local is_unit_list = list_name == "unit_list"
    for _, entity in ipairs(list) do
      if is_unit_list then
        local isAlive = entity:isAlive()
        local camp = entity.camp
        if entity.controlledTarget then
          camp = -camp
        end
        if camp == ed.emCampPlayer then
          if isAlive then
            alive_alliance_count = alive_alliance_count + 1
          else
            dead_alliance_count = dead_alliance_count + 1
          end
        elseif isAlive then
          alive_enemy_count = alive_enemy_count + 1
        else
          dead_enemy_count = dead_enemy_count + 1
        end
      end
    end
  end
  self.alive_alliance_count = alive_alliance_count
  self.alive_enemy_count = alive_enemy_count
  self.dead_alliance_count = dead_alliance_count
  self.dead_enemy_count = dead_enemy_count
end

function Engine:defaultBattleEndCheck()
  local defaultResult
  if self.alive_enemy_count == 0 then
    defaultResult = "victory"
  elseif 0 >= self.time_limit then
    self:timeoutBattleRecheck()
    if self.alive_enemy_count == 0 then
      defaultResult = "victory"
    elseif self.alive_alliance_count == 0 then
      defaultResult = "defeat"
    else
      defaultResult = "timeout"
    end
  elseif self.alive_alliance_count == 0 then
    defaultResult = "defeat"
  end
  local realResult = defaultResult
  if realResult and self.awakeStageMode and self.stage_info["Stage Category"] == "Special" then
    local checkCondition = true
    if self.stage_info["Refresh Time"] and self.wave_id < #self.stage_info["Refresh Time"] + 1 and realResult == "victory" then
      realResult = nil
    end
    if 0 < self.stage_info["Reborn Time"] and realResult ~= "timeout" then
      realResult = nil
    end
    if self.stage_info["Scrolls Waves"] and self.wave_id < self.stage_info.Waves then
      checkCondition = false
    end
    if nil ~= realResult and checkCondition then
      local finalCondResult = self:checkConditionBattleResult()
      if not finalCondResult then
        realResult = "defeat"
      else
        realResult = "victory"
      end
    end
  end
  if realResult == "victory" then
    self.beingEnd = true
    self:unfreeze(true)
    self:onBattleEnd()
    self:victory()
  elseif realResult == "defeat" then
    self.result_stars = 0
    self.beingEnd = true
    self:unfreeze(true)
    self:onBattleEnd()
    self:exitStage(1)
    self:defeat()
  elseif realResult == "timeout" then
    self.result_stars = 0
    self.beingEnd = true
    if self.crusade_mode then
      for i, unit in pairs(self.unit_list) do
        unit:onDying()
      end
    end
    self:onBattleEnd()
    self:exitStage(3)
  end
end

function Engine:checkConditionBattleResult()
  local finalResult = true
  for conditionId, condition in pairs(self.battleConditionList or {}) do
    local info = condition.info
    local conditionResult = condition:check(info)
    if not conditionResult then
      finalResult = false
    end
  end
  return finalResult
end

function Engine:checkDefaultBattleResult()
  if self.siegeMode or self.nightmareMode or self.assassinateMode or self.multiplayerMode or self.multiarena_mode or self.autoChessMode then
    return false
  end
  if self.awakeStageMode then
    local refreshTimeList = self.stage_info["Refresh Time"] or {}
    local rebornTime = self.stage_info["Reborn Time"] or 0
    if 0 < rebornTime then
      return 0 >= self.time_limit
    end
    if self.wave_id > #refreshTimeList and (self.alive_alliance_count == 0 or self.alive_enemy_count == 0 or 0 >= self.time_limit) then
      return true
    end
    return false
  elseif self.alive_alliance_count == 0 or self.alive_enemy_count == 0 or 0 >= self.time_limit then
    return true
  end
  return false
end

local function manuallyCastSkill(self, unit, slot)
  local oppration = {
    op = ed.opManualSkill,
    wave = self.wave_id,
    tick = self.ticks,
    unit_index = unit.index_in_engine,
    slot = slot or 1
  }
  battle_tick.addSelfOperation(oppration)
end

Engine.manuallyCastSkill = manuallyCastSkill

function Engine:getMyHeroIndex()
  for i, unit in ipairs(self.unit_list) do
    if unit.camp == ed.emCampPlayer and unit.controlTarget then
      return i
    end
  end
end

function Engine:manuallyWalkTowards(dest)
  local index = self:getMyHeroIndex()
  if not index then
    return
  end
  local oppration = {
    op = ed.opControlTarget,
    tick = self.ticks,
    unit_index = index,
    ext = {
      math.ceil(dest[1] / 10),
      math.ceil(dest[2] / 10)
    }
  }
  battle_tick.addSelfOperation(oppration)
end

function Engine:getCanTouchRespondOfHero()
  local maxPriority = -math.huge
  local ret
  for i, unit in ipairs(self.unit_list) do
    local touchPriority = unit:canTouchRespond()
    if touchPriority then
      if type(touchPriority) == "number" and maxPriority < touchPriority then
        maxPriority = touchPriority
        ret = i
      else
        return i
      end
    end
  end
  return ret
end

function Engine:manuallyLocationTarget(dest)
  local index = self:getCanTouchRespondOfHero()
  if not index then
    return
  end
  local oppration = {
    op = ed.opControlTouch,
    wave = self.wave_id,
    tick = self.ticks,
    unit_index = index,
    ext = {
      math.ceil(dest[1] / 10),
      math.ceil(dest[2] / 10)
    }
  }
  battle_tick.addSelfOperation(oppration)
end

local function manuallyGainMp(self, unit)
  local oppration = {
    op = ed.opEnergyBean,
    wave = self.wave_id,
    tick = self.ticks,
    unit_index = unit.index_in_engine
  }
  battle_tick.addSelfOperation(oppration)
end

Engine.manuallyGainMp = manuallyGainMp

function Engine:manuallyEvacuate()
  local operation = {
    op = ed.opExitBattle,
    tick = self.ticks
  }
  print("manuallyEvacuate", self.ticks)
  battle_tick.addSelfOperation(operation)
end

local function manualTapBall(self, deliverer, idx, myslotidx, nexttick)
  local kael
  if deliverer.camp == ed.emCampPlayer then
    kael = ed.engine.playerKaelHero
  else
    kael = ed.engine.enemyKaelHero
  end
  local t = self.ticks
  if nexttick then
    t = t + 1
  end
  local oppration = {
    op = ed.opKaelTapBall,
    wave = self.wave_id,
    tick = t,
    unit_index = kael.index_in_engine,
    ext = {idx, myslotidx}
  }
  battle_tick.addSelfOperation(oppration)
end

Engine.manualTapBall = manualTapBall

local function damageToBossFOP(boss_damages, selfIdx)
  if boss_damages == nil or #boss_damages == 0 then
    return
  end
  local t = self.ticks
  for i = 1, #boss_damages do
    if selfIdx ~= i then
      local oppration = {
        tick = t,
        op = ed.opDamageToBoss,
        player_index = i,
        damage = boss_damages[i]
      }
    end
    battle_tick.addSelfOperation(oppration)
  end
end

Engine.damageToBossFOP = damageToBossFOP
local slotPositions = {}
for i = 1, 10 do
  slotPositions[i] = {
    100 + 70 * i,
    ed.rand() * 30 + 210
  }
end
for i = 11, 20 do
  slotPositions[i] = {
    100 + 70 * (i - 10),
    ed.rand() * 50 + 400
  }
end
Engine.slotPositions = slotPositions

local function getDeliveredEmptySlot(self, x)
  local neari = 0
  local nearlen = 9999999
  for i = 1, 10 do
    if not self.usedDeliveredBallSlots[i] then
      local a = math.abs(slotPositions[i][1] - x)
      if nearlen > a then
        nearlen = a
        neari = i
      end
    end
  end
  if neari ~= 0 then
    return neari, slotPositions[neari]
  else
    local r = math.floor(ed.rand() * 9 + 1)
    return r, slotPositions[r]
  end
end

Engine.getDeliveredEmptySlot = getDeliveredEmptySlot

local function getManualDeliveredEmptySlot(self, x)
  local neari = 0
  local nearlen = 9999999
  for i = 11, 20 do
    if not self.usedDeliveredBallSlots[i] then
      local a = math.abs(slotPositions[i][1] - x)
      if nearlen > a then
        nearlen = a
        neari = i
      end
    end
  end
  if neari ~= 0 then
    return neari, slotPositions[neari]
  else
    local r = math.floor(ed.rand() * 10 + 1)
    return r, slotPositions[r]
  end
end

Engine.getManualDeliveredEmptySlot = getManualDeliveredEmptySlot

local function getAvailableBallSlot(self, deliver)
  for i, u in pairs(self.unit_list) do
    if u.energy_ball_manager and u.camp == deliver.camp then
      return u.energy_ball_manager:getEmptySlot(true)
    end
  end
end

Engine.getAvailableBallSlot = getAvailableBallSlot

local function setOperationList(self, list)
  self.operation_list = {}
  list = list or {}
  for i, v in ipairs(list) do
    self:setOperationListItem(i, v)
  end
end

Engine.setOperationList = setOperationList

function Engine:setOperationListItem(k, operation)
  local tick = operation._tick
  local value = operation._operation
  local op = battle_tick.splitSingleOperation(value)
  op.tick = tick
  self.operation_list[k] = op
end

local function getOprationList(self)
  return battle_tick.battleEndMakebitOperations(self.operation_list)
end

Engine.getOprationList = getOprationList

function Engine:getOrderBySlot(uIndex, slot)
  local unit = self.unit_list[uIndex]
  if not unit then
    return 0
  end
  local order = ed.lookupDataTable("SkillGroup", "Online Skill Order", unit.tid, slot or 1)
  return order or 0
end

function Engine:getSlotByOrder(uIndex, order)
  local unit = self.unit_list[uIndex]
  if not unit then
    return
  end
  local list = ed.lookupDataTable("SkillGroup", nil, unit.tid)
  for _, row in pairs(list) do
    if row["Online Skill Order"] == order then
      return row.Slot
    end
  end
end

local function freeze(self, camp)
  if self:stopFreezeMode() then
    return
  end
  if self.freeze_level == 0 then
    if ed.run_with_scene then
      ed.scene:onSceneFreezeBegin()
    end
    for entity in self:foreachEntity() do
      entity:freeze()
    end
  end
  self.freeze_level = self.freeze_level + 1
  self.freeze_camp = camp
end

Engine.freeze = freeze

local function unfreeze(self, force)
  if self:stopFreezeMode() then
    return
  end
  if force then
    if self.freeze_level == 0 then
      self.freeze_camp = nil
      return
    else
      self.freeze_level = 1
    end
  end
  self.freeze_level = self.freeze_level - 1
  if self.freeze_level == 0 then
    self.freeze_camp = nil
    for entity in self:foreachEntity() do
      entity:unfreeze()
    end
    if ed.run_with_scene then
      ed.scene:onSceneFreezeEnd()
    end
  end
end

Engine.unfreeze = unfreeze

function Engine:cutScene(x, y, w)
  return self.rect_cut.add(x, y, w)
end

function Engine:closeCut(idx)
  self.rect_cut.remove(idx)
end

function Engine:clearCut()
  self.rect_cut.clear()
end

local function addUnit(self, unit)
  local alive = unit:isAlive()
  unit.previous_position = {
    unit.position[1],
    unit.position[2]
  }
  table.insert(self.unit_list, unit)
  if alive then
    table.insert(self.alive_units[unit.camp], unit)
    table.insert(self.alive_units[ed.emCampBoth], unit)
    if unit.camp == 2 and unit.name == "Duckboy" then
      table.insert(self.alive_units[ed.emCampEnemy], unit)
      table.insert(self.alive_units[ed.emCampPlayer], unit)
      table.insert(self.alive_units[ed.emCampNeither], unit)
    end
    if unit.camp == ed.emCampPlayer then
      self.alive_alliance_count = self.alive_alliance_count + 1
    elseif unit.camp == ed.emCampEnemy then
      self.alive_enemy_count = self.alive_enemy_count + 1
    end
  elseif unit.camp == ed.emCampPlayer then
    self.dead_alliance_count = self.dead_alliance_count + 1
  elseif unit.camp == ed.emCampEnemy then
    self.dead_enemy_count = self.dead_enemy_count + 1
  end
  unit.index_in_engine = #self.unit_list
  unit:clearActor()
  unit:startWork()
end

Engine.addUnit = addUnit

function Engine:addStageUint(unit)
  table.insert(self.FieldNpc_list, unit)
end

local enhanceAttribList = {
  "HP",
  "AD",
  "AP",
  "ARM",
  "MR"
}

local function summonUnit(self, unit, position, summoner, bornActionName)
  unit.config.is_summoned = true
  unit.position = position
  self:addUnit(unit)
  unit:summon(bornActionName)
  unit.config.summoner = summoner
  if unit.actor then
    unit.actor:update(0)
  end
  local attribs = unit.attribs
  local enhanceRatio = summoner.attribs.MOBRatio * 0.01
  local buffId = 997
  local binfo = ed.lookupDataTable("Buff", nil, buffId)
  local buff = ed.BuffCreate(binfo, unit, summoner)
  for _, attribName in ipairs(enhanceAttribList) do
    if 0 < enhanceRatio then
      buff:setAttribute(attribName, attribs[attribName] * enhanceRatio)
    end
  end
  unit:addBuff(buff, summoner)
  if unit.config.summoner and unit.config.summoner.controlledTarget and unit.config.summoner.oldData then
    unit.summon_oldcamp = unit.config.summoner.oldData.camp * (unit.camp * unit.config.summoner.camp)
  end
  if summoner and summoner.campLv and (not unit.campLv or unit.campLv == 0) then
    unit.campLv = summoner.campLv
  end
end

Engine.summonUnit = summonUnit

local function onNpcDie(self, npc)
  local list = self.npc_list
  for i, u in pairs(list) do
    if u == npc then
      table.remove(self.npc_list, i)
      break
    end
  end
end

Engine.onNpcDie = onNpcDie

local function onUnitDie(self, unit, killer_unit, sureKMPR)
  if self.battleDataCollect then
    self.battleDataCollect:handleUnitDieEventOnce(unit, killer_unit)
  end
  if killer_unit and killer_unit.what == "petUnit" then
    killer_unit = killer_unit.owner
  end
  local list = self.alive_units[unit.camp]
  for i, u in pairs(list) do
    if u == unit then
      table.remove(list, i)
      break
    end
  end
  list = self.alive_units[ed.emCampBoth]
  for i, u in pairs(list) do
    if u == unit then
      table.remove(list, i)
      break
    end
  end
  for i, u in pairs(self.unit_list) do
    if u == unit then
    else
      u:handleUnitDieEventToAll(unit, killer_unit)
    end
  end
  for i, u in pairs(self.FieldNpc_list) do
    if u == unit then
    else
      u:handleUnitDieEventToAll(unit, killer_unit)
    end
  end
  if not unit.config.is_summoned then
    unit.die_tick = self.ticks
    table.insert(self.die_units, unit)
  end
  if not self.autoChessMode then
    if killer_unit and killer_unit:isHero() and not unit.config.is_summoned then
      local addMP = sureKMPR and 150 or 300
      if killer_unit.what == "lordUnit" then
        sureKMPR = true
        addMP = 150
      end
      if ed.engine.rogue_mode then
        local revelation8buff = false
        for i, buff in ipairs(killer_unit.buff_list) do
          if buff.info.ID == 60008000 then
            revelation8buff = true
            break
          end
        end
        if revelation8buff and ed.engine.rogueSkillMgr:getBless(8102) and killer_unit.camp == 1 then
          local bless8102 = ed.engine.rogueSkillMgr.rogueBlessList[8102]
          killer_unit:takeHeal(bless8102.info["Script Arg1"], "mp", killer_unit)
        end
        if ed.engine.rogueSkillMgr:getBless(8101) and killer_unit.camp == 1 then
          local bless8101 = ed.engine.rogueSkillMgr.rogueBlessList[8101]
          local addrevelationenergy = bless8101.info["Script Arg1"]
          local revelation = ed.engine.rogueSkillMgr:getRogueRevelation()
          if revelation.destinyId == 8 then
            revelation:addEnergy(addrevelationenergy)
          end
        end
      end
      killer_unit:setMP(killer_unit.mp + addMP)
      if killer_unit.actor then
        local killstring = sureKMPR and "kill_half" or "kill"
        local color = killer_unit.camp == ed.emCampPlayer and "blue" or "red"
        ed.PopupCreate(killstring, color, killer_unit.actor, nil, "text")
      end
    end
    if killer_unit and killer_unit.config.is_summoned and not unit.config.is_summoned then
      local summoner = killer_unit.config.summoner
      local addMP = 150
      if summoner and not summoner.config.is_boss then
        summoner:setMP(summoner.mp + addMP)
      end
      if summoner.actor then
        local killstring = "kill_half"
        local color = summoner.camp == ed.emCampPlayer and "blue" or "red"
        ed.PopupCreate(killstring, color, summoner.actor, nil, "text")
      end
    end
  end
  if unit.camp == ed.emCampPlayer then
    self.alive_alliance_count = self.alive_alliance_count - 1
    self.dead_alliance_count = self.dead_alliance_count + 1
  elseif unit.camp == ed.emCampEnemy then
    self.alive_enemy_count = self.alive_enemy_count - 1
    self.dead_enemy_count = self.dead_enemy_count + 1
    if ed.run_with_scene then
      local waveid = self.nightmareMode and unit.wave_idx or self.wave_id
      ed.scene:showMonsterLoots(waveid, unit)
    end
  end
  if killer_unit and not unit.config.is_summoned then
    killer_unit.battledata:addKilled(unit.tid)
  end
  if ed.run_with_scene then
    FireEvent("UnitDie", unit, killer_unit)
    ListenTimer(Timer:Once(1), function()
      FireEvent("UnitDieDelay", unit, killer_unit)
    end)
  end
  if self.firstEnemyDie == false and unit.camp == ed.emCampEnemy and self.timeLimitMode then
    self.firstEnemyDie = true
    self.time_limit = self.left_time or 10
  end
end

Engine.onUnitDie = onUnitDie

local function doFailed(self, param)
  if not ed.scene.scene then
    return
  end
  local id = ed.playEffect(ed.sound.battle.lose)
  param.isTowerWarsMode = self:isTowerWarsMode()
  param.isMythMode = self.myth_mode ~= nil
  ed.audioParam.effects.battleResult = id
  ed.scene.scene:runAction(CCSequence:create(ccArrayMake(unpack({
    CCDelayTime:create(2.5),
    CCCallFunc:create(function()
      ed.ui.stageaccount.initialize(param)
    end)
  }))))
end

Engine.doFailed = doFailed

local function getTeamMercenaryInfo(self)
  if not self.unit_list then
    return
  end
  local mercenartInfo
  for i, unit in ipairs(self.unit_list) do
    if unit.camp == ed.emCampPlayer and unit:getMercenaryData() then
      mercenartInfo = {}
      mercenartInfo.index = i
      mercenartInfo.data = unit:getMercenaryData()
      break
    end
  end
  return mercenartInfo
end

Engine.getTeamMercenaryInfo = getTeamMercenaryInfo

local function getMercenaryNum(self)
  local num = 0
  for i, unit in ipairs(self.unit_list) do
    if unit.camp == ed.emCampPlayer and unit:isMercenary() == true then
      num = num + 1
    end
  end
  return num
end

Engine.getMercenaryNum = getMercenaryNum

function Engine:getSelfHeroIdList()
  local mercenaryInfo = getTeamMercenaryInfo(self)
  if mercenaryInfo then
    local heros = ed.copyTable(self.hero_id_list)
    heros[mercenaryInfo.index] = nil
    return heros
  else
    return self.hero_id_list
  end
end

local function getChapterName(stage)
  local st = ed.getDataTable("Stage")
  local chapterId = st[stage]["Chapter ID"]
  local ct = ed.getDataTable("Chapter")
  local ctNmae = ct[chapterId]["Chapter Name"]
  return ctNmae
end

local function heroTaskCanSweep(self, stage, stars)
  local ctNmae = getChapterName(stage)
  local herostage, hid, aloneMsg
  if ed.isHeroTaskStage(self, stage) then
    herostage, hid, aloneMsg = ed.isHeroTaskStage(self, stage)
  end
  if herostage then
    return ed.stageType(stage) == "act" and (ctNmae == T("\232\175\149\231\187\131\229\156\186") or ctNmae == T("\233\162\132\232\168\128\228\185\139\230\177\160")) and withBattleHero(self, hid) and stars == 3
  end
end

local function checkHeroTaskSweep(self, stage, stars)
  local cansweep = heroTaskCanSweep(self, stage, stars)
  return cansweep
end

local function downExit(self, result)
  if self.ancients_mode or self.throne_tower_mode or self.chaos_tower_mode or self.stage_type == "dreamland" or self.stage_type == "monsterseal" or self.autoChessMode or self.hadesMode then
    return
  end
  
  local function handler(isKnown, bestRankReward, bestWave, exp)
    if not self then
      return
    end
    if tolua.isnull(ed.scene.scene) then
      return
    end
    local heroList = ed.engine.hero_id_list
    if ed.engine.multistageTeamwork_mode then
      heroList = {}
    end
    local stage = self.stage_info["Stage ID"]
    if isKnown then
      if result == 0 then
        local type = ed.stageType(stage)
        local s = ed.elite2NormalStage(stage)
        if type == "elite" then
          ed.player:addStageLimit(s)
        end
        if type == "act" then
          local sg = self.stage_info["Stage Group"]
          ed.player:addActTimes(sg)
          ed.player:refreshActResetTime(sg)
        end
        local final_stars = math.max(1, self.result_stars - getMercenaryNum(self))
        if self:isTowerWarsMode() then
        end
        if self.arena_mode then
          self.mode = "pvp"
          ed.player:takePVPReward(self.hero_list)
        else
          ed.player:takeStageReward(stage, final_stars, self.hero_list, ed.player:getStageLoots())
        end
        if pveMode(self) == true then
          local vit = self.stage_info["Vit Return"]
          ed.player:addVitality(-vit)
        end
        local id = ed.playEffect(ed.sound.battle.win)
        ed.audioParam.effects.battleResult = id
        local stars = pveMode(self) and final_stars or {}
        local cansweep = checkHeroTaskSweep(self, stage, stars)
        if cansweep then
          ed.player:insertHeroTaskSweepStage(stage)
        end
        local herostage, hid, aloneMsg = ed.isHeroTaskStage(self, stage, "superawake")
        if herostage and withBattleHero(self, hid) and stars == 3 then
          ed.player:insertSuperHeroTaskSweepStage(stage)
        end
        local args = {
          isArenaMode = self.arena_mode,
          isShareFight = self.share_fight,
          isTbcMode = self.crusade_mode,
          stage_id = stage,
          victory = true,
          heroes = heroList,
          stars = stars,
          loots = ed.player:getStageLoots(),
          replayMode = self.replayMode,
          bestRankReward = bestRankReward,
          mercenaryInfo = getTeamMercenaryInfo(self),
          isPveMode = pveMode(self),
          canSweep = cansweep,
          bestWave = bestWave,
          nightmareExp = exp,
          nightmareWave = self.currentEnemyWaveIndex,
          isTowerWarsMode = self:isTowerWarsMode(),
          isFootHold = self.pvpIsFootHold,
          noExp = self.assassinateMode or self.share_fight or self.awakeStageMode,
          assassinateMode = self.assassinateMode,
          isCrusadeMode = self.crusade_mode,
          isMythMode = self.myth_mode
        }
        ed.scene.scene:runAction(ed.readaction.create({
          t = "seq",
          CCDelayTime:create(3.6),
          CCCallFunc:create(function()
            ed.ui.stageaccount.initialize(args)
          end)
        }))
      elseif result == 1 then
        local args = {
          isArenaMode = self.arena_mode,
          isShareFight = self.share_fight,
          isTbcMode = self.crusade_mode,
          stage_id = stage,
          victory = false,
          heroes = heroList,
          loseType = "fail",
          bestRankReward = bestRankReward,
          ancients_mode = self.ancients_mode,
          isPveMode = pveMode(self),
          isTowerWarsMode = self:isTowerWarsMode(),
          assassinateMode = self.assassinateMode
        }
        self:doFailed(args)
        ed.player:takeStageFailExp(stage)
      elseif result == 3 then
        self:doFailed({
          isArenaMode = self.arena_mode,
          isShareFight = self.share_fight,
          isTbcMode = self.crusade_mode,
          bestRankReward = bestRankReward,
          stage_id = stage,
          victory = false,
          heroes = heroList,
          loseType = "timeout",
          isPveMode = pveMode(self)
        })
        ed.player:takeStageFailExp(stage)
      end
    else
      local args = {
        isArenaMode = self.arena_mode,
        isShareFight = self.share_fight,
        isTbcMode = self.crusade_mode,
        stage_id = stage,
        victory = false,
        heroes = heroList,
        loseType = "fail",
        ancients_mode = self.ancients_mode,
        isPveMode = pveMode(self)
      }
      self:doFailed(args)
      ed.player:takeStageFailExp(stage)
    end
  end
  
  return handler
end

Engine.downExit = downExit

local function onBattleEnd(self)
  local newlist = {}
  for i, unit in ipairs(self.unit_list) do
    if unit.config.is_summoned then
      local summoner = unit.config.summoner
      if summoner and unit ~= summoner then
        summoner.battledata:addDamage(unit.battledata:getDamage())
        summoner.battledata:addBearDamage(unit.battledata.beardmg)
        summoner.battledata:addHeal(unit.battledata.heal)
        for _, killed in ipairs(unit.battledata.killlist) do
          summoner.battledata:addKilled(killed)
        end
      end
    else
      if unit.pet then
        local actor = unit.pet.actor
        local is = actor and actor.node:setVisible(false)
      end
      unit:removeAllBuffs()
      if unit.config.is_summoned then
        local summoner = unit.config.summoner
        if summoner and unit ~= summoner then
          summoner.battledata:addDamage(unit.battledata:getDamage())
          summoner.battledata:addBearDamage(unit.battledata.beardmg)
          summoner.battledata:addHeal(unit.battledata.heal)
          for _, killed in ipairs(unit.battledata.killlist) do
            summoner.battledata:addKilled(killed)
          end
        end
      else
        table.insert(newlist, unit)
      end
    end
    for i, unit in ipairs(self.unit_list) do
      if unit.actor and unit.actor.puppet then
        unit.actor.puppet:interruptSound()
      end
    end
  end
  self.unit_list = newlist
  if ed.run_with_scene then
    ed.scene:ClearFVTimeZone()
    ed.sceneui:removeAllBall()
  end
end

Engine.onBattleEnd = onBattleEnd

local function fillEnemyHpInfo(self, stageId, waveId)
  local hpTable = {}
  local battle_info = ed.lookupDataTable("Battle", nil, stageId, waveId)
  for i = 1, 5 do
    local id = battle_info["Monster " .. i .. " ID"]
    if id and 0 < id then
      table.insert(hpTable, 10000)
    else
      table.insert(hpTable, 0)
    end
  end
  return hpTable
end

Engine.fillEnemyHpInfo = fillEnemyHpInfo

local function getEenemyConsumePercent(self)
  local percent = 0
  local sumHp = 0
  local sumTotalHp = 0
  local sumDpsHp = 0
  for i, unit in ipairs(self.unit_list) do
    if unit.config.is_summoned ~= true and unit.camp == ed.emCampEnemy and unit.monster_idx then
      sumHp = sumHp + unit.hp
      sumTotalHp = sumTotalHp + unit.attribs.HP
    end
  end
  if 0 ~= sumTotalHp then
    percent = 1 - sumHp / sumTotalHp
  end
  sumDpsHp = sumTotalHp - sumHp
  return percent, sumDpsHp, {sumHp, sumTotalHp}
end

Engine.getEenemyConsumePercent = getEenemyConsumePercent

local function getEnemyFinalHpInfo(self)
  local enemyHpInfo = {}
  for i, unit in ipairs(self.unit_list) do
    if unit.config.is_summoned ~= true and unit.camp == ed.emCampEnemy and unit.monster_idx then
      enemyHpInfo[unit.monster_idx] = {
        HP = unit.hp,
        SumHP = unit.attribs.HP
      }
    end
  end
  for i = 1, 5 do
    if enemyHpInfo[i] == nil then
      enemyHpInfo[i] = {HP = 0, SumHP = 0}
    end
  end
  return enemyHpInfo
end

Engine.getEnemyFinalHpInfo = getEnemyFinalHpInfo

local function getEnemyTotalHp(self)
  local sumTotalHp = 0
  for i, unit in ipairs(self.unit_list) do
    if unit.config.is_summoned ~= true and unit.camp == ed.emCampEnemy and unit.monster_idx then
      sumTotalHp = sumTotalHp + unit.attribs.HP
    end
  end
  return sumTotalHp
end

Engine.getEnemyTotalHp = getEnemyTotalHp

function Engine:getBattleResult()
  local selfHeros = {}
  local enemyHeros = {}
  local bMercenary = {}
  for i, unit in pairs(self.unit_list) do
    if unit.config.is_summoned then
    else
      local hero = {}
      hero._heroid = unit.tid
      hero._hp_perc = math.ceil(unit.hp / unit.attribs.HP * 10000)
      if unit.attribs.MP == 0 then
        hero._mp_perc = 0
      else
        hero._mp_perc = math.ceil(unit.mp / unit.attribs.MP * 10000)
      end
      hero._custom_data = unit.custom_data
      if unit.camp == ed.emCampEnemy then
        if unit.index_in_team then
          enemyHeros[unit.index_in_team] = hero
        else
          table.insert(enemyHeros, hero)
        end
      elseif unit.camp == ed.emCampPlayer then
        table.insert(selfHeros, hero)
        table.insert(bMercenary, unit:isMercenary())
      end
    end
  end
  return selfHeros, enemyHeros, bMercenary
end

local function getHeroBattleData(self)
  local selfHeros = {}
  local enemyHeros = {}
  for i, unit in pairs(self.unit_list) do
    if unit.config.is_summoned then
    else
      local hero = {}
      hero._heroid = unit.tid
      hero._damage = unit.battledata:getDamage()
      hero._kill = unit.battledata:getKillNum()
      if unit.proto then
        local proto = unit.proto
        hero._legend_equip = proto._legend_equip
      end
      if unit.camp == ed.emCampEnemy then
        table.insert(enemyHeros, hero)
      elseif unit.camp == ed.emCampPlayer then
        table.insert(selfHeros, hero)
      end
    end
  end
  return selfHeros, enemyHeros
end

Engine.getHeroBattleData = getHeroBattleData

local function getHeroPvPBattleData(self)
  local herosData = {}
  for i, unit in pairs(self.unit_list) do
    if unit.config.is_summoned then
    else
      local hero = {}
      hero._tid = unit.tid
      hero._damage = math.floor(unit.battledata:getDamage())
      hero._kill = unit.battledata:getKillNum()
      hero._healing = unit.battledata:getTakeHeal()
      hero._suffer_damage = math.floor(unit.battledata:getBearDamage())
      hero._level = unit.level
      hero._stars = unit.stars
      hero._rank = unit.rank
      hero._hp = unit.hp
      hero._camp = unit.camp
      hero._fashion_id = unit.fashion_id
      local proto = unit.proto
      if unit.proto then
        hero._proto_rank = unit.proto._rank
        if unit.proto._shard then
          hero._shard_id = unit.proto._shard._id
        end
        hero._legend_equip = proto._legend_equip
      end
      if proto._pet then
        local petSummary = {}
        petSummary._id = proto._pet._id
        petSummary._type_id = proto._pet._type_id
        hero._pet = petSummary
      end
      table.insert(herosData, hero)
    end
  end
  return herosData
end

Engine.getHeroPvPBattleData = getHeroPvPBattleData

local function applyCrusadeResult(selfHero, mercenay)
  if nil == selfHero then
    return
  end
  for i, v in ipairs(selfHero) do
    local hero
    if mercenay[i] == true then
      hero = ed.GuildManager.crusadeMercenary
    else
      hero = ed.player:getHero(v._heroid)
    end
    if hero then
      hero.crusadeData = {}
      hero.crusadeData._hp_perc = v._hp_perc
      hero.crusadeData._mp_perc = v._mp_perc
      hero.crusadeData._custom_data = v._custom_data
    end
  end
end

local function getExitMsg(self, result)
  local msg
  local msgName = ""
  if self.arena_mode then
    msg = ed.upmsg.ladder()
    msg._end_battle = {}
    msg._end_battle._result = result
    msgName = "ladder"
  elseif self.crusade_mode then
    local selfHero, enemyHero, mercenay = self:getBattleResult()
    if result ~= 2 then
      applyCrusadeResult(selfHero, mercenay)
    end
    msg = ed.upmsg.tbc()
    msg._end_bat = {}
    msg._end_bat._result = result
    msg._end_bat._self_heroes = selfHero
    msg._end_bat._oppo_heroes = enemyHero
    msg._end_bat._oprations = self:getOprationList()
    msg._end_bat._energy_bean = self.useEnergyBeanNumber
    msgName = "tbc"
    ed.battleshare.getBattleData({
      result = result,
      oppo_heroes = enemyHero,
      oprations = self:getOprationList(),
      msgName = 1
    })
  elseif self.guildInstance_mode then
    local enemyHp = self:getEnemyHpInfo()
    msg = ed.upmsg.guild_raid_req()
    msg._end_battle = {}
    msg._end_battle._operations = self:getOprationList()
    msg._end_battle._battle_result = result
    msg._end_battle._wave = self.wave_id
    msg._end_battle._hp_list = enemyHp
    msg._end_battle._stage_progress = getStageProgress(self)
    msg._end_battle._damage = math.floor(self:getPlayerTotalDamage(ed.emCampPlayer))
    msgName = "guild_raid"
  elseif self.stage_type == "dreamland" then
    msg = ed.upmsg.dreamland()
    msg._end_battle = ed.upmsg.dreamland_end_battle()
    msg._end_battle._result = result
    msg._end_battle._damage = math.floor(ed.engine:getPlayerTotalDamage(ed.emCampPlayer))
    ed.dreamland.dreamland_object:SetCurrentDamage(msg._end_battle._damage)
    msg._end_battle._operations = self:getOprationList()
    msgName = "dreamland"
  else
    msg = ed.upmsg.exit_stage()
    msg._result = result
    if 0 == result then
      msg._heroes = self.hero_id_list
      msg._stars = self.result_stars
      msg._oprations = self:getOprationList()
      local selfHero = self:getBattleResult()
      local hp_info = {}
      for i, v in ipairs(selfHero) do
        hp_info[i] = v._hp_perc
      end
      msg._self_data = hp_info
    end
    if self.heroTaskHid ~= -1 then
      msg._unit_battle_data = {
        {}
      }
      msg._unit_battle_data[1]._unit_hid = self.heroTaskHid
      msg._unit_battle_data[1]._unit_max_damage = self:getSpecificHeroDamage()
      msg._unit_battle_data[1]._unit_kill_list = self:getScecificHeroKillList()
    else
      msg._unit_battle_data = {}
    end
    if EDFLAGUNITY then
      msg._is_manual_battle = self:manualBtMode() and true or false
    else
      msg._is_manual_battle = self:manualBtMode() and 1 or 0
    end
    msgName = "exit_stage"
  end
  return msg, msgName
end

local function printStatistics(self)
  print("==========================================")
  local unitDamage = {}
  local maxdmg = 0
  local maxlen = 0
  for i, unit in ipairs(self.unit_list) do
    maxdmg = math.max(maxdmg, unit.battledata:getDamage())
    maxlen = math.max(maxlen, #unit.name)
  end
  print("                   damage")
  for i, unit in ipairs(self.unit_list) do
    local ratio = 0
    if 0 < maxdmg then
      ratio = math.floor(unit.battledata:getDamage() / maxdmg * 20)
    end
    print(table.concat({
      unit.camp == 1 and "[+]" or "[-]",
      unit.name,
      string.rep(" ", maxlen - #unit.name + 1),
      string.rep("#", ratio),
      string.rep(" ", 21 - ratio),
      math.floor(unit.battledata:getDamage())
    }))
    if unit.camp == 1 then
      unitDamage[unit.tid] = unit.battledata:getDamage()
    end
  end
  print("==========================================")
  if self.multiplayerMode then
    ed.dreamland.Dreamland:setUnitDamage(unitDamage)
  end
end

Engine.printStatistics = printStatistics

local function getPlayerTotalDamage(self, camp)
  local damage = 0
  for i, unit in ipairs(self.unit_list) do
    if unit.camp == camp then
      damage = damage + unit.battledata:getDamage()
    end
  end
  return damage
end

Engine.getPlayerTotalDamage = getPlayerTotalDamage

local function getStars(self, camp)
  self:judgeStars()
  return self.stars
end

Engine.getStars = getStars

local function getSpecificHeroDamage(self, hid)
  local damage = 0
  if hid == nil and self.heroTaskHid ~= -1 then
    hid = self.heroTaskHid
  end
  for i, unit in ipairs(self.unit_list) do
    if unit.tid == hid then
      damage = unit.battledata:getDamage()
    end
  end
  return math.floor(damage)
end

Engine.getSpecificHeroDamage = getSpecificHeroDamage

local function getScecificHeroKillList(self, hid)
  local killlist = {}
  if hid == nil and self.heroTaskHid ~= -1 then
    hid = self.heroTaskHid
  end
  for i, unit in ipairs(self.unit_list) do
    if unit.tid == hid then
      return unit.battledata.killlist
    end
  end
  return killlist
end

Engine.getScecificHeroKillList = getScecificHeroKillList

local function isEnemyAlive(self, hid)
  for _, unit in pairs(self.unit_list) do
    if unit.camp == ed.emCampEnemy and unit.tid == hid and not unit:isAlive() then
      return false
    end
  end
  return true
end

Engine.isEnemyAlive = isEnemyAlive

local function saveBattleLog(self, checkId)
  if do_battle_log and not EDFLAGSVR then
    self.battleLog = getBtlog()
    if ed.debug_mode then
      local folder = CCFileUtils:sharedFileUtils():getWritablePath()
      local path = string.format("%s/%s.log", folder, os.date("%Y-%m-%d %H-%M-%S"))
      if checkId then
        path = string.format("%s/%s_%s.log", folder, os.date("%Y-%m-%d %H-%M-%S"), checkId)
      end
      local file = io.open(path, "w")
      if file then
        file:write(self.battleLog)
        file:close()
      end
    end
  end
end

Engine.saveBattleLog = saveBattleLog

local function doTimeOut(self)
  local stage = self.stage_info["Stage ID"]
  self:doFailed({
    stage_id = stage,
    victory = false,
    heroes = self.hero_id_list,
    loseType = "timeout",
    isPveMode = pveMode(self)
  })
  ed.player:takeStageFailExp(stage)
end

function Engine:getDeadCount(camp)
  local deathcount = 0
  for i, unit in ipairs(self.unit_list) do
    if unit.camp == camp and unit:isHero() and unit.config.is_summoned ~= true and not unit:isAlive() then
      deathcount = deathcount + 1
    end
  end
  return deathcount
end

local function getBattleCheckResult(self, result)
  local args = {}
  args.result = result
  args.selfHeroHpMp, args.enemyHeroHpMp = self:getBattleResult()
  args.selfDamage = math.floor(self:getPlayerTotalDamage(ed.emCampPlayer))
  args.targetDamage = math.floor(self:getPlayerTotalDamage(ed.emCampEnemy))
  args.operations = self:getOprationList()
  return args
end

Engine.getBattleCheckResult = getBattleCheckResult

function Engine:shouldAddTimeOutUI()
  return self.guildInstance_mode or self.stage_type == "dreamland" or self.fancyTowerMode or self.activityAdventureMode or self.fancyAbyssMode or self.awakeStageMode or self.guildMountBossMode
end

function Engine:judgeStars()
  local triggerTb = ed.getDataTable("FancyTowerStarTrigger")
  local triggers = {
    self.trigger1,
    self.trigger2,
    self.trigger3
  }
  self.star = {
    false,
    false,
    false
  }
  self.stars = 0
  local unit = ed.getDataTable("Unit")
  local front, mid, back, str, agi, int = 0, 0, 0, 0, 0, 0
  for k, heroid in ipairs(self.hero_id_list or {}) do
    local pos = unit[heroid]["Position Type"]
    local type = unit[heroid]["Hero Type"]
    if pos == T("\229\137\141\230\142\146") then
      front = front + 1
    elseif pos == T("\228\184\173\230\142\146") then
      mid = mid + 1
    elseif pos == T("\229\144\142\230\142\146") then
      back = back + 1
    end
    if type == T("\229\138\155\233\135\143") then
      str = str + 1
    elseif type == T("\230\149\143\230\141\183") then
      agi = agi + 1
    elseif type == T("\230\153\186\229\138\155") then
      int = int + 1
    end
  end
  for i = 1, 3 do
    if triggers[i] then
      local triggerTypeId = triggers[i][1]
      local triggerParam = triggers[i][2]
      local isOk = false
      if triggerTb[triggerTypeId]["Trigger Type"] == "FinishTime" then
        if triggerParam >= ed.engine.ticks * ed.tick_interval then
          isOk = true
        end
      elseif triggerTb[triggerTypeId]["Trigger Type"] == "NoHeroDefeat" then
        if 1 > self.death_count then
          isOk = true
        end
      elseif triggerTb[triggerTypeId]["Trigger Type"] == "HeroDefeatMost" then
        if triggerParam >= self.death_count then
          isOk = true
        end
      elseif triggerTb[triggerTypeId]["Trigger Type"] == "AtLeastFrontRow" then
        if front >= triggerParam then
          isOk = true
        end
      elseif triggerTb[triggerTypeId]["Trigger Type"] == "AtLeastMiddleRow" then
        if mid >= triggerParam then
          isOk = true
        end
      elseif triggerTb[triggerTypeId]["Trigger Type"] == "AtLeastBackRow" then
        if back >= triggerParam then
          isOk = true
        end
      elseif triggerTb[triggerTypeId]["Trigger Type"] == "AtLeastStr" then
        if str >= triggerParam then
          isOk = true
        end
      elseif triggerTb[triggerTypeId]["Trigger Type"] == "AtLeastAgi" then
        if agi >= triggerParam then
          isOk = true
        end
      elseif triggerTb[triggerTypeId]["Trigger Type"] == "AtLeastInt" and int >= triggerParam then
        isOk = true
      end
      if isOk then
        self.star[i] = isOk
        self.stars = self.stars + 1
      end
    end
  end
end

function Engine:compareHarm()
  local selfDamage = self:getPlayerTotalDamage(ed.emCampPlayer)
  local targetDamage = self:getPlayerTotalDamage(ed.emCampEnemy)
  return selfDamage >= targetDamage and 0 or 1
end

function Engine:getWcaResult(result)
  local selfHero, enemyHero = self:getBattleResult()
  if result == 3 then
    local selfDeadCount = self:getDeadCount(ed.emCampPlayer)
    local targetDeadCount = self:getDeadCount(ed.emCampEnemy)
    if #selfHero - selfDeadCount > #enemyHero - targetDeadCount then
      return 0, "alive", selfHero, enemyHero
    elseif #selfHero - selfDeadCount < #enemyHero - targetDeadCount then
      return 1, "alive", selfHero, enemyHero
    end
    return self:compareHarm(), "damage", selfHero, enemyHero
  elseif result == 0 and self.alive_alliance_count == 0 then
    local result = self:compareHarm()
    return result, "damage", selfHero, enemyHero
  end
  return result, nil, selfHero, enemyHero
end

function Engine:shouldGetWcaResult()
  if self.wca_mode then
    return true
  end
  if self.cupArena_mode and 7 == self.battleBOType then
    return true
  end
  return self.guildClash_mode
end

function Engine:getRogueBattleResult(result)
  local sheepDead = 0
  local goldSheepDead = 0
  local enemyAlive = 0
  for _, unit in ipairs(self.unit_list) do
    local name = unit.name or ""
    local isAlive = unit:isAlive()
    local camp = unit.camp
    local sheepType = string.match(name, "^Rogue(%w*)Sheep$")
    if camp == ed.emCampEnemy then
      if sheepType then
        if sheepType == "" and not isAlive then
          sheepDead = sheepDead + 1
        elseif sheepType == "Golden" and not isAlive then
          goldSheepDead = goldSheepDead + 1
        end
      elseif isAlive then
        enemyAlive = enemyAlive + 1
      end
    end
  end
  if result == 3 then
    if 0 < enemyAlive then
      result = 1
    else
      result = 0
    end
  end
  return result, sheepDead, goldSheepDead
end

local function exitStage(self, result, exitFlag)
  self.beingEnd = false
  self.running = false
  self.enabled = false
  self.stage_ended = true
  if self:shouldGetWcaResult() then
    self.battleResult = self:getWcaResult(result)
  elseif self.rogue_mode then
    self.battleResult = self:getRogueBattleResult(result)
  else
    self.battleResult = result
  end
  if do_battle_log then
    btlog(tostring(self))
    btlog("-----------------------------------------------------------------")
    btlog(ed.tabletostring(ed.engine.operation_list))
  end
  if ed.run_with_scene then
    for i, unit in ipairs(self.unit_list) do
      if unit.actor and unit.actor.puppet then
        unit.actor.puppet:interruptSound()
      end
    end
    self:printStatistics()
    ed.stopMusic()
    ed.scene:resetDamageStep()
    ed.scene.running = false
    if self.gmMode then
      doTimeOut(self)
      return
    end
    ed.scene:saveFrameRecords()
    saveBattleLog(self)
    if self.custom_mode then
      return
    end
    if self.stage_info.isHeroTryUseMode and result ~= 2 then
      FireEvent("TryUseHeroEnd")
      return
    end
    if self.replayMode == true then
      self.replayMode = nil
      if exitFlag ~= true then
        ListenTimer(Timer:Once(2), function()
          if self.multiarena_mode then
            ed.popScene()
          else
            ed.ui.vcdLayer.create()
            ed.playMusic(ed.music.map)
          end
          print("exit replay mode!")
        end)
      end
      return
    end
    if self.videoplayer_mode and ed.videoplayer.battleEnd then
      ListenTimer(Timer:Once(2), function()
        ed.videoplayer.battleEnd:show()
        ed.playMusic(ed.music.map)
      end)
      return
    end
    if self.battle_check_arena_mode or self.battle_check_stage_mode then
      if result == 2 then
        return
      end
      FireEvent("BattleCheckEnd", getBattleCheckResult(self, result))
      return
    end
    if self.wca_mode then
      FireEvent("RealPVPBattleEnd", self:getWcaResult(result))
      return
    end
    if self.crusade_mode and self.energyBean_mode and result ~= 2 then
      ed.player:setEnergyBeanNum(ed.player:getEnergyBeanNum() - self.useEnergyBeanNumber)
    end
    if self.hadesMode then
      local battlePrepareInfo = ed.hadesHeatMgr:getInstance():getBattlePrepareInfo()
      local groupId = battlePrepareInfo.groupId
      local battleTime = math.ceil(ed.tick_interval * self.ticks)
      local chooseHeat, totalHeat = ed.engine:getChooseHeat()
      ed.hadesHeatNet.sendExitStage(groupId, result, self:getOprationList(), battleTime, chooseHeat, totalHeat)
      return
    end
    if self.rogue_mode then
      local selfHero, enemyHero = self:getBattleResult()
      local revelation = self.rogueSkillMgr:getRogueRevelation()
      ed.rogueLikeNet.sendEndBattle(self.battleResult, self:getOprationList(), selfHero, revelation.energy * 10000)
      return
    end
    if self.autoChessMode then
      return
    end
    if self.crevicedefend_mode and not ed.CreviceDefendBattleManager.forceQuitBattle then
      ListenTimer(Timer:Once(3), function()
        if ed.getCurrentScene().identity == "battle" then
          ed.popScene()
        end
        FireEvent("EventCreviceDefendPlayNextBattle")
      end)
      return
    end
    if result == 0 then
      FireEvent("BattleEnding", self.stage_info["Stage ID"], "success")
      ed.netreply.exitStageReply = self:downExit(result)
      ed.sceneui:autoCollectLoots(2.8)
    elseif result == 1 then
      FireEvent("BattleEnding", self.stage_info["Stage ID"], "failed")
      for unit in self:foreachAliveUnit(ed.emCampEnemy) do
        if unit.actor then
          unit.actor:waitAfterBattle()
        end
      end
      ed.netreply.exitStageReply = self:downExit(result)
    elseif result == 2 then
      ed.playMusic(ed.music.map)
      if self.myth_mode then
        ListenTimer(Timer:Once(0.1), function()
          FireEvent("EventSecretAreaStageEnd", self.stage_info["Stage ID"])
        end)
      end
      if self.stage_type == "dreamland" and not self.mythBossMode then
        ed.dreamland.dreamland_object:MinusChance()
        return
      end
    elseif result == 3 then
      if self.arena_mode then
        ed.netreply.exitStageReply = self:downExit(result)
      elseif self.crusade_mode then
        ListenTimer(Timer:Once(2), function()
          doTimeOut(self)
        end)
      elseif self:shouldAddTimeOutUI() then
        ed.sceneui:addTimeOutUI()
      else
        doTimeOut(self)
      end
    end
    if self.fancyTowerMode and ed.SkillTowerManager then
      self:judgeStars()
      ed.SkillTowerManager:requestTowerEndBattle(result, self.stars)
      return
    end
    if self.peakArena_mode then
      ListenTimer(Timer:Once(3), function()
        if ed.getCurrentScene().identity == "battle" then
          ed.popScene()
        end
        FireEvent("PeakArenaPlayNextBattle")
      end)
      return
    end
    if self.cupArena_mode then
      ListenTimer(Timer:Once(3), function()
        if ed.getCurrentScene().identity == "battle" then
          ed.popScene()
        end
        FireEvent("CupArenaPlayNextBattle")
      end)
      return
    end
    if self.fancyAbyssMode then
      ed.SkillTowerNetwork:sendExTowerEndBattle(result, ed.engine:getOprationList(), math.floor(ed.tick_interval * self.ticks))
      return
    end
    if self.activityAdventureMode and ed.actiAdventureMgr.getInstance() then
      ed.actiAdventureNet.exitStage(result, self:getOprationList())
      return
    end
    if self.share_fight then
      ed.pvpManager:exitShareFight(result)
      return
    end
    if self.awakeStageMode then
      local getStageProgress = self:getAwakeStageProgress(result)
      ed.AwakeDungeonNetwork.sendExitStage(result, self:getOprationList(), getStageProgress)
      return
    end
    if self.guildClash_mode then
      ed.GuildClashManager.IN_REPLAY = false
      FireEvent("GuildClashBattleEnd")
      ListenTimer(Timer:Once(2), function()
        if self.multiarena_mode then
          ed.popScene()
        else
          ed.ui.vcdLayer.create()
          ed.playMusic(ed.music.map)
        end
        print("exit replay mode!")
      end)
      return
    end
    if self.guildMountBossMode and ed.GuildMountManager then
      ed.GuildMountManager:requestBossEndBattle(result)
      return
    end
    local msg, msgName = getExitMsg(self, result)
    ed.netdata.exitStageReply = {
      stage = self.stage_info["Stage ID"],
      result = result
    }
    self.exitStageMSG = msg
    self.exitStageMsgName = msgName
    ed.send(msg, msgName)
  end
end

Engine.exitStage = exitStage

local function enterGmMode(self)
  self.gmMode = true
end

Engine.enterGmMode = enterGmMode

local function passWaves(self, skip)
  if skip then
    for i, unit in ipairs(self.unit_list) do
      if unit.config.is_summoned ~= true and unit.camp == ed.emCampEnemy and unit.monster_idx then
        unit.hp = 0
        unit:onDying(self.hero_list[0])
      end
    end
    self.time_limit = 0
  end
end

Engine.passWaves = passWaves

function Engine:isStealKill()
  local type = ed.getChallengeType(self.stage_info["Stage ID"])
  return type == "StealKill"
end

function Engine:isCompleteChallenge()
  local type = ed.getChallengeType(self.stage_info["Stage ID"])
  local heroId = ed.getChallengeHero(self.stage_info["Stage ID"])
  if type == "Guardian" then
    for unit in self:foreachAliveUnit(ed.emCampPlayer) do
      if unit.tid == heroId then
        return true
      end
    end
    return false
  elseif type == "StealKill" then
    local unit = self:getUnitByIdAndCamp(heroId, ed.emCampPlayer)
    if unit then
      local targetNum = ed.getChallengeParam(self.stage_info["Stage ID"], 6)
      local killNum = unit.battledata:getKillNum()
      return targetNum <= killNum
    end
  end
  return true
end

local function victory(self, skip)
  self.running = false
  local waves = self.stage_info.Waves
  if waves > self.wave_id and not skip then
    for unit in self:foreachAliveUnit(ed.emCampPlayer) do
      if unit.config.is_summoned then
        unit:die()
      end
    end
    self.beingEnd = false
    if ed.run_with_scene then
      ed.sceneui:showNextButton()
      for unit in self:foreachAliveUnit(ed.emCampPlayer) do
        if unit.actor then
          unit.actor:waitAfterBattle()
        end
      end
    else
      self:nextBattle()
    end
  else
    self.beingEnd = false
    if self:isCompleteChallenge() then
      self.death_count = self:getDeadCount(ed.emCampPlayer)
      self.result_stars = math.max(1, 3 - self.death_count)
      if self.crusade_mode then
        self:battleSupply()
      end
      self:exitStage(0)
      if ed.run_with_scene then
        self.stage_ended = true
        for unit in self:foreachAliveUnit(ed.emCampPlayer) do
          if unit.actor then
            unit.actor:cheer()
          end
        end
      end
    else
      self.result_stars = 0
      self:exitStage(1)
    end
  end
  if ed.run_with_scene then
    ed.scene.running = false
    for _, unit in pairs(self.unit_list) do
      if unit.camp == ed.emCampEnemy and unit.actor then
        unit.actor:onUnitDeath()
      end
    end
  end
end

Engine.victory = victory

local function defeat(self)
  if ed.run_with_scene and self.wca_mode then
    for unit in self:foreachAliveUnit(ed.emCampEnemy) do
      if unit.actor then
        unit.actor:cheer()
      end
    end
  end
end

Engine.defeat = defeat

local function foreachAliveUnit(self, camp)
  local list = {}
  if camp == ed.emCampBoth then
    list = self.alive_units[ed.emCampBoth]
  else
    local a = self.alive_units[ed.emCampBoth]
    for _, unit2 in ipairs(a) do
      if unit2.camp == camp or unit2.camp == 2 then
        table.insert(list, unit2)
      end
    end
  end
  local i = #list + 1
  return function()
    i = i - 1
    return list[i]
  end
end

Engine.foreachAliveUnit = foreachAliveUnit

local function setUnitFilter(self)
  self.unitFilter = {
    STR = function(unit)
      if unit.info["Main Attrib"] == "STR" then
        return true
      end
    end,
    AGI = function(unit)
      if unit.info["Main Attrib"] == "AGI" then
        return true
      end
    end,
    INT = function(unit)
      if unit.info["Main Attrib"] == "INT" then
        return true
      end
    end,
    FRONT = function(unit)
      local positionType = ed.getDataTable("Unit")[unit.tid]["Position Type"]
      return positionType == T("\229\137\141\230\142\146")
    end,
    MIDDLE = function(unit)
      local positionType = ed.getDataTable("Unit")[unit.tid]["Position Type"]
      return positionType == T("\228\184\173\230\142\146")
    end,
    BACK = function(unit)
      local positionType = ed.getDataTable("Unit")[unit.tid]["Position Type"]
      return positionType == T("\229\144\142\230\142\146")
    end,
    IS_SUMMONED = function(unit)
      return unit.config.is_summoned == true
    end,
    ALL = function(unit)
      return true
    end
  }
end

Engine.setUnitFilter = setUnitFilter

local function filterAliveUnit(self, camp, and_key_list, or_key_list, non_key_list)
  and_key_list = and_key_list or {}
  or_key_list = or_key_list or {}
  non_key_list = non_key_list or {}
  local list = {}
  if #and_key_list == 0 and #or_key_list == 0 then
    return {}
  end
  for unit in ed.engine:foreachAliveUnit(camp) do
    local andResult = true
    for _, filterKey in ipairs(and_key_list) do
      local filterFunc = self.unitFilter[filterKey]
      local result = filterFunc and filterFunc(unit) and true or false
      andResult = andResult and result
    end
    local orResult = true
    for _, filterKey in ipairs(or_key_list) do
      local filterFunc = self.unitFilter[filterKey]
      local result = filterFunc and filterFunc(unit) and true or false
      orResult = orResult or result
    end
    local nonResult = true
    for _, filterKey in ipairs(or_key_list) do
      local filterFunc = self.unitFilter[filterKey]
      local result = not (not filterFunc or filterFunc(unit)) and true or false
      nonResult = nonResult and result
    end
    if andResult and orResult and nonResult then
      table.insert(list, unit)
    end
  end
  return list
end

Engine.filterAliveUnit = filterAliveUnit

local function foreachNpc(self)
  local list = self.npc_list
  local i = #list + 1
  return function()
    i = i - 1
    return list[i]
  end
end

Engine.foreachNpc = foreachNpc

local function foreachEntity(self)
  local list_of_list = unit_list_names
  local i, j = 1, 1
  return function()
    repeat
      local list = self[list_of_list[i]]
      if list == nil then
        return nil
      end
      local ret = list[j]
      if j >= #list then
        i = i + 1
        j = 1
      else
        j = j + 1
      end
      if ret and not ret.terminated then
        return ret
      end
    until ret
  end
end

Engine.foreachEntity = foreachEntity

local function addProjectile(self, projectile)
  if projectile then
    projectile.previous_position = {
      projectile.position[1],
      projectile.position[2]
    }
    table.insert(self.projectile_list, projectile)
    if ed.run_with_scene then
      local actor = ed.ProjectileActorCreate(projectile)
      ed.scene:addActor(actor)
      projectile.actor = actor
    end
  end
end

Engine.addProjectile = addProjectile

local function createNpc(self, npcId, isFlipX, owner)
  local npc
  local npcInfo = ed.lookupDataTable("NPC", nil, npcId)
  if npcInfo then
    npcInfo.id = npcId
    npc = ed.NpcCreate(npcInfo, isFlipX, owner)
    table.insert(self.npc_list, npc)
  end
  return npc
end

Engine.createNpc = createNpc

local function addChain(self, chain)
  if chain then
    table.insert(self.projectile_list, chain)
  end
end

Engine.addChain = addChain

function Engine:addMagic(magic)
  if magic then
    table.insert(self.projectile_list, magic)
  end
end

function Engine:setTimeLimit(time)
  self.left_time = time
end

function Engine:addRegion(region)
  if region then
    table.insert(self.projectile_list, region)
    if ed.run_with_scene then
      local actor = ed.baseActorCreate(region)
      ed.scene:addActor(actor)
    end
  end
end

local function getUnitByIndex(self, index, camp)
  if self.alive_units[camp] then
    return self.alive_units[camp][index]
  end
end

Engine.getUnitByIndex = getUnitByIndex

local function getUnitNum(self, camp)
  if self.alive_units[camp] then
    return #self.alive_units[camp]
  end
  return 0
end

Engine.getUnitNum = getUnitNum

local function openDayandnightMode(self, structure)
  if self.dayandnightMode == true then
    return
  end
  if not structure then
    EDDebug("dayandnight structure can't be nil")
  end
  self.dayandnightMode = true
  self.dayandnightStructure = structure
  self.dayandnightState = {phase = 1, currentTime = 0}
end

Engine.openDayandnightMode = openDayandnightMode

local function changeDayandnightStructure(self, phase, time)
  if not self.dayandnightMode then
    return
  end
  local phaseTime = self.dayandnightStructure.times[phase]
  if 0 < phaseTime + time then
    self.dayandnightStructure.times[phase] = phaseTime + time
  end
end

Engine.changeDayandnightStructure = changeDayandnightStructure

local function updateDayandnightState(self, dt)
  if not self.dayandnightMode then
    return
  end
  local phase = self.dayandnightState.phase
  local currentTime = self.dayandnightState.currentTime
  local structure = self.dayandnightStructure
  self.dayandnightState.currentTime = currentTime + dt
  if currentTime >= structure.times[phase] and phase < #structure.phases then
    self:transformDayandnightState()
  end
end

Engine.updateDayandnightState = updateDayandnightState

local function transformDayandnightState(self)
  local current = self.dayandnightState
  local type = self.dayandnightStructure.states[current.phase]
  if type == "day" then
    type = "daytonight"
  else
    type = "nighttoday"
  end
  current.phase = current.phase + 1
  current.currentTime = 0
  for i, unit in ipairs(self.alive_units[ed.emCampBoth]) do
    unit:dayAndNightSwitchImpact(type)
  end
end

Engine.transformDayandnightState = transformDayandnightState

local function getDayandnightState(self)
  local phase = self.dayandnightState.phase
  local state = {}
  state.phase = phase
  state.time = self.dayandnightStructure.times[phase]
  state.state = self.dayandnightStructure.states[phase]
  state.currentTime = self.dayandnightState.currentTime
  return state
end

Engine.getDayandnightState = getDayandnightState

function Engine:getUnitByIdAndCamp(id, camp)
  for i, unit in ipairs(self.unit_list) do
    if unit.camp == ed.emCampPlayer and unit.tid == id then
      return unit
    end
  end
  return nil
end

function Engine:collectSkill(unit, skill, idx)
  for i, u in pairs(self.unit_list) do
    if u.collectSkill then
      u:collectSkill(unit, skill, idx)
    end
  end
  for i, u in pairs(self.FieldNpc_list) do
    if u.collectSkill then
      u:collectSkill(unit, skill, idx)
    end
  end
  if self.battleDataCollect then
    self.battleDataCollect:collectSkill(unit, skill, idx)
  end
end

function Engine:collectSkillStart(unit, skill, target)
  for i, u in pairs(self.unit_list) do
    if u.collectSkillStart then
      u:collectSkillStart(unit, skill, target)
    end
  end
  for i, u in pairs(self.FieldNpc_list) do
    if u.collectSkillStart then
      u:collectSkillStart(unit, skill, target)
    end
  end
  self:deliverBall(unit, skill)
  if self.battleDataCollect then
    self.battleDataCollect:collectSkillStart(unit, skill, target)
  end
end

function Engine:collectSkillHit(unit, skill, target)
  for i, u in pairs(self.unit_list) do
    if u.collectSkillHit then
      u:collectSkillHit(unit, skill, target)
    end
  end
  for i, u in pairs(self.FieldNpc_list) do
    if u.collectSkillHit then
      u:collectSkillHit(unit, skill, target)
    end
  end
  if self.battleDataCollect then
    self.battleDataCollect:collectSkillHit(unit, skill, target)
  end
end

function Engine:collectBuff(buff)
  for i, u in pairs(self.unit_list or {}) do
    if u.collectBuff then
      u:collectBuff(buff)
    end
  end
  for i, u in pairs(self.FieldNpc_list or {}) do
    if u.collectBuff then
      u:collectBuff(buff)
    end
  end
  if self.battleDataCollect then
    self.battleDataCollect:collectBuff(buff)
  end
end

function Engine:collectHPchange(config)
  for i, u in pairs(self.unit_list) do
    if u.collectHPchange then
      u:collectHPchange(config)
    end
  end
  for i, u in pairs(self.FieldNpc_list) do
    if u.collectHPchange then
      u:collectHPchange(config)
    end
  end
  if self.battleDataCollect then
    self.battleDataCollect:collectHPchange(config)
  end
end

function Engine:collectMPchange(config)
  for i, u in pairs(self.unit_list) do
    if u.collectMPchange then
      u:collectMPchange(config)
    end
  end
  for i, u in pairs(self.FieldNpc_list) do
    if u.collectMPchange then
      u:collectMPchange(config)
    end
  end
  if self.battleDataCollect then
    self.battleDataCollect:collectMPchange(config)
  end
end

function Engine:listerRemoveBuff(buff)
  for i, u in pairs(self.unit_list) do
    if u.listerRemoveBuff then
      u:listerRemoveBuff(buff)
    end
  end
  for i, u in pairs(self.FieldNpc_list) do
    if u.listerRemoveBuff then
      u:listerRemoveBuff(buff)
    end
  end
end

local function deliverBall(self, unit, skill)
  if self.playerKaelHero and unit.camp == ed.emCampPlayer then
    self.playerKaelHero:showBall(unit, skill)
  elseif self.enemyKaelHero and unit.camp == ed.emCampEnemy then
    self.enemyKaelHero:showBall(unit, skill)
  end
end

Engine.deliverBall = deliverBall

local function showReplay(data, mode, stage_id, extra_ui_info)
  if not data then
    return
  end
  data = ed.copyProto(data)
  mode = mode or "pvp"
  ed.ui.vcdLayer.setData(data, mode, stage_id, extra_ui_info)
  if data._bt_st then
    ed.startBattleTime = data._bt_st
  end
  local stageid, enemyid, enemy_list, enemy_dyna_list, enemy_is_robot
  if mode == "pvp" then
    stageid = -1
  elseif mode == "tbc" or mode == "peakArena" or mode == "cupArena" or mode == "dreamland" then
    stageid = stage_id
  elseif mode == "guildClash" then
    stageid = data._stageId or -32
  elseif mode == "real_pvp" then
    stageid = stage_id or -27
  end
  local stage = ed.lookupDataTable("Stage", nil, stageid)
  local battle = ed.lookupDataTable("Battle", nil, stageid, 1)
  local info = {
    userId = data._userid,
    userName = data._username,
    userAvatar = data._avatar,
    userMedal = data._self_medal or (data._self_user or {})._medal,
    vip = data._vip,
    oppoUserid = data._oppo_userid,
    oppoUserName = data._oppo_name,
    oppoUserAvatar = data._oppo_avatar,
    oppovip = data._oppo_vip,
    oppoMedal = data._oppo_medal or (data._oppo_user or {})._medal,
    winTimes = data._winTimes,
    checkid = data._checkid
  }
  if mode == "quest" then
    info.hide_board = true
  end
  ed.srand(data._rseed)
  local operations = data._operations
  local self_buffs, oppo_buffs
  local param = {
    hero_list = data._self_heroes,
    self_dyna_list = data._self_dynas or data._camp1_hero_dynas or nil,
    hero_is_bot = 0 < (data._self_robot or 0),
    enemy_list = enemy_list or data._oppo_heroes,
    enemy_dyna_list = enemy_dyna_list or data._oppo_dynas or data._camp2_hero_dynas or nil,
    enemy_is_bot = enemy_is_robot or 0 < (data._oppo_robot or 0),
    stage_id = stageid,
    operations = operations,
    mode = mode,
    self_buffs = self_buffs,
    oppo_buffs = oppo_buffs,
    ladder_buff_id = data._ladder_buff_id,
    trigger_buf = data._trigger_buf,
    selfBonus = data._self_bonus or nil,
    oppoBonus = data._oppo_bonus or nil,
    battleBonus = data._self_bonus or nil,
    winTimes = data._winTimes,
    seasonBuffIds = data._season_buff_key
  }
  ed.engine:enterRelay(param)
  local addition = {replayInfo = info, extra_ui_info = extra_ui_info}
  if data._background_id or ed.pvpManager.backgroundId then
    local homeGround = data._home_ground or 2
    if homeGround ~= 2 then
      local backgroundId = data._background_id or ed.pvpManager.backgroundId
      addition.oppoSummary = {
        _avatar = data._oppo_avatar,
        _name = data._oppo_name,
        _medal = data._oppo_medal
      }
      addition.homeGround = homeGround
      if backgroundId and backgroundId ~= 0 then
        battle = ed.copyTable(battle)
        local res = ed.getDataTable("ArenaBackground")[backgroundId].Picture
        res = string.gsub(res, "UI/alpha/1080P/", "")
        battle["Background Pic"] = res
      end
    end
  end
  ed.scene:reset(stage, battle, addition)
  ed.pushScene(ed.scene)
end

ed.showReplay = showReplay

function Engine:enterVideoPlayer(parameter)
  local stageInfo = parameter.stageInfo
  local heroList = parameter.heroList
  local selfExtraData = parameter.selfExtraData
  local stageExtraData = parameter.stageExtraData
  local bonusInfo = parameter.bonusInfo
  local mode = parameter.mode
  self:resetStage()
  self.manualbt_mode = parameter.manualBattle
  self.multi_mode = parameter.multiMode
  self.videoplayer_mode = true
  self.stage_info = stageInfo
  self:initMsbHeros(heroList, nil, 0, selfExtraData, mode, bonusInfo)
  self:dealMpBattleBonusInfos(bonusInfo)
  local battle = ed.lookupDataTable("Battle", nil, stageInfo["Stage ID"], 1)
  self:setupBattle(battle, stageExtraData)
  self:setOperationList(parameter.operations)
  if parameter.stageBuff then
    self.wave_id = 1
    self:initStageManager(parameter.stageBuff)
  else
    self:initStageManager()
  end
  self.mp_bonus = self.stage_info["MP Bonus"]
end

function Engine:initMsbHeros(hero_list, warschool, bookReadingLevel, extraData, mode, bonusInfos)
  if nil == hero_list then
    return
  end
  self.hero_list = hero_list
  bonusInfos = bonusInfos or {}
  sortHeroList(hero_list)
  for i = 1, #hero_list do
    local hero = hero_list[i]
    local readLevel = 1
    local bonusInfo = bonusInfos[hero._tid] or nil
    local extra
    if extraData then
      extra = extraData[hero._tid]
    end
    local meal = {
      mode = mode,
      time = ed.startBattleTime
    }
    local config = {
      meal = meal,
      estimate_rank = nil,
      estimate_skill = nil,
      estimate_max_rank = ed.enableMaxAttStrategy
    }
    local unit = ed.UnitCreate(hero, ed.emCampPlayer, config, extra, nil, 0, bonusInfo)
    unit.ai.will_cast_manual_skill = nil
    table.insert(self.unit_list, unit)
    table.insert(self.hero_id_list, hero._tid)
  end
end

function Engine:addGuildClashBuff(selfUnits, enemyUnits, winTimes)
  if winTimes == nil then
    return
  end
  if winTimes.camp1WinTimes and winTimes.camp1WinTimes > 0 then
    for k, unit in ipairs(selfUnits) do
      local buffInfo = ed.getDataTable("Buff")[50010001]
      local buff = ed.BuffCreate(buffInfo, unit, unit, {
        winTimes = winTimes.camp1WinTimes
      })
      unit:addBuff(buff, unit)
    end
  end
  if winTimes.camp2WinTimes and 0 < winTimes.camp2WinTimes then
    for k, unit in ipairs(enemyUnits) do
      local buffInfo = ed.getDataTable("Buff")[50010001]
      local buff = ed.BuffCreate(buffInfo, unit, unit, {
        winTimes = winTimes.camp2WinTimes
      })
      unit:addBuff(buff, unit)
    end
  end
end

function Engine:enterGuildClash(hero_list, enemy_list, self_dyna_list, enemy_dyna_list, stage_id, bonusInfo, winTimes)
  self:resetStage()
  if do_battle_log then
    logBeforeBt(hero_list, nil, nil, 0)
  end
  self.guildClash_mode = true
  self.stage_info = ed.lookupDataTable("Stage", stage_id)
  self.hero_list = hero_list
  self.wave_id = 1
  self.origin_enemy_team = combineBaseDyna(enemy_list, enemy_dyna_list)
  local selfBonus = type(bonusInfo) == "table" and bonusInfo.selfBonus or nil
  local selfUnit = self:initUnitList(true, hero_list, false, self_dyna_list, nil, nil, nil, selfBonus)
  local oppoBonus = type(bonusInfo) == "table" and bonusInfo.oppoBonus or nil
  local enemyUnit = self:initUnitList(false, enemy_list, false, enemy_dyna_list, nil, nil, nil, oppoBonus)
  self:initUnitInfo(selfUnit, enemyUnit)
  self.guildClashWinTimes = winTimes
  self:addGuildClashBuff(selfUnit, enemyUnit, winTimes)
  self:dealPvpBattleBonusInfo(bonusInfo)
  self:initStageManager()
  self.mp_bonus = 1
  self.enableHPSAndMPS = false
end

function Engine:isRealTimeMode()
  return self.multiarena_mode or self.wca_mode
end
