module("ed.activity", package.seeall)
Tools = {}
Tools.__index = Tools

local function getActDescByStartTime(startTime)
  local start_time = startTime
  local time_current = ed.getServerTime()
  local _, _, _, h_target, m_target, _ = ed.time2YMDHMS(start_time)
  local _, _, _, h_current, m_current, s_current = ed.time2YMDHMS(time_current)
  local ground_zero = time_current - h_current * 3600 - m_current * 60 - s_current
  local seconds_one_day = 86400
  local delta_day = math.floor((start_time - ground_zero) / seconds_one_day)
  local deadline_desc = ""
  if delta_day == 0 then
    deadline_desc = T("\228\187\138\229\164\169%s:%s\229\188\128\229\167\139", h_target, m_target)
  elseif delta_day == 1 then
    deadline_desc = T("\230\152\142\229\164\169%s:%s\229\188\128\229\167\139", h_target, m_target)
  else
    deadline_desc = T("%s\229\164\169\229\144\142\229\188\128\229\167\139", delta_day)
  end
  return deadline_desc
end

local function getActDescByEndTime(endTime)
  local time_current = ed.getServerTime()
  local _, _, _, h_target, m_target, _ = ed.time2YMDHMS(endTime)
  local _, _, _, h_current, m_current, s_current = ed.time2YMDHMS(time_current)
  local ground_zero = time_current - h_current * 3600 - m_current * 60 - s_current
  local seconds_one_day = 86400
  local delta_day = math.floor((endTime - ground_zero) / seconds_one_day)
  local deadline_desc = ""
  if delta_day == 0 then
    deadline_desc = T("\228\187\138\229\164\169%s:%s\230\136\170\230\173\162", h_target, m_target)
  elseif delta_day == 1 then
    deadline_desc = T("\230\152\142\229\164\169%s:%s\230\136\170\230\173\162", h_target, m_target)
  else
    deadline_desc = T("%s\229\164\169\229\144\142\230\136\170\230\173\162", delta_day)
  end
  return deadline_desc
end

local function getRedBagActivity(info)
  local lenght = #info
  for i = 1, lenght do
    local acInfo = info[i]
    if acInfo._type == "add_up_red_envelope" then
      for k = i, lenght do
        local remainAcInfo = info[k]
        if remainAcInfo._type == "red_envelope" then
          return remainAcInfo
        end
      end
      return acInfo
    elseif acInfo._type == "red_envelope" then
      return acInfo
    end
  end
end

local function onlineIsFinished(reward)
  local currentTime = ed.getYMDHMS(ed.getServerTime())
  local getReardsTime = ed.getYMDHMS(reward._dailyjob._last_rewards_time)
  if currentTime.year > getReardsTime.year then
    return false
  end
  if currentTime.month > getReardsTime.month then
    return false
  end
  if currentTime.day > getReardsTime.day then
    return false
  end
  if tonumber(currentTime.hour) < 5 and tonumber(currentTime.hour) > 5 then
    return false
  end
  return true
end

local function isFinished(type, reward, info)
  if type == "add_up_red_envelope" then
    return false
  elseif type == "save_overflow_vitality" then
    return info._end_time <= ed.getServerTime()
  elseif type == "online" then
    local finished = onlineIsFinished(reward)
    return finished
  elseif type == "rt2v2_rewards" then
    return info._end_time <= ed.getServerTime()
  else
    return reward._dailyjob._last_rewards_time ~= 0
  end
  return false
end

local function canGetReward(type, reward)
  if type == "add_up_red_envelope" then
    return not ed.ui.newRedBag:checkGetted(reward._dailyjob._last_rewards_time or 0)
  elseif type == "save_overflow_vitality" then
    return 0 < reward._rewards[1]._amount
  elseif type == "online" then
    return 0 < ed.onTimeActivityCanGetNum
  elseif type == "rt2v2_rewards" then
    return (reward._amount or 1) <= (reward._dailyjob._task_target or 0) and ed.checkTwoDateod(reward._dailyjob._last_rewards_time)
  else
    return (reward._amount or 1) <= (reward._dailyjob._task_target or 0)
  end
  return false
end

