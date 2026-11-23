local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.adventureRewardPanel = class
ed.UITool.registViewOpenFunc("adventureRewardPanel", function(param)
  local panel = class.create(param)
  panel:popWindow()
end)

function class.create(param)
  local self = base.create("adventureRewardPanel")
  setmetatable(self, class.mt)
  self:init(param)
  return self
end

function class:init(param)
  self.param = param or {}
  self.actId = self.param.actId
  self.actAdventureLineRewardTb = ed.getDataTable("ActivityAdventureLineReward")
  self.actAdventureTb = ed.getDataTable("ActivityAdventure")
  self.tokenPath = self.actAdventureTb[self.actId]["Token Icon"]
  self.adventureMgr = ed.actiAdventureMgr.getInstance()
  self.rewardItemList = {}
  self.startClickX = nil
  self.startClickY = nil
  self.rewardDataList = {}
  self:initView()
  self:refreshView()
  self:registerTouchEvent()
  self:addEventListener()
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.activity_adventure_reward_win)
  self.ui = ui
  self.container:addChild(container)
  self:initTableView()
  ed.setLabelColor(self.ui.label_collection, ed.toccc3(16700269))
  ed.setLabelStroke(self.ui.label_collection, ed.toccc3(2037784), 1)
  local tokenName = ed.adventureDefine.getAdventureTokenInfo(self.actId).tokenName
  ed.setLabelString(self.ui.desc, string.format(T("\228\184\138\233\152\181\232\139\177\233\155\132\230\151\182\239\188\140%s\232\142\183\229\143\150\233\135\143\230\143\144\229\141\135"), tokenName))
  self.refreshCliprectConfig = {
    draglist = self.tableView.dragList
  }
end

function class:initTableView()
  local size = self.ui.list_layer:getContentSize()
  self.delegate = {
    numberOfCells = function()
      return #self.rewardDataList
    end,
    cellSizeFromIndex = function(index)
      return self:getRewardItemSize()
    end,
    createCell = function(index)
      local rewardData = self.rewardDataList[index]
      local itemContainer, ui = self:createRewardItem(index, rewardData)
      return itemContainer, {rewardData = rewardData, ui = ui}
    end,
    doPressIn = function(cell, x, y)
      local data = cell.data
      if not data then
        return
      end
      local ui = data.ui
      if ed.containsPoint(ui.image_bg, x, y) then
        if ed.containsPoint(ui.btn_get_reward, x, y) then
          ui.btn_get_reward:setScale(0.95)
        end
        return cell
      end
    end,
    cancelPressIn = function(cell)
      local data = cell.data
      if not data then
        return
      end
      local ui = data.ui
      ui.btn_get_reward:setScale(1)
    end,
    doClickIn = function(cell, x, y)
      local data = cell.data
      if not data then
        return
      end
      local ui = data.ui
      if not ed.containsPoint(ui.btn_get_reward, x, y) then
        return
      end
      local rewardData = data.rewardData
      local rewardState = rewardData.rewardState
      if rewardState == ed.adventureDefine.TASK_AVAILABLE then
        ed.actiAdventureNet.getRewards(self.actId, rewardData.progressId)
        ed.actiAdventureNet.openPanel()
      end
    end
  }
  local param = {
    delegate = self.delegate,
    container = self.ui.list_layer,
    cliprect = CCRectMake(0, 0, size.width, size.height),
    colNum = 1,
    dragMode = 1,
    touchpriority = -300,
    offset = {8, 0},
    noshade = true
  }
  self.tableView = Tableview.create(param)
end

function class:getRewardItemSize()
  return CCSizeMake(775, 90)
end

function class:refreshView()
  self:refreshCollection()
  self:refreshTableView()
end

function class:setTabButtonSelect(tabName, select)
  local btnSelect = self.ui[tabName .. "_selected"]
  btnSelect:setVisible(select)
  local btn = self.ui[tabName]
  btn:setVisible(not select)
