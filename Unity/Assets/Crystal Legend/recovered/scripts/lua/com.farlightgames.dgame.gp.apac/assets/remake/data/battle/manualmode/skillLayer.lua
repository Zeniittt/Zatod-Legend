module("ed.ManualMode", package.seeall)
SkillLayer = {}
SkillLayer.__index = SkillLayer

function SkillLayer:Create()
  local obj = {}
  setmetatable(obj, SkillLayer)
  obj:Init()
  return obj
end

function SkillLayer:Init()
  self:InitWindow()
end

function SkillLayer:SetManager(manager)
  self.manager = manager
end

function SkillLayer:InitWindow()
  self.mainTouchPriority = -250
  local mainLayer = CCLayer:create()
  self.mainLayer = mainLayer
end

function SkillLayer:InitSkills()
  local ui = {}
  local skills = self.manager.unit.skill_list
  for k = 1, #skills do
    local skill_1 = ed.createSprite("UI/DOTA-ITEM/053.png")
    skill_1:setPosition(ccp(400 + 70 * (k - 1), 50))
    table.insert(ui, skill_1)
    self.mainLayer:addChild(skill_1)
  end
  self.ui = ui
end

function SkillLayer:IsTouching(event, x, y)
  for k, skill_icon in pairs(self.ui) do
    if ed.containsPoint(skill_icon, x, y) then
      self.touch_index = k
      return true
    end
  end
  return false
end

function SkillLayer:TouchHandler(event, x, y)
  if event == "began" then
  elseif event == "moved" then
  elseif event == "ended" then
    local unit = self.manager.unit
    local target = unit.ai:searchTarget()
    if target then
      local skill = unit.skill_list[self.touch_index]
      self.manager.unit:castSkill(skill, target)
    end
    print("cast skill " .. self.touch_index)
    self.touch_index = nil
  end
end
