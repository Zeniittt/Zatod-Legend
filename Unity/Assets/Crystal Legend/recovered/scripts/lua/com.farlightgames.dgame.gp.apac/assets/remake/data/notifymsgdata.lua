local notifyMsgData = {
  WarschoolNotifyData = {_is_notify = 0},
  WardecomposeNotifyData = {_is_notify = 0},
  WarmakeNotifyData = {_is_notify = 0},
  ReadingHouseNotifyData = {_is_notify = 0},
  WarResourceNotifyData = {_is_notify = 0},
  QuestNotifyData = {_is_notify = 0},
  PetHouseNotifyData = {_is_notify = 0}
}
ed.reportEventConfig = {
  "acc_create",
  "event_First_Open",
  "Purchase",
  "role_login",
  "Purchase_First",
  "activation",
  "role_create",
  "tutorial_complete",
  "summon_300",
  "summon_500",
  "summon_1000",
  "chat_10",
  "chat_50",
  "campaign_normal_1",
  "campaign_normal_3",
  "campaign_normal_5",
  "campaign_normal_7",
  "campaign_normal_9",
  "campaign_normal_11",
  "campaign_normal_13",
  "campaign_elite_1",
  "campaign_elite_3",
  "campaign_elite_5",
  "campaign_elite_7",
  "campaign_elite_9",
  "campaign_elite_11",
  "campaign_elite_13",
  "ladder_wholegs_100",
  "ladder_wholegs_500",
  "ladder_wholegs_1000",
  "ladder_teamgs_100",
  "ladder_teamgs_500",
  "ladder_teamgs_1000",
  "buy_diamond_648",
  "buy_diamond_328",
  "buy_diamond_198",
  "buy_diamond_98",
  "buy_diamond_30",
  "buy_diamond_6",
  "bug_monthlycard",
  "role_levelup"
}

