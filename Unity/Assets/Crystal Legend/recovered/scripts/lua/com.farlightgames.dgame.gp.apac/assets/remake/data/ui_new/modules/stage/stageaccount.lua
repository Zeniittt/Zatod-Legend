local class = newclass({__index = _G})
ed.ui.stageaccount = class
setfenv(1, class)
stageCsvName = "Stage"
battleCsvName = "Battle"

function initialize(param)
  local param = param
  local battleParam = ed.battleDataCache or {}
  ed.battleDataCache = nil
  param.gwMode = battleParam.gwMode
  param.actType = battleParam.actType
  param.heroLimit = battleParam.heroLimit
  param.bestRankReward = param.bestRankReward
  param.isPveMode = param.isPveMode or false
  param.breakHistory = param.breakHistory or false
  stageCsvName = param.stageCsvName or "Stage"
  battleCsvName = param.battleCsvName or "Battle"
  print("stageCsvName", stageCsvName, "battleCsvName", battleCsvName)
  if param.victory then
    if param.isGuildRaid then
      ed.ui.GuildRaidVictoryWin.create(param)
      return
    end
    dealVictoryParam(param)
    if param.isArenaMode and not param.isShareFight then
      ed.ui.pvpBattleVictoryWin.create(param)
    elseif param.dreamland_data then
      ed.ui.dreamLandBattleResult.create(param)
    elseif param.guildMountBossData then
      if param.practice then
        ed.ui.GuildMountPracticeBattleEndWin.create(param.guildMountBossData)
      else
        ed.ui.GuildMountBattleEndWin.create(param.guildMountBossData)
      end
    else
      ed.ui.commonBattleWin.create(param)
    end
  else
    dealLoseParam(param)
    ed.ui.commonBattleFail.create(param)
  end
end

function dealLoseParam(param)
  if param.excavate_mode or param.mode == "nian" then
    local sid = param.stage_id
    local st = ed.getDataTable(stageCsvName)
    local row = st[sid]
    param.exp = row["Exp Reward"]
    local info = {
      exp = ed.player:getExp(),
      addExp = param.exp,
      maxExp = ed.getDataTable("PlayerLevel")[ed.player:getLevel()].Exp,
      level = ed.player:getLevel()
    }
    param.playerInfo = getPlayerInfo(info)
  end
end

