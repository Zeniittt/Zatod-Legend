local base = ed.ui.commonscene
local GuildMountShopScene = newclass(base.mt)
ed.ui.GuildMountShopScene = GuildMountShopScene

function GuildMountShopScene:initData()
  self.goodList = ed.GuildMountManager.shopList
  self.shopCoinId = ed.GuildMountManager:getSeasonShopCoinID()
end

function GuildMountShopScene:adaptUI()
  local ui = self.ui
  local newWid = ed.display.halfFixedWidth
  local newHei = ed.display.halfFixedHeight
  local posx, posy = ui.pan_item:getPosition()
  ui.pan_item:setPosition(posx - newWid, -newHei)
  local size = ui.pan_item:getContentSize()
  size = CCSizeMake(size.width + newWid * 2, size.height + newHei * 2)
  ui.pan_item:setContentSize(size)
  self.thisConList = size
  posx, posy = ui.pan_title:getPosition()
  ui.pan_title:setPosition(posx - newWid, posy + newHei)
  posx, posy = ui.pan_updata:getPosition()
  ui.pan_updata:setPosition(posx + newWid - 125, posy + newHei)
  ed.layout.layoutWithMagin(self.resourceBox.container, {top = 22, right = 62})
  ed.layout.layoutWithMagin(ui.price_rule, {top = 22, right = 30})
end

function GuildMountShopScene:refreshTimeDes()
  local strTime, s = ed.GuildMountManager:getSeasonEnd()
  s = s or ed.getServerTime()
  if s <= ed.getServerTime() then
    self.ui.Label_1084:setString(T("\229\183\178\229\129\156\230\173\162\229\133\145\230\141\162"))
    self.stopShop = true
  elseif s - ed.getServerTime() < 3601 then
    self:listenTimer(Timer:Always(1), function()
      local ts = s - ed.getServerTime()
      if ts <= 0 then
        self.ui.Label_1084:setString(T("\229\183\178\229\129\156\230\173\162\229\133\145\230\141\162"))
        self.stopShop = true
      else
        self.ui.Label_1084:setString(T("%s\229\144\142\229\129\156\230\173\162\229\133\145\230\141\162", ed.time2dhms(ts)))
      end
    end)
  else
    self.ui.Label_1084:setString(T("%s\229\144\142\229\129\156\230\173\162\229\133\145\230\141\162", strTime))
  end
end

function GuildMountShopScene:getCancelPressInHandler()
  local function handler(x, y, item)
    if item then
      item.ui.img_bj:setScale(1)
    end
  end
  
  return handler
end

function GuildMountShopScene:getPressInHandler()
  local function handler(x, y)
    local items = self.items or {}
    
    for i, v in ipairs(items) do
      if ed.containsPoint(v.ui.img_bj, x, y) then
        v.ui.img_bj:setScale(0.98)
        self.newTouch = true
        return v
      end
    end
  end
  
  return handler
end

function GuildMountShopScene:getClickInHandler()
  local function handler(x, y, passItem)
    if self.stopShop then
      ed.showToast(T("\229\183\178\229\129\156\230\173\162\229\133\145\230\141\162\239\188\129"))
      
      return
    end
    if not self.newTouch then
      return
    end
    if passItem then
      passItem.ui.img_bj:setScale(1)
    end
    local amount = 999
    if passItem.data.amountMax and passItem.data.amountNew then
      amount = passItem.data.amountMax - passItem.data.amountNew
    end
    if amount <= 0 then
      ed.showToast(T("\229\183\178\229\148\174\231\189\132\239\188\129"))
      return
    end
    if passItem.data.time and (passItem.ui.timeDele or self.timeToItemRes[passItem.data.id] and 0 >= self.timeToItemRes[passItem.data.id].time_s) then
      ed.showToast(T("\232\175\165\229\149\134\229\147\129\229\183\178\228\184\139\230\158\182\239\188\129"))
      return
    end
    local shopShard = "shopShard" == self.identity
    self.passItem = passItem
    local item = passItem.data.item
    local buyResourceBox = ed.ui.buyResourceBox.create({
      buyLimitNum = amount,
      defaultBuyNum = 1,
      goodsResType = ed.ui.configs.resType.getResType(item.type),
      goodsId = item.id,
      costResType = passItem.data.priceType,
      price = passItem.data.price * (item.count or 1),
      buyAction = function(num)
        self.buyIng = true
        ed.GuildMountNetwork:sendBuyGoods(passItem.data.groupId, passItem.data.index, num)
      end,
      callback = function(num)
        if not self.buyIng then
          self.passItem = nil
        end
      end,
      shopShard = shopShard,
      item = item
    })
    buyResourceBox:setSurplusAmount(amount)
    buyResourceBox:popWindow()
  end
  
  return handler
