local BattleSceneUI = ed.sceneui

function BattleSceneUI:resetExtra()
  if ed.IsMultiArena() then
    self.timer.bg:setVisible(false)
    self.timer.mask:setVisible(false)
    self.timer.hourglass:setVisible(false)
    self.timer.text:setPositionX(380)
    self.pause_btn:setVisible(false)
    self.auto_btn:setVisible(false)
    self.heroes_panel:setVisible(false)
    ed.multiArena.Reset(self.ui_layer)
  end
  self:resetVideoplayer()
  self.openBarrage = false
  FireEvent(ed.guide.eventNames.OPEN_VIEW, self)
end

function BattleSceneUI:resetUIExtra()
  self:createRecoverUI()
end

function BattleSceneUI:resetVideoplayer()
  if not ed.engine.videoplayer_mode then
    return
  end
  if not self.heroes_left_panel then
    return
  end
  self.heroes_panel:setVisible(false)
  if #self.left_list == 6 then
    self.heroes_left_panel:setContentSize(CCSizeMake(self.leftPanelWidth, 320))
    for idx, p in ipairs(self.left_list) do
      p.node:setScale(0.35)
      p.node:setPosition(ccp(self.leftPanelWidth / 2, p.height / 2.9 * (#self.left_list - idx) + 3))
    end
  elseif #self.left_list == 5 then
    for idx, p in ipairs(self.left_list) do
      p.node:setScale(0.4)
      p.node:setPosition(ccp(self.leftPanelWidth / 2, p.height / 2.5 * (#self.left_list - idx) + 6))
    end
  end
end

function BattleSceneUI:createRecoverUI()
  if ed.engine.recovering then
    local layer = CCLayerColor:create(ccc4(255, 255, 255, 0))
    self.ui_layer:addChild(layer, 999)
    ed.loadBegin(false, false, T("\230\129\162\229\164\141\229\156\186\230\153\175\228\184\173..."))
    self.recover_layer = layer
  end
end

function BattleSceneUI:updateExtra(dt, paused)
  if self.recover_layer and not ed.engine.recovering then
    self.recover_layer:removeFromParentAndCleanup(true)
    self.recover_layer = nil
  end
  if not paused and self.openBarrage then
    self:updateBarrage(dt)
  end
end

function BattleSceneUI:resetBarrage(barrageArray)
  self.openBarrage = true
  self.barrageSpeed = 100
  self.currentTicks = 0
  self.barrageArray = barrageArray
  self.barrageLabelList = {}
  ed.videoplayer.panel.create(self)
end

function BattleSceneUI:updateBarrage(dt)
  self:moveBarrage(dt)
  self:createBarrage()
end

function BattleSceneUI:closeBarrage()
  self.openBarrage = false
  for _, barrageLabel in ipairs(self.barrageLabelList) do
    self:removeBarrage(barrageLabel)
  end
  self.barrageLabelList = {}
end

function BattleSceneUI:moveBarrage(dt)
  local xshift = self.barrageSpeed * dt
  local labelList = {}
  for _, barrageLabel in ipairs(self.barrageLabelList) do
    local xpos = barrageLabel:getPositionX()
    local nxpos = xpos - xshift
    if nxpos < -150 then
      self:removeBarrage(barrageLabel)
    else
      barrageLabel:setPositionX(nxpos)
      table.insert(labelList, barrageLabel)
    end
  end
  self.barrageLabelList = labelList
end

function BattleSceneUI:removeBarrage(barrageLabel)
  barrageLabel:removeFromParentAndCleanup(true)
end

function BattleSceneUI:createBarrage()
  local ticks = ed.engine.ticks
  if self.currentTicks == ticks then
    return
  end
  self.currentTicks = ticks
  local barrages = self.barrageArray[ticks] or {}
  for _, barrage in ipairs(barrages) do
    local isMute = barrage._is_mute
    if isMute ~= 1 then
      local contentText = barrage._content
      self:createBarrageLabel(contentText, barrage._color)
    end
  end
end

function BattleSceneUI:createBarrageLabel(text, colorflag)
  local color = self:getBarrageColor(colorflag)
  local label = ed.createLabelWithFontInfo(text, color)
  self.ui_layer:addChild(label)
  local pos = self:getBarragePos(colorflag)
  label:setPosition(pos)
  table.insert(self.barrageLabelList, label)
end

function BattleSceneUI:getBarrageColor(flag)
  if flag == 0 then
    return "videoplayer_white"
  elseif flag == 1 then
    return "videoplayer_yellow"
  end
end

function BattleSceneUI:getBarragePos(flag)
  local posx = 850
  local posyRang = {200, 450}
  if flag == 1 then
    posyRang = {120, 200}
  end
  local posy = math.random(posyRang[1], posyRang[2])
  return ccp(posx, posy)
end

function BattleSceneUI:addMyBarrage(content, colorflag)
  self:createBarrageLabel(content, colorflag)
end
