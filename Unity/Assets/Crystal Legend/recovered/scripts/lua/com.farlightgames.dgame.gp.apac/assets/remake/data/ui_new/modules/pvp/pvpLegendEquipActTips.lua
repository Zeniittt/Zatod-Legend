local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.pvpLegendEquipActTips = class
ed.UITool.registViewOpenFunc("pvpLegendEquipActTips", function(param)
  local window = ed.ui.pvpLegendEquipActTips.create(param)
  window:popWindow()
  return window
end)

function class.create(param)
  local self = base.create("pvpLegendEquipActTips", {noShade = true})
  setmetatable(self, class.mt)
  self:init(param)
  return self
end

function class:init(param)
  self.legendEquipId = param.legendEquipId or 1
  self:initView()
  self:addTouchEvent()
  self:addEventListen()
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.arena_legend_equip_activity_tips)
  self.container:addChild(container)
  self.ui = ui
  self:initLabels()
  self:adaptUI()
  local legendEquipIcon = ed.readequip.createLegendEquipIcon({
    _type_id = self.legendEquipId,
    _star = 5
  })
  self.ui.image_tattoo:addChild(legendEquipIcon)
  ed.layout.centerInParent(legendEquipIcon)
end

function class:initLabels()
  local panelSize = self.ui.panel_desc:getContentSize()
  local autoText = ed.ui.autoText.new()
  local legendEquipName = ed.getDataTable("LegendEquip")[self.legendEquipId]["Equip Name"]
  autoText:initParam({
    context = string.format(T("\230\180\187\229\138\168\230\156\159\233\151\180\229\134\133\239\188\140\232\139\177\233\155\132\230\137\128\231\169\191\231\154\132<lable color=ccc3(232,177,82)>\226\128\156%s\226\128\157</lable>\229\176\134\229\156\168\231\142\169\230\179\149\229\134\133\228\184\180\230\151\182\230\143\144\229\141\135\232\135\179<lable color=ccc3(232,177,82)>5\230\152\159</lable>"), legendEquipName),
    color = ed.toccc3(16776423),
    maxWidth = panelSize.width,
    fontSize = 18
  })
  self.ui.panel_desc:addChild(autoText.node)
  autoText.node:setPosition(0, panelSize.height - 9)
end

function class:adaptUI()
  local titleSize = self.ui.label_title:getContentSize()
  local titlePositionX = self.ui.label_title:getPositionX()
  self.ui.image_title_left:setPositionX(titlePositionX - titleSize.width / 2 - 15)
  self.ui.image_title_right:setPositionX(titlePositionX + titleSize.width / 2 + 15)
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

function class:addEventListen()
end