end

function GuildMountShopScene:createItem(data)
  local container, ui = ed.editorui(ed.uieditor.shopitem)
  local soldout_label = ui.soldout_label
  ed.setLabelFontName(soldout_label, ed.fontBold)
  ed.setLabelStroke(soldout_label, ed.toccc3(2826261), 1.5)
  ed.adaptLabel(soldout_label, {maxWidth = 56, minScale = 0.65})
  ui.img_bg:setZOrder(-10)
  if data.item.id then
    local quality = ed.readequip.quality(data.item.id) or 1
    local bg_size = ui.img_bg:getContentSize()
    ui.img_bg:setSpriteFrame(ed.getSpriteFrame(string.format("UI/alpha/1080P/shop/shop_goods_bg_%d.png", quality == 4 and 5 or quality)))
    ui.img_bg:setContentSize(bg_size)
  end
  local config = ed.ui.configs.resBar.getResBarConfig(string.lower(data.priceType))
  if config then
    local res
    if type(config.smallIcon) == "function" then
      res = config.smallIcon()
    else
      res = config.smallIcon
    end
    ed.initSpriteWithFrame(ui.img_price, res)
    ui.img_price:setScale(config.scale or 1)
  end
  ui.label_name:setString("")
  local amount = 999
  if data.amountMax and data.amountNew then
    amount = data.amountMax - data.amountNew
  end
  ui.label_num:setString(T("\229\137\169\228\189\153\230\149\176\233\135\143:%d", amount))
  ui.label_num:setStroke(ccc3(ed.colorToStr("#2b2015")), 1)
  ui.label_num:setColor(ccc3(ed.colorToStr(amount <= 0 and "#FF664B" or "#FFD790")))
  ui.img_nil:setVisible(amount <= 0)
  ui.soldout_shade:setVisible(amount <= 0)
  ui.img_chaozhi_shade:setVisible(amount <= 0)
  local wid = ui.img_bj:getContentSize()
  local icon, name = ed.createItemIcon(data.item, true)
  icon:setPosition(wid.width / 2, wid.height - 50)
  icon:setScale(1)
  ui.img_bj:addChild(icon)
  name:setColor(ccc3(ed.colorToStr("#FFF1D7")))
  name:setStroke(ccc3(ed.colorToStr("#2b2015")), 1)
  name:setPositionY(name:getPositionY() - 8)
  ed.adaptLabel(name, {
    maxWidth = wid.width * 0.85,
    minScale = 0.8
  })
  ui.pan_time:setVisible(false)
  ui.line_long_price:setVisible(false)
  ui.label_long_price:setVisible(false)
  ui.pan_zhe:setVisible(false)
  ui.pan_chaozhi:setVisible(data.zhe)
  ui.label_price:setString(data.price * (data.item.count or 1))
  local multiFontSize = {
    cn = 14,
    en = 13,
    tw = 14,
    ko = 13,
    ja = 14,
    es = 13
  }
  local label = ed.createLabelTTF(T("\232\182\133\229\128\188\228\188\152\230\131\160"), multiFontSize[ed.getCurArea()] or 14, ed.fontBold)
  ed.setLabelColor(label, ed.toccc3(15093776))
  ed.setLabelStroke(label, ed.toccc3(16777215), 1.5)
  ed.UITool.replaceUINew(ui, "ImageView_126", label)
  return container, ui
end

