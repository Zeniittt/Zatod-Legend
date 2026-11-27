local base = ed.ui.popwindow
local buyExteriorShopBox = newclass(base.mt)
ed.ui.buyExteriorShopBox = buyExteriorShopBox

local function clickFunc(self, node, click, press, normal, key)
  self:btRegisterButtonClick({
    button = node,
    key = key,
    clickHandler = click,
    force = true,
    pressScale = press or 0.9,
    normalScale = normal or 1,
    clickInterval = 0.2
  })
end

function buyExteriorShopBox.create(params)
  local self = base.create("buyExteriorShopBox", {notBlurBg = true})
  setmetatable(self, buyExteriorShopBox.mt)
  self.params = params
  self:initUieditor()
  self:registEvents()
  return self
end

function buyExteriorShopBox:initUieditor()
  local container, ui = ed.editorui(ed.uieditor.buyExteriorShopBox)
  self.container:addChild(container)
  ui.line:getParent():setScale(0.5)
  ui.line:setScaleX(-1)
  self.ui = ui
  local oIcon = ed.createSpriteTools({
    res = "UI/alpha/1080P/shop/cosmetic/shop_cosmetic_currency_orange.png",
    pos = ccp(77, 28),
    parent = ui.btn_buy_orange,
    scale = 1.2
  })
  local oPrice = ed.createLabelTools({
    txt = self.params["Orange Price"],
    size = 24,
    anchor = ccp(0, 0.5),
    pos = ccp(96, 28),
    color = ccc3(ed.colorToStr("#FCF1A5")),
    shadow = {
      ccc3(69, 46, 29),
      ccp(0, 2)
    },
    parent = ui.btn_buy_orange
  })
  local bIcon = ed.createSpriteTools({
    res = "UI/alpha/1080P/shop/cosmetic/shop_cosmetic_currency_blue.png",
    pos = ccp(77, 28),
    parent = ui.btn_buy_blue,
    scale = 1.2
  })
  local bPrice = ed.createLabelTools({
    txt = self.params["Blue Price"],
    size = 24,
    anchor = ccp(0, 0.5),
    pos = ccp(94, 28),
    color = ccc3(ed.colorToStr("#FCF1A5")),
    shadow = {
      ccc3(69, 46, 29),
      ccp(0, 2)
    },
    parent = ui.btn_buy_blue
  })
  if 0 < self.params["Orange Price Discount"] then
    oIcon:setPositionX(oIcon:getPositionX() - 20)
    oPrice:setPositionX(oPrice:getPositionX() - 20)
    oPrice:setString(self.params["Orange Price Discount"])
    ed.createLabelTools({
      txt = self.params["Orange Price"],
      size = 22,
      anchor = ccp(0.5, 0.5),
      pos = ccp(130, 28),
      color = ccc3(ed.colorToStr("#B3855E")),
      parent = ui.btn_buy_orange
    })
    ed.createSpriteTools({
      res = "UI/alpha/1080P/shop/shop_line_2.png",
      pos = ccp(130, 28),
      parent = ui.btn_buy_orange,
      scale = 1.1
    })
  end
  if 0 < self.params["Blue Price Discount"] then
    bIcon:setPositionX(bIcon:getPositionX() - 20)
    bPrice:setPositionX(bPrice:getPositionX() - 20)
    bPrice:setString(self.params["Blue Price Discount"])
    ed.createLabelTools({
      txt = self.params["Blue Price"],
      size = 22,
      anchor = ccp(0.5, 0.5),
      pos = ccp(130, 28),
      color = ccc3(ed.colorToStr("#B3855E")),
      parent = ui.btn_buy_blue
    })
    ed.createSpriteTools({
      res = "UI/alpha/1080P/shop/shop_line_2.png",
      pos = ccp(130, 28),
      parent = ui.btn_buy_blue,
      scale = 1.1
    })
  end
  local strPrice = ""
  if self.params["Orange Price"] == 0 then
    ui.btn_buy_blue:setPositionX(479)
    ui.btn_buy_orange:setVisible(false)
    local item = ed.getDataTable("equip")[20270]
    strPrice = item.Name
  elseif self.params["Blue Price"] == 0 then
    ui.btn_buy_orange:setPositionX(479)
    ui.btn_buy_blue:setVisible(false)
    local item = ed.getDataTable("equip")[20269]
    strPrice = item.Name
  else
    local item1 = ed.getDataTable("equip")[20270]
    local item2 = ed.getDataTable("equip")[20269]
    strPrice = T("%s\230\136\150%s", item2.Name, item1.Name)
  end
  strPrice = T("\228\189\191\231\148\168%s\232\180\173\228\185\176", strPrice)
  local item = ed.createItemIcon({
    id = self.params["Reward Item ID"]
  })
  item:setPosition(55, 43)
  ui.conent_bg:addChild(item)
  item:setScale(0.94)
  local strokecolor = ccc3(39, 37, 36)
  ed.setLabelStroke(ui.title_text, strokecolor, 1)
  ed.setLabelStroke(ui.item_name, strokecolor, 1)
  ed.setLabelStroke(ui.cost_value, strokecolor, 1)
  ed.setLabelDimensions(ui.item_desc, CCSizeMake(316.5, 0))
  item = ed.getDataTable("equip")[self.params["Reward Item ID"]]
  self.ui.item_name:setString(item.Name)
  self.ui.item_desc:setString(item.Comment or T("\232\191\153\228\187\182\232\163\133\229\164\135\228\184\141\230\132\191\230\132\143\230\143\143\232\191\176\232\135\170\229\183\177"))
  self.ui.title_text:setString(T("\232\180\173\228\185\176") .. item.Name)
  self.ui.shop_cosmetic_text:setVisible(false)
  self.ui.shop_cosmetic_text_1:setVisible(false)
  ed.createLabelTools({
    txt = strPrice,
    size = 16,
    anchor = ccp(0.5, 0.5),
    pos = ccp(153, 12),
    color = ccc3(95, 79, 68),
    parent = self.ui.shop_cosmetic_text_bg
  })
