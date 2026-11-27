local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.kingsBuffTipsWindow = class

function class.create()
  local self = base.create("kingsBuffTipsWindow", {noShade = true})
  setmetatable(self, class.mt)
  self:init()
  return self
end

function class:init()
  self:initView()
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.kingsMainSceneBuffTips)
  self.container:addChild(container)
  self.ui = ui
  self:initLabels()
  self:initDesc()
  self:addTouchEvent()
end

function class:initLabels()
end

function class:initDesc()
  local panelSize = self.ui.panel_buff_desc:getContentSize()
  local autoText = ed.ui.autoText.new()
  autoText:initParam({
    context = T("\230\180\187\229\138\168\230\156\159\233\151\180\229\134\133\239\188\140\232\139\177\233\155\132\230\137\128\231\169\191\228\188\160\229\165\135\232\163\133\229\164\135\231\148\159\230\149\136\239\188\140\228\184\148\228\188\154\232\162\171\228\184\180\230\151\182\230\143\144\229\141\135\232\135\179<lable color=ccc3(255,191,18)>5\230\152\159</lable>"),
    fontSize = 15,
    maxWidth = panelSize.width,
    color = ccc3(255, 252, 231),
    strokeColor = ed.toccc3(2369048),
    strokeSize = 1
  })
  self.ui.panel_buff_desc:addChild(autoText.node)
  autoText.node:setPosition(ccp(0, panelSize.height - 7.5))
end

function class:addTouchEvent()
  self:btRegisterOutClick({
    area = self.ui.image_bg,
    key = "clickOut",
    clickHandler = function()
      self:destroy({skipAnim = true})
    end,
    force = true
  })
end
