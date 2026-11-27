local base = ed.ui.popwindow
local pirateshopGoodsPop = newclass(base.mt)
ed.ui.pirateshopGoodsPop = pirateshopGoodsPop

function pirateshopGoodsPop.create(param)
  local self = base.create("pirateshopGoodsPop")
  setmetatable(self, pirateshopGoodsPop.mt)
  self:init(param)
  return self
end

function pirateshopGoodsPop:init(param)
  self.param = param
  self:initView(param)
  self:addEventListener()
end

function pirateshopGoodsPop:initView(param)
  local container, ui = ed.editorui(ed.uieditor.pirateshopGoodsPop)
  self.ui = ui
  self.container:addChild(container)
  ed.setLabelStroke(self.ui.Label_name, ed.toccc3(7687475), 2)
  ed.setLabelStroke(self.ui.Label_354, ed.toccc3(16774113), 3)
  self.ui.Label_354:setFontName(ed.fontBold)
  self.ui.Label_2508:setFontName(ed.fontBold)
  local data = param.data
  local icon = ed.createItemIcon({
    id = data.itemID,
    type = "item",
    amount = data.amount
  })
  icon:setPosition(130, 320)
  icon:setScale(0.95)
  self.ui.bg:addChild(icon)
  local name = ed.readequip.value(data.itemID, "Name")
  self.ui.Label_name:setString(name)
  ed.setLabelDimensions(ui.Label_txt, CCSizeMake(400, 0))
  local item = ed.getDataTable("equip")[data.itemID]
  self.ui.Label_txt:setString(item.Description or item.Comment or T("\232\191\153\228\187\182\232\163\133\229\164\135\228\184\141\230\132\191\230\132\143\230\143\143\232\191\176\232\135\170\229\183\177"))
  self.ui.label_count:setString(ed.player:getEquipAmount(data.itemID))
  local color = ed.player:getPoint(string.lower(data.price_type)) < self.param.price and "ccc3(255,34,27)" or "ccc3(255,241,173)"
  local autoText = ed.ui.autoText.new()
  autoText:initParam({
    context = T("<sprite src=UI/alpha/1080P/icon/%s.png scale=1.4><lable color=%s>%d</lable>", data.price_type, color, param.price),
    fontSize = 21,
    lineSpacing = 4,
    align = "CENTER",
    strokeColor = ed.toccc3(2565412),
    strokeSize = 2
  })
  autoText.node:setPosition(-110, 28.25)
  self.ui.btn_buy:addChild(autoText.node)
  self:createHeroList(param)
  self:show()
end

function pirateshopGoodsPop:addEventListener()
  ed.UITool.registerBtn(self, "btn_close", function()
    self:destroy()
  end, {pressScale = 0.7, normalScale = 0.75})
  ed.UITool.registerBtn(self, "btn_buy", function()
    local data = self.param.data
    if ed.player:getPoint(string.lower(data.price_type)) < self.param.price then
      ed.showToast(T("%s\228\184\141\232\182\179", ed.virtualName[string.lower(data.price_type)]))
      return
    end
    ed.pirateshopNetwork.sendBuyGoods(data.index, self.param.price, data.price_type)
    self:destroy()
  end, {
    pressScale = 0.75,
    normalScale = 0.8,
    clickInterval = 0.8
  })
end

function pirateshopGoodsPop:createHeroList(param)
  local thisCon = self.ui.Panel_hero:getContentSize()
  local info = {
    cliprect = CCRectMake(0, 0, thisCon.width, thisCon.height),
    container = self.ui.Panel_hero,
    noshade = true,
    priority = -300
  }
  self.dragList = ed.draglist.create(info)
  self.heros = ed.pirateshopManager.tidyHeros(param.data.itemID)
  self.refreshCliprectConfig = {
    draglist = self.dragList
  }
  if #self.heros == 0 then
    self.ui.ImageView_2405:setVisible(true)
    self.ui.ImageView_359:setVisible(false)
    self.ui.Label_360:setVisible(false)
    return
  end
  self.dragList:clearList()
  local width, heigh = 90, 70
  local posY = thisCon.height - heigh / 2
  local addx = #self.heros < 6 and (6 - #self.heros) * width / 2 or 0
  for i, v in ipairs(self.heros) do
    local posX = (i % 6 == 0 and 6 or i % 6) * width - width / 2 + addx
    local heroUI = ed.readhero.createIconByID(v, {state = "idle"})
    heroUI.icon:setScale(0.8)
    self.dragList:addItem(heroUI.icon, ccp(posX, posY))
    posY = i % 6 == 0 and posY - heigh or posY
  end
  self.dragList:initListHeight(math.ceil(#self.heros / 6) * heigh + 10)
end
