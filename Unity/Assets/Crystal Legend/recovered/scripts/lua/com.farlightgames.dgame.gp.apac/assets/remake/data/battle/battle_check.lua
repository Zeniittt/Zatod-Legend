module("battle_check", package.seeall)

function isSameDeviceId(deviceid1, deviceid2)
  if not deviceid1 or not deviceid2 then
    return false
  end
  return deviceid1._uid == deviceid2._uid and deviceid1._svr_id == deviceid2._svr_id
end

local function getHeroMaxRange(hid)
  local basicSkill = ed.getDataTable("Unit")[hid]["Basic Skill"]
  local maxRange = ed.getDataTable("Skill")[basicSkill][0]["Max Range"]
  return maxRange
end

function sortHeroes(heroes)
  local newHeroes = {}
  for _, hero in ipairs(heroes) do
    local index = 0
    local aRange = getHeroMaxRange(hero._tid)
    for idx, new in ipairs(newHeroes) do
      local bRange = getHeroMaxRange(new._tid)
      if aRange < bRange then
        index = idx
        break
      end
    end
    if index ~= 0 then
      table.insert(newHeroes, index, hero)
    else
      table.insert(newHeroes, hero)
    end
  end
  return newHeroes
end

function getDeviceInfo(data)
  local heroDevice = {}
  local warSchool = {}
  local readLevel = {}
  local bonusInfo = {}
  for _, value in ipairs(data) do
    for _, tid in ipairs(value._select_hero_id or {}) do
      heroDevice[tid] = value._key
      readLevel[tid] = value._book_level
      bonusInfo[tid] = value._bonus
    end
    for _, book in ipairs(value._warschool_books or {}) do
      table.insert(warSchool, book)
    end
  end
  return heroDevice, warSchool, readLevel, bonusInfo
end

function getOpList(heroes, operation, heroDevice)
  local opList = {}
  for _, unit in ipairs(operation._unit or {}) do
    local deviceid = unit._key
    for _, op in ipairs(unit._ops or {}) do
      local optype = ed.splitbits(op, 3)
      local index, order, idx, dsIdx, opp
      if optype == ed.opControlTarget or optype == ed.opControlTouch then
        index, idx, dsIdx, opp = ed.splitbits(op, 4, 7, 6, 3)
        local hero = heroes[index] or {}
        local isSame = isSameDeviceId(deviceid, heroDevice[hero._tid or 0])
        if isSame then
          table.insert(opList, {
            index = index,
            ext = {idx, dsIdx},
            op = opp
          })
        end
      elseif optype == ed.opEnergyBean then
        index, opp = ed.splitbits(op, 4, 3)
        local hero = heroes[index] or {}
        local isSame = isSameDeviceId(deviceid, heroDevice[hero._tid or 0])
        if isSame then
          table.insert(opList, {index = index, op = opp})
        end
      elseif optype == ed.opJoinEchoSkill then
        local echoId, opp = ed.splitbits(op, 16, 3)
        table.insert(opList, {echoId = echoId, op = opp})
      else
        index, order, opp = ed.splitbits(op, 4, 5, 3)
        local hero = heroes[index] or {}
        local isSame = isSameDeviceId(deviceid, heroDevice[hero._tid or 0])
        if isSame then
          table.insert(opList, {
            index = index,
            order = order,
            op = opp
          })
        end
      end
    end
  end
  return opList
end

function checkMultiplayerOperation(msg)
  local heroes = sortHeroes(msg._heroes)
  if msg._stageid == 20105 then
    for idx, hero in ipairs(heroes) do
      if hero._tid == 10001 then
        heroes[1], heroes[idx] = heroes[idx], heroes[1]
        break
      end
    end
  end
  local heroDevice, warSchool, readLevel, bonusInfo = getDeviceInfo(msg._devicehero)
  local tickList = {}
  for _, operation in ipairs(msg._operations or {}) do
    local tick = operation._tick
    local opList = getOpList(heroes, operation, heroDevice)
    for _, op in ipairs(opList) do
      if op.op == ed.opControlTarget or op.op == ed.opControlTouch then
        local v = ed.makebits(4, op.index, 7, op.ext[1], 6, op.ext[2], 3, op.op)
        local param = {_tick = tick, _operation = v}
        table.insert(tickList, param)
      elseif op.op == ed.opEnergyBean then
        local v = ed.makebits(4, op.index, 3, op.op)
        local param = {_tick = tick, _operation = v}
        table.insert(tickList, param)
      else
        local v = ed.makebits(4, op.index, 5, op.order, 3, op.op)
        local param = {_tick = tick, _operation = v}
        table.insert(tickList, param)
      end
    end
  end
  return tickList, warSchool, readLevel, bonusInfo
