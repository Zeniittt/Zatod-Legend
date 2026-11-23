local base = ed.ui.popwindow
local heroDetailEvolveWin = {}
heroDetailEvolveWin.__index = heroDetailEvolveWin
setmetatable(heroDetailEvolveWin, base.mt)
ed.ui.heroDetailEvolveWin = heroDetailEvolveWin
local res = ed.heroDetailManager.resConfig

function heroDetailEvolveWin.create(param)
  local self = base.create("heroDetailEvolveWin")
  setmetatable(self, heroDetailEvolveWin)
  self:initData(param)
  self:initUI()
  self:registerTouchHandlers()
  self:popWindow(500)
  self:show()
  return self
end

function heroDetailEvolveWin:initData(param)
  self.hero = param.hero
  self.hid = self.hero._tid
  self.stars = self.hero._stars
  self.callback = param.callback
end

function heroDetailEvolveWin:initLabels()
  ed.setLabelShadow(self.ui.label_cancle, ed.toccc3(0), ccp(1, 0))
  ed.setLabelShadow(self.ui.label_ok, ed.toccc3(0), ccp(1, 0))
  ed.setLabelShadow(self.ui.title, ed.toccc3(0), ccp(1, 0))
end

function heroDetailEvolveWin:initUI()
  local container = self.container
  local ui = {}
  self.ui = ui
  local readnode = ed.readnode.create(container, ui)
  readnode:addNode(ed.uieditor.heroEvolveWin)
  self:initLabels()
  ed.left2(self.ui.ImageView_2453, self.ui.title, 5)
  ed.right2(self.ui.ImageView_2454, self.ui.title, 5)
  local preHead = ed.readhero.createIconByID(self.hid, {state = "idle"}).icon
  local x, y = self.ui.icon1:getPosition()
  self.ui.icon1:setVisible(false)
  preHead:setPosition(ccp(x, y))
  ui.bg_heroicon:addChild(preHead, 1)
  local head = ed.readhero.createIconByID(self.hid, {addStar = 1}).icon
  x, y = self.ui.icon2:getPosition()
  head:setPosition(ccp(x, y))
  ui.bg_heroicon:addChild(head, 1)
  self.ui.icon2:setVisible(false)
  local oldGrowth = ed.readhero.getGrowthByHero(self.hero)
  local newGrowth = ed.readhero.getGrowthByHero(self.hero, self.stars + 1)
  local oldGrowthRatio = ed.readhero.getGrowthRatioByHero(self.hero)
  local newGrowthRatio = ed.readhero.getGrowthRatioByHero(self.hero, {
    _stars = self.stars + 1
  })
  local oldSTRGrowth = oldGrowth.STR * (oldGrowthRatio["+STR%"] / 100 + 1)
  local oldINTGrowth = oldGrowth.INT * (oldGrowthRatio["+INT%"] / 100 + 1)
  local oldAGIGrowth = oldGrowth.AGI * (oldGrowthRatio["+AGI%"] / 100 + 1)
  local newSTRGrowth = newGrowth.STR * (newGrowthRatio["+STR%"] / 100 + 1)
  local newINTGrowth = newGrowth.INT * (newGrowthRatio["+INT%"] / 100 + 1)
  local newAGIGrowth = newGrowth.AGI * (newGrowthRatio["+AGI%"] / 100 + 1)
  ed.setString(self.ui.from1, string.format("%.2f", oldSTRGrowth))
  ed.setString(self.ui.from2, string.format("%.2f", oldINTGrowth))
  ed.setString(self.ui.from3, string.format("%.2f", oldAGIGrowth))
  ed.setString(self.ui.to1, string.format("%.2f", newSTRGrowth))
  ed.setString(self.ui.to2, string.format("%.2f", newINTGrowth))
  ed.setString(self.ui.to3, string.format("%.2f", newAGIGrowth))
  local money = ed.getDataTable("HeroStars")[self.stars + 1]["Upgrade Price"]
  local autoText = ed.ui.autoText.new()
  local text = string.format(T("<lable color=ccc3(255,252,231)>\230\152\175\229\144\166\230\182\136\232\128\151</lable><lable color=ccc3(255,163,49)>%d</lable>") .. T("<lable color=ccc3(255,252,231)>\233\135\145\229\184\129\228\184\186%s\230\143\144\229\141\135\230\152\159\231\186\167\239\188\159</lable>"), money, ed.getDataTable("Unit")[self.hid]["Display Name"])
  autoText:initParam({
    context = text,
    fontSize = 16,
    maxWidth = 800
  })
  autoText:limitWidthByScale(500)
  local atWid, _ = autoText:getCurContentSize()
  autoText.node:setPosition(ccp((ui.bg:getContentSize().width - atWid * autoText.node:getScale()) * 0.5, 310))
  ui.desc:setVisible(false)
  ui.bg:addChild(autoText.node, 1)
  local desMinWidth = self.ui.from1:getPositionX() - self.ui.from1:getContentSize().width * 0.5 - self.ui.attrname1:getPositionX() - 5
  desMinWidth = math.min(desMinWidth, self.ui.from2:getPositionX() - self.ui.from2:getContentSize().width * 0.5 - self.ui.attrname2:getPositionX() - 5)
  desMinWidth = math.min(desMinWidth, self.ui.from3:getPositionX() - self.ui.from3:getContentSize().width * 0.5 - self.ui.attrname3:getPositionX() - 5)
  local minScale = math.min(1, desMinWidth / self.ui.attrname1:getContentSize().width)
  minScale = math.min(minScale, desMinWidth / self.ui.attrname2:getContentSize().width)
  minScale = math.min(minScale, desMinWidth / self.ui.attrname3:getContentSize().width)
  self.ui.attrname1:setScale(minScale)
  self.ui.attrname2:setScale(minScale)
  self.ui.attrname3:setScale(minScale)
end

function heroDetailEvolveWin:registerTouchHandlers()
  ed.UITool.registerBtn(self, "btn_cancle", function()
    self:destroy()
  end, {pressScale = 0.9})
  ed.UITool.registerBtn(self, "btn_ok", function()
    self.callback()
    self:destroy()
  end, {pressScale = 0.9})
end

function heroDetailEvolveWin:popWindow(zOrder)
  base.popWindow(self, zOrder)
end

function heroDetailEvolveWin:destroy()
  base.destroy(self, {skipAnim = true})
end
