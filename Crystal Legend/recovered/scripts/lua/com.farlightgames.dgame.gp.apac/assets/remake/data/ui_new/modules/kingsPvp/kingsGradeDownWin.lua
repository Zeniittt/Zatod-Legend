local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.kingsGradeDownWin = class
ed.UITool.registViewOpenFunc("kingsGradeDownWin", function(param)
  ed.ui.kingsGradeDownWin.create(param):popWindow()
end)

function class.create(param)
  local self = base.create("kingsGradeDownWin", {layer_opacity = 204})
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
  local container, ui = ed.editorui(ed.uieditor.kingsRankDownWin)
  self.container:addChild(container)
  self.ui = ui
  self:initLabels()
  local gradeCfg = ed.getDataTable("KingsGrade")[self.beforeGrade]
  ed.setLabelString(self.ui.label_name, gradeCfg.Name)
  ed.setTexture(self.ui.image_rank_icon, gradeCfg.Icon, true)
  self:initEffect()
end

function class:initEffect()
  local delay1 = CCDelayTime:create(0.7)
  local callFunc1 = CCCallFunc:create(function()
    local eff = ed.createFcaNode("eff_UI_kingspvp_rank_down")
    self:addFca(eff)
    self.ui.image_bg:addChild(eff)
    local bgSize = self.ui.image_bg:getContentSize()
    eff:setPosition(ccp(bgSize.width / 2, bgSize.height / 2 + 15))
  end)
  local delay2 = CCDelayTime:create(0)
  local callFunc2 = CCCallFunc:create(function()
    local gradeCfg = ed.getDataTable("KingsGrade")[self.afterGrade]
    ed.setLabelString(self.ui.label_name, gradeCfg.Name)
    ed.setTexture(self.ui.image_rank_icon, gradeCfg.Icon, true)
  end)
  self.ui.image_bg:runAction(CCSequence:create(ccArrayMake(delay1, callFunc1, delay2, callFunc2)))
end

function class:initLabels()
  ed.setLabelFontName(self.ui.label_name, ed.fontBold)
  local rankDownTips = ed.ui.gradientLabel.create({
    text = T("\230\174\181\228\189\141\228\184\139\233\153\141"),
    fontSize = 32,
    fontName = ed.fontBold,
    startColor = ed.toccc3(11184852),
    endColor = ed.toccc3(16777215)
  })
  self.ui.image_bg:addChild(rankDownTips.node)
  rankDownTips.node:setPosition(self.ui.panel_title_pos:getPosition())
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