end

local function enterGuildInstance(msg)
  local stage = ed.lookupDataTable("Stage", nil, msg._stageid)
  local instanceInfo = {
    wave = msg._start_wave,
    hpInfo = msg._hp_start
  }
  ed.engine:enterGuildInstance(stage, msg._self_heroes, instanceInfo)
end

local function getDamageBuffs(heroId, targetLevel)
  local meta = ed.getDataTable("ArcanaTrial")[heroId][targetLevel]
  local list = {}
  for i = 1, 3 do
    local key1 = "ArcanaHero ID" .. i
    local key2 = "HeroDamage Ratio" .. i
    local heroId = meta[key1]
    local ratio = meta[key2]
    if heroId ~= 0 and ratio ~= 0 then
      table.insert(list, {heroId = heroId, ratio = ratio})
    end
  end
  return list
end

local function enterArcanaTrial(msg, warschool, bookReadingLevel, bonus)
  local heroId = msg._hero_id
  local arcanaLv = msg._arcana_level
  local stageId = ed.lookupDataTable("ArcanaTrial", "Arcana Stage ID", heroId, arcanaLv)
  local stage = ed.lookupDataTable("Stage", nil, stageId)
  local arcanaData = {}
  arcanaData._progress = msg._start_progress
  local param = {
    progress = arcanaData,
    damageBuffs = getDamageBuffs(heroId, arcanaLv)
  }
  ed.engine:enterArcanaTrial(stage, msg._heroes, param, nil, warschool, bookReadingLevel, bonus)
end

local function getDynaData(msg)
  local self_dyna_data = {}
  for i, h in ipairs(msg._self_heroes) do
    self_dyna_data[h._tid] = msg._self_dyna_start[i]
  end
  local oppo_dyna_data = {}
  for i, h in ipairs(msg._oppo_heroes) do
    oppo_dyna_data[h._tid] = msg._oppo_dyna_start[i]
  end
  return self_dyna_data, oppo_dyna_data
end

local function getStarGateStartDynaData(heros)
  local dyna_data = {}
  for i = 1, #heros do
    local hero = heros[i]
    dyna_data[hero._tid] = {_hp_perc = 10000, _mp_perc = 0}
  end
  return dyna_data
end

local function getSeasonArenaStartDynaData(heroes)
  local dyna_data = {}
  for i = 1, #heroes do
    local hero = heroes[i]
    dyna_data[hero._tid] = {_hp_perc = 10000, _mp_perc = 0}
  end
  return dyna_data
end

local function getSelfDynaData(msg)
  local self_dyna_data = {}
  for i, h in ipairs(msg._self_heroes) do
    self_dyna_data[h._tid] = msg._self_dyna_start[i]
  end
  return self_dyna_data
end

local function getMsbDynaData(msg)
  local self_dyna_data = {}
  for i, h in ipairs(msg._heroes) do
    self_dyna_data[h._tid] = msg._self_dyna_start[i]
  end
  return self_dyna_data
end

local function fillExcavMsg(msg)
  return ed.getDataTable("ExcavateTreasure")[msg._param1]["PVP Stage ID"]
end

