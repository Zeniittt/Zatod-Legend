local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.repeatRewardWindow = class
local newHei = ed.display.halfFixedHeight * 2 * 0.82
local list_top_y = 375 + newHei

local function refreshClipRect(self)
  local function handler(dt)
    xpcall(function()
      if tolua.isnull(self.container) then
        self.layerScheduler:unscheduleScriptEntry(self.refreshClipRectID)
        
        return
      end
      local scalex = self.container:getScale()
      local scaley = scalex
      if 1 < scaley then
        scaley = scaley * 0.96
      end
      self.draglist:refreshClipRect2(scalex, scaley)
    end, EDDebug)
  end
  
  return handler
end

class.refreshClipRect = refreshClipRect

local function playListLayerAnim(self, lh, ey)
  local ll = self.draglist:getList()
  local x, y = ll:getPosition()
  local bp = ccp(x, y)
  self.draglist:initListHeight(lh)
  ll:setPosition(bp)
  local ep = ccp(x, ey)
  ll:stopAllActions()
  if not self.skipLootAnim then
    local move = CCMoveTo:create(0.2, ep)
    move = CCEaseBackOut:create(move)
    ll:runAction(move)
  else
    ll:setPosition(ep)
  end
  if ll:getPositionY() > 0 then
    self.draglist:refreshShade()
  end
end

class.playListLayerAnim = playListLayerAnim

local function createEndTag(self, index)
  local widhtWin = ed.display.winSize.width
  local heightWin = ed.display.winSize.height
  local newWid = ed.display.halfFixedWidth
  local newHei = ed.display.halfFixedHeight
  local oh = list_top_y
  local layer = self.draglist:getList()
  local lh = self.listHeight
  lh = lh + 80
  local endTag = CCSprite:create()
  endTag:setPosition(ccp(self.widhtWin / 2, oh - lh - 109))
  layer:addChild(endTag)
  endTag:setVisible(false)
  local clipLayer = CCLayer:create()
  endTag:addChild(clipLayer)
  clipLayer:setClipRect(CCRectMake(-250, 133, 500, 500))
  local node = ed.createFcaNode("eff_UI_pvp_light")
  node:setPosition(0, 113)
  ed.getCurrentScene():addFca(node)
  clipLayer:addChild(node)
  local posX = self.widhtWin / 2 - endTag:getContentSize().width / 2
  local lineUi = {}
  local ui_info = {
    {
      t = "Sprite",
      base = {
        name = "line_bg",
        res = "UI/alpha/1080P/campaign/campaign_detail_line_3_fa.png"
      },
      layout = {
        position = ccp(self.widhtWin / 2 - posX, 132)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "line_1",
        res = "UI/alpha/1080P/campaign/campaign_detail_line_3_lin.png",
        capInsets = CCRectMake(20, 0, 20, 0)
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(15 - posX, 132)
      },
      config = {
        scaleSize = CCSizeMake((self.widhtWin - 30) / 2 - 17, 14)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "line_2",
        res = "UI/alpha/1080P/campaign/campaign_detail_line_3_lin.png",
        capInsets = CCRectMake(20, 0, 20, 0)
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(self.widhtWin - 15 - posX, 132)
      },
      config = {
        scaleSize = CCSizeMake((self.widhtWin - 30) / 2 - 17, 14),
        scalexy = {x = -1, y = 1}
      }
    }
  }
  local readNode = ed.readnode.create(endTag, lineUi)
  readNode:addNode(ui_info, 9)
  local sweep = ed.createSprite("UI/alpha/1080P/campaign/campaign_sweep.png")
  sweep:setPosition(endTag:getContentSize().width / 2, 165)
  endTag:addChild(sweep)
  local light = ed.createSprite("UI/alpha/1080P/campaign/campaign_sweep_light_2.png")
  light:setPosition(endTag:getContentSize().width / 2, 210)
  endTag:addChild(light, 9)
  lh = lh + sweep:getContentSize().height / 2 - 35
  self.listHeight = lh
  self:playListLayerAnim(lh, math.max(lh - oh, 0))
  if self.skipLootAnim then
    endTag:setVisible(true)
    self:createLootAnim(index + 1)
  else
    local array = CCArray:create()
    local delay = CCDelayTime:create(0.5)
    local func = CCCallFunc:create(function()
      xpcall(function()
        endTag:setVisible(true)
        endTag:setScale(1.5)
      end, EDDebug)
    end)
    local scale = CCScaleTo:create(0.2, 1)
    scale = CCEaseBackOut:create(scale)
    local func2 = CCCallFunc:create(function()
      xpcall(function()
        self:createLootAnim(index + 1)
      end, EDDebug)
    end)
    array:addObject(delay)
    array:addObject(func)
    array:addObject(scale)
    array:addObject(func2)
    local s = CCSequence:create(array)
    endTag:runAction(s)
  end
