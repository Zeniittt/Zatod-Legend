local base = ed.ui.basescene
local class = newclass(base.mt)
ed.ui.rogueEventBusiness = class
class.BTN_BUY_SHOP = {
  key = "btn_buy_shop",
  text = T("\231\156\139\231\156\139\228\187\150\231\154\132\232\180\167\231\137\169")
}
class.BTN_ENHANCE_SHOP = {
  key = "btn_enhance_shop",
  text = T("\229\188\186\229\140\150\231\165\157\231\166\143")
}
class.BTN_LEAVE = {
  key = "btn_leave",
  text = T("\232\189\172\232\186\171\231\166\187\229\188\128")
}
ed.UITool.registViewOpenFunc("rogueEventBusiness", function(param)
  local scene = ed.ui.rogueEventBusiness.create(param)
  ed.pushScene(scene)
end)

function class.create(param)
  local self = base.create("rogueEventBusiness")
  setmetatable(self, class.mt)
  self:init(param)
  return self
end

function class:init(param)
  param = param or {}
  self.roomId = param.roomId
  self.type = param.type
  self.goods = param.goods
  self.rogueLikeMgr = ed.rogueLikeMgr.getInstance()
  self.btnList = {}
  self:initView()
  self:addEventListener()
  self:showOpenAction()
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.rogueEventBusiness)
  self.mainLayer:addChild(container)
  self.ui = ui
  self:adaptUI()
  self:initLabels()
  self:initDragList()
  self:refreshDragList()
  self:refreshPearlAmount()
  self:refreshRetryTimesAmount()
end

function class:adaptUI()
  ed.layout.layoutWithMagin(self.ui.image_pearl_bg, {right = 10, top = 20}, false, true)
  ed.layout.layoutWithMagin(self.ui.image_retry_bg, {right = 120, top = 20}, false, true)
  self.ui.image_title_left:setPositionX(self.ui.label_title:getPositionX() - self.ui.label_title:getContentSize().width / 2 - self.ui.image_title_left:getContentSize().width * 0.5 - 35)
  self.ui.image_title_right:setPositionX(self.ui.label_title:getPositionX() + self.ui.label_title:getContentSize().width / 2 + self.ui.image_title_right:getContentSize().width * 0.5 + 35)
  ed.setLabelDimensions(self.ui.label_desc, CCSizeMake(440, 0))
  self.ui.panel_option:setPositionY(self.ui.label_desc:getPositionY() - self.ui.label_desc:getContentSize().height * 0.5 - 15 - self.ui.panel_option:getContentSize().height)
end

function class:initLabels()
  ed.setLabelStroke(self.ui.label_title, ed.toccc3(10177828), 1)
  ed.setLabelFontName(self.ui.label_title, ed.fontBold)
end

function class:showOpenAction()
  self.ui.image_bg:setOpacity(0)
  self.ui.image_bg:setPositionX(self.ui.image_bg:getPositionX() - 150)
  self.ui.image_bg:runAction(CCSpawn:create(ccArrayMake(CCMoveBy:create(0.3, ccp(150, 0)), CCFadeIn:create(0.2))))
  self.ui.event_info_bg:setOpacity(0)
  self.ui.event_info_bg:setPositionX(self.ui.event_info_bg:getPositionX() + 150)
  self.ui.event_info_bg:runAction(CCSpawn:create(ccArrayMake(CCMoveBy:create(0.3, ccp(-150, 0)), CCFadeIn:create(0.2))))
  self.ui.dec1:setVisible(false)
  self.ui.dec5:setVisible(true)
  local callFunc = CCCallFunc:create(function()
    self.ui.dec1:setVisible(true)
    self.ui.dec5:setVisible(false)
  end)
  self.ui.dec5:runAction(CCSequence:create(ccArrayMake(CCDelayTime:create(0.7), callFunc)))
  self.ui.dec3:setOpacity(0)
  self.ui.dec3:runAction(CCSequence:create(ccArrayMake(CCDelayTime:create(0.8), CCFadeIn:create(0.3))))
  self.ui.shop_icon:runAction(CCSequence:create(ccArrayMake(CCDelayTime:create(0.3), CCRotateBy:create(0.15, 5), CCRotateBy:create(0.15, -5))))
  self.ui.label_title:setOpacity(0)
  self.ui.image_title_left:setOpacity(0)
  self.ui.image_title_right:setOpacity(0)
  self.ui.label_title:runAction(CCSequence:create(ccArrayMake(CCDelayTime:create(0.3), CCFadeIn:create(0.2))))
  self.ui.image_title_left:runAction(CCSequence:create(ccArrayMake(CCDelayTime:create(0.3), CCFadeIn:create(0.2))))
  self.ui.image_title_right:runAction(CCSequence:create(ccArrayMake(CCDelayTime:create(0.3), CCFadeIn:create(0.2))))
  self.ui.label_desc:setOpacity(0)
  self.ui.label_desc:runAction(CCSequence:create(ccArrayMake(CCDelayTime:create(0.4), CCFadeIn:create(0.2))))
  for index, item in ipairs(self.dragList.listItems) do
    item:setOpacity(0)
    item:runAction(CCSequence:create(ccArrayMake(CCDelayTime:create(0.3 + index * 0.1), CCFadeIn:create(0.4))))
  end
