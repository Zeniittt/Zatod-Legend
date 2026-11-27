local taskNetwork = {}

function taskNetwork:dailyjobOpen()
  local msg = ed.upmsg.dailyjob()
  msg._dailyjob_open_panel = ed.upmsg.dailyjob_open_panel()
  ed.send(msg, "dailyjob")
end

function taskNetwork:dailyjobReward(taskid)
  self.newDaliyTaskId = taskid
  local msg = ed.upmsg.job_rewards()
  msg._job = taskid
  ed.send(msg, "job_rewards")
end

function taskNetwork:sendOpenChest(chestid)
  local msg = ed.upmsg.dailyjob()
  msg._dailyjob_open_chest = ed.upmsg.dailyjob_open_chest()
  msg._dailyjob_open_chest._chest_id = chestid
  ed.send(msg, "dailyjob")
end

function taskNetwork:dailyOnekey(jobs)
  local msg = ed.upmsg.dailyjob()
  msg._dailyjob_one_key = ed.upmsg.dailyjob_onekey()
  msg._dailyjob_one_key._job = jobs
  ed.send(msg, "dailyjob")
end

function taskNetwork:dailyjobReply(info)
  info = ed.copyProto(info)
  info.newDaliyTaskId = self.newDaliyTaskId
  self.newDaliyTaskId = nil
  if nil ~= info._dailyjob_open_panel and nil ~= info._dailyjob_open_panel._module_type then
    ed.weeklyjobData:weeklyjobDataReply(info)
    return
  end
  if nil ~= info._job_rewards_reply and nil ~= info.newDaliyTaskId then
    local todoTableData = ed.getDataTable("Todolist")[info.newDaliyTaskId]
    if nil ~= todoTableData and todoTableData["Mission Type"] == "WeeklyMission" then
      ed.weeklyjobData:weeklyjobRewardReply(info)
      return
    end
  end
  local refreshType = ed.taskData:taskReply("day", info)
  FireEvent("dailyjobReply", refreshType)
end

function taskNetwork:taskPassPush()
  local req = ed.upmsg.daily_pass_req()
  req._open_panel = ed.upmsg.daily_pass_open_panel()
  ed.send(req, "daily_pass")
end

function taskNetwork:sendLevelReward(level, index, isAdvanced)
  local req = ed.upmsg.daily_pass_req()
  req._level_reward = ed.upmsg.daily_pass_level_reward()
  req._level_reward._index = level
  req._level_reward._reward_index = index or 1
  req._level_reward._is_advanced = isAdvanced and 1 or 0
  ed.send(req, "daily_pass")
end

function taskNetwork:sendDailyPassSweep()
  local req = ed.upmsg.daily_pass_req()
  req._sweep_reward = ed.upmsg.daily_pass_sweep_reward()
  ed.send(req, "daily_pass")
end

function taskNetwork:sendDailyPassBuyLevel(lv)
  local req = ed.upmsg.daily_pass_req()
  req._buy_level = ed.upmsg.daily_pass_buy_level()
  req._buy_level._buy_levels = lv
  ed.pt(req)
  ed.send(req, "daily_pass")
end

function taskNetwork:taskPassReply(info)
  local refreshType = ed.taskData:taskReply("pass", info)
  FireEvent("passReply", refreshType)
  FireEvent("DailyPassReply")
end

function taskNetwork:requireRewards(chain, id)
  ed.netdata.requireRewards = {chain = chain, id = id}
  ed.netreply.requireRewards = self:netreplyRewards()
  local msg = ed.upmsg.require_rewards()
  msg._line = chain
  msg._id = id
  ed.send(msg, "require_rewards")
end

function taskNetwork:netreplyRewards()
  return function(reply, param)
    reply = ed.copyProto(reply)
    reply._result = reply._result or "success"
    if reply._result ~= "success" then
      ed.showToast(T("\228\187\187\229\138\161\230\143\144\228\186\164\229\164\177\232\180\165"))
    else
      local item = {}
      for k, v in pairs(reply._rewards or {}) do
        if v._type == "money" then
          v._type = "gold"
        end
        table.insert(item, v)
      end
      if item and 0 < #item then
        local rewards = {}
        for i, v in ipairs(item) do
          table.insert(rewards, {
            id = v._id,
            type = v._type,
            amount = v._amount
          })
        end
        local geftItem, exceedItem, giveItemAll = ed.itemExceeds(rewards)
        ed.ui.maillocalbox.create({
          type = "addItem",
          item = giveItemAll or {}
        }):popWindow()
        ed.player:addRewards(item)
      end
      local tl = ed.player:getTaskList()
      for k, v in pairs(tl) do
        if param.chain == v._line and param.id == v._id then
          tl[k]._status = "finished"
        end
      end
      local refreshType = ed.taskData:taskReply("role", reply)
      FireEvent("roleTaskReply", refreshType)
    end
  end
end

function taskNetwork:achievementPush(this)
  local msg = ed.upmsg.achievement()
  msg._open_panel = ed.upmsg.achievement_open_panel
  ed.send(msg, "achievement")
  return this or false
end

function taskNetwork:achRequireRewards(param)
  local msg = ed.upmsg.achievement()
  msg._require_rewards = ed.upmsg.achievement_require_rewards
  msg._require_rewards._type = param.type
  msg._require_rewards._id = param.id
  msg._require_rewards._line_id = param.line_id
  ed.send(msg, "achievement")
end

function taskNetwork:requirePointRewards(id)
  print("param ============== param == id ===", id)
  local msg = ed.upmsg.achievement()
  msg._point_reward = ed.upmsg.achievement_point_reward
  msg._point_reward._id = id
  ed.send(msg, "achievement")
end

function taskNetwork:achievementReply(info)
  local refreshType = ed.taskData:taskReply("ach", info)
  FireEvent("achTaskReply", refreshType)
end

function taskNetwork:sendWeeklyjob(type)
  local msg = ed.upmsg.dailyjob()
  msg._dailyjob_open_panel = ed.upmsg.dailyjob_open_panel()
  msg._dailyjob_open_panel._type = ed.weeklyjobData:convertToServerTypeByModuleType(type)
  ed.send(msg, "dailyjob")
end

ed.taskNetwork = setmetatable({}, {__index = taskNetwork})
