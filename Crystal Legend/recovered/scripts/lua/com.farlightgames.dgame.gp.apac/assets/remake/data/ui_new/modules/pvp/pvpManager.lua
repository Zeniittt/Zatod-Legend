local class = {}
class.__index = class
local instance

function class.getInstance()
  if not instance then
    instance = class.create()
  end
  return instance
end

function class.create()
  local self = {}
  setmetatable(self, class)
  self:initData()
  return self
end

function class:initData()
  self.bDataValid = false
  self.adjustTime = 0
  self.resetCDDiamond = 50
  self.maxBuyTimes = 13
  self.oppos = {}
end

function class:handleErrorCode(data)
  ed.showToast(data)
end

function class:handleOpenPanelReply(data)
  self.bDataValid = true
  self.lastBtTime = data._last_bt_time
  self.leftTime = data._left_count
  self.buyTime = data._buy_times
  self.lineup = data._lineup or {}
  self.leftShareCount = data._left_share_count or 0
  table.sort(self.lineup, function(a, b)
    return ed.readhero.getHeroMaxRange(a._tid) < ed.readhero.getHeroMaxRange(b._tid)
  end)
  self.rank = data._rank
  self.gs = data._gs
  self.bEnableResetCD = ed.getDataTable("VIP")[ed.player:getvip()]["PVP CD Reset"]
  self.banHero = data._ban_hero
  if not data._is_ban_hero_open or data._is_ban_hero_open == 0 then
    ed.isOpenBanHeroMode = false
  else
    ed.isOpenBanHeroMode = true
  end
  if self.win then
    self.win:refreshUI()
  else
    self.oppos = data._oppos
    self.win = ed.ui.pvpMainScene.create()
    ed.pushScene(self.win)
  end
  self.backgroundId = data._background_id
end

function class:handleUseBackground(data)
  self.backgroundId = data._background_id
  FireEvent("useBackgroundReply")
end

function class:handleStartBattleReply(data)
end

function class:handleEndBattleReply(data)
  local result = ed.engine:btResult2String()
  result = result == "timeout" and "defeat" or result
  if data._result ~= result then
    ed.reportCtrBattleLog()
  end
  ed.player:addRewards(data._rewards or {})
  ed.pvpNetwork:sendApplyOpponent()
  local reply = ed.netreply.exitStageReply
  if reply then
    ed.netreply.exitStageReply(data._result, data)
    ed.netreply.exitStageReply = nil
  end
  local data = ed.netdata.exitStageReply
  if data then
    local stage = data.stage
    local r = data.result
    ed.record:chaosFarmStage(stage)
    if data._result == "victory" then
      ed.record:successFarmStage(stage)
    end
    ed.netdata.exitStageReply = nil
  end
end

function class:handleSweepReply(data, sweep)
  self.leftTime = data._left_challenge
  ed.player:addRewards(data._rewards)
  ed.UITool.showRewardsFromServer(data._rewards)
  if 1 < sweep then
    ed.player:increaseDailyjobCount({type = "PVPBattle", add = sweep})
  else
    ed.record:chaosFarmStage(-1)
  end
  FireEvent("PvpSweepReply")
end

function class:handleClearBattleCDReply(data)
  if "success" == data._result then
    self.lastBtTime = 0
    ed.player:subrmb(self.resetCDDiamond)
    FireEvent("resetPvpCDAndTimesSuccessed")
  end
end

function class:handleBuyPvpTimes(data)
  if data._result == "success" then
    self.leftTime = 5
    self.buyTime = data._buy_times
    ed.player:subrmb(self.buyTimeCost)
    self.buyTimeCost = 0
    FireEvent("PvpBuyTimesReply")
  end
end

function class:handleSetLineup(data)
  if data._result == "success" then
    self.lineup = data._lineup
    self.adjustTime = ed.getServerTime() + 10
    self.ban_hero = data._ban_hero or 0
    FireEvent("SetLineupReply")
  end
end

function class:handleApplyOppo(data)
  self.oppos = data._oppos
  self.rank = data._rank
  FireEvent("ChangeEnemyReply")
end

function class:handleQueryRecord(data)
  self:setRecordData(data)
end

function class:handleQueryReplay(data)
  ed.showReplay(data._record)
end

function class:handleQuerySummary(data)
  if data[1] then
    ed.ui.BattleStaticsWin.create(data[1], "pvp")
  else
    ed.showToast(T("\231\188\186\229\164\177\230\149\176\230\141\174"))
  end
end

function class:handleQueryOppo(data)
  local handler = ed.getNetReply("query_pvp_oppo")
  if handler then
    handler(data)
  else
    FireEvent("PvpQueryOppo", data._user)
  end
end

function class:setLeftShareTimes(times)
  self.leftShareCount = math.max(times, 0)
  FireEvent("LeftShareTimesChange")
end

function class:showPvpReplay(data)
  local ladderFightData = data.ladderFightData
  local summaryData = data.summaryData
  local totalGs = data.totalGs
  local roleId = summaryData._role_id
  if roleId == ed.getRoleId() then
    ed.showToast(T("\230\151\160\230\179\149\228\184\142\232\135\170\229\183\177\230\136\152\230\150\151"))
    return
  end
  local scene = ed.ui.battleprepare.create({
    pvpMode = "share_fight",
    pvpShare = true,
    stage_id = -1,
    enemyId = roleId,
    enemyHeros = ladderFightData._heroes,
    pvpIsFootHold = false,
    objData = {_summary = summaryData, _gs = totalGs}
  })
  ed.pushScene(scene)
end

function class:exitShareFight(result)
  if not ed.netreply.exitStageReply or not result then
    ed.showToast(T("\230\136\152\230\150\151\231\187\147\230\158\156\229\135\186\233\148\153"))
    ed.popScene()
    return
  end
  if ed.netreply.exitStageReply then
    if result == 3 then
      result = 1
    end
    ed.netreply.exitStageReply(result)
    ed.netreply.exitStageReply = nil
  end
end

function class:setRecordData(data)
  if data then
    FireEvent("PvpRecordRefresh", data)
  else
    ed.showToast(T("\230\154\130\230\151\160\229\155\158\230\148\190\232\174\176\229\189\149"))
  end
end

ed.UITool.registViewOpenFunc("PVP", function()
  local pl = ed.playerlimit
  local cpl = pl.getAreaUnlockPrompt
  local ds = cpl("PVP")
  if ds then
    ed.showToast(ds)
    return
  else
    if ReloadModule then
      ReloadModule("ui_new/modules/pvp/pvpModuleList")
    end
    local msg = ed.upmsg.ladder()
    msg._open_panel = {}
    ed.send(msg, "ladder")
  end
end)
ed.pvpManager = class.getInstance()
return class
