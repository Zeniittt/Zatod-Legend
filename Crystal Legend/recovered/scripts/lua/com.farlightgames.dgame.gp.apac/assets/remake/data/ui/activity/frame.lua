local base = ed.ui.basenode
local class = newclass(base.mt)
ed.ui.activityBase = class
local initDraglistHeight = 300
local loadLayer = {}
local scope = {}

function class.createRewardsIcon(config, data)
  local x, y = 35, 0
  local dt = 40
  local parent = CCNode:create()
  local self = {}
  local types = {
    money = "UI/alpha/HVGA/task_gold_icon_2.png",
    rmb = "UI/alpha/HVGA/task_rmb_icon_2.png",
    crystal = "UI/alpha/HVGA/warschool/resource_crystal.png",
    iron = "UI/alpha/HVGA/warschool/resource_iron.png",
    wood = "UI/alpha/HVGA/warschool/resource_wood.png",
    captain_avatar_frame = "UI/alpha/1080P/common/handbook_icon_lock.png"
  }
  if data then
    local text = ed.createLabelWithFontInfo(data, "op_act_red")
    text:setPosition(ccp(x, y))
    text:setAnchorPoint(ccp(0.5, 0.5))
    parent:addChild(text)
    x = x + 25
  end
  for k, item in pairs(config) do
    dt = 40
    local type = item.type
    local scale = item.scale or 1
    local amount = item.amount
    local id = item.id
    local node = CCNode:create()
    local equip = ""
    local label = ""
    if type == "rand_soul" then
      equip = ed.readequip.getUnknownIcon(1, id)
    elseif type == "item" then
      equip = ed.readequip.createIcon(id)
    elseif type == "medal" then
      local path = ed.lookupDataTable("Medal", "Picture", tonumber(id))
      equip = ed.createSprite(path)
      equip:setScale(0.5)
    else
      equip = ed.createSprite(types[type])
    end
    equip:setAnchorPoint(ccp(0, 0))
    equip:setScale(scale)
    node:addChild(equip)
    local size = equip:getContentSize()
    if amount then
      label = ed.createLabelWithFontInfo(T("X%s", amount), "op_act_red")
      label:setHorizontalAlignment(kCCTextAlignmentLeft)
      label:setAnchorPoint(ccp(0, 0.5))
      label:setPosition(ccp(x + size.width * scale + 2, y))
      parent:addChild(label)
      dt = dt + label:getContentSize().width + 5
    end
    node:setAnchorPoint(ccp(0, 0.5))
    node:setContentSize(CCSizeMake(size.width * scale, size.height * scale))
    node:setPosition(ccp(x, y))
    parent:addChild(node)
    x = x + dt
    local temp = {icon = node, data = item}
    table.insert(self, temp)
  end
  return parent, self
end

function class.createFlyLayer(config)
  local showPanel
  local config = config or {}
  local parent = config.parent
  local index = config.index
  local type = config.type
  local id = config.id
  if "rmb" == type then
    showPanel = ed.readequip.getDetailCard("Diamond")
  elseif "money" == type then
    showPanel = ed.readequip.getDetailCard("Gold")
  elseif "rand_soul" == type then
    showPanel = ed.readequip.getDetailCard("rand_soul")
  elseif "medal" == type then
    local info = {}
    info.medal = ed.lookupDataTable("Medal", "Name", tonumber(id))
    info.ps = ed.lookupDataTable("Medal", "Description", tonumber(id))
    showPanel = ed.readequip.getDetailCard("Medal", info)
  else
    showPanel = ed.readequip.getDetailCard(id)
  end
  parent:addChild(showPanel, 600)
  return showPanel
end

function class:doPressInList()
  local function handler(x, y)
    if self.doPress then
      return self:doPress(x, y)
    end
  end
  
  return handler
end

function class:doClickInList()
  local function handler(x, y, k, i)
    if self.doClick then
      return self:doClick(x, y, k, i)
    end
  end
  
  return handler
end

function class:cancelPressInList()
  local function handler(x, y, k, i)
    if self.cancelPress then
      return self:cancelPress(x, y, k, i)
    end
  end
  
  return handler
end

function class:cancelClickInList()
  local function handler(x, y, k, i)
    if self.cancelClick then
      return self:cancelClick(x, y, k, i)
    end
  end
  
  return handler
