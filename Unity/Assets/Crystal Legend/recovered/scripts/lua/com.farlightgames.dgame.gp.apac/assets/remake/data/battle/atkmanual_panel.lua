module("ed", package.seeall)
AtkManuakPanel = {}
AtkManuakPanel.__index = AtkManuakPanel
local AtkManuakPanelScope = {}

function AtkManuakPanel.create(params)
  local obj = {}
  setmetatable(obj, AtkManuakPanel)
  obj:initWindow(params)
  return obj
end

function AtkManuakPanel:initWindow(params)
  self.params = params
  self.unit = params.unit
  self.dir = params.dir or "right"
  self.skill_icons = {}
  self.skill_state = {}
  self.container = CCLayer:create()
  self:initAllSkills()
  self.currentStage = 1
  self:createSkillIcons()
end

function AtkManuakPanel:registerEvents()
end

function AtkManuakPanel:unRegisterEvents()
  CloseScope(AtkManuakPanelScope)
end

function AtkManuakPanel:update(dt)
  self:updateStage()
  for _, summery in ipairs(self.skill_icons) do
    local skill = self.unit:getSkillBySlot(summery.slot)
    self:updateIcon(summery)
    self:updateTime(summery, skill)
  end
end

function AtkManuakPanel:updateStage()
  if self.currentStage ~= self.unit.currentActionStage then
    self.currentStage = self.unit.currentActionStage
    self:createSkillIcons()
  end
end

function AtkManuakPanel:updateTime(summery, skill)
  if not self.unit:isAlive() then
    return
  end
  if skill then
    local maxTime = skill.info.CD or 1
    local nowTime = skill:getSkillCDRemaining()
    local intTime = math.ceil(nowTime)
    self:changeTimeIconState(summery, intTime)
    if 99 < intTime then
      summery.time.node:setVisible(false)
      summery.ifCD:setVisible(true)
    elseif 0 < intTime then
      summery.time.node:setVisible(true)
      summery.ifCD:setVisible(false)
      ed.refreshNumberNode(summery.time, "", {text = intTime, folder = "golden"})
    end
    if 0 <= nowTime then
      local percent = math.min(nowTime / maxTime, 1)
      percent = math.max(percent, 0)
      summery.mask:setTextureRect(CCRectMake(0, 0, 64, 64 * percent))
    end
  end
end

function AtkManuakPanel:changeTimeIconState(summery, intTime)
  summery.time.node:setVisible(0 < intTime)
end

function AtkManuakPanel:updateIcon(summery)
  if not self.unit:isAlive() then
    summery.layer:setVisible(false)
    return
  end
  local icon = summery.icon
  local slot = summery.slot
  self.skill_state[slot] = self.skill_state[slot] or {}
  local lastState = self.skill_state[slot].icon_shader
  local nowState = self:needIconGray(slot)
  if lastState == nowState then
    return
  end
  if nowState then
    ed.resetSpriteShader(icon)
  else
    ed.setSpriteGray(icon)
  end
  self.skill_state[slot].icon_shader = nowState
end

function AtkManuakPanel:destroy()
  self:unRegisterEvents()
  self.skill_icons = {}
end

function AtkManuakPanel:initAllSkills()
  self.allSkills = {}
  local tid = self.unit.tid
  local periodGroup = ed.lookupDataTable("Unit", "Period Group", tid)
  if periodGroup and periodGroup ~= 0 then
    local periods = ed.lookupDataTable("Period", nil, periodGroup)
    for _, period in pairs(periods) do
      local stage = period.Period
      self.allSkills[stage] = self.allSkills[stage] or {}
      local list = period["Skill List"]
      for _, gid in ipairs(list) do
        local slot = self:findSlotByGroupId(tid, gid)
        if slot then
          table.insert(self.allSkills[stage], {
            gid = tonumber(gid),
            slot = tonumber(slot)
          })
        end
      end
    end
  else
    self.allSkills[1] = self.allSkills[1] or {}
    local sgt = ed.lookupDataTable("SkillGroup", nil, tid) or {}
    for _, skill in pairs(sgt) do
      if skill["Atk Manual"] then
        table.insert(self.allSkills[1], {
          gid = tonumber(skill["Skill Group ID"]),
          slot = tonumber(skill.Slot)
        })
      end
    end
  end
end

function AtkManuakPanel:findSlotByGroupId(tid, gid)
  local sgt = ed.lookupDataTable("SkillGroup", nil, tid)
  for _, skill in pairs(sgt) do
    local id = skill["Skill Group ID"] or 0
    if skill["Atk Manual"] and tonumber(id) == tonumber(gid) then
      return skill.Slot
    end
  end
