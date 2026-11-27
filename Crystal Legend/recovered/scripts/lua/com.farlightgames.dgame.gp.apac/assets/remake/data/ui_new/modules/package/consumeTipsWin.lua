local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.consumeTipsWin = class
class.consumeTipsKey = "consumeTipsKey"
ed.UITool.registViewOpenFunc("consumeTipsWin", function(param)
  ed.ui.consumeTipsWin.create(param):popWindow()
end)

function class.isEnableShowWin(key)
  key = key or class.consumeTipsKey
  local lastTime = ed.storage.getInt(ed.getRoleKey(key))
  if not lastTime then
    return true
  end
  local y, m, d = ed.time2YMD(lastTime)
  local nowTime = ed.getServerTime()
  local nowY, nowM, nowD = ed.time2YMD(nowTime)
  if nowD ~= d and nowTime ~= lastTime then
    return true
  end
  return false
end

function class.create(param)
  local self = base.create("consumeTipsWin")
  setmetatable(self, class.mt)
  self:init(param)
  return self
end

function class:init(param)
  param = param or {}
  self.text = param.text
  self.leftText = param.leftText
  self.rightText = param.rightText
  self.leftHandler = param.leftHandler
  self.rightHandler = param.rightHandler
  self.checkBoxKey = param.key or class.consumeTipsKey
  self.notShowCheckBox = param.notShowCheckBox or false
  self.isCheckBoxSelect = false
  self:initView()
  self:addTouchEvent()
  self:show()
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.consumeTipsWin)
  self.container:addChild(container)
  self.ui = ui
  ed.setLabelStroke(self.ui.label_title, ed.toccc3(4406072), 1)
  self.ui.label_title:setFontName(ed.fontBold)
  if self.leftText then
    ed.setLabelString(self.ui.label_left, self.leftText)
  end
  if self.rightText then
    ed.setLabelString(self.ui.label_right, self.rightText)
  end
  if self.notShowCheckBox then
    self.ui.btn_check_box:setVisible(false)
  else
    self.ui.btn_check_box:setVisible(true)
  end
  self:initDesc()
  self:refreshCheckBox()
  local totalWidth = self.ui.label_check_box:getPositionX() + self.ui.label_check_box:getContentSize().width
  self.ui.btn_check_box:setPositionX(476 - totalWidth + self.ui.btn_check_box:getContentSize().width * 0.5)
end

function class:initDesc()
  local layer = self.ui.panel_desc
  local layerSize = layer:getContentSize()
  local autoText = ed.ui.autoText.new()
  self.text = self.text
  autoText:initParam({
    context = self.text,
    maxWidth = layerSize.width,
    color = ccc3(25, 2, 3)
  })
  layer:addChild(autoText.node)
  local autoTextWidth, autoTextHeight = autoText:getCurContentSize()
  autoText.node:setPositionX(layerSize.width / 2 - autoTextWidth / 2)
  autoText.node:setPositionY((layerSize.height + autoTextHeight) / 2)
end

function class:refreshCheckBox()
  self.ui.image_select:setVisible(self.isCheckBoxSelect)
end

function class:changeCheckBox()
  self.isCheckBoxSelect = not self.isCheckBoxSelect
  self:refreshCheckBox()
end

function class:addTouchEvent()
  ed.UITool.registerBtn(self, "btn_left", function()
    if self.leftHandler then
      self.leftHandler()
    end
    self:destroy()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_right", function()
    if self.rightHandler then
      self.rightHandler()
    end
    if self.isCheckBoxSelect then
      ed.storage.setValue(ed.getRoleKey(self.checkBoxKey), ed.getServerTime())
    end
    self:destroy()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_check_box", function()
    self:changeCheckBox()
  end, {pressScale = 0.95})
  self:btRegisterOutClick({
    area = self.ui.image_bg,
    key = "clickOut",
    clickHandler = function()
      self:destroy()
    end
  })
end
