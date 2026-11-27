local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.rogueRewardWindow = class
class.TYPE_ADD = "add"
class.TYPE_LOSE = "lose"
ed.UITool.registViewOpenFunc("rogueRewardWindow", function(param)
  ed.ui.rogueRewardWindow.create(param):popWindow()
end)

function class.create(param)
  local self = base.create("rogueRewardWindow")
  setmetatable(self, class.mt)
  self:init(param)
  return self
end

function class:init(param)
  param = param or {}
  self.amount = param.amount or 0
  self.type = param.type or self.TYPE_ADD
  self.amountList = param.amountList
  self.closeCallBack = param.closeCallBack
  self.showIndex = 1
  if self.amountList and 0 < #self.amountList then
    local cfg = self.amountList[self.showIndex]
    self.amount = cfg.amount
    self.type = cfg.type
  end
  self:initView()
  self:addTouchEvent()
  self:addEventListener()
  self.refreshCliprectConfig = {
    draglist = self.dragList
  }
  self:show()
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.rogueRewardWindow)
  self.container:addChild(container)
  self.ui = ui
  self:initLabels()
  self:initDragList()
  self:refreshView()
end

function class:refreshView()
  local titleLabel
  if self.type == self.TYPE_ADD then
    titleLabel = ed.ui.gradientLabel.create({
      text = T("\232\142\183\229\190\151\233\129\147\229\133\183"),
      fontSize = 49,
      fontName = ed.fontBold,
      startColor = ed.toccc3(16776703),
      endColor = ed.toccc3(16568317)
    })
    ed.setTexture(self.ui.image_bg, "UI/alpha/1080P/rogue/instance/event/result_pearl_get.png")
  elseif self.type == self.TYPE_LOSE then
    titleLabel = ed.ui.gradientLabel.create({
      text = T("\229\164\177\229\142\187\233\129\147\229\133\183"),
      fontSize = 49,
      fontName = ed.fontBold,
      startColor = ed.toccc3(15128277),
      endColor = ed.toccc3(15176875)
    })
    ed.setTexture(self.ui.image_bg, "UI/alpha/1080P/rogue/instance/event/result_pearl_lose.png")
  end
  if titleLabel then
    self.ui.panel_title:removeAllChildrenWithCleanup(true)
    self.ui.panel_title:addChild(titleLabel.node)
    ed.layout.centerInParent(titleLabel.node)
  end
  self:refreshDragList()
end

function class:initLabels()
end

function class:initDragList()
  self.dragList = ed.UITool.createDraglist(self.ui.panel_list)
end

function class:refreshDragList()
  local panelSize = self.ui.panel_list:getContentSize()
  self.dragList:clearList()
  local amount = self.amount
  local itemIcon = self:createItemIcon(amount)
  self.dragList:addItem(itemIcon)
  itemIcon:setPosition(ccp(panelSize.width / 2, panelSize.height / 2 + 13))
  self:btRegisterButtonClick({
    button = itemIcon,
    key = "clickPearl",
    clickHandler = function()
      ed.ui.packageDetailWin.create({type = "pearl"}):popWindow()
    end,
    force = true
  })
end

function class:createItemIcon(amount)
  local itemIcon = ed.createItemIcon({
    id = nil,
    type = "Pearl",
    amount = amount
  })
  itemIcon:setScale(1)
  local name = ed.createttf(T("\231\143\141\231\143\160"), 12)
  ed.setLabelColor(name, ccc3(255, 252, 231))
  ed.setLabelStroke(name, ed.toccc3(3745060), 1)
  itemIcon:addChild(name)
  name:setPosition(ccp(itemIcon:getContentSize().width / 2, -10))
  return itemIcon
end

function class:onClickOut()
  if self.amountList and #self.amountList > self.showIndex then
    self.showIndex = self.showIndex + 1
    local cfg = self.amountList[self.showIndex]
    self.amount = cfg.amount
    self.type = cfg.type
    self:refreshView()
  else
    self:destroy({
      callback = function()
        if self.closeCallBack then
          self.closeCallBack()
        end
      end
    })
  end
end

function class:addTouchEvent()
  self:btRegisterOutClick({
    area = self.ui.panel_click_area,
    key = "clickOut",
    clickHandler = function()
      self:onClickOut()
    end,
    force = true
  })
end

function class:addEventListener()
end
