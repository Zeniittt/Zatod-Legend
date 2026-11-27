local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.kingsGradeUpWin = class
ed.UITool.registViewOpenFunc("kingsGradeUpWin", function(param)
  ed.ui.kingsGradeUpWin.create(param):popWindow()
end)

function class.create(param)
  local self = base.create("kingsGradeUpWin", {layer_opacity = 204})
  setmetatable(self, class.mt)
  self:init(param)
  return self
end

function class:init(param)
  param = param or {}
  self.beforeGrade = param.beforeGrade or 1
  self.afterGrade = param.afterGrade or 1
  self:initUI()
  self:addTouchEvent()
  self:show()
end

function class:initUI()
  local container, ui = ed.editorui(ed.uieditor.kingsRankUpWin)
  self.container:addChild(container)
  self.ui = ui
  self:initLabels()
  local gradeCfg = ed.getDataTable("KingsGrade")[self.beforeGrade]
  ed.setLabelString(self.ui.label_name, gradeCfg.Name)
  ed.setTexture(self.ui.image_rank_icon, gradeCfg.Icon, true)
  self:initEffect()
end

function class:initEffect()
  local eff = ed.createFcaNode("eff_UI_kingspvp_rank_up")
  self:addFca(eff)
  self.ui.image_bg:addChild(eff)
  local bgSize = self.ui.image_bg:getContentSize()
  eff:setPosition(ccp(bgSize.width / 2, bgSize.height / 2 + 15))
  self.ui.image_bg:runAction(CCSequence:create(ccArrayMake(CCDelayTime:create(2), CCCallFunc:create(function()
    local gradeCfg = ed.getDataTable("KingsGrade")[self.afterGrade]
    ed.setLabelString(self.ui.label_name, gradeCfg.Name)
    ed.setTexture(self.ui.image_rank_icon, gradeCfg.Icon, true)
  end))))
end

function class:initLabels()
  ed.setLabelFontName(self.ui.label_name, ed.fontBold)
  local rankUpTips = ed.ui.gradientLabel.create({
    text = T("\230\174\181\228\189\141\230\143\144\229\141\135"),
    fontSize = 32,
    fontName = ed.fontBold,
    startColor = ed.toccc3(16711272),
    endColor = ed.toccc3(16776383)
  })
  self.ui.image_bg:addChild(rankUpTips.node)
  rankUpTips.node:setPosition(self.ui.panel_title_pos:getPosition())
end

function class:addTouchEvent()
  self:btRegisterHandler({
    handler = function(event, x, y)
      if event == "ended" then
        self:destroy()
      end
    end,
    key = "close"
  })
end
