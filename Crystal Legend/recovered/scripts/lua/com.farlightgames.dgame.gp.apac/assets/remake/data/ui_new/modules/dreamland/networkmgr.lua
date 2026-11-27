module("ed.dreamland", package.seeall)
local error_string_list = {
  no_stage_count = T("\228\187\138\230\151\165\230\140\145\230\136\152\230\172\161\230\149\176\229\183\178\231\148\168\229\174\140\239\188\140\232\175\183\232\180\173\228\185\176\230\172\161\230\149\176"),
  no_stage_info = T("\230\156\170\230\159\165\232\175\162\229\136\176\229\133\179\229\141\161\228\191\161\230\129\175"),
  not_in_battle_period = T("BOSS\230\156\170\233\153\141\228\184\180"),
  lineup_hero_duplicate = T("\230\136\152\230\150\151\228\184\141\229\143\175\228\187\165\228\189\191\231\148\168\233\135\141\229\164\141\231\154\132\232\139\177\233\155\132"),
  lineup_hero_toomany = T("\230\136\152\230\150\151\228\184\141\229\143\175\228\187\165\228\189\191\231\148\1685\228\184\170\228\187\165\228\184\138\231\154\132\232\139\177\233\155\132"),
  lineup_hero_invalid = T("\230\136\152\230\150\151\228\184\141\229\143\175\228\187\165\228\189\191\231\148\168\230\156\170\230\139\165\230\156\137\231\154\132\232\139\177\233\155\132"),
  not_in_rank_period = T("BOSS\229\183\178\231\187\143\230\182\136\229\164\177"),
  money_not_enough = T("\233\146\187\231\159\179\228\184\141\232\182\179\239\188\140\232\175\183\229\133\133\229\128\188"),
  buy_limit_error = T("\230\130\168\229\189\147\229\137\141\231\154\132VIP\231\173\137\231\186\167\228\184\141\232\131\189\229\134\141\232\180\173\228\185\176\230\140\145\230\136\152\230\172\161\230\149\176\228\186\134"),
  limit_by_level = T("\230\130\168\231\154\132\230\136\152\233\152\159\231\173\137\231\186\167\228\184\141\232\182\179")
}
local error_handler_list = {
  no_stage_count = function()
    ed.popScene()
    ed.popScene()
    ListenTimer(Timer:Once(0.1), function()
      ed.showToast(error_string_list.no_stage_count)
    end)
  end,
  not_in_battle_period = function()
    ed.popScene()
    ed.popScene()
    ed.popScene()
    ListenTimer(Timer:Once(0.1), function()
      ed.showToast(error_string_list.not_in_battle_period)
    end)
  end,
  not_in_rank_period = function()
    ed.popScene()
    ed.popScene()
    ed.popScene()
    ListenTimer(Timer:Once(0.1), function()
      ed.showToast(error_string_list.not_in_rank_period)
    end)
  end,
  money_not_enough = function()
    ed.showHandyDialog("toRecharge")
    ListenTimer(Timer:Once(0.1), function()
      ed.showToast(error_string_list.money_not_enough)
    end)
  end
}
DreamlandScope = {}
NetworkMgr = {}
NetworkMgr.__index = NetworkMgr

function NetworkMgr.Create()
  local network_mgr = {}
  network_mgr.what = "DreamlandNetworkMgr"
  setmetatable(network_mgr, NetworkMgr)
  network_mgr:RegisterEvents()
  return network_mgr
end

function NetworkMgr:Destroy()
  CloseScope(DreamlandScope)
end

function NetworkMgr:RegisterEvents()
  ListenEvent("DreamlandRsp", function(msg)
    self:Dispatch(msg)
  end, DreamlandScope)
  ListenEvent("DreamlandRequestStartBattle", function(hero_ids)
    self:RequestStartBattle(hero_ids)
  end, DreamlandScope)
  ListenEvent("DreamlandBuyChance", function()
    self:RequestBuyChance()
  end, DreamlandScope)
  ListenEvent("DreamlandRequestSummary", function()
  end, DreamlandScope)
end

function NetworkMgr:RequestSummary()
  local msg = ed.upmsg.dreamland()
  msg._request_summary = ed.upmsg.dreamland_request_summary()
  ed.send(msg, "dreamland")
end

function NetworkMgr:RequestOpenPanel(hideScene)
  self.hideScene = hideScene
  local msg = ed.upmsg.dreamland()
  msg._open_panel = ed.upmsg.dreamland_open_panel()
  ed.send(msg, "dreamland")
end

function NetworkMgr:sendSetVideoStatu(ishide)
  local msg = ed.upmsg.dreamland()
  msg._set_video_status = ed.upmsg.dreamland_set_video_status()
  msg._set_video_status._is_hide = ishide
  ed.send(msg, "dreamland")
end