end

function class:isBegin()
  return self.sTime < ed.getServerTime()
end

function class:isEnd()
  return ed.getServerTime() > self.eTime
end

function class:doTaskConsume(info)
  for i = 1, #(info or {}) do
    local v = info[i]
    local id = v._id
    local type = v._type
    local amount = v._amount
    if "rmb" == type or "diamond" == type then
      ed.player:addrmb(amount)
    elseif "money" == type then
      ed.player:addMoney(amount)
    elseif "gold" == type then
      ed.player:addMoney(amount)
    elseif "item" == type then
      ed.player:addEquip(id, amount)
    elseif "hero" == type then
      ed.player:addHero(id)
    elseif "crusadepoint" == type then
      ed.player:addCrusadeMoney(amount)
    elseif ed.isElementInTable(type, {
      "wood",
      "iron",
      "crystal"
    }) then
      ed.player:addPoint(type, amount or 0)
    elseif "vitality" == type then
      ed.player:addVitality(amount or 0)
    end
  end
end

function class:showReward(info)
  local items = {}
  local prizeType = {
    money = "Gold",
    gold = "Gold",
    rmb = "Diamond",
    diamond = "Diamond",
    item = "item",
    hero = "item",
    rand_soul = "item",
    crusadepoint = "CrusadePoint",
    wood = "Wood",
    crystal = "Crystal",
    iron = "Iron",
    vitality = "Vitality",
    medal = "medal",
    magicstone = "magicstone"
  }
  for i = 1, #(info or {}) do
    local r = info[i]
    local types = prizeType[r._type]
    local it = {
      type = types,
      id = r._id,
      amount = r._amount
    }
    table.insert(items, it)
  end
  local config = {
    type = "getProp",
    param = {
      title = T("\232\142\183\229\190\151"),
      items = items
    }
  }
  ed.announce(config)
end

function class:refreshActiviyList()
  local msg = ed.upmsg.ask_activity_info()
  ed.send(msg, "ask_activity_info")
end

function class:requesetRewardReply(callback, failback)
  local function handler(replys)
    CloseScope(scope)
    
    if not replys._result then
      ed.showToast(T("\228\187\187\229\138\161\230\143\144\228\186\164\229\164\177\232\180\165"))
      if failback then
        failback(replys)
      end
      return
    end
    if callback then
      callback(replys)
    end
    local info = replys._activity_reward
    self:doTaskConsume(info)
    self:showReward(info)
    self:refreshActiviyList()
  end
  
  return handler
end

function class:requestReward(id, callback, failback)
  if not id then
    print("activity id can not be nil")
    return
  end
  ListenEvent("requestRewardReply", self:requesetRewardReply(callback, failback), scope)
  local msg = ed.upmsg.job_rewards()
  msg._job = id
  ed.send(msg, "job_rewards")
end

function class:createFrame()
  self.container, self.fui = ed.editorui(ed.uieditor.ActivityFrame)
  self.container:registerScriptTouchHandler(self:btGetMainTouchHandler(), false, -100, false)
  self.container:setTouchEnabled(true)
end

function class:resetFrame()
  self.fui.enter_button:setVisible(false)
  self.fui.enter_label:setVisible(false)
  ed.setString(self.fui.a_title, self.title)
end

function class:getClipRect()
  local banner = self.bannerHeight
  return CCRectMake(17, 65, 417, 295 - banner)
end

function class:createDraglist()
  local banner = self.bannerHeight
  local draglistInfo = {
    cliprect = self:getClipRect(),
    rect = CCRectMake(20, 65, 410, 295 - banner),
    container = self.fui.a_frame,
    priority = self.touchpriority or -900,
    noshade = true,
    swallow = false,
    bar = {
      bglen = 260 - banner,
      bgpos = ccp(15, 218 - banner / 2)
    },
    doPressIn = self:doPressInList(),
    doClickIn = self:doClickInList(),
    cancelPressIn = self:cancelPressInList(),
    cancelClickIn = self:cancelClickInList()
  }
  self.draglist = ed.draglist.create(draglistInfo)
  self.draglist:initListHeight(initDraglistHeight)
end

function class:createTime()
  local time = string.format("%s-%s" .. ed.getUTCLabel(), ed.formatTime(self.sTime), ed.formatTime(self.eTime))
  ed.setString(self.ui.time, time)
