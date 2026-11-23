local base = ed.ui.popwindow
local buyResourceBox = newclass(base.mt)
ed.ui.buyResourceBox = buyResourceBox

function buyResourceBox.create(params)
  local self = base.create("buyResourceBox", {notBlurBg = true})
  setmetatable(self, buyResourceBox.mt)
  self.params = params
  params.buyLimitNum = params.buyLimitNum or 9999
  params.defaultBuyNum = params.defaultBuyNum or 1
  params.price = params.price or 0
  
  local function toMaxAmount(itemId)
    local ca = ed.player:getEquipAmount(itemId)
    local maxAmount = ed.player:getItemMaxAmount(itemId)
    return maxAmount - ca
  end
  
  local max
  if params.item and params.item.type == "legend_equip" then
    max = params.buyLimitNum <= 0 and 1 or params.buyLimitNum
  elseif params.goodsId then
    max = toMaxAmount(params.goodsId)
    self.beyond = max <= 0
    if max <= 0 then
      max = 1 or max
    end
  else
    max = params.buyLimitNum <= 0 and 1 or params.buyLimitNum
  end
  self.originBuyLimitNum = params.buyLimitNum
  params.buyLimitNum = max < params.buyLimitNum and max or params.buyLimitNum
  params.defaultBuyNum = max < params.defaultBuyNum and max or params.defaultBuyNum
  if params.price > 0 then
    local costNum = self:getCostResNum()
    local buyLimitNum = math.min(math.floor(costNum / params.price), params.buyLimitNum)
    params.buyLimitNum = math.max(buyLimitNum, 1)
  end
  if params.showNumber then
    self.showNumber = params.showNumber
  end
  
  function self.destroyCallback()
    if self.params.callback then
      self.params.callback()
    end
  end
  
  self:init()
  return self
end

function buyResourceBox:init()
  local container, ui = ed.editorui(ed.uieditor.buyBoxWindow, self.ui)
  self.ui = ui
  self.container:addChild(container)
  ui.line:getParent():setScale(0.5)
  ui.line:setScaleX(-1)
  ui.cost_value:setVisible(false)
  local label = ed.createttf("", 16)
  label:setPosition(500, 183)
  label:setColor(ccc3(255, 252, 231))
  container:addChild(label)
  ui.cost_value = label
  self:shopShardBuyResourceBoxUi()
  self:show()
  local strokecolor = ccc3(39, 37, 36)
  ed.setLabelStroke(ui.title_text, strokecolor, 1)
  ed.setLabelStroke(ui.item_name, strokecolor, 1)
  ed.setLabelStroke(ui.cost_value, strokecolor, 1)
  ed.setLabelDimensions(ui.item_desc, CCSizeMake(316.5, 0))
  self:initGoodsInfo()
  self:initEditBox()
  self:updateNumAndCost(self.params.defaultBuyNum)
  self:registEvents()
end

local ResType = ed.ui.configs.resType.ResType

