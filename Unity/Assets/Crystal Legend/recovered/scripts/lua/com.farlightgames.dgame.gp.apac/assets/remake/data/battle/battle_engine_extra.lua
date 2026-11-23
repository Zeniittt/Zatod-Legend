local Engine = ed.EngineClass

function ed.IsMultiArena()
  return ed.engine.multiarena_mode
end

function ed.IsAutoChessMode()
  return ed.engine.autoChessMode
end

function Engine:enterMultiArenaRelay(param)
  param = param or {}
  self:enterMultiArena(param)
  self.replayMode = true
  battle_tick.enterReplayMode()
  for i, v in ipairs(param.operations or {}) do
    battle_tick.setSelfOperation(v._tick, v._ops)
  end
  for i, v in ipairs(param.right_operations or {}) do
    battle_tick.setTargetOperation(v._tick, v._ops)
  end
end

function Engine:RecoveryMultiArenaBattle(param)
  self.recovering = true
  param = param or {}
  self:enterMultiArena(param)
  for i, v in ipairs(param.operations or {}) do
    battle_tick.setSelfOperation(v._tick, v._operation)
  end
  for i, v in ipairs(param.oppo_operation or {}) do
    battle_tick.setTargetOperation(v._tick, v._operation)
  end
  local stage = ed.lookupDataTable("Stage", nil, -64)
  local battle = ed.lookupDataTable("Battle", nil, -64, 1)
  local param = {
    pvpInfo = {pvpMode = "multiarena"}
  }
  ed.scene:reset(stage, battle, param)
  ed.pushScene(ed.scene)
end

function Engine:enterMultiArena(param)
  local isHost = param.isHost
  local teamIndex = param.team_index
  self:resetStage()
  self.battle_manager = MultiArenaBattleManager.Create(param.btInfo)
  local left_lord, right_lord = self.battle_manager:GetTeamLord()
  if do_battle_log then
    logBeforeBt({left_lord}, {right_lord}, {}, nil)
  end
  self.multiarena_mode = true
  self.stage_rect = ed.multiArena.stage_rect
  self.wave_id = 1
  self.stage_info = ed.lookupDataTable("Stage", -27)
  self.hero_list = {left_lord}
  battle_tick.setRealTimePvp(true)
  battle_tick.setHost(isHost)
  battle_tick.setTeamIndex(teamIndex)
  Engine.initLordUnit(self, {left_lord}, {right_lord})
  self:SetTarget()
  if not isHost then
    self.hero_list = {right_lord}
    self.hero_id_list = {}
    for i = 1, #self.hero_list do
      local proto = self.hero_list[i]
      if ed.player:getHero(proto._tid) then
        table.insert(self.hero_id_list, proto._tid)
      end
    end
  end
  self.mp_bonus = 1
  self.time_limit = ed.multiArena.battleTime
end

function Engine:isSelf(isHost, teamIndex)
  if teamIndex ~= battle_tick.getTeamIndex() then
    return false
  end
  return self:isSelfTeam(isHost)
end

function Engine:isSelfTeam(isHost)
  if battle_tick.getRealTimePvp() and not battle_tick.getHost() and isHost == battle_tick.GUEST then
    return true
  end
  if battle_tick.getRealTimePvp() and battle_tick.getHost() and isHost ~= battle_tick.GUEST then
    return true
  end
  return false
end

function Engine:onJoinMagic(info)
  local isHost = info.isHost
  local pos = info.pos
  local id = info.id
  local teamIndex = info.teamIndex
  local pl = self.battle_manager:GetPlayer(isHost == battle_tick.HOST, teamIndex)
  if not pl:CanAddMagic(id) then
    return
  end
  pl:AddMagic(id)
  local camp = ed.emCampPlayer
  if not self:isSelfTeam(isHost) then
    camp = ed.emCampEnemy
  end
  local param = {
    position = pos,
    direction = camp,
    foecamp = -camp,
    camp = camp
  }
  local caster = pl:GetMagicCaster()
  for k, v in pairs(param) do
    caster[k] = v
  end
  local temp = {
    magicId = id,
    pos = pos,
    caster = caster
  }
  ed.multiArena.MagicManager.CreateMagic(temp)
  if self:isSelf(isHost, teamIndex) and not self.replayMode and ed.run_with_scene then
    FireEvent("placeMagicInBattle", id)
  end
end

function Engine:SetTarget()
  local target_list = {}
  local player_list = self.alive_units[ed.emCampPlayer]
  local player_target = player_list[1]
  player_target.isTarget = true
  player_target:addSpecialBuff()
  table.insert(target_list, player_target)
  local enemy_list = self.alive_units[ed.emCampEnemy]
  local enemy_target = enemy_list[1]
  enemy_target.isTarget = true
  enemy_target:addSpecialBuff()
  table.insert(target_list, enemy_target)
  self.target_list = target_list
end

function Engine:GetTargetList()
  return self.target_list or {}
end

function Engine:enterAutoChess(param)
  self:resetStage()
  self:initAutoChessParam(param)
  self.push_interval_tick = 4
