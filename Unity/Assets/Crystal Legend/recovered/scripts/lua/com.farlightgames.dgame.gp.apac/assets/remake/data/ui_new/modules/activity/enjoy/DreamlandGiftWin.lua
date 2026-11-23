local base = ed.ui.popwindow
local DreamlandGiftWin = newclass(base.mt)
ed.ui.DreamlandGiftWin = DreamlandGiftWin
ed.ui.DreamlandGiftWin.isViewShowing = false
ed.UITool.registViewOpenFunc("DreamlandGiftWin", function(params)
  if nil == params._gifts then
    return
  end
  if ed.ui.DreamlandGiftWin.isViewShowing then
    FireEvent("DreamlandGiftDataRefresh", params)
  else
    ed.ui.DreamlandGiftWin.create(params)
  end
end)

function DreamlandGiftWin.create(params)
  local self = base.create("DreamlandGiftWin")
  setmetatable(self, DreamlandGiftWin.mt)
  self:registerOnEnterHandler("enter_flag", function()
    ed.ui.DreamlandGiftWin.isViewShowing = true
  end)
  self:registerOnExitHandler("exit_flag", function()
    ed.ui.DreamlandGiftWin.isViewShowing = false
  end)
  self.curPageIndex = 1
  self.curGearIndex = 1
  self.pageIconArr = {}
  self.rewardItemArr = {}
  local initBunchIndex, initGearIndex = self:initData(params)
  self:initUI()
  self:registerEvents()
  self:registerTouchHandlers()
  self:popWindow()
  self:refreshPage(initBunchIndex, initGearIndex)
  return self
end

function DreamlandGiftWin:initData(params)
  local notifyMsg = {
    _dreamland_end_time = {},
    _new_gift_flag = {}
  }
  self.giftBunchIDArr = {}
  self.giftBunchDataMap = {}
  local giftTable = ed.getDataTable("ImpulseGift")
  local serverTime = ed.getServerTime()
  local initBunchID, initGearIndex
  for i, v in ipairs(params._gifts) do
    local giftTableItem = giftTable[v._cfg_gift_id]
    local bunchGroupId = giftTableItem["Bunch Group"]
    local arr = self.giftBunchDataMap[bunchGroupId]
    if nil == arr then
      arr = {}
      self.giftBunchDataMap[bunchGroupId] = arr
      table.insert(self.giftBunchIDArr, bunchGroupId)
    end
    table.insert(arr, ed.copyProto(v))
    if 0 == v._has_buy then
      table.insert(notifyMsg._dreamland_end_time, v._dead_line)
    end
  end
  for _, arr in pairs(self.giftBunchDataMap) do
    table.sort(arr, function(a, b)
      return a._cfg_gift_id < b._cfg_gift_id
    end)
  end
  table.sort(notifyMsg._dreamland_end_time)
  ed.RechargeManager:setDreamlandGiftData(notifyMsg)
  FireEvent("RefreshRightTopButtons")
  for bunchIndex, bunchID in ipairs(self.giftBunchIDArr) do
    local giftArr = self.giftBunchDataMap[bunchID]
    for gearIndex, v in ipairs(giftArr) do
      if ed.isElementInTable(v._gift_id, params._new_gifts) then
        return bunchIndex, gearIndex
      end
    end
  end
  return 1, nil
end

function DreamlandGiftWin:getGiftDataArr(index)
  local id = self.giftBunchIDArr[index]
  if nil == id then
    return {}
  end
  local arr = self.giftBunchDataMap[id]
  if nil == arr then
    return {}
  end
  return arr
end