function buyResourceBox:initGoodsInfo()
  if self.originBuyLimitNum then
    if self.params.totalBuyLimit then
      self.ui.text_buy_num_limit:setString(string.format(T("\228\187\138\230\151\165\229\143\175\232\180\173\228\185\176\230\172\161\230\149\176\239\188\154%s/%s"), self.originBuyLimitNum, self.params.totalBuyLimit))
    else
      self.ui.text_buy_num_limit:setString(T("\228\187\138\230\151\165\229\143\175\232\180\173\228\185\176\230\172\161\230\149\176\239\188\154") .. self.originBuyLimitNum)
    end
    if self.originBuyLimitNum <= 0 then
      ed.setLabelColor(self.ui.text_buy_num_limit, ed.toccc3(16711685))
    end
  end
  if self.params.goodsResType == ResType.item then
    local item = ed.getDataTable("equip")[self.params.goodsId or self.params.item.id]
    local icon = ed.readequip.createIconWithAmount(self.params.goodsId or self.params.item.id, nil, self.params.groupAmount or 1)
    icon:setScale(0.8)
    self.ui.item_name:setString(item.Name)
    self.ui.item_desc:setString(item.Description or item.Comment or T("\232\191\153\228\187\182\232\163\133\229\164\135\228\184\141\230\132\191\230\132\143\230\143\143\232\191\176\232\135\170\229\183\177"))
    self.ui.icon_parent:addChild(icon)
    ed.layout.centerInParent(icon)
    self.ui.title_text:setString(T("\232\180\173\228\185\176%s", item.Name))
  elseif ed.getDataTable("Token")[self.params.goodsResType] then
    local tokenCfg = ed.getDataTable("Token")[self.params.goodsResType]
    local iconFrame = ed.createSprite("UI/alpha/1080P/common/frame/equip_frame_white.png")
    local icon = ed.createSprite(tokenCfg.Icon)
    icon:addChild(iconFrame)
    ed.layout.centerInParent(iconFrame)
    icon:setScale(0.8)
    self.ui.icon_parent:addChild(icon)
    ed.layout.centerInParent(icon)
    local tokenName = tokenCfg["Token Name"]
    self.ui.item_name:setString(tokenName)
    self.ui.item_desc:setString(tokenCfg["Describe 1"])
    self.ui.title_text:setString(T("\232\180\173\228\185\176%s", tokenName))
  elseif self.params.goodsResType == "legend_equip" then
    local icon, equip, amountLabel = ed.readequip.createBasicLegendEquipIcon(self.params.item.id, self.params.groupAmount or 1)
    self.ui.icon_parent:addChild(icon)
    ed.layout.centerInParent(icon)
    self.ui.item_name:setString(ed.getDataTable("LegendEquip")[self.params.item.id]["Equip Name"])
    self.ui.item_desc:setString(ed.getDataTable("LegendEquip")[self.params.item.id]["Get Dec"])
    self.ui.title_text:setString(T("\232\180\173\228\185\176%s", ed.getDataTable("LegendEquip")[self.params.item.id]["Equip Name"]))
  elseif self.params.goodsResType == "rise_star" then
    local item = ed.getDataTable("equip")[self.params.goodsId or self.params.item.id]
    local icon = ed.readequip.createIconWithAmount(self.params.goodsId or self.params.item.id, nil, self.params.groupAmount or 1)
    icon:setScale(0.8)
    self.ui.item_name:setString(item.Name)
    self.ui.item_desc:setString(item.Description or item.Comment or T("\232\191\153\228\187\182\232\163\133\229\164\135\228\184\141\230\132\191\230\132\143\230\143\143\232\191\176\232\135\170\229\183\177"))
    self.ui.icon_parent:addChild(icon)
    ed.layout.centerInParent(icon)
    self.ui.title_text:setString(T("\232\180\173\228\185\176%s", item.Name))
    local label = ed.createttf(self.showNumber, 24)
    label:setPosition(ccp(80, 10))
    label:setAnchorPoint(ccp(1, 0))
    icon:addChild(label)
    ed.setLabelStroke(label, ed.toccc3(2826261), 1.5)
  end
  local hei = self.ui.item_desc:getContentSize().height
  if hei > self.ui.item_desc_panel:getContentSize().height then
    self.ui.item_desc_panel:setVisible(true)
    local dlDesc = ed.UITool.createDraglist(self.ui.item_desc_panel, {})
    self.ui.item_desc:removeFromParentAndCleanup(true)
    dlDesc:addItem(self.ui.item_desc)
    self.ui.item_desc:setPosition(ccp(0, self.ui.item_desc_panel:getContentSize().height - hei * 0.5))
    dlDesc:initListHeight(hei + 5)
  end
  self.ui.item_name:limitWidthByScale(self.ui.label_amount_str:getPositionX() - self.ui.label_amount_str:getContentSize().width - self.ui.item_name:getPositionX() - 10)
  self.ui.title_text:limitWidthByScale(self.ui.title_bg:getContentSize().width - 65)
  if self.params.costResType == "riseStarPoint" then
    ed.initSpriteWithFrame(self.ui.cost_icon, "UI/alpha/1080P/risestar/itemicon.png")
    self.ui.cost_icon:setScale(1)
    self.ui.cost_icon:setPositionX(self.ui.cost_icon:getPositionX() + 10)
    self.ui.amount:setPositionX(self.ui.amount:getPositionX() - 10)
  else
    local config = ed.ui.configs.resBar.getResBarConfig(string.lower(self.params.costResType))
    local costIconConfig = self.params.costIconConfig
    if config or costIconConfig then
      local config = config or costIconConfig
      local res = config.smallIcon
      ed.initSpriteWithFrame(self.ui.cost_icon, res)
      self.ui.cost_icon:setScale(config.scale or 1)
    end
  end
  local amount = 0
  if self.params.ownedAmount then
    amount = self.params.ownedAmount
  elseif self.params.goodsResType == "legend_equip" then
    amount = ed.legendEquipMgr.getInstance():getLegendEquipAmountByTypeId(self.params.goodsId)
  else
    amount = ed.player:getEquipAmount(self.params.goodsId)
  end
  local amountStr = amount
  if ed.readequip.value(self.params.goodsId, "Category") == T("\231\129\181\233\173\130\231\159\179") then
    local heroId = ed.readhero.getMakeid(self.params.goodsId)
    local hero = ed.player.heroes[heroId]
    if not hero or hero and 5 > hero._stars then
      local stoneNeed = ed.readhero.getStoneNeed(heroId) or 9999999
      amountStr = string.format("%d/%d", amount, stoneNeed)
    end
    self.isMaxStar = hero and 5 <= hero._stars
  end
  self.ui.amount:setString(amountStr)
  self.ui.label_amount_str:setPositionX(self.ui.amount:getPositionX() - self.ui.amount:getContentSize().width)
