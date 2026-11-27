local SoloUnitActor = {
  mt = {}
}
ed.SoloUnitActor = SoloUnitActor
SoloUnitActor.mt.__index = SoloUnitActor

local function SoloUnitActorCreate(model)
  local self = {
    puppet = nil,
    node = CCNode:create(),
    model = model,
    bar_hp = nil,
    bar_shield = nil,
    bar_Fury = nil,
    bar_group = nil,
    puppetName = nil,
    tick = -1,
    position = {0, 0},
    velocity = {0, 0},
    speeder = 1,
    height = 0,
    zSpeed = nil,
    offline = false,
    actor_scale = {1, 1},
    scale_stack = {},
    shader_stack = {},
    particle_stack = {},
    puppetInfo = nil
  }
  setmetatable(self, SoloUnitActor.mt)
  self:usePuppet()
  if self.model.config.is_summoned then
    self:useBar()
  end
  return self
end

SoloUnitActor.create = SoloUnitActorCreate
ed.SoloUnitActorCreate = SoloUnitActorCreate

function SoloUnitActor:useBar()
  local model = self.model
  local unitScale = model:getUnitScale()
  self.bar_group = ed.FloatingBarGroup.create()
  self.bar_hp = ed.FloatingBar.create(model, "HP")
  self.node:addChild(self.bar_hp.node, 999)
  self.bar_hp.node:setScale(unitScale)
  self.bar_hp.node:setPosition(0, 100 * unitScale)
  self.bar_hp.auto_hide = false
  self.bar_group:AddBar("HP", self.bar_hp)
end