function NetworkMgr:RequestStartBattle(hero_ids)
  local msg = ed.upmsg.dreamland()
  msg._start_battle = ed.upmsg.dreamland_start_battle()
  msg._start_battle._hero_ids = hero_ids
  ed.send(msg, "dreamland")
end

function NetworkMgr:RequestBuyChance()
  local msg = ed.upmsg.dreamland()
  msg._buy_chance = ed.upmsg.dreamland_buy_chance()
  ed.send(msg, "dreamland")
end

function NetworkMgr:RequestCalendar()
  local msg = ed.upmsg.dreamland()
  msg._query_calendar = ed.upmsg.dreamland_query_calendar()
  ed.send(msg, "dreamland")
end

function NetworkMgr:sendBattleRecord()
  local msg = ed.upmsg.dreamland()
  msg._battle_record = ed.upmsg.dreamland_battle_record()
  ed.send(msg, "dreamland")
end

function NetworkMgr:sendQueryReplay(replay_id)
  local msg = ed.upmsg.dreamland()
  msg._query_replay = ed.upmsg.dreamland_query_replay()
  msg._query_replay._replay_id = replay_id
  ed.send(msg, "dreamland")
end

function NetworkMgr:sendQuerySummary(replay_id)
  local msg = ed.upmsg.dreamland()
  msg._query_summary = ed.upmsg.dreamland_query_summary()
  msg._query_summary._replay_id = replay_id
  ed.send(msg, "dreamland")
end

function NetworkMgr:StartBattle(data)
  ed.stopMusic()
  ed.playEffect(ed.sound.deo.battle_begin)
  ed.battleshare.clearShareButton()
  dreamland_object:setBattleGroupInfo({})
  local hero_list = {}
  for i, id in ipairs(attack_team.team) do
    local hero
    if i == attack_team.mercenary_index then
      hero = ed.GuildManager:getMercenaryHero(attack_team.mercenary_info.uid, id)
    else
      hero = ed.player:getHero(id)
    end
    local copyHero = NetworkMgr.copyHero(hero)
    table.insert(hero_list, copyHero)
  end
  local stage = ed.lookupDataTable("Stage", nil, dreamland_object:GetStage())
  local battle = ed.lookupDataTable("Battle", nil, dreamland_object:GetStage(), 1)
  ed.srand(data._rseed or 0)
  local params = {}
  params.battleBonus = ed.player:getBattleBonus()
  params.stageBuff = ed.activityHints.data:getDreamStageBuffId()
  ed.engine:enterStage(stage, hero_list, nil, nil, nil, 0, params)
  local extra_info = {}
  ed.scene:reset(stage, battle, extra_info)
  ed.replaceScene(ed.scene)
end

function NetworkMgr:showDreamlandReply(data)
  local stageid = self.ReplayStageId
  ed.ui.vcdLayer.setData(data, "dreamland", stageid)
  ed.srand(data._rseed)
  local stage = ed.lookupDataTable("Stage", nil, stageid)
  local battle = ed.lookupDataTable("Battle", nil, stageid, 1)
  local heroList = {}
  for k, v in ipairs(data._self_heroes) do
    local hero = ed.HeroCreate()
    hero:setup(v)
    table.insert(heroList, hero)
  end
  local params = {}
  params.stageBuff = ed.activityHints.data:getDreamStageBuffId()
  ed.engine:enterStage(stage, heroList, nil, nil, nil, 0, params)
  ed.engine.replayMode = true
  ed.engine:setOperationList(data._operations)
  ed.scene:reset(stage, battle, {
    replayInfo = {
      dreamlandReplay = true,
      checkid = data._checkid
    }
  })
  ed.pushScene(ed.scene)
end