end

function class:refreshCollection()
  local tokenAmount = self.adventureMgr:getAdventureToken(self.actId)
  ed.setLabelString(self.ui.label_collection, string.format(T("\229\183\178\230\148\182\233\155\134\239\188\154%s"), tokenAmount))
  ed.setTexture(self.ui.image_token, self.tokenPath, true)
  local collectionSize = self.ui.label_collection:getContentSize()
  local collectionPosX, _ = self.ui.label_collection:getPosition()
  self.ui.image_token:setPositionX(collectionSize.width + collectionPosX + self.ui.image_token:getContentSize().width)
end

function class:refreshTableView()
  local rewardDataList = self:getRewardList(self.actId)
  table.sort(rewardDataList, ed.cmpSort({
    {key = "progressId"}
  }))
  self.rewardDataList = rewardDataList
  local firstRewardIndex, firstUncompleteIndex
  for index, rewardData in ipairs(rewardDataList or {}) do
    local rewardState = rewardData.rewardState
    if rewardState == ed.adventureDefine.TASK_AVAILABLE and not firstRewardIndex then
      firstRewardIndex = index
    end
    if rewardState == ed.adventureDefine.TASK_UNCOMPLETE and not firstUncompleteIndex then
      firstUncompleteIndex = index
    end
  end
  local size = self.ui.list_layer:getContentSize()
  local itemHeight = self:getRewardItemSize().height
  self.tableView:reloadData()
  if (firstRewardIndex or firstUncompleteIndex) and itemHeight then
    local index = firstRewardIndex or firstUncompleteIndex
    local listPosY = itemHeight * (index - 1)
    local totalHeight = itemHeight * #rewardDataList
    listPosY = math.min(listPosY + size.height, totalHeight)
    self.tableView:setListPos(ccp(0, listPosY))
  end
end

function class:createRewardItem(index, rewardData)
  local container, ui = ed.editorui(ed.uieditor.activity_adventure_reward_item)
  container:setContentSize(ui.image_bg:getContentSize())
  ed.setLabelString(ui.label_desc, string.format(T("\230\148\182\233\155\134%s"), rewardData.requireMedalCount))
  ed.setLabelColor(ui.label_desc, ed.toccc3(16776423))
  ed.setLabelStroke(ui.label_desc, ed.toccc3(2037784), 1)
  ed.setTexture(ui.image_token, self.tokenPath, true)
  ui.image_token:setPositionX(ui.label_desc:getPositionX() + ui.label_desc:getContentSize().width + ui.image_token:getContentSize().width)
  local rewardState = rewardData.rewardState
  ui.btn_uncomplete:setVisible(rewardState == ed.adventureDefine.TASK_UNCOMPLETE)
  ui.btn_get_reward:setVisible(rewardState == ed.adventureDefine.TASK_AVAILABLE)
  ui.btn_complete:setVisible(rewardState == ed.adventureDefine.TASK_COMPLETE)
  local bgPath
  if rewardState == ed.adventureDefine.TASK_UNCOMPLETE then
    bgPath = "UI/alpha/1080P/activityadventure/adventure_reward_bg2.png"
  elseif rewardState == ed.adventureDefine.TASK_AVAILABLE then
    bgPath = "UI/alpha/1080P/activityadventure/adventure_reward_bg1.png"
  elseif rewardState == ed.adventureDefine.TASK_COMPLETE then
    bgPath = "UI/alpha/1080P/activityadventure/adventure_reward_bg4.png"
  end
  ed.setTexture(ui.image_bg, bgPath)
  self:createRewardItemList(ui.reward_list, rewardData.itemList)
  return container, ui
end

