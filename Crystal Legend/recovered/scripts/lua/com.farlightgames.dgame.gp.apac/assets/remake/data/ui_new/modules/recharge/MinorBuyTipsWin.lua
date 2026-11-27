local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.MinorBuyTipsWin = class
ed.UITool.registViewOpenFunc("MinorBuyTipsWin", function(param)
  class.create(param):popWindow()
end)

function class.create(areaTipsCfg)
  local self = base.create("MinorBuyTipsWin")
  setmetatable(self, class.mt)
  self:init(areaTipsCfg)
  return self
end

function class:init(areaTipsCfg)
  self.areaTipsCfg = areaTipsCfg
  self:initView()
  self:addTouchEvent()
  self:show()
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.summonRulePop)
  self.ui = ui
  self.container:addChild(container)
  ed.setLabelString(self.ui.label_title, self.areaTipsCfg.shortTips)
  local titleSize = self.ui.label_title:getContentSize()
  local titlePosX = self.ui.label_title:getPositionX()
  self.ui.ImageView_692:setPositionX(titlePosX - titleSize.width / 2 - 40)
  self.ui.ImageView_692_Copy0:setPositionX(titlePosX + titleSize.width / 2 + 40)
  local autoText = ed.ui.autoText.new()
  local desc
  if self.areaTipsCfg.superLinkText then
    desc = string.format("<lable ccc3(201,183,172)>%s</lable><br/><lable color=ccc3(201,183,172) clickhandler=%s>%s</lable>", self.areaTipsCfg.longTips, "superLink", self.areaTipsCfg.superLinkText)
  else
    desc = string.format("<lable ccc3(201,183,172)>%s</lable>", self.areaTipsCfg.longTips, self.areaTipsCfg.longTips)
  end
  autoText:initParam({
    context = desc,
    fontSize = 16,
    lineSpacing = 4,
    maxWidth = 554,
    priority = -300
  })
  self.ui.Image_bg:addChild(autoText.node)
  local _, height = autoText:getCurContentSize()
  self.height = height
  autoText.node:setPosition(25, 281)
  self.autoText = autoText
  autoText:addRegisterHandler("superLink", function()
    local url = self.areaTipsCfg.linkUrl
    if url then
      ed.openURL(url)
    end
  end)
end

function class:addTouchEvent()
  self:btRegisterOutClick({
    area = self.ui.panel_touch,
    key = "out_click",
    clickHandler = function()
      self:destroy()
    end
  })
end
