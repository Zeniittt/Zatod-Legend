module("ed.multiArena", package.seeall)
Magic = {}
Magic.__index = Magic
local search_cd = 0.125

function Magic.GetMagicCostEnergy(id)
  local cost = ed.getDataTable("MultiArenaMagic")[id]["Energy Cost"]
  return cost
end

function Magic.CreateMagicDetail(id)
  local panel
  local pw, ph = 280, 70
  local lh = 0
  local scItemHeight = 15
  local frameRes = "UI/alpha/1080P/common/main_vit_tips.png"
  local frameCapInsets = CCRectMake(10, 10, 58, 26)
  panel = ed.createNode({
    t = "Scale9Sprite",
    base = {res = frameRes, capInsets = frameCapInsets}
  })
  
  local function createLabel(text)
    local label = ed.createttf(text, 16)
    label:setHorizontalAlignment(kCCTextAlignmentLeft)
    label:setVerticalAlignment(kCCVerticalTextAlignmentTop)
    ed.setLabelDimensions(label, CCSizeMake(pw - 40, 0))
    label:setAnchorPoint(ccp(0, 0))
    return label
  end
  
  local function setPanelSize(size)
    panel:setContentSize(size)
  end
end

function Magic.Create(container, data, x, y)
  PRINT("magic create")
  local self = {}
  setmetatable(self, Magic)
  self:Init(container, data, x, y)
  return self
end

function Magic:Destroy()
  PRINT("Magic Destroy")
  self.node:removeFromParentAndCleanup(true)
  self.targetManager:Destroy()
  self.node = nil
  self.or_x = nil
  self.or_y = nil
end

function Magic:Init(container, data, x, y)
  local magic_id = data
  local pos = ed.toLogicalPosition(ccp(x, y), 0)
  local level = ed.multiArena.GetMagicLevel()
  local info = ed.MagicSkill.getSkillInfo(magic_id, level)
  local pl = ed.engine.battle_manager:GetDefaultPlayer()
  local caster = pl:GetMagicCaster()
  local param = {
    position = pos,
    direction = 1,
    foecamp = -1,
    camp = 1
  }
  for k, v in pairs(param) do
    caster[k] = v
  end
  self.skill = ed.MagicSkillCreate(info, caster, pos)
  self.targetManager = PreTargetManager.Create()
  self.or_x = x
  self.or_y = y
  self.search_cd = search_cd
  self.magic_id = data
  self.node = CCNode:create()
  self.node:setPosition(ccp(x, y))
  container:addChild(self.node)
  self:CreateMagicIcon()
  self:Touch(nil, x, y)
end

function Magic:setVisible(visible)
  self.node:setVisible(visible)
  self.targetManager:setVisible(visible)
  self.isVisible = visible
end

local function createMagicIcon(magic_id)
  local param = {id = magic_id, addName = true}
  return ed.createMagicIcon(param)
end

function Magic:CreateMagicIcon()
  PRINT("Create Magic Icon")
  local icon = createMagicIcon(self.magic_id).icon
  self.node:addChild(icon)
  self.magic_icon = icon
end

function Magic:Update(dt)
  self.targetManager:Update(dt)
  self.search_cd = self.search_cd - dt
end

function Magic:Touch(event, x, y)
  if y - self.or_y > ed.pvpMode.value_to_judge_move then
    self.isMoved = true
    Details.SetMagicDetailVisible(false)
  end
  if not MagicListSystem.checkJoinCondition(self.magic_id, true) then
    if self.isMoved then
      MagicListSystem.checkJoinCondition(self.magic_id)
    else
      self.node:setPosition(ccp(x, y))
    end
    return
  end
  self:setVisible(true)
  local scale = ed.pvpMode.calculatePreHeroUpdateScale(x, y, self.or_x, self.or_y)
  self.node:setScale(scale)
  self.node:setPosition(ccp(x, y))
  local pos = FlipViewXPosition(ccp(x, y))
  pos = ed.toLogicalPosition(pos, 0)
  self.skill.caster.position = FlipXPosition(pos)
  if 0 >= self.search_cd then
    self:SearchTarget()
    self.search_cd = search_cd
  end
end

function Magic:HasTarget()
  return self.canCast
end

function Magic:SearchTarget()
  self.canCast = false
  local target = self.skill:selectTarget()
  if target then
    if self:IsRangeSkill() then
      self:CreateRangeTargetPoint(target)
    else
      self.canCast = true
      self.targetManager:ResetTargetList({target})
    end
  else
    self.targetManager:ResetTargetList({})
  end
end

function Magic:IsRangeSkill()
  local skill = self.skill
  if skill.info["AOE Origin"] then
    return true
  end
  if skill.info["Track Type"] == "projectile" and skill.info["Tile Piercing"] then
    return true
  end
  return false
end

function Magic:CreateRangeTargetPoint(target)
  local skill = self.skill
  local caster = self.skill.caster
  local info = skill.info
  local aoe = info["AOE Origin"]
  local target_list = {}
  if aoe then
    local direction = target.position[1] - caster.position[1] > 0 and 1 or -1
    local location = aoe == "self" and caster.position or target.position
    local origin = {
      location[1],
      location[2]
    }
    target_list = ed.Skill.collectAoeTarget(skill, origin, direction)
  else
    local pj = ed.ProjectileCreate(skill, true)
    pj.birthtick = nil
    pj.previous_position = {
      pj.position[1],
      pj.position[2]
    }
    while not pj.terminated do
      pj:update(ed.engine.tick_interval)
    end
    target_list = pj.hit_list
  end
  if 0 < #target_list then
    self.canCast = true
  end
  self.targetManager:ResetTargetList(target_list)
end
