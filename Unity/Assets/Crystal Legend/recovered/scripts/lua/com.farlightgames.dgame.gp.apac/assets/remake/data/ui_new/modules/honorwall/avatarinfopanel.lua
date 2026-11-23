AvatarInfoPanel = {}
AvatarInfoPanel.__index = AvatarInfoPanel
local base = ed.ui.popwindow
setmetatable(AvatarInfoPanel, base.mt)

function AvatarInfoPanel.create(headId, frameId)
  local panel = base.create("avatarInfoPanel")
  setmetatable(panel, AvatarInfoPanel)
  panel.headId = headId
  panel.frameId = frameId
  panel:initData()
  panel:initAppearance()
  panel:registerTouchHandler()
  return panel
end

function AvatarInfoPanel:initData()
end

function AvatarInfoPanel:initAppearance()
  local container, ui = ed.editorui(ed.uieditor.avatar_info_panel)
  self.mainLayer:addChild(container)
  self.container = container
  self.ui = ui
  local newWid = ed.display.halfFixedWidth
  local newHei = ed.display.halfFixedHeight
  container:setPosition(newWid, newHei)
  local head = ed.getHeadIcon({
    id = self.headId
  })
  ui.node_avatar:addChild(head)
  local frame = ed.getHeadFrame({
    id = self.frameId,
    hide_icon_when_dyna = true
  })
  ui.node_avatar:addChild(frame)
  local avatarName = ed.lookupDataTable("Avatar", "Name", tonumber(self.headId)) or ""
  local frameName = ed.lookupDataTable("AvatarFrame", "Name", tonumber(self.frameId)) or ""
  local avatarDesc = ed.lookupDataTable("Avatar", "Description", tonumber(self.headId)) or ""
  local frameDesc = ed.lookupDataTable("AvatarFrame", "Unlock Description", tonumber(self.frameId)) or ""
  ed.setString(ui.label_avatar_name, avatarName)
  ed.setString(ui.label_frame_name, frameName)
  ui.label_avatar_desc:setDimensions(CCSizeMake(420, 0))
  ui.label_frame_desc:setDimensions(CCSizeMake(420, 0))
  ed.setString(ui.label_avatar_desc, avatarDesc)
  ed.setString(ui.label_frame_desc, frameDesc)
end

function AvatarInfoPanel:registerTouchHandler()
  self:btRegisterOutClick({
    area = self.ui.image_bg,
    key = "btn_destroy",
    clickHandler = function()
      self:destroy()
    end,
    priority = 1
  })
end
