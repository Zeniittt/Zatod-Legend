module("ed.dreamland", package.seeall)
chance_count_max = 5
chance_count_min = 0
damage_step_goal = 10000
boss_skill_slot_max = 6
DreamlandStates = {
  [1] = "none",
  [2] = "prepare",
  [3] = "open",
  [4] = "ended"
}
Dreamland = {}
Dreamland.__index = Dreamland

function Dreamland.Create(info)
  local dreamland = {}
  dreamland.what = "Dreamland"
  setmetatable(dreamland, Dreamland)
  info = info or {}
  dreamland.stage_id = info._summary._current_stage
  dreamland.time_start = info._summary._start_time
  dreamland.time_end = info._summary._end_time
  dreamland.time_disappear = info._summary._disappear_time
  dreamland.chance_count = info._left_chance
  dreamland.top_damage = info._top_damage or 0
  dreamland.top_damage_previous = dreamland.top_damage
  dreamland.rank = info._current_rank or 0
  dreamland.globalRank = 99999
  dreamland.chance_buy_times = info._times or 0
  dreamland.activity_open = info._rank_act_open
  dreamland.available_heroes = info._available_heroes
  dreamland:InitState()
  return dreamland
end

function Dreamland.CreateWithSummary(summary)
  local dreamland = {}
  dreamland.what = "Dreamland"
  setmetatable(dreamland, Dreamland)
  summary = summary or {}
  dreamland.stage_id = summary._current_stage
  dreamland.time_start = summary._start_time
  dreamland.time_end = summary._end_time
  dreamland.time_disappear = summary._disappear_time
  dreamland.chance_count = 0
  dreamland.top_damage = 0
  dreamland.top_damage_previous = 0
  dreamland.rank = 0
  dreamland.globalRank = 99999
  dreamland.chance_buy_times = 0
  dreamland.activity_open = false
  dreamland.available_heroes = nil
  dreamland:InitState()
  return dreamland
end

function Dreamland:Destroy()
end

function Dreamland:ResetSummary(summary)
  self.stage_id = summary._current_stage
  self.time_start = summary._start_time
  self.time_end = summary._end_time
  self.time_disappear = summary._disappear_time
end

function Dreamland:ResetData(info)
  self:ResetSummary(info._summary)
  self.chance_count = info._left_chance or self.chance_count
  self.top_damage = info._top_damage or self.top_damage
  self.rank = info._current_rank or self.rank
  self.chance_buy_times = info._times or self.chance_buy_times
  self.activity_open = info._rank_act_open
  self.available_heroes = info._available_heroes
end

function Dreamland:InitState()
  if self.stage_id == 0 then
    self.state = "none"
    return
  end
  local time_current = ed.getServerTime()
  if time_current < self.time_start then
    self.state = "prepare"
  elseif time_current < self.time_end then
    self.state = "open"
  elseif time_current < self.time_disappear then
    self.state = "ended"
  else
    self.state = "none"
  end
end

function Dreamland:RefreshState()
  local state_prev = self.state or "none"
  if self.stage_id == 0 then
    self.state = "none"
    return state_prev ~= self.state
  end
  local time_current = ed.getServerTime()
  if time_current < self.time_start then
    self.state = "prepare"
  elseif time_current < self.time_end then
    self.state = "open"
  elseif time_current < self.time_disappear then
    self.state = "ended"
  else
    self.state = "none"
  end
  return state_prev ~= self.state
end

function Dreamland:IsPrepare()
  return self.state == "prepare"
end

function Dreamland:IsOpen()
  return self.state == "open"
end

function Dreamland:IsNone()
  return self.state == "none"
end

function Dreamland:IsEnded()
  return self.state == "ended"
end

function Dreamland:GetState()
  return self.state
end

function Dreamland:Tick(dt)
end

function Dreamland:GetStage()
  return self.stage_id
end

function Dreamland:SetTopDamage(damage)
  if damage == nil or damage < self.top_damage then
    EDLog("ERROR: Wrong top damage data in dreamland!")
  else
    self.top_damage = damage
  end
end

function Dreamland:GetTopDamage()
  return self.top_damage
end

function Dreamland:SavePreviousTopDamage()
  self.top_damage_previous = self.top_damage
end

function Dreamland:GetPreviousTopDamage()
  return self.top_damage_previous
end

function Dreamland:SetCurrentDamage(damage)
  self.current_damage = damage
end

function Dreamland:GetCurrentDamage()
  return self.current_damage or 0
end

function Dreamland:SetRank(rank)
  self.rank = rank or self.rank
end

function Dreamland:GetRank()
  return self.rank
end

function Dreamland:SetGlobalRank(rank)
  self.globalRank = rank or self.globalRank
  print(rank, self.globalRank)
end

function Dreamland:GetGlobalRank()
  return self.globalRank
end

function Dreamland:GetRankInterval()
  local rank_begin, rank_end = 1, 1
  local rank_reward_tbl = ed.getDataTable("DreamlandRankReward")
  for i, row_data in ipairs(rank_reward_tbl) do
    if self.rank <= row_data["Floor Rank"] then
      rank_begin = rank_reward_tbl[i - 1] and rank_reward_tbl[i - 1]["Floor Rank"] + 1 or rank_begin
      rank_end = row_data["Floor Rank"]
      break
    end
  end
  if rank_begin > rank_end then
    rank_end = rank_begin + 100000
  end
  return rank_begin, rank_end
end

function Dreamland:GetChance()
  return self.chance_count
end

function Dreamland:SetChanceBuyTimes(times)
  self.chance_buy_times = times
end

function Dreamland:GetChanceBuyTimes()
  return self.chance_buy_times
