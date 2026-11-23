local exchangePage = {}
ed.ui.ActivityExchangePage = exchangePage

function exchangePage.create(base, param, pageKey)
  local self = {}
  setmetatable(exchangePage, {__index = base})
  setmetatable(self, {__index = exchangePage})
  self:init(param, pageKey)
  return self
end

function exchangePage:init(param, pageKey)
  self.pageKey = pageKey
  self.taskList = param._tasks
  self.activityId = param._id
  self.cfgId = param._cfg_id
  self.endTime = param._end_time
  self.actiDataTable = ed.getDataTable("Activity")[self.cfgId]
  self.tokenId = self.actiDataTable["Extra AN"][1] or 0
  self.iconPath = self.actiDataTable["Extra Str"][1] or "UI/alpha/1080P/icon/exchange_bamboo.png"
  self.exchangeTaskList = {}
  self.progressTaskList = {}
  self.isVisible = true
  self:initView()
  self:addListenEvent()
end

function exchangePage:initView()
  local container, ui = ed.editorui(ed.uieditor.activity_exchange)
  self.container = container
  self.ui = ui
  ed.setLabelColor(self.ui.left_time, ed.toccc3(16776423))
  ed.setLabelStroke(self.ui.left_time, ed.toccc3(9263891), 1)
  ed.setLabelColor(self.ui.token_amount, ed.toccc3(16776423))
  ed.setLabelStroke(self.ui.token_amount, ed.toccc3(4733742), 1)
  local tokenName = ed.readequip.value(self.tokenId, "Name") or ""
  self.ui.target_task_desc:setString(string.format(T("\231\180\175\232\174\161\230\182\136\232\128\151%s\233\162\134\229\165\150\229\138\177"), tokenName))
  ed.adaptLabel(self.ui.target_task_desc, {maxWidth = 150, minScale = 0.7})
  self:adaptUI()
  self:refreshLeftTime()
  self:refreshTokenAmount()
  self:initTableView()
  self:refreshTask()
end

function exchangePage:adaptUI()
  local offsetWidth = ed.display.winSize.width - 960
  local offsetHeight = ed.display.winSize.height - 540
  self.ui.item_list:setPositionX(self.ui.item_list:getPositionX() + offsetWidth * 0.23)
  self.ui.item_list_bg:setPositionX(self.ui.item_list_bg:getPositionX() + offsetWidth * 0.23)
end

function exchangePage:initTableView()
  local delegate = {
    numberOfCells = function()
      return #self.exchangeTaskList
    end,
    cellSizeFromIndex = function(index)
      return CCSizeMake(135, 179)
    end,
    createCell = function(index)
      local taskData = self.exchangeTaskList[index]
      local node, ui = self:createExchangeItem(taskData)
      return node, {taskData = taskData, ui = ui}
    end,
    doClickIn = function(cell)
      if not self.isVisible then
        return
      end
      local param = cell.data
      local taskData = param.taskData
      local needTokenAmount = taskData._cond_target
      local reward = taskData._rewards and taskData._rewards[1]
      local surplusAmount = taskData._max_reward_times - taskData._cur_reward_times
      if surplusAmount <= 0 then
        ed.showToast(T("\230\178\161\230\156\137\229\186\147\229\173\152\228\186\134"))
        return
      end
      local panel = ed.ui.buyResourceBox.create({
        buyLimitNum = surplusAmount,
        defaultBuyNum = 1,
        goodsResType = ed.ui.configs.resType.getResType(reward._type),
        goodsId = reward._id,
        costResType = "Item",
        costId = self.tokenId,
        price = needTokenAmount,
        groupAmount = reward._amount,
        costIconConfig = {
          smallIcon = self.iconPath
        },
        buyAction = function(num)
          if 0 < num then
            self.objWork:activitySubmit(self.activityId, taskData._id, num)
            self.reduceCostAmount = needTokenAmount * num
            self.objWork:activityPull(self.activityId)
          end
        end
      })
      panel:setSurplusAmount(surplusAmount)
      panel:popWindow()
    end
  }
  local size = self.ui.item_list:getContentSize()
  local param = {
    delegate = delegate,
    cliprect = CCRectMake(0, 0, size.width, size.height),
    container = self.ui.item_list,
    touchpriority = -300,
    zorder = 10,
    dragMode = 1,
    noshade = true,
    colNum = 3,
    padding = {width = 15, height = 15}
  }
  self.itemTbView = Tableview.create(param)
