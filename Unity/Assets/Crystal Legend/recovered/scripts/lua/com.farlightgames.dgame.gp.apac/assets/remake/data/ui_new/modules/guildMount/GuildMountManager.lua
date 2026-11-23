local class = {}
class.__index = class

function class.getInstance()
  local self = {}
  setmetatable(self, class)
  self:initData()
  return self
end

function class:initData()
  self.endTime = 0
  self.season = 0
  self.state = "wait"
  self.bossIds = {}
  self.curBoss = nil
  self.level = 1
  self.playerRank = 0
  self.guildRank = 0
  self.round = 1
  self.allNum = 9
  self.leftNum = self.allNum
  self.challengeTimes = 0
  self.maxRequireTimes = 0
  local lineRewardTbl = ed.getDataTable("GuildMountLineReward")
  for k, v in ipairs(lineRewardTbl) do
    if v.RequireTimes > self.maxRequireTimes then
      self.maxRequireTimes = v.RequireTimes
    end
  end
  self.coins = 0
  self.rewardFlags = {}
  self.damageEvent = {}
  self.bossDamageList = {}
  self.playDamageMap = {}
  self.extraTime = nil
  self.bossInfo = {}
  self.battleUser = nil
  self.battleCount = 0
  self.topDamageInfo = nil
  self.redFlag = false
  self.isOpenPanel = false
  self.rankRewardWin = nil
  self.nextRoundFlag = false
  self.openBossId = -1
end

function class:getRankRewardWin()
  return self.rankRewardWin
end

function class:setRankRewardWin(winInstance)
  self.rankRewardWin = winInstance
end

function class:getBossIds()
  return self.bossIds
end

function class:getCurBoss()
  return self.curBoss
end

function class:setCurBoss(boss)
  self.curBoss = boss
end

function class:getCurBossRound()
  return ed.lookupDataTable("GuildMountBoss", "Appear Days", self.bossIds[1])
end

function class.getBossRoundById(bossId)
  return ed.lookupDataTable("GuildMountBoss", "Appear Days", bossId)
end

function class:setRank(rank)
  self.guildRank = type(rank) == "number" and rank or self.guildRank
end

function class:getGuildRank()
  return self.guildRank
end

function class:getPlayerRank()
  return self.playerRank
end

function class:getZoneId()
  return self.zoneId
end

function class:getLeftChallengeNum()
  return self.leftNum
end

function class:setDisplayTid(tid)
  self.displayTid = tid
end

function class:getDisplayTid()
  return self.displayTid or 1
end

function class:setLeftChallengeNum(times)
  self.leftNum = times or self.leftNum
end

function class:getAllChallengeNum()
  return self.allNum
end

function class:getChallengeTimes()
  return self.challengeTimes
end

function class:addChallengeTimes()
  self.challengeTimes = self.challengeTimes + 1
end

function class:setChallengeTimes(times)
  self.challengeTimes = times
end

function class:getMaxRequireTimes()
  return self.maxRequireTimes
end

function class:isGetLineReward(id)
  return ed.isElementInTable(id, self.rewardFlags)
end

function class:getAttackPlayer()
  return self.battleUser
end

function class:getDamageEvent()
  return self.damageEvent
end

function class:getBossDamageList()
  return self.bossDamageList
end

function class:updateBoss(toHealth)
  if type(toHealth) == "number" then
    local curBoss = self:getCurBoss()
    curBoss._health = toHealth
    if curBoss._health <= 0 then
      FireEvent("EventGuildMountBossDead")
      self.nextRoundFlag = true
    end
  end
end

function class:resetNextRoundFlag()
  self.nextRoundFlag = false
end

function class:getNextRoundFlag()
  return self.nextRoundFlag
end

function class:getExtraTime()
  return self.extraTime
end

function class:setRedFlag(flag)
  self.redFlag = flag and self:isOpen()
  FireEvent("MainBuildRedTagChange", ed.ui.configs.mainSceneMap.builddingType.Guild)
  FireEvent("MainRedTagChange", ed.ui.configs.mainButton.ButtonType.GUILD_MOUNT)
end

function class:getRedFlag()
  return self.redFlag
