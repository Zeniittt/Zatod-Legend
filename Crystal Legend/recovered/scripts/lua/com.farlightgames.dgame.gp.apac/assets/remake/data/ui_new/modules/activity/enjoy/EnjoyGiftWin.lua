local base = ed.ui.popwindow
local EnjoyGiftWin = newclass(base.mt)
ed.ui.EnjoyGiftWin = EnjoyGiftWin
local GEAR_BTN_POS_X = {
  [1] = {5},
  [2] = {0, 0},
  [3] = {
    -5,
    5,
    -5
  },
  [4] = {
    -12,
    0,
    0,
    -12
  }
}
local REWARD_ITEM_POS = {
  [1] = {
    line = {1},
    spaceX = 5,
    spaceY = 0,
    offsetX = -40,
    offsetY = 8
  },
  [2] = {
    line = {2},
    spaceX = 5,
    spaceY = 0,
    offsetX = -40,
    offsetY = 8
  },
  [3] = {
    line = {3},
    spaceX = 5,
    spaceY = 0,
    offsetX = -40,
    offsetY = 8
  },
  [4] = {
    line = {4},
    spaceX = 0,
    spaceY = 0,
    offsetX = 4,
    offsetY = 8
  },
  [5] = {
    line = {3, 2},
    spaceX = 5,
    spaceY = 0,
    offsetX = 0,
    offsetY = 0
  }
}
ed.UITool.registViewOpenFunc("EnjoyGiftWin", function(params)
  if nil == params._gifts then
    return
  end
  ed.ui.EnjoyGiftWin.create(params)
end)

function EnjoyGiftWin.create(params)
  local self = base.create("EnjoyGiftWin")
  setmetatable(self, EnjoyGiftWin.mt)
  local initBunchIndex, initGearIndex = self:initData(params)
  self:initUI()
  self:registerEvents()
  self:registerTouchHandlers()
  self:popWindow()
  self:refreshPage(initBunchIndex, initGearIndex)
  return self
end

function EnjoyGiftWin:initData(params)
  local notifyMsg = {
    _nearest_end_time = {},
    _new_gift_flag = {}
  }
  self.giftBunchIDArr = {}
  self.giftBunchDataMap = {}
  local serverTime = ed.getServerTime()
  local initBunchID, initGearIndex
  for i, v in ipairs(params._gifts) do
    if serverTime <= v._dead_line then
      local arr = self.giftBunchDataMap[v._bunch_group]
      if nil == arr then
        arr = {}
        self.giftBunchDataMap[v._bunch_group] = arr
        table.insert(self.giftBunchIDArr, v._bunch_group)
      end
      table.insert(arr, ed.copyProto(v))
      table.insert(notifyMsg._nearest_end_time, v._dead_line)
    end
  end
  table.sort(notifyMsg._nearest_end_time)
  ed.RechargeManager:setEnjoyGiftData(notifyMsg)
  FireEvent("RefreshRightTopButtons")
  self.curPageIndex = 1
  self.curGearIndex = 1
  self.pageIconArr = {}
  self.gearBtnArr = {}
  self.rewardItemArr = {}
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

function EnjoyGiftWin:getGiftDataArr(index)
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

