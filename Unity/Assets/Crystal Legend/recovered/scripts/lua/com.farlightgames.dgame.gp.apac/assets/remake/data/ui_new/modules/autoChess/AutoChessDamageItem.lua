module("ed.ui", package.seeall)
AutoChessDamageItem = {}
AutoChessDamageItem.__index = AutoChessDamageItem
local MAX_DAMAGE = {
  500,
  1000,
  2000,
  3000,
  5000,
  6000,
  8000,
  10000,
  15000,
  20000,
  30000,
  40000,
  50000,
  60000,
  70000,
  80000,
  100000,
  120000,
  160000,
  200000
}
local RankMap = {
  price_1 = 1,
  price_2 = 2,
  price_3 = 4,
  price_4 = 7,
  price_5 = 12
}

function AutoChessDamageItem.create(data)
  local object = {}
  setmetatable(object, AutoChessDamageItem)
  object:initData(data)
  object:initUI()
  return object
end

function AutoChessDamageItem:getLimitDamage(damage)
  for _, limit in ipairs(MAX_DAMAGE) do
    if damage <= limit then
      return limit
    end
  end
  return MAX_DAMAGE[#MAX_DAMAGE]
end

function AutoChessDamageItem:initData(data)
  self.damageData = data
end

function AutoChessDamageItem:initUI()
  local uiRes = ed.uieditor.AutoChessDamageItem
  local container, ui = ed.editorui(uiRes, {
    container = CCSprite:create()
  })
  self.container = container
  self.ui = ui
  local bgSize = self.ui.bg:getContentSize()
  self.container:setContentSize(bgSize)
  self.container:setAnchorPoint(ccp(0, 0))
  self:initLabelStroke()
  self:initHeadIcon()
  self:updateIcon()
end

function AutoChessDamageItem:getRootNode(...)
  return self.container
end

function AutoChessDamageItem:initLabelStroke(...)
  ed.setLabelStroke(self.ui.label_damage, ccc3(20, 18, 18), 1)
end

function AutoChessDamageItem:initHeadIcon()
  local unit = self.damageData.unit
  local unitInfo = ed.getDataTable("ChessUnit")[unit.tid]
  local heroId = unitInfo["Hero ID"]
  local price = ed.getChessUnitBuyPrice(heroId)
  local param = {
    id = unit.tid
  }
  local heroIcon = ed.readhero.createChessIcon(param)
  heroIcon.icon:setScale(0.4)
  ed.UITool.replaceUI(self.ui, "bg", "node_icon", heroIcon.icon)
end

function AutoChessDamageItem:updateIcon()
  self:updateDamage()
  self:updateStar()
end

function AutoChessDamageItem:updateDamage(damage, maxDamage)
  local curDamage = damage or self.damageData.damage
  ed.setString(self.ui.label_damage, curDamage)
  local limitDamage = self:getLimitDamage(maxDamage or 0)
  local progress = math.min(curDamage / limitDamage, 1)
  self.ui.img_bar_red:setScaleX(progress)
end

function AutoChessDamageItem:updateStar()
  local unit = self.damageData.unit
  local star = unit.rank
  local param = {
    id = unit.tid
  }
  local heroIcon = ed.readhero.createChessIcon(param)
  heroIcon.icon:setScale(0.4)
  ed.UITool.replaceUI(self.ui, "bg", "node_icon", heroIcon.icon)
end
