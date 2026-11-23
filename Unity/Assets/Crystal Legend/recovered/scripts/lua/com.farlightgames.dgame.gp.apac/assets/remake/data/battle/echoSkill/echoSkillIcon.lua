local class = {}
ed.echoSkillIcon = class

function class.create(param)
  local self = {}
  setmetatable(self, {__index = class})
  self:init(param)
  return self
end

function class:init(param)
  self.mode = param.mode
  self.echoId = param.echoId
  self.container = param.container
  self.CD = 5
  self.leftTime = self.CD
  self.isReady = false
  self.isRunning = false
  self.ticks = 0
  self.mgr = ed.engine:getEchoSkillMgr()
  self.eventScope = {}
  self:initView()
  self:addListenEvent()
end

function class:initView()
  self:initIcon()
  self:initBarShadow()
end

function class:initIcon()
  local echoCfg = ed.getDataTable("EchoSkill")[self.echoId]
  local iconPath = echoCfg.ICON
  local container, ui = ed.editorui(ed.uieditor.echoSkillIcon, {
    container = self.container
  })
  self.ui = ui
  self.icon = ui.image_bg
  ed.setTexture(self.ui.image_skill_icon, iconPath)
  ed.setLabelStroke(self.ui.label_left_time, ed.toccc3(0), 2)
  self.ui.image_light:runAction(CCRepeatForever:create(CCRotateBy:create(1, 360)))
  self:setReady(self.leftTime == 0)
end

function class:initBarShadow()
  self.ui.image_shadow:setVisible(false)
  local progress = CCProgressTimer:create(self.ui.image_shadow)
  progress:setReverseProgress(true)
  progress:setType(kCCProgressTimerTypeRadial)
  progress:setZOrder(self.ui.image_shadow:getZOrder())
  self.ui.image_bg:addChild(progress)
  progress:setPosition(self.ui.image_shadow:getPosition())
  self.progress = progress
end

function class:onClickMagicIcon()
  if self:checkReady() then
    self:executeEchoSkill()
  else
    ed.showToast(T("\229\176\154\230\156\170\229\176\177\231\187\170"))
  end
end

function class:onPressInMagicIcon()
  self:showSkillTips()
end

function class:onCancelPressInMagicIcon()
  if self.skillTipsPanel then
    self.skillTipsPanel:removeFromParentAndCleanup(true)
    self.skillTipsPanel = nil
  end
end

function class:executeEchoSkill()
  if self:checkReady() and not self.isRunning then
    self.isRunning = true
    ed.engine:manualEchoSkill(self.echoId)
  end
end

function class:echoSkillEffectStart()
  self.isRunning = false
  self.CD = ed.getDataTable("EchoSkill")[self.echoId].CD
  self.leftTime = self.CD
  self.ticks = ed.engine.ticks
end

function class:checkReady()
  if not self.isReady then
    return false
  end
  if (ed.engine.ticks - self.ticks) * ed.tick_interval < self.CD then
    return false
  end
  return true
end

function class:update(dt)
  if ed.engine.running then
    self:updateCD(dt)
    if ed.scene.auto_combat then
      self:executeEchoSkill()
    end
  end
end

function class:updateCD(dt)
  self.leftTime = self.leftTime - dt
  self.leftTime = math.max(self.leftTime, 0)
  self:setReady(self.leftTime == 0)
  self.progress:setPercentage(self.leftTime / self.CD * 100)
  ed.setLabelString(self.ui.label_left_time, math.ceil(self.leftTime))
end

function class:setReady(isReady)
  self.isReady = isReady
  if isReady then
    self.ui.label_left_time:setVisible(false)
    self.ui.image_bg2:setVisible(true)
    self.ui.image_unready:setVisible(false)
    self.ui.image_ready:setVisible(true)
    self.ui.image_light:setVisible(true)
    self.ui.image_skill_icon:setOpacity(255)
  else
    self.ui.label_left_time:setVisible(true)
    self.ui.image_bg2:setVisible(false)
    self.ui.image_unready:setVisible(true)
    self.ui.image_ready:setVisible(false)
    self.ui.image_light:setVisible(false)
    self.ui.image_skill_icon:setOpacity(153)
  end
end

function class:showSkillTips()
  if self.skillTipsPanel then
    self.skillTipsPanel:removeFromParentAndCleanup(true)
    self.skillTipsPanel = nil
  end
  local echoCfg = ed.getDataTable("EchoSkill")[self.echoId]
  if not echoCfg then
    return
  end
  local name = echoCfg["Display Name"]
  local desc = echoCfg.Description
  local parent = self.ui.image_bg
  local bg = ed.createScale9Sprite("UI/alpha/1080P/common/com_new_3.png")
  parent:addChild(bg, 999)
  bg:setAnchorPoint(ccp(0.5, 1))
  local nameLabel = ed.createLabelTTF(name, 20)
  ed.setLabelColor(nameLabel, ed.toccc3(16776423))
  ed.setLabelStroke(nameLabel, ed.toccc3(2565412), 1)
  bg:addChild(nameLabel)
  local line = ed.createSprite("UI/alpha/1080P/hades/hades_boss_line.png")
  bg:addChild(line)
  desc = string.format("<lable color=ccc3(255,252,231) strokeColor=ccc3(39,37,36), strokeSize=1>%s</lable>", desc)
  local autoText = ed.ui.autoText.new()
  autoText:initParam({
    context = desc,
    color = ed.toccc3(16113079),
    strokeColor = ed.toccc3(1774610),
    strokeSize = 1,
    maxWidth = 300,
    fontSize = 16
  })
  bg:addChild(autoText.node)
  local autoTextW, autoTextH = autoText:getCurContentSize()
  local bgWidth = 330
  local bgHeight = nameLabel:getContentSize().height + autoTextH + 35
  bg:setContentSize(CCSizeMake(bgWidth, bgHeight))
  local cd = echoCfg.CD
  local CDLabel = ed.createLabelTTF(string.format(T("\229\134\183\229\141\180\230\151\182\233\151\180%s\231\167\146"), cd), 16)
  ed.setLabelColor(CDLabel, ccc3(232, 177, 82))
  ed.setLabelStroke(CDLabel, ccc3(39, 37, 36), 1)
  bg:addChild(CDLabel)
  ed.layout.layoutWithParentMagin(nameLabel, {left = 16, top = 15})
  ed.layout.layoutWithParentMagin(CDLabel, {right = 16, top = 18})
  ed.layout.layoutWithParentMagin(line, {left = 24, top = 45})
  ed.layout.layoutWithParentMagin(autoText.node, {left = 15, top = 60})
  local parentSize = parent:getContentSize()
  ed.layout.relateLayout(parent, bg, {
    top = bg:getContentSize().height + parentSize.height / 2
  })
  ed.layout.layoutWithMagin(bg, {
    left = ed.display.getNotchHeight()
  })
  self.skillTipsPanel = bg
end

function class:addListenEvent()
  ListenEvent("echoSkillEffectStart", function(echoId)
    if tolua.isnull(self.icon) then
      return
    end
    if self.echoId == echoId then
      self:echoSkillEffectStart()
    end
  end, self.eventScope)
end

function class:clear()
  CloseScope(self.eventScope)
  if not tolua.isnull(self.icon) then
    self.icon:removeFromParentAndCleanup(true)
  end
end
