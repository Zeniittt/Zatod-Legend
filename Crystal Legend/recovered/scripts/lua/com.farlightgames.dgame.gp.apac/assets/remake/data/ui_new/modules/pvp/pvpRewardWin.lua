local base = ed.ui.popwindow
local pvpRewardWin = {}
pvpRewardWin.__index = pvpRewardWin
setmetatable(pvpRewardWin, base.mt)
ed.ui.pvpRewardWin = pvpRewardWin
local pvpRewardWinScope = {}

function pvpRewardWin.create()
  local self = base.create("pvpRewardWin")
  setmetatable(self, pvpRewardWin)
  self:initData()
  self:initUI()
  self:registerTouchHandlers()
  self:popWindow()
  self:show()
  return self
end

function pvpRewardWin:initData()
  self.tabIndex = 1
  self.rankNum = ed.pvpManager.rank
  local pvpRewardTable = ed.getDataTable("PVPRankReward")
  local selfRewardIndex
  local numString = ""
  self.rewardList = {}
  for i, v in ipairs(pvpRewardTable) do
    local result = ""
    local items = {}
    if pvpRewardTable[i - 1] and pvpRewardTable[i - 1]["Floor Rank"] < v["Floor Rank"] - 1 then
      result = T("\231\172\172%s\229\144\141-\231\172\172%s\229\144\141", string.format("<lable color=ccc3(141,244,118) strokeColor=ccc3(85,64,39) strokeSize=1>%d</lable>", pvpRewardTable[i - 1]["Floor Rank"] + 1), string.format("<lable color=ccc3(141,244,118) strokeColor=ccc3(85,64,39) strokeSize=1>%d</lable>", v["Floor Rank"]))
    else
      result = T("\231\172\172%s\229\144\141", string.format("<lable color=ccc3(141,244,118) strokeColor=ccc3(85,64,39) strokeSize=1>%d</lable>", v["Floor Rank"]))
    end
    for i = 1, 10 do
      if v["Reward Type " .. i] then
        local item = {
          type = v["Reward Type " .. i],
          id = v["Reward ID " .. i],
          amount = v["Reward Amount " .. i]
        }
        table.insert(items, item)
      end
    end
    table.insert(self.rewardList, {str = result, rewards = items})
  end
  self.timeRewardList = {}
  local timeRewardTable = ed.getDataTable("PVPDailyChallengeReward")
  timeRewardTable[0] = {Times = 0}
  for i, v in ipairs(timeRewardTable) do
    local result = ""
    local items = {}
    if timeRewardTable[i - 1] and timeRewardTable[i - 1].Times < v.Times - 1 then
      result = T("\231\172\172%s\230\172\161-\231\172\172%s\230\172\161", string.format("<lable color=ccc3(141,244,118) strokeColor=ccc3(85,64,39) strokeSize=1>%d</lable>", timeRewardTable[i - 1].Times + 1), string.format("<lable color=ccc3(141,244,118) strokeColor=ccc3(85,64,39) strokeSize=1>%d</lable>", v.Times))
    else
      result = T("\231\172\172%s\230\172\161", string.format("<lable color=ccc3(141,244,118) strokeColor=ccc3(85,64,39) strokeSize=1>%d</lable>", v.Times))
    end
    for i = 1, 10 do
      if v["Reward Type " .. i] then
        local item = {
          type = v["Reward Type " .. i],
          id = v["Reward ID " .. i],
          amount = v["Reward Amount " .. i]
        }
        table.insert(items, item)
      end
    end
    table.insert(self.timeRewardList, {str = result, rewards = items})
  end
end

local function createRewardIcon(reward, iconWidth)
  local type = reward.type
  local showAmount = true
  if type == "Item" then
    local icon
    if showAmount then
      icon = ed.readequip.createIconWithAmount(reward.id, iconWidth, reward.amount)
    else
      icon = ed.readequip.createIcon(reward.id, iconWidth)
    end
    return icon
  elseif type == "Diamond" then
    local icon = ed.createSprite("UI/alpha/1080P/common/newshop_recharge_diamond_04.png")
    icon:setScale(iconWidth / icon:getContentSize().height * 1.5)
    local amountText = reward.amount > 1 and tostring(reward.amount) or ""
    if showAmount then
      local amountLabel = ed.getNumberNode({
        text = amountText,
        folder = "prop_amount",
        padding = -1,
        scale = 0.9
      })
      local alNode = amountLabel.node
      alNode:setAnchorPoint(ccp(1, 0.5))
      alNode:setPosition(ccp(100, 32))
      icon:addChild(alNode)
    end
    return icon
  end
