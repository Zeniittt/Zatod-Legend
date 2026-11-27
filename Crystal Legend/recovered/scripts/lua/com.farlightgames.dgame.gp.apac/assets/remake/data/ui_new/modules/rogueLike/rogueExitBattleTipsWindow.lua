local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.rogueExitBattleTipsWindow = class
ed.UITool.registViewOpenFunc("rogueExitBattleTipsWindow", function(param)
  ed.ui.rogueExitBattleTipsWindow.create(param):popWindow()
end)

function class.create(param)
  param = param or {}
  local noShade = param.noShade or false
  local self = base.create("rogueExitBattleTipsWindow", {noShade = noShade})
  setmetatable(self, class.mt)
  self:init(param)
  return self
end

function class:init(param)
  self.skipAnim = param.skipAnim or false
  self.rogueLikeMgr = ed.rogueLikeMgr.getInstance()
  self.content = param.content
  self.extTips = param.extTips
  self.confirmCallBack = param.confirmCallBack
  self:initView()
  self:addTouchEvent()
  self:addEventListener()
  if not self.skipAnim then
    self:show()
  end
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.rogueExitBattleTipsWindow)
  self.container:addChild(container)
  self.ui = ui
  self.ui.image_line_right:setScaleX(-1)
  local panelSize = self.ui.panel_desc:getContentSize()
  local autoText = ed.ui.autoText.new()
  autoText:initParam({
    context = self.content or "",
    color = ed.toccc3(16776423),
    fontSize = 18,
    maxWidth = panelSize.width
  })
  self.ui.panel_desc:addChild(autoText.node)
  autoText.node:setPosition(ccp(0, panelSize.height - 9))
  local panelSize = self.ui.panel_ext_desc:getContentSize()
  local extAutoText = ed.ui.autoText.new()
  extAutoText:initParam({
    context = self.extTips or "",
    color = ed.toccc3(16776423),
    fontSize = 18,
    maxWidth = panelSize.width
  })
  self.ui.panel_ext_desc:addChild(extAutoText.node)
  local extTipsW, extTipsH = extAutoText:getCurContentSize()
  extAutoText.node:setPosition(ccp(panelSize.width / 2 - extTipsW / 2, panelSize.height - 9))
end

function class:onClickBtnCancel()
  self:destroy()
end

function class:onClickBtnConfirm()
  self:destroy({skipAnim = true})
  if self.confirmCallBack then
    self.confirmCallBack()
  end
end

function class:addTouchEvent()
  self:btRegisterOutClick({
    area = self.ui.image_bg,
    key = "clickOut",
    clickHandler = function()
      self:destroy({
        skipAnim = self.skipAnim
      })
    end,
    force = true
  })
  ed.UITool.registerBtn(self, "btn_cancel", function()
    self:onClickBtnCancel()
  end, {normalScale = 0.8, pressScale = 0.75})
  ed.UITool.registerBtn(self, "btn_confirm", function()
    self:onClickBtnConfirm()
  end, {normalScale = 0.8, pressScale = 0.75})
end

function class:addEventListener()
end