end

function class:setPullTime()
  self.pullTime = ed.getServerTime()
end

function class:getPullTime()
  return self.pullTime or 0
end

function class:resetOpenPanel()
  self.isOpenPanel = false
end

function class:isHeroUsed(id)
  if type(self.usedHeroList) == "table" then
    return ed.isElementInTable(id, self.usedHeroList)
  end
  return false
end

function class:refreshUsedHeroList(ids)
  if type(ids) == "table" then
    for _, v in ipairs(ids) do
      table.insert(self.usedHeroList, v)
    end
  end
end

function class:isOffSeason()
  return self.season == 0 or not self:isOpen()
end

function class:getState()
  return self.state
end

function class:setState(state)
  self.state = state
  if state ~= "open" then
    self:setRedFlag(false)
  end
end

function class:getSeason()
  return self.season
end

function class:getSeasonEnd()
  local season = ed.GuildMountManager:getSeason() or 1
  local seasonData = ed.getDataTable("GuildMountSeason")[season]
  if seasonData then
    return ed.time2dhms(ed.dateStringToTime(seasonData["End Time"]) - ed.getFitServerTime()), ed.dateStringToServerTime(seasonData["End Time"])
  end
  return 0, 0
end

function class:isStageOpen()
  return true
end

function class:enterBattlePrepare(bossId)
  if ed.player:getGuildId() == 0 then
    ed.showToast(T("\232\175\183\229\133\136\229\138\160\229\133\165\229\133\172\228\188\154"))
    return
  end
  self.prepareBossId = nil
  local leftTimes = self:getLeftChallengeNum()
  if not ed.GuildMountManager:getExtraTime() and leftTimes <= 0 then
    ed.showToast(T("\228\187\138\230\151\165\230\140\145\230\136\152\230\172\161\230\149\176\229\183\178\231\148\168\229\174\140"))
    return
  end
  local isStageOpen, notOpenReason = self:isStageOpen()
  if not isStageOpen then
    ed.showToast(notOpenReason)
    return
  end
  local bossTblData = ed.getDataTable("GuildMountBoss")[bossId]
  local guildMountMercenary = ed.GuildManager.guildMountMercenary
  local puppetId = ed.getUnitPuppet(bossTblData["Unit ID"])
  local colors = 0 >= self.leftNum and "dreamland_red" or "dreamland_white"
  local str = string.format("<text|%s|%s><text|dreamland_white|/><text|dreamland_white|%s>", colors, self.leftNum, self.allNum)
  ed.pushScene(ed.ui.battleprepare.create({
    stage_id = bossTblData["Stage ID"],
    mode = "GuildMountBoss",
    hireMercenary = guildMountMercenary,
    objData = {
      modTxt = {
        name = bossTblData["Boss Name"],
        fca = puppetId
      },
      monsSkil = {
        skli = bossTblData["Boss Desc"],
        chance = str
      },
      monsBuff = {
        name = bossTblData["Buff Name"],
        desc = bossTblData["Buff Dec"]
      },
      bossTblData = bossTblData
    }
  }))
end

function class:enterPracticeBattlePrepare(bossId)
  if ed.player:getGuildId() == 0 then
    ed.showToast(T("\232\175\183\229\133\136\229\138\160\229\133\165\229\133\172\228\188\154"))
    return
  end
  local isStageOpen, notOpenReason = self:isStageOpen()
  if not isStageOpen then
    ed.showToast(notOpenReason)
    return
  end
  self.prepareBossId = bossId
  local bossTblData = ed.getDataTable("GuildMountBoss")[bossId]
  local guildMountMercenary = ed.GuildManager.guildMountMercenary
  local puppetId = ed.getUnitPuppet(bossTblData["Unit ID"])
  local colors = 0 >= self.leftNum and "dreamland_red" or "dreamland_white"
  local str = string.format("<text|%s|%s><text|dreamland_white|/><text|dreamland_white|%s>", colors, self.leftNum, self.allNum)
  ed.pushScene(ed.ui.battleprepare.create({
    stage_id = bossTblData["Stage ID"],
    mode = "GuildMountBoss",
    hireMercenary = guildMountMercenary,
    objData = {
      practice = true,
      modTxt = {
        name = bossTblData["Boss Name"],
        fca = puppetId
      },
      monsSkil = {
        skli = bossTblData["Boss Desc"],
        chance = str
      },
      monsBuff = {
        name = bossTblData["Buff Name"],
        desc = bossTblData["Buff Dec"]
      },
      bossTblData = bossTblData
    }
  }))