function DreamlandGiftWin:initUI()
  local container = self.container
  local ui = {}
  self.ui = ui
  local readnode = ed.readnode.create(container, ui)
  readnode:addNode(ed.uieditor.DreamlandGiftWin)
  ed.setLabelStroke(self.ui.label_limit, ed.toccc3(14176529), 1)
  ed.setLabelString(self.ui.label_limit, T("\233\153\144\232\180\173\n\228\184\128\230\172\161"))
  local titleContentSize = self.ui.panel_title:getContentSize()
  local titleDesLabel = ed.ui.gradientLabel.create({
    text = T("\230\162\166\229\162\131\228\184\187\229\174\176 \231\165\158\230\173\166\233\153\141\228\184\180"),
    fontSize = 40,
    fontName = ed.fontBold,
    startColor = ed.toccc3(16777205),
    endColor = ed.toccc3(16774801),
    strokeSize = 2.5,
    strokeColor = ed.toccc3(5480996)
  })
  self.ui.panel_title:addChild(titleDesLabel.node)
  titleDesLabel:setPosition(ccp(titleContentSize.width * 0.5, titleContentSize.height * 0.5))
  self.rewardDraglist = ed.UITool.createDraglist(self.ui.panel_reward, {
    doPressIn = self:getRewardPressHander(),
    doClickIn = self:getRewardClickHander(),
    cancelPressIn = self:getRewardCancelPressIn(),
    priority = -300
  })
  self.rewardUIArr = {}
  self.refreshCliprectConfig = {
    draglist = self.rewardDraglist
  }
  local buyDesPanel = self.ui.panel_buy_des:getContentSize()
  local buyDesLabel = ed.ui.autoText.new()
  buyDesLabel:initParam({
    context = T("\232\180\173\228\185\176\229\143\175\232\142\183\229\190\151\230\162\166\229\162\131\229\188\186\229\138\155\232\139\177\233\155\132 <lable color=ccc3(255,252,231) fontSize=f16 strokeSize=1 strokeColor=0x3c2215>\231\165\158\231\129\181\230\173\166\229\163\171</lable> \229\143\138\229\133\182\229\133\187\230\136\144\233\129\147\229\133\183"),
    fontSize = 15,
    color = ed.toccc3(6703123),
    lineSpacing = 4,
    maxWidth = buyDesPanel.width
  })
  self.ui.panel_buy_des:addChild(buyDesLabel.node)
  local desWidth, desHeight = buyDesLabel:getCurContentSize()
  buyDesLabel.node:setPosition(ccp((buyDesPanel.width - desWidth) * 0.5, buyDesPanel.height * 0.5))
  ed.setLabelStroke(self.ui.label_left_time, ed.toccc3(16763993), 1)
  ed.setLabelStroke(self.ui.label_worth_des, ed.toccc3(15408952), 1)
  ed.setLabelShadow(self.ui.label_worth_des, ed.toccc3(9970701), ccp(0, 2))
  self.ui.label_worth_des:setSkewX(10)
  self.priceNormalLabel = ed.ui.autoText.new()
  self.ui.btn_buy:addChild(self.priceNormalLabel.node)
  local priceDisableLabel = ed.ui.gradientLabel.create({
    text = T("\229\183\178\232\142\183\229\190\151"),
    fontName = ed.fontBold,
    fontSize = 22,
    startColor = ed.toccc3(16514806),
    endColor = ed.toccc3(230538715),
    strokeSize = 1.5,
    strokeColor = ed.toccc3(7350021)
  })
  local disableBuySize = self.ui.btn_buy_disable:getContentSize()
  priceDisableLabel:setPosition(ccp(disableBuySize.width * 0.5, disableBuySize.height * 0.5 + 3))
  self.ui.btn_buy_disable:addChild(priceDisableLabel.node)
  self.worthValLabel1 = ed.ui.gradientLabel.create({
    text = T("+"),
    fontName = ed.fontBold,
    fontSize = 67.5,
    startColor = ed.toccc3(16449398),
    endColor = ed.toccc3(16776409),
    strokeSize = 2.5,
    strokeColor = ed.toccc3(13724435),
    shadowColor = ed.toccc3(9970701),
    shadowOffset = ccp(0, -3.5)
  })
  self.ui.panel_worth:addChild(self.worthValLabel1.node)
  self.worthValLabel1:setPosition(ccp(0, self.worthValLabel1:getContentSize().height * 0.5 - 4.375 - 4))
  self.worthValLabel1.node:setSkewX(10)
  self.worthValLabel2 = ed.ui.gradientLabel.create({
    text = T("00%"),
    fontName = ed.fontBold,
    fontSize = 50,
    startColor = ed.toccc3(16449398),
    endColor = ed.toccc3(16776409),
    strokeSize = 2.5,
    strokeColor = ed.toccc3(13724435),
    shadowColor = ed.toccc3(9970701),
    shadowOffset = ccp(0, -3.5)
  })
  self.ui.panel_worth:addChild(self.worthValLabel2.node)
  self.worthValLabel2:setPosition(ccp(0, self.worthValLabel2:getContentSize().height * 0.5 - 4))
  self.worthValLabel2.node:setSkewX(10)
  self:listenTimer(Timer:Always(0.2), function(...)
    self:updatePerHalfSecond()
  end)
  self:createHeroFca()
  self:initPageDots()
