local base = ed.ui.popwindow
local CupArenaGambleAmountWin = newclass(base.mt)
ed.ui.CupArenaGambleAmountWin = CupArenaGambleAmountWin

function CupArenaGambleAmountWin:initLabels()
  local titleLabel = ed.ui.gradientLabel.create({
    text = T("\230\148\175\230\140\129"),
    fontSize = 28,
    fontName = ed.fontBold,
    startColor = ed.toccc3(16775930),
    endColor = ed.toccc3(16446666),
    shadowOffset = ccp(0, -1.5),
    shadowColor = ccc3(88, 15, 17)
  })
  self.ui.bg:addChild(titleLabel.node)
  titleLabel.node:setPosition(ccp(self.ui.bg:getContentSize().width * 0.5, self.ui.title_left:getPositionY()))
  ed.setLabelStroke(self.ui.label_count_des, ed.toccc3(2565412), 1)
  ed.setLabelStroke(self.ui.label_support, ed.toccc3(9458959), 1)
end

function CupArenaGambleAmountWin:initData(data)
  self.data = data
  self.curAmount = math.min(1000, self.data.maxAmount)
end

function CupArenaGambleAmountWin:initUI()
  ed.editorui(ed.uieditor.CupArenaGambleAmountWin, {
    container = self.container,
    ui = self.ui
  })
  self:initLabels()
  self:refreshAmount()
end

function CupArenaGambleAmountWin:refreshAmount()
  ed.setLabelString(self.ui.label_count_des, ed.formatNumber(self.curAmount))
  local leftAmount = self.data.maxAmount - self.curAmount
  if 0 == leftAmount then
    ed.setLabelString(self.ui.label_amount_tip, T("\229\183\178\232\190\190\229\136\176\230\156\172\229\156\186\230\156\128\229\164\167\230\148\175\230\140\129\233\162\157\239\188\129"))
  else
    ed.setLabelString(self.ui.label_amount_tip, T("\230\156\172\229\156\186\229\137\169\228\189\153\229\143\175\231\148\168\230\148\175\230\140\129\233\162\157\229\186\166\239\188\154%s", ed.formatNumber(leftAmount)))
  end
end

function CupArenaGambleAmountWin:registerTouchHandlers()
  self:btRegisterOutClick({
    area = self.ui.bg,
    clickHandler = function()
      if self.isCloseAnimPlaying then
        return
      end
      self:playCloseAction(function()
        self:destroy({skipAnim = true})
      end)
    end,
    key = "clickout"
  })
  ed.UITool.registerBtn(self, "btn_support", function()
    self:onSupportEvent()
  end, {pressScale = 0.95})
  self:registerChangeBtn("btn_sub_10", function()
    self:onChangeEvent(-10)
  end)
  self:registerChangeBtn("btn_sub_1", function()
    self:onChangeEvent(-1)
  end)
  self:registerChangeBtn("btn_add_1", function()
    self:onChangeEvent(1)
  end)
  self:registerChangeBtn("btn_add_10", function()
    self:onChangeEvent(10)
  end)
end

function CupArenaGambleAmountWin:createLoopFunc(func)
  local count = 0
  local delay = 0.5
  local accAcc = 2
  local speed = 10
  local accSpeed = 2
  local times = 0
  local func = func
  
  local function longPressHandler(dt)
    count = count + dt
    if count > delay then
      accSpeed = accSpeed + accAcc * dt
      speed = speed + accSpeed * dt
      times = times + speed * dt
      while 1 < times do
        func()
        times = times - 1
      end
    end
  end
  
  return longPressHandler
end

function CupArenaGambleAmountWin:registerChangeBtn(key, func)
  local config = {
    button = self.ui[key],
    key = key,
    clickHandler = function(_, x, y)
      ed.playEffect(ed.sound.deo.common_back)
      func(x, y)
    end,
    force = true,
    mcpMode = true,
    mcp_dis = 30,
    priority = -1,
    pressScale = 0.95,
    pressHandler = function()
      self:registerUpdateHandler("long_click_change_btn", self:createLoopFunc(func))
    end,
    cancelPressHandler = function()
      self:removeUpdateHandler("long_click_change_btn")
      self.ui[key]:setScale(1)
    end
  }
  self:btRegisterButtonClick(config)
end

function CupArenaGambleAmountWin:onChangeEvent(val)
  self.curAmount = self.curAmount + val * self.data.perAmount
  self.curAmount = math.min(self.curAmount, self.data.maxAmount)
  self.curAmount = math.max(self.curAmount, 0)
  self:refreshAmount()
end

function CupArenaGambleAmountWin:onSupportEvent()
  if self.isCloseAnimPlaying then
    return
  end
  if 0 == self.curAmount then
    ed.showToast(T("\230\178\161\230\156\137\232\182\179\229\164\159\231\154\132\230\148\175\230\140\129\233\162\157\229\186\166"))
    return
  end
  self:playCloseAction(function()
    if self.data.callback then
      self.data.callback(self.data.matchId, self.data.isHost, self.curAmount)
    end
    self:destroy({skipAnim = true})
  end)
end

function CupArenaGambleAmountWin:playShowAction()
  if nil == self.bgPos then
    self.bgPos = ccp(self.ui.bg:getPosition())
  end
  ed.setCascadeOpacityEnabled(self.ui.bg, true, true)
  self.ui.bg:setOpacity(0)
  self.ui.bg:setPositionY(self.bgPos.y + 20)
  self.ui.bg:runAction(CCSpawn:create(ccArrayMake(CCFadeIn:create(0.15), CCEaseOut:create(CCMoveTo:create(0.15, self.bgPos), 2))))
  self.mainLayer:setOpacity(0)
  self.mainLayer:runAction(CCFadeTo:create(0.15, 170))
end

function CupArenaGambleAmountWin:playCloseAction(func)
  self.isCloseAnimPlaying = true
  if nil == self.bgPos then
    self.bgPos = ccp(self.ui.bg:getPosition())
  end
  self.ui.bg:stopAllActions()
  self.ui.bg:runAction(CCSpawn:create(ccArrayMake(CCFadeTo:create(0.2, 0), CCEaseIn:create(CCMoveTo:create(0.2, ccpAdd(self.bgPos, ccp(0, 20))), 2))))
  self:listenTimer(Timer:Once(0.2), func)
  self.mainLayer:runAction(CCFadeTo:create(0.2, 0))
end

function CupArenaGambleAmountWin.create(data)
  local self = base.create("CupArenaGambleAmountWin")
  setmetatable(self, CupArenaGambleAmountWin.mt)
  self:initData(data)
  self:initUI()
  self:registerTouchHandlers()
  self:popWindow()
  self:playShowAction()
  return self
end