end

function class:enterBattlePrepareTest(bossId)
  local bossTblData = ed.getDataTable("GuildMountBoss")[bossId]
  local guildMountMercenary = ed.GuildManager.guildMountMercenary
  local puppetId = ed.getUnitPuppet(bossTblData["Unit ID"])
  local colors = self.leftNum <= 0 and "dreamland_red" or "dreamland_white"
  local str = string.format("<text|%s|%s><text|dreamland_white|/><text|dreamland_white|%s>", colors, self.leftNum, self.allNum)
  ed.pushScene(ed.ui.battleprepare.create({
    stage_id = bossTblData["Stage ID"],
    mode = "GuildMountBoss",
    hireMercenary = guildMountMercenary,
    objData = {
      test = true,
      modTxt = {
        name = bossTblData["Boss Name"],
        fca = puppetId
      },
      monsSkil = {
        skli = bossTblData["Boss Desc"],
        chance = str
      },
      monsBuff = {
        name = bossTblData["Buff Name"],
        desc = bossTblData["Buff Dec"]
      },
      bossTblData = bossTblData
    }
  }))
end

function class:requestBossStartBattle(heroIds, isHired)
  local boss = self:getCurBoss()
  if not boss then
    ed.showToast(T("Boss\228\191\161\230\129\175\229\188\130\229\184\184"))
  else
    self.isTestBattle = false
    self.practiceBattle = false
    ed.GuildMountNetwork:sendStartBattleBoss(boss._id, heroIds, isHired)
  end
end

function class:requestBossPracticeStartBattle()
  local boss = self:getCurBoss()
  if not boss then
    ed.showToast(T("Boss\228\191\161\230\129\175\229\188\130\229\184\184"))
  else
    self.practiceBattle = true
    self:handleStartPracticeBattleReply()
  end
end

function class:requestBossStartBattleTest(heroIds, isHired)
  self.isTestBattle = true
  local boss = self:getCurBoss()
  local bossInfo
  bossInfo = {}
  bossInfo.id = boss._id
  bossInfo.health = 10000
  self.battleBossInfo = bossInfo
  self:setCurBoss(boss)
  ed.stopMusic()
  ed.playEffect(ed.sound.deo.battle_begin)
  ed.battleshare.clearShareButton()
  local prepareInfo = self.battle_prepare_info
  local hero_list = {}
  for i, id in ipairs(prepareInfo.team) do
    local hero
    if i == prepareInfo.mercenary_index then
      hero = ed.GuildManager:getMercenaryHero(prepareInfo.mercenary_info.uid, id)
    else
      hero = ed.player:getHero(id)
    end
    table.insert(hero_list, hero)
  end
  local stageId = prepareInfo.stage_id
  local stage = ed.lookupDataTable("Stage", nil, stageId)
  local battle = ed.lookupDataTable("Battle", nil, stageId, 1)
  local battleBonus = ed.player:getBattleBonus()
  local seed = math.random(1, 9999)
  ed.srand(seed)
  ed.engine:enterGuildMountBoss(stage, hero_list, nil, bossInfo, nil, 0, battleBonus)
  local extra_info = {}
  extra_info.guildMountBossInfo = {}
  ed.scene:reset(stage, battle, extra_info)
  ed.replaceScene(ed.scene)
end

function class:requestBossEndBattle(result)
  if self.isTestBattle then
    ed.popScene()
  else
    local param = {}
    param.result = result
    local engine = ed.engine
    param.oprations = engine:getOprationList()
    param.damage = math.floor(engine:getPlayerTotalDamage(ed.emCampPlayer))
    param.bossId = engine.guildMountBossId
    param.hplist = engine:getSelfFinalHpPercent()
    if self.practiceBattle then
      ed.GuildMountNetwork:sendEndPracticeBattleBoss(param.bossId, param.damage)
    else
      ed.GuildMountNetwork:sendEndBattleBoss(param)
    end
  end
