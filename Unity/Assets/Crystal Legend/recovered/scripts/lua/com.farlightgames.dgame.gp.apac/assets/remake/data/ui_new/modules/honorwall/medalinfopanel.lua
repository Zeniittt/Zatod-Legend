MedalInfoPanel = {}
MedalInfoPanel.__index = MedalInfoPanel
local base = ed.ui.popwindow
setmetatable(MedalInfoPanel, base.mt)

function MedalInfoPanel.create(medalId)
  local panel = base.create("medalInfoPanel")
  setmetatable(panel, MedalInfoPanel)
  panel.medalId = medalId
  panel:initData()
  panel:initAppearance()
  panel:registerTouchHandler()
  return panel
end

function MedalInfoPanel:initData()
end

function MedalInfoPanel:initAppearance()
  local container, ui = ed.editorui(ed.uieditor.medal_info_panel)
  self.mainLayer:addChild(container)
  self.container = container
  self.ui = ui
  local newWid = ed.display.halfFixedWidth
  local newHei = ed.display.halfFixedHeight
  container:setPosition(newWid, newHei)
  local path = ed.lookupDataTable("Medal", "Picture", tonumber(self.medalId))
  local icon = ed.createSprite(path)
  icon:setScale(0.5)
  ui.node_medal:addChild(icon)
  local name = ed.lookupDataTable("Medal", "Name", tonumber(self.medalId))
  local desc = ed.lookupDataTable("Medal", "Description", tonumber(self.medalId))
  ui.label_desc:setDimensions(CCSizeMake(293, 0))
  ed.setString(ui.label_name, name)
  ed.setString(ui.label_desc, desc)
end

function MedalInfoPanel:registerTouchHandler()
  self:btRegisterOutClick({
    area = self.ui.image_bg,
    key = "btn_destroy",
    clickHandler = function()
      self:destroy()
    end,
    priority = 1
  })
end