end

function buyResourceBox:initEditBox()
  local info = {
    config = {
      editSize = self.ui.input_bg:getContentSize(),
      maxLength = 4,
      fontColor = ccc3(255, 252, 231),
      fontSize = 18,
      inputMode = kEditBoxInputModeNumeric
    }
  }
  local edit_box = editBox:new(info)
  edit_box:setVisible(false)
  edit_box:setEnabled(true)
  edit_box.edit:setAnchorPoint(ccp(0, 0))
  edit_box.edit:setPosition(ccp(0, 0))
  self.ui.input_bg:addChild(edit_box.edit)
  self.ui.edit_box = edit_box
  self:btRegisterHandler({
    handler = function(event, x, y)
      self.ui.edit_box:touch(event, x, y)
    end,
    key = "edit_box"
  })
end

function buyResourceBox:setSurplusAmount(surplusAmount)
  self.surplusAmount = surplusAmount
  if self.surplusAmount then
    self.params.buyLimitNum = math.min(self.surplusAmount, self.params.buyLimitNum)
  end
  self.ui.text_buy_num_limit:setString(T("\229\137\169\228\189\153\230\149\176\233\135\143\239\188\154") .. surplusAmount)
end

function buyResourceBox:setOwnLabelVisible(isVisible)
  self.ui.amount:setVisible(isVisible)
  self.ui.label_amount_str:setVisible(isVisible)
end

local buttonnames = {
  "btn_add",
  "btn_reduce",
  "btn_reduce_ten",
  "btn_add_ten",
  "btn_max"
}

function buyResourceBox:registEvents()
  self:btRegisterButtonClick({
    button = self.ui.btn_close,
    key = "btn_close",
    clickHandler = function()
      ed.playEffect(ed.sound.deo.common_back)
      self:closeWindow()
    end,
    clickInterval = 0.2,
    priority = -1,
    normalScale = 0.75,
    pressScale = 0.7
  })
  self:btRegisterButtonClick({
    button = self.ui.btn_buy,
    key = "btn_buy",
    clickHandler = function()
      self:doBuy()
    end,
    clickInterval = 0.2,
    priority = -1,
    normalScale = 0.8,
    pressScale = 0.75
  })
  
  local function keepeatHandler(func)
    local count = 0
    local delay = 0.5
    local accAcc = 2
    local speed = 10
    local accSpeed = 2
    local times = 0
    local func = func
    
    local function longPressHandler(dt)
      count = count + dt
      if count > delay then
        accSpeed = accSpeed + accAcc * dt
        speed = speed + accSpeed * dt
        times = times + speed * dt
        while 1 < times do
          func()
          times = times - 1
        end
      end
    end
    
    return longPressHandler
  end
  
  local function registerChangeNumButtonClick(buttonName, func, name)
    local function callFunc()
      func(self, name)
    end
    
    local config = {
      button = self.ui[buttonName],
      key = buttonName,
      clickHandler = function()
        ed.playEffect(ed.sound.deo.common_back)
        callFunc()
      end,
      priority = -1,
      clickInterval = 0.1,
      pressScale = 0.9,
      pressHandler = function()
        self:registerUpdateHandler("long_click_button_down", keepeatHandler(callFunc))
      end,
      cancelPressHandler = function()
        self:removeUpdateHandler("long_click_button_down")
      end
    }
    self:btRegisterButtonClick(config)
  end
  
  for _, name in ipairs(buttonnames) do
    registerChangeNumButtonClick(name, self.changeNum, name)
  end
  ed.getCurrentScene():registerUpdateHandler("buyResourceBoxUpdate", function()
    local num = tonumber(self.ui.edit_box:getString())
    if not num then
      return
    end
    if self.num ~= num then
      num = ed.clamp(num, 1, self.params.buyLimitNum)
      self:updateNumAndCost(num)
    end
  end)