end

function class:handleBossErrorCode(data)
  ed.showToast(data)
end

function class:isOpen()
  return not ed.playerlimit.getAreaUnlockPrompt("GuildMount") and self.state ~= "wait"
end

function class:handleOpenPanelReply(data)
  self.season = data._season or 1
  self:setState(data._state)
  self.endTime = data._end_time or 0
  self.leftNum = data._left_battle_times or 0
  self.challengeTimes = data._acc_battle_times or 0
  self.rewardFlags = data._reward_flags or {}
  self.curBoss = data._boss or nil
  self.zoneId = data._zone_id or 0
  self.playerRank = data._player_rank or 0
  self.guildRank = data._guild_rank or 0
  self.usedHeroList = data._used_hero_list or {}
  self.leftExitTimes = data._left_exit_times or 0
  self.coins = data._coins or 0
  self.bossIds = data._boss_list or {}
  if data._season and data._season > 0 then
    if not self.isOpenPanel then
      ed.pushScene(ed.ui.GuildMountMainScene.create())
      self.isOpenPanel = true
    else
      FireEvent("EventGuildMountOpenPanel")
    end
  else
    ed.showToast(T("\232\181\155\229\173\163\230\156\170\229\188\128\229\144\175"))
  end
end

function class:handleOpenBossReply(data)
  self.bossInfo = data._boss or {}
  self.battleUser = data._battling_user or nil
  self.battleCount = data._battling_count or 0
  self.topDamageInfo = data._top_damage or nil
  ed.GuildManager:setGuildMountMercenary(data._hire_hero)
  if data._boss then
    self:setCurBoss(data._boss)
  end
  if self.openBossId == -1 then
    FireEvent("GuildMountRefreshBossInfo")
  elseif self.openBossId ~= self.bossInfo._id then
    ed.showAlertDialog({
      text = T("\232\175\165boss\229\183\178\232\162\171\229\135\187\230\157\128\239\188\140\232\175\183\230\140\145\230\136\152\228\184\139\228\184\170boss"),
      buttonText = T("\231\161\174\229\174\154"),
      handler = function()
        FireEvent("GuildMountRefreshBossInfo")
      end
    })
  else
    FireEvent("GuildMountRefreshBossInfo")
    ed.ui.GuildMountDetailWin.create(self.bossInfo)
  end
end

function class:handleQueryDamageReply(data)
  self.bossDamageList = data._damages or {}
  FireEvent("EventGuildMountQueryDamage")
end

function class:handleStartBattleReply(data)
  ed.reportClientHUE({
    action_type = "guild_mount_battle_start"
  })
  local rseed = data._rseed or 0
  local curBoss = data._boss or {}
  local bossInfo
  bossInfo = {}
  bossInfo.id = curBoss._id
  self.battleBossId = curBoss._id
  bossInfo.duration = self.extraTime and self.extraTime._duration or nil
  self.battleBossInfo = bossInfo
  self:setCurBoss(curBoss)
  ed.stopMusic()
  ed.playEffect(ed.sound.deo.battle_begin)
  ed.battleshare.clearShareButton()
  local prepareInfo = self.battle_prepare_info
  local hero_list = {}
  for i, id in ipairs(prepareInfo.team) do
    local hero
    if i == prepareInfo.mercenary_index then
      hero = ed.GuildManager:getMercenaryHero(prepareInfo.mercenary_info.uid, id)
    else
      hero = ed.player:getHero(id)
    end
    table.insert(hero_list, hero)
  end
  local stageId = prepareInfo.stage_id
  local stage = ed.lookupDataTable("Stage", nil, stageId)
  local battle = ed.lookupDataTable("Battle", nil, stageId, 1)
  local battleBonus = ed.player:getBattleBonus()
  ed.srand(rseed)
  ed.engine:enterGuildMountBoss(stage, hero_list, nil, bossInfo, nil, 0, battleBonus)
  local extra_info = {}
  extra_info.guildMountBossInfo = {}
  ed.scene:reset(stage, battle, extra_info)
  ed.replaceScene(ed.scene)