local function paraseMode(arg)
  if not arg then
    return
  end
  if string.find(arg, "multistage") then
    return "multistage"
  end
  if string.find(arg, "stage") then
    return "stage"
  end
  if string.find(arg, "tbc") then
    return "tbc"
  end
  if string.find(arg, "guildMount") then
    return "guildMount"
  end
  if string.find(arg, "guild") then
    return "guild"
  end
  if string.find(arg, "excav") then
    return "excav"
  end
  if string.find(arg, "wca") then
    return "wca"
  end
  if string.find(arg, "gvg") then
    return "gvg"
  end
  if string.find(arg, "throne_tower") then
    return "throne_tower"
  end
  if string.find(arg, "chaos_tower") then
    return "chaos_tower"
  end
  if string.find(arg, "dreamland") then
    return "dreamland"
  end
  if string.find(arg, "monsterseal") then
    return "monsterseal"
  end
  if string.find(arg, "quest") then
    return "quest"
  end
  if string.find(arg, "siege") then
    return "siege"
  end
  if string.find(arg, "nightmare") then
    return "nightmare"
  end
  if string.find(arg, "multiplayer") then
    return "multiplayer"
  end
  if string.find(arg, "nian") then
    return "nian"
  end
  if string.find(arg, "multiarena") then
    return "multiarena"
  end
  if string.find(arg, "legend") then
    return "legend"
  end
  if string.find(arg, "msb") then
    return "msb"
  end
  if string.find(arg, "cuparena") then
    return "cuparena"
  end
  if string.find(arg, "arena") then
    return "arena"
  end
  if string.find(arg, "ancients") then
    return "ancients"
  end
  if string.find(arg, "assassinate") then
    return "assassinate"
  end
  if string.find(arg, "arcanaTrial") then
    return "arcanaTrial"
  end
  if string.find(arg, "mythBoss") then
    return "mythBoss"
  end
  if string.find(arg, "stargate") then
    return "stargate"
  end
  if string.find(arg, "babel") then
    return "babel"
  end
  if string.find(arg, "seasonArena") then
    return "seasonArena"
  end
  if string.find(arg, "seasonTower") then
    return "seasonTower"
  end
  if string.find(arg, "fancyAbyss") then
    return "fancyAbyss"
  end
  if string.find(arg, "rogueCheck") then
    return "rogueCheck"
  end
  if string.find(arg, "awakeStage") then
    return "awakeStage"
  end
end

function getMsg(arg)
  local msg = require(arg)
  local mode = paraseMode(arg)
  return msg, mode
end