end

function buyExteriorShopBox:registEvents()
  clickFunc(self, self.ui.btn_close, function()
    ed.playEffect(ed.sound.deo.common_back)
    self:destroy()
  end, 0.7, 0.75, "btn_close")
  clickFunc(self, self.ui.btn_buy_orange, function()
    ed.showConfirmDialog({
      autoText = T("\230\152\175\229\144\166\232\138\177\232\180\185<sprite src=UI/alpha/1080P/shop/cosmetic/shop_cosmetic_currency_orange.png scale=0.9><lable color=ccc3(189,116,0)>%d</lable> \232\180\173\228\185\176%s\239\188\159", self.params["Orange Price Discount"] > 0 and self.params["Orange Price Discount"] or self.params["Orange Price"], self.ui.item_name:getString()),
      rightHandler = function()
        ed.shop_network.cosmeticSendExchange(self.params["Goods ID"], 1)
      end
    })
  end, 0.75, 0.8, "btn_buy_orange")
  clickFunc(self, self.ui.btn_buy_blue, function()
    ed.showConfirmDialog({
      autoText = T("\230\152\175\229\144\166\232\138\177\232\180\185<sprite src=UI/alpha/1080P/shop/cosmetic/shop_cosmetic_currency_blue.png scale=0.9><lable color=ccc3(189,116,0)>%d</lable> \232\180\173\228\185\176%s\239\188\159", self.params["Blue Price Discount"] > 0 and self.params["Blue Price Discount"] or self.params["Blue Price"], self.ui.item_name:getString()),
      rightHandler = function()
        ed.shop_network.cosmeticSendExchange(self.params["Goods ID"], 2)
      end
    })
  end, 0.75, 0.8, "btn_buy_blue")
  self:listenEvent("cosmeticShopReplyShow", function()
    self:destroy()
  end)
end

local buyFashionShopBox = newclass(base.mt)
ed.ui.buyFashionShopBox = buyFashionShopBox

function buyFashionShopBox.create(params)
  local self = base.create("buyFashionShopBox", {notBlurBg = true})
  setmetatable(self, buyFashionShopBox.mt)
  self.params = params
  self:initUieditor()
  self:registEvents()
  return self
end