end

function pvpRewardWin:removeDetailCard()
  if self.detailCard then
    self.ui.bg:removeChild(self.detailCard, true)
    self.detailCard = nil
  end
end

function pvpRewardWin:createDetailCard(node, id)
  self:removeDetailCard()
  local w_pos = node:getParent():convertToWorldSpace(ccp(node:getPosition()))
  local l_pos = self.mainLayer:convertToNodeSpace(w_pos)
  l_pos.x = l_pos.x - 320
  l_pos.y = l_pos.y + 40
  local detailCard = ed.readequip.getDetailCard(id)
  if detailCard then
    self.detailCard = detailCard
    self.detailCard:setPosition(l_pos)
    self.ui.bg:addChild(self.detailCard, 1000)
  end
end

function pvpRewardWin:createRewardItem(index)
  local container = CCNode:create()
  local ui = {}
  ui.container = container
  local readnode = ed.readnode.create(container, ui)
  readnode:addNode(ed.uieditor.arenaRewardItem)
  ed.setLabelStroke(ui.label_get, ccc3(8, 48, 18), 1)
  local autoText = ed.ui.autoText.new()
  local text = self.rewardList[index].str
  autoText:initParam({
    context = text,
    fontSize = 15,
    color = ccc3(255, 252, 231),
    strokeColor = ccc3(85, 64, 39),
    strokeSize = 1
  })
  local iconList = {}
  
  local function doPressIn(x, y)
    for k, v in ipairs(iconList) do
      if ed.containsPoint(v.icon, x, y) then
        self.draglist.canDragY = false
        local pos = ed.getWorldPos(v.icon)
        if v.reward.id and v.reward.id ~= 0 then
          self:createDetailCard(v.icon, v.reward.id)
        elseif ed.resToIconId[string.lower(v.reward.type)] then
          self:createDetailCard(v.icon, ed.resToIconId[string.lower(v.reward.type)])
        end
        return v.reward
      end
    end
    return nil
  end
  
  local function cancelPressIn(x, y, k)
    self.draglist.canDragY = true
    self:removeDetailCard()
  end
  
  local info = {
    cliprect = CCRectMake(0, 0, 195, 70),
    container = ui.Panel_6912,
    noshade = true,
    zorder = 10,
    priority = -514,
    doPressIn = doPressIn,
    cancelPressIn = cancelPressIn
  }
  ui.equipDraglist = ed.draglist.create(info)
  ed.setLabelStroke(ui.label_reward, ccc3(0, 0, 0), 1)
  ed.setLabelStroke(ui.label_diamond, ccc3(0, 0, 0), 1)
  ed.setLabelStroke(ui.label_pvpcoin, ccc3(0, 0, 0), 1)
  local n = 0
  for k, v in ipairs(self.rewardList[index].rewards) do
    if v.type == "Diamond" then
      ed.setString(ui.label_diamond, "x" .. v.amount)
    elseif v.type == "ArenaPoint" then
      ed.setString(ui.label_pvpcoin, "x" .. v.amount)
    elseif v.type == "Item" then
      local icon = createRewardIcon(v, 65)
      icon:setPosition(ccp(30 + 65 * n, 35))
      ui.equipDraglist:addItem(icon)
      table.insert(iconList, {reward = v, icon = icon})
      n = n + 1
    end
  end
  ui.equipDraglist:initListWidth(65 * n)
  ui.rank:setVisible(false)
  autoText.node:setPosition(ccp(15, 42))
  ui.bg:addChild(autoText.node)
  return container, ui
end

