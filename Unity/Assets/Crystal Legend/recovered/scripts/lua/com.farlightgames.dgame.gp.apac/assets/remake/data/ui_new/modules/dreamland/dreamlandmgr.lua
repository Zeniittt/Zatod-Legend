module("ed.dreamland", package.seeall)
RefreshTime = {
  {h = "05", m = "00"},
  {h = "22", m = "00"}
}
DreamlandMgrScope = {}
DreamlandMgr = {}
DreamlandMgr.__index = DreamlandMgr

function DreamlandMgr.Create(summary)
  local dreamland_mgr = {}
  setmetatable(dreamland_mgr, DreamlandMgr)
  dreamland_mgr.what = "DreamlandMgr"
  summary = summary or {
    _current_stage = 0,
    _start_time = 0,
    _end_time = 0,
    _disappear_time = 0
  }
  dreamland_object = Dreamland.CreateWithSummary(summary)
  dreamland_mgr.dreamland = dreamland_object
  dreamland_mgr:ResetData()
  dreamland_mgr:InitEvents()
  dreamland_mgr.dreamlandTitanWar = false
  return dreamland_mgr
end

function DreamlandMgr:Destroy()
  CloseScope(DreamlandMgrScope)
end

function DreamlandMgr:ResetData()
  self.refresh_flag = {}
  for i, time in ipairs(RefreshTime) do
    self.refresh_flag[i] = false
  end
end

function DreamlandMgr:RefreshState()
  return self.dreamland:RefreshState()
end

function DreamlandMgr:InitEvents()
  ListenTimer(Timer:Always(1), function()
    self:Update(1)
  end, DreamlandMgrScope)
end

function DreamlandMgr:Update(dt)
  if self:RefreshState() then
    EDLog("DreamlandStateChange:" .. self.dreamland:GetState())
    FireEvent("DreamlandStateChange", self.dreamland:GetState())
  end
  local _, _, d, h, m = ed.time2YMDHMS()
  for i, time in ipairs(RefreshTime) do
    if self.refresh_flag[i] == false and time.h == h and time.m == m then
      FireEvent("DreamlandRequestSummary")
      EDLog("DreamlandRequestSummary")
      self.refresh_flag[i] = true
      self.cross_day_flag = nil
      break
    end
  end
  if self.cross_day_flag == nil and self.prev_update_day ~= d then
    self.cross_day_flag = true
    self:ResetData()
    FireEvent("DreamlandRequestSummary")
  end
  self.prev_update_day = d
end

function DreamlandMgr:setFairPlay(id)
  self.fairPlayActivityId = id
end

function DreamlandMgr:isFairPlay()
  return nil ~= self.fairPlayActivityId and 0 ~= self.fairPlayActivityId
end

function DreamlandMgr:getFairPlayMaxStar()
  local maxStar = 10
  if self.fairPlayActivityId and 0 ~= self.fairPlayActivityId then
    local extra = ed.lookupDataTable("FixedActlist", "Extra_AN", self.fairPlayActivityId % 100)
    if extra and 1 <= #extra then
      maxStar = extra[1]
    end
  end
  return maxStar
end

function DreamlandMgr:getFairPlayStageSkill()
  self.fairPlayActivityId = self.fairPlayActivityId or 0
  local skills = {}
  local extra = ed.lookupDataTable("FixedActlist", "Extra_AN", self.fairPlayActivityId % 100)
  if nil == extra or #extra < 2 then
    return skills
  end
  local stageSkillId = extra[2]
  if stageSkillId == nil or stageSkillId <= 0 then
    return skills
  end
  local stageSkill = ed.lookupDataTable("StageSkill", nil, stageSkillId)
  if nil == stageSkill then
    print("No stage skill", stageSkillId)
    return skills
  end
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

function DreamlandMgr:setTitanWar(isTiranWar)
  self.dreamlandTitanWar = isTiranWar
end

function DreamlandMgr:isTitanWar()
  return self.dreamlandTitanWar
end

function DreamlandMgr:isBossLimit()
  return self.dreamlandTitanWar and ed.player:getLevel() < 100, 100
end

function DreamlandMgr:getStageLimit()
  return self.dreamlandTitanWar and {
    type = "HeroIsTitan",
    detail = "True"
  } or {}
end