end

function Engine:initAutoChessParam(param)
  self.wave_id = 1
  self.autoChessMode = true
  self.stage_rect = {
    minX = 0,
    maxX = 800,
    minY = -240,
    maxY = 240
  }
  self.stage_info = ed.lookupDataTable("Stage", param.stageId)
  self.mp_bonus = self.stage_info["MP Bonus"]
end

function Engine:addChessUnit(unit, withEffect)
  local alive = unit:isAlive()
  unit.previous_position = {
    unit.position[1],
    unit.position[2]
  }
  table.insert(self.unit_list, unit)
  if alive then
    table.insert(self.alive_units[unit.camp], unit)
    table.insert(self.alive_units[ed.emCampBoth], unit)
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
  if not unit.actor and ed.run_with_scene then
    if ed.scene.scene then
      unit.actor = ed.UnitActorCreate(unit)
      ed.scene:addActor(unit.actor)
      unit.actor:update(0)
    end
    local origin = {
      unit.position[1],
      unit.position[2]
    }
    if withEffect then
      local effect_name1 = "eff_UI_Chess_hero_evolution.cha"
      local effect_name2 = "eff_UI_Chess_hero_evolution2.cha"
      ed.scene:playEffectOnScene(effect_name1, origin, {
        unit.direction * 0.85,
        0.85
      }, nil, 1)
      ed.scene:playEffectOnScene(effect_name2, origin, {
        unit.direction * 0.85,
        0.85
      }, nil, -1)
    end
  end
end

function Engine:clearAllChessUnits(...)
  if type(self.unit_list) == "table" then
    for _, unit in ipairs(self.unit_list) do
      unit:onUnitExitBattle()
    end
  end
  self.unit_list = {}
end

function Engine:onUnitExit(unit)
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
  if unit.camp == ed.emCampPlayer then
    self.alive_alliance_count = self.alive_alliance_count - 1
    self.dead_alliance_count = self.dead_alliance_count + 1
  elseif unit.camp == ed.emCampEnemy then
    self.alive_enemy_count = self.alive_enemy_count - 1
    self.dead_enemy_count = self.dead_enemy_count + 1
  end
  if self.firstEnemyDie == false and unit.camp == ed.emCampEnemy and self.timeLimitMode then
    self.firstEnemyDie = true
    self.time_limit = self.left_time or 10
  end
end

function Engine:placePrepareHero(info)
  local oppration = {
    op = ed.opPrepareJoinBattle,
    tick = self.ticks,
    hero = info.hero,
    ext = {0, 0},
    pos = info.pos,
    isHost = 0
  }
  battle_tick.addSelfOperation(oppration)
end

function Engine:undoPlacePrepareHero(info)
  local oppration = {
    op = ed.opPrepareUndoJoinBattle,
    tick = self.ticks,
    insid = info.insid
  }
  battle_tick.addSelfOperation(oppration)
end

function Engine:runChessPrepareOperations()
  if not self.autoChessMode then
    return
  end
  local ulist = self.unit_list
  
  local function doOpCall(opp)
    local op = opp.op
    if op == ed.opPrepareJoinBattle then
      local hero = opp.hero
      local pos = opp.pos
      if not hero or not pos then
        return
      end
      local info = {
        hero = hero,
        pos = pos,
        camp = opp.camp
      }
      self:onPrepareJoinBattle(info)
    end
    if op == ed.opPrepareUndoJoinBattle then
      local insid = opp.insid
      for _, unit in ipairs(ulist) do
        if unit.insid == insid then
          unit:onUnitExitBattle(true)
          break
        end
      end
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

function Engine:onPrepareJoinBattle(info, isCheck)
  local pos = info.pos
  local chessHero = info.hero
  local hero = {
    _tid = chessHero:getChessId(),
    _insid = chessHero:getHeroInsid(),
    still_show = info.still_show,
    show_tag = info.show_tag,
    show_pet = info.show_pet
  }
  local chessPet = chessHero:getEquipChessPet()
  if chessPet and info.addPet then
    hero._pet = {
      _insid = chessPet:getChessPetInsid(),
      _pid = chessPet:getChessPetId()
    }
  end
  if chessPet and info.show_pet then
    hero.pid = chessPet:getChessPetId()
  end
  local unit = self:createChessBattleUnit(hero, pos, info.camp)
  local isTagEffect, tags = false, {}
  if isCheck then
    isTagEffect, tags = self:checkChessTagEffect(hero._tid)
  end
  self:addChessUnit(unit, info.withEffect)
  FireEvent("EventChessUpdateTag", isTagEffect, tags)
end

function Engine:delChessUnitFromBattle(insid)
  local ulist = self.unit_list
  for i, unit in ipairs(ulist) do
    if unit.insid == insid then
      unit:onUnitExitBattle(true)
      table.remove(self.unit_list, i)
      break
    end
  end
  FireEvent("EventChessUpdateTag", false)
end