end

function exchangePage:refreshLeftTime()
  local leftTime = self.endTime - ed.getServerTime()
  leftTime = math.max(0, leftTime)
  local day = math.floor(leftTime / 86400)
  local hour = math.floor(leftTime % 86400 / 3600)
  local min = math.floor(leftTime % 3600 / 60)
  if day <= 0 and hour <= 0 then
    self.ui.left_time:setString(T("\229\137\169\228\189\153 %s\230\151\182%s\229\136\134", hour, min))
  else
    self.ui.left_time:setString(T("\229\137\169\228\189\153 %s\229\164\169%s\230\151\182", day, hour))
  end
end

function exchangePage:refreshTokenAmount()
  if self.reduceCostAmount and self.reduceCostAmount > 0 then
    ed.player:consumeEquip(self.tokenId, self.reduceCostAmount)
    self.reduceCostAmount = 0
  end
  local tokenAmount = ed.player:getEquipAmount(self.tokenId)
  ed.setLabelString(self.ui.token_amount, string.format(T("\230\140\129\230\156\137%s"), tokenAmount))
  local tokenIcon = self:createTokenIcon()
  self.ui.token_amount:removeAllChildrenWithCleanup(true)
  self.ui.token_amount:addChild(tokenIcon)
  local x = self.ui.token_amount:getContentSize().width + tokenIcon:getContentSize().width
  local y = self.ui.token_amount:getContentSize().height / 2
  tokenIcon:setScale(0.9)
  tokenIcon:setPosition(ccp(x - 10, y))
end

function exchangePage:refreshTask()
  self.exchangeTaskList = {}
  self.progressTaskList = {}
  for index, taskData in ipairs(self.taskList or {}) do
    if taskData._cond_type == "exchange_progress" then
      table.insert(self.progressTaskList, taskData)
    elseif taskData._cond_type == "item_exchange" then
      table.insert(self.exchangeTaskList, taskData)
    end
  end
  table.sort(self.exchangeTaskList, ed.cmpSort({
    {
      getValue = function(o)
        if o._cur_reward_times >= o._max_reward_times then
          return 1
        end
        return 0
      end
    }
  }))
  self:refreshTableView()
  self:refreshProgressTask()
end

function exchangePage:refreshTableView()
  self.itemTbView:reloadData()
end

function exchangePage:refreshProgressTask()
  if #self.progressTaskList < 1 then
    return
  end
  local pregressTask = self.progressTaskList[1]
  local progress = pregressTask._progress
  local condTarget = pregressTask._cond_target
  ed.setLabelString(self.ui.target_reward_desc_2, string.format("%s/%s", progress, condTarget))
  ed.setTexture(self.ui.target_task_img, self.iconPath, true)
  self.ui.target_task_img:setScale(0.9)
  local taskState = ed.activityTaskTool.getTaskState(pregressTask)
  local rewardData = pregressTask._rewards[1]
  local id = rewardData._id
  local rewardType = rewardData._type
  local amount = rewardData._amount
  local icon = ed.createItemIcon({
    id = id,
    type = rewardType,
    amount = amount
  })
  if taskState == "IS_FINISHED" then
    local mask = ed.createSprite("UI/alpha/1080P/common/frame/equip_frame_mask.png")
    local imageReceived = ed.createSprite("UI/alpha/1080P/package/selected.png")
    icon:addChild(mask, 1)
    icon:addChild(imageReceived, 2)
    imageReceived:setPosition(ccp(45, 40))
    mask:setPosition(ccp(45, 45))
    ed.setLabelString(self.ui.target_reward_desc_1, T("\229\183\178\233\162\134\229\143\150"))
    self.ui.target_reward_desc_1:setPositionX(self.ui.target_task_desc:getPositionX() + self.ui.target_reward_desc_1:getContentSize().width * 0.5)
    self.ui.target_task_img:setVisible(false)
    self.ui.target_reward_desc_2:setVisible(false)
  elseif taskState == "IS_COMPLETED" then
    local eff = ed.createSprite("UI/alpha/1080P/taskModel/player_award_list_item_eff.png")
    icon:addChild(eff)
    eff:setPosition(46, 45)
    eff:runAction(CCRepeatForever:create(CCRotateBy:create(0.7, 360)))
    ed.setLabelString(self.ui.target_reward_desc_1, T("\229\183\178\232\190\190\230\136\144"))
    self.ui.target_reward_desc_1:setPositionX(self.ui.target_task_desc:getPositionX() + self.ui.target_reward_desc_1:getContentSize().width * 0.5)
    self.ui.target_task_img:setVisible(false)
    self.ui.target_reward_desc_2:setVisible(false)
  else
    local des1Width = self.ui.target_reward_desc_1:getContentSize().width
    local desTaskWidth = self.ui.target_task_img:getContentSize().width * 0.9
    local des2Width = self.ui.target_reward_desc_2:getContentSize().width
    local startPosX = self.ui.target_task_desc:getPositionX() - (des1Width + desTaskWidth + des2Width) * 0.5
    self.ui.target_reward_desc_1:setPositionX(startPosX + des1Width)
    self.ui.target_task_img:setPositionX(startPosX + des1Width + desTaskWidth * 0.5)
    self.ui.target_reward_desc_2:setPositionX(startPosX + des1Width + desTaskWidth)
  end
  self.ui.target_reward:removeAllChildrenWithCleanup(true)
  icon:setScale(1)
  self.ui.target_reward:addChild(icon)
  ed.layout.centerInParent(icon)
  self:btRegisterButtonClick({
    button = icon,
    key = "pregressReward",
    force = true,
    clickHandler = function()
      if taskState == "IS_COMPLETED" then
        self.objWork:activitySubmit(self.activityId, pregressTask._id)
        self.objWork:activityPull(self.activityId)
      else
        local panel = ed.ui.packageDetailWin.create({id = id, type = rewardType})
        panel:popWindow()
      end
    end
  })