function buyFashionShopBox:initUieditor()
  local container, ui = ed.editorui(ed.uieditor.buyFashionShopBox)
  self.container:addChild(container)
  container:setPosition(ed.display.winSize.width / 2 - ed.display.halfFixedWidth, ed.display.winSize.height / 2 - ed.display.halfFixedHeight)
  self.ui = ui
  local oIcon = ed.createSpriteTools({
    res = "UI/alpha/1080P/shop/cosmetic/shop_cosmetic_currency_orange.png",
    pos = ccp(70, 28),
    parent = ui.btn_buy_orange,
    scale = 1.2
  })
  local oPrice = ed.createLabelTools({
    txt = self.params["Orange Price"],
    size = 24,
    anchor = ccp(0, 0.5),
    pos = ccp(90, 28),
    color = ccc3(ed.colorToStr("#FCF1A5")),
    shadow = {
      ccc3(69, 46, 29),
      ccp(0, 2)
    },
    parent = ui.btn_buy_orange
  })
  local bIcon = ed.createSpriteTools({
    res = "UI/alpha/1080P/shop/cosmetic/shop_cosmetic_currency_blue.png",
    pos = ccp(70, 28),
    parent = ui.btn_buy_blue,
    scale = 1.2
  })
  local bPrice = ed.createLabelTools({
    txt = self.params["Blue Price"],
    size = 24,
    anchor = ccp(0, 0.5),
    pos = ccp(90, 28),
    color = ccc3(ed.colorToStr("#FCF1A5")),
    shadow = {
      ccc3(69, 46, 29),
      ccp(0, 2)
    },
    parent = ui.btn_buy_blue
  })
  if 0 < self.params["Orange Price Discount"] then
    oIcon:setPositionX(oIcon:getPositionX() - 20)
    oPrice:setPositionX(oPrice:getPositionX() - 20)
    oPrice:setString(self.params["Orange Price Discount"])
    ed.createLabelTools({
      txt = self.params["Orange Price"],
      size = 22,
      anchor = ccp(0.5, 0.5),
      pos = ccp(130, 28),
      color = ccc3(ed.colorToStr("#B3855E")),
      parent = ui.btn_buy_orange
    })
    ed.createSpriteTools({
      res = "UI/alpha/1080P/shop/shop_line_2.png",
      pos = ccp(130, 28),
      parent = ui.btn_buy_orange,
      scale = 1.1
    })
  end
  if 0 < self.params["Blue Price Discount"] then
    bIcon:setPositionX(bIcon:getPositionX() - 20)
    bPrice:setPositionX(bPrice:getPositionX() - 20)
    bPrice:setString(self.params["Blue Price Discount"])
    ed.createLabelTools({
      txt = self.params["Blue Price"],
      size = 22,
      anchor = ccp(0.5, 0.5),
      pos = ccp(130, 28),
      color = ccc3(ed.colorToStr("#B3855E")),
      parent = ui.btn_buy_blue
    })
    ed.createSpriteTools({
      res = "UI/alpha/1080P/shop/shop_line_2.png",
      pos = ccp(130, 28),
      parent = ui.btn_buy_blue,
      scale = 1.1
    })
  end
  local strPrice = ""
  if self.params["Orange Price"] == 0 then
    ui.btn_buy_blue:setPositionX(560)
    ui.btn_buy_orange:setVisible(false)
    local item = ed.getDataTable("equip")[20270]
    strPrice = item.Name
  elseif self.params["Blue Price"] == 0 then
    ui.btn_buy_orange:setPositionX(560)
    ui.btn_buy_blue:setVisible(false)
    local item = ed.getDataTable("equip")[20269]
    strPrice = item.Name
  else
    local item1 = ed.getDataTable("equip")[20270]
    local item2 = ed.getDataTable("equip")[20269]
    strPrice = T("%s\230\136\150%s", item2.Name, item1.Name)
  end
  strPrice = T("\228\189\191\231\148\168%s\232\180\173\228\185\176", strPrice)
  local fashion_id = ed.getDataTable("equip")[self.params["Reward Item ID"]]["Fashion ID"]
  local heroId = ed.lookupDataTable("Fashion", "Hero ID", fashion_id)
  local ress = ed.getFashionFrameRes(fashion_id, "nameFrame")
  if ress then
    ed.setTexture(self.ui.bg_skin_name, ress)
  end
  self.ui.skin_name:setString(ed.lookupDataTable("Fashion", "Name", fashion_id))
  self.hid = heroId
  self.fashion = fashion_id
  local card = ed.readhero.getHeroCard(heroId, {
    hide_star = true,
    starType = "init",
    OriSize = true,
    fashion_id = fashion_id or 0
  }, {
    index = 1,
    _tid = heroId,
    _stars = 2,
    _level = 1,
    _rank = 1,
    _items = {}
  })
  local card_ui = card.container
  card_ui:setScale(0.99)
  card_ui:setZOrder(2)
  self.ui.bg:addChild(card_ui)
  card_ui:setPosition(7, -11)
  self.ui.skin_card = card_ui
  for _, effect_fca in pairs(card.card_fashion_effect or {}) do
    self:addFca(effect_fca)
  end
  for _, plist in pairs(card.fashion_plist_res or {}) do
    self:addFca(plist)
  end
  local puppet, puppet_id, cha = ed.readhero.getActor(heroId, "Idle", true, false, fashion_id, false)
  local row = ed.getDataTable("Puppet")[puppet_id]
  local scale = row.Scale
  local wscale = row["Window Scale"]
  if wscale ~= 0 then
    scale = row.Scale * wscale
  end
  puppet:setScale(scale)
  puppet:setPosition(ccp(self.ui.bg_mid:getContentSize().width / 2, 200))
  self.ui.bg_mid:addChild(puppet, 10)
  self:addFca(puppet)
  self.puppet = puppet
  self.cha = cha
  self.action_pre = "Idle"
  self:btRegisterRectClick({
    rect = CCRectMake(230, 165, 140, 195),
    parent = self.ui.bg_skin,
    key = "skin_touch",
    clickHandler = function()
      self:changeFcaAction(nil, true)
    end,
    force = true
  })
  self.ui.shop_cosmetic_text:setVisible(false)
  self.ui.shop_cosmetic_text_1:setVisible(false)
  ed.createLabelTools({
    txt = strPrice,
    size = 17,
    anchor = ccp(0.5, 0.5),
    pos = ccp(120, 13),
    color = ccc3(253, 234, 196),
    parent = self.ui.shop_cosmetic_text_bg
  })
  if self.params.IsShow then
    self.ui.shop_cosmetic_text_bg:setVisible(false)
    ui.btn_buy_orange:setVisible(false)
    ui.btn_buy_blue:setVisible(false)
  end