function class:createItemIcon(itemData)
  local id = itemData.itemId
  local itemType = itemData.itemType
  local amount = itemData.itemAmount
  local rewardState = itemData.rewardState
  local icon = ed.createItemIcon({
    id = id,
    type = itemType,
    amount = amount
  })
  if rewardState == ed.adventureDefine.TASK_COMPLETE then
    local mask = ed.createSprite("UI/alpha/1080P/common/frame/equip_frame_mask.png")
    local imageReceived = ed.createSprite("UI/alpha/1080P/package/selected.png")
    icon:addChild(mask, 1)
    icon:addChild(imageReceived, 2)
    imageReceived:setPosition(ccp(45, 40))
    mask:setPosition(ccp(45, 45))
  elseif rewardState == ed.adventureDefine.TASK_AVAILABLE then
    local eff = ed.createSprite("UI/alpha/1080P/taskModel/player_award_list_item_eff.png")
    icon:addChild(eff)
    eff:setPosition(46, 45)
    eff:runAction(CCRepeatForever:create(CCRotateBy:create(0.7, 360)))
  end
  return icon
end

function class:getRewardList(actId)
  local medalRewardGroupId = self.actAdventureTb[actId]["Medal Reward Group ID"]
  local progressData = self.actAdventureLineRewardTb[medalRewardGroupId]
  local rewardDataList = {}
  for progressId, rewardDataCfg in pairs(progressData or {}) do
    local rewardState = self.adventureMgr:getRewardState(self.actId, progressId)
    local itemList = {}
    for index = 1, 20 do
      local itemType = rewardDataCfg[string.format("Reward Type %s", index)]
      if not itemType then
        break
      end
      local itemId = rewardDataCfg[string.format("Reward ID %s", index)]
      local itemAmount = rewardDataCfg[string.format("Reward Amount %s", index)]
      table.insert(itemList, {
        itemType = itemType,
        itemId = itemId,
        itemAmount = itemAmount
      })
    end
    local rewardData = {
      progressId = progressId,
      rewardState = rewardState,
      itemList = itemList,
      discribe = rewardDataCfg.Discribe,
      requireMedalCount = rewardDataCfg["Require Token Count"]
    }
    table.insert(rewardDataList, rewardData)
  end
  return rewardDataList
end

function class:createRewardItemList(container, rewardDataList)
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
      if not ed.containsPoint(self.ui.list_layer, x, y) then
        return
      end
      ed.ui.packageDetailWin.create({
        id = itemData.itemId,
        count = itemData.itemAmount,
        type = itemData.itemType
      }):popWindow()
    end,
    priority = -300
  })
  local posX, gapX = 0, 0
  for _, itemData in ipairs(rewardDataList or {}) do
    local icon = self:createItemIcon({
      itemId = itemData.itemId,
      itemType = itemData.itemType,
      itemAmount = itemData.itemAmount,
      rewardState = itemData.rewardState
    })
    local iconSize = icon:getContentSize()
    rewardDragList:addItem(icon)
    icon:setPosition(ccp(iconSize.width / 2 + posX + gapX, iconSize.height / 2 - 5))
    posX = posX + iconSize.width + gapX
    table.insert(itemList, {icon = icon, itemData = itemData})
  end
  rewardDragList:initListWidth(posX)
  return rewardDragList
end

function class:registerTouchEvent()
  self:btRegisterHandler({
    handler = function(event, x, y)
      if event == "began" then
        if ed.containsPoint(self.ui.image_bg, x, y) or ed.containsPoint(self.ui.layer_tab, x, y) then
          self.clickInList = true
        else
          self.clickInList = false
        end
      elseif event == "ended" and not ed.containsPoint(self.ui.image_bg, x, y) and not ed.containsPoint(self.ui.layer_tab, x, y) and not self.clickInList then
        self:close()
        return false
      end
      return false
    end,
    key = "close",
    priority = -100
  })
end

function class:addEventListener()
  self:listenEvent("refreshAdventureInfo", function(actId)
    if actId == self.actId then
      self:refreshView()
    end
  end)
end

function class:close()
  self:destroy()
end
