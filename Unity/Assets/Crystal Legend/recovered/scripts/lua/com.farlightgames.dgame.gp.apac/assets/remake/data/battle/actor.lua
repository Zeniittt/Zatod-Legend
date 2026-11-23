local UnitActor = {
  mt = {}
}
ed.UnitActor = UnitActor
UnitActor.mt.__index = UnitActor
local setScaleX = CCNode.setScaleX
local setScaleY = CCNode.setScaleY
local setPosition = CCNode.setPosition
local setZOrder = CCNode.setZOrder

local function isFixedHpBar(model)
  if ed.IsMultiArena() then
    return true
  end
  if ed.engine:isStealKill() and model.camp == ed.emCampEnemy then
    return true
  end
  return false
end

local function UnitActorCreate(model)
  local self = {
    puppet = nil,
    node = CCNode:create(),
    model = model,
    bar_hp = nil,
    bar_shield = nil,
    bar_Fury = nil,
    bar_group = nil,
    puppetName = nil,
    tick = 0,
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
  setmetatable(self, UnitActor.mt)
  self:usePuppet()
  self:useBar()
  if ed.IsAutoChessMode() then
    self:addStarNode()
    self:addTagNode()
    self:addPetNode()
  end
  return self
end

UnitActor.create = UnitActorCreate
ed.UnitActorCreate = UnitActorCreate

local function useBar(self)
  local model = self.model
  self.bar_group = ed.FloatingBarGroup.create()
  if not self.model.hpLayer or 0 == self.model.hpLayer then
    local shiftY = ed.engine:isTowerWarsMode() and 25 or 0
    if ed.IsMultiArena() then
      shiftY = ed.pvpMode.UnitHPshiftY
    end
    shiftY = ed.IsAutoChessMode() and 30 or 0
    self.bar_hp = ed.FloatingBar.create(model, "HP")
    if isFixedHpBar(model) or self.model.still_show then
      self.bar_hp.auto_hide = false
    end
    self.node:addChild(self.bar_hp.node, 999)
    self.bar_hp.node:setPosition(0, 134.5 - shiftY)
    self.bar_hp.node:setScale(0.6666666666666666)
    self.bar_group:AddBar("HP", self.bar_hp)
    if ed.IsAutoChessMode() then
      self.bar_mp = ed.FloatingBar.create(model, "MP")
      if isFixedHpBar(model) or self.model.still_show then
        self.bar_mp.auto_hide = false
      end
      self.node:addChild(self.bar_mp.node, 999)
      self.bar_mp.node:setPosition(0, 130 - shiftY)
      self.bar_mp.node:setScale(0.6666666666666666)
      self.bar_group:AddBar("MP", self.bar_mp)
    end
    self.bar_shield = ed.FloatingBar.create(model, "Shield")
    self.node:addChild(self.bar_shield.node, 999)
    self.bar_shield.node:setPosition(0, 130 - shiftY)
    if ed.IsAutoChessMode() then
      self.bar_shield.node:setPosition(0, 125.5 - shiftY)
    end
    self.bar_shield.node:setScale(0.6666666666666666)
    self.bar_group:AddBar("Shield", self.bar_shield)
    self.bar_Fury = ed.FloatingBar.create(model, "Fury")
    self.node:addChild(self.bar_Fury.node, 999)
    self.bar_Fury.node:setPosition(0, 125.5 - shiftY)
    self.bar_Fury.node:setScale(0.6666666666666666)
    self.bar_Fury:forceHide(true)
    self.bar_group:AddBar("Fury", self.bar_Fury)
  else
    local height = 55
    if ed.sceneui.bigHpBarList and #ed.sceneui.bigHpBarList > 1 then
      height = 40
    end
    if ed.scene:getCurrentMode() ~= "guildMountBoss" then
      self.bar_shield = ed.FloatingBar.create(model, "ShieldBoss")
      self.bar_shield.node:setPosition(ccp(ed.display.center.x + 23, ed.display.winSize.height - height))
      self.bar_shield.node:setScaleX(-1)
      ed.sceneui.ui_layer:addChild(self.bar_shield.node, -1)
      self.bar_group:AddBar("ShieldBoss", self.bar_shield)
    end
    self.bar_Fury = ed.FloatingBar.create(model, "Fury")
    self.node:addChild(self.bar_Fury.node, 999)
    self.bar_Fury.node:setPosition(ed.display.center.x + 100, ed.display.winSize.height - height)
    self.bar_Fury.node:setScale(0.6666666666666666)
    self.bar_Fury:forceHide(true)
    self.bar_group:AddBar("Fury", self.bar_Fury)
    if ed.scene:getCurrentMode() == "guildMountBoss" then
      local curBoss = ed.GuildMountManager:getCurBoss()
      if curBoss then
        local tbData = ed.getDataTable("GuildMountBoss")[ed.GuildMountManager.prepareBossId or curBoss._id]
        if tbData then
          ed.useHSVShaderV2(self.puppet, tbData.Hue, tbData.Saturation, tbData.Value)
          self:pushShader("HSVtoRGBShaderV2")
          self.puppet:addEffect("eff_UI_GuildMount_boss", 1)
        end
      end
    end
  end
end

UnitActor.useBar = useBar

local function usePuppet(self)
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
end

UnitActor.usePuppet = usePuppet

local function useScale(self, scale)
  table.insert(self.scale_stack, scale)
  self.actor_scale = scale
  return #self.scale_stack
end

UnitActor.useScale = useScale

local function removeScale(self, scale_id)
  local stack = self.scale_stack
  if scale_id > #stack then
    EDLog("Actor scale has been removed!")
    return
  end
  stack[scale_id] = ""
  while stack[#stack] == "" do
    stack[#stack] = nil
  end
  if #stack == 0 then
    self.actor_scale = {1, 1}
  else
    self.actor_scale = stack[#stack]
  end
end

UnitActor.removeScale = removeScale

function UnitActor:usePreTargetShader()
  if self.model.terminated then
    return
  end
  self.puppet:useShader("BanishShader")
  self.pre_select_sher = true
end

function UnitActor:removePreTargetShader()
  self.pre_select_sher = nil
  if self.model.terminated then
    return
  end
  local stack = self.shader_stack
  if #stack == 0 then
    self.puppet:useDefaultShader()
  else
    self.puppet:useShader(stack[#stack])
  end
end

local function pushShader(self, shader)
  table.insert(self.shader_stack, shader)
  if not self.pre_select_sher then
    self.puppet:useShader(shader)
  end
  return #self.shader_stack
end

UnitActor.pushShader = pushShader

local function removeShader(self, shader_id)
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

UnitActor.removeShader = removeShader

local function onStartNewAction(self)
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

UnitActor.onStartNewAction = onStartNewAction

local function playGoldDropEffect(self)
  if self.model.money and self.model.money > 0 then
    if self.gold_drop_played then
      return
    end
    self.gold_drop_played = true
    local node = self.node
    node:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.2), CCCallFunc:create(function()
      ed.scene:playEffectOnScene("eff_battle_drop_money.cha", self.position, {1, 1}, 0, 1)
      local str = "+" .. math.floor(self.model.money)
      local color = "golden"
      ed.PopupCreate(str, color, self, false, "gold")
      ed.sceneui:addGold(self.model.money)
    end)))
  end
end

UnitActor.playGoldDropEffect = playGoldDropEffect

local function onUnitDeath(self)
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
  self:playGoldDropEffect()
  self:removeStarNode()
end

UnitActor.onUnitDeath = onUnitDeath

local function update(self, dt)
  local node = self.node
  local u = self.model
  if not self.offline and self.tick ~= ed.engine.ticks then
    self.tick = ed.engine.ticks
    local speeder = u.speeder
    do
      local scale = self:getUnitScaleSizeByPosY(self.position[2])
      local x, y = u:getRuntimeScale()
      x = FlipDirection(x)
      local adaptScale = ed.scene.contentScale or 1
      setScaleX(node, adaptScale * self.actor_scale[1] * x * scale)
      setScaleY(node, adaptScale * self.actor_scale[2] * y * scale)
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
    if self.targetPos and math.abs(self.targetPos[1] - pos[1]) < 5 and math.abs(self.targetPos[2] - pos[2]) < 5 then
      self:gotoTargetPosEnd()
    end
  end
  self.puppet:update(dt)
  local h = self.height
  if self.zSpeed then
    h = self.height + self.zSpeed * dt
    self.zSpeed = self.zSpeed + ed.Unit.gravity * dt
    if h < 0 then
      self.zSpeed = nil
      h = 0
    end
    self.height = h
  end
  local pos = FlipXPosition(self.position)
  local p = ed.toViewPosition(pos, h)
  setPosition(node, p)
  setZOrder(node, u.config.zOrder or -self.position[2])
  if self.bar_group then
    self.bar_group:update(dt)
  end
  if ed.IsMultiArena() then
    local model = self.model
    local unVisible = not model.buff_effects.untargetable or not model.buff_effects.invulnerable
    model:setHpVisible(unVisible)
  end
end

UnitActor.update = update

local function addEffect(self, name, zorder, option_args)
  if ed.trackMgr.isShieldEffect then
    return
  end
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
    if ed.engine:isTowerWarsMode() then
      self:setEffectScale(eid, 0.8)
    end
    if ed.IsMultiArena() then
      self:setEffectScale(eid, 0.8)
    end
    if ed.IsAutoChessMode() then
      local scale = 1
      local star = self.model.info["Chess Stars"]
      scale = star == 1 and 0.75 or scale
      scale = star == 2 and 0.8 or scale
      scale = star == 3 and 0.85 or scale
      self:setEffectScale(eid, scale)
    end
    return eid
  end
end

UnitActor.addEffect = addEffect

function UnitActor:setEffectScale(effectId, scale)
  local effect = self.puppet:getChildByTag(effectId)
  effect:setScale(scale)
end

function UnitActor:getEffectById(effectId)
  return self.puppet:getChildByTag(effectId)
end

local function addEffectToComponent(self, name, component_name, zorder, option_args)
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

UnitActor.addEffectToComponent = addEffectToComponent

local function addNode(self, node, zorder, option_args)
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

UnitActor.addNode = addNode

local function addNodeToComponent(self, node, component_name, zorder, option_args)
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

UnitActor.addNodeToComponent = addNodeToComponent

local function removeExtraNode(self, id)
  if id == nil then
    return
  end
  self.puppet:removeNodeWithID(id)
end

UnitActor.removeExtraNode = removeExtraNode

local function launch(self, time)
  self.zSpeed = time * -ed.Unit.gravity * 0.5
end

UnitActor.launch = launch

local function gotoNextBattle(self)
  local puppet = self.puppet
  local moveActionName = self:getActionName("Move")
  puppet:setAction(moveActionName)
  puppet:setLoop(true)
  puppet:setActionSpeeder(ed.next_battle_walk_speeder ^ 0.5)
  self.velocity = {
    self.model.info["Walk Speed"] * ed.next_battle_walk_speeder,
    0
  }
  local adaptScale = ed.scene.contentScale or 1
  setScaleX(self.node, adaptScale)
  setScaleY(self.node, adaptScale)
  self.offline = true
end

UnitActor.gotoNextBattle = gotoNextBattle

function UnitActor:gotoTargetPos(logicPos)
  local puppet = self.puppet
  local moveActionName = self:getActionName("Move")
  puppet:setAction(moveActionName)
  puppet:setLoop(true)
  local currentPos = FlipXPosition(self.position)
  local walkSpeed = 2
  self.targetPos = logicPos
  self.velocity = {
    (logicPos[1] - currentPos[1]) / walkSpeed,
    (logicPos[2] - currentPos[2]) / walkSpeed
  }
  local adaptScale = ed.scene.contentScale or 1
  setScaleX(self.node, adaptScale)
  setScaleY(self.node, adaptScale)
  self.offline = true
end

function UnitActor:gotoTargetPosEnd()
  self.targetPos = nil
  self.velocity = {0, 0}
end

local function waitAfterBattle(self)
  local puppet = self.puppet
  local idleActionName = self:getActionName("Idle")
  puppet:setNextAction(idleActionName)
  puppet:setLoop(true)
  self.velocity = {0, 0}
  local direction = FlipDirection(self.model.direction)
  local adaptScale = ed.scene.contentScale or 1
  self.node:setScaleX(adaptScale * direction)
  self.node:setScaleY(adaptScale)
  self.offline = true
end

UnitActor.waitAfterBattle = waitAfterBattle

local function cheer(self)
  local puppet = self.puppet
  local cheerActionName = self:getActionName("Cheer")
  puppet:setNextAction(cheerActionName)
  puppet:setLoop(true)
  self.velocity = {0, 0}
  local direction = FlipDirection(self.model.direction)
  local adaptScale = ed.scene.contentScale or 1
  setScaleX(self.node, adaptScale * direction)
  setScaleY(self.node, adaptScale)
  self.offline = true
end

UnitActor.cheer = cheer

local function tint(self, r, g, b)
  self.puppet:tint(r, g, b)
end

UnitActor.tint = tint

local function getActionName(self, actionName)
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

UnitActor.getActionName = getActionName

local function isActionEmpty(self, actionName)
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

UnitActor.isActionEmpty = isActionEmpty

function UnitActor:getUnitScaleSizeByPosY(posy)
  if not ed.engine:isTowerWarsMode() then
    return 1
  end
  local scale = -4.166666666666667E-4 * posy + 0.9
  scale = math.min(scale, 1)
  scale = math.max(scale, 0.8)
  return scale
end
