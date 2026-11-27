local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.rogueRevelationUnlockWindow = class
ed.UITool.registViewOpenFunc("rogueRevelationUnlockWindow", function(param)
  ed.ui.rogueRevelationUnlockWindow.create(param):popWindow()
end)

function class.create(param)
  local self = base.create("rogueRevelationUnlockWindow")
  setmetatable(self, class.mt)
  self:init(param)
  return self
end

function class:init(param)
  param = param or {}
  self.destinyId = param.destinyId or 1
  self.isShowDetail = false
  self:initView()
  self:addTouchEvent()
  self:addEventListener()
  self:show()
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.rogueRevelationUnlockWindow)
  self.container:addChild(container)
  self.ui = ui
  self:initLabels()
  self:initEffect()
  self:initDestinyCard()
  self:initTitleTips()
  self:refreshBtnDetail()
  ed.rogueGuide.getInstance():startGuide("rogueRevelationUnlockWindow", self.revelationCard)
end

function class:initLabels()
end

function class:initEffect()
  local eff_light = ed.createFcaNode("eff_UI_rogue_echo_light")
  self.ui.image_bg:addChild(eff_light, 0)
  self:addFca(eff_light)
  eff_light:setAction("Loop")
  local panelSize = self.ui.panel_card_bg:getContentSize()
  eff_light:setPositionX(self.ui.panel_card_bg:getPositionX() + panelSize.width / 2)
  eff_light:setPositionY(self.ui.panel_card_bg:getPositionY() + panelSize.height / 2)
end

function class:initDestinyCard()
  self.ui.panel_card_bg:removeAllChildrenWithCleanup(true)
  local descType = self.isShowDetail and "Revelation Full Description" or "Revelation Description"
  local card, ui = ed.rogueLikeTool.createRevelationCard(self.destinyId, {descType = descType})
  local fca = ed.createFcaNode("eff_UI_rogue_bless_reinforce2")
  card:addChild(fca)
  self:addFca(fca)
  local cardSize = card:getContentSize()
  fca:setPosition(ccp(cardSize.width / 2, cardSize.height / 2))
  self.ui.panel_card_bg:addChild(card)
  ed.layout.centerInParent(card)
  self.revelationCard = card
end

function class:initTitleTips()
  local autoText = ed.ui.autoText.new()
  local destinyName = ed.getDataTable("RogueDestiny")[self.destinyId]["Display Name"]
  local context = string.format(T("\229\183\178\232\142\183\229\190\151<lable color=ccc3(243,123,27) strokeColor=destinyStrokeColor strokeSize=1>3</lable>\228\184\170%s\231\165\157\231\166\143\239\188\140\229\145\189\232\191\144\229\144\175\231\164\186\230\191\128\230\180\187"), destinyName)
  autoText:initParam({
    context = context,
    fontSize = 18,
    color = ed.toccc3(16776423),
    strokeColor = ed.toccc3(3085579),
    strokeSize = 1
  })
  self.ui.image_tips_bg:addChild(autoText.node)
  local width, height = autoText:getCurContentSize()
  ed.layout.centerYInParent(autoText.node)
  autoText.node:setPositionX((self.ui.image_tips_bg:getContentSize().width - width) / 2)
end

function class:refreshBtnDetail()
  local btnBgPath, switchPath
  if self.isShowDetail then
    btnBgPath = "UI/alpha/1080P/rogue/bless/bless_shop_batchchoose_on.png"
    switchPath = "UI/alpha/1080P/rogue/bless/bless_shop_batchchoose_button2.png"
  else
    btnBgPath = "UI/alpha/1080P/rogue/bless/bless_shop_batchchoose_close.png"
    switchPath = "UI/alpha/1080P/rogue/bless/bless_shop_batchchoose_button1.png"
  end
  ed.setTexture(self.ui.btn_detail, btnBgPath)
  ed.setTexture(self.ui.image_detail_switch, switchPath)
  self:initDestinyCard()
end

function class:onClickBtnConfirm()
  self:destroy()
end

function class:onClickBtnDetail()
  self.isShowDetail = not self.isShowDetail
  local pos
  if self.isShowDetail then
    pos = ccp(40, 10)
  else
    pos = ccp(10, 10)
  end
  local moveAction = CCMoveTo:create(0.3, pos)
  local callFunc = CCCallFunc:create(function()
    self:refreshBtnDetail()
  end)
  local action = CCSequence:create(ccArrayMake(moveAction, callFunc))
  self.ui.image_detail_switch:runAction(action)
end

function class:addTouchEvent()
  ed.UITool.registerBtn(self, "btn_confirm", function()
    self:onClickBtnConfirm()
  end, {pressScale = 0.95, normalScale = 1})
  ed.UITool.registerBtn(self, "btn_detail", function()
    self:onClickBtnDetail()
  end, {pressScale = 0.95, normalScale = 1})
end

function class:addEventListener()
end