end

function Dreamland:CanBuyChance()
  local vip_level = ed.player:getvip()
  local max_time = ed.getDataTable("VIP")[vip_level]["Dreamland Buy"]
  return max_time - self.chance_buy_times > 0
end

function Dreamland:AddChance()
  self.chance_count = self.chance_count + 1
  if self.chance_count > chance_count_max then
    EDLog("ERROR:Dreamland challenge chance reach the max!")
    self.chance_count = chance_count_max
    return false, self.chance_count
  end
  return true, self.chance_count
end

function Dreamland:MinusChance()
  self.chance_count = self.chance_count - 1
  if self.chance_count < chance_count_min then
    EDLog("ERROR:Dreamland challenge chance reach the max!")
    self.chance_count = chance_count_min
    return false, self.chance_count
  end
  return true, self.chance_count
end

function Dreamland:ResetChance()
  self.chance_count = chance_count_max
end

local date_string_map = {
  [0] = T("\228\187\138\229\164\169"),
  [1] = T("\230\152\142\229\164\169"),
  [2] = T("\229\144\142\229\164\169")
}

function Dreamland:GetStartTimeString()
  return self:GetTimeString(self.time_start)
end

function Dreamland:GetEndTimeString()
  return self:GetTimeString(self.time_end)
end

local seconds_one_day = 86400

function Dreamland:GetTimeString(time)
  local result_string = ""
  local time_current = ed.getServerTime()
  if time <= time_current then
    return ""
  end
  local _, _, _, h_target, m_target, _ = ed.time2YMDHMS(ed.time2China(time))
  local _, _, _, h_current, m_current, s_current = ed.time2YMDHMS(ed.time2China(time_current))
  local ground_zero = time_current - h_current * 3600 - m_current * 60 - s_current + 1
  local delta_day = math.floor((time - ground_zero) / seconds_one_day)
  local date_string = date_string_map[delta_day]
  if date_string == nil then
    date_string = tostring(delta_day) .. "\229\164\169\229\144\142"
  end
  local time_string = string.format("%02d:%02d", h_target, m_target)
  result_string = T(date_string .. time_string)
  return result_string
end

function Dreamland:GetRewardData()
  local rank_reward_tbl = ed.getDataTable("DreamlandRankReward")
  local reward_idx
  local reward_data = {}
  if self.rank and self.rank ~= 0 then
    for i, row_data in ipairs(rank_reward_tbl) do
      if self.rank <= row_data["Floor Rank"] then
        reward_idx = i
        reward_data = row_data
        break
      end
    end
  end
  return reward_data
end

function Dreamland:GetRankRewardData()
  local function func(rankReward)
    local rank, rankData = 0, {}
    
    for i, v in ipairs(rankReward) do
      local items = {}
      for t = 1, 7 do
        local reward_type = v["Reward Type " .. t]
        if reward_type then
          local reward_amount = v["Reward Amount " .. t]
          if 0 < reward_amount then
            table.insert(items, {
              type = reward_type,
              amount = reward_amount,
              id = v["Reward ID " .. t]
            })
          end
        end
      end
      table.insert(rankData, {
        rank = rank + 1,
        floorRank = v["Floor Rank"],
        items = items
      })
      rank = v["Floor Rank"]
    end
    return rankData
  end
  
  return func(ed.getDataTable("DreamlandRankReward")), func(ed.getDataTable("DreamlandGuildReward"))
end

function Dreamland:GetBossSkillData()
  local desc_row = ed.lookupDataTable("DreamlandBossDesc", nil, self.stage_id)
  local desc = T(desc_row["Boss Desc"])
  local boss_unit_id = desc_row["Unit ID"]
  local skill_group_tbl = ed.getDataTable("SkillGroup")
  local skill_data_tbl = ed.getDataTable("Skill")
  local skill_info = {}
  for i = 1, boss_skill_slot_max do
    local slot_id = desc_row["Slot " .. i]
    if slot_id and 0 < slot_id then
      local skill_group_row = skill_group_tbl[boss_unit_id][slot_id]
      local skill_group_id = skill_group_row["Skill Group ID"]
      local skill_row = skill_data_tbl[skill_group_id][0]
      table.insert(skill_info, {
        id = skill_group_id,
        skill_group_row = skill_group_row,
        skill_row = skill_row
      })
    end
  end
  local result = {
    unit_id = boss_unit_id,
    desc = desc,
    skills = skill_info
  }
  return result
end

function Dreamland:setBattleGroupInfo(info)
  self.battleGroupInfo = info
end

function Dreamland:getBattleGroupInfo()
  return self.battleGroupInfo or {}
end

function Dreamland:setUnitDamage(list)
  self.unitDamage = list
end

function Dreamland:getUnitDamage()
  return self.unitDamage or {}
end

function Dreamland:getActivityOpen()
  return self.activity_open == 1
end

function Dreamland:getAvailableHeroes()
  return self.available_heroes
end

function Dreamland:getStageSkills()
  local skills = {}
  local stageSkillId = ed.player:getDreamlandStageBuffId()
  if stageSkillId == nil or stageSkillId <= 0 then
    return skills
  end
  local stageSkill = ed.lookupDataTable("StageSkill", nil, stageSkillId)
  local iconkeyStr = "Skill %d Icon"
  local deskeyStr = "Skill %d Description"
  for i = 1, 3 do
    local iconkey = string.format(iconkeyStr, i)
    local iconRes = stageSkill[iconkey]
    local deskey = string.format(deskeyStr, i)
    local des = stageSkill[deskey]
    if iconRes and des then
      skills[i] = {iconRes = iconRes, des = des}
    end
  end
  return skills
end
