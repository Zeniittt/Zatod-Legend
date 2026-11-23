module("ed.gmtools", package.seeall)
battlereply = {}
battlereply.__index = battlereply

function battlereply.create()
  local object = {}
  setmetatable(object, battlereply)
  object:registerEventHandler()
  return battlereply
end

function battlereply:registerEventHandler()
  ListenEvent("query_replay_reply", function(info)
    self:doBattlereplay(info)
  end)
end

function battlereply:doBattlereplay(info)
  if info._general then
    self:doGeneral(info)
  elseif info._cup_arena then
    self:doCupArena(info._cup_arena)
  elseif info._peak_arena then
    ed.UITool.openView("PeakArenaChallengeResultWin", {
      data = {
        _battle_replay = {
          _records = info._peak_arena._records
        },
        _self_score_change = 0,
        _self_new_score = 0,
        _oppo_score_change = 0,
        _oppo_new_score = 0
      },
      isEvolving = false,
      isReplay = true
    })
    ed.PeakArenaManager:peakArenaAchFcaGroup()
  elseif info._guild_clash then
    ed.GuildClashManager.enterReplay(info._guild_clash)
  elseif info._crevice_defend then
    ed.UITool.openView("OpenCreviceDefendRecordDetailWin", info._crevice_defend)
  end
end

function battlereply:doGeneral(info)
  local mode = self:getBattleMode(info._type)
  if mode == "babel" then
    self:showBabelReplay(info._general)
  elseif mode == "tbc" then
    self:showTbcReplay(info._general)
  elseif mode == "dreamland" then
    self:showDreamlandReply(info._general)
  elseif mode == "real_pvp" then
    ed.realarena.RealArenaMgr.showReplay(info._general, -39)
  else
    ed.showReplay(info._general, mode)
  end
end

function battlereply:getBattleMode(mode)
  local modeHash = {ladder = "pvp", real_arena = "real_pvp"}
  if modeHash[mode] then
    return modeHash[mode]
  else
    return mode
  end
end

function battlereply:showBabelReplay(record)
  local stageid = record._oppo_userid
  ed.showReplay(record, "babel", stageid)
end

function battlereply:showTbcReplay(record)
  local stageid = -1
  ed.showReplay(record, "tbc", stageid)
end

function battlereply:showDreamlandReply(data)
  local stageid = data._param1
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
  ed.engine:enterStage(stage, heroList, nil, nil, nil, 0, {})
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

function battlereply:doLegendarena(record)
  local data = {_record = record}
  local replayWindow = legendarena.create(data)
  local currentScene = ed.getCurrentScene()
  currentScene.mainLayer:addChild(replayWindow.mainLayer, 100)
end

function battlereply:doMultiarena(record)
  local camp = {_role = "host", _pos = "first"}
  local battle_info = {
    host = {
      lord = record._host_team._lord,
      lord_index = record._host_team._lord_index,
      member_list = {}
    },
    guest = {
      lord = record._guest_team._lord,
      lord_index = record._guest_team._lord_index,
      member_list = {}
    }
  }
  for k, player in ipairs(record._host_team._players) do
    local temp = {
      index = player._team_index,
      heroes = player._heroes,
      magics = player._magics,
      warschool_books = ed.player:initFightWarschoolInfo(player._warschool_books),
      bookreading_level = player._bookreading_level,
      battleBonus = player._bonus or nil
    }
    table.insert(battle_info.host.member_list, temp)
  end
  for k, player in ipairs(record._guest_team._players) do
    local temp = {
      index = player._team_index,
      heroes = player._heroes,
      magics = player._magics,
      warschool_books = ed.player:initFightWarschoolInfo(player._warschool_books),
      bookreading_level = player._bookreading_level,
      battleBonus = player._bonus or nil
    }
    table.insert(battle_info.guest.member_list, temp)
  end
  local param = {
    isHost = camp._role == "host",
    team_index = camp._pos == "first" and 1 or 2,
    btInfo = battle_info,
    operations = record._host_team._ops,
    right_operations = record._guest_team._ops
  }
  ed.srand(record._rseed)
  ed.engine:enterMultiArenaRelay(param)
  local stage = ed.lookupDataTable("Stage", nil, -64)
  local battle = ed.lookupDataTable("Battle", nil, -64, 1)
  local addition = {
    multiArenaReplayMode = {
      checkid = record._checkid
    }
  }
  ed.scene:reset(stage, battle, addition)
  ed.pushScene(ed.scene)
end

function battlereply:doStarGate(records)
  local panel = StarGateReplayPanel.create({_replay = records}, {})
  panel:popWindow()
end

function battlereply:doCupArena(records)
  local record = records._records[1]
  ed.netdata.cupArenaReplayData = {
    active = true,
    oppoSummary = record._oppo_user,
    serverId = 10000,
    leftSummary = record._self_user,
    leftServerId = 10000
  }
  local panel = ed.ui.CupArenaReplayWin.create(records, 1)
  panel:popWindow()
end

battlereply = battlereply.create()
