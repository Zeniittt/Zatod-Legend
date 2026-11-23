local base = ed.ui.popwindow
local timeCorridorBuyFashionPop = newclass(base.mt)
ed.ui.timeCorridorBuyFashionPop = timeCorridorBuyFashionPop

function timeCorridorBuyFashionPop.create(param)
  local self = base.create("timeCorridorBuyFashionPop")
  setmetatable(self, timeCorridorBuyFashionPop.mt)
  self:init(param)
  self:popWindow()
  return self
end

function timeCorridorBuyFashionPop:init(param)
  self:initData(param)
  self:initUI()
  self:registerEvents()
end

function timeCorridorBuyFashionPop:initData(param)
  self.fashionId = param.fashionId
  self.tokenAmount = param.tokenAmount
  self.progress = param.progress
  self.heroId = ed.lookupDataTable("Fashion", "Hero ID", self.fashionId)
  self.goodId = param.goodId
end

function timeCorridorBuyFashionPop:initUI()
  local container, ui = ed.editorui(ed.uieditor.buyFashionShopBox)
  self.container:addChild(container)
  self.ui = ui
  container:setPosition(ed.display.winSize.width / 2 - ed.display.halfFixedWidth, ed.display.winSize.height / 2 - ed.display.halfFixedHeight)
  ui.shop_cosmetic_text_1:setVisible(false)
  ui.shop_cosmetic_text:setVisible(false)
  ui.btn_buy_blue:setVisible(false)
  ui.btn_buy_orange:setPositionX(ui.shop_cosmetic_text_bg:getPositionX())
  local str = self.progress <= 0 and T("\229\183\178\232\190\190\229\133\145\230\141\162\230\157\161\228\187\182\239\188\129") or T("\232\191\152\233\156\128%s\229\143\175\229\133\145\230\141\162", string.format("<sprite src=%s scale=0.7><lable color=ccc3(229,147,58)>%s</lable>", ed.timeCorridorMgr:getTokenSmallIconRes(), self.progress))
  local progress_tip = ed.ui.autoText.new()
  progress_tip:initParam({
    context = str,
    fontSize = 16,
    color = ccc3(255, 234, 198)
  })
  ui.shop_cosmetic_text_bg:addChild(progress_tip.node)
  local btn_size = ui.shop_cosmetic_text_bg:getContentSize()
  local atWid, _ = progress_tip:getCurContentSize()
  progress_tip.node:setPosition(ccp((btn_size.width - atWid) * 0.5, btn_size.height * 0.5))
  local small_icon = ed.createSprite(ed.timeCorridorMgr:getTokenSmallIconRes())
  local price_lab = ed.createLabelTools({
    txt = self.tokenAmount,
    size = 24,
    color = ccc3(ed.colorToStr("#FCF1A5")),
    shadow = {
      ccc3(69, 46, 29),
      ccp(0, 2)
    },
    parent = ui.btn_buy_orange
  })
  ui.btn_buy_orange:addChild(small_icon)
  small_icon:setPositionY(ui.btn_buy_orange:getContentSize().height * 0.5)
  price_lab:setPositionY(ui.btn_buy_orange:getContentSize().height * 0.5)
  ed.layout.horizontalSortNode({small_icon, price_lab}, {5, 0}, ui.btn_buy_orange:getContentSize().width * 0.5)
  local ress = ed.getFashionFrameRes(self.fashionId, "nameFrame")
  if ress then
    ed.setTexture(self.ui.bg_skin_name, ress)
  end
  self.ui.skin_name:setString(ed.lookupDataTable("Fashion", "Name", self.fashionId))
  local card = ed.readhero.getHeroCard(self.heroId, {
    hide_star = true,
    starType = "init",
    OriSize = true,
    fashion_id = self.fashionId or 0
  }, {
    index = 1,
    _tid = self.heroId,
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
  local puppet, puppet_id, cha = ed.readhero.getActor(self.heroId, "Idle", true, false, self.fashionId, false)
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
end

local lsr = ed.heroDetailManager.listener.create()

function timeCorridorBuyFashionPop:changeFcaAction(name, with_sound)
  if with_sound == nil then
    with_sound = true
  end
  local action, duration = self:changeAction(name)
  if with_sound then
    lsr:report("clickHeroFca", {
      hid = self.heroId,
      action = action,
      fashionId = self.fashionId
    })
  end
  self:registerUpdateHandler("checkFcaHandler", self:checkFcaHandler(action, duration))
end

function timeCorridorBuyFashionPop:checkFcaHandler(action, duration)
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

function timeCorridorBuyFashionPop:changeAction(name)
  local row = ed.getDataTable("AnimDuration")[self.cha]
  local actions = {}
  local dur = {}
  local skill_items = ed.getDataTable("SkillGroup")[self.heroId]
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

function timeCorridorBuyFashionPop:registerEvents()
  self:btRegisterButtonClick({
    button = self.ui.btn_close,
    key = "btn_back",
    clickHandler = function()
      self:removeUpdateHandler("checkFcaHandler")
      ed.asyncload.isdDirty = false
      self:destroy({skipAnim = true})
    end,
    force = true,
    pressScale = 0.7,
    normalScale = 0.75,
    clickInterval = 0.2
  })
  self:btRegisterButtonClick({
    button = self.ui.btn_buy_orange,
    key = "buy_btn",
    clickHandler = function()
      ed.showConfirmDialog({
        autoText = T("\230\152\175\229\144\166\232\138\177\232\180\185%s\229\133\145\230\141\162%s\239\188\159", string.format("<sprite src=%s scale=0.9><lable color=ccc3(189,116,0)>%d</lable>", ed.timeCorridorMgr:getTokenSmallIconRes(), self.tokenAmount), self.ui.skin_name:getString()),
        rightHandler = function()
          ed.timeCorridorNet:sendBuyGoods(self.goodId, 1)
          self:destroy()
        end
      })
    end,
    force = true,
    pressScale = 0.75,
    normalScale = 0.8,
    clickInterval = 0.2
  })
  self:listenEvent("timeCorridorShopReply", function()
    ed.showToast(T("\229\133\145\230\141\162\230\136\144\229\138\159"))
    self:destroy()
  end)
end

local timeCorridorBuyItemPop = newclass(base.mt)
ed.ui.timeCorridorBuyItemPop = timeCorridorBuyItemPop

function timeCorridorBuyItemPop.create(params)
  local self = base.create("timeCorridorBuyItemPop", {notBlurBg = true})
  setmetatable(self, timeCorridorBuyItemPop.mt)
  self:initData(params)
  self:initUI()
  self:registEvents()
  self:popWindow()
  return self
end

function timeCorridorBuyItemPop:initData(params)
  self.tokenAmount = params.tokenAmount
  self.smallIconRes = params.smallIconRes
  self.itemId = params.itemId
  self.goodId = params.goodId
end

function timeCorridorBuyItemPop:initUI()
  local container, ui = ed.editorui(ed.uieditor.buyExteriorShopBox)
  self.container:addChild(container)
  ui.line:getParent():setScale(0.5)
  ui.line:setScaleX(-1)
  self.ui = ui
  ui.shop_cosmetic_text_bg:setVisible(false)
  ui.btn_buy_blue:setVisible(false)
  ui.btn_buy_orange:setPositionX(ui.shop_cosmetic_text_bg:getPositionX())
  ed.UITool.setPositionBy(ui.ImageView_305, ccp(0, -10))
  ed.UITool.setPositionBy(ui.btn_buy_orange, ccp(0, 10))
  local small_icon = ed.createSprite(self.smallIconRes)
  local price_lab = ed.createLabelTools({
    txt = self.tokenAmount,
    size = 24,
    color = ccc3(ed.colorToStr("#FCF1A5")),
    shadow = {
      ccc3(69, 46, 29),
      ccp(0, 2)
    },
    parent = ui.btn_buy_orange
  })
  ui.btn_buy_orange:addChild(small_icon)
  small_icon:setPositionY(ui.btn_buy_orange:getContentSize().height * 0.5)
  price_lab:setPositionY(ui.btn_buy_orange:getContentSize().height * 0.5)
  ed.layout.horizontalSortNode({small_icon, price_lab}, {5, 0}, ui.btn_buy_orange:getContentSize().width * 0.5)
  local item = ed.createItemIcon({
    id = self.itemId
  })
  item:setPosition(55, 43)
  ui.conent_bg:addChild(item)
  item:setScale(0.94)
  local strokecolor = ccc3(39, 37, 36)
  ed.setLabelStroke(ui.title_text, strokecolor, 1)
  ed.setLabelStroke(ui.item_name, strokecolor, 1)
  ed.setLabelStroke(ui.cost_value, strokecolor, 1)
  ed.setLabelDimensions(ui.item_desc, CCSizeMake(316.5, 0))
  item = ed.getDataTable("equip")[self.itemId]
  self.ui.item_name:setString(item.Name)
  self.ui.item_desc:setString(item.Comment or T("\232\191\153\228\187\182\232\163\133\229\164\135\228\184\141\230\132\191\230\132\143\230\143\143\232\191\176\232\135\170\229\183\177"))
  self.ui.title_text:setString(T("\229\133\145\230\141\162") .. item.Name)
end

function timeCorridorBuyItemPop:registEvents()
  self:btRegisterButtonClick({
    button = self.ui.btn_close,
    key = "btn_back",
    clickHandler = function()
      ed.playEffect(ed.sound.deo.common_back)
      self:destroy()
    end,
    force = true,
    pressScale = 0.7,
    normalScale = 0.75,
    clickInterval = 0.2
  })
  self:btRegisterButtonClick({
    button = self.ui.btn_buy_orange,
    key = "buy_btn",
    clickHandler = function()
      ed.showConfirmDialog({
        autoText = T("\230\152\175\229\144\166\232\138\177\232\180\185%s \229\133\145\230\141\162%s\239\188\159", string.format("<sprite src=%s scale=0.9><lable color=ccc3(189,116,0)>%d</lable>", self.smallIconRes, self.tokenAmount), self.ui.item_name:getString()),
        rightHandler = function()
          ed.timeCorridorNet:sendBuyGoods(self.goodId, 1)
          self:destroy()
        end
      })
    end,
    force = true,
    pressScale = 0.75,
    normalScale = 0.8,
    clickInterval = 0.2
  })
  self:listenEvent("timeCorridorShopReply", function()
    self:destroy()
  end)
end