end

function DreamlandGiftWin:initPageDots()
  local dotNum = #self.giftBunchIDArr
  local spaceX = 0
  local startX = 0
  local containerSize = self.ui.panel_page_dot:getContentSize()
  local startY = containerSize.height * 0.5
  for i = 1, dotNum do
    local tab
    if i > #self.pageIconArr then
      local lightImg = ed.createSprite("UI/alpha/1080P/impulsegift/dot2.png")
      local darkImg = ed.createSprite("UI/alpha/1080P/impulsegift/dot1.png")
      self.ui.panel_page_dot:addChild(lightImg)
      self.ui.panel_page_dot:addChild(darkImg)
      tab = {darkImg = darkImg, lightImg = lightImg}
      table.insert(self.pageIconArr, tab)
    else
      tab = self.pageIconArr[i]
      tab.lightImg:setVisible(true)
      tab.darkImg:setVisible(true)
    end
    local width = tab.lightImg:getContentSize().width
    if 0 == startX then
      local totalWidth = dotNum * width + (dotNum - 1) * spaceX
      startX = (containerSize.width - totalWidth) * 0.5
    end
    local pos = ccp(startX + width * 0.5, startY)
    tab.lightImg:setPosition(pos)
    tab.darkImg:setPosition(pos)
    startX = startX + width + spaceX
  end
  for i = dotNum + 1, #self.pageIconArr do
    local tab = self.pageIconArr[i]
    tab.lightImg:setVisible(false)
    tab.darkImg:setVisible(false)
  end
end

function DreamlandGiftWin:refreshPage(index, gearIndex)
  self.curPageIndex = index
  local isLeftRed = false
  local isRightRed = false
  for i, v in ipairs(self.pageIconArr) do
    self.pageIconArr[i].lightImg:setVisible(i == self.curPageIndex)
    self.pageIconArr[i].darkImg:setVisible(i ~= self.curPageIndex)
  end
  local targetIndex = gearIndex
  if nil == gearIndex then
    targetIndex = 1
    local giftDataArr = self:getGiftDataArr(self.curPageIndex)
    for i, v in ipairs(giftDataArr) do
      if 0 == v._has_buy then
        targetIndex = i
        break
      end
    end
  end
  self:refreshGear(targetIndex)
end

