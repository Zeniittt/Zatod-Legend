local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.kingsNewSeasonWin = class
ed.UITool.registViewOpenFunc("kingsNewSeasonWin", function(param)
  ed.ui.kingsNewSeasonWin.create(param):popWindow()
end)

function class.create(param)
  local self = base.create("kingsNewSeasonWin")
  setmetatable(self, class.mt)
  self:init(param)
  return self
end

function class:init(param)
  param = param or {}
  self.step = 1
  self:initUI()
  self:addTouchEvent()
  self:show()
end

function class:initUI()
  local container, ui = ed.editorui(ed.uieditor.kingsNewSeasonWindow, {layer_opacity = 204})
  self.container:addChild(container)
  self.ui = ui
  self:initLabels()
end

function class:initLabels()
  ed.setLabelFontName(self.ui.label_rank_name_1, ed.fontBold)
  ed.setLabelFontName(self.ui.label_rank_name_2, ed.fontBold)
  local newSeasonTips = ed.ui.gradientLabel.create({
    text = string.format("\229\133\168\230\150\176\232\181\155\229\173\163S%d\229\188\128\229\144\175", 2),
    fontSize = 36,
    fontName = ed.fontBold,
    startColor = ed.toccc3(16711272),
    endColor = ed.toccc3(16776383)
  })
  self.ui.image_new_season_bg1:addChild(newSeasonTips.node)
  newSeasonTips.node:setPosition(self.ui.panel_new_season_tips:getPosition())
end

function class:runNewSeasonAction()
  self.ui.image_new_season_bg1:setVisible(false)
  self.ui.image_new_season_bg2:setVisible(true)
end

function class:onClickContinue()
  if self.step == 1 then
    self:runNewSeasonAction()
  else
    self:destroy()
  end
  self.step = self.step + 1
end

function class:addTouchEvent()
  self:btRegisterHandler({
    handler = function(event, x, y)
      if event == "ended" then
        self:onClickContinue()
      end
    end,
    key = "close"
  })
end