function dealVictoryParam(param)
  local sid = param.stage_id
  print("dealVictoryParam.stageCsvName", stageCsvName)
  local st = ed.getDataTable(stageCsvName)
  local row = st[sid]
  param.isKeyStage = row["Key Stage"]
  param.chapter = row["Chapter ID"]
  param.exp = row["Exp Reward"] or 0
  param.gold = param.guildInstanceData and param.guildInstanceData.gold or row["Money Reward"]
  local result = 1
  param.exp = param.exp * result
  local loots = {}
  for i, v in ipairs(param.loots or {}) do
    if loots[v.id] then
      loots[v.id].amount = loots[v.id].amount + 1
    else
      local amount = v.amount or 1
      loots[v.id] = {
        amount = amount,
        type = v.type
      }
    end
  end
  param.lootList = loots
  local totalExp
  if sid == -1 then
    totalExp = ed.getDataTable("PlayerLevel")[ed.player:getLevel()]["Arena Hero Exp"]
  else
    totalExp = row["Heroexp Reward"]
  end
  local heroExp = math.floor(totalExp / #param.heroes)
  param.totalExp = totalExp
  param.heroExp = heroExp
  local heroes = {}
  for i, v in ipairs(param.heroes) do
    local isMercenary
    if param.mercenaryInfo and param.mercenaryInfo.index == i then
      isMercenary = true
    end
    heroes[i] = getHeroInfo(param, v, heroExp, isMercenary)
  end
  param.heroes = heroes
  local info = {
    exp = ed.player:getExp(),
    addExp = param.exp,
    maxExp = ed.getDataTable("PlayerLevel")[ed.player:getLevel()].Exp,
    level = ed.player:getLevel()
  }
  param.playerInfo = getPlayerInfo(info)
end

ed.dealVictoryParam = dealVictoryParam

function getHeroInfo(param, id, heroExp, isMercenary)
  local unitLevel = ed.getDataTable("Levels")
  local hero
  if isMercenary then
    hero = ed.GuildManager:getMercenaryHero(param.mercenaryInfo.data._uid, id)
  elseif param.mode == "real_arena" then
    hero = ed.realarena.hero_mgr:getHeroByIDWithEmploy(id)
  else
    hero = ed.player.heroes[id]
  end
  local id = hero._tid
  local hc = (ed.player.heroCache or {})[id] or {}
  local exp = hero._exp or 0
  local level = hero._level
  local maxExp = unitLevel[level].Exp
  local rank = hero._rank
  local preExp = isMercenary == true and exp or hc.preExp or 0
  local preLevel = isMercenary == true and level or hc.preLevel or 0
  local addExp = isMercenary == true and 0 or hc.expIncrement or 0
  local preMaxExp
  if preLevel and unitLevel[preLevel] then
    preMaxExp = unitLevel[preLevel].Exp
  else
    preMaxExp = unitLevel[level].Exp
  end
  if ed.IsMultiArena() or ed.engine.multistageTeamwork_mode or ed.engine.activityAdventureMode or ed.engine.awakeStageMode then
    preLevel = level
  end
  local isMaxLevel = false
  if level >= ed.playerlimit.heroLevelLimit() and exp >= maxExp then
    isMaxLevel = true
  end
  local addHeroExp = isMercenary == true and 0
  addHeroExp = addHeroExp or param.noExp and 0 or heroExp
  return {
    id = id,
    rank = rank,
    level = preLevel,
    exp = preExp,
    maxExp = preMaxExp,
    tLevel = level,
    tExp = exp,
    tMaxExp = maxExp,
    isMaxLevel = isMaxLevel,
    hp = hero:hp_perc(),
    mp = hero:mp_perc(),
    addExp = addExp,
    addHeroExp = addHeroExp or 0,
    bMercenary = isMercenary,
    hero_proto = hero
  }
end

ed.getHeroInfo = getHeroInfo

function getPlayerInfo(info)
  local pt = ed.getDataTable("PlayerLevel")
  if ed.player.teamAlreadyMaxLevel then
    info.addExp = 0
  end
  local exp = info.exp
  local addExp = info.addExp
  local level = info.level
  local maxExp = info.maxExp
  local cExp = exp
  local cLevel = level
  local cAddExp = addExp
  local animList = {}
  while cExp < cAddExp do
    table.insert(animList, 1, {
      be = 0,
      ee = cExp,
      len = pt[cLevel].Exp,
      lv = cLevel
    })
    cAddExp = cAddExp - cExp
    if pt[cLevel - 1] == nil then
      break
    end
    cLevel = cLevel - 1
    cExp = pt[cLevel].Exp
  end
  table.insert(animList, 1, {
    be = cExp - cAddExp,
    ee = cExp,
    len = pt[cLevel].Exp,
    lv = cLevel
  })
  cExp = cExp - cAddExp
  return {
    oriExp = cExp,
    oriLevel = cLevel,
    oriMaxExp = pt[cLevel].Exp,
    exp = exp,
    level = level,
    addExp = addExp,
    maxExp = maxExp,
    animList = animList
  }
end

ed.getPlayerInfo = getPlayerInfo

function getBattleBgRes(stage)
  local level = ed.getDataTable(battleCsvName)[stage]
  local waves = ed.getDataTable(stageCsvName)[stage].Waves
  local res = level[waves]["Background Pic"]
  return "UI/alpha/HVGA/" .. res
end

function getStageVitalityCost(stage)
  local row = ed.getDataTable(stageCsvName)[stage]
  if row then
    return row["Vitality Cost"]
  end
  return 0
end

function getLoseTitleRes(loseType)
  if loseType == "timeout" then
    return "UI/alpha/1080P/battleresult/timeout.png"
  elseif loseType == "over" then
    return "UI/alpha/HVGA/task_complete_title.png"
  elseif loseType == "assassinate" then
    return "UI/alpha/HVGA/gvg/gvg_ass_failure.png"
  else
    return false
  end
end