local function updateNotifyMsgData(data)
  if nil == data then
    return
  end
  if data._ladder_notify then
    local notify = {}
    notify._is_attacked = data._ladder_notify._is_attacked
    notifyMsgData.PvpNotifyData = notify
    local BuilddingType = ed.ui.configs.mainSceneMap.builddingType
    FireEvent("MainBuildRedTagChange", BuilddingType.Pvp)
  end
  if data._personal_chat then
    local chatNotify = data._personal_chat
    notifyMsgData.ChatNotifyData = chatNotify
    FireEvent("ChatNotifyData", data._personal_chat)
  end
  if data._activity_notify or data._activity_reward_ids or data._has_unread_activies then
    FireEvent("activityNotify", data)
  end
  if data._item_expiry then
    for index, itemExpiry in ipairs(data._item_expiry) do
      if not ed.player._item_expiry then
        ed.player._item_expiry = {}
      end
      local exist = false
      for key, item in pairs(ed.player._item_expiry) do
        if item._item_id == itemExpiry._item_id then
          exist = true
          break
        end
      end
      if not exist then
        table.insert(ed.player._item_expiry, itemExpiry)
      end
    end
  end
  if data._is_open_debug then
    ed.open_debug = true
  else
    ed.open_debug = false
  end
  if data._fancy_candle_count then
    ed.SkillTowerManager.power = data._fancy_candle_count
    ed.SkillTowerManager.lastPowerTime = ed.getServerTime()
    FireEvent("FancyTowerCandleChange")
  end
  if data._fancy_tower then
    ed.SkillTowerManager.redLight = data._fancy_tower == 1
  end
  if data._gift_ticket_sync then
    ed.RechargeManager:setTicketData(data._gift_ticket_sync)
  end
  if data._recharge_notify._is_role_first then
  end
  if data._recharge_notify and data._recharge_notify._is_acc_first == 1 and EDReportEvent then
    EDReportEvent("Purchase_First", "")
  end
  if data._has_hatched_egg == 1 then
    ed.PetManager:setRedFlag(true)
  end
  if data._guild_worship then
    notifyMsgData.guildTag = data._guild_worship
  end
  if data._force_battle_report then
    ed.storage.setValue("FORCE_BATTLE_REPORT_FLAG", data._force_battle_report == 1)
  end
  if data._points_sync then
    for k, v in ipairs(data._points_sync) do
      local num = ed.player:getPoint(v._type)
      v._value = ed.clamp(v._value - num, 0, v._value)
      ed.player:addPoint(v._type, v._value)
    end
  end
  if data._goback_notify then
    ed.GobackManager:setNotifyRedLight(data._goback_notify == 1)
    FireEvent("MainRedTagChange", ed.ui.configs.mainButton.ButtonType.GOBACK)
  end
  if data._chess_act_open then
    ed.AutoChessManager:setIsOpen(1 == data._chess_act_open)
  end
  if data._impulse_gift then
    ed.RechargeManager:handleGiftReply(data._impulse_gift)
  end
  if data._cup_arena then
    ed.CupArenaManager:handleBaseInfo(data._cup_arena)
  end
  if data._mall_gift then
    ed.RechargeManager:setNewGiftNotifyFlag(data._mall_gift ~= 0)
  end
  if data._activity_hint then
  end
  if data._weeklyjob_notify then
    ed.weeklyjobData:weeklyjobRedUpdate(data._weeklyjob_notify)
  end
  if data._new_monthcards then
    for k, v in ipairs(data._new_monthcards) do
      ed.player:refreshMonthCardData(v)
    end
  end
  if data._guild_mount then
    ed.GuildMountManager.season = data._guild_mount._season or 0
    ed.GuildMountManager:setState(data._guild_mount._state or "wait")
    local battle = data._guild_mount._battle_hint and 0 < data._guild_mount._battle_hint and ed.player:isNewDay()
    local reward = data._guild_mount._rewards_hint and 0 < data._guild_mount._rewards_hint
    ed.GuildMountManager:setRedFlag(battle or reward)
  end
  if data._achievement then
    ed.taskData:achievementRed(data._achievement)
  end
  if data._daily_pass_notify then
    ed.taskData:setDailyPassRed(data._daily_pass_notify._reward_hint or 0)
  end
  if data._simple_shop_notify then
    local simple_shop_notify = {}
    local tmp = data._simple_shop_notify
    local simple_shop_notify = tmp[".data"]._newlys
    for k, v in pairs(simple_shop_notify or {}) do
      v[".data"].isVisible = true
    end
    ed.ShopMgr.simple_shop_notify = simple_shop_notify
  end
  if data._simple_pass_notify then
    local newPassList = data._simple_pass_notify._new_pass_list
    local rewardHintList = data._simple_pass_notify._reward_hints
    for i, simplePass in ipairs(newPassList or {}) do
      ed.passDataMgr:updatePassData(simplePass)
    end
    for i, rewardHint in ipairs(rewardHintList or {}) do
      local passId = rewardHint._pass_id
      local rewardCount = rewardHint._reward_count
      ed.passDataMgr:setPassRewardCount(passId, rewardCount)
    end
  end
  if data._ip_location then
    ed.setIpLocation(data._ip_location)
  end
  if data._activity_reward_ids then
    print("_activity_reward_ids: back updata Activity")
    ed.activityHints:activityReward(data._activity_reward_ids)
  end
  if data._activity_notify then
    print("_activity_notify: back updata Activity")
    ed.activityHints:activityNotify(data._activity_notify)
  end
  if data._charge_vault_notify then
    ed.RechargeManager.SecretBoxRedLight = data._charge_vault_notify == 1
    FireEvent("MainRedTagChange", ed.ui.configs.mainButton.ButtonType.RECHARGE)
  end
  if data._sevenday_assist_notify then
    ed.SevenDayManager:setRedLight(data._sevenday_assist_notify == 1)
    FireEvent("MainRedTagChange", ed.ui.configs.mainButton.ButtonType.SEVENDAY)
  end
  if data._act_adventure_notify then
    local actiAdventureMgr = ed.actiAdventureMgr.getInstance()
    actiAdventureMgr:setAdventureNotify(data._act_adventure_notify)
  end
  if data._peak_arena_notify then
    ed.PeakArenaNetwork:notify(data._peak_arena_notify)
  end
  if data._guild_clash_notify then
    ed.GuildClashNetwork:notify(data._guild_clash_notify)
  end
  if data._awake_dungeon_notify then
    ed.AwakeDungeonNetwork.notify(data._awake_dungeon_notify)
  end
  if data._heat_notify then
    ed.hadesHeatNet.notify(data._heat_notify)
  end
  if data._nian_monster_notify then
    ed.nianMonsterNet.notify(data._nian_monster_notify)
  end
  if data._fancy_abyss_notify == 1 then
    local newSeasonList = ed.newSeasonOrActOpen
    newSeasonList[140] = T("\230\150\176\229\185\187\229\162\131\231\171\158\233\128\159\229\188\128\229\144\175")
  end
  if data._chat_spell_notify then
    print("_chat_spell_notify")
    FireEvent("NOTICE_CHAT_SPELL", data._chat_spell_notify)
  end
  if data._guild_enlist and data._guild_enlist ~= 0 then
    ed.GuildManager:notify(data._guild_enlist)
    FireEvent("GuildRecruitReply", "notify")
    local BuilddingType = ed.ui.configs.mainSceneMap.builddingType
    FireEvent("MainBuildRedTagChange", BuilddingType.Guild)
  end
  if data._retrieval_reward_notify then
    ed.retrievalRewardNet.notify(data._retrieval_reward_notify)
  end
  if data._summon_circle_notify then
    ed.summonMgr:setCircleRed(data._summon_circle_notify)
    local BuilddingType = ed.ui.configs.mainSceneMap.builddingType
    FireEvent("MainBuildRedTagChange", BuilddingType.Summon)
  end
  if data._rogue_notify then
    ed.rogueLikeNet.notify(data._rogue_notify)
  end
  if data._cosmetic_shop_notify then
    ed.exteriorShopData:setCircleRed(data._cosmetic_shop_notify)
    local BuilddingType = ed.ui.configs.mainSceneMap.builddingType
    FireEvent("MainBuildRedTagChange", BuilddingType.Shop)
  end
  if data._guild_join_req_notify then
    ed.GuildManager:joinNotify(data._guild_join_req_notify)
    local BuilddingType = ed.ui.configs.mainSceneMap.builddingType
    FireEvent("MainBuildRedTagChange", BuilddingType.Guild)
  end
  if data._new_hero_astrolabe == 1 then
    local msg = ed.upmsg.astrolabe_req()
    msg._pull = ed.upmsg.astrolabe_pull()
    ed.send(msg, "astrolabe")
  end
  if data._sweet_party_notify then
    ed.sweetPartyManager:notify(data._sweet_party_notify)
  end
  if data._chat_blocking_notify then
    ed.chatNetWork:handleBlockingNotify(data._chat_blocking_notify)
  end
  if data._time_corridor_notify then
    ed.timeCorridorNet:notify(data._time_corridor_notify)
  end
  if data._real_arena_notify then
    FireEvent("RealArenaNotify", data._real_arena_notify)
  end
  if data._legend_equip_notify then
    ed.legendEquipNet.notify(data._legend_equip_notify)
  end
  if data._simple_assist_notify then
    ed.dayAwardsManager:notify(data._simple_assist_notify)
    ed.runCricketManager:notify(data._simple_assist_notify)
  end
  if data._pirate_shop_notify then
    ed.pirateshopManager.npcRed(data._pirate_shop_notify)
  end
  if data._dragon_boat_notify then
    ed.dragonBoatNet.getInstance():notify(data._dragon_boat_notify)
  end
  if data._crevice_defend_notify then
    ed.CreviceDefendNetWork:notify(data._crevice_defend_notify)
  end
  if data._hero_haggle_notify then
    ed.heroHaggleNet.notify(data._hero_haggle_notify)
  end
  if data._simple_assist_notify then
    ed.heroHaggleNet.notifyTask(data._simple_assist_notify)
  end
  if data._feature_preview_notify then
    ed.featurePreviewManager:notify(data._feature_preview_notify)
  end
  if data._simple_assist_notify then
    ed.riseStarNet:notifyTask(data._simple_assist_notify)
  end