function Engine:moveChessUnitFromBattle(insid, pos)
  local ulist = self.unit_list
  for _, unit in ipairs(ulist) do
    if unit.insid == insid then
      unit.position = {
        pos.x,
        pos.y
      }
      break
    end
  end
end

function Engine:createChessBattleUnit(hero, pos, camp)
  local config = {
    estimate_rank = false,
    estimate_skill = true,
    estimate_max_rank = false
  }
  local dynaData = {_mp_perc = 0}
  local camp = camp or ed.emCampPlayer
  local unit = ed.ChessUnitCreate(hero, camp, config, dynaData)
  unit.position = {
    pos.x,
    pos.y
  }
  unit.direction = camp == ed.emCampPlayer and 1 or -1
  unit:reset()
  unit:setAction("Idle", true)
  if unit.manual_skill then
    unit.manual_skill.cd_remaining = 0
  end
  return unit
end

function Engine:createChessNpcUnit()
  local proto = {_tid = 100001, _level = 1}
  local config = {
    estimate_rank = true,
    estimate_skill = true,
    estimate_max_rank = false
  }
  local unit = ed.ChessUnitCreate(proto, ed.emCampPlayer, config)
  unit:reset()
  self:addStageUint(unit)
  unit.position = {
    ed.engine.stage_rect.maxX / 2,
    0
  }
  local eunit = ed.ChessUnitCreate(proto, ed.emCampEnemy, config)
  eunit:reset()
  self:addStageUint(eunit)
  unit.position = {
    ed.engine.stage_rect.maxX / 2,
    0
  }
end

function Engine:clearChessNpc(...)
  for _, unit in ipairs(self.FieldNpc_list) do
    unit:onUnitExitBattle()
  end
  self.FieldNpc_list = {}
end

function Engine:autoChessBattleEndCheck()
  if ed.AutoChessManager:getBattleEndCheck() then
    local isBattleEnd = false
    if self.alive_enemy_count == 0 then
      isBattleEnd = true
      for unit in self:foreachAliveUnit(ed.emCampPlayer) do
        if unit.actor then
          unit.actor:cheer()
        end
      end
    elseif 0 >= self.time_limit then
      isBattleEnd = true
    elseif self.alive_alliance_count == 0 then
      isBattleEnd = true
    end
    if isBattleEnd then
      ed.AutoChessManager:enterStage(ed.AutoChessManager.GAMESTAGE.WAITTING)
      ed.AutoChessManager:stopBattleEndCheck()
      ed.AutoChessManager:handlerBattleConfirm()
      FireEvent("EventChessBattleCheckEnd")
    end
  end
end

function Engine:getChessTagData(camp)
  local heroList = {}
  local tagData = {
    race = {},
    ability = {}
  }
  for _, unit in ipairs(self.unit_list) do
    if unit.camp == camp then
      local heroId = unit.info["Hero ID"]
      if not ed.isElementInTable(heroId, heroList) then
        table.insert(heroList, heroId)
        local raceTags = unit.info["Race Tag"]
        for _, tag in ipairs(raceTags) do
          if tagData.race[tag] == nil then
            tagData.race[tag] = 0
          end
          tagData.race[tag] = tagData.race[tag] + 1
        end
        local abilityTags = unit.info["Ability Tag"]
        for _, tag in ipairs(abilityTags) do
          if tagData.ability[tag] == nil then
            tagData.ability[tag] = 0
          end
          tagData.ability[tag] = tagData.ability[tag] + 1
        end
      end
    end
  end
  return tagData
end

