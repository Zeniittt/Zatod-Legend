local class = {}
class.__index = class
local printNetData = true

function class.getInstance()
  local networkMod = {}
  setmetatable(networkMod, class)
  return networkMod
end

function class:dispatchReply(msg)
  if printNetData then
    print("---------------GuildMountNetwork:dispatch----------------")
    ed.pt(msg)
  end
  if msg._error_code then
    ed.GuildMountManager:handleBossErrorCode(msg._error_code)
    FireEvent("GuildMountErrorCode", msg._error_code)
    return
  end
  if msg._open_panel then
    ed.GuildMountManager:handleOpenPanelReply(msg._open_panel)
  elseif msg._open_boss then
    ed.GuildMountManager:handleOpenBossReply(msg._open_boss)
  elseif msg._query_damage then
    ed.GuildMountManager:handleQueryDamageReply(msg._query_damage)
  elseif msg._start_battle then
    ed.GuildMountManager:handleStartBattleReply(msg._start_battle)
  elseif msg._end_battle then
    ed.GuildMountManager:handleBossEndBattleReply(msg._end_battle)
  elseif msg._gain_reward then
    ed.GuildMountManager:handleGainRewardReply(msg._gain_reward)
  elseif msg._pull_event then
    ed.GuildMountManager:handlePullEventReply(msg._pull_event)
  elseif msg._score_rank then
    ed.GuildMountManager:handleScoreRankReply(msg._score_rank)
  elseif msg._guild_rank then
    ed.GuildMountManager:handleZoneRankReply(msg._guild_rank)
  elseif msg._query_goods then
    ed.GuildMountManager:handleQueryGoods(msg._query_goods)
  elseif msg._buy_goods then
    ed.GuildMountManager:handleBuyGoods(msg._buy_goods)
  elseif msg._change_display then
    ed.GuildMountManager:handleChangeDisplay(msg._change_display)
  elseif msg._guild_member_rb then
    ed.GuildMountManager:handleTodayScoreRankReply(msg._guild_member_rb)
  elseif msg._practice then
    ed.GuildMountManager:handleBossEndPracticeBattleReply(msg._practice)
  end
end

function class:doSendReq(msg)
  if printNetData then
    print("-------------GuildMountNetwork:send--------------")
    ed.pt(msg)
  end
  ed.send(msg, "guild_mount")
end

function class:sendOpenPanel()
  local msg = ed.upmsg.guild_mount_req()
  msg._open_panel = ed.upmsg.guild_mount_open_panel()
  self:doSendReq(msg)
end

function class:sendOpenBoss(bossId)
  local msg = ed.upmsg.guild_mount_req()
  msg._open_boss = ed.upmsg.guild_mount_open_boss()
  self:doSendReq(msg)
end

function class:sendQueryDamageBoss(bossId)
  local msg = ed.upmsg.guild_mount_req()
  msg._query_damage = ed.upmsg.guild_mount_query_damage()
  msg._query_damage._boss_id = bossId
  self:doSendReq(msg)
end

function class:sendStartBattleBoss(bossId, lineup, isHired)
  local msg = ed.upmsg.guild_mount_req()
  msg._start_battle = ed.upmsg.guild_mount_start_battle()
  msg._start_battle._boss_id = bossId
  msg._start_battle._lineup = lineup
  msg._start_battle._use_hired = isHired == true and 1 or 0
  self:doSendReq(msg)
end

function class:sendEndPracticeBattleBoss(bossId, damage)
  local msg = ed.upmsg.guild_mount_req()
  msg._practice = ed.upmsg.guild_mount_practice()
  msg._practice._boss_id = bossId
  msg._practice._damage = damage
  self:doSendReq(msg)
end

function class:sendEndBattleBoss(param)
  local msg = ed.upmsg.guild_mount_req()
  msg._end_battle = ed.upmsg.guild_mount_end_battle()
  msg._end_battle._boss_id = param.bossId
  msg._end_battle._result = param.result
  msg._end_battle._oprations = param.oprations
  msg._end_battle._hp_list = param.hplist
  msg._end_battle._damage = param.damage
  self:doSendReq(msg)
end

function class:sendGainReward(index)
  local msg = ed.upmsg.guild_mount_req()
  msg._gain_reward = ed.upmsg.guild_mount_gain_reward()
  msg._gain_reward._index = index
  self:doSendReq(msg)
end

function class:sendPullEvent(needDamage)
  local msg = ed.upmsg.guild_mount_req()
  msg._pull_event = ed.upmsg.guild_mount_pull_event()
  msg._pull_event._need_damage = needDamage and 1 or 0
  self:doSendReq(msg)
end

function class:sendScoreRank()
  local msg = ed.upmsg.guild_mount_req()
  msg._score_rank = ed.upmsg.guild_mount_score_rankboard()
  self:doSendReq(msg)
end

function class:sendTodayScoreRank()
  local msg = ed.upmsg.guild_mount_req()
  msg._guild_member_rb = ed.upmsg.guild_mount_guild_member_rb()
  self:doSendReq(msg)
end

function class:sendZoneRank(type)
  local msg = ed.upmsg.guild_mount_req()
  msg._guild_rank = ed.upmsg.guild_mount_guild_rankboard()
  msg._guild_rank._type = type
  self:doSendReq(msg)
end

function class:sendQueryGoods()
  local msg = ed.upmsg.guild_mount_req()
  msg._query_goods = ed.upmsg.guild_mount_query_goods()
  self:doSendReq(msg)
end

function class:sendBuyGoods(groupId, goodsIndex, amount)
  local req = ed.upmsg.guild_mount_req()
  req._buy_goods = ed.upmsg.guild_mount_buy_goods()
  req._buy_goods._amount = amount
  req._buy_goods._group_id = groupId
  req._buy_goods._index = goodsIndex
  self:doSendReq(req)
end

function class:sendChangeDisplay(hid)
  local req = ed.upmsg.guild_mount_req()
  req._change_display = ed.upmsg.guild_mount_change_display()
  self.changeDisplay = hid
  req._change_display._hero_id = hid
  self:doSendReq(req)
end

ed.GuildMountNetwork = class.getInstance()