end

function class:createTContent()
  local ui = self.ui.content
  ed.setString(ui, self.tContent)
  ui:setDimensions(CCSizeMake(400, 0))
  ui:setHorizontalAlignment(kCCTextAlignmentLeft)
  ui:setVerticalAlignment(kCCVerticalTextAlignmentTop)
end

function class:refreshRewardPosition()
  local height = self.ui.content:getContentSize().height * self.ui.content:getScaleY() - 35
  self.ui.a_rewards:setPosition(self.ui.a_rewards:getPositionX(), self.ui.a_rewards:getPositionY() - height)
  self.ui.rewards_layer:setPosition(self.ui.rewards_layer:getPositionX(), self.ui.rewards_layer:getPositionY() - height)
end

function class:hideDescription()
  self.ui.a_description:setVisible(false)
  self.ui.description:setVisible(false)
end

function class:createContent()
  local defaultY = -100
  if self:hasBanner() then
    defaultY = defaultY - 84
  end
  self.leftContainer, self.ui = ed.editorui(ed.uieditor.Activity)
  self.draglist:addItem(self.leftContainer, ccp(4, defaultY))
  self:createTime()
  self:createTContent()
  self:refreshRewardPosition()
  self:hideDescription()
end

function class:refreshBannerPosition()
  local pos = self.ui.a_time:getPositionY()
  self.bannerNode:setPosition(ccp(15, pos + 20))
end

function class:hasBanner()
  return self.banner
end

function class:createBanner()
  self.bannerHeight = 0
  if not self:hasBanner() then
    return
  end
  self.bannerHeight = 84
  local res = ed.getDataTable("ActListBanner")[self.banner].Picture
  local banner = ed.createSprite(res)
  banner:setAnchorPoint(ccp(0, 0))
  banner:setPosition(ccp(20, 280))
  self.bannerNode = banner
  self.fui.a_frame:addChild(banner)
end

function class:initData(param)
  self.data = param
  self.sTime = param.sTime
  self.eTime = param.eTime
  self.banner = param.banner
  self.tContent = param.tContent
  self.title = param.title
  local config = param.config or {}
  self.touchpriority = config.touchpriority
end

function class:createRewards()
end

function class:refreshListHeight(rHeight)
  local height = self.ui.content:getContentSize().height * self.ui.content:getScaleY()
  height = height + 120 + rHeight
  self.draglist:initListHeight(height)
end

function class.create(data)
  local self = base.create("window")
  setmetatable(self, class.mt)
  self:initData(data)
  self:createFrame()
  self:createBanner()
  self:resetFrame()
  self:createDraglist()
  self:createContent()
  return self
end

function class.createItemPrizeIcon(ttype, id, amount, size)
  local icon, icon2, num
  if ttype == "item" then
    icon = ed.readequip.createIcon(id)
  elseif ttype == "hero" then
    icon = ed.readequip.createIcon(id)
  elseif ttype == "rmb" then
    icon = CCSprite:create("UI/alpha/1080P/icon/diamond_icon.png")
  elseif ttype == "money" then
    icon = CCSprite:create("UI/alpha/1080P/icon/gold_icon.png")
  elseif ttype == "rand_soul" then
    icon2 = ed.readequip.getUnknownHeroStone()
    icon2:setAnchorPoint(ccp(0, 0))
    icon2:setPosition(ccp(0, 0))
    icon = ed.createScale9Sprite("UI/alpha/HVGA/fragment_frame_blue.png")
    icon:addChild(icon2)
  elseif ttype == "medal" then
    local path = ed.lookupDataTable("Medal", "Picture", tonumber(id))
    icon = ed.createSprite(path)
    icon:setScale(0.7)
  elseif ed.isMagicStone(id, ttype) then
    icon = ed.MagicStoneUITool.createClippingStoneIconById(id)
  else
    icon = ed.readequip.getUnknownIcon(1, 1)
    EDLog("[ERROR] The reward type is not used for this activity!")
  end
  if amount then
    num = string.format("x%s", amount)
    num = ed.createLabelTTF(num, size or 20)
  end
  return icon, num
end

function class:destroy()
  if not tolua.isnull(self.container) then
    self.container:setTouchEnabled(false)
    self.container:removeFromParentAndCleanup(true)
  end
end