end

function class:initDragList()
  self.dragList = ed.UITool.createDraglist(self.ui.panel_option, {
    doPressIn = function(x, y)
      for _, btnInfo in ipairs(self.btnList) do
        local btn = btnInfo.btn
        if ed.containsPoint(btn, x, y) then
          btn:setScale(0.95)
          return btnInfo
        end
      end
    end,
    doClickIn = function(x, y, btnInfo)
      local btn = btnInfo.btn
      local btnCfg = btnInfo.btnCfg
      if ed.containsPoint(btn, x, y) then
        local key = btnCfg.key
        if key == "btn_buy_shop" then
          self:onClickBtnBuyShop()
        elseif key == "btn_enhance_shop" then
          self:onClickBtnEnhanceShop()
        elseif key == "btn_leave" then
          self:onClickBtnLeave()
        end
      end
    end,
    cancelPressIn = function(x, y, btnInfo)
      local btn = btnInfo.btn
      btn:setScale(1)
    end
  })
end

function class:refreshDragList()
  local btnKeyList
  if self.type == "buy_shop" then
    btnKeyList = {
      class.BTN_BUY_SHOP,
      class.BTN_LEAVE
    }
  elseif self.type == "enhance_shop" then
    btnKeyList = {
      class.BTN_ENHANCE_SHOP,
      class.BTN_LEAVE
    }
  elseif self.type == "all_shop" then
    btnKeyList = {
      class.BTN_BUY_SHOP,
      class.BTN_ENHANCE_SHOP,
      class.BTN_LEAVE
    }
  else
    btnKeyList = {
      class.BTN_LEAVE
    }
  end
  local panelSize = self.ui.panel_option:getContentSize()
  local posY = 0
  for index, btnCfg in ipairs(btnKeyList) do
    local btn = self:createBtn(btnCfg)
    table.insert(self.btnList, {btn = btn, btnCfg = btnCfg})
    local btnSize = btn:getContentSize()
    self.dragList:addItem(btn)
    btn:setPosition(ccp(panelSize.width / 2, panelSize.height - posY - btnSize.height / 2))
    posY = posY + btnSize.height + 8
  end
end

function class:createBtn(btnCfg)
  local text = btnCfg.text
  local btnBg = ed.createSprite("UI/alpha/1080P/rogue/instance/instance_event_choice_button2.png")
  local titleLabel = ed.createttf(text, 21)
  ed.setLabelColor(titleLabel, ed.toccc3(16774864))
  ed.setLabelStroke(titleLabel, ed.toccc3(10580513), 1)
  titleLabel:setAnchorPoint(ccp(0, 0.5))
  btnBg:addChild(titleLabel)
  titleLabel:setPosition(ccp(25, btnBg:getContentSize().height / 2 + 5))
  btnBg:setCascadeOpacityEnabled(true)
  return btnBg
end

function class:refreshPearlAmount()
  local pearl = self.rogueLikeMgr:getPearl()
  ed.setLabelString(self.ui.pearl_amount, pearl)
end

function class:refreshRetryTimesAmount()
  local retryTimes = self.rogueLikeMgr:getRetryTimes()
  ed.setLabelString(self.ui.retry_amount, string.format("%s", retryTimes))
end

function class:onClickBtnBuyShop()
  ed.UITool.openView("rogueShopScene", {
    roomId = self.roomId,
    type = "buy_shop",
    goods = self.goods
  })
end

function class:onClickBtnEnhanceShop()
  local curChapter = self.rogueLikeMgr:getCurChapter()
  local goods = {}
  for index, rogueBless in ipairs(curChapter._bless_list or {}) do
    local blessId = rogueBless._bless
    local blessLevel = rogueBless._level
    local rogueBlessCfg = ed.getDataTable("RogueBless")[blessId]
    local rarity = rogueBlessCfg.Rarity
    local canBeReinforced = rogueBlessCfg["Can Be Reinforced"]
    local key = string.format("NormalBless Rarity %s Reinforced Price", rarity)
    local reinforcePrice = ed.getDataTable("RogueBlessConfig")[key]
    if blessLevel == 1 and canBeReinforced then
      table.insert(goods, {
        _bless_id = rogueBless._bless,
        _price = reinforcePrice and reinforcePrice["Script Arg"][1] or 0
      })
    end
  end
  if #goods == 0 then
    ed.showToast(T("\230\178\161\230\156\137\229\143\175\228\187\165\229\188\186\229\140\150\231\154\132\231\165\157\231\166\143"))
    return
  end
  ed.UITool.openView("rogueShopScene", {
    roomId = self.roomId,
    type = "enhance_shop",
    goods = goods
  })
end

function class:onClickBtnLeave()
  ed.popScene()
end

function class:addEventListener()
  self:listenEvent("rogueUpdatePearlAmount", function()
    self:refreshPearlAmount()
  end)
  self:listenEvent("rogueUpdateRetryTimes", function()
    self:refreshRetryTimesAmount()
  end)
end

function class:addTouchEvent()
end
