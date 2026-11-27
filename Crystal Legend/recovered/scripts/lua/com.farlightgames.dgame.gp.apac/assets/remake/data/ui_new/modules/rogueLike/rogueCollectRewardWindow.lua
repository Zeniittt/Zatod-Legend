local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.rogueCollectRewardWindow = class
ed.UITool.registViewOpenFunc("rogueCollectRewardWindow", function()
  ed.ui.rogueCollectRewardWindow.create():popWindow()
end)

function class.create()
  local self = base.create("rogueCollectRewardWindow")
  setmetatable(self, class.mt)
  self:init()
  return self
end

function class:init()
  self.taskDataList = {}
  self.rogueLikeMgr = ed.rogueLikeMgr.getInstance()
  local viewRevelationAmount = #self.rogueLikeMgr:getViewRevelation()
  local viewBlessAmount = #self.rogueLikeMgr:getViewBless()
  self.totalViewAmount = viewBlessAmount + viewRevelationAmount
  self.rogueBlessCollectionTB = ed.getDataTable("RogueBlessCollection")
  self:initView()
  self:addTouchEvent()
  self:addEventListener()
  self.refreshCliprectConfig = {
    draglist = self.tableView.dragList
  }
  self:show()
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.rogueCollectRewardWindow)
  self.container:addChild(container)
  self.ui = ui
  self:initTableView()
  local title = ed.ui.gradientLabel.create({
    text = T("\230\148\182\233\155\134\229\165\150\229\138\177"),
    fontSize = 55,
    fontName = ed.fontBold,
    startColor = ed.toccc3(15971327),
    endColor = ed.toccc3(16707839),
    strokeColor = ed.toccc3(5447810),
    strokeSize = 2.5
  })
  self.ui.image_title:addChild(title.node)
  title.node:setScale(math.min(1, 400 / title.node:getContentSize().width))
  title.node:setPosition(ccp(290 + title.node:getContentSize().width * 0.5 * title.node:getScaleX(), 68))
  ed.layout.horizontalSortNode({
    self.ui.label_tips,
    self.ui.label_total
  }, {0}, self.ui.image_bg:getContentSize().width * 0.5)
  self:initLabels()
  self:refreshView()
end

function class:initLabels()
  ed.setLabelStroke(self.ui.label_tips, ed.toccc3(8928414), 1)
  ed.setLabelStroke(self.ui.label_total, ed.toccc3(3678799), 1)
end

function class:initTableView()
  local size = self.ui.panel_list:getContentSize()
  self.delegate = {
    numberOfCells = function()
      return #self.taskDataList
    end,
    cellSizeFromIndex = function(index)
      return CCSizeMake(775, 90)
    end,
    createCell = function(index)
      local data = self.taskDataList[index]
      local itemContainer, ui = self:createListItem(data)
      return itemContainer, {data = data, ui = ui}
    end,
    doClickIn = function(cell, x, y)
      local data = cell.data.data
      local ui = cell.data.ui
      local rewardState = data.rewardState
      local id = data.blessCollectCfg.ID
      if rewardState == "available" and ed.containsPoint(ui.btn_get_reward, x, y) then
        ed.rogueLikeNet.sendViewBlessReward(id)
      end
    end,
    cancelPressIn = function()
    end
  }
  local param = {
    delegate = self.delegate,
    container = self.ui.panel_list,
    cliprect = CCRectMake(0, 0, size.width, size.height),
    colNum = 1,
    dragMode = 1,
    touchpriority = -300,
    noshade = true
  }
  self.tableView = Tableview.create(param)
end

function class:createListItem(rewardData)
  local container, ui = ed.editorui(ed.uieditor.rogueCollectRewardItem)
  container:setContentSize(ui.image_bg:getContentSize())
  ed.setLabelStroke(ui.label_complete, ed.toccc3(4268366), 1)
  local cfg = rewardData.blessCollectCfg
  local rewardState = rewardData.rewardState
  local requireAmount = cfg["Require Bless Amount"]
  local labelColor, strokeColor, bgPath
  if rewardState == "complete" then
    labelColor = ccc3(173, 170, 149)
    strokeColor = ed.toccc3(2037784)
    bgPath = "UI/alpha/1080P/rogue/collect/collect_reward_frame_3.png"
  elseif rewardState == "available" then
    labelColor = ccc3(255, 252, 231)
    strokeColor = ed.toccc3(5447810)
    bgPath = "UI/alpha/1080P/rogue/collect/collect_reward_frame_1.png"
  else
    labelColor = ccc3(255, 252, 231)
    strokeColor = ed.toccc3(5447810)
    bgPath = "UI/alpha/1080P/rogue/collect/collect_reward_frame_2.png"
  end
  ui.image_complete:setVisible(rewardState == "complete")
  ui.btn_get_reward:setVisible(rewardState == "available")
  ui.btn_uncomplete:setVisible(rewardState == "uncomplete")
  ed.setLabelColor(ui.label_desc, labelColor)
  ed.setLabelStroke(ui.label_desc, strokeColor, 1)
  ed.setLabelString(ui.label_desc, string.format(T("\231\180\175\231\167\175\232\167\163\233\148\129\232\190\190%s"), requireAmount))
  ed.setTexture(ui.image_bg, bgPath)
  local rewardDataList = {}
  for index = 1, 10 do
    local type = cfg[string.format("Reward Type %s", index)]
    local amount = cfg[string.format("Reward Amount %s", index)]
    local rewardId = cfg[string.format("Reward ID %s", index)]
    if not amount or amount == 0 then
      break
    end
    table.insert(rewardDataList, {
      id = rewardId,
      type = type,
      amount = amount
    })
  end
  self:createRewardItemList(ui.panel_reward, rewardDataList, rewardState)
  return container, ui