function SoloUnitActor:usePuppet()
  local old = self.puppet
  local model = self.model
  model.actor = self
  self.puppetName = model.puppet_stack[#model.puppet_stack]
  local info = ed.lookupDataTable("Puppet", nil, self.puppetName)
  if string.match(self.puppetName, "%.sp$") then
    self.isSpine = true
  end
  self.puppet = ed.createFcaActor(info.Resource, model:getUnitScale())
  local isFlipX = model:getUnitFlipX()
  if isFlipX then
    self.puppet:setScaleX(-1)
  end
  self.puppetInfo = info
  local comps = info["Change Components"]
  if comps then
    for i = 1, #comps, 2 do
      self.puppet:setComponent(comps[i], comps[i + 1])
    end
  end
  local invisible = model.buffManager.invisible
  local stealthChangeComps = info["Stealth Change Components"]
  local allComps = info["All Components"]
  if invisible and stealthChangeComps then
    local shouldVisible = {}
    for i = 1, #stealthChangeComps, 2 do
      shouldVisible[stealthChangeComps[i]] = true
    end
    local replaceElement = info["Transparent Pixel"]
    for i = 1, #allComps do
      if not shouldVisible[allComps[i]] then
        self.puppet:setComponent(allComps[i], replaceElement)
      end
    end
    for i = 1, #stealthChangeComps, 2 do
      self.puppet:setComponent(stealthChangeComps[i], stealthChangeComps[i + 1])
    end
  end
  local usePlists = info.Plist
  local elements = info.Element
  if usePlists and elements then
    local SourcePositions = info["Source Position"]
    local PositionTypes = info["Position Type"]
    local EmissionRates = info["Emission Rate"]
    local enumPositionTypes = {
      Free = kCCPositionTypeFree,
      Relative = kCCPositionTypeRelative,
      Grouped = kCCPositionTypeGrouped
    }
    for i = 1, #usePlists do
      local particle = CCParticleSystemQuad:create("UI/particle/" .. usePlists[i] .. ".plist")
      local t = CCAffineTransformMake(1, 0, 0, 1, 0, 0)
      local element = elements[i]
      if element and element ~= "null" then
        self.puppet:addNodeToComponent(particle, element, 1, t, true, true)
      else
        self:addNode(particle, 1, t, true, true)
      end
      if #SourcePositions ~= 0 and #PositionTypes ~= 0 and #EmissionRates ~= 0 then
        local px, py = tonumber(SourcePositions[i * 2 - 1]), tonumber(SourcePositions[i * 2])
        particle:setSourcePosition(ccp(px, py))
        particle:setPositionType(enumPositionTypes[PositionTypes[i]])
        local emissionRate = tonumber(EmissionRates[i])
        particle:setEmissionRate(emissionRate)
      end
      self.particle_stack[usePlists[i]] = particle
    end
  end
  if model.config.is_boss and (model.isBossCreateWithEffect or model.isBossCreateWithEffect == nil) then
    self.puppet:addEffect("eff_buff_boss", -1)
  end
  self.node:addChild(self.puppet, 0)
  if old then
    self.shader_stack = {}
    old:removeFromParentAndCleanup(true)
  end
  local actionName = self:getActionName(model.action_name)
  self.puppet:setAction(actionName)
  self.puppet:setLoop(model.action_loop)
  self.puppet:setActionElapsed(model.action_elapsed)
  for i, buff in ipairs(model.buff_list) do
    buff:onAddedClient(false)
  end
  self.drugEffectId = self.puppet:addEffect("eff_buff_solo_drug", 1)
  self.showDrugEffect = true
  self.frozenEffectId = self.puppet:addEffect("eff_buff_AA_ult", 1)
  self.showFrozenEffect = true
  self.shieldEffectId = self.puppet:addEffect("eff_buff_BB_ult", 1)
  self.showShieldEffect = true
  self.weakEffectId = self.puppet:addEffect("eff_buff_SG_Skull", 1)
  self.showWeakEffect = true
end

function SoloUnitActor:pushShader(shader)
  table.insert(self.shader_stack, shader)
  self.puppet:useShader(shader)
  return #self.shader_stack
end

function SoloUnitActor:removeShader(shader_id)
  local stack = self.shader_stack
  if shader_id > #stack then
    EDLog("Actor shader has been removed!")
    return
  end
  stack[shader_id] = ""
  while stack[#stack] == "" do
    stack[#stack] = nil
  end
  if #stack == 0 then
    self.puppet:useDefaultShader()
  else
    self.puppet:useShader(stack[#stack])
  end
end

function SoloUnitActor:onStartNewAction()
  if self.offline then
    return
  end
  local model = self.model
  if not model.buff_effects.frozen and not model.buff_effects.icefrozen then
    local actionName = self:getActionName(model.action_name)
    self.puppet:setAction(actionName)
    self.puppet:setLoop(model.action_loop)
  end
end

function SoloUnitActor:onUnitDeath()
  local model = self.model
  local duration = model.action_duration
  local delay = model.is_summoned and 0 or 2
  if model.isDeathWithEffect then
    delay = 0
  end
  if duration + delay <= 0 then
    self.node:setVisible(false)
    self.is_terminated = true
  elseif model.isDisapearWhenDie or nil == model.isDisapearWhenDie then
    self.puppet:runAction(CCSequence:create(ccArrayMake(CCDelayTime:create(duration + delay), CCFadeOut:create(1), CCCallFunc:create(function()
      self.node:setVisible(false)
      self.is_terminated = true
    end))))
  end
  self.isDied = true
  self.puppet:setActionSpeeder(1)
  self.offline = true
  self.puppet:setLoop(false)
  self.velocity = {0, 0}
end

function SoloUnitActor:onUnitExit()
  self.node:setVisible(false)
  self.is_terminated = true
  self.offline = true
  self.puppet:setLoop(false)
  self.velocity = {0, 0}
end

function SoloUnitActor:update(dt)
  local node = self.node
  local u = self.model
  if not self.offline and self.tick ~= ed.engine.ticks then
    self.tick = ed.engine.ticks
    local speeder = u.speeder
    do
      local x, y = u:getRuntimeScale()
      local adaptScale = ed.scene.contentScale or 1
      node:setScaleX(adaptScale * self.actor_scale[1] * x)
      node:setScaleY(adaptScale * self.actor_scale[2] * y)
    end
    do
      local p1 = self.position
      local p2 = u.position
      p1[1] = p2[1]
      p1[2] = p2[2]
    end
    do
      local v1 = self.velocity
      local v2 = u.velocity
      v1[1] = v2[1] * speeder
      v1[2] = v2[2] * speeder
    end
    self.puppet:setActionSpeeder((u.buff_effects.frozen or u.buff_effects.icefrozen) and 0 or speeder)
  else
    local pos = self.position
    local v = self.velocity
    pos[1] = pos[1] + v[1] * dt
    pos[2] = pos[2] + v[2] * dt
  end
  local effect = self.puppet:getChildByTag(self.frozenEffectId)
  if effect then
    if self.showFrozenEffect == false and 1 <= self.model.frozenValue then
      effect:setVisible(true)
      self.showFrozenEffect = true
    end
    if self.showFrozenEffect and 1 > self.model.frozenValue then
      effect:setVisible(false)
      self.showFrozenEffect = false
    end
  end
  local effect1 = self.puppet:getChildByTag(self.drugEffectId)
  if effect1 then
    if self.showDrugEffect == false and 1 <= self.model.drugValue then
      effect1:setVisible(true)
      self.showDrugEffect = true
    end
    if self.showDrugEffect and 1 > self.model.drugValue then
      effect1:setVisible(false)
      self.showDrugEffect = false
    end
  end
  local effect2 = self.puppet:getChildByTag(self.shieldEffectId)
  local effect3 = self.puppet:getChildByTag(self.weakEffectId)
  if effect2 and effect3 then
    if 1 <= self.model.shieldValue then
      if self.showShieldEffect == false then
        effect2:setVisible(true)
        self.showShieldEffect = true
      end
      if self.showWeakEffect == true then
        effect3:setVisible(false)
        self.showWeakEffect = false
      end
    elseif self.model.shieldValue <= -1 then
      if self.showShieldEffect == true then
        effect2:setVisible(false)
        self.showShieldEffect = false
      end
      if self.showWeakEffect == false then
        effect3:setVisible(true)
        self.showWeakEffect = true
      end
    else
      if self.showShieldEffect == true then
        effect2:setVisible(false)
        self.showShieldEffect = false
      end
      if self.showWeakEffect == true then
        effect3:setVisible(false)
        self.showWeakEffect = false
      end
    end
  end
  self.puppet:update(dt)
  if self.bar_group then
    self.bar_group:update(dt)
  end
  local p = ed.toViewPosition(self.model.position, 0)
  node:setPosition(p)
end

function SoloUnitActor:addEffect(name, zorder, option_args)
  local puppet = self.puppet
  if string.match(name, "%.cha$") or string.match(name, "%.sp$") then
    name = string.gsub(name, "%.cha$", "")
    zorder = zorder or 1
    option_args = option_args or {}
    local offset_x = option_args.x or 0
    local offset_y = option_args.y or 0
    local angle = option_args.angle or 0
    angle = angle / 180 * math.pi
    local t = CCAffineTransformMakeIdentity()
    t = CCAffineTransformTranslate(t, offset_x, offset_y)
    t = CCAffineTransformRotate(t, angle)
    local eid = puppet:addEffect(name, zorder, t)
    return eid
  end
end

function SoloUnitActor:setEffectScale(effectId, scale)
  local effect = self.puppet:getChildByTag(effectId)
  effect:setScale(scale)
end

function SoloUnitActor:getEffectById(effectId)
  return self.puppet:getChildByTag(effectId)
end

function SoloUnitActor:addEffectToComponent(name, component_name, zorder, option_args)
  local puppet = self.puppet
  if string.match(name, "%.cha$") or string.match(name, "%.sp$") then
    name = string.gsub(name, "%.cha$", "")
    zorder = zorder or 1
    option_args = option_args or {}
    local offset_x = option_args.x or 0
    local offset_y = option_args.y or 0
    local angle = option_args.angle or 0
    angle = angle / 180 * math.pi
    local t = CCAffineTransformMakeIdentity()
    t = CCAffineTransformTranslate(t, offset_x, offset_y)
    t = CCAffineTransformRotate(t, angle)
    local inherit_rotation = option_args.inherit_rotation or false
    local inherit_visible = option_args.inherit_visible or false
    return puppet:addEffectToComponent(name, component_name, zorder, t, inherit_rotation, inherit_visible)
  end
end

function SoloUnitActor:addNode(node, zorder, option_args)
  if node == nil then
    return
  end
  local puppet = self.puppet
  zorder = zorder or 1
  option_args = option_args or {}
  local offset_x = option_args.x or 0
  local offset_y = option_args.y or 0
  local angle = option_args.angle or 0
  angle = angle / 180 * math.pi
  local t = CCAffineTransformMakeIdentity()
  t = CCAffineTransformTranslate(t, offset_x, offset_y)
  t = CCAffineTransformRotate(t, angle)
  return puppet:addNode(node, zorder, t)
end

function SoloUnitActor:addNodeToComponent(node, component_name, zorder, option_args)
  if node == nil then
    return
  end
  local puppet = self.puppet
  zorder = zorder or 1
  option_args = option_args or {}
  local offset_x = option_args.x or 0
  local offset_y = option_args.y or 0
  local angle = option_args.angle or 0
  angle = angle / 180 * math.pi
  local t = CCAffineTransformMakeIdentity()
  t = CCAffineTransformTranslate(t, offset_x, offset_y)
  t = CCAffineTransformRotate(t, angle)
  local inherit_rotation = option_args.inherit_rotation or false
  local inherit_visible = option_args.inherit_visible or false
  return puppet:addNodeToComponent(node, component_name, zorder, t, inherit_rotation, inherit_visible)
end

function SoloUnitActor:removeExtraNode(id)
  if id == nil then
    return
  end
  self.puppet:removeNodeWithID(id)
end

function SoloUnitActor:launch(time)
  self.zSpeed = time * -ed.Unit.gravity * 0.5
end

function SoloUnitActor:cheer()
  local puppet = self.puppet
  local cheerActionName = self:getActionName("Cheer")
  puppet:setNextAction(cheerActionName)
  puppet:setLoop(true)
  self.velocity = {0, 0}
  local direction = FlipDirection(self.model.direction)
  local adaptScale = ed.scene.contentScale or 1
  CCNode.setScaleX(self.node, adaptScale * direction)
  CCNode.setScaleY(self.node, adaptScale)
  self.offline = true
end

function SoloUnitActor:tint(r, g, b)
  self.puppet:tint(r, g, b)
end

function SoloUnitActor:getActionName(actionName)
  local newActionName = actionName
  if self.puppetInfo ~= nil and actionName ~= nil then
    local flagName = "Action " .. actionName
    local tmpActionName = self.puppetInfo[flagName]
    if tmpActionName ~= nil then
      newActionName = tmpActionName
    end
  end
  return newActionName
end

function SoloUnitActor:isActionEmpty(actionName)
  local bRet = true
  if self.puppetInfo ~= nil and actionName ~= nil then
    local flagName = "Action " .. actionName
    local tmpActionName = self.puppetInfo[flagName]
    if tmpActionName ~= nil and tmpActionName ~= "" then
      bRet = false
    end
  end
  return bRet
end