end

function ed.queryNotifyData(type)
  if nil == type then
    return
  end
  return notifyMsgData[type]
end

function ed.changeNotifyData(type, key, value)
  if nil == type then
    return
  end
  if nil == notifyMsgData[type] then
    return
  end
  if key then
    notifyMsgData[type][key] = value
  else
    notifyMsgData[type] = value
  end
  FireEvent(type, notifyMsgData[type])
end

function ed.getNotifyDataValue(t)
  if t == nil then
    return false
  end
  local data = notifyMsgData[t]
  if nil == data then
    return false
  end
  for k, v in pairs(data) do
    if 0 < v then
      return true
    end
  end
  return false
end

function ed.getNotifyKeyValue(type, key)
  if type == nil then
    return false
  end
  local data = notifyMsgData[type]
  if nil == data then
    return false
  end
  for k, v in pairs(data) do
    if k == key then
      return v
    end
  end
end

local function updateNotifyMsgDataDelay(data)
  if ed.delayHandleNotifyMsgData then
    ed.delayHandleNotifyMsgData = nil
    ListenTimer(Timer:Once(0.5), function()
      updateNotifyMsgData(data)
    end)
  else
    updateNotifyMsgData(data)
  end
end

ListenEvent("NotifyMsgRsp", updateNotifyMsgDataDelay)