end

function buyResourceBox:changeNum(name)
  local buyLimitNum = self.params.buyLimitNum
  local num = tonumber(self.ui.edit_box:getString())
  if name == "btn_add" then
    num = num + 1
  elseif name == "btn_add_ten" then
    num = num + 10
  elseif name == "btn_max" then
    num = buyLimitNum
  elseif name == "btn_reduce" then
    num = num - 1
  elseif name == "btn_reduce_ten" then
    num = num - 10
  end
  local totalPrice = self.params.totalPriceFun and self.params.totalPriceFun(num) or num * self.params.price
  if num > self.originBuyLimitNum then
    ed.showToast(T("\229\183\178\232\190\190\229\136\176\228\184\138\233\153\144\239\188\129"))
  elseif totalPrice > self:getCostResNum() then
    ed.showToast(T("%s\228\184\141\232\182\179", self.getGoodsName(self.params.costId, self.params.costResType)))
  end
  num = ed.clamp(num, 1, buyLimitNum)
  if self.num ~= num then
    self:updateNumAndCost(num)
  end
end

function buyResourceBox:updateNumAndCost(num)
  num = math.min(num, self.params.buyLimitNum)
  local totalPrice = self.params.totalPriceFun and self.params.totalPriceFun(num) or num * self.params.price
  self.ui.cost_value:setString(totalPrice)
  self.ui.edit_box:setString(num)
  self.ui.input_label:setString(num)
  self.num = num
  local totalCost = self.num * self.params.price
  local isRed = totalCost > self:getCostResNum()
  self.ui.cost_value:setColor(ccc3(ed.colorToStr(isRed and "#FF0005" or "#FFFCE7")))
  self:refreshHeroList()
end

function buyResourceBox:getCostResNum()
  if self.params.costResType == ResType.item then
    return ed.player:getEquipAmount(self.params.costId)
  elseif self.params.costResType == "peakarenapoint" then
    return ed.PeakArenaManager.coins or 0
  elseif self.params.costResType == "guildmountpoint" then
    return ed.GuildMountManager.coins or 0
  elseif self.params.costResType == "riseStarPoint" then
    return ed.riseStarMgr:getItemPoint() or 0
  end
  return ed.player:getPoint(self.params.costResType)
end

function buyResourceBox:setBtnBuyGrey(isGrey)
  local btnRes, labelColor
  if isGrey then
    btnRes = "UI/alpha/1080P/common/button_big_grey.png"
    labelColor = 15790320
  else
    btnRes = "UI/alpha/1080P/common/buttion_big.png"
    labelColor = 16446117
  end
  ed.setTexture(self.ui.btn_buy, btnRes)
  ed.setLabelColor(self.ui.label_buy, ed.toccc3(labelColor))
end

function buyResourceBox:doBuy()
  if self.isMaxStar then
    ed.showConfirmDialog({
      autoText = T("\230\173\164\232\139\177\233\155\132\229\183\178\232\191\155\229\140\150\232\135\179<lable color=ccc3(213,31,38)>\230\187\161\230\152\159</lable>\239\188\140\230\152\175\229\144\166\232\180\173\228\185\176\239\188\159"),
      rightHandler = function()
        self.isMaxStar = nil
        self:doBuy()
      end
    })
    return
  end
  if self.beyond then
    ed.showToast(self.ui.item_name:getString() .. T("\229\183\178\232\190\190\229\136\176\228\184\138\233\153\144\239\188\129"))
    return
  end
  if self.num <= 0 then
    ed.showToast(T("\232\180\173\228\185\176\230\149\176\233\135\143\228\184\141\232\131\189\228\184\1860\239\188\129"))
    return
  end
  local totalCost = self.num * self.params.price
  if totalCost > self:getCostResNum() then
    ed.showToast(T("%s\228\184\141\232\182\179", self.getGoodsName(self.params.costId, self.params.costResType)))
    return
  end
  if ed.isOpenConsumeTips() and ed.isElementInTable(self.params.costResType, {"diamond", "Diamond"}) and ed.ui.consumeTipsWin.isEnableShowWin() then
    ed.UITool.openView("consumeTipsWin", {
      text = T("\230\152\175\229\144\166\232\138\177\232\180\185%s%s\232\180\173\228\185\176%s*%s", totalCost, self.getGoodsName(self.params.costId, self.params.costResType), self.ui.item_name:getString(), self.num),
      rightHandler = function()
        self:consumeHandler()
      end
    })
  else
    self:consumeHandler()
  end