function DreamlandGiftWin:refreshGear(index)
  self.curGearIndex = index
  local giftArr = self:getGiftDataArr(self.curPageIndex)
  local giftData = giftArr[self.curGearIndex]
  if 0 == giftData._view_flag then
    ed.RechargeNetwork:sendViewEnjoyGift(giftData._gift_id)
    giftData._view_flag = 1
  end
  local giftTableItem = ed.getDataTable("ImpulseGift")[giftData._cfg_gift_id]
  if nil == giftTableItem then
    return
  end
  self.ui.btn_last:setVisible(self.curGearIndex > 1)
  self.ui.btn_next:setVisible(self.curGearIndex < #giftArr)
  ed.setLabelString(self.ui.label_last_des, T("\231\172\172%d\230\156\159", self.curGearIndex - 1))
  ed.setLabelString(self.ui.label_next_des, T("\231\172\172%d\230\156\159", self.curGearIndex + 1))
  local worthContentSize = self.ui.panel_worth:getContentSize()
  self.worthValLabel1:setString(T("+%d", math.floor(giftData._discount / 100 + 0.001)))
  ed.layout.horizontalSortNode({
    self.worthValLabel1.node,
    self.worthValLabel2.node
  }, {0, 0}, worthContentSize.width * 0.5)
  local priceType = giftTableItem["Price Type"]
  local isBought = giftData._has_buy == 1
  self.ui.btn_buy:setVisible(not isBought)
  self.ui.btn_buy_disable:setVisible(isBought)
  if not isBought then
    self.priceNormalLabel:initParam({
      context = T("<lable startColor=0xfbfef6 endColor=0xfff4aa strokeSize=1.5 strokeColor=0xb85723>%s\232\167\163\233\148\129</lable>", ed.RechargeManager:getCostDisplayByCNYCost(giftTableItem.Price)),
      fontName = ed.fontBold,
      fontSize = 22
    })
    local buyBtnSize = self.ui.btn_buy:getContentSize()
    local priceDesWidth, priceDesHeight = self.priceNormalLabel:getCurContentSize()
    self.priceNormalLabel.node:setPosition(ccp((buyBtnSize.width - priceDesWidth) * 0.5, (buyBtnSize.height + priceDesHeight - self.priceNormalLabel:getFirstLineHeight()) * 0.5))
  end
  self:updatePerHalfSecond()
  local rewardNum = 0
  for i, v in ipairs(giftData._rewards or {}) do
    if nil == self.rewardUIArr[i] then
      local container, ui = self:createRewardItem(v)
      self.rewardDraglist:addItem(container)
      container:setPosition(self:getRewardItemPos(i))
      table.insert(self.rewardUIArr, ui)
    else
      self:refreshRewardItem(self.rewardUIArr[i], v)
    end
    rewardNum = rewardNum + 1
  end
  self.rewardDraglist:initListHeight(self:getRewardListHeight(rewardNum))
  for i = rewardNum + 1, #self.rewardUIArr do
    self.rewardUIArr[i].container:setVisible(false)
  end
  self.rewardDraglist.listLayer:stopAllActions()
  self.rewardDraglist.listLayer:setPosition(ccp(0, -self.rewardDraglist.height * 1.5))
  self.rewardDraglist.listLayer:runAction(CCEaseExponentialOut:create(CCMoveTo:create(1, ccp(0, 0))))
  local isLock = false
  for i, v in ipairs(giftArr) do
    if ed.isElementInTable(v._cfg_gift_id, giftTableItem["Previous Gift ID"]) then
      isLock = v._has_buy == 0
      if isLock then
        break
      end
    end
  end
  self.ui.img_buy_lock:setVisible(isLock)
end

function DreamlandGiftWin:getRewardItemPos(i)
  local itemHeight = 61
  local itemSpace = 4
  local topPadding = 5
  local size = self.ui.panel_reward:getContentSize()
  local ox = size.width / 2
  local oy = size.height
  local dy = oy - topPadding - (i - 0.5) * itemHeight - (i - 1) * itemSpace
  return ccp(ox, dy)
end

function DreamlandGiftWin:getRewardListHeight(num)
  local itemHeight = 61
  local itemSpace = 4
  local topPadding = 5
  return topPadding + (itemHeight + itemSpace) * num - itemSpace
end

function DreamlandGiftWin:createRewardItem(data)
  local ui = {}
  local container = CCLayer:create()
  ui.container = container
  local bg = ed.createSprite("UI/alpha/1080P/impulsegift/impulsegift_dreamland/gift_bg.png")
  container:addChild(bg)
  ui.bg = bg
  local contentSize = bg:getContentSize()
  local nameLabel = ed.createLabelTTF(T(""), 14)
  ui.bg:addChild(nameLabel)
  ed.setLabelColor(nameLabel, ccc3(78, 42, 29))
  nameLabel:setAnchorPoint(ccp(0, 0.5))
  nameLabel:setPosition(60, contentSize.height - 14)
  ui.nameLabel = nameLabel
  local numLabel = ed.createLabelTTF(T(""), 14)
  ui.bg:addChild(numLabel)
  ed.setLabelColor(numLabel, ccc3(255, 252, 231))
  ed.setLabelStroke(numLabel, ed.toccc3(3880473), 1)
  numLabel:setAnchorPoint(ccp(0, 0.5))
  numLabel:setPosition(60, 15)
  ui.numLabel = numLabel
  self:refreshRewardItem(ui, data)
  return container, ui
end

function DreamlandGiftWin:refreshRewardItem(ui, data)
  if nil ~= ui.rewardIcon then
    ui.rewardIcon:removeFromParentAndCleanup(true)
    ui.rewardIcon = nil
  end
  local contentSize = ui.bg:getContentSize()
  local iconScale = 0.65
  local rewardIcon = ed.createItemIcon({
    id = data._id,
    type = data._type
  })
  rewardIcon:setScale(iconScale)
  ui.bg:addChild(rewardIcon)
  rewardIcon:setPosition(rewardIcon:getContentSize().width * 0.5 * iconScale, contentSize.height * 0.5 + 1.5)
  ui.rewardIcon = rewardIcon
  ui.rewardData = {
    id = data._id,
    type = data._type,
    count = data._amount
  }
  local typeLwr = string.lower(data._type)
  local nameStr
  if typeLwr == "hero" then
    nameStr = ed.lookupDataTable("Unit", "Display Name", data._id)
  elseif typeLwr == "legend_equip" or typeLwr == "legendequip" then
    nameStr = ed.lookupDataTable("LegendEquip", "Equip Name", data._id)
  else
    nameStr = ed.readequip.value(data._id, "Name")
  end
  ed.setLabelString(ui.nameLabel, nameStr or typeLwr)
  ui.nameLabel:limitWidthByScale(120)
  ed.setLabelString(ui.numLabel, "x" .. data._amount)
end

function DreamlandGiftWin:onGearBtnEvent(index)
  if self.curGearIndex == index then
    return
  end
  self:refreshGear(index)
end

function DreamlandGiftWin:time2dhms(t)
  local str = ""
  if 86400 <= t then
    local d = math.floor(t / 86400)
    local h = math.floor((t - d * 86400) / 3600)
    local m = math.floor((t - d * 86400 - h * 3600) / 60)
    str = T("%d\229\164\169%d\230\151\182%d\229\136\134", d, h, m)
  else
    local h = math.floor(t / 3600)
    local m = math.floor((t - h * 3600) / 60)
    local s = math.floor(t % 60)
    str = T("%d\230\151\182%d\229\136\134%d\231\167\146", h, m, s)
  end
  return str
end

function DreamlandGiftWin:updatePerHalfSecond()
  local giftData = self:getGiftDataArr(self.curPageIndex)[self.curGearIndex]
  local leftTime = giftData._dead_line - ed.getServerTime()
  if leftTime <= 0 or giftData._has_buy == 1 then
    self.ui.img_left_time:setVisible(false)
  else
    self.ui.img_left_time:setVisible(true)
    local timeStr = self:time2dhms(math.max(leftTime, 0))
    ed.setLabelString(self.ui.label_left_time, T("\229\137\169\228\189\153%s", timeStr))
    ed.layout.horizontalSortNode({
      self.ui.icon_left_time,
      self.ui.label_left_time
    }, {5, 0}, self.ui.img_left_time:getContentSize().width * 0.5)
  end
end

function DreamlandGiftWin:onBuyEvent(...)
  if self.ui.img_buy_lock:isVisible() then
    ed.showToast(T("\233\156\128\232\166\129\232\180\173\228\185\176\229\137\141\231\189\174\231\164\188\229\140\133"))
    return
  end
  local giftData = self:getGiftDataArr(self.curPageIndex)[self.curGearIndex]
  ed.RechargeManager:doRechargeEnjoyGift(giftData._cfg_gift_id, giftData._gift_id)
end

function DreamlandGiftWin:registerTouchHandlers()
  self:btRegisterOutClick({
    area = self.ui.panel_touch,
    key = "out_click",
    clickHandler = function()
      self:destroy()
    end,
    extraCheckHandler = function(x, y)
      if ed.containsPoint(self.ui.btn_close, x, y) then
        return false
      else
        return true
      end
    end
  })
  ed.UITool.registerBtn(self, "btn_close", function()
    self:destroy()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_last", function()
    if self.curGearIndex <= 1 then
      return
    end
    self:refreshGear(self.curGearIndex - 1)
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_next", function()
    local giftDataArr = self:getGiftDataArr(self.curPageIndex)
    if self.curGearIndex >= #giftDataArr then
      return
    end
    self:refreshGear(self.curGearIndex + 1)
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_buy", function()
    self:onBuyEvent()
  end, {pressScale = 0.95})
end

function DreamlandGiftWin:registerEvents()
  self:listenEvent("DreamlandGiftDataRefresh", function(data)
    if nil == data._gifts or 0 == #data._gifts then
      return
    end
    self:initData(data)
    self:initPageDots()
    self.curPageIndex = ed.clamp(self.curPageIndex, 1, #self.giftBunchIDArr)
    local giftDataArr = self:getGiftDataArr(self.curPageIndex)
    self.curGearIndex = ed.clamp(self.curGearIndex, 1, #giftDataArr)
    self:refreshPage(self.curPageIndex, self.curGearIndex)
  end)
  self:listenEvent("EnjoyGiftBuyReply", function(data)
    if data._result == "success" then
      for _, arr in pairs(self.giftBunchDataMap) do
        for _, v in ipairs(arr) do
          if v._gift_id == data._gift_id then
            v._has_buy = 1
            break
          end
        end
      end
      self:refreshGear(self.curGearIndex)
      ed.RechargeManager:checkTriggerNewGif()
    end
  end)
end

function DreamlandGiftWin:createHeroFca()
  if self.heroPuppet then
    self.heroPuppet:removeFromParentAndCleanup(true)
    self.heroPuppet = nil
  end
  local puppet, cha = ed.readhero.getActor(34, "Idle", true, false, 0, false)
  local row = ed.getDataTable("Puppet")[cha]
  local scale = row.Scale
  local wscale = row["Window Scale"]
  if wscale ~= 0 then
    scale = scale * wscale
  end
  puppet:setScale(scale * 1.35)
  self.ui.panel_hero:addChild(puppet, 10)
  puppet:setPosition(0, 0)
  self:addFca(puppet)
  self.heroPuppet = puppet
end

function DreamlandGiftWin:getRewardPressHander(...)
  return function(x, y)
    for index, cellUI in ipairs(self.rewardUIArr) do
      if cellUI.container:isVisible() and ed.containsPoint(cellUI.rewardIcon, x, y) then
        return cellUI, index
      end
    end
  end
end

function DreamlandGiftWin:getRewardClickHander(...)
  return function(x, y, cellUI, index)
    if not (not tolua.isnull(cellUI.container) and ed.containsPoint(cellUI.rewardIcon, x, y)) or cellUI.rewardData.type == "hero" then
    else
      ed.ui.packageDetailWin.create(cellUI.rewardData):popWindow()
    end
  end
end

function DreamlandGiftWin:getRewardCancelPressIn(...)
  return function(x, y, cellUI)
  end
end
