local network = {}
ed.ActivityNetwork = network

function network.create()
  local object = {}
  setmetatable(object, {__index = network})
  return object
end

function network:setEnterHandler(id)
  self.ReplyId = id
end

function network:getEnterHandler()
  if self.ReplyId then
    self:activityPull(self.ReplyId)
    self.ReplyId = nil
  end
end

function network:activityHintPull()
  local req = ed.upmsg.activity_hint_req()
  req._view = ed.upmsg.activity_hint_pull()
  ed.send(req, "activity_hint")
end

function network:activityHintResolve(id)
  local req = ed.upmsg.activity_hint_req()
  req._resolve = ed.upmsg.activity_hint_resolve()
  req._resolve._act_id = id
  self.HintId = id
  ed.send(req, "activity_hint")
end

function network:activityPull(act_ids)
  local msg = ed.upmsg.activity_req()
  msg._pull = {
    _act_ids = {act_ids}
  }
  ed.send(msg, "activity")
end

function network:activitySubmit(act_id, task_id, times)
  local msg = ed.upmsg.activity_req()
  msg._task_submit = {
    _act_id = act_id,
    _task_id = task_id,
    _times = times
  }
  ed.send(msg, "activity")
end

function network.activityCalenderReq()
  local msg = ed.upmsg.activity_req()
  msg._act_calendar = {}
  ed.send(msg, "activity")
end

function network.activityHeroRecycle(actId, taskId, heroId)
  local msg = ed.upmsg.activity_req()
  msg._hero_recycle = {}
  msg._hero_recycle._act_id = actId
  msg._hero_recycle._task_id = taskId
  msg._hero_recycle._hero_id = heroId
  ed.pt(msg)
  ed.send(msg, "activity")
end

function network:dailyVitality(type, replenish)
  local typeStr = {lunch = 0, dinner = 1}
  local msg = ed.upmsg.daily_vitality_req()
  msg._type = type
  msg._is_replenish = replenish
  ed.send(msg, "daily_vitality")
end

function network:activityChooseHerSubmit(act_id, task_id, index, reward_id, target)
  local msg = ed.upmsg.activity_req()
  msg._choose_reward = {
    _act_id = act_id,
    _task_id = task_id,
    _index = index,
    _reward_id = reward_id,
    _reward_amount = target
  }
  ed.send(msg, "activity")
end

function network:sendLotteryReq(type, param)
  local msg = ed.upmsg.lottery_req()
  if type == "_open_panel" then
    msg._open_panel = ed.upmsg.lottery_open_panel()
  elseif type == "_enter_tray" then
    msg._enter_tray = ed.upmsg.lottery_enter_tray()
  elseif type == "_open_card" then
    msg._open_card = ed.upmsg.lottery_open_card()
    msg._open_card._open_index = param._open_index
  elseif type == "_line_reward" then
    msg._line_reward = ed.upmsg.lottery_line_reward()
    msg._line_reward._reward_index = param._reward_index
  elseif type == "_open_tray" then
    msg._open_tray = ed.upmsg.lottery_open_tray()
  elseif type == "_talk" then
    msg._talk = ed.upmsg.lottery_talk()
    msg._talk._count = param._count
  end
  ed.send(msg, "lottery")
end

function network:manualTriggerRed(type)
  local msg = ed.upmsg.manual_trigger_req()
  msg._type = type
  msg._param = ""
  ed.send(msg, "manual_trigger")
end

function network.sendAllStarRankMsg(left, right)
  local msg = ed.upmsg.all_star_req()
  msg._query_rankboard = ed.upmsg.all_star_query_rankboard()
  msg._query_rankboard._rank_left = left
  msg._query_rankboard._rank_right = right
  ed.send(msg, "all_star")
end

function network.sendAllStarRankGiveRecordMsg()
  local msg = ed.upmsg.all_star_req()
  msg._give_record = ed.upmsg.all_star_give_record()
  ed.send(msg, "all_star")
end

function network.sendAllStarRankGetMsg()
  local msg = ed.upmsg.all_star_req()
  msg._get_rank = ed.upmsg.all_star_get_rank()
  ed.send(msg, "all_star")
end

function network.sendAllStarRankGiveMsg(roleId, num)
  local msg = ed.upmsg.all_star_req()
  msg._give = ed.upmsg.all_star_give()
  msg._give._role_id = roleId
  msg._give._star_num = num
  ed.pt(msg)
  network.starCount = num
  ed.send(msg, "all_star")
end

function network:sendArenaCompetitionReq(type)
  local msg = ed.upmsg.guild_contest_req()
  if type == "_open_panel" then
    msg._open_panel = ed.upmsg.guild_contest_open_panel()
  elseif type == "_query_members" then
    msg._query_members = ed.upmsg.guild_contest_query_members()
  end
  ed.send(msg, "guild_contest")
end

function network:sendDreamlandNewYearReq(type, param)
  local msg = ed.upmsg.dreamland_new_year_req()
  if type == "_query_rankboard" then
    msg._query_rankboard = ed.upmsg.dreamland_new_year_query_rankboard()
    msg._query_rankboard._type = param.type
    msg._query_rankboard._rank_left = param.rank_left
    msg._query_rankboard._rank_right = param.rank_right
  elseif type == "_daily_record" then
    msg._daily_record = ed.upmsg.dreamland_new_year_daily_record()
  end
  ed.pt(msg)
  ed.send(msg, "dreamland_new_year")
end

function network.sendBanMagnusBoostReq(id, amount)
  local msg = ed.upmsg.activity_req()
  msg._assist = ed.upmsg.activity_assist()
  msg._assist._act_id = id
  msg._assist._amount = amount
  ed.send(msg, "activity")
end

function network:dispatch(msg)
  if msg._open_panel then
    ed.runCricketManager:handleOpenPanel(msg._open_panel)
  elseif msg._get_task_rewards then
    ed.runCricketManager:handleGetTaskRewards(msg._get_task_rewards)
  elseif msg._get_line_rewards then
    ed.runCricketManager:handleGetLineRewards(msg._get_line_rewards, self.tmpLineId)
  end
end

function network:doSendReq(msg)
  print("------------------------runCricketManager:send------------------------")
  ed.pt(msg)
  ed.send(msg, "simple_assist")
end

function network:getReq()
  return ed.upmsg.simple_assist_req()
end

function network:sendSoloOpenPanel()
  local msg = self:getReq()
  msg._open_panel = ed.upmsg.simple_assist_open_panel()
  msg._open_panel._type = ed.runCricketManager.type
  self:doSendReq(msg)
end

function network:sendSoloGetTaskReward(taskId)
  self.tmpTaskId = taskId
  local msg = self:getReq()
  msg._get_task_rewards = ed.upmsg.simple_assist_get_task_rewards()
  msg._get_task_rewards._type = ed.runCricketManager.type
  msg._get_task_rewards._task_id = taskId
  self:doSendReq(msg)
end

function network:sendSoloGetLineReward(lineId)
  self.tmpLineId = lineId
  local msg = self:getReq()
  msg._get_line_rewards = ed.upmsg.simple_assist_get_line_rewards()
  msg._get_line_rewards._type = ed.runCricketManager.type
  msg._get_line_rewards._line_id = lineId
  self:doSendReq(msg)
end