local function checkHeroesNumber(msg, mode, round, self_team_idx, oppo_team_idx)
  if mode == "stage" then
    if msg._heroes == nil or #msg._heroes > 5 or #msg._heroes == 0 then
      print("heroes length is err")
      return true
    end
    local challengeTable = ed.getDataTable("Challenge")
    local isChallengeMode = challengeTable[msg._stageid]
    if isChallengeMode and challengeTable[msg._stageid].Type == "Legendary" and #msg._heroes > 1 then
      print("heroes length is err")
      return true
    end
  elseif mode == "dreamland" or mode == "monsterseal" or mode == "babel" or mode == "nian" then
    if msg._heroes == nil or #msg._heroes > 5 or #msg._heroes == 0 then
      print("heroes length is err")
      return true
    end
  elseif mode == "toppvp" or mode == "legend" then
    if msg._self_heroes[round]._heroes == nil or 5 < #msg._self_heroes[round]._heroes or #msg._self_heroes[round]._heroes == 0 then
      print("heroes length is err")
      return true
    end
  elseif mode == "stargate" then
    if msg._self_heroes[self_team_idx]._heroes == nil or 5 < #msg._self_heroes[self_team_idx]._heroes or #msg._self_heroes[self_team_idx]._heroes == 0 then
      print("heroes length is err")
      return true
    end
  elseif mode == "quest" then
    if msg._heroes == nil or #msg._heroes > 5 or #msg._heroes == 0 then
      print("heroes length is err")
      return true
    end
  elseif mode == "siege" or mode == "nightmare" then
    if msg._self_heroes == nil or 1 >= #msg._self_heroes then
      print("seige battle heroes length is err!")
      return true
    end
  elseif mode == "multiplayer" then
    return false
  elseif mode == "multiarena" then
    return false
  elseif mode == "msb" then
    return false
  elseif mode == "multistage" then
    if msg._self_heroes == nil or 5 < #msg._self_heroes or #msg._self_heroes == 0 then
      print("heroes length is err")
      return true
    end
    if msg._self_dyna_start == nil or msg._self_dyna_end == nil or #msg._self_dyna_start ~= #msg._self_dyna_end then
      print("self dyna is wrong")
      return true
    end
    if msg._oppo_dyna_start == nil or msg._oppo_dyna_end == nil or #msg._oppo_dyna_start ~= #msg._oppo_dyna_end then
      print("oppo dyna is wrong")
      return true
    end
  elseif mode == "chaos_tower" then
    if msg._heroes == nil or #msg._heroes > 5 or #msg._heroes == 0 then
      print("heroes length is err")
      return true
    end
  elseif mode == "chess" then
    return false
  elseif mode == "solo" then
    return false
  elseif mode == "arcanaTrial" then
    if msg._heroes == nil or #msg._heroes > 5 or #msg._heroes == 0 then
      print("heroes length is err")
      return true
    end
  elseif mode == "cuparena" then
    if msg._self_heroes == nil or msg._self_heroes[round] == nil or msg._self_heroes[round]._heroes == nil or 5 < #msg._self_heroes[round]._heroes or #msg._self_heroes[round]._heroes == 0 then
      print("heroes length is err")
      return true
    end
  elseif mode == "mythBoss" then
    if msg._heroes == nil or #msg._heroes > 5 or #msg._heroes == 0 then
      print("heroes length is err")
      return true
    end
  elseif mode == "fiveBoss" then
    if msg._heroes == nil or #msg._heroes > 5 or #msg._heroes == 0 then
      print("heroes length is err")
      return true
    end
  elseif mode == "raceTower" then
    if msg._heroes == nil or #msg._heroes > 5 or #msg._heroes == 0 then
      print("heroes length is err")
      return true
    end
  elseif mode == "fancyTower" or mode == "fancyAbyss" then
    if msg._heroes == nil or #msg._heroes > 5 or #msg._heroes == 0 then
      print("heroes length is err")
      return true
    end
  elseif mode == "activityAdventure" then
    if msg._heroes == nil or #msg._heroes > 5 or #msg._heroes == 0 then
      print("heroes length is err")
      return true
    end
  elseif mode == "guildMount" then
    if msg._heroes == nil or #msg._heroes > 5 or #msg._heroes == 0 then
      print("heroes length is err")
      return true
    end
  elseif mode == "seasonArena" then
    if msg._self_heroes[self_team_idx]._heroes == nil or 5 < #msg._self_heroes[self_team_idx]._heroes or #msg._self_heroes[self_team_idx]._heroes == 0 then
      print("heroes length is err, self_team_idx = " .. self_team_idx)
      return true
    end
  elseif mode == "seasonTower" then
    if msg._heroes == nil or #msg._heroes > 5 or #msg._heroes == 0 then
      print("heroes length is err")
      return true
    end
  elseif mode == "hadesHeat" then
    if msg._heroes == nil or #msg._heroes > 5 or #msg._heroes == 0 then
      print("heroes length is err")
      return true
    end
  elseif mode == "rogueCheck" then
    if msg._heroes == nil or #msg._heroes > 5 or #msg._heroes == 0 then
      print("heroes length is err")
      return true
    end
  elseif mode == "awakeStage" then
    local stageTableItem = ed.getDataTable("DungeonStage")[msg._stageid]
    local limitNum = stageTableItem["Ally Num"]
    if 0 == limitNum then
      limitNum = 5
    end
    if msg._heroes == nil or limitNum < #msg._heroes or #msg._heroes == 0 then
      print("heroes length is err")
      return true
    end
  elseif msg._self_heroes == nil or 5 < #msg._self_heroes or #msg._self_heroes == 0 then
    print("heroes length is err")
    return true
  end
  return false
end