local function getActivityTypeByRewards(info)
  local type = info._type
  if not info._rewards or type == "vitality_rewards" then
    return "present"
  else
    local canget, finish = 0, 0
    local rewards = #info._rewards
    for __, reward in ipairs(info._rewards) do
      if reward._dailyjob then
        if isFinished(type, reward, info) then
          finish = finish + 1
        elseif canGetReward(type, reward) then
          canget = canget + 1
        end
      end
      if type == "compose" and ed.isEquipCraftable(reward._extra_reward_info._compose_info._item_id) then
        canget = canget + 1
      end
    end
    EDLog(T("activity state :: %s,%s,%s ", finish, canget, rewards))
    if finish == rewards then
      return "completed"
    elseif 0 < canget then
      return "canReward"
    else
      return "present"
    end
  end
end

local function creatOnTimesData(info)
  ed.ui.onTimeData = {}
  local infoData = info
  ed.onTimeActivityCanGetNum = 0
  if infoData == nil then
    return
  end
  local rewardList = infoData._rewards
  for i, rewardInfo in ipairs(rewardList) do
    local reward_info = rewardInfo
    local user_job = reward_info._dailyjob
    local job_id = user_job._id
    local job_last_get_time = user_job._last_rewards_time
    local job_target = user_job._task_target
    local job_state = 4
    local y, mon, last_d, h, m, s = ed.time2YMDHMS(job_last_get_time)
    local y1, m1, cur_d = ed.time2YMD(ed.getServerTime())
    local starTime = ed.getServerTime() + reward_info._amount - job_target
    local times = reward_info._amount - job_target
    if job_target >= reward_info._amount and ed.checkTwoDateod(job_last_get_time) then
      ed.onTimeActivityCanGetNum = ed.onTimeActivityCanGetNum + 1
    end
    local data = {
      id = job_id,
      state = job_state,
      times = times,
      amount = reward_info._amount,
      starTime = starTime
    }
    if ed.ui.onTimeData[job_id] == nil then
      ed.ui.onTimeData[job_id] = data
    end
  end
end

function Tools.getSelActivity(info)
  local info = info or {}
  if ed.ui.redBag.isJoinRedBagActivity() then
    ed.ui.redBag.clearIsJoinRedBagActivity()
    local acInfo = getRedBagActivity(info)
    if acInfo then
      return acInfo
    end
  end
  local selActivity = ed.activity.Activity.getSelectActivityInfo()
  local selId = selActivity._id
  if selId then
    for __, acInfo in ipairs(info) do
      if acInfo._id == selId then
        return acInfo
      end
    end
  else
    for __, acInfo in ipairs(info) do
      if acInfo._show == 1 then
        return acInfo
      end
    end
  end
  return nil
end

function Tools.getActivityType(info)
  local current_time = ed.getServerTime()
  if info._type == "online" then
    creatOnTimesData(info)
  end
  if info._show == 1 then
    if current_time <= info._end_time and current_time > info._start_time then
      local type = getActivityTypeByRewards(info)
      return type
    elseif current_time > info._end_time then
      return "finished"
    else
      return "future"
    end
  end
  return "unknown"
end

function Tools.getActivityPower(type)
  local power = 0
  if type == "canReward" then
    power = 5
  elseif type == "present" then
    power = 4
  elseif type == "future" then
    power = 3
  elseif type == "finished" then
    power = 2
  elseif type == "completed" then
    power = 1
  end
  return power
end

function Tools.getActDesc(data)
  local info = data.info
  local description = ""
  if data.type == "canReward" then
    if data.info._type == "super_exchange" then
      description = T("\229\143\175\229\133\145\230\141\162")
    else
      description = T("\229\143\175\233\162\134\229\165\150")
    end
  elseif data.type == "present" then
    if info._extra_info._is_open_svr == 1 then
      description = T("\230\176\184\228\185\133")
    else
      description = getActDescByEndTime(info._end_time)
    end
  elseif data.type == "finished" then
    description = T("\232\175\165\230\180\187\229\138\168\229\183\178\231\187\147\230\157\159")
  elseif data.type == "future" then
    description = getActDescByStartTime(info._start_time)
  elseif data.type == "completed" and data.info._type ~= "super_exchange" then
    description = T("\229\183\178\229\174\140\230\136\144")
  end
  return description
end
