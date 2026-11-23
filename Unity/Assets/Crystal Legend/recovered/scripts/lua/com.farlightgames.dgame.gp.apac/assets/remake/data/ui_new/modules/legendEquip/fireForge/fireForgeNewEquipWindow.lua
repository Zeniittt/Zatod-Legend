local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.fireForgeNewEquipWindow = class
ed.UITool.registViewOpenFunc("fireForgeNewEquipWindow", function()
  local window = ed.ui.fireForgeNewEquipWindow.create()
  window:popWindow()
  window:show()
end)

function class.create()
  local self = base.create("fireForgeNewEquipWindow")
  setmetatable(self, class.mt)
  self:init()
  return self
end

function class:init()
  self.mgr = ed.legendEquipMgr.getInstance()
  self:initView()
  self:addTouchEvent()
  self:addEventListen()
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.fire_forge_new_equip_window)
  self.container:addChild(container)
  self.ui = ui
  self:initLabels()
  self:refreshLegendEquipIcon()
end

function class:initLabels()
  ed.setLabelShadow(self.ui.label_title, ccc3(0, 0, 0), ccp(0, 1.5))
  ed.setLabelStroke(self.ui.label_desc, ccc3(0, 0, 0), 1)
  local labelCancel = ed.ui.gradientLabel.create({
    text = T("\229\143\150\230\182\136"),
    fontSize = 20,
    startColor = ed.toccc3(16770735),
    endColor = ed.toccc3(16316121),
    strokeSize = 1,
    strokeColor = ed.toccc3(8931382)
  })
  self.ui.btn_cancel:addChild(labelCancel.node)
  ed.layout.centerInParent(labelCancel.node)
  local labelConfirm = ed.ui.gradientLabel.create({
    text = self.rightText or T("\229\137\141\229\190\128\232\174\190\231\189\174"),
    fontSize = 20,
    startColor = ed.toccc3(16775087),
    endColor = ed.toccc3(16776946),
    strokeSize = 1,
    strokeColor = ed.toccc3(10572575)
  })
  self.ui.btn_confirm:addChild(labelConfirm.node)
  ed.layout.centerInParent(labelConfirm.node)
end

function class:refreshLegendEquipIcon()
  local legendEquipTypeIdList = self.mgr:getNewLegendEquipTypeList()
  local panelSize = self.ui.panel_equip_icon:getContentSize()
  local iconList = {}
  local gapList = {}
  for index, typeId in ipairs(legendEquipTypeIdList) do
    local icon = self:createLegendEquip(typeId)
    table.insert(iconList, icon)
    table.insert(gapList, 30)
    self.ui.panel_equip_icon:addChild(icon)
    icon:setPositionY(panelSize.height / 2 + 5)
  end
  ed.layout.horizontalSortNode(iconList, gapList, panelSize.width / 2)
end

function class:createLegendEquip(typeId)
  local legendEquipCfg = ed.getDataTable("LegendEquip")[typeId]
  local icon = ed.readequip.createBasicLegendEquipIcon(typeId)
  icon:setScale(0.8)
  local labelName = ed.createLabelTTF(legendEquipCfg["Equip Name"], 20)
  icon:addChild(labelName)
  labelName:setColor(ed.toccc3(16775789))
  labelName:setStroke(ed.toccc3(2232069), 1)
  labelName:setPosition(ccp(45, -10))
  return icon
end

function class:onClickBtnCancel()
  self:destroy()
end

function class:onClickBtnConfirm()
  self:destroy({skipAnim = true})
  ed.UITool.openView("fireForgeWishWindow")
end

function class:addTouchEvent()
  ed.UITool.registerBtn(self, "btn_cancel", function()
    self:onClickBtnCancel()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_confirm", function()
    self:onClickBtnConfirm()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_close", function()
    self:destroy()
  end, {pressScale = 0.95})
end

function class:addEventListen()
end