end

function AtkManuakPanel:createSkillIcons()
  local stage = self.currentStage
  local tid = self.unit.tid
  local skills = self.allSkills[stage]
  if not skills then
    return
  end
  self:clearSkillIcons()
  local cache = ed.createSprite()
  self.container:addChild(cache)
  self.cacheLayer = cache
  for _, skill in ipairs(skills) do
    local gid = skill.gid
    local slot = skill.slot
    local layer, icon, time, mask, ifCD = self:createSkillIcon(tid, slot)
    layer:setPosition(self:getSkillIconNextPos())
    cache:addChild(layer)
    table.insert(self.skill_icons, {
      gid = gid,
      slot = slot,
      layer = layer,
      icon = icon,
      time = time,
      mask = mask,
      ifCD = ifCD
    })
  end
  self:registerTouchLayer()
end

function AtkManuakPanel:createSkillIcon(tid, slot)
  local layer = CCSprite:create()
  layer:setScale(1)
  local bg = ed.createSprite("UI/alpha/1080P/common/gocha.png")
  local icon_res = ed.readhero.getSkillIconRes(tid, slot)
  local icon = ed.createSprite(icon_res)
  local mask = ed.createSprite("UI/alpha/HVGA/cdmask.png")
  mask:setAnchorPoint(ccp(0.5, 0))
  mask:setPosition(ccp(0, -32))
  mask:setTextureRect(CCRectMake(0, 0, 64, 0))
  local frame = ed.createSprite("UI/alpha/HVGA/equip_frame_white.png")
  local infiniteCD = ed.createSprite("UI/alpha/HVGA/multiplayer_battle/infinite_cd.png")
  local time = ed.getNumberNode({text = 0, folder = "golden"})
  layer:addChild(bg)
  layer:addChild(icon)
  layer:addChild(mask)
  layer:addChild(frame)
  layer:addChild(time.node)
  layer:addChild(infiniteCD)
  return layer, icon, time, mask, infiniteCD
end

function AtkManuakPanel:clearSkillIcons()
  self.skill_icons = {}
  self.skill_state = {}
  if self.cacheLayer then
    self.cacheLayer:removeFromParentAndCleanup(true)
    self.cacheLayer = nil
  end
end

function AtkManuakPanel:getSkillIconNextPos()
  local dir = self.dir == "right" and 1 or -1
  return ccp(dir * 90 + dir * 75 * #self.skill_icons, 85)
end

function AtkManuakPanel:registerTouchLayer()
  local touch_node = ed.ui.basetouchnode.btCreate()
  self.container:setTouchEnabled(true)
  self.container:registerScriptTouchHandler(touch_node:btGetMainTouchHandler(), false, -130, false)
  for idx, summery in pairs(self.skill_icons) do
    touch_node:btRegisterButtonClick({
      button = summery.icon,
      key = "atk_skill_" .. idx,
      force = true,
      clickHandler = function()
        self:triggerSkill(summery.slot)
      end,
      pressHandler = function()
        summery.layer:setScale(0.95)
      end,
      cancelPressHandler = function()
        summery.layer:setScale(1)
      end
    })
  end
end

function AtkManuakPanel:canTriggerSkill(slot)
  local unitCurrentSkill = self.unit.current_skill
  if self.unit.manual_skill and self.unit.manual_skill == unitCurrentSkill then
    return false
  end
  local stage = self.currentStage
  local skills = self.allSkills[stage] or {}
  for _, skill in ipairs(skills) do
    if unitCurrentSkill == skill then
      return false
    end
  end
  local skill = self.unit:getSkillBySlot(slot)
  if not skill then
    return false
  end
  local cdtime = skill:getSkillCDRemaining()
  if cdtime and 0 < cdtime then
    return false
  end
  return skill.can_cast
end

function AtkManuakPanel:triggerSkill(slot)
  if self:canTriggerSkill(slot) then
    ed.engine:manuallyCastSkill(self.unit, slot)
    return true
  end
  return false
end

function AtkManuakPanel:autoCastSkill()
  for _, summery in pairs(self.skill_icons) do
    local isTrigger = self:triggerSkill(summery.slot)
    if isTrigger then
      break
    end
  end
end

function AtkManuakPanel:needIconGray(slot)
  local skill = self.unit:getSkillBySlot(slot)
  if not skill then
    return false
  end
  local cdtime = skill:getSkillCDRemaining()
  if cdtime and 0 < cdtime then
    return true
  end
  local canTrigger = self:canTriggerSkill(slot)
  return canTrigger
end