function pvpRewardWin:createTimesRewardItem(index)
  local container = CCNode:create()
  local ui = {}
  ui.container = container
  local readnode = ed.readnode.create(container, ui)
  readnode:addNode(ed.uieditor.arenaTimeRewardItem)
  local autoText = ed.ui.autoText.new()
  local text = self.timeRewardList[index].str
  autoText:initParam({
    context = text,
    fontSize = 15,
    color = ccc3(255, 252, 231),
    strokeColor = ccc3(85, 64, 39),
    strokeSize = 1
  })
  local iconList = {}
  local canDragY = self.draglist.canDragY
  
  local function doPressIn(x, y)
    for k, v in ipairs(iconList) do
      if ed.containsPoint(v.icon, x, y) then
        self.draglist.canDragY = false
        local pos = ed.getWorldPos(v.icon)
        if v.reward.id and v.reward.id ~= 0 then
          self:createDetailCard(v.icon, v.reward.id)
        elseif ed.resToIconId[string.lower(v.reward.type)] then
          self:createDetailCard(v.icon, ed.resToIconId[string.lower(v.reward.type)])
        end
        return v.reward
      end
    end
    return nil
  end
  
  local function cancelPressIn(x, y, k)
    self.draglist.canDragY = canDragY
    self:removeDetailCard()
  end
  
  local info = {
    cliprect = CCRectMake(0, 0, 195, 70),
    container = ui.Panel_6912,
    noshade = true,
    zorder = 10,
    priority = -514,
    doPressIn = doPressIn,
    cancelPressIn = cancelPressIn
  }
  ui.equipDraglist = ed.draglist.create(info)
  local n = 0
  for k, v in ipairs(self.timeRewardList[index].rewards) do
    local icon
    if v.id and v.id ~= 0 then
      icon = ed.readequip.createIconWithAmount(v.id, 65, v.amount)
    elseif ed.resToIconId[string.lower(v.type)] then
      icon = ed.readequip.createIconWithAmount(ed.resToIconId[string.lower(v.type)], 65, v.amount)
    else
      icon = ed.createSprite()
    end
    icon:setPosition(ccp(30 + 65 * n, 35))
    ui.equipDraglist:addItem(icon)
    table.insert(iconList, {reward = v, icon = icon})
    n = n + 1
  end
  ui.equipDraglist:initListWidth(65 * n)
  ui.rank:setVisible(false)
  autoText.node:setPosition(ccp(15, 42))
  ui.bg_Copy0:addChild(autoText.node)
  return container, ui
end

function pvpRewardWin:getPos(i)
  if self.tabIndex == 1 then
    return ccp(self.ui.layer_item:getContentSize().width / 2, self.ui.layer_item:getContentSize().height - 86 * i + 43)
  else
    local row = math.floor((i + 1) / 2)
    if i % 2 == 1 then
      return ccp(self.ui.layer_item:getContentSize().width / 4, self.ui.layer_item:getContentSize().height - 86 * row + 43)
    else
      return ccp(self.ui.layer_item:getContentSize().width * 3 / 4, self.ui.layer_item:getContentSize().height - 86 * row + 43)
    end
  end
end