function NetworkMgr:Dispatch(msg)
  if msg._battle_record then
    if ed.copyProto(msg._battle_record)._records then
      ed.UITool.openView("dreamRecordPop", msg._battle_record)
    else
      ed.showToast(T("\230\154\130\230\151\160\229\155\158\230\148\190\232\174\176\229\189\149"))
    end
    return
  end
  if msg._query_replay then
    self:showDreamlandReply(msg._query_replay._record)
    return
  end
  if msg._query_summary then
    ed.ui.BattleStaticsWin.create(msg._query_summary[1], "dramland", false)
    return
  end
  if msg._err_code then
    local error_handler = error_handler_list[msg._err_code]
    if error_handler then
      error_handler()
      return
    end
    local error_string = error_string_list[msg._err_code]
    ed.showToast(error_string or msg._err_code)
    return
  end
  if msg._open_panel then
    if msg._open_panel._summary._current_stage == 0 then
      dreamland_object:ResetData(msg._open_panel)
      ed.showToast(T("\230\176\184\231\148\159\230\162\166\229\162\131\230\178\161\230\156\137\229\188\128\230\148\190"))
    elseif self.hideScene then
      if dreamland_object then
        dreamland_object:ResetData(msg._open_panel)
      else
        dreamland_object = Dreamland.Create(msg._open_panel)
      end
    else
      ed.pushScene(ed.ui.dreamlandscene.create(msg._open_panel))
    end
  elseif msg._start_battle then
    if msg._start_battle._result == "success" then
      ed.startBattleTime = msg._start_battle._bt_st
      dreamland_object:SavePreviousTopDamage()
      self:StartBattle(msg._start_battle)
      ed.player:increaseDailyjobCount({
        type = "EnterDreamLand",
        add = 1
      })
    else
      ed.showToast(T("\230\176\184\231\148\159\230\162\166\229\162\131\230\136\152\230\150\151\230\151\160\230\179\149\229\188\128\229\167\139"))
    end
  elseif msg._end_battle then
    print("dreamland end battle------>")
    local data = msg._end_battle
    dreamland_object:SetRank(data._current_rank)
    dreamland_object:SetTopDamage(data._current_damage)
    dreamland_object:SetGlobalRank(data._global_rank)
    local heroList = {}
    if not ed.engine.multiplayerMode then
      dreamland_object:MinusChance()
      heroList = ed.engine.hero_id_list
    end
    local unitDamage = dreamland_object:getUnitDamage()
    local MPGroupInfo = dreamland_object:getBattleGroupInfo()
    local mp_info = {}
    for _, playerInfo in pairs(MPGroupInfo) do
      local ids = playerInfo.heroIds
      local damage = 0
      for _, hid in pairs(ids) do
        local adddamage = unitDamage[hid] or 0
        damage = damage + adddamage
      end
      local param = {
        summary = playerInfo.summary,
        damage = math.floor(damage),
        deviceid = playerInfo.deviceid
      }
      table.insert(mp_info, param)
    end
    local args = {
      victory = true,
      stage_id = ed.engine.stage_info["Stage ID"],
      heroes = heroList,
      mercenaryInfo = ed.engine:getTeamMercenaryInfo(),
      mp_info = mp_info,
      dreamland_data = {
        rank_current = data._current_rank,
        rank_previous = data._previous_rank,
        damage_previous = dreamland_object:GetPreviousTopDamage(),
        damage_current = dreamland_object:GetCurrentDamage(),
        damage_top = data._current_damage,
        damage_milestone = data._milestone_damage,
        rank_milestone = data._milestone_rank,
        player_summary_milestone = data._milestone_player
      },
      loseType = "fail"
    }
    if args.victory then
      local id = ed.playEffect(ed.sound.battle.win)
      ed.audioParam.effects.battleResult = id
    else
      local id = ed.playEffect(ed.sound.battle.lose)
      ed.audioParam.effects.battleResult = id
    end
    ed.player:takeStageReward(args.stage_id, nil, ed.engine.hero_list, {})
    ListenTimer(Timer:Once(2), function()
      if ed.getCurrentScene().identity == "battle" then
        ed.ui.stageaccount.initialize(args)
      end
    end)
    self:checkMultiplayerDamage(mp_info)
  elseif msg._buy_chance then
    if msg._buy_chance._result == "success" then
      FireEvent("DreamlandChanceReset", msg._buy_chance._times)
    else
      ed.showToast(T("\232\180\173\228\185\176\230\172\161\230\149\176\229\164\177\232\180\165"))
    end
  elseif msg._summary then
    dreamland_object:ResetSummary(msg._summary)
  elseif msg._calendar then
    FireEvent("DreamAnnouncedCalendar", msg._calendar)
  end
end

function NetworkMgr:initVoiceEngine()
  local msg = ed.upmsg.voice_room()
  msg._voice_room_available = ed.upmsg.voice_room_available()
  if ed.openVoicetalk then
    msg._voice_room_available._available = 0
    EDLog("Youme Voice engine my client is ok for voice!")
  else
    msg._voice_room_available._available = 1
    EDLog("Youme Voice engine my client is failed for voice!")
  end
  EDLog("init voice engine isok ?" .. tostring(msg._voice_room_available._available))
  ed.send(msg, "voice_room")
end

function NetworkMgr:checkMultiplayerDamage(local_damage_info)
  local damage_current = dreamland_object:GetCurrentDamage()
  local damage_local = 0
  for _, info in pairs(local_damage_info) do
    damage_local = damage_local + info.damage
  end
  if math.abs(damage_current - damage_local) > 10 then
    EDLog("----------------------->>> dreamland cheat")
    local param = ed.dreamland.dreamland_object.battle_check
    if not param then
      return
    end
    local str = T("multi_dreamland_sm_%s_lm_%s", damage_current, damage_local)
    ed.reportBattleLog(param.check_id, str, param.svr_id)
  end
end

function NetworkMgr.copyHero(copyHero)
  local hero = ed.copyProto(copyHero.data)
  local newHero = ed.HeroCreate()
  newHero:setup(hero)
  newHero:setMercenaryData(copyHero:getMercenaryData())
  return newHero
end