end

function buyResourceBox:consumeHandler()
  if self.params.buyAction then
    self.params.buyAction(self.num)
  end
  self:closeWindow()
end

function buyResourceBox:closeWindow()
  self:removeUpdateHandler("long_click_button_down")
  ed.getCurrentScene():removeUpdateHandler("buyResourceBoxUpdate")
  self:destroy()
end

function buyResourceBox.getGoodsName(id, type)
  local typ = string.lower(type)
  local name = "nil"
  if typ == "item" then
    name = ed.getDataTable("equip")[id].Name
  elseif typ == "medal" then
    name = ed.getDataTable("Medal")[id].Name
  elseif typ == "hero" then
    name = ed.getDataTable("Unit")[id]["Display Name"]
  elseif typ == string.lower("riseStarPoint") then
    name = T("\230\181\129\229\133\137\229\190\174\231\178\146")
  else
    name = ed.getVirtualName(string.lower(type)) or type .. T(":\230\156\170\229\145\189\229\144\141")
  end
  return name
end

function buyResourceBox:shopShardBuyResourceBoxUi()
  self.shardUpLevelCost = self:getShardUpLevelCost(self.params.goodsId)
  if #self.shardUpLevelCost == 0 then
    return
  end
  local addHeight = 120
  local ui = self.ui
  ui.ImageView_286:setContentSize(CCSizeMake(484, 311.5 + addHeight))
  ui.ImageView_294:setContentSize(CCSizeMake(493.5, 312 + addHeight))
  ui.ImageView_294:setPositionY(ui.ImageView_294:getPositionY() + addHeight / 2)
  ui.btn_close:setPositionY(ui.btn_close:getPositionY() + addHeight / 2)
  ui.title_bg:setPositionY(ui.title_bg:getPositionY() + addHeight / 2)
  ui.conent_bg:setPositionY(ui.conent_bg:getPositionY() + addHeight / 2)
  ui.text_buy_num_limit:setPositionY(ui.text_buy_num_limit:getPositionY() - addHeight / 2)
  ui.input_panel:setPositionY(ui.input_panel:getPositionY() - addHeight / 2)
  ui.ImageView_305:setPositionY(ui.ImageView_305:getPositionY() - addHeight / 2)
  ui.btn_buy_123:setPositionY(ui.btn_buy_123:getPositionY() - addHeight / 2)
  ui.cost_icon:setPositionY(ui.cost_icon:getPositionY() - addHeight / 2)
  ui.btn_buy:setPositionY(ui.btn_buy:getPositionY() - addHeight / 2)
  ui.cost_value:setPositionY(ui.cost_value:getPositionY() - addHeight / 2)
  local posx, posy = self.ui.conent_bg:getPosition()
  local heroLayer = ed.createScale9Sprite("UI/alpha/1080P/shop/shard/shop_shard_bg.png", CCRectMake(8, 8, 10, 99))
  heroLayer:setContentSize(CCSizeMake(467.5, addHeight))
  heroLayer:setPosition(posx, posy - (addHeight - 14))
  self.ui.conent_bg:getParent():addChild(heroLayer)
  local sprite = ed.createSprite("UI/alpha/1080P/common/battle_prepare_lins_3.png")
  sprite:setPosition(88.75, addHeight - 12)
  heroLayer:addChild(sprite)
  sprite = ed.createSprite("UI/alpha/1080P/common/battle_prepare_lins_1.png")
  sprite:setPosition(378.75, addHeight - 12)
  heroLayer:addChild(sprite)
  local label = ed.createttf(T("\232\180\173\228\185\176\229\144\142\230\140\129\230\156\137\233\129\147\229\133\183\230\149\176\233\135\143\229\143\175\230\143\144\229\141\135"), 16)
  label:setPosition(233.75, addHeight - 12)
  label:setColor(ccc3(ed.colorToStr("#433b38")))
  heroLayer:addChild(label)
  self.heroLayer = heroLayer
  local classifyInfo = {
    cliprect = CCRectMake(0, 0, 467.5, addHeight),
    noshade = true,
    container = self.heroLayer,
    priority = -999
  }
  self.heroLayerDraglist = ed.draglist.create(classifyInfo)
  self.refreshCliprectConfig = {
    draglist = self.heroLayerDraglist
  }
  self:initHeroList()
end

