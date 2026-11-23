local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.rogueBlessReinforceWindow = class
ed.UITool.registViewOpenFunc("rogueBlessReinforceWindow", function(param)
  ed.ui.rogueBlessReinforceWindow.create(param):popWindow()
end)

function class.create(param)
  local self = base.create("rogueBlessReinforceWindow", {noShade = false})
  setmetatable(self, class.mt)
  self:init(param)
  return self
end

function class:init(param)
  param = param or {}
  self.blessIdList = param.blessIdList or {}
  self.closeCallBack = param.closeCallBack
  self.tips = param.tips
  self.showIndex = 1
  self.rogueLikeMgr = ed.rogueLikeMgr.getInstance()
  self.heroList = {}
  self.isShowDetail = false
  self:initView()
  self:addTouchEvent()
  self:addEventListener()
  self:show()
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.rogueBlessReinforceWindow)
  self.container:addChild(container)
  self.ui = ui
  if self.tips then
    ed.setLabelString(self.ui.labtl_tips, self.tips)
  end
  self:refreshCard()
  self:refreshBtnDetail()
end

function class:refreshCard()
  if self.showIndex > #self.blessIdList then
    return
  end
  local blessId = self.blessIdList[self.showIndex]
  self.ui.panel_left:removeAllChildrenWithCleanup(true)
  local cardLeft = ed.rogueLikeTool.createBlessCard(blessId, {
    descType = self.isShowDetail and "Full Description" or "Description"
  })
  self.ui.panel_left:addChild(cardLeft)
  ed.layout.centerInParent(cardLeft)
  self.ui.panel_right:removeAllChildrenWithCleanup(true)
  local cardRight = ed.rogueLikeTool.createBlessCard(blessId, {
    descType = self.isShowDetail and "Reinforced Full Description" or "Reinforced Description",
    isReinforce = true
  })
  local fca = ed.createFcaNode("eff_UI_rogue_bless_reinforce2")
  cardRight:addChild(fca)
  self:addFca(fca)
  local cardSize = cardRight:getContentSize()
  fca:setPosition(ccp(cardSize.width / 2, cardSize.height / 2 - 52))
  self.ui.panel_right:addChild(cardRight)
  ed.layout.centerInParent(cardRight)
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
    self:refreshCard()
  end)
  local action = CCSequence:create(ccArrayMake(moveAction, callFunc))
  self.ui.image_detail_switch:runAction(action)
end

function class:onClickBtnConfirm()
  self.showIndex = self.showIndex + 1
  if self.showIndex > #self.blessIdList then
    self:destroy({skipAnim = true})
    if self.closeCallBack then
      self.closeCallBack()
    end
  else
    self:refreshCard()
  end
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