local function checkOprations(msg, mode)
  local maxOperationNum = 400
  if mode == "guild" or mode == "ancients" or mode == "stage" or mode == "tbc" or mode == "throne_tower" or mode == "chaos_tower" or mode == "excav" or mode == "dreamland" or mode == "monsterseal" or mode == "multistage" then
    if msg._operations and maxOperationNum < #msg._operations then
      print("oprations length  more than " .. maxOperationNum)
      return true
    end
    local oper1 = msg._operations and msg._operations[1] and msg._operations[1]._operation
    if oper1 and ed.splitbits(oper1, 3) == 1 and (mode ~= "siege" or mode ~= "nightmare") then
      print("invalid oprations!(op == 1 but not siege or nightmare!)")
      return true
    end
  elseif mode == "wca" then
    if msg._self_operation and maxOperationNum < #msg._self_operation then
      print("oprations length  more than " .. maxOperationNum)
      return true
    end
    if msg._oppo_operation and maxOperationNum < #msg._oppo_operation then
      print("oprations length  more than " .. maxOperationNum)
      return true
    end
  end
  return false
end

local enterBattleCondition = {checkHeroesNumber, checkOprations}

function limitEnterBattle(msg, mode, round, self_team_idx, oppo_team_idx)
  if not msg then
    return true
  end
  if not mode then
    return true
  end
  for i, condition in ipairs(enterBattleCondition) do
    if condition(msg, mode, round, self_team_idx, oppo_team_idx) then
      return true
    end
  end
  return false
end

local function initFightWarschoolInfo(data)
  if not data then
    return nil
  end
  local fightWarschool = {}
  for i = 1, #data do
    fightWarschool[i] = {}
    fightWarschool[i].id = data[i]._id
    fightWarschool[i].info = {}
    local info = fightWarschool[i].info
    local skills = data[i]._skills
    for j = 1, #skills do
      local skillid = ed.bits(skills[j], 0, 8)
      local level = ed.bits(skills[j], 8, 8)
      info[skillid] = level
    end
  end
  return fightWarschool
end