function GuildMountShopScene:refreshDraglist()
  local contentSize = self.ui.pan_item:getContentSize()
  local px, py = 170, 185
  local numOfCol = math.floor(contentSize.width / px)
  local oy = contentSize.height - 10
  px = contentSize.width / numOfCol
  local ox = (contentSize.width - px * numOfCol) / 2
  
  local function getPos(index)
    local row = math.floor((index - 1) / numOfCol) + 1
    local col = (index - 1) % numOfCol
    return ccp(ox + col * px, oy - row * py)
  end
  
  self.items = {}
  for k, v in ipairs(self.goodList or {}) do
    local container, ui = self:createItem(v)
    container:setPosition(getPos(k))
    self.draglist:addItem(container)
    table.insert(self.items, {ui = ui, data = v})
  end
  local listHeight = (math.floor((#self.goodList - 1) / numOfCol) + 1) * py
  self.draglist:initListHeight(listHeight + 15)
end

function GuildMountShopScene:initUI()
  local container, ui = ed.editorui(ed.uieditor.PeakArenaShopScene)
  self.ui = ui
  self.mainLayer:addChild(container)
  local _, titleTxt = ed.UITool.createSceneTitle(T("\233\173\148\231\149\140\229\149\134\229\186\151"), self.ui.pan_title, {
    position = ccp(13, 18)
  })
  ed.layout.relateLayout(titleTxt, self.ui.btn_rule, {
    right = titleTxt:getContentSize().width * 0.5 + 20
  })
  self:setBackButton()
  self:setBackground("UI/alpha/1080P/toparena/toparena_shop_bg.jpg")
  self:adaptUI()
  self.draglist = ed.UITool.createDraglist(self.ui.pan_item, {
    doPressIn = self:getPressInHandler(),
    doClickIn = self:getClickInHandler(),
    cancelPressIn = self:getCancelPressInHandler(),
    priority = -300
  })
  self:refreshTimeDes()
  self:refreshDraglist()
end

function GuildMountShopScene:registerTouchHandlers()
  ed.UITool.registerBtn(self, "btn_rule", function()
    local txt = {
      T("<lable color=summonYellow>\229\149\134\229\186\151</lable><br/><br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\232\174\168\228\188\144\229\139\139\231\171\160\229\143\175\231\148\168\228\186\142\229\156\168<lable color=summonYellow>\233\173\148\231\149\140\229\149\134\229\186\151</lable>\233\135\140\229\133\145\230\141\162\229\165\150\229\138\177<br/><br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\233\173\148\231\149\140\229\149\134\229\186\151\228\188\154\229\156\168\230\180\187\229\138\168\231\187\147\230\157\159\230\151\182\229\133\179\233\151\173\239\188\140\229\144\140\230\151\182\232\174\168\228\188\144\229\139\139\231\171\160\228\188\154\229\156\168\230\150\176\231\154\132\228\184\128\230\156\159\230\180\187\229\138\168\229\188\128\229\167\139\230\151\182\229\129\154\232\191\135\230\156\159\229\164\132\231\144\134\239\188\140\232\175\183\229\144\132\228\189\141\233\152\159\233\149\191\230\179\168\230\132\143\229\133\145\230\141\162\230\151\182\233\151\180\227\128\130<br/>")
    }
    ed.ui.commonRulePop.create({
      title = T("\229\133\145\230\141\162\232\167\132\229\136\153"),
      txt = txt
    }):popWindow()
  end, {pressScale = 0.9})
  ed.UITool.registerBtn(self, "price_rule", function()
    ed.showToast(T("\232\174\168\228\188\144\229\139\139\231\171\160\229\176\134\229\156\168\228\184\139\228\184\128\230\156\159\230\180\187\229\138\168\229\188\128\229\167\139\230\151\182\230\184\133\231\169\186"))
  end, {pressScale = 0.9})
end

function GuildMountShopScene:registerEvents()
  self.eventScope = {}
  self:listenEvent("GuildMountShopItemUpdate", function()
    if self.passItem then
      ed.showToast(T("\232\180\173\228\185\176\230\136\144\229\138\159"))
      local ui = self.passItem.ui
      local itemData = self.passItem.data
      local amount
      if itemData.amountMax and itemData.amountNew then
        amount = itemData.amountMax - itemData.amountNew
      end
      if amount and ui and ui.label_num and not tolua.isnull(ui.label_num) then
        ui.label_num:setString(T("\229\137\169\228\189\153\230\149\176\233\135\143:%d", amount))
        ui.label_num:setStroke(ccc3(ed.colorToStr("#2b2015")), 1)
        ui.label_num:setColor(ccc3(ed.colorToStr(amount <= 0 and "#FF664B" or "#FFD790")))
        ui.img_nil:setVisible(amount <= 0)
        ui.soldout_shade:setVisible(amount <= 0)
        ui.img_chaozhi_shade:setVisible(amount <= 0)
      end
      self.passItem = nil
      self.buyIng = nil
      self.resourceBox:updateAllResourceValue()
    end
  end, self.eventScope)
end

function GuildMountShopScene.create()
  local self = base.create("GuildMountShopScene", {noBottomButton = true})
  setmetatable(self, GuildMountShopScene.mt)
  self:initData()
  self:initUI()
  self:registerTouchHandlers()
  self:registerEvents()
  return self
end

ed.UITool.registViewOpenFunc("GuildMountShopScene", function()
  ed.pushScene(GuildMountShopScene.create())
end)
