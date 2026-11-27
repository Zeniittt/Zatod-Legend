local base = ed.ui.popwindow
local SoloChooseFactionWin = newclass(base.mt)
ed.ui.SoloChooseFactionWin = SoloChooseFactionWin

function SoloChooseFactionWin:initUI()
  ed.editorui(ed.uieditor.SoloChooseFactionWin, {
    container = self.container,
    ui = self.ui
  })
  self.ui.bg:setScale(1.2)
  ed.setLabelFontName(self.ui.label_title, ed.fontBold)
  ed.setLabelStroke(self.ui.label_title, ccc3(45, 33, 25), 1)
  ed.setLabelFontName(self.ui.Label_12527, ed.fontBold)
  ed.setLabelStroke(self.ui.Label_12527, ccc3(45, 33, 25), 2)
  local factions = {}
  for factionId, faction in pairs(ed.SoloModel.factions or {}) do
    table.insert(factions, factionId)
  end
  table.sort(factions)
  self.factions = factions
  self.selectIdx = nil
  for i = 1, 8 do
    ed.setLabelStroke(self.ui["name" .. i], ccc3(18, 16, 16), 1)
    ed.setString(self.ui["name" .. i], ed.getDataTable("SoloCardTag")[factions[i]].Name)
    ed.setTexture(self.ui["icon" .. i], ed.getDataTable("SoloCardTag")[factions[i]]["Tag2 Icon"])
  end
end

function SoloChooseFactionWin:registerEvents()
  self:btRegisterOutClick({
    area = self.ui.bg,
    clickHandler = function()
      self:destroy()
    end,
    priority = -1
  })
  for i = 1, 8 do
    ed.UITool.registerBtn(self, "faction" .. i, function()
      self.selectIdx = self.factions[i]
      self.ui.btn_ok:setVisible(true)
      self.ui.icon_selected:setVisible(true)
      self.ui.icon_selected:setPositionY(self.ui["faction" .. i]:getPositionY())
    end)
  end
  ed.UITool.registerBtn(self, "btn_ok", function()
    if not self.selectIdx then
      return
    end
    ed.SoloNetwork:sendUseHeroPower(self.power._id, self.power._pos, {
      {
        _type = "specify_faction",
        _int_values = {
          self.selectIdx
        }
      }
    })
    self:destroy()
  end)
  self:listenEvent("EventCloseOtherWin", function()
    base.destroy(self, {skipAnim = true})
  end)
end

function SoloChooseFactionWin:destroy()
  base.destroy(self, {skipAnim = true})
end

function SoloChooseFactionWin:initData(params)
  self.power = params.power
end

function SoloChooseFactionWin.create(params)
  local self = base.create("SoloChooseFactionWin", {
    notBlurBg = true,
    noShade = true,
    priority = -999,
    swallow = true
  })
  setmetatable(self, SoloChooseFactionWin.mt)
  self:initData(params)
  self:initUI()
  self:registerEvents()
  return self
end