function Engine:checkChessTagEffect(hid)
  local tagData = self:getChessTagData(ed.emCampPlayer)
  local raceTags = tagData.race
  local abilityTags = tagData.ability
  local chessTags = {}
  local chessRaceTags = ed.getChessUnitRaceTags(hid)
  local chessAbilityTags = ed.getChessUnitAbilityTags(hid)
  local isTagEffect = false
  for _, tag in pairs(chessRaceTags) do
    local raceNum = raceTags[tag] or 0
    local abilityNum = abilityTags[tag] or 0
    local totalNum = raceNum + abilityNum + 1
    local tagConfig = ed.AutoChessModel:getTagNumByType(tag)
    for _, config in ipairs(tagConfig) do
      if totalNum >= config.min and totalNum <= config.max then
        isTagEffect = true
        chessTags[#chessTags + 1] = tag
      end
    end
  end
  for _, tag in pairs(chessAbilityTags) do
    local raceNum = raceTags[tag] or 0
    local abilityNum = abilityTags[tag] or 0
    local totalNum = raceNum + abilityNum + 1
    local tagConfig = ed.AutoChessModel:getTagNumByType(tag)
    for _, config in ipairs(tagConfig) do
      if totalNum >= config.min and totalNum <= config.max then
        isTagEffect = true
        chessTags[#chessTags + 1] = tag
      end
    end
  end
  return isTagEffect, chessTags
end

function Engine:exitChessCheck(result)
  self.beingEnd = false
  self.running = false
  self.enabled = false
  self.stage_ended = true
  self.battleResult = result
  if ed.autoSaveChessLog then
    self:saveBattleLog()
  end
end

function Engine:getChessBattleResult(...)
  local selfHeros = {}
  local enemyHeros = {}
  for i, unit in pairs(self.unit_list) do
    if unit.camp == ed.emCampEnemy then
      if unit:isAlive() then
        table.insert(enemyHeros, unit.insid)
      end
    elseif unit.camp == ed.emCampPlayer and unit:isAlive() then
      table.insert(selfHeros, unit.insid)
    end
  end
  return selfHeros, enemyHeros
end

function Engine:chessBattleEndCheckNew()
  if self.alive_enemy_count == 0 then
    self.beingEnd = true
    self:exitChessCheck(0)
  elseif 0 >= self.time_limit then
    self.beingEnd = true
    self:exitChessCheck(0)
  elseif self.alive_alliance_count == 0 then
    self:exitChessCheck(1)
  end
end

function Engine:enterAutoChessCheck(param)
  self.unit_list = {}
  self:resetStage()
  self:initAutoChessParam({stageId = 100001})
  self.autoChessMode = true
  self.push_interval_tick = 4
  self.time_limit = 102
  local heroPos = {
    pos_9 = ccp(121, -47),
    pos_5 = ccp(159, 1),
    pos_1 = ccp(186, 39),
    pos_10 = ccp(191, -47),
    pos_6 = ccp(190, 1),
    pos_2 = ccp(242, 39),
    pos_11 = ccp(262, -47),
    pos_7 = ccp(281, 1),
    pos_3 = ccp(299, 39),
    pos_12 = ccp(335, -47),
    pos_8 = ccp(346, 1),
    pos_4 = ccp(355, 39)
  }
  local self_team = param.self_team
  local oppo_team = param.oppo_team
  if type(oppo_team._heroes) == "table" then
    for i, hero in ipairs(oppo_team._heroes) do
      local heroData = {
        _tid = hero._hid,
        _insid = hero._insid
      }
      if hero._pet then
        heroData._pet = {
          _insid = hero._pet._insid,
          _pid = hero._pet._pid
        }
      end
      local posIndex = oppo_team._positions[i]
      local pos = heroPos["pos_" .. posIndex]
      local chessUnit = self:createChessBattleUnit(heroData, pos, ed.emCampEnemy)
      self:addChessUnit(chessUnit)
    end
  end
  if type(self_team._heroes) == "table" then
    for i, hero in ipairs(self_team._heroes) do
      local heroData = {
        _tid = hero._hid,
        _insid = hero._insid
      }
      if hero._pet then
        heroData._pet = {
          _insid = hero._pet._insid,
          _pid = hero._pet._pid
        }
      end
      local posIndex = self_team._positions[i]
      local pos = heroPos["pos_" .. posIndex]
      pos = ccp(800 - pos.x, pos.y)
      local chessUnit = self:createChessBattleUnit(heroData, pos, ed.emCampPlayer)
      self:addChessUnit(chessUnit)
    end
  end
  self:clearChessNpc()
  self:createChessNpcUnit()
end

function Engine:getArcanaProgress()
  local maxPercent = 10000
  local donePercent = 0
  local totalPercent = 0
  local totalWaves = self.stage_info.Waves
  for i = 1, totalWaves do
    local battle = ed.lookupDataTable("Battle", nil, self.stage_info["Stage ID"], i)
    local weight = 1
    totalPercent = totalPercent + weight
    if i < self.wave_id then
      donePercent = donePercent + weight
    elseif self.wave_id == i then
      local hpInfo, percent = self:getEnemyHpInfo()
      local tempPercent = self.monsterNum * maxPercent
      donePercent = donePercent + (tempPercent - percent) / tempPercent * weight
    end
  end
  return maxPercent - math.floor(donePercent / totalPercent * maxPercent)
end

function Engine:enterArcanaTrial(stage_info, hero_list, arcanaTrialData, isbot, warschool, bookReadingLevel, battleBonus)
  if arcanaTrialData == nil then
    return
  end
  self:resetStage()
  if do_battle_log then
    logBeforeBt(hero_list, nil, warschool, bookReadingLevel, {battleBonus = battleBonus})
  end
  self.stage_info = stage_info
  self.mp_bonus = 1
  self.arcanaTrialMode = true
  self.arcanaStartProgress = arcanaTrialData.progress._progress
  self.arcanaHeroId = arcanaTrialData.progress._hero_id
  self.arcanaDamageBuffs = arcanaTrialData.damageBuffs
  self:initSelfHero(hero_list, isbot, warschool, bookReadingLevel, {battleBonus = battleBonus})
  self:dealPveBattleBonus(battleBonus)
  local battle = ed.lookupDataTable("Battle", nil, stage_info["Stage ID"], 1)
  local hpData
  if arcanaTrialData.progress._progress then
    hpData = {}
    local hpInfo = {}
    hpInfo._hp_perc = arcanaTrialData.progress._progress
    table.insert(hpData, hpInfo)
  end
  self:setupBattle(battle, hpData)
  self:initStageManager()
end

function Engine:getUnitDPSMod(unitId)
  if self.arcanaTrialMode then
    for _, v in pairs(self.arcanaDamageBuffs or {}) do
      if v.heroId == unitId then
        return 1 + v.ratio / 100
      end
    end
    return 1
  elseif self.campBossMode then
    local info = self:getCampBossDamageDefenceUpInfo(self.campBossId)
    for _, v in ipairs(info) do
      if v.heroId == unitId then
        return v.damageRatio / 100
      end
    end
    return 1
  else
    return 1
  end
end

function Engine:getUnitIMUMod(unitId)
  if self.campBossMode then
    local info = self:getCampBossDamageDefenceUpInfo(self.campBossId)
    for _, v in ipairs(info) do
      if v.heroId == unitId then
        return v.defenceRatio / 100
      end
    end
    return 1
  else
    return 1
  end
end

function Engine:enterCupArena(hero_list, enemy_list, warschool, bookReadingLevels, bonusInfo, isAudition)
  self:resetStage()
  if do_battle_log then
    logBeforeBt(hero_list, enemy_list, warschool, bookReadingLevels, bonusInfo)
  end
  self.battleBOType = isAudition and 5 or 7
  self.cupArena_mode = true
  self.stage_info = ed.lookupDataTable("Stage", -1)
  self.hero_list = hero_list
  self.sortHeroList(hero_list)
  self.sortHeroList(enemy_list)
  self.wave_id = 1
  self:initHeroInfo(hero_list, false, enemy_list)
  self.mp_bonus = 1
end

function Engine:getMythBossStageSkillIdsByStageId(stageId)
  local tbl = ed.getDataTable("MythBoss")
  for k, v in pairs(tbl) do
    if type(v) == "table" and stageId == v["Stage ID"] then
      return v.StageSkill_AN
    end
  end
  return {}
end

function Engine:enterMythBoss(stage_info, hero_list, isbot, warschool, bookReadingLevel, battleBonus)
  self:resetStage()
  if do_battle_log then
    logBeforeBt(hero_list, nil, warschool, bookReadingLevel, {battleBonus = battleBonus})
  end
  self.stage_info = stage_info
  local stageId = stage_info["Stage ID"]
  self.mp_bonus = 1
  self.mythBossMode = true
  self:initSelfHero(hero_list, isbot, warschool, bookReadingLevel, {battleBonus = battleBonus})
  self:dealPveBattleBonus(battleBonus)
  local battle = ed.lookupDataTable("Battle", nil, stageId, 1)
  self:setupBattle(battle)
  local ids = self:getMythBossStageSkillIdsByStageId(stageId)
  local id = ids[1]
  self:initStageManager(id)
end

function Engine:getCampBossDamageDefenceUpInfo(bossId)
  local row = ed.getDataTable("FiveBossBoss")[bossId]
  local heroes = row["Bonus Hero"]
  local _ratioATK = row["ATK Bonus Ratio"]
  local _ratioDEF = row["DEF Bonus Ratio"]
  local r = {}
  for k, v in ipairs(heroes) do
    local _ratioATK = 100 + math.floor(_ratioATK)
    local _ratioDEF = 100 + math.floor(_ratioDEF)
    table.insert(r, {
      heroId = v,
      damageRatio = _ratioATK,
      defenceRatio = _ratioDEF
    })
  end
  return r
end

function Engine:enterCampBoss(stage_info, hero_list, isbot, warschool, bookReadingLevel, bossId, battleBonus)
  local startWaveId = 1
  self:resetStage()
  if do_battle_log then
    logBeforeBt(hero_list, nil, warschool, bookReadingLevel, {battleBonus = battleBonus})
  end
  self.stage_info = stage_info
  local stageId = stage_info["Stage ID"]
  self.wave_id = 1
  self.campBossMode = true
  self.campBossId = bossId
  self.mp_bonus = self.stage_info["MP Bonus"]
  local battle = ed.lookupDataTable("Battle", nil, stageId, startWaveId)
  self:initSelfHero(hero_list, isbot, warschool, bookReadingLevel, {battleBonus = battleBonus})
  self:dealPveBattleBonus(battleBonus)
  self:setupBattle(battle)
  self:initStageManager()
end

function Engine:enterFancyTower(stage_info, hero_list, isbot, warschool, bookReadingLevel, battleFloorInfo, battleBonus)
  if do_battle_log then
    logBeforeBt(hero_list, nil, warschool, bookReadingLevel, {battleBonus = battleBonus})
  end
  self:resetStage()
  self.stage_info = stage_info
  local stageId = stage_info["Stage ID"]
  self.wave_id = 1
  self.fancyTowerMode = true
  self.fancyTowerFloorInfo = battleFloorInfo
  self.trigger1 = battleFloorInfo.trigger1
  self.trigger2 = battleFloorInfo.trigger2
  self.trigger3 = battleFloorInfo.trigger3
  self.mp_bonus = 1
  local battle = ed.lookupDataTable("FancyTowerBattle", nil, stageId, self.wave_id)
  self:initSelfHero(hero_list, isbot, warschool, bookReadingLevel, {battleBonus = battleBonus})
  self:dealPveBattleBonus(battleBonus)
  self:setupBattle(battle)
  self:initStageManager()
end

function Engine:enterFancyAbyss(stage_info, hero_list, isbot, bonus)
  if do_battle_log then
    logBeforeBt(hero_list, nil, nil, 0, {battleBonus = bonus})
  end
  self:resetStage()
  self.stage_info = stage_info
  local stageId = stage_info["Stage ID"]
  self.wave_id = 1
  self.fancyAbyssMode = true
  self.mp_bonus = 1
  local battle = ed.lookupDataTable("FancyAbyssBattle", nil, stageId, self.wave_id)
  self:initSelfHero(hero_list, isbot, nil, 0, {battleBonus = bonus})
  self:setupBattle(battle)
  self:initStageManager()
end

function Engine:enterActivityAdventure(stage_info, hero_list, isbot, warschool, bookReadingLevel, battleBonus, param)
  if do_battle_log then
    logBeforeBt(hero_list, nil, warschool, bookReadingLevel, {battleBonus = battleBonus})
  end
  self:resetStage()
  self.stage_info = stage_info
  local stageId = stage_info["Stage ID"]
  self.wave_id = 1
  self.mp_bonus = 1
  self.activityAdventureMode = true
  self.difficultyRatio = param.difficultyRatio
  local battle = ed.lookupDataTable("ActivityAdventureBattle", nil, stageId, self.wave_id)
  self:initSelfHero(hero_list, isbot, warschool, bookReadingLevel, {battleBonus = battleBonus})
  self:dealPveBattleBonus(battleBonus)
  self:setupBattle(battle)
  self:initStageManager()
end

function Engine:enterHadesHeat(stage_info, hero_list, isbot, warschool, bookReadingLevel, battleBonus, param)
  if do_battle_log then
    logBeforeBt(hero_list, nil, warschool, bookReadingLevel, {battleBonus = battleBonus})
  end
  self:resetStage()
  self.stage_info = stage_info
  local stageId = stage_info["Stage ID"]
  self.wave_id = 1
  self.mp_bonus = 1
  self.hadesMode = true
  local chooseHeat = param.chooseHeat or {}
  self.hadesGroupId = param.groupId
  local echoId = param.echoId
  self.difficultyRatio = param.difficultyRatio
  self.activeHeat = {}
  local activeHeatIdList = ed.getDataTable("HeatGroup")[self.hadesGroupId]["Heat Active"] or {}
  for _, heatData in ipairs(chooseHeat) do
    if ed.isElementInTable(heatData._heat_id, activeHeatIdList) then
      table.insert(self.activeHeat, {
        _heat_id = heatData._heat_id,
        _times = heatData._times
      })
    end
  end
  if echoId and 0 < echoId then
    self.echoSkillMgr = ed.echoSkillMgr.create({echoId = echoId})
  end
  local battle = ed.lookupDataTable("HeatBattle", nil, stageId, self.wave_id)
  self:initSelfHero(hero_list, isbot, warschool, bookReadingLevel, {battleBonus = battleBonus})
  self:dealPveBattleBonus(battleBonus)
  self:setupBattle(battle)
  self:initStageManager()
end

function Engine:enterAwakeStage(stage_info, hero_list, isbot, awakeStageBuff, awakeStageBonus)
  if do_battle_log then
    logBeforeBt(hero_list, nil, nil, 0, {})
  end
  self:resetStage()
  self.stage_info = stage_info
  local stageId = stage_info["Stage ID"]
  self.wave_id = 1
  self.mp_bonus = 1
  self.awakeStageMode = true
  self.awakeStageBuff = awakeStageBuff
  self.awakeStageBonus = awakeStageBonus
  local battle = ed.lookupDataTable("DungeonBattle", nil, stageId, self.wave_id)
  self:initSelfHero(hero_list, isbot, nil, 0, {
    awakeStageBonus = awakeStageBonus,
    rank_limit = stage_info["Rank Limit"],
    ignore_equip = 0 < stage_info["Rank Limit"],
    ignore_legend_equip = stage_info["Ignore LegendEquip"]
  })
  self:setupBattle(battle)
  if stage_info["Scrolls Waves"] then
    self.supplied = true
  end
  self:initBattleDataCollect()
  self:initSpecialCondition(self.stage_info["Condition Group"])
  self:initStageManager()
end

function Engine:enterCampTower(stage_info, hero_list, isbot, warschool, bookReadingLevel, battleFloorInfo, battleBonus)
  if do_battle_log then
    logBeforeBt(hero_list, nil, warschool, bookReadingLevel, {battleBonus = battleBonus})
  end
  self:resetStage()
  self.stage_info = stage_info
  local stageId = stage_info["Stage ID"]
  self.wave_id = 1
  self.campTowerMode = true
  self.campTowerFloorInfo = battleFloorInfo
  self.mp_bonus = self.stage_info["MP Bonus"]
  local battle = ed.lookupDataTable("Battle", nil, stageId, self.wave_id)
  self:initSelfHero(hero_list, isbot, warschool, bookReadingLevel, {battleBonus = battleBonus})
  self:dealPveBattleBonus(battleBonus)
  self:setupBattle(battle)
  self:initStageManager()
end

function Engine:enterRogueBattle(stage_info, hero_list, param)
  if do_battle_log then
    logBeforeBt(hero_list, nil, nil, nil, {battleBonus = nil})
  end
  self:resetStage()
  self.stage_info = stage_info
  local stageId = stage_info["Stage ID"]
  self.wave_id = 1
  self.mp_bonus = 1
  self.rogue_mode = true
  local destinyId = param.destinyId
  local destinyEnergy = param.destinyEnergy / 10000
  local blessList = param.blessList
  local charmList = param.charmList
  local techIdList = param.techIdList
  local chapterDiff = param.chapterDiff
  local crisisDiff = param.crisisDiff
  local chapterId = param.chapterId
  local dynaStart = param.dynaStart
  local rogueWave = param.rogueWave
  self.rogueChapterBattleInfo = {
    chapterId = chapterId,
    chapterDiff = chapterDiff,
    crisisDiff = crisisDiff
  }
  local techTreeId = ed.getDataTable("RogueChapter")[chapterId][chapterDiff]["Tech Tree ID"]
  self:disableHPSAndMPS()
  local heroDyna = {}
  for _, rogueHeroInfo in ipairs(dynaStart or {}) do
    heroDyna[rogueHeroInfo._heroid] = {
      _hp_perc = rogueHeroInfo._hp_perc,
      _mp_perc = rogueHeroInfo._mp_perc,
      _custom_data = rogueHeroInfo._custom_data
    }
  end
  local battle = ed.lookupDataTable("RogueBattle", nil, stageId, self.wave_id)
  self.sortHeroList(hero_list)
  self.rogueTechBonus = {}
  for index, techId in ipairs(techIdList or {}) do
    local rogueTechCfg = ed.getDataTable("RogueTech")[techTreeId][techId]
    table.insert(self.rogueTechBonus, ed.copyTable(rogueTechCfg))
  end
  self:initHeroInfo(hero_list, nil, {}, nil, heroDyna, nil, nil, {
    rogueTechBonus = self.rogueTechBonus
  })
  local rogueChapterId = stage_info["RogueChapter ID"]
  if rogueChapterId == 999 then
    rogueChapterId = chapterId
  end
  local rogueDiffCfg = ed.getDataTable("RogueDiff")[rogueChapterId]
  local stageType = stage_info["Stage Type"]
  local levelBonus
  if stageType == "NormalBattle" then
    levelBonus = rogueDiffCfg["Normal Level"] + rogueDiffCfg["Normal Diff Step"] * (chapterDiff - 1)
  elseif stageType == "EliteBattle" then
    levelBonus = rogueDiffCfg["Elite Level"] + rogueDiffCfg["Elite Diff Step"] * (chapterDiff - 1)
  elseif stageType == "ExEliteBattle" then
    levelBonus = rogueDiffCfg["ExElite Level"] + rogueDiffCfg["ExElite Diff Step"] * (chapterDiff - 1)
  elseif stageType == "BossBattle" then
    levelBonus = rogueDiffCfg["Boss Level"] + rogueDiffCfg["Boss Diff Step"] * (chapterDiff - 1)
  end
  self.rogueLevelBonusCfg = ed.getDataTable("RogueLevelBonus")[levelBonus]
  self.rogueWaveBonusCfg = ed.getDataTable("RogueWaveBonus")[rogueWave]
  self:setupBattle(battle)
  self.rogueSkillMgr = ed.rogueSkillMgr.create({
    rogueRevelationId = destinyId,
    rogueRevelationEnergy = destinyEnergy,
    blessList = blessList,
    charmList = charmList,
    rogueTechTreeId = techTreeId,
    rogueTechIdList = techIdList
  })
  self.rogueSkillMgr:init()
end

function Engine:getSelfFinalHpPercent()
  local selfHpInfo = {}
  for i, v in ipairs(self.hero_id_list) do
    for _, unit in ipairs(self.unit_list) do
      if unit.config.is_summoned ~= true and unit.camp == ed.emCampPlayer and unit.tid == v then
        selfHpInfo[i] = unit.hp * 10000 / unit.attribs.HP
      end
    end
  end
  return selfHpInfo
end

function Engine:geEenemyFinalHpPercent()
  local percent = 0
  local sumHp = 0
  local sumTotalHp = 0
  for i, unit in ipairs(self.unit_list) do
    if unit.config.is_summoned ~= true and unit.camp == ed.emCampEnemy and unit.monster_idx then
      sumHp = sumHp + unit.hp
      sumTotalHp = sumTotalHp + unit.attribs.HP
    end
  end
  percent = sumHp / sumTotalHp
  return percent
end

function Engine:enterGuildMountBoss(stage_info, hero_list, isbot, guildMountBoss, warschool, bookReadingLevel, battleBonus)
  if guildMountBoss == nil then
    return
  end
  local startWaveId = 1
  self:resetStage()
  if do_battle_log then
    logBeforeBt(hero_list, nil, warschool, bookReadingLevel, {battleBonus = battleBonus})
  end
  self.stage_info = stage_info
  local stageId = stage_info["Stage ID"]
  self.wave_id = 1
  self.guildMountBossMode = true
  self.mp_bonus = self.stage_info["MP Bonus"] or 1
  local battle = ed.lookupDataTable("Battle", nil, stageId, startWaveId)
  self:initSelfHero(hero_list, isbot, warschool, bookReadingLevel, {battleBonus = battleBonus})
  self:dealPveBattleBonus(battleBonus)
  local hpData
  if guildMountBoss then
    self.guildMountBossId = guildMountBoss.id
  end
  self:setupBattle(battle, hpData)
  self:initStageManager()
end

function Engine:enterSeasonArena(hero_list, enemy_list, self_dyna, oppo_dyna, warschool, bookReadingLevels, trigger_buf, bonusInfo)
  print("Enter Season Arena")
  self:resetStage()
  if do_battle_log then
    logBeforeBt(hero_list, enemy_list, warschool, bookReadingLevels, bonusInfo)
  end
  self.seasonArena_mode = true
  self.stage_info = ed.lookupDataTable("Stage", -1)
  self.hero_list = hero_list
  self.sortHeroList(hero_list)
  self.sortHeroList(enemy_list)
  self.wave_id = 1
  self:initHeroInfo(hero_list, false, enemy_list, false, self_dyna, oppo_dyna, nil, warschool, bookReadingLevels, bonusInfo)
  self:dealPvpBattleBonusInfo(bonusInfo)
  self.mp_bonus = 1
end

function Engine:addPeakArenaBuff(key)
  if not key then
    return
  end
  local info = ed.getDataTable("PeakArenaBuff")[key] or {}
  for k, unit in pairs(self.unit_list) do
    if ed.isElementInTable(unit.tid, info["Unit ID"] or {}) then
      local buffInfo = ed.getDataTable("Buff")[info["Buff ID"]]
      local buff = ed.BuffCreate(buffInfo, unit, unit, {})
      unit:addBuff(buff, unit)
    end
  end
end

function Engine:enterPeakArena(hero_list, enemy_list, roundIdx, seasonBuffKey)
  self:resetStage()
  if do_battle_log then
    logBeforeBt(hero_list, enemy_list, nil, 0, nil)
  end
  self.roundIdx = roundIdx
  self.peakArena_mode = true
  self.stage_info = ed.lookupDataTable("Stage", -1)
  self.hero_list = hero_list
  self.sortHeroList(hero_list)
  self.sortHeroList(enemy_list)
  self.wave_id = 1
  self:initHeroInfo(hero_list, false, enemy_list, false, nil, nil, nil, nil, 0, nil)
  self.peakAreanSkillId = seasonBuffKey
  self:initStageManager()
  self.mp_bonus = 1
end

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

function Engine:enterCreviceDefend(stage_info, hero_list, params)
  params = params or {}
  self:resetStage()
  self.crevicedefend_mode = true
  self.myth_mode = "crevicedefend"
  self.stage_info = stage_info
  self.wave_id = 1
  local battle = ed.lookupDataTable("CreviceDefendBattle", nil, params.stageid, 1)
  local battleBonus = params.battleBonus
  if do_battle_log then
    logBeforeBt(hero_list, nil, nil, 0, params)
  end
  local param = {stageType = "dreamland", battleBonus = battleBonus}
  self.custom_data_battle = battle
  for i = 1, #hero_list do
    local proto = hero_list[i]
    local config = {
      estimate_rank = false,
      estimate_skill = false,
      estimate_max_rank = false
    }
    local hero = ed.UnitCreate(proto, ed.emCampPlayer, config, nil, nil, 0, battleBonus, {
      awakeStageBonus = param.awakeStageBonus
    })
    hero.ai.will_cast_manual_skill = true
    self:addUnit(hero)
    hero.position = {
      initial_position[i][1],
      initial_position[i][2]
    }
    table.insert(self.hero_id_list, proto._tid)
  end
  self:dealPveBattleBonus(battleBonus)
  self:setupBattle(battle)
  if params.stageBuff then
    self:initStageManager(params.stageBuff)
  end
  self.mp_bonus = self.stage_info["MP Bonus"]
  if params.replayMode then
    self.replayMode = true
  end
end

function Engine:dealPveBattleBonus(battleBonus)
end

function Engine:dealPvpBattleBonus(selfBonus, oppoBonus)
end

function Engine:dealPvpBattleBonusInfo(bonusInfo)
end

function Engine:dealMpBattleBonusInfos(bonusInfos)
end