end

function class:handleStartPracticeBattleReply()
  local boss = self:getCurBoss()
  local bossInfo
  bossInfo = {}
  bossInfo.id = self.prepareBossId or boss._id
  bossInfo.health = 10000
  self.battleBossInfo = bossInfo
  self:setCurBoss(boss)
  ed.stopMusic()
  ed.playEffect(ed.sound.deo.battle_begin)
  ed.battleshare.clearShareButton()
  local prepareInfo = self.battle_prepare_info
  local hero_list = {}
  for i, id in ipairs(prepareInfo.team) do
    local hero
    if i == prepareInfo.mercenary_index then
      hero = ed.GuildManager:getMercenaryHero(prepareInfo.mercenary_info.uid, id)
    else
      hero = ed.player:getHero(id)
    end
    table.insert(hero_list, hero)
  end
  local stageId = prepareInfo.stage_id
  local stage = ed.lookupDataTable("Stage", nil, stageId)
  local battle = ed.lookupDataTable("Battle", nil, stageId, 1)
  local battleBonus = ed.player:getBattleBonus()
  local seed = math.random(1, 9999)
  ed.srand(seed)
  ed.engine:enterGuildMountBoss(stage, hero_list, nil, bossInfo, nil, 0, battleBonus)
  local extra_info = {}
  extra_info.guildMountBossInfo = {practice = true}
  ed.scene:reset(stage, battle, extra_info)
  ed.replaceScene(ed.scene)
end

function class:handleBossEndBattleReply(data)
  ed.reportClientHUE({
    action_type = "guild_mount_battle_end"
  })
  FireEvent("EventGuildMountStageEnd")
  local checkId = data._checkid
  local battleResult = data._result
  if battleResult == "unknown" then
    ed.popScene()
    ListenTimer(Timer:Once(1), function()
      ed.showToast(T("\230\136\152\230\150\151\231\187\147\230\158\156\229\135\186\233\148\153\239\188\140\232\175\183\233\135\141\230\150\176\229\176\157\232\175\149"))
    end)
    if checkId and 0 < checkId and do_battle_log then
      ed.reportBattleLog(checkId, "guildMountBoss")
    end
    return
  end
  if battleResult == "canceled" then
    ed.showToast(T("\230\136\152\230\150\151\229\143\150\230\182\136"))
    return
  end
  if not self.extraTime then
    self:setLeftChallengeNum(math.max(0, self.leftNum - 1))
  end
  local rewards = data._rewards or {}
  self.challengeTimes = data._acc_battle_times or 0
  self.topDamageInfo = data._top_damage or self.topDamageInfo
  ed.player:addRewards(rewards or {})
  if data._add_coins and 0 < data._add_coins then
    self.coins = self.coins + data._add_coins
    FireEvent("ResourceNumChange", "guildmountpoint")
    table.insert(rewards, {
      _type = "guildmountpoint",
      _amount = data._add_coins
    })
  end
  local idlist = ed.engine.hero_id_list or {}
  for _, v in ipairs(idlist) do
    table.insert(self.usedHeroList, v)
  end
  local hero_list = {}
  local prepareInfo = self.battle_prepare_info
  for i, id in ipairs(prepareInfo.team) do
    local hero
    if i == prepareInfo.mercenary_index then
      hero = ed.GuildManager:getMercenaryHero(prepareInfo.mercenary_info.uid, id)
    else
      hero = ed.player:getHero(id)
    end
    table.insert(hero_list, hero)
  end
  local engine = ed.engine
  local stageId = engine.stage_info["Stage ID"]
  local guildMountBossData = {
    damage = data._damage or 0,
    score = data._add_score or 0,
    maxdamage = self.topDamageInfo and self.topDamageInfo._damage or 0,
    rewards = rewards,
    maxDamageUser = self.topDamageInfo and self.topDamageInfo._user_summary or nil,
    hero_list = hero_list,
    battleBossId = self.battleBossId,
    isNewRecord = data._is_new_record or 0
  }
  if false then
    ed.showAlertDialog({
      text = T("\232\175\165BOSS\229\183\178\232\162\171\229\133\182\228\187\150\231\142\169\229\174\182\229\135\187\230\157\128"),
      buttonText = T("\231\161\174\229\174\154"),
      handler = function()
        ed.popScene()
        FireEvent("EventGuildMountBossDead")
      end
    })
  else
    local args = {
      victory = true,
      stage_id = stageId,
      heroes = {},
      guildMountBossData = guildMountBossData
    }
    ListenTimer(Timer:Once(0.1), function()
      ed.ui.stageaccount.initialize(args)
    end)
  end
