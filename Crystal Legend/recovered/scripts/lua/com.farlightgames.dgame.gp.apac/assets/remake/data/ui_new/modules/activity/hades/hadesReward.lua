local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.hadesRewardWin = class
ed.UITool.registViewOpenFunc("hadesRewardWin", function(param)
  local panel = class.create(param)
  panel:popWindow()
end)

function class.create(param)
  local self = base.create("hadesRewardWin")
  setmetatable(self, class.mt)
  self:init(param)
  return self
end

function class:init(param)
  self.param = param or {}
  self.groupId = param.groupId or 1
  self.hadesHeatMgr = ed.hadesHeatMgr.getInstance()
  self.startClickX = nil
  self.startClickY = nil
  self.heatTaskList = {}
  self.nextTaskOpenTime = nil
  self:initView()
  self:refreshView()
  self:registerTouchEvent()
  self:addEventListener()
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.hades_reward_win)
  self.ui = ui
  self.container:addChild(container)
  self:initTableView()
  ed.setLabelStroke(self.ui.label_history_heat, ed.toccc3(9644819), 1)
  local maxHeat = self.hadesHeatMgr:getMaxHeat(self.groupId)
  ed.setLabelString(self.ui.label_history_heat, maxHeat)
  ed.layout.horizontalSortNode({
    self.ui.label_1,
    self.ui.image_token,
    self.ui.label_history_heat
  }, {
    -10,
    -6,
    0
  }, self.ui.label_1:getPositionX(), 0)
  self.refreshCliprectConfig = {
    draglist = self.tableView.dragList
  }
end

function class:initTableView()
  local size = self.ui.list_layer:getContentSize()
  self.delegate = {
    numberOfCells = function()
      return #self.heatTaskList
    end,
    cellSizeFromIndex = function(index)
      return self:getRewardItemSize()
    end,
    createCell = function(index)
      local rewardData = self.heatTaskList[index]
      if rewardData.type == "tips" then
        local itemContainer, ui = self:createNewTaskTipsItem(self.nextTaskOpenTime)
        return itemContainer
      else
        local itemContainer, ui = self:createHeatRewardItem(index, rewardData)
        return itemContainer, {rewardData = rewardData, ui = ui}
      end
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
      if rewardData._is_rewarded and rewardData._is_rewarded > 0 then
        return
      end
      if rewardData._task_progress >= rewardData._cond_target then
        ed.hadesHeatNet.sendTaskRewards(self.groupId, rewardData._task_line_id, rewardData._task_id)
        ed.hadesHeatNet.sendOpenPanel(self.groupId)
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
  self:refreshTableView()
end

function class:refreshTableView()
  self.heatTaskList, self.nextTaskOpenTime = self.hadesHeatMgr:getShowTaskList(self.groupId)
  table.sort(self.heatTaskList, ed.cmpSort({
    {
      getValue = function(heatData)
        if heatData._is_rewarded and heatData._is_rewarded > 0 then
          return 1
        end
        return 0
      end
    },
    {
      getValue = function(heatData)
        return heatData.isNewTask and 0 or 1
      end
    },
    {
      key = "_task_line_id"
    },
    {key = "_task_id"}
  }))
  if self.nextTaskOpenTime then
    table.insert(self.heatTaskList, 1, {type = "tips"})
  end
  self.tableView:reloadData()
  local firstRewardIndex
  for index, taskData in ipairs(self.heatTaskList or {}) do
    if taskData.type ~= "tips" then
      if taskData._task_progress >= taskData._cond_target and taskData._is_rewarded <= 0 and not firstRewardIndex then
        firstRewardIndex = index
      end
      if firstRewardIndex then
        break
      end
    end
  end
  local size = self.ui.list_layer:getContentSize()
  local itemHeight = self:getRewardItemSize().height
  if firstRewardIndex and itemHeight then
    local index = firstRewardIndex
    local listPosY = itemHeight * (index - 1)
    local totalHeight = itemHeight * #self.heatTaskList
    listPosY = math.min(listPosY + size.height, totalHeight)
    self.tableView:setListPos(ccp(0, listPosY))
  end
end

function class:createHeatRewardItem(index, rewardData)
  local container, ui = ed.editorui(ed.uieditor.hades_reward_item)
  container:setContentSize(ui.image_bg:getContentSize())
  local taskLineId = rewardData._task_line_id
  local taskId = rewardData._task_id
  local taskCfg = ed.getDataTable("HeatTask")[taskLineId][taskId]
  local rewardState, bgPath, labelColor
  if rewardData._is_rewarded and rewardData._is_rewarded > 0 then
    bgPath = "UI/alpha/1080P/activityadventure/adventure_reward_bg4.png"
    rewardState = ed.adventureDefine.TASK_COMPLETE
    labelColor = ed.toccc3(11381397)
  elseif rewardData._task_progress >= rewardData._cond_target then
    bgPath = "UI/alpha/1080P/activityadventure/adventure_reward_bg1.png"
    rewardState = ed.adventureDefine.TASK_AVAILABLE
    labelColor = ed.toccc3(16776423)
  else
    bgPath = "UI/alpha/1080P/activityadventure/adventure_reward_bg2.png"
    rewardState = ed.adventureDefine.TASK_UNCOMPLETE
    labelColor = ed.toccc3(16776423)
  end
  ui.image_new:setVisible(rewardData.isNewTask)
  ed.setTexture(ui.image_bg, bgPath)
  ui.btn_uncomplete:setVisible(rewardState == ed.adventureDefine.TASK_UNCOMPLETE)
  ui.btn_get_reward:setVisible(rewardState == ed.adventureDefine.TASK_AVAILABLE)
  ui.btn_complete:setVisible(rewardState == ed.adventureDefine.TASK_COMPLETE)
  ed.setLabelDimensions(ui.label_desc, CCSizeMake(240, 0))
  ed.setLabelString(ui.label_desc, taskCfg["Task Detail"])
  ed.setLabelColor(ui.label_desc, labelColor)
  ed.setLabelStroke(ui.label_desc, ed.toccc3(2037784), 1)
  local itemList = {}
  for index = 1, 20 do
    local rewardType = taskCfg[string.format("Task Reward Type %s", index)]
    local rewardId = taskCfg[string.format("Task Reward ID %s", index)]
    local rewardAmount = taskCfg[string.format("Task Reward Amount %s", index)]
    if not rewardAmount or rewardAmount <= 0 then
      break
    end
    table.insert(itemList, {
      itemType = rewardType,
      itemId = rewardId,
      itemAmount = rewardAmount,
      rewardState = rewardState
    })
  end
  self:createRewardItemList(ui.reward_list, itemList)
  return container, ui
end

function class:createNewTaskTipsItem(nextTaskOpenTime)
  local container, ui = ed.editorui(ed.uieditor.hades_reward_task_tips)
  ed.setLabelStroke(ui.label_new_task_tips, ed.toccc3(3017740), 1)
  local year, month, day = ed.time2YMDHMS(nextTaskOpenTime)
  ed.setLabelString(ui.label_new_task_tips, string.format(T("\230\150\176\231\131\173\229\138\155\230\140\145\230\136\152\228\187\187\229\138\161\229\176\134\229\156\168%s\230\156\136%s\230\151\165\229\143\145\229\184\131"), month, day))
  ed.layout.centerInParent(ui.label_new_task_tips)
  container:setContentSize(ui.image_bg:getContentSize())
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
  self:listenEvent("hadesHeatOpenPanel", function(groupId)
    if self.groupId == groupId then
      self:refreshView()
    end
  end)
end

function class:close()
  self:destroy()
end