function buyResourceBox:getShardUpLevelCost(goodsId)
  local costToHero = {}
  for k, v in pairs(ed.getDataTable("ShardAttribs")) do
    if v[1]["Item ID"] == goodsId then
      local timeStr = ed.getDataTable("ShardToHero")[k]["Online Time"]
      if timeStr then
        local onlineTime = ed.getTimeByYMDHMS(timeStr)
        if onlineTime <= ed.getServerTime() then
          local item = {}
          for _, vv in ipairs(v) do
            table.insert(item, vv["Item Amount"])
          end
          table.insert(costToHero, {
            heroId = ed.getDataTable("ShardToHero")[k]["Hero ID"],
            itemAmounts = item,
            shardId = k
          })
        end
      end
    end
  end
  local newTab = {}
  for i, v in ipairs(costToHero) do
    if ed.player.heroes[v.heroId] then
      local data = ed.player.heroes[v.heroId].data
      if data then
        table.insert(newTab, {
          heroId = v.heroId,
          itemAmounts = v.itemAmounts,
          shardLv = data._shard and data._shard._level or 0,
          shardId = v.shardId
        })
      end
    end
  end
  return newTab
end

function buyResourceBox:getHeroShardMaxLv(shardId)
  local maxLv = 0
  for k, v in pairs(ed.getDataTable("ShardAttribs")[shardId]) do
    maxLv = maxLv < v.Level and v.Level or maxLv
  end
  return maxLv
end

function buyResourceBox:getHeroShardCanUpLevel(data)
  local canUpLv = 0
  local addNum = self.params.item.count * self.num + ed.player:getEquipAmount(self.params.goodsId)
  local newLv = data.shardLv
  while 0 <= addNum do
    newLv = newLv + 1
    if data.itemAmounts[newLv] then
      addNum = addNum - data.itemAmounts[newLv]
      if 0 <= addNum then
        canUpLv = canUpLv + 1
      else
        break
      end
    else
      break
    end
  end
  return canUpLv
end

function buyResourceBox:initHeroList()
  local function createHeroIcon(data)
    local hero = ed.readhero.createIconByID(data.heroId, {state = "idle"})
    
    local icon = hero.icon
    icon:setScale(0.8)
    local maxLv = self:getHeroShardMaxLv(data.shardId)
    
    local function setAutoLableStr(localHero, self)
      local localData = localHero.heroData
      if localHero.autoLable then
        localHero.autoLable.node:removeFromParentAndCleanup(true)
      end
      local canUpLv = self:getHeroShardCanUpLevel(localData)
      local autoText = ed.ui.autoText.new()
      local str = T("  \229\183\178\230\187\161\231\186\167")
      if maxLv > localData.shardLv then
        str = string.format(ed.formatLevel("Lv.") .. "%d(<sprite src=UI/alpha/1080P/pvp/arrow_up.png scale=0.9><lable color=ccc3(17,136,19) >%d</lable>)", data.shardLv, canUpLv)
      end
      autoText:initParam({
        context = str,
        color = ccc3(67, 59, 56),
        maxWidth = 500,
        lineSpacing = 0,
        fontSize = 18
      })
      autoText:setVerticalCenter()
      local width, _ = autoText:getCurContentSize()
      autoText.node:setPosition(ccp(width / 2 - 43, -17))
      localHero.icon:addChild(autoText.node)
      localHero.autoLable = autoText
    end
    
    hero.setAutoLableStr = setAutoLableStr
    hero.heroData = data
    return hero
  end
  
  local long = ed.clamp(#self.shardUpLevelCost, 1, 5)
  local width = 467 / long
  local posx = width / 2
  if long == 2 then
    posx = 170
    width = 130
  end
  self.heroIcons = {}
  for _, v in ipairs(self.shardUpLevelCost) do
    local hero = createHeroIcon(v)
    local heroIcon = hero.icon
    heroIcon:setPosition(posx, 57)
    self.heroLayerDraglist.listLayer:addChild(heroIcon)
    posx = posx + width
    table.insert(self.heroIcons, hero)
  end
  self.heroLayerDraglist:initListWidth(#self.shardUpLevelCost * width)
  if 5 < long then
    self.heroLayerDraglist.listLayer:runAction(CCEaseExponentialInOut:create(CCMoveTo:create(0.9, ccp(-30, 0))))
  end
end

function buyResourceBox:refreshHeroList()
  for _, v in ipairs(self.heroIcons or {}) do
    v.setAutoLableStr(v, self)
  end
end