end

class.createEndTag = createEndTag

local function createLoot(self, index)
  local oh = list_top_y
  local layer = self.draglist:getList()
  local list = self.lootList[index]
  if not self.listHeight then
    self.listHeight = 0
  end
  local lh = self.listHeight
  if index == #self.lootList then
    lh = lh + 20
  end
  local title = {}
  local ui_info = {
    {
      t = "Label",
      base = {
        name = "title",
        text = index == #self.lootList - 1 and T("\233\162\157\229\164\150\229\165\150\229\138\177:") or T("\231\172\172%d\230\136\152:", index),
        size = 15
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(40, oh - lh - 22 + 7.5)
      },
      config = {
        color = index <= #self.lootList - 2 and ed.toccc3(16776423) or ed.toccc3(15249746)
      }
    }
  }
  local readNode = ed.readnode.create(layer, title)
  readNode:addNode(ui_info, 9)
  title.title:setShadow(ccc3(ed.colorToStr("#141313")), ccp(0, 1))
  if index == #self.lootList then
    title.title:setString(T("\230\177\135\230\128\187:"))
  else
    ed.adaptLabel(title.title, {maxWidth = 82, minScale = 0.8})
  end
  lh = lh + 15
  local widIcon = math.floor((self.widhtWin - 120) / 75)
  self.widIcons = widIcon
  local lootBg = {}
  local lootList = {}
  local loots = list.loots
  for i = 1, math.ceil(#loots / widIcon) do
    local iconBg = ed.createScale9Sprite("UI/alpha/1080P/campaign/campaign_sweep_reward_bg.png", CCRectMake(250, 0, 87, 1))
    iconBg:setContentSize(CCSizeMake(self.widhtWin - 10, 80))
    iconBg:setPosition(ccp(self.widhtWin / 2, oh - lh - 80 * (i - 1) + 2))
    layer:addChild(iconBg)
    table.insert(lootBg, iconBg)
    if not self.skipLootAnim then
      iconBg:setVisible(false)
    end
    iconBg:setOpacity(index == #self.lootList and 0 or 255)
  end
  local posLeft = 100
  if widIcon > #loots and index == #self.lootList then
    posLeft = 100 - (widIcon - #loots) * 38 + 50
    title.title:setPositionX(10 + (widIcon - #loots) * 38)
  end
  for i = 1, #loots do
    local icon, add_icon
    icon = ed.createItemIcon(loots[i])
    icon:setPosition(ccp(250 + 75 * ((i - 1) % widIcon) - posLeft, oh - lh - 80 * (math.ceil(i / widIcon) - 1) + 3))
    if icon then
      icon:setScale(0.8)
      layer:addChild(icon)
      local config = {
        icon = icon,
        info = loots[i]
      }
      if add_icon then
        layer:addChild(add_icon)
        config.add_icon = add_icon
      end
      table.insert(lootList, config)
      if not self.skipLootAnim then
        icon:setVisible(false)
        if add_icon then
          add_icon:setVisible(false)
        end
      end
    end
  end
  if #loots == 0 then
    local iconBg = ed.createScale9Sprite("UI/alpha/1080P/campaign/campaign_sweep_reward_bg.png", CCRectMake(250, 0, 87, 1))
    iconBg:setContentSize(CCSizeMake(self.widhtWin - 10, 80))
    iconBg:setPosition(ccp(self.widhtWin / 2, oh - lh + 2))
    layer:addChild(iconBg)
    table.insert(lootBg, iconBg)
    local label = ed.createttf(T("\230\173\164\230\172\161\230\137\171\232\141\161\230\156\170\232\142\183\229\190\151\231\137\169\229\147\129"), 15)
    label:setAnchorPoint(ccp(0.5, 0.5))
    label:setPosition(ccp(self.widhtWin / 2, oh - lh + 2))
    ed.setLabelColor(label, ed.toccc3(16776423))
    layer:addChild(label)
    table.insert(lootList, {
      icon = label,
      info = {}
    })
    if not self.skipLootAnim then
      iconBg:setVisible(false)
      label:setVisible(false)
    end
    iconBg:setOpacity(index == #self.lootList and 0 or 255)
  end
  lh = lh + 80 * math.max(0, math.floor((#loots - 1) / widIcon)) + 70
  self.listHeight = lh
  self:playListLayerAnim(lh, math.max(lh - oh + 30, 0))
  self.loots = self.loots or {}
  self.loots[index] = lootList
  self.lootBg = self.lootsBg or {}
  self.lootBg[index] = lootBg
  self:playLootAnim(index)
end

class.createLoot = createLoot

local function playLootAnim(self, index)
  if self.skipLootAnim then
    self:createLootAnim(index + 1)
    if index == #self.lootList then
      self.ui.close_btn:setVisible(true)
      if self.stage and ed.stageType(self.stage) ~= "act" then
        self.ui.sweep_btn:setVisible(true)
        self.ui.confirm_btn:setVisible(true)
      end
    end
    return
  end
  local icons = self.loots[index]
  local bg = self.lootBg[index]
  local od = 0.5
  local delay = 0.1
  local di = 0
  for i = 1, #icons do
    if (i - 1) % self.widIcons == 0 then
      local node = bg[math.floor((i - 1) / self.widIcons) + 1]
      self:playNodeAnim(node, delay)
      di = di + 1
    end
    local node = icons[i].icon
    if node then
      if i == #icons then
        self:playNodeAnim(node, od + delay * di, function()
          local d = CCDelayTime:create(0.1)
          local f = CCCallFunc:create(function()
            xpcall(function()
              self:createLootAnim(index + 1)
              if index == #self.lootList then
                self.ui.close_btn:setVisible(true)
                if self.stage and ed.stageType(self.stage) ~= "act" then
                  self.ui.sweep_btn:setVisible(true)
                  self.ui.confirm_btn:setVisible(true)
                end
              end
            end, EDDebug)
          end)
          self.mainLayer:runAction(CCSequence:createWithTwoActions(d, f))
        end)
      else
        self:playNodeAnim(node, od + delay * di)
      end
      di = di + 1
    else
      print("node = nil  i =", i)
    end
  end
end

class.playLootAnim = playLootAnim

local function playNodeAnim(self, node, delay, handler)
  delay = 0
  if self.skipLootAnim then
    if handler then
      handler()
    end
    return
  end
  local d = CCDelayTime:create(delay)
  local f1 = CCCallFunc:create(function()
    xpcall(function()
      node:setVisible(true)
      node:setScale(node:getScale() + 0.5)
    end, EDDebug)
  end)
  local a = CCScaleTo:create(0.2, node:getScale())
  a = CCEaseBackOut:create(a)
  a = CCSequence:createWithTwoActions(f1, a)
  local s = CCSequence:createWithTwoActions(d, a)
  if not handler then
    node:runAction(s)
  else
    local func = CCCallFunc:create(function()
      xpcall(function()
        handler()
      end, EDDebug)
    end)
    s = CCSequence:createWithTwoActions(s, func)
    node:runAction(s)
  end
end

class.playNodeAnim = playNodeAnim

local function createLootAnim(self, index)
  if self.endPlayLootAnim then
    return
  end
  if index == #self.lootList then
    self:createEndTag(index)
    return
  end
  if index == #self.lootList + 1 then
    self:setAnimEnd()
    self:createLoot(index - 1)
    return
  end
  self:createLoot(index)
end

class.createLootAnim = createLootAnim

local function getLootidInList(id)
  local j = id % 1000
  local i = (id - j) / 1000
  return i, j
end

local function doPressInList(self)
  local function handler(x, y)
    for i = 1, #self.loots do
      local loots = self.loots[i]
      
      for j = 1, #loots do
        local loot = loots[j]
        local icon = loot.icon
        local id = loot.info.id
        local type = loot.info.type
        if (id or type) and ed.containsPoint(icon, x, y) then
          return loot, y
        end
      end
    end
  end
  
  return handler
end

class.doPressInList = doPressInList

local function cancelPressInList(self)
  local function handler(x, y, loot, oldy)
    local id = loot.info.id
    
    local type = loot.info.type
    if math.abs(oldy - y) < 20 then
      ed.ui.packageDetailWin.create({id = id, type = type}):popWindow()
    end
  end
  
  return handler
end

class.cancelPressInList = cancelPressInList

local function createListLayer(self)
  local info = {
    cliprect = CCRectMake(0, 68, self.widhtWin, self.heightWin - 44 - 60),
    container = self.ui.sweepBg,
    priority = -300,
    doPressIn = self:doPressInList(),
    cancelPressIn = self:cancelPressInList(),
    noshade = true
  }
  self.draglist = ed.draglist.create(info)
  self.draglist:setTouchEnabled(false)
end

class.createListLayer = createListLayer

local function playTitleLightAnim(self)
  local light = self.ui.light
  light:setVisible(true)
  local rtt = CCRotateBy:create(5, 360)
  rtt = CCRepeatForever:create(rtt)
  light:runAction(rtt)
end

class.playTitleLightAnim = playTitleLightAnim

local function playTitleAnim(self)
  local title = self.ui.title
  title:setVisible(true)
  title:setScale(2)
  local s = CCScaleTo:create(0.2, 1)
  s = CCEaseBackOut:create(s)
  local func = CCCallFunc:create(function()
    xpcall(function()
      self:playTitleLightAnim()
      self:createLootAnim(1)
    end, EDDebug)
  end)
  local sequence = CCSequence:createWithTwoActions(s, func)
  title:runAction(sequence)
end

class.playTitleAnim = playTitleAnim

local function doOutLayerTouch(self)
  local isPress, isPressClose
  
  local function handler(event, x, y)
    if event == "began" then
      if not ed.containsPoint(self.ui.sweepBg, x, y) then
        isPressClose = true
      end
      isPress = true
    elseif event == "ended" then
      if isPress then
        self.skipLootAnim = true
      end
      if isPressClose and not ed.containsPoint(self.ui.sweepBg, x, y) and self.endPlayLootAnim == true then
        self:destroy()
      end
      isPress = nil
      isPressClose = nil
    end
  end
  
  return handler
end

class.doOutLayerTouch = doOutLayerTouch

local function doCloseButtonTouch(self)
  local isPress
  
  local function handler(event, x, y)
    if not self.ui.close_btn:isVisible() then
      return
    end
    if event == "began" then
      isPress = true
      if ed.containsPoint(self.ui.close_btn, x, y) then
        self.ui.close_btn:setScale(0.65)
      end
      if ed.containsPoint(self.ui.sweep_btn, x, y) then
        self.ui.sweep_btn:setScale(0.95)
      end
      if ed.containsPoint(self.ui.confirm_btn, x, y) then
        self.ui.confirm_btn:setScale(0.95)
      end
    elseif event == "ended" then
      if isPress then
        self.ui.close_btn:setScale(0.7)
        self.ui.sweep_btn:setScale(1)
        self.ui.confirm_btn:setScale(1)
        if ed.containsPoint(self.ui.close_btn, x, y) or ed.containsPoint(self.ui.confirm_btn, x, y) then
          self:destroy()
        end
        if ed.containsPoint(self.ui.sweep_btn, x, y) and self.ui.sweep_btn:isVisible() then
          self:doClickSweep(self.times)
        end
      end
      isPress = nil
    end
  end
  
  return handler
end

class.doCloseButtonTouch = doCloseButtonTouch

local function setAnimEnd(self)
  self.endPlayLootAnim = true
  self:setTargetItemDisplay()
  self.draglist:setTouchEnabled(true)
end

class.setAnimEnd = setAnimEnd

local function getLootItemAmount(self, itemId)
  if not itemId then
    return 0
  end
  print("getLootItemAmount", itemId)
  if not self.lootList[#self.lootList] then
    return 0
  end
  local loots = self.lootList[#self.lootList].loots
  if not loots then
    return 0
  end
  for i = 1, #loots do
    local item = loots[i]
    if item.id == itemId then
      return item.amount
    end
  end
  return 0
end

class.getLootItemAmount = getLootItemAmount

local function setTargetItemDisplay(self)
  self.ui.itemTargetBg:setVisible(self.getWayItemId > 0)
  if self.getWayItemId > 0 then
    if not self.childBg then
      self.childBg = ed.readequip.createIcon(self.getWayItemId)
      self.childBg:setScale(0.7)
      self.ui.itemTargetBg:addChild(self.childBg)
    end
    local posX = self.ui.itemTargetBg:getContentSize().width / 2
    local posY = self.ui.itemTargetBg:getContentSize().height - self.childBg:getContentSize().height / 2 + 10
    self.childBg:setPosition(ccp(posX, posY))
    local amount = ed.player.equip_qunty[self.getWayItemId] or 0
    if amount < self.getWayItemNeed then
      text = string.format("<lable color=ccc3(255,108,108) strokeColor=ccc3(85,26,12) strokeSize=2>%d</lable>/%d", amount, self.getWayItemNeed)
    else
      text = string.format("%d/%d", amount, self.getWayItemNeed)
    end
    if self.autoText then
      self.autoText.node:removeFromParentAndCleanup(true)
    end
    self.autoText = ed.ui.autoText.new()
    self.autoText:initParam({
      context = text,
      fontSize = 16,
      color = ccc3(255, 251, 231),
      strokeColor = ccc3(39, 37, 36),
      strokeSize = 2
    })
    self.ui.itemTargetBg:addChild(self.autoText.node)
    local width, height = self.autoText:getCurContentSize()
    self.autoText.node:setPosition(ccp(posX - width / 2, posY - 38))
    ed.setString(self.ui.sweep_times, T("\230\156\172\230\172\161\230\137\171\232\141\161:") .. self.getWayItemAddAmount)
    ed.setLabelStroke(self.ui.sweep_times, ccc3(27, 21, 29), 2)
  end
end

class.setTargetItemDisplay = setTargetItemDisplay

function class:doMainLayerTouch()
  local outLayerTouch = self:doOutLayerTouch()
  local closeTouch = self:doCloseButtonTouch()
  
  local function handler(event, x, y)
    xpcall(function()
      if not self.endPlayLootAnim then
        outLayerTouch(event, x, y)
      else
        closeTouch(event, x, y)
        outLayerTouch(event, x, y)
      end
    end, EDDebug)
    return true
  end
  
  return handler
end

local function destroy(self)
  self.layerScheduler = self.container:getScheduler()
  self.refreshClipRectID = self.layerScheduler:scheduleScriptFunc(self:refreshClipRect(), 0, false)
  ed.netreply.sweep = nil
  local s = CCScaleTo:create(0.2, 0)
  s = CCEaseBackIn:create(s)
  base.destroy(self)
  local func = CCCallFunc:create(function()
    xpcall(function()
      if self.destroyHandler then
        self.destroyHandler()
      end
      self.mainLayer:setVisible(false)
    end, EDDebug)
  end)
  local sequence = CCSequence:createWithTwoActions(s, func)
  self.container:runAction(sequence)
end

class.destroy = destroy

local function show(self, showEaseBackOut)
  if showEaseBackOut then
    self.container:setScale(0)
    local s = CCScaleTo:create(0.2, 1)
    s = CCEaseBackOut:create(s)
    local func = CCCallFunc:create(function()
      xpcall(function()
        self:createListLayer()
        self.mainLayer:setTouchEnabled(true)
        self:createLootAnim(1)
      end, EDDebug)
    end)
    local sequence = CCSequence:createWithTwoActions(s, func)
    self.container:runAction(sequence)
  else
    if self.mainLayer and not tolua.isnull(self.mainLayer) then
      self.mainLayer:setTouchEnabled(true)
    end
    self.skipLootAnim = false
    self.draglist:clearList()
    self.listHeight = 0
    self.endPlayLootAnim = false
    self:createLootAnim(1)
  end
  self.getWayItemAddAmount = self:getLootItemAmount(self.getWayItemId)
end

class.show = show

local function overlapping(data)
  local newTbas = {}
  local newItem = {}
  local i = 1
  for k, v in pairs(data or {}) do
    local key = (v.id or "") .. (v.type or "nil")
    if newTbas[key] then
      newItem[newTbas[key]].amount = newItem[newTbas[key]].amount + v.amount
    else
      newItem[i] = {
        id = v.id,
        type = v.type,
        amount = v.amount
      }
      newTbas[key] = i
      i = i + 1
    end
  end
  return newItem
end

local function createLootList(lootList)
  local allLootList = {}
  allLootList.loots = {}
  local newLootList = {}
  for i, v in ipairs(lootList) do
    newLootList[i] = v
    newLootList[i].loots = newLootList[i].loots or {}
    if v.money and v.money > 0 then
      table.insert(newLootList[i].loots, 1, {
        type = "gold",
        amount = v.money
      })
    end
    if v.exp and 0 < v.exp then
      table.insert(newLootList[i].loots, 1, {
        type = "playerexp",
        amount = v.exp
      })
    end
    for e, m in ipairs(newLootList[i].loots) do
      table.insert(allLootList.loots, m)
    end
  end
  allLootList.loots = overlapping(allLootList.loots)
  table.insert(lootList, allLootList)
  return lootList
end

local function doClickSweep(self, times)
  self.repeatInfo = self:getRepeatInformation()
  ed.playEffect(ed.sound.deo.common_popup_window)
  if times > self.repeatInfo.cLimit then
    ed.showToast(T("\232\175\165\229\133\179\229\141\161\232\191\155\229\133\165\230\172\161\230\149\176\229\183\178\232\190\190\230\156\172\230\151\165\228\184\138\233\153\144"))
    return
  end
  if self.sendSweepTime then
    local time = ed.getSystemTime()
    if time - self.sendSweepTime < 1.5 then
      return
    end
  end
  if self.stageInfo and self.stageInfo.power > ed.player:getVitality() then
    ed.ui.buyVitalityBox.create()
    return
  end
  if times > self.repeatInfo.tLimit then
    self:doPaySweepConfirm(times)
    return
  end
  self:doSendSweep("free", times)()
  self.sendSweepTime = ed.getSystemTime()
end

class.doClickSweep = doClickSweep

local function getLeftTimes(self)
  local s = ed.elite2NormalStage(self.stage)
  if ed.stageType(self.stage) == "elite" then
    self.stageInfo.countLimit = ed.parameter.default_elite_sweep_times
  else
    return ed.parameter.default_normal_sweep_times
  end
  local count = self.stageInfo.countLimit - ((ed.player.stage_limit or {})[s] or 0)
  return count
end

class.getLeftTimes = getLeftTimes

local function getRepeatInformation(self)
  local info = self.stageInfo
  local star = info.star
  local power = info.power
  local powerLimit = math.floor(ed.player:getVitality() / power)
  local countLimit
  if info.countLimit == 0 then
    countLimit = 999
  else
    countLimit = self:getLeftTimes()
  end
  local timeLimit = ed.player:getSweepTimes()
  local dt = ed.parameter.default_normal_sweep_times
  local limit
  if timeLimit == 0 then
    limit = dt
  else
    limit = math.min(timeLimit, dt)
  end
  limit = math.min(countLimit, limit)
  if self.stage and ed.stageType(self.stage) == "elite" then
    limit = ed.parameter.default_elite_sweep_times
    limit = math.min(countLimit, limit)
    local vitality = ed.player:getVitality() or 0
    if vitality < self.stageInfo.power then
    else
      limit = math.min(math.floor(vitality / self.stageInfo.power), limit)
    end
  elseif self.stage and ed.stageType(self.stage) == "act" then
    limit = ed.exerciseNetWork:getQueryActStageReply()._user_left_time
    limit = math.min(countLimit, limit)
  else
    local vitality = ed.player:getVitality() or 0
    limit = math.floor(vitality / self.stageInfo.power)
    if limit >= ed.parameter.default_normal_sweep_times then
      limit = ed.parameter.default_normal_sweep_times
    elseif vitality < self.stageInfo.power then
      limit = ed.parameter.default_normal_sweep_times
    end
  end
  local repeatInfo = {
    star = star,
    pLimit = powerLimit,
    cLimit = countLimit,
    tLimit = timeLimit,
    limit = limit
  }
  return repeatInfo
end

class.getRepeatInformation = getRepeatInformation

local function doPaySweepConfirm(self, times)
  local price = self:getSweepPrice(times)
  ed.showConfirmDialog({
    text = T("\230\137\171\232\141\161\229\136\184\228\184\141\232\182\179\239\188\140\232\191\155\232\161\140\230\137\171\232\141\161\233\156\128\232\166\129\232\138\177\232\180\185 %d \233\146\187\231\159\179.\n\230\152\175\229\144\166\231\187\167\231\187\173\239\188\159", price),
    rightHandler = self:doSendSweep("pay", times)
  })
end

class.doPaySweepConfirm = doPaySweepConfirm

local function getSweepPrice(self, times)
  local price = ed.parameter.pay_sweep_unit_price
  price = price * times
  return price
end

class.getSweepPrice = getSweepPrice

local function doSendSweep(self, type, times)
  local function handler()
    if times < 1 then
      return
    end
    local cost = self:getSweepPrice(times) or 0
    if type == "pay" and cost > ed.player._rmb then
      ed.showHandyDialog("toRecharge")
      return
    end
    self:doSweep(type, times)
  end
  
  return handler
end

class.doSendSweep = doSendSweep

local function doSweep(self, type, times)
  ed.netdata.sweep = {
    type = type,
    times = times,
    power = self.stageInfo.power,
    cost = type == "pay" and self:getSweepPrice(times) or 0,
    stage = self.stage
  }
  ed.netreply.sweep = self:doSendSweepReply()
  local msg = ed.upmsg.sweep_stage()
  msg._type = type == "free" and "sweep_with_ticket" or "sweep_with_rmb"
  msg._stageid = self.stage
  msg._times = times
  self.addTime = times
  ed.send(msg, "sweep_stage")
end

class.doSweep = doSweep

local function doSendSweepReply(self)
  local function handler(info)
    if self.addTimes then
      self.addTimes = self.addTimes + self.times
    end
    if ed.stageType(self.stage) == "elite" then
      self.initcLimit = self:getLeftTimes()
      if self.initcLimit == 0 then
        self:setSweepLabel(string.format(T("\230\151\160\230\179\149\230\137\171\232\141\161")))
      end
    end
    local lootList = ed.ui.stagedetail:readSweepReply(info)
    self.lootList = createLootList(lootList)
    self:show(false)
    self:refreshSweepLabel()
  end
  
  return handler
end

class.doSendSweepReply = doSendSweepReply

local function refreshSweepLabel(self)
  self.initcLimit = self:getLeftTimes()
  if ed.stageType(self.stage) == "elite" then
    self.initTime = ed.parameter.default_elite_sweep_times
  else
    self.initTime = ed.parameter.default_normal_sweep_times
  end
  self.times = math.max(math.floor(ed.player:getVitality() / self.stageInfo.power), 1)
  self.times = math.min(self.times, self.initcLimit)
  if self.initcLimit and self.initcLimit == 0 then
    self:setSweepLabel(string.format(T("\230\151\160\230\179\149\230\137\171\232\141\161")))
    return
  end
  if self.isOnce then
    self.times = 1
    self:setSweepLabel(string.format(T("\230\137\171\232\141\161%s\230\172\161"), 1))
    return
  end
  if self.stageInfo.power > ed.player:getVitality() then
    if ed.stageType(self.stage) == "elite" then
      self:setSweepLabel(string.format(T("\230\137\171\232\141\161%s\230\172\161"), self.initcLimit))
    else
      self:setSweepLabel(string.format(T("\230\137\171\232\141\161%s\230\172\161"), self.initTime))
    end
    return
  end
  self:setSweepLabel(string.format(T("\230\137\171\232\141\161%s\230\172\161"), self.times))
end

class.refreshSweepLabel = refreshSweepLabel

local function setSweepLabel(self, str)
  ed.setLabelString(self.ui.sweep_label, str)
  self.ui.sweep_label:limitWidthByScale(95)
end

class.setSweepLabel = setSweepLabel

local function addEventListener(self)
  self:listenEvent("ResourceNumChange", function(type)
    if type == "vitality" then
      self:refreshSweepLabel()
    end
  end)
end

class.addEventListener = addEventListener

local function create(lootList, param)
  local self = base.create("stageReward", {notBlurBg = true})
  setmetatable(self, class.mt)
  self.lootList = createLootList(lootList)
  if param then
    self.stage = param.stageId
    self.times = param.times or 1
    self.getWayItemId = param.getWayItemId or 0
    self.getWayItemNeed = param.getWayItemNeed or 0
    self.getWayItemAddAmount = 0
    self.stageInfo = ed.ui.stagedetail.getStageInformation(self.stage)
    self.isOnce = param.isOnce
  else
    self.times = 1
    self.getWayItemId = 0
    self.getWayItemNeed = 0
  end
  self.initTime = self.times
  self.mainLayer:registerScriptTouchHandler(self:doMainLayerTouch(), false, -300, true)
  local container = CCLayer:create()
  self.container = container
  self.mainLayer:addChild(container)
  local widhtWin = ed.display.winSize.width
  local heightWin = ed.display.winSize.height
  local newWid = ed.display.halfFixedWidth * 2
  local newHei = ed.display.halfFixedHeight * 2
  local frameWid = 0.6
  local frameHei = 0.82
  local sise = 960
  if widhtWin ~= sise then
    local sca = sise / widhtWin
    frameWid = frameWid * sca
  end
  sise = 540
  if heightWin ~= sise then
    local sca = sise / heightWin
    frameHei = frameHei * sca
  end
  list_top_y = 380
  local frameBgX = (widhtWin - widhtWin * frameWid) / 2
  local frameBgY = (heightWin - heightWin * frameHei) / 2
  self.widhtWin = widhtWin * frameWid
  self.heightWin = heightWin * frameHei
  local container, ui = ed.editorui(ed.uieditor.stageRewardWin, {
    container = self.container
  })
  self.ui = ui
  ui.sweepBg:setContentSize(CCSizeMake(widhtWin * frameWid, heightWin * frameHei))
  ui.sweepBg:setAnchorPoint(ccp(0, 0))
  ui.sweepBg:setPosition(ccp(frameBgX, frameBgY))
  ui.title_bg:setPosition(ccp(widhtWin * frameWid / 2, heightWin * frameHei - 18))
  ui.title:setPosition(ccp(widhtWin * frameWid / 2, heightWin * frameHei - 20))
  ui.star_line1:setPosition(ccp(widhtWin * frameWid / 2 - 100, heightWin * frameHei - 20))
  ui.star_line2:setPosition(ccp(widhtWin * frameWid / 2 + 100, heightWin * frameHei - 20))
  ui.close_btn:setPosition(ccp(widhtWin * frameWid - 12, heightWin * frameHei - 12))
  ui.image_line:setPosition(ccp(widhtWin * frameWid / 2, frameHei + 65))
  ui.sweep_btn:setPosition(ccp(widhtWin * frameWid / 2 - 90, frameHei + 35))
  ui.confirm_btn:setPosition(ccp(widhtWin * frameWid / 2 + 90, frameHei + 35))
  local bgWidth = ui.itemTargetBg:getContentSize().width
  ui.itemTargetBg:setPosition(ccp(frameBgX + widhtWin * frameWid + bgWidth / 2 + 5, frameBgY + heightWin * frameHei * 0.7))
  ui.itemTargetBg:setVisible(false)
  ui.close_btn_img:setPosition(ccp(28, 28))
  ui.sweep_btn:setVisible(false)
  ui.confirm_btn:setVisible(false)
  if self.stageInfo then
    local vc = self.stageInfo.power * self.times
    if vc > ed.player:getVitality() then
      self.times = math.max(math.floor(ed.player:getVitality() / self.stageInfo.power), 1)
    end
    self.repeatInfo = self:getRepeatInformation()
    if ed.stageType(self.stage) == "elite" then
      self.initcLimit = self:getLeftTimes()
    end
    if ed.stageType(self.stage) == "elite" then
      self.initTime = ed.parameter.default_elite_sweep_times
    else
      self.initTime = ed.parameter.default_normal_sweep_times
    end
    if self.initcLimit and self.initcLimit == 0 then
      self:setSweepLabel(string.format(T("\230\151\160\230\179\149\230\137\171\232\141\161")))
    elseif self.stageInfo and self.stageInfo.power > ed.player:getVitality() then
      if ed.stageType(self.stage) == "elite" then
        self:setSweepLabel(string.format(T("\230\137\171\232\141\161%s\230\172\161"), self.initcLimit))
      else
        self:setSweepLabel(string.format(T("\230\137\171\232\141\161%s\230\172\161"), self.initTime))
      end
    else
      self:setSweepLabel(string.format(T("\230\137\171\232\141\161%s\230\172\161"), self.times))
    end
  else
    self:setSweepLabel(string.format(T("\230\137\171\232\141\161%s\230\172\161"), self.times))
  end
  if self.isOnce then
    self.times = 1
    self:setSweepLabel(string.format(T("\230\137\171\232\141\161%s\230\172\161"), 1))
  end
  self:addEventListener()
  self:show(true)
  return self
end

class.create = create