end

function class:refreshView()
  ed.setLabelString(self.ui.label_total, self.totalViewAmount)
  self:refreshTableView()
end

function class:refreshTableView(isHoldPos)
  self.taskDataList = {}
  local firstAvailableIndex, firstUncomplete
  for id, blessCollectCfg in ipairs(self.rogueBlessCollectionTB) do
    local requireAmount = blessCollectCfg["Require Bless Amount"]
    local flag = self.rogueLikeMgr:getBlessRewardFlagById(id)
    local rewardState
    if flag then
      rewardState = "complete"
    elseif requireAmount <= self.totalViewAmount then
      rewardState = "available"
      if not firstAvailableIndex then
        firstAvailableIndex = id
      end
    else
      rewardState = "uncomplete"
      firstUncomplete = firstUncomplete or id
    end
    table.insert(self.taskDataList, {blessCollectCfg = blessCollectCfg, rewardState = rewardState})
  end
  local jumpIndex
  if firstAvailableIndex then
    jumpIndex = firstAvailableIndex
  elseif firstUncomplete then
    jumpIndex = firstUncomplete
  end
  if isHoldPos then
    local listX, listY = self.tableView:getListPos()
    self.tableView:reloadData()
    self.tableView:setListPos(ccp(listX, listY))
  else
    self.tableView:reloadData()
  end
  if jumpIndex then
    local listX, _ = self.tableView:getListPos()
    local size = self.ui.panel_list:getContentSize()
    local listHeight = self.tableView:getListHeight()
    local listY = math.min(listHeight - size.height, (jumpIndex - 1) * 90)
    self.tableView:setListPos(ccp(listX, listY + size.height))
  end
end

function class:createRewardItemList(container, rewardDataList, rewardState)
  local itemList = {}
  local rewardDragList = ed.UITool.createDraglist(container, {
    doPressIn = function(x, y)
      self.startClickX = x
      self.startClickY = y
      for k, v in pairs(itemList) do
        if ed.containsPoint(v.icon, x, y) then
          return v
        end
      end
    end,
    doClickIn = function(x, y, v)
      if self.startClickX and self.startClickY and (math.abs(x - self.startClickX) > 10 or math.abs(y - self.startClickY) > 10) then
        return
      end
      local itemData = v.itemData
      if not ed.containsPoint(container, x, y) then
        return
      end
      ed.ui.packageDetailWin.create({
        id = itemData.id,
        count = itemData.amount,
        type = itemData.type
      }):popWindow()
    end,
    priority = -300
  })
  local posX, gapX = 0, -30
  for _, itemData in ipairs(rewardDataList or {}) do
    local icon = ed.createItemIcon({
      id = itemData.id,
      type = itemData.type,
      amount = itemData.amount
    })
    if rewardState == "complete" then
      local mask = ed.createSprite("UI/alpha/1080P/common/frame/equip_frame_mask.png")
      local imageReceived = ed.createSprite("UI/alpha/1080P/package/selected.png")
      icon:addChild(mask, 1)
      icon:addChild(imageReceived, 2)
      imageReceived:setPosition(ccp(45, 40))
      mask:setPosition(ccp(45, 45))
    elseif rewardState == "available" then
      local eff = ed.createSprite("UI/alpha/1080P/taskModel/player_award_list_item_eff.png")
      icon:addChild(eff)
      eff:setPosition(46, 45)
      eff:runAction(CCRepeatForever:create(CCRotateBy:create(0.7, 360)))
    end
    local iconSize = icon:getContentSize()
    rewardDragList:addItem(icon)
    icon:setPosition(ccp(iconSize.width / 2 + posX, container:getContentSize().height / 2))
    posX = posX + iconSize.width + gapX
    table.insert(itemList, {icon = icon, itemData = itemData})
  end
  rewardDragList:initListWidth(posX)
  return rewardDragList
end

function class:addTouchEvent()
  self:btRegisterOutClick({
    area = self.ui.image_bg,
    key = "clickOut",
    clickHandler = function()
      self:destroy()
    end,
    force = true
  })
end

function class:addEventListener()
  self:listenEvent("rogueViewBlessReward", function()
    self:refreshTableView(true)
  end)
end