end

function class:handleBossEndPracticeBattleReply(data)
  if ed.GuildMountManager.battleCanceled then
    ed.showToast(T("\230\136\152\230\150\151\229\143\150\230\182\136"))
    ed.GuildMountManager.battleCanceled = nil
    return
  end
  local prepareInfo = self.battle_prepare_info
  local hero_list = {}
  for i, id in ipairs(prepareInfo.team) do
    local hero
    if i == prepareInfo.mercenary_index then
      hero = ed.GuildManager:getMercenaryHero(prepareInfo.mercenary_info.uid, id)
    else
      hero = ed.player:getHero(id)
    end
    table.insert(hero_list, hero)
  end
  local guildMountBossData = {
    damage = 0,
    score = data._add_score or 0,
    maxdamage = self.topDamageInfo and self.topDamageInfo._damage or 0,
    rewards = {},
    maxDamageUser = self.topDamageInfo and self.topDamageInfo._user_summary or nil,
    hero_list = hero_list
  }
  if (self.prepareBossId or 99) > ed.GuildMountManager:getCurBoss()._id then
    guildMountBossData.maxdamage = nil
    guildMountBossData.maxDamageUser = nil
  end
  local engine = ed.engine
  local stageId = engine.stage_info["Stage ID"]
  local args = {
    victory = true,
    practice = true,
    stage_id = stageId,
    heroes = {},
    guildMountBossData = guildMountBossData
  }
  ListenTimer(Timer:Once(0.1), function()
    ed.ui.stageaccount.initialize(args)
  end)
end

function class:handleGainRewardReply(data)
  table.insert(self.rewardFlags, data._index)
  local rewards = {}
  if data._add_coins then
    table.insert(rewards, {
      _amount = data._add_coins,
      _type = "guildmountpoint"
    })
    self.coins = self.coins + data._add_coins
  end
  FireEvent("EventGuildMountGainReward", data._index, rewards)
  FireEvent("ResourceNumChange", "guildmountpoint")
end

function class:handlePullEventReply(data)
  if data._damage_events then
    self.damageEvent = data._damage_events
    FireEvent("GuildMountDamageEvent", data._damage_events)
  end
  if data._enter_events then
    FireEvent("GuildMountEnterEvent", data._enter_events)
  end
end

function class:handleScoreRankReply(data)
  FireEvent("GuildMountMyGuildRank", data)
end

function class:handleZoneRankReply(data)
  FireEvent("GuildMountZoneRank", data)
end

function class:handleTodayScoreRankReply(data)
  FireEvent("GuildMountTodayMyGuildRank", data)
end

function class:handleQueryGoods(queryGoods)
  local shopTable = ed.getDataTable("GuildMountShop")
  self.shopList = {}
  local sellShort = {}
  for t, v in ipairs(queryGoods._goods or {}) do
    local groups = shopTable[v._group_id] or {}
    local shopData = groups[v._index]
    local amount = 999
    if v._max_buy_times and v._cur_buy_times then
      amount = v._max_buy_times - v._cur_buy_times
    end
    local items = {
      item = {
        id = shopData["Goods ID"],
        count = shopData["Goods Amount"],
        type = shopData["Goods Type"]
      },
      order = shopData["Order Number"],
      price = shopData["Goods Price"],
      priceType = "guildmountpoint",
      amountNew = v._cur_buy_times or 0,
      amountMax = v._max_buy_times or 1,
      index = v._index,
      zhe = shopData["Show Discount"],
      groupId = v._group_id
    }
    if amount <= 0 then
      table.insert(sellShort, items)
    else
      table.insert(self.shopList, items)
    end
  end
  table.sort(self.shopList, function(a, b)
    return a.order < b.order
  end)
  table.sort(sellShort, function(a, b)
    return a.order < b.order
  end)
  for _, v in ipairs(sellShort) do
    table.insert(self.shopList, v)
  end
  ed.UITool.openView("GuildMountShopScene")
