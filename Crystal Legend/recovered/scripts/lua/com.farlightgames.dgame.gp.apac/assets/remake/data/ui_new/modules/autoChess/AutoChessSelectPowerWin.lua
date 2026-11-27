local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.AutoChessSelectPowerWin = class

function class:initData()
  ed.AutoChessManager.selectPowerWin = self
  self.powerPos = ed.AutoChessModel.selectPowerPos or 1
end

function class:createChessPowerIcon(key)
  local powerInfo = ed.getDataTable("ChessHeroPower")[key]
  local icon = ed.createClippingNodeEx(powerInfo.Icon, "UI/alpha/1080P/chess/heropower/heropower_bg.png", nil, CCSizeMake(0, 0), {})
  local frame = ed.createSprite("UI/alpha/1080P/chess/heropower/frame_2.png")
  icon:setScale(1.52)
  frame:addChild(icon, -1)
  ed.layout.centerInParent(icon)
  return frame
end

function class:initUI()
  ed.editorui(ed.uieditor.AutoChessSelectWin, {
    container = self.container,
    ui = self.ui
  })
  local text = ed.ui.gradientLabel.create({
    text = "\233\128\137\230\139\169\228\184\128\228\184\170\232\139\177\233\155\132\229\138\169\229\138\155",
    fontSize = 30,
    fontName = ed.fontBold,
    startColor = ed.toccc3(16776423),
    endColor = ed.toccc3(16773540),
    strokeSize = 2.5,
    strokeColor = ed.toccc3(8869681)
  })
  ed.UITool.replaceUINew(self.ui, "Label_656", text.node)
  local powerIds = ed.AutoChessModel.selectPowerIds or {
    1,
    2,
    3
  }
  for i = 1, 3 do
    if powerIds[i] then
      local powerInfo = ed.getDataTable("ChessHeroPower")[powerIds[i]]
      local icon = self:createChessPowerIcon(powerIds[i])
      ed.UITool.replaceUINew(self.ui, "icon" .. i, icon)
      ed.setString(self.ui["name" .. i], powerInfo["HeroPower Name"])
      local text = ed.ui.gradientLabel.create({
        text = powerInfo["HeroPower Name"],
        fontSize = 24,
        fontName = ed.fontBold,
        startColor = ed.toccc3(16774069),
        endColor = ed.toccc3(16766830),
        strokeSize = 1.5,
        strokeColor = ed.toccc3(3152392)
      })
      ed.UITool.replaceUINew(self.ui, "name" .. i, text.node)
      ed.setLabelDimensions(self.ui["desc" .. i], CCSizeMake(160, 0))
      ed.setString(self.ui["desc" .. i], powerInfo.Description)
    else
      self.ui["card" .. i]:setVisible(false)
    end
  end
end

function class:registerEvents()
  ed.UITool.registerBtn(self, "btn_hide", function()
    self:destroy({skipAnim = true})
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "card1", function()
    ed.AutoChessNetwork:sendChooseHeroPower(self.powerPos, 1)
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "card2", function()
    ed.AutoChessNetwork:sendChooseHeroPower(self.powerPos, 2)
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "card3", function()
    ed.AutoChessNetwork:sendChooseHeroPower(self.powerPos, 3)
  end, {pressScale = 0.95})
  self:listenEvent("AutoChessSelectPowerSuccess", function()
    self:destroy({skipAnim = true})
  end)
  self:listenEvent("EventCloseOtherWin", function()
    self:destroy({skipAnim = true})
  end)
end

function class:destroy()
  ed.AutoChessManager.selectPowerWin = nil
  base.destroy(self, {})
end

function class.create()
  local self = base.create("AutoChessSelectPowerWin")
  setmetatable(self, class.mt)
  self:initData()
  self:initUI()
  self:registerEvents()
  self:popWindow()
  return self
end