end

local lsr = ed.heroDetailManager.listener.create()

function buyFashionShopBox:changeFcaAction(name, with_sound)
  if with_sound == nil then
    with_sound = true
  end
  local action, duration = self:changeAction(name)
  if with_sound then
    lsr:report("clickHeroFca", {
      hid = self.hid,
      action = action,
      fashionId = self.fashion
    })
  end
  self:registerUpdateHandler("checkFcaHandler", self:checkFcaHandler(action, duration))
end

function buyFashionShopBox:checkFcaHandler(action, duration)
  local time = 0
  
  local function handler(dt)
    time = time + dt
    if action ~= "Move" and time > duration then
      self.puppet:setAction("Idle")
      self.puppet:setLoop(true)
      self:removeUpdateHandler("checkFcaHandler")
    end
  end
  
  return handler
end

function buyFashionShopBox:changeAction(name)
  local row = ed.getDataTable("AnimDuration")[self.cha]
  local actions = {}
  local dur = {}
  local skill_items = ed.getDataTable("SkillGroup")[self.hid]
  local can_show_action_tbl = {"Move"}
  for idx, skill_item in pairs(skill_items or {}) do
    for jdx, action in pairs(ed.getDataTable("Skill")[skill_item["Skill Group ID"]][0]["Action(s)"]) do
      if string.find(action, "special") == nil then
        can_show_action_tbl[#can_show_action_tbl + 1] = action
      end
    end
  end
  for k, v in pairs(row or {}) do
    if name then
      if k == name then
        table.insert(actions, k)
        table.insert(dur, v.Duration)
      end
    elseif ed.isElementInTable(k, can_show_action_tbl) and k ~= self.action_pre then
      table.insert(actions, k)
      table.insert(dur, v.Duration)
    end
  end
  local index
  if name then
    index = 1
  else
    index = math.random(1, #actions)
  end
  local action = actions[index]
  self.action_pre = action
  self.duration = dur[index]
  self.puppet:setAction(action)
  self.puppet:setLoop(action == "Move")
  return action, self.duration
end

function buyFashionShopBox:registEvents()
  clickFunc(self, self.ui.btn_close, function()
    self:removeUpdateHandler("checkFcaHandler")
    ed.asyncload.isdDirty = false
    self:destroy({skipAnim = true})
  end, 0.7, 0.75, "btn_back")
  clickFunc(self, self.ui.btn_buy_orange, function()
    ed.showConfirmDialog({
      autoText = T("\230\152\175\229\144\166\232\138\177\232\180\185<sprite src=UI/alpha/1080P/shop/cosmetic/shop_cosmetic_currency_orange.png scale=0.9><lable color=ccc3(189,116,0)>%d</lable> \232\180\173\228\185\176%s\239\188\159", self.params["Orange Price Discount"] > 0 and self.params["Orange Price Discount"] or self.params["Orange Price"], self.ui.skin_name:getString()),
      rightHandler = function()
        ed.shop_network.cosmeticSendExchange(self.params["Goods ID"], 1)
      end
    })
  end, 0.75, 0.8, "btn_buy_orange")
  clickFunc(self, self.ui.btn_buy_blue, function()
    ed.showConfirmDialog({
      autoText = T("\230\152\175\229\144\166\232\138\177\232\180\185<sprite src=UI/alpha/1080P/shop/cosmetic/shop_cosmetic_currency_blue.png scale=0.9><lable color=ccc3(189,116,0)>%d</lable> \232\180\173\228\185\176%s\239\188\159", self.params["Blue Price Discount"] > 0 and self.params["Blue Price Discount"] or self.params["Blue Price"], self.ui.skin_name:getString()),
      rightHandler = function()
        ed.shop_network.cosmeticSendExchange(self.params["Goods ID"], 2)
      end
    })
  end, 0.75, 0.8, "btn_buy_blue")
  self:listenEvent("cosmeticShopReplyShow", function()
    self:destroy()
  end)
end