end

function class:handleBuyGoods(buyGoods)
  ed.player:addRewards(buyGoods._rewards or {})
  for _, v in ipairs(self.shopList) do
    if v.groupId == buyGoods._group_id and v.index == buyGoods._goods_index then
      v.amountNew = buyGoods._cur_buy_times
    end
  end
  self.coins = buyGoods._left_coin
  FireEvent("GuildMountShopItemUpdate")
  FireEvent("ResourceNumChange", "guildmountpoint")
end

function class:handleChangeDisplay(data)
  if data == "success" then
    ed.showToast(T("\232\174\190\231\189\174\230\136\144\229\138\159"))
    FireEvent("GuildMountChangeDisplaySuccess")
  end
end

function class:getSeasonShopCoinID()
  return ed.getDataTable("GuildMountSeason")[self.season]["Shop Coin ID"]
end

function class:runDebugOpenPanel()
  self:handleOpenPanelReply({
    _season = 1,
    _state = "open",
    _end_time = ed.getServerTime() + 7200,
    _left_battle_times = 3,
    _acc_battle_times = 10,
    _reward_flags = {1},
    _boss = {_id = 1, _health = 100000},
    _guild_rank = 10
  })
end

function class:runDebugOpenBoss()
  self:handleOpenBossReply({
    _boss = {_id = 1, _health = 100000},
    _battling_user = {
      _name = "\232\141\137\228\184\155\228\188\166",
      _vip = 15,
      _uid = 203,
      _babel_level = 0,
      _avatar = 65537,
      _level = 100
    },
    _battling_count = 3,
    _top_damage = {
      _damage = 100000,
      _user_summary = {
        _name = "\232\141\137\228\184\155\228\188\166",
        _vip = 15,
        _uid = 203,
        _babel_level = 0,
        _avatar = 65537,
        _level = 100
      },
      _heroes = {
        {
          _tid = 10077,
          _rank = 6,
          _level = 10,
          _stars = 4
        },
        {
          _tid = 10078,
          _rank = 6,
          _level = 10,
          _stars = 4
        },
        {
          _tid = 10079,
          _rank = 6,
          _level = 10,
          _stars = 4
        },
        {
          _tid = 10080,
          _rank = 6,
          _level = 10,
          _stars = 4
        },
        {
          _tid = 10081,
          _rank = 6,
          _level = 10,
          _stars = 4
        }
      }
    }
  })
end

function class:runDebugPullEvent()
  self:handlePullEventReply({
    _events = {
      {
        _time = ed.getServerTime() - 7200,
        _boss_id = 2,
        _user_id = 1,
        _nick_name = "\232\141\137\228\184\155\232\189\174",
        _damage = 100000
      },
      {
        _time = ed.getServerTime() - 7200,
        _boss_id = 2,
        _user_id = 1,
        _nick_name = "\232\141\137\228\184\155\232\189\174",
        _damage = 100000
      },
      {
        _time = ed.getServerTime() - 7200,
        _boss_id = 2,
        _user_id = 1,
        _nick_name = "\232\141\137\228\184\155\232\189\174",
        _damage = 100000
      },
      {
        _time = ed.getServerTime() - 7200,
        _boss_id = 2,
        _user_id = 1,
        _nick_name = "\232\141\137\228\184\155\232\189\174",
        _damage = 100000
      }
    }
  })
end