function pvpRewardWin:refreshDraglist()
  local uiList = {}
  self.draglist:clearList()
  self.draglist.listLayer:setPositionY(0)
  local rewardLists
  if self.tabIndex == 1 then
    rewardLists = self.rewardList
    self.draglist:initListHeight(86 * #rewardLists)
  else
    rewardLists = self.timeRewardList
    self.draglist:initListHeight(86 * math.floor((#rewardLists + 1) / 2))
  end
  for k, v in ipairs(rewardLists or {}) do
    local container, ui
    if self.tabIndex == 1 then
      container, ui = self:createRewardItem(k)
    else
      container, ui = self:createTimesRewardItem(k)
    end
    ui.data = v
    table.insert(uiList, ui)
    self.draglist:addItem(container)
    container:setPosition(self:getPos(k))
  end
  self.uiList = uiList
end

function pvpRewardWin:initUI()
  local container = self.mainLayer
  local ui = {}
  self.ui = ui
  local readnode = ed.readnode.create(container, ui)
  readnode:addNode(ed.uieditor.arenaRewardWin)
  self.ui.bg_title:setVisible(true)
  self.ui.bg_title1:setVisible(false)
  self.draglist = ed.UITool.createDraglist(self.ui.layer_item, {})
  ed.setString(self.ui.label_reward, T("\230\142\146\229\144\141\n\229\165\150\229\138\177"))
  self.ui.label_reward:limitWidthByScale(self.ui.btn_reward:getContentSize().width * 0.9)
  ed.setString(self.ui.label_times, T("\230\140\145\230\136\152\n\229\165\150\229\138\177"))
  self.ui.label_times:limitWidthByScale(self.ui.btn_times:getContentSize().width * 0.9)
  ed.setLabelColor(self.ui.label_reward, ccc3(67, 57, 52))
  ed.setLabelStroke(self.ui.label_reward, ccc3(255, 252, 231), 1)
  ed.setLabelColor(self.ui.label_times, ccc3(255, 252, 231))
  ed.setLabelStroke(self.ui.label_times, ccc3(56, 38, 34), 1)
  if ed.isAreaOverSea() then
    self.ui.Label_6843:setString(T("\230\175\143\230\151\16515\231\130\185\231\187\147\231\174\151\229\165\150\229\138\177"))
  end
  ed.setLabelStroke(self.ui.Label_6843, ccc3(0, 0, 0), 1)
  ed.setLabelStroke(self.ui.Label_6844, ccc3(0, 0, 0), 1)
  ed.setLabelStroke(self.ui.label_titlename, ed.toccc3(4205085), 1.5)
  ed.setLabelStroke(self.ui.label_title1, ed.toccc3(4205085), 1.5)
  self.ui.label_titlename:setFontName(ed.fontBold)
  self.ui.label_title1:setFontName(ed.fontBold)
  local x, y = self.ui.rank:getPosition()
  self.ui.rank:setVisible(false)
  local rank = ed.getNumberNode({
    text = self.rankNum,
    folder = "crusade",
    padding = -1,
    scale = 1
  }).node
  local labelTitleRightPosX = self.ui.label_title:getPositionX() + self.ui.label_title:getContentSize().width
  local rankWidth = rank:getContentSize().width
  if labelTitleRightPosX > self.ui.rank:getPositionX() - rankWidth * 0.5 then
    x = labelTitleRightPosX + rankWidth * 0.5 + 10
  end
  rank:setPosition(ccp(x, y))
  self.ui.bg_titlename:addChild(rank)
  self.ui.rank = rank
  x, y = self.ui.bg:getPosition()
  self.ui.bg:setPosition(ccp(x + ed.display.winSize.width / 2 - 480, y + ed.display.winSize.height / 2 - 270))
  self:refreshDraglist()
end

function pvpRewardWin:registerTouchHandlers()
  ed.UITool.registerBtn(self, "btn_back", function()
    self:destroy()
  end, {pressScale = 0.75, normalScale = 0.8})
  ed.UITool.registerBtn(self, "btn_reward", function()
    if self.tabIndex == 1 then
      return
    end
    self.tabIndex = 1
    ed.setLabelColor(self.ui.label_reward, ccc3(67, 57, 52))
    ed.setLabelStroke(self.ui.label_reward, ccc3(255, 252, 231), 1)
    ed.setLabelColor(self.ui.label_times, ccc3(255, 252, 231))
    ed.setLabelStroke(self.ui.label_times, ccc3(56, 38, 34), 1)
    self.ui.bg_title:setVisible(true)
    self.ui.bg_title1:setVisible(false)
    self.ui.btn_reward_selected:setVisible(true)
    self.ui.btn_times_selected:setVisible(false)
    self:refreshDraglist()
  end)
  ed.UITool.registerBtn(self, "btn_times", function()
    if self.tabIndex == 2 then
      return
    end
    self.tabIndex = 2
    ed.setLabelColor(self.ui.label_reward, ccc3(255, 252, 231))
    ed.setLabelStroke(self.ui.label_reward, ccc3(56, 38, 34), 1)
    ed.setLabelColor(self.ui.label_times, ccc3(67, 57, 52))
    ed.setLabelStroke(self.ui.label_times, ccc3(255, 252, 231), 1)
    self.ui.bg_title:setVisible(false)
    self.ui.bg_title1:setVisible(true)
    self.ui.btn_reward_selected:setVisible(false)
    self.ui.btn_times_selected:setVisible(true)
    self:refreshDraglist()
  end)
end

function pvpRewardWin:destroy()
  CloseScope(pvpRewardWin)
  base.destroy(self, {skipAnim = true})
end
