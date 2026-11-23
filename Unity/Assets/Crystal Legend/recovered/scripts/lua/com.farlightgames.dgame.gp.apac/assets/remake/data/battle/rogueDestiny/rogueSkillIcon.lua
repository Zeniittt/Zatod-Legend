local class = {}
ed.rogueSkillIcon = class

function class.create(param)
  local self = {}
  setmetatable(self, {__index = class})
  self:init(param)
  return self
end

function class:init(param)
  param = param or {}
  self.container = param.container
  self.mgr = ed.engine:getRogueSkillMgr()
  self.rogueRevelationId = self.mgr:getDestinyId()
  self.rogueRevelation = self.mgr:getRogueRevelation()
  if not self.rogueRevelationId or not self.rogueRevelation then
    return
  end
  self.destinyInfo = self.rogueRevelation.info
  self.CD = self.rogueRevelation.CD or 5
  self.isEnable = self.rogueRevelation.isEnable or false
  self.leftTime = self.CD
  self.isReady = false
  self.isRunning = false
  self.eventScope = {}
  self:initView()
  self:addListenEvent()
end

function class:initView()
  self:initIcon()
end

function class:initIcon()
  local iconPath = self.destinyInfo.Icon
  local icon, ui = ed.editorui(ed.uieditor.rogueRevelationIcon, {
    container = self.container
  })
  self.ui = ui
  self.icon = ui.image_bg
  ed.setTexture(self.ui.image_icon, string.format("UI/alpha/1080P/rogue/bless/%s_simple.png", iconPath))
  ed.setLabelStroke(self.ui.label_left_time, ed.toccc3(0), 2)
  self.ui.image_light:runAction(CCRepeatForever:create(CCRotateBy:create(0.7, 360)))
  self.ui.image_light:setVisible(false)
  local eff_charging = ed.createFcaNode("eff_UI_rogue_echo_charging")
  local clippingNode = ed.createClippingNodeOnly("UI/alpha/1080P/rogue/instance/instance_battle_echo_shade.png")
  clippingNode:addChild(eff_charging)
  self.ui.image_bg:addChild(clippingNode, 1)
  ed.layout.centerInParent(clippingNode)
  ed.scene:addFca(eff_charging)
  eff_charging:setAction("Loop")
  eff_charging:setLoop(true)
  self.eff_charging = eff_charging
  self.clippingNode = clippingNode
  local eff_ready = ed.createFcaNode("eff_UI_rogue_echo_ready")
  self.eff_ready = eff_ready
  ed.scene:addFca(eff_ready)
  self.ui.image_bg:addChild(eff_ready, 1)
  ed.layout.centerInParent(eff_ready)
  eff_ready:setVisible(false)
  if self.isEnable then
    self.ui.image_lock_mask:setVisible(false)
    self.ui.image_lock:setVisible(false)
    self.ui.image_icon:setOpacity(255)
    self.ui.label_left_time:setVisible(true)
    self.ui.panel_energy_clip:setVisible(true)
    self.clippingNode:setVisible(true)
  else
    self.ui.image_lock_mask:setVisible(true)
    self.ui.image_lock:setVisible(true)
    self.ui.image_icon:setOpacity(102)
    self.ui.label_left_time:setVisible(false)
    self.ui.panel_energy_clip:setVisible(false)
    self.clippingNode:setVisible(false)
  end
end

function class:onClickMagicIcon()
  if not self.isEnable then
    ed.showToast(T("\229\144\175\231\164\186\230\156\170\232\167\163\233\148\129"))
  elseif self:checkReady() then
    self:executeRogueSkill()
  else
    ed.showToast(T("\229\176\154\230\156\170\229\176\177\231\187\170"))
  end
end

function class:onPressInMagicIcon()
  self:showSkillTips()
end

function class:onCancelPressInMagicIcon()
  if self.skillTipsPanel then
    self.skillTipsPanel:destroy({skipAnim = true})
    self.skillTipsPanel = nil
  end
end

function class:executeRogueSkill()
  if self:checkReady() and not self.isRunning then
    self.isRunning = true
    ed.engine:manualEchoSkill(self.rogueRevelationId)
  end
end

function class:rogueSkillEffectStart()
end

function class:rogueSkillEffectEnd()
  self.isRunning = false
end

function class:checkReady()
  local isReady = false
  if self.leftTime <= 0 and self.rogueRevelation:isCanCast() then
    isReady = true
  end
  self:setReady(isReady)
  return isReady
end

function class:update(dt)
  if ed.engine.running then
    self:updateCD(dt)
    self:updateEnergy()
    self:checkReady()
    if ed.scene.auto_combat then
      self:executeRogueSkill()
    end
  end
end

function class:updateCD(dt)
  self.leftTime = self.leftTime - dt
  self.leftTime = math.max(self.leftTime, 0)
  ed.setLabelString(self.ui.label_left_time, math.ceil(self.leftTime))
  if self.leftTime <= 0 then
    self.ui.label_left_time:setVisible(false)
  end
end

function class:updateEnergy()
  local energy = self.rogueRevelation.energy
  local energyUpperLimit = self.rogueRevelation.energyUpperLimit
  local percent = energy / energyUpperLimit
  local panelSize = self.ui.panel_energy_clip:getContentSize()
  self.ui.panel_energy_clip:setClipRect(CCRectMake(0, 0, panelSize.width, panelSize.height * percent))
  self.eff_charging:setPosition(ccp(0, -47.5 + 95 * percent))
end

function class:setReady(isReady)
  if isReady == self.isReady then
    return
  end
  self.isReady = isReady
  if not self.isEnable then
    return
  end
  if isReady then
    self.ui.label_left_time:setVisible(false)
    self.ui.image_light:setVisible(true)
    self.eff_ready:setVisible(true)
    self.eff_ready:setAction("Start")
    self.eff_ready:setLoopAction("Loop")
  else
    self.ui.image_light:setVisible(false)
    self.ui.label_left_time:setVisible(true)
    self.eff_ready:setVisible(false)
  end
  if self.leftTime <= 0 then
    self.ui.label_left_time:setVisible(false)
  end
end

function class:showSkillTips()
  if self.skillTipsPanel then
    self.skillTipsPanel:destroy({skipAnim = true})
  end
  local win = ed.ui.rogueRevelationDetailWindow.create({
    destinyId = self.rogueRevelationId
  })
  win:popWindow()
  ed.layout.relateLayout(self.ui.image_bg, win.ui.image_bg, {
    top = win.ui.image_bg:getContentSize().height + self.ui.image_bg:getContentSize().height / 2
  })
  ed.layout.layoutWithMagin(win.ui.image_bg, {
    left = ed.display.getNotchHeight()
  })
  self.skillTipsPanel = win
end

function class:addListenEvent()
  ListenEvent("rogueSkillEffectStart", function(revelationId)
    if tolua.isnull(self.icon) then
      return
    end
    if self.rogueRevelationId == revelationId then
      self:rogueSkillEffectStart()
    end
  end, self.eventScope)
  ListenEvent("rogueSkillEffectEnd", function(revelationId)
    if tolua.isnull(self.icon) then
      return
    end
    if self.rogueRevelationId == revelationId then
      self:rogueSkillEffectEnd()
    end
  end)
end

function class:clear()
  CloseScope(self.eventScope)
  if not tolua.isnull(self.icon) then
    self.icon:removeFromParentAndCleanup(true)
    self.icon = nil
  end
end