function class:runDebugQueryDamage()
  self:handleQueryDamageReply({
    _damages = {
      {
        _damage = 100000,
        _user_summary = {
          _name = "\232\141\137\228\184\155\228\188\166",
          _vip = 15,
          _uid = 203,
          _babel_level = 0,
          _avatar = 65537,
          _level = 100
        },
        _heroes = {
          {
            _tid = 10077,
            _rank = 6,
            _level = 10,
            _stars = 4
          },
          {
            _tid = 10078,
            _rank = 6,
            _level = 10,
            _stars = 4
          },
          {
            _tid = 10079,
            _rank = 6,
            _level = 10,
            _stars = 4
          },
          {
            _tid = 10080,
            _rank = 6,
            _level = 10,
            _stars = 4
          },
          {
            _tid = 10081,
            _rank = 6,
            _level = 10,
            _stars = 4
          }
        }
      },
      {
        _damage = 100000,
        _user_summary = {
          _name = "\232\141\137\228\184\155\228\188\166",
          _vip = 15,
          _uid = 203,
          _babel_level = 0,
          _avatar = 65537,
          _level = 100
        },
        _heroes = {
          {
            _tid = 10077,
            _rank = 6,
            _level = 10,
            _stars = 4
          },
          {
            _tid = 10078,
            _rank = 6,
            _level = 10,
            _stars = 4
          },
          {
            _tid = 10079,
            _rank = 6,
            _level = 10,
            _stars = 4
          },
          {
            _tid = 10080,
            _rank = 6,
            _level = 10,
            _stars = 4
          },
          {
            _tid = 10081,
            _rank = 6,
            _level = 10,
            _stars = 4
          }
        }
      },
      {
        _damage = 100000,
        _user_summary = {
          _name = "\232\141\137\228\184\155\228\188\166",
          _vip = 15,
          _uid = 203,
          _babel_level = 0,
          _avatar = 65537,
          _level = 100
        },
        _heroes = {
          {
            _tid = 10077,
            _rank = 6,
            _level = 10,
            _stars = 4
          },
          {
            _tid = 10078,
            _rank = 6,
            _level = 10,
            _stars = 4
          },
          {
            _tid = 10079,
            _rank = 6,
            _level = 10,
            _stars = 4
          },
          {
            _tid = 10080,
            _rank = 6,
            _level = 10,
            _stars = 4
          },
          {
            _tid = 10081,
            _rank = 6,
            _level = 10,
            _stars = 4
          }
        }
      },
      {
        _damage = 100000,
        _user_summary = {
          _name = "\232\141\137\228\184\155\228\188\166",
          _vip = 15,
          _uid = 203,
          _babel_level = 0,
          _avatar = 65537,
          _level = 100
        },
        _heroes = {
          {
            _tid = 10077,
            _rank = 6,
            _level = 10,
            _stars = 4
          },
          {
            _tid = 10078,
            _rank = 6,
            _level = 10,
            _stars = 4
          },
          {
            _tid = 10079,
            _rank = 6,
            _level = 10,
            _stars = 4
          },
          {
            _tid = 10080,
            _rank = 6,
            _level = 10,
            _stars = 4
          },
          {
            _tid = 10081,
            _rank = 6,
            _level = 10,
            _stars = 4
          }
        }
      },
      {
        _damage = 100000,
        _user_summary = {
          _name = "\232\141\137\228\184\155\228\188\166",
          _vip = 15,
          _uid = 203,
          _babel_level = 0,
          _avatar = 65537,
          _level = 100
        },
        _heroes = {
          {
            _tid = 10077,
            _rank = 6,
            _level = 10,
            _stars = 4
          },
          {
            _tid = 10078,
            _rank = 6,
            _level = 10,
            _stars = 4
          },
          {
            _tid = 10079,
            _rank = 6,
            _level = 10,
            _stars = 4
          },
          {
            _tid = 10080,
            _rank = 6,
            _level = 10,
            _stars = 4
          },
          {
            _tid = 10081,
            _rank = 6,
            _level = 10,
            _stars = 4
          }
        }
      }
    }
  })
end

function class:runDebugEndBattle()
  self:handleBossEndBattleReply({
    _result = "default",
    _damage = 1000000,
    _add_score = 1,
    _total_score = 4,
    _rewards = {
      {
        _id = 1234,
        _type = "item",
        _amount = 1
      }
    }
  })
end

ed.GuildMountManager = class.getInstance()