end

function exchangePage:createExchangeItem(taskData)
  local container, ui = ed.editorui(ed.uieditor.activity_exchange_item)
  local reward = taskData._rewards[1]
  local itemIcon = ed.readequip.createIconWithAmount(reward._id, 80, reward._amount)
  ui.item_icon:addChild(itemIcon)
  ed.layout.centerInParent(itemIcon)
  local name = ed.readequip.value(reward._id, "Name") or ""
  ed.setLabelString(ui.item_name, name)
  ed.adaptLabel(ui.item_name, {maxWidth = 120, minScale = 0.65})
  if EDCurLanguage == "en" then
    local nameScale = 0.8
    ui.item_name:setScale(nameScale)
    ed.setLabelDimensions(ui.item_name, CCSizeMake(120 / nameScale, 0))
  end
  local maxRewardTimes = taskData._max_reward_times
  local curRewardTimes = taskData._cur_reward_times
  ed.setLabelString(ui.exchange_limit, T("\229\137\169\228\189\153%s/%s", maxRewardTimes - curRewardTimes, maxRewardTimes))
  ed.setLabelStroke(ui.exchange_limit, ed.toccc3(4733742), 1)
  local condTarget = taskData._cond_target
  ed.setLabelString(ui.need_token, condTarget)
  local isRed = condTarget > ed.player:getEquipAmount(self.tokenId)
  ed.setLabelColor(ui.need_token, ccc3(ed.colorToStr(isRed and "#FF0005" or "#493C2F")))
  ui.sold_out_mask:setVisible(maxRewardTimes - curRewardTimes == 0)
  local tokenIcon = self:createTokenIcon()
  ui.need_token:getParent():addChild(tokenIcon)
  tokenIcon:setScale(0.9)
  ed.layout.horizontalSortNode({
    tokenIcon,
    ui.need_token
  }, {0, 0}, ui.exchange_limit:getPositionX())
  tokenIcon:setPositionY(ui.need_token:getPositionY())
  container:setContentSize(ui.item_bg:getContentSize())
  return container, ui
end

function exchangePage:createTokenIcon()
  local icon = ed.createSprite(self.iconPath)
  return icon
end

function exchangePage:pageUpDate(param)
  self.taskList = param._tasks
  self:refreshTokenAmount()
  self:refreshTask()
end

function exchangePage:setVisibleCallBack(isVisible)
  self.isVisible = isVisible
  if isVisible then
    self:refreshTokenAmount()
    self:refreshTask()
  end
end

function exchangePage:addListenEvent()
end
