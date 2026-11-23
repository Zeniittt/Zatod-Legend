local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.rogueRevelationDetailWindow = class
ed.UITool.registViewOpenFunc("rogueRevelationDetailWindow", function(param)
  ed.ui.rogueRevelationDetailWindow.create(param):popWindow()
end)

function class.create(param)
  local self = base.create("rogueRevelationDetailWindow", {noShade = true, notBlurBg = true})
  setmetatable(self, class.mt)
  self:init(param)
  return self
end

function class:init(param)
  param = param or {}
  self.destinyId = param.destinyId
  self.rogueLikeMgr = ed.rogueLikeMgr:getInstance()
  self:initView()
  self:addTouchEvent()
  self:addEventListener()
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.rogueRevelationDetailWindow)
  self.container:addChild(container)
  self.ui = ui
  self:initLabels()
  self:refreshView()
end

function class:refreshView()
  local destinyCfg = ed.getDataTable("RogueDestiny")[self.destinyId]
  ed.setLabelString(self.ui.label_name, destinyCfg["Revelation Name"])
  ed.setLabelString(self.ui.label_destiny, string.format(T("%s\231\154\132\229\144\175\231\164\186"), destinyCfg["Display Name"]))
  local descAutoText = ed.rogueLikeTool.parseAutoTextDesc(destinyCfg["Revelation Description"], destinyCfg, {
    maxWidth = self.ui.image_bg:getContentSize().width - 30,
    color = ed.toccc3(15249746),
    fontSize = 18
  })
  self.ui.image_bg:addChild(descAutoText.node)
  descAutoText.node:setPosition(ccp(self.ui.label_name:getPositionX(), self.ui.label_name:getPositionY() - 40))
  local descSizeW, descSizeH = descAutoText:getCurContentSize()
  local extAutoText = ed.ui.autoText.new()
  extAutoText:initParam({
    context = string.format(T("\232\142\183\229\143\150<lable color=ccc3(243,123,27)>3</lable>\228\184\170%s\231\154\132\231\165\157\231\166\143\228\187\165\230\191\128\230\180\187\230\156\172\229\144\175\231\164\186\239\188\140\230\191\128\230\180\187\229\144\142\239\188\140\232\142\183\229\143\150%s\231\154\132\231\165\157\231\166\143\232\190\190\229\136\176<lable color=ccc3(243,123,27)>6/9/12</lable>\230\151\182\229\143\175\233\128\137\230\139\169<lable color=ccc3(243,123,27)>1</lable>\228\184\170\230\183\177\229\186\166\229\144\175\231\164\186\230\157\165\229\188\186\229\140\150\230\156\172\229\144\175\231\164\186"), destinyCfg["Display Name"], destinyCfg["Display Name"]),
    fontSize = 18,
    color = ed.toccc3(16776423),
    maxWidth = self.ui.image_bg:getContentSize().width - 30
  })
  self.ui.image_bg:addChild(extAutoText.node)
  extAutoText.node:setPosition(ccp(self.ui.label_name:getPositionX(), descAutoText.node:getPositionY() - descSizeH - 20))
end

function class:initLabels()
  ed.setLabelFontName(self.ui.label_name, ed.fontBold)
  ed.setLabelStroke(self.ui.label_name, ed.toccc3(2565412), 1)
end

function class:addTouchEvent()
  self:btRegisterOutClick({
    area = self.ui.image_bg,
    key = "clickOut",
    clickHandler = function()
      self:destroy({skipAnim = true})
    end,
    priority = -300,
    force = true
  })
end

function class:addEventListener()
end
