local base = ed.ui.popwindow
local class = {}
class.__index = class
setmetatable(class, base.mt)
ed.ui.dragonBoatUpLevelPop = class
class.boatUIConfig = {
  [1] = {
    beforeBoatRes = "UI/alpha/1080P/dragonboat/db_race/before_upgrade_boat first.png",
    afterBoatRes = "UI/alpha/1080P/dragonboat/db_race/after_upgrade_boat second.png",
    beforePos = ccp(140, 220),
    afterPos = ccp(410, 210)
  },
  [2] = {
    beforeBoatRes = "UI/alpha/1080P/dragonboat/db_race/before_upgrade_boat second.png",
    afterBoatRes = "UI/alpha/1080P/dragonboat/db_race/after_upgrade_boat third.png",
    beforePos = ccp(140, 220),
    afterPos = ccp(410, 210)
  }
}

function class.create(params)
  local self = base.create("dragonBoatUpLevelPop", {notBlurBg = true})
  setmetatable(self, class)
  self:init(params)
  return self
end

function class:init(params)
  self:initData(params)
  self:initUI()
  self:registerEvents()
end

function class:initData(params)
  self.mgr = ed.dragonBoatMgr.getInstance()
  self.boatLevel = params.boatLevel
  self.cfg = params.cfg
  self.btnTxt = params.btnTxt
  self.isDiamond = params.isDiamond
  self.callback = params.callback
end

function class:initUI()
  local container, ui = ed.editorui(ed.uieditor.dragonBoatUpLevelPop)
  self.container:addChild(container)
  self.ui = ui
  self:initBoat()
  self:initLabel()
end

function class:initBoat()
  local function createBoat(cfg, parent, pos, boatRes, color)
    local skinTbl = ed.getDataTable("DragonBoatSkin")[cfg.upgrade]
    
    local boat = ed.createSpriteTools({
      res = boatRes,
      parent = parent,
      pos = pos
    })
    local name = ed.ui.gradientLabel.create({
      text = skinTbl.BoatName,
      fontSize = 27,
      fontName = ed.fontBold,
      startColor = cfg.nameColor1,
      endColor = cfg.nameColor2,
      strokeSize = 4,
      strokeColor = ed.toccc3(16774095)
    })
    name.node:setPosition(pos.x, 135)
    parent:addChild(name.node)
    ed.createLabelTools({
      txt = T("%d \232\136\170\233\128\159 / \230\151\182", skinTbl.Speed),
      size = 21,
      pos = ccp(pos.x, 100),
      color = color,
      parent = parent,
      stroke = {
        ccc3(ed.colorToStr("#011303")),
        1.3
      }
    })
  end
  
  local boatCfg = self.boatUIConfig[self.boatLevel]
  if boatCfg then
    createBoat(self.cfg["upgrade" .. self.boatLevel], self.ui.ImageView_2730, boatCfg.beforePos, boatCfg.beforeBoatRes, ed.toccc3(16776423))
    createBoat(self.cfg["upgrade" .. self.boatLevel + 1], self.ui.ImageView_2730, boatCfg.afterPos, boatCfg.afterBoatRes, ed.toccc3(16768879))
  end
end

function class:initLabel()
  ed.setLabelStroke(self.ui.Label_2733, ed.toccc3(70403), 1.5)
  if self.isDiamond then
    ed.createSpriteTools({
      res = "UI/alpha/1080P/icon/diamond.png",
      parent = self.ui.ImageView_2735,
      pos = ccp(22, 28)
    })
    self.btnTxt = "  " .. self.btnTxt
  end
  local btn_label = ed.ui.gradientLabel.create({
    text = self.btnTxt,
    fontSize = 22,
    startColor = ed.toccc3(16775901),
    endColor = ed.toccc3(16774308),
    strokeSize = 1,
    strokeColor = ed.toccc3(11748623)
  })
  local btn_node = btn_label.node
  self.ui.ImageView_2735:addChild(btn_node)
  ed.layout.centerInParent(btn_node)
end

function class:registerEvents()
  ed.UITool.registerBtn(self, "close", function()
    self:destroy()
  end, {pressScale = 0.95, normalScale = 1})
  self:btRegisterOutClick({
    area = {
      self.ui.ImageView_2730,
      self.ui.close
    },
    key = "bj_close",
    clickHandler = function()
      self:destroy({skipAnim = false})
    end
  })
  ed.UITool.registerBtn(self, "ImageView_2735", function()
    self:destroy()
    self.callback()
  end, {pressScale = 0.95, normalScale = 1})
end