function EnjoyGiftWin:initUI()
  local container = self.container
  local ui = {}
  self.ui = ui
  local readnode = ed.readnode.create(container, ui)
  readnode:addNode(ed.uieditor.EnjoyGiftWin)
  ed.setLabelStroke(self.ui.label_left_time, ed.toccc3(11809051), 1.5)
  self.ui.btn_left:setVisible(#self.giftBunchIDArr > 1)
  self.ui.btn_right:setVisible(#self.giftBunchIDArr > 1)
  local worthContentSize = self.ui.panel_worth:getContentSize()
  local worthDesLabel = ed.ui.gradientLabel.create({
    text = T("\232\182\133\229\128\188"),
    fontSize = 45,
    startColor = ed.toccc3(16775040),
    endColor = ed.toccc3(16775372),
    strokeSize = 2,
    strokeColor = ed.toccc3(15562794)
  })
  self.ui.panel_worth:addChild(worthDesLabel.node)
  worthDesLabel:setPosition(ccp(-worthDesLabel:getContentSize().width * 0.5, worthContentSize.height * 0.5 + 5))
  self.ui.worthValLabel = ed.ui.gradientLabel.create({
    text = T(""),
    fontName = ed.fontBold,
    fontSize = 59,
    startColor = ed.toccc3(16770972),
    endColor = ed.toccc3(16745314),
    strokeSize = 1.5,
    strokeColor = ed.toccc3(14828861)
  })
  self.ui.panel_worth:addChild(self.ui.worthValLabel.node)
  self.ui.worthValLabel:setPosition(ccp(0, 0))
  self.ui.priceNormalLabel = ed.ui.gradientLabel.create({
    text = T("\232\180\173\228\185\176"),
    fontName = ed.fontBold,
    fontSize = 30,
    startColor = ed.toccc3(15770624),
    endColor = ed.toccc3(12528659),
    strokeSize = 2,
    strokeColor = ed.toccc3(16645629)
  })
  self.ui.btn_buy:addChild(self.ui.priceNormalLabel.node)
  self.ui.priceNormalLabel:setPosition(ccp(0, self.ui.btn_buy:getContentSize().height * 0.5))
  self.ui.priceDisableLabel = ed.ui.gradientLabel.create({
    text = T("\232\180\173\228\185\176"),
    fontName = ed.fontBold,
    fontSize = 30,
    startColor = ed.toccc3(10325614),
    endColor = ed.toccc3(9000525),
    strokeSize = 2,
    strokeColor = ed.toccc3(15263976)
  })
  self.ui.btn_buy_disable:addChild(self.ui.priceDisableLabel.node)
  self.ui.priceDisableLabel:setPosition(ccp(0, self.ui.btn_buy_disable:getContentSize().height * 0.5))
  self:listenTimer(Timer:Always(0.3), function(...)
    self:updatePerHalfSecond()
  end)
  self:initPageDots()
end

function EnjoyGiftWin:initPageDots()
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

function EnjoyGiftWin:initGearBtns(...)
  local giftDataArr = self:getGiftDataArr(self.curPageIndex)
  local gearNum = #giftDataArr
  if 1 == gearNum then
    gearNum = 0
  end
  local centerIndex = gearNum % 2 == 0 and 0 or math.ceil(gearNum / 2)
  local containerSize = self.ui.panel_gear:getContentSize()
  local spaceY = 15
  local startY
  for i = 1, gearNum do
    local tab
    if i > #self.gearBtnArr then
      local lightImg = ed.createSprite("UI/alpha/1080P/impulsegift/button2.png")
      local darkImg = ed.createSprite("UI/alpha/1080P/impulsegift/button1.png")
      self.ui.panel_gear:addChild(lightImg)
      self.ui.panel_gear:addChild(darkImg)
      local darkSize = darkImg:getContentSize()
      local lightDiamondImg = ed.createSprite("UI/alpha/1080P/icon/diamond.png")
      lightImg:addChild(lightDiamondImg)
      lightDiamondImg:setPositionY(lightImg:getContentSize().height * 0.5)
      local darkDiamondImg = ed.createSprite("UI/alpha/1080P/icon/diamond.png")
      darkDiamondImg:setPositionY(darkSize.height * 0.5)
      darkImg:addChild(darkDiamondImg)
      local lightLabel = ed.createttf("", 21, ed.fontBold)
      lightLabel:setColor(ed.toccc3(16747052))
      ed.setLabelStroke(lightLabel, ed.toccc3(16776940), 1)
      lightImg:addChild(lightLabel)
      lightLabel:setPositionY(lightImg:getContentSize().height * 0.5)
      local darkLabel = ed.createttf("", 21, ed.fontBold)
      darkLabel:setColor(ed.toccc3(16776346))
      ed.setLabelStroke(darkLabel, ed.toccc3(15881230), 1)
      darkImg:addChild(darkLabel)
      darkLabel:setPositionY(darkSize.height * 0.5)
      local redImg = ed.createSprite("UI/alpha/1080P/common/digit_red_tag_bg.png")
      darkImg:addChild(redImg)
      local redSize = redImg:getContentSize()
      redImg:setPosition(ccp(darkSize.width - redSize.width * 0.5, darkSize.height - redSize.height * 0.5))
      tab = {
        isEnable = true,
        darkImg = darkImg,
        lightImg = lightImg,
        redImg = redImg,
        lightLabel = lightLabel,
        darkLabel = darkLabel,
        lightDiamondImg = lightDiamondImg,
        darkDiamondImg = darkDiamondImg
      }
      table.insert(self.gearBtnArr, tab)
      local curIndex = i
      self:btRegisterButtonClick({
        button = darkImg,
        key = "gearDark" .. curIndex,
        force = true,
        clickHandler = function()
          self:onGearBtnEvent(curIndex)
        end
      })
    else
      tab = self.gearBtnArr[i]
      tab.isEnable = true
      tab.lightImg:setVisible(true)
      tab.darkImg:setVisible(true)
    end
    local giftTable = ed.getDataTable("ImpulseGift")[giftDataArr[i]._cfg_gift_id]
    if nil ~= giftTable then
      local priceType = giftTable["Price Type"]
      local isDiamond = priceType == ed.RechargeManager.PriceType.Diamond
      tab.lightDiamondImg:setVisible(isDiamond)
      tab.darkDiamondImg:setVisible(isDiamond)
      if isDiamond then
        tab.lightLabel:setString(giftTable.Price)
        tab.darkLabel:setString(giftTable.Price)
      elseif priceType == ed.RechargeManager.PriceType.GiftTicket then
        local priceStr = T("%s\232\180\173\228\185\176", ed.RechargeManager:getCostDisplayByCNYCost(giftTable.Price))
        tab.lightLabel:setString(priceStr)
        tab.darkLabel:setString(priceStr)
      end
    end
    ed.layout.horizontalSortNode({
      tab.lightDiamondImg,
      tab.lightLabel
    }, {0, 0}, tab.lightImg:getContentSize().width * 0.5)
    ed.layout.horizontalSortNode({
      tab.darkDiamondImg,
      tab.darkLabel
    }, {0, 0}, tab.darkImg:getContentSize().width * 0.5)
    local height = tab.darkImg:getContentSize().height
    if nil == startY then
      startY = (height + spaceY) * gearNum - spaceY
      local oldSize = self.ui.panel_gear:getContentSize()
      local newSize = CCSizeMake(oldSize.width, startY)
      self.ui.panel_gear:setContentSize(newSize)
      self.ui.panel_gear:setPositionY(self.ui.panel_gear:getPositionY() + (oldSize.height - newSize.height) * 0.5)
    end
    local pos = ccp(containerSize.width * 0.5 + GEAR_BTN_POS_X[gearNum][i], startY - height * 0.5)
    tab.lightImg:setPosition(pos)
    tab.darkImg:setPosition(pos)
    startY = startY - (height + spaceY)
  end
  for i = gearNum + 1, #self.gearBtnArr do
    local tab = self.gearBtnArr[i]
    tab.isEnable = false
    tab.lightImg:setVisible(false)
    tab.darkImg:setVisible(false)
  end
end

function EnjoyGiftWin:refreshPage(index, gearIndex)
  self.curPageIndex = index
  local isLeftRed = false
  local isRightRed = false
  for i, v in ipairs(self.pageIconArr) do
    self.pageIconArr[i].lightImg:setVisible(i == self.curPageIndex)
    self.pageIconArr[i].darkImg:setVisible(i ~= self.curPageIndex)
    if i ~= self.curPageIndex then
      local giftArr = self:getGiftDataArr(i)
      for _, giftData in ipairs(giftArr) do
        if giftData._view_flag == 0 then
          if i < self.curPageIndex then
            isLeftRed = true
            break
          end
          if i > self.curPageIndex then
            isRightRed = true
          end
          break
        end
      end
    end
  end
  self.ui.img_left_red:setVisible(isLeftRed)
  self.ui.img_right_red:setVisible(isRightRed)
  self:initGearBtns()
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

function EnjoyGiftWin:refreshGear(index)
  self.curGearIndex = index
  local giftArr = self:getGiftDataArr(self.curPageIndex)
  local giftData = giftArr[self.curGearIndex]
  if 0 == giftData._view_flag then
    ed.RechargeNetwork:sendViewEnjoyGift(giftData._gift_id)
    giftData._view_flag = 1
  end
  for i, v in ipairs(self.gearBtnArr) do
    if v.isEnable then
      v.lightImg:setVisible(i == self.curGearIndex)
      v.darkImg:setVisible(i ~= self.curGearIndex)
      v.redImg:setVisible(giftArr[i]._view_flag == 0)
    end
  end
  local worthContentSize = self.ui.panel_worth:getContentSize()
  self.ui.worthValLabel:setString(T("+%d%%", giftData._discount))
  self.ui.worthValLabel:setPosition(ccp(worthContentSize.width * 0.5, worthContentSize.height * 0.5))
  local lab_wid = self.ui.worthValLabel:getContentSize().width
  if 200 < lab_wid then
    self.ui.worthValLabel.node:setScale(180 / lab_wid)
  end
  local giftTable = ed.getDataTable("ImpulseGift")[giftData._cfg_gift_id]
  if nil ~= giftTable then
    local priceType = giftTable["Price Type"]
    local isDiamond = priceType == ed.RechargeManager.PriceType.Diamond
    self.ui.img_buy_diamond:setVisible(isDiamond)
    self.ui.img_disable_diamond:setVisible(isDiamond)
    if isDiamond then
      self.ui.priceNormalLabel:setString(giftTable.Price)
      self.ui.priceDisableLabel:setString(giftTable.Price)
    elseif priceType == ed.RechargeManager.PriceType.GiftTicket then
      local priceStr = T("%s\232\180\173\228\185\176", ed.RechargeManager:getCostDisplayByCNYCost(giftTable.Price))
      self.ui.priceNormalLabel:setString(priceStr)
      self.ui.priceDisableLabel:setString(priceStr)
    end
    local scale = math.min(180 / self.ui.priceNormalLabel:getContentSize().width, 1)
    self.ui.priceNormalLabel.node:setScale(scale)
    self.ui.priceDisableLabel.node:setScale(scale)
  end
  local isBought = giftData._has_buy == 1
  self.ui.btn_buy:setVisible(not isBought)
  self.ui.btn_buy_disable:setVisible(isBought)
  if isBought then
    ed.layout.horizontalSortNode({
      self.ui.img_disable_diamond,
      self.ui.priceDisableLabel.node
    }, {0, 0}, self.ui.btn_buy_disable:getContentSize().width * 0.5)
  else
    ed.layout.horizontalSortNode({
      self.ui.img_buy_diamond,
      self.ui.priceNormalLabel.node
    }, {0, 0}, self.ui.btn_buy:getContentSize().width * 0.5)
  end
  ed.setLabelString(self.ui.label_left_time, T("\229\137\169\228\189\153%s", self:time2dhms(630)))
  self.ui.label_left_time:limitWidthByScale(100)
  self:updatePerHalfSecond()
  self.ui.panel_reward:removeAllChildrenWithCleanup(true)
  local contentSize = self.ui.panel_reward:getContentSize()
  local posCfg = REWARD_ITEM_POS[#giftData._rewards]
  local rewardIndex = 1
  local startY = -999999
  for line, num in ipairs(posCfg.line) do
    local startX = -999999
    for index = 1, num do
      local item = self:createRewardItem(rewardIndex, giftData._rewards[rewardIndex], isBought)
      self.ui.panel_reward:addChild(item)
      local itemSize = item:getContentSize()
      if startX == -999999 then
        startX = posCfg.offsetX + contentSize.width * 0.5 - ((itemSize.width + posCfg.spaceX) * num - posCfg.spaceX) * 0.5
      end
      if startY == -999999 then
        startY = posCfg.offsetY + contentSize.height * 0.5 + ((itemSize.height + posCfg.spaceY) * #posCfg.line - posCfg.spaceY) * 0.5 - itemSize.height
      end
      item:setPosition(ccp(startX + (itemSize.width + posCfg.spaceX) * (index - 1), startY + (itemSize.height + posCfg.spaceY) * (line - 1)))
      rewardIndex = rewardIndex + 1
    end
  end
end

function EnjoyGiftWin:createRewardItem(index, data, isBought)
  local container = CCLayer:create()
  local flowerBg = ed.createSprite("UI/alpha/1080P/impulsegift/bg_item.png")
  local contentSize = flowerBg:getContentSize()
  container:setContentSize(contentSize)
  container:addChild(flowerBg)
  local centerPos = ccp(contentSize.width * 0.5, contentSize.height * 0.5)
  flowerBg:setPosition(centerPos)
  local rewardIcon = ed.createItemIcon({
    id = data._id,
    type = data._type,
    amount = data._amount
  })
  rewardIcon:setScale(0.85)
  container:addChild(rewardIcon)
  rewardIcon:setPosition(centerPos)
  if isBought then
    local maskImg = ed.createSprite("UI/alpha/1080P/common/frame/equip_frame_mask.png")
    container:addChild(maskImg, 1)
    maskImg:setScale(0.85)
    maskImg:setPosition(centerPos)
    local soldoutImg = ed.createSprite("UI/alpha/1080P/newshop/over_tf.png")
    local soldout_lab = ed.createLabelTTF(T("\229\148\174\231\189\132"), 20, ed.fontBold)
    ed.setLabelColor(soldout_lab, ed.toccc3(16735838))
    ed.setLabelStroke(soldout_lab, ed.toccc3(2826261), 1.5)
    soldout_lab:limitWidthByScale(56)
    soldoutImg:addChild(soldout_lab)
    ed.layout.centerInParent(soldout_lab)
    soldoutImg:setScale(0.85)
    soldoutImg:setRotation(-14)
    container:addChild(soldoutImg, 2)
    soldoutImg:setPosition(centerPos)
  end
  self:btRegisterButtonClick({
    button = rewardIcon,
    key = "baseReward" .. index,
    force = true,
    clickHandler = function()
      ed.ui.packageDetailWin.create({
        id = data._id,
        count = data._amount,
        type = data._type
      }):popWindow()
    end
  })
  return container
end

function EnjoyGiftWin:onGearBtnEvent(index)
  if self.curGearIndex == index then
    return
  end
  self:refreshGear(index)
end

function EnjoyGiftWin:time2dhms(t)
  local str = ""
  if 86400 <= t then
    local d = math.floor(t / 86400)
    local h = math.floor((t - d * 86400) / 3600)
    str = tostring(d) .. T("\229\164\169")
    if 0 < h then
      str = str .. tostring(h) .. T("\230\151\182")
    end
  elseif 3600 <= t then
    local h = math.floor(t / 3600)
    local m = math.floor((t - h * 3600) / 60)
    str = tostring(h) .. T("\230\151\182")
    if 0 < m then
      str = str .. tostring(m) .. T("\229\136\134")
    end
  else
    local m = math.floor(t / 60)
    local s = math.floor(t % 60)
    if 0 < m then
      str = tostring(m) .. T("\229\136\134")
    end
    if 0 < s or m == 0 then
      str = str .. tostring(s) .. T("\231\167\146")
    end
  end
  return str
end

function EnjoyGiftWin:updatePerHalfSecond()
  local giftData = self:getGiftDataArr(self.curPageIndex)[self.curGearIndex]
  local serverTime = ed.getServerTime()
  local timeStr = self:time2dhms(math.max(giftData._dead_line - serverTime, 0))
  ed.setLabelString(self.ui.label_left_time, T("\229\137\169\228\189\153%s", timeStr))
end

function EnjoyGiftWin:onBuyEvent(...)
  local giftData = self:getGiftDataArr(self.curPageIndex)[self.curGearIndex]
  ed.RechargeManager:doRechargeEnjoyGift(giftData._cfg_gift_id, giftData._gift_id)
end

function EnjoyGiftWin:registerTouchHandlers()
  self:btRegisterOutClick({
    area = self.ui.panel_touch,
    key = "out_click",
    clickHandler = function()
      self:destroy()
    end,
    extraCheckHandler = function(x, y)
      if ed.containsPoint(self.ui.panel_gear, x, y) then
        return false
      else
        return true
      end
    end
  })
  self:btRegisterButtonClick({
    button = self.ui.btn_close,
    key = "btn_close",
    clickHandler = function()
      self:destroy({skipAnim = true})
    end,
    force = true,
    pressScale = 0.95,
    normalScale = 1
  })
  self:btRegisterButtonClick({
    button = self.ui.btn_left,
    key = "btn_left",
    clickHandler = function()
      if 1 == self.curPageIndex then
        return
      end
      self:refreshPage(self.curPageIndex - 1)
    end,
    force = true,
    pressScale = 0.95,
    normalScale = 1
  })
  self:btRegisterButtonClick({
    button = self.ui.btn_right,
    key = "btn_right",
    clickHandler = function()
      if #self.giftBunchIDArr == self.curPageIndex then
        return
      end
      self:refreshPage(self.curPageIndex + 1)
    end,
    force = true,
    pressScale = 0.95,
    normalScale = 1
  })
  self:btRegisterButtonClick({
    button = self.ui.btn_buy,
    key = "btn_buy",
    clickHandler = function()
      self:onBuyEvent()
    end,
    force = true,
    pressScale = 0.95,
    normalScale = 1
  })
end

function EnjoyGiftWin:registerEvents()
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
    end
  end)
end
