local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.fireForeConfirmWindow = class
ed.UITool.registViewOpenFunc("fireForeConfirmWindow", function(param)
  local window = ed.ui.fireForeConfirmWindow.create(param)
  window:show()
  window:popWindow()
end)

function class.create(param)
  local self = base.create("fireForeConfirmWindow")
  setmetatable(self, class.mt)
  self:init(param or {})
  return self
end

function class:init(param)
  self.title = param.title
  self.desc = param.desc
  self.type = param.type
  self.costType = param.costType
  self.costAmount = param.costAmount
  self.costId = param.costId
  self.leftHandler = param.leftHandler
  self.rightHandler = param.rightHandler
  self.rightText = param.rightText
  self:initView()
  self:addTouchEvent()
  self:addEventListen()
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.fire_forge_confirm_window)
  self.container:addChild(container)
  self.ui = ui
  self:initLabels()
  self:adaptUI()
  ed.setLabelString(self.ui.label_title, self.title or T("\230\143\144\231\164\186"))
  self:refreshDesc()
  self:refreshCost()
end

function class:adaptUI()
  if self.costType then
    local oldSize = self.ui.panel_desc:getContentSize()
    self.ui.panel_desc:setContentSize(CCSizeMake(oldSize.width, oldSize.height - 15))
    self.ui.panel_desc:setPositionY(self.ui.panel_desc:getPositionY() + 15)
  end
end

function class:initLabels()
  ed.setLabelShadow(self.ui.label_title, ccc3(0, 0, 0), ccp(0, 1.5))
  local labelCancel = ed.ui.gradientLabel.create({
    text = T("\229\143\150\230\182\136"),
    fontSize = 20,
    startColor = ed.toccc3(16770735),
    endColor = ed.toccc3(16316121),
    strokeSize = 1,
    strokeColor = ed.toccc3(8931382)
  })
  self.ui.btn_cancel:addChild(labelCancel.node)
  ed.layout.centerInParent(labelCancel.node)
  local labelConfirm = ed.ui.gradientLabel.create({
    text = self.rightText or T("\231\161\174\229\174\154"),
    fontSize = 20,
    startColor = ed.toccc3(16775087),
    endColor = ed.toccc3(16776946),
    strokeSize = 1,
    strokeColor = ed.toccc3(10572575)
  })
  self.ui.btn_confirm:addChild(labelConfirm.node)
  ed.layout.centerInParent(labelConfirm.node)
end

function class:refreshCost()
  if self.costType then
    self.ui.icon_cost:setVisible(true)
    ed.setTexture(self.ui.icon_cost, self:getIcon(), true)
    local ownAmount = self:getAmount()
    local costAmount = self.costAmount or 0
    local color = ownAmount >= costAmount and "ccc3(141,244,118)" or "ccc3(244,0,0)"
    local autoText = ed.ui.autoText.new()
    autoText:initParam({
      context = string.format("<lable color=%s>%s</lable>/%s", color, ownAmount, costAmount),
      fontSize = 14,
      color = ccc3(255, 252, 231),
      strokeColor = ccc3(0, 0, 0),
      strokeSize = 1
    })
    local iconSize = self.ui.icon_cost:getContentSize()
    self.ui.icon_cost:addChild(autoText.node)
    autoText.node:setPosition(ccp(iconSize.width, iconSize.height / 2))
    local w, h = autoText:getCurContentSize()
    self.ui.icon_cost:setPositionX(self.ui.btn_confirm:getPositionX() - w / 2)
  else
    self.ui.icon_cost:setVisible(false)
  end
end

function class:getAmount()
  if self.costType == "diamond" then
    return ed.player:getDiamondAmount()
  elseif self.costType == "item" then
    return ed.player:getEquipAmount(self.costId)
  end
  return 0
end

function class:getIcon()
  local res
  if self.costType == "diamond" then
    res = "UI/alpha/1080P/icon/diamond.png"
  elseif self.costType == "item" then
    res = "UI/alpha/1080P/fireforge/art5.png"
  end
  return res
end

function class:refreshDesc()
  local panelSize = self.ui.panel_desc:getContentSize()
  local autoText = ed.ui.autoText.new()
  autoText:initParam({
    context = self.desc or "",
    color = ccc3(255, 252, 231),
    strokeColor = ed.toccc3(1774610),
    strokeSize = 1,
    maxWidth = panelSize.width,
    fontSize = 19
  })
  self.ui.panel_desc:addChild(autoText.node)
  local w, h = autoText:getCurContentSize()
  autoText.node:setPosition(ccp(panelSize.width / 2 - w / 2, panelSize.height / 2 + h / 2 - 9.5))
end

function class:onClickBtnCancel()
  if self.leftHandler then
    self.leftHandler()
  end
  self:destroy()
end

function class:onClickBtnConfirm()
  if self.rightHandler then
    self.rightHandler()
  end
  self:destroy({skipAnim = true})
end

function class:onClickBtnClose()
  self:destroy()
end

function class:addTouchEvent()
  self:btRegisterOutClick({
    area = self.ui.image_bg,
    key = "clickOut",
    clickHandler = function()
      self:destroy()
    end,
    force = true
  })
  ed.UITool.registerBtn(self, "btn_cancel", function()
    self:onClickBtnCancel()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_confirm", function()
    self:onClickBtnConfirm()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_close", function()
    self:onClickBtnClose()
  end, {pressScale = 0.95})
end

function class:addEventListen()
end

function class:getGuideNode(nodeKey)
  if nodeKey == "btn_confirm" then
    return self.ui.btn_confirm
  end
  return base.getGuideNode(self, nodeKey)
end