function enterBattle(msg, mode, round, selfTeamIdx, oppoTeamIdx)
  ed.engine = ed.commonEngine
  if mode == "guild" or mode == "dreamland" or mode == "multiplayer" or mode == "babel" or mode == "multistage" or mode == "msb" then
    ed.startBattleTime = msg._bt_st
  end
  ed.srand(msg._rseed)
  if mode == "guild" then
    enterGuildInstance(msg)
    ed.engine:setOperationList(msg._operations)
  elseif mode == "stage" or mode == "dreamland" or mode == "monsterseal" then
    local stage = ed.lookupDataTable("Stage", nil, msg._stageid)
    local selfschool = initFightWarschoolInfo(msg._warschool_books or nil)
    local stageBuff
    if mode == "dreamland" then
      stageBuff = msg._scene_buff
    end
    local manualBattle = mode == "stage" and msg._is_manual_battle and msg._is_manual_battle == 1
    local myth_mode = math.modf(msg._stageid / 10000) == 2000 and "mythPve" or nil
    ed.engine:enterStage(stage, msg._heroes, nil, nil, nil, nil, {
      manualBattle = manualBattle,
      stageBuff = stageBuff,
      mode = myth_mode,
      battleBonus = msg._bonus
    })
    ed.engine:setOperationList(msg._operations)
  elseif mode == "tbc" then
    local oppo_bot = msg._oppo_robot and msg._oppo_robot > 0
    local self_dyna, oppo_dyna = getDynaData(msg)
    local bonusInfo = {
      selfBonus = msg._self_bonus,
      oppoBonus = msg._oppo_bonus
    }
    ed.engine:enterCrusade(msg._self_heroes, msg._oppo_heroes, oppo_bot, self_dyna, oppo_dyna, -1, msg._mode, nil, nil, msg._energy_beans, bonusInfo, msg._self_bonus._buff_id)
    ed.engine:setOperationList(msg._operations)
  elseif mode == "arena" then
    local self_bot = msg._self_robot and 0 < msg._self_robot
    local oppo_bot = msg._oppo_robot and msg._oppo_robot > 0
    local pvpActivityId = msg._ladder_buff_id
    local background = {
      backgroundId = msg._background_id,
      homeGround = msg._home_ground
    }
    local bonusInfo = {
      selfBonus = msg._self_bonus,
      oppoBonus = msg._oppo_bonus
    }
    ed.engine:enterArena(msg._self_heroes, msg._oppo_heroes, self_bot, oppo_bot, nil, nil, nil, pvpActivityId, bonusInfo, nil, background)
  elseif mode == "test_battle_check" then
    if msg._type == "pvp" then
      local param = {
        type = "pvp",
        selfTeam = msg._self_heroes,
        oppoTeam = msg._oppo_heroes
      }
      ed.engine:battleCheck(param)
      ed.engine:setOperationList(msg._operations)
    elseif msg._type == "guild" or msg._type == "dreamland" then
      local stageInfo = ed.lookupDataTable("Stage", nil, msg._stage_id)
      local param = {
        type = "guild",
        selfTeam = msg._self_heroes,
        stageInfo = stageInfo
      }
      ed.engine:battleCheck(param)
      ed.engine:setOperationList(msg._operations)
    end
  elseif mode == "fancyTower" then
    local towerId = msg._towerid
    local floorId = msg._floor
    local stageData = ed.getDataTable("FancyTowerNormal")[towerId][floorId]
    local stageId = stageData["Fancy Tower Stage ID"]
    local stage = ed.lookupDataTable("FancyTowerStage", nil, stageId)
    local floorInfo = {
      towerId = towerId,
      floorId = floorId,
      stageId = stageId,
      trigger1 = {
        stageData["Star Collect Trigger Type 1"],
        stageData["Star Collect Trigger Target 1"]
      },
      trigger2 = {
        stageData["Star Collect Trigger Type 2"],
        stageData["Star Collect Trigger Target 2"]
      },
      trigger3 = {
        stageData["Star Collect Trigger Type 3"],
        stageData["Star Collect Trigger Target 3"]
      }
    }
    ed.engine:enterFancyTower(stage, msg._heroes, nil, nil, nil, floorInfo, msg._bonus)
    ed.engine:setOperationList(msg._operations)
  elseif mode == "fancyAbyss" then
    local seasonId = msg._seasonid
    local floorId = msg._floorid
    local stageData = ed.getDataTable("FancyAbyssNormal")[seasonId][floorId]
    local stageId = stageData["Stage ID"]
    local stage = ed.lookupDataTable("FancyAbyssStage", nil, stageId)
    local buffId
    ed.engine:enterFancyAbyss(stage, msg._heroes, false, msg._bonus)
    ed.engine:setOperationList(msg._operations)
  elseif mode == "activityAdventure" then
    local stageId = msg._stageid
    local actId = msg._actid
    local actAdventureCfg = ed.getDataTable("ActivityAdventure")[actId]
    local stageInfo = ed.lookupDataTable("ActivityAdventureStage", nil, stageId)
    local challengeLevel = msg._challenge_level
    local minDay = actAdventureCfg["Min day"]
    local maxDay = actAdventureCfg["Max day"]
    challengeLevel = math.max(challengeLevel, minDay)
    challengeLevel = math.min(challengeLevel, maxDay)
    local difficultyRatio = (challengeLevel - minDay) / (maxDay - minDay)
    ed.engine:enterActivityAdventure(stageInfo, msg._heroes, nil, nil, nil, nil, {difficultyRatio = difficultyRatio})
    ed.engine:setOperationList(msg._operations)
  elseif mode == "hadesHeat" then
    local stageId = msg._stageid
    local stageInfo = ed.lookupDataTable("HeatStage", nil, stageId)
    local heatGroupCfg = ed.getDataTable("HeatGroup")[msg._groupid]
    local minDay = heatGroupCfg["Min day"]
    local maxDay = heatGroupCfg["Max day"]
    local challengeLevel = msg._challenge_level
    challengeLevel = math.max(msg._challenge_level, minDay)
    challengeLevel = math.min(challengeLevel, maxDay)
    local difficultyRatio = (challengeLevel - minDay) / (maxDay - minDay)
    ed.engine:enterHadesHeat(stageInfo, msg._heroes, nil, nil, nil, nil, {
      chooseHeat = msg._choose_heat,
      groupId = msg._groupid,
      echoId = msg._echo_id,
      difficultyRatio = difficultyRatio
    })
    ed.engine:setOperationList(msg._operations)
  elseif mode == "awakeStage" then
    local stageId = msg._stageid
    local startTime = msg._season_start_time
    local stageInfo = ed.lookupDataTable("DungeonStage", nil, stageId)
    local chapterGroup = stageInfo["Chapter Group ID"]
    local chapterId = stageInfo["Chapter ID"]
    local dungeonChapterCfg = ed.getDataTable("DungeonChapter")[chapterGroup][chapterId]
    local buffGroupId, stageBuffInfo
    if dungeonChapterCfg and startTime ~= 0 then
      buffGroupId = dungeonChapterCfg["Buff Group ID"]
      if buffGroupId and 0 < buffGroupId then
        local stagebuffCfg = ed.getDataTable("DungeonStagebuff")[buffGroupId]
        for index = 1, 20 do
          local duration = stagebuffCfg["Duration" .. index]
          if not duration or duration <= 0 then
            break
          end
          local serverTime = msg._start_time
          if startTime < serverTime and serverTime < startTime + duration * 3600 then
            stageBuffInfo = {
              buffId = stagebuffCfg["Buff ID" .. index],
              buffGroupId = buffGroupId,
              targetCamp = stagebuffCfg["Target" .. index]
            }
            break
          end
        end
      end
    end
    ed.engine:enterAwakeStage(stageInfo, msg._heroes, false, stageBuffInfo, {
      groupId = msg._level_group_id,
      level = msg._paragon_level,
      maxLevel = msg._max_paragon_level
    })
    ed.engine:setOperationList(msg._operations)
  elseif mode == "peakArena" then
    local selfHeros = msg._self_heroes[round] and msg._self_heroes[round]._heroes or {}
    local oppoHeros = msg._oppo_heroes[round] and msg._oppo_heroes[round]._heroes or {}
    local sh = {}
    for i, selfHero in pairs(selfHeros) do
      table.insert(sh, selfHero)
    end
    local oh = {}
    for i, oppoHero in pairs(oppoHeros) do
      table.insert(oh, oppoHero)
    end
    ed.engine:enterPeakArena(sh, oh, round, msg._season_buff_key)
  elseif mode == "guildClash" then
    local bonusInfo = {
      selfBonus = msg._self_bonus,
      oppoBonus = msg._oppo_bonus
    }
    local winTimes = {
      camp1WinTimes = msg._camp1_win_times,
      camp2WinTimes = msg._camp2_win_times
    }
    ed.engine:enterGuildClash(msg._self_heroes, msg._oppo_heroes, msg._self_hero_dynas, msg._oppo_hero_dynas, -1, bonusInfo, winTimes)
  elseif mode == "seasonTower" then
    local selfschool = initFightWarschoolInfo(msg._warschool_books or nil)
    local selfBookReadingLevel = msg._bookreading_level
    local towerId = msg._towerid
    local floorId = msg._floor
    local stageId = ed.getDataTable("SeasonTowerReward")[towerId][floorId]["Stage ID"]
    local stage = ed.lookupDataTable("SeasonTowerStage", nil, stageId)
    local towerBonusInfo = {
      towerId = towerId,
      floorId = floorId,
      bonusIds = msg._tower_bonus or {}
    }
    ed.engine:enterSeasonTower(stage, msg._heroes, nil, selfschool, selfBookReadingLevel, msg._bonus, towerBonusInfo)
    ed.engine:setOperationList(msg._operations)
  elseif mode == "chess" then
    ed.engine = ed.AutoChessBattleEngine
    local param = {
      self_team = msg._self_team,
      oppo_team = msg._oppo_team,
      self_powers = msg._self_powers,
      oppo_powers = msg._oppo_powers
    }
    ed.engine:enterAutoChessCheck(param)
  elseif mode == "solo" then
    ed.engine = ed.SoloBattleEngine
    ed.engine:enterSoloCheck(msg)
  elseif mode == "cuparena" then
    local warschool = {
      selfschool = initFightWarschoolInfo(msg._self_warschool_books or nil),
      opposchool = initFightWarschoolInfo(msg._oppo_warschool_books or nil)
    }
    local bookReadingLevels = {
      selfBookReadingLevel = msg._self_bookreading_level,
      oppoBookReadingLevel = msg._oppo_bookreading_level
    }
    local bonusInfo = {
      selfBonus = msg._self_bonus,
      oppoBonus = msg._oppo_bonus
    }
    local selfHeros = msg._self_heroes and msg._self_heroes[round] and msg._self_heroes[round]._heroes or {}
    local oppoHeros = msg._oppo_heroes and msg._oppo_heroes[round] and msg._oppo_heroes[round]._heroes or {}
    ed.engine:enterCupArena(selfHeros, oppoHeros, warschool, bookReadingLevels, bonusInfo, #(msg._self_heroes or {}) == 5 or #(msg._oppo_heroes or {}) == 5)
  elseif mode == "rogueCheck" then
    local stageId = msg._stageid
    local stageInfo = ed.lookupDataTable("RogueStage", nil, stageId)
    ed.engine:enterRogueBattle(stageInfo, msg._heroes, {
      stageId = msg._stageid,
      chapterId = msg._chapter_id,
      destinyId = msg._destiny,
      destinyEnergy = msg._des_energy_start,
      blessList = msg._bless,
      charmList = msg._charm_list,
      techIdList = msg._tech_ids,
      dynaStart = msg._dyna_start,
      chapterDiff = msg._chapter_diff,
      crisisDiff = msg._crisis,
      rogueWave = msg._wave
    })
    ed.engine:setOperationList(msg._operations)
  elseif mode == "guildMount" then
    local stageId = ed.getDataTable("GuildMountBoss")[msg._bossid]["Stage ID"]
    local stage = ed.lookupDataTable("Stage", nil, stageId)
    local guildBossData = {
      id = msg._bossid
    }
    ed.engine:enterGuildMountBoss(stage, msg._heroes, nil, guildBossData, nil, 0, msg._bonus)
    ed.engine:setOperationList(msg._operations)
  elseif mode == "wca" then
    local bonusInfo = {
      selfBonus = msg._self_bonus,
      oppoBonus = msg._oppo_bonus
    }
    ed.engine:enterWCA(msg._self_heroes, msg._oppo_heroes, true, bonusInfo)
    for i, v in ipairs(msg._self_operation or {}) do
      battle_tick.setSelfOperation(v._tick, v._operation)
    end
    for i, v in ipairs(msg._oppo_operation or {}) do
      battle_tick.setTargetOperation(v._tick, v._operation)
    end
  elseif mode == "crevicedefend" then
    local _selfbonus = msg._self_bonus
    local currentRound = round or 1
    local _stageId = msg._stage_ids and msg._stage_ids[currentRound] or msg._stageid
    local _selfHeros = msg._self_heroes and msg._self_heroes[currentRound] and msg._self_heroes[currentRound]._heroes or msg._heroes or {}
    local stage_info = ed.lookupDataTable("Stage", nil, -13)
    local params = {stageid = _stageId, battleBonus = _selfbonus}
    ed.engine:enterCreviceDefend(stage_info, _selfHeros, params)
  end
  if ed.run_with_scene then
    local stage = ed.lookupDataTable("Stage", nil, -1)
    local battle = ed.lookupDataTable("Battle", nil, -1, 1)
    ed.scene:reset(stage, battle, {
      pvpInfo = {
        player_summary = {}
      }
    })
    ed.pushScene(ed.scene)
  end
end

function endBattle()
  local battleLog = getBtlog()
  local folder = CCFileUtils:sharedFileUtils():getWritablePath()
  print(folder)
  local path = string.format("%s/%s.log", folder, os.date("%Y-%m-%d %H-%M-%S"))
  local file = io.open(path, "w")
  if file then
    file:write(battleLog)
    file:close()
  end
  print("bot over")
end

function String2Result(result)
  if result == "victory" then
    return 0
  elseif result == "defeat" then
    return 1
  elseif result == "canceled" then
    return 2
  elseif result == "timeout" then
    return 3
  elseif result == "cheat" then
    return 4
  end
end
