local base = ed.ui.popwindow
local GuildWeeklyjobWin = newclass(base.mt)
ed.ui.GuildWeeklyjobWin = GuildWeeklyjobWin

function GuildWeeklyjobWin.create()
  local self = base.create("GuildWeeklyjobWin")
  setmetatable(self, GuildWeeklyjobWin.mt)
  self.isFirstEnter = true
  self.taskUIList = {}
  self:initUI()
  self:registerEvents()
  self:registerTouchHandlers()
  self:popWindow()
  return self
end

function GuildWeeklyjobWin:RefreshItemInfo(itemUI, info)
  itemUI.data = info
  ed.setLabelString(itemUI.name_txt, info.name)
  ed.setLabelString(itemUI.des_txt, info.detail)
  ed.setLabelString(itemUI.pro_txt, T("%d/%d", info.value, info.target))
  local per = info.value / info.target
  itemUI.pro_img:setVisible(0 < per)
  if 0 < per then
    local proBgSize = itemUI.pro_bg:getContentSize()
    itemUI.pro_img:setContentSize(CCSizeMake(proBgSize.width * ed.clamp(per, 0.04, 1), proBgSize.height))
  end
  local isFinish = info.taskState == ed.weeklyjobData.TaskState.Finish
  local isTodo = info.taskState == ed.weeklyjobData.TaskState.Todo
  local isComplete = info.taskState == ed.weeklyjobData.TaskState.Complete
  itemUI.bg:setVisible(isComplete)
  itemUI.bg2:setVisible(not isComplete)
  itemUI.mask_img:setVisible(isFinish)
  itemUI.complete_bg:setVisible(isFinish)
  itemUI.get_btn:setVisible(isComplete)
  itemUI.go_btn:setVisible(isTodo)
  itemUI.fast_btn = ed.basetask.createFastButton(self, info, {isNocreateButton = true})
  local rewardList = {}
  if nil == itemUI.reward_draglist then
    itemUI.reward_draglist = ed.UITool.createDraglist(itemUI.reward_panel, {
      doPressIn = function(x, y)
        for k, v in pairs(rewardList or {}) do
          if ed.containsPoint(v.icon, x, y) then
            return v
          end
        end
      end,
      doClickIn = function(x, y, config)
        if not ed.containsPoint(self.ui.layer_item, x, y) then
          return
        end
        local reward = config.reward
        ed.ui.packageDetailWin.create({
          id = reward.id,
          count = reward.amount,
          type = reward.type
        }):popWindow()
      end,
      priority = -300
    })
  end
  local posX = 0
  for k, v in ipairs(info.reward) do
    local icon = self:createItemIcon(info.taskState, v)
    icon:setScale(0.8)
    itemUI.reward_draglist:addItem(icon)
    table.insert(rewardList, {icon = icon, reward = v})
    local iconWidth = icon:getContentSize().width * 0.8
    icon:setPosition(ccp(iconWidth / 2 + posX, iconWidth / 2))
    posX = posX + iconWidth - 5
  end
  itemUI.reward_draglist:initListWidth(posX)
end

function GuildWeeklyjobWin:getPos(i)
  local size = self.ui.layer_item:getContentSize()
  local ox = size.width / 2
  local oy = size.height
  local itemHeight = 85
  local itemSpace = 2
  local dy = oy - (i - 0.5) * itemHeight - (i - 1) * itemSpace
  return ccp(ox, dy)
end

function GuildWeeklyjobWin:createItemIcon(taskState, rewardData)
  local icon = ed.createItemIcon({
    id = rewardData.id,
    type = rewardData.type,
    amount = rewardData.amount
  })
  if taskState == ed.weeklyjobData.TaskState.Finish then
    local mask = ed.createSprite("UI/alpha/1080P/common/frame/equip_frame_mask.png")
    local imageReceived = ed.createSprite("UI/alpha/1080P/package/selected.png")
    icon:addChild(mask, 1)
    icon:addChild(imageReceived, 2)
    imageReceived:setPosition(ccp(45, 40))
    mask:setPosition(ccp(45, 45))
  elseif taskState == ed.weeklyjobData.TaskState.Complete then
    local eff = ed.createSprite("UI/alpha/1080P/taskModel/player_award_list_item_eff.png")
    icon:addChild(eff)
    eff:setPosition(46, 45)
    eff:runAction(CCRepeatForever:create(CCRotateBy:create(0.7, 360)))
  end
  return icon
end

function GuildWeeklyjobWin:buildDraglist(oldPos)
  self.taskUIList = {}
  self.draglist:clearList()
  local taskDataList = ed.weeklyjobData:getTaskList(ed.weeklyjobData.ModuleType.Guild)
  local taskNum = #taskDataList
  local finishNum = 0
  if 0 < taskNum then
    for i = 1, taskNum do
      local itemContainer = CCNode:create()
      local itemUI = {}
      itemUI.itemContainer = itemContainer
      local readnode = ed.readnode.create(itemContainer, itemUI)
      readnode:addNode(ed.uieditor.GuildWeeklyjobItem)
      itemContainer:setPosition(self:getPos(i))
      table.insert(self.taskUIList, itemUI)
      self.draglist:addItem(itemContainer)
      ed.setLabelStroke(itemUI.name_txt, ccc3(0, 0, 0), 1)
      ed.setLabelShadow(itemUI.go_txt, ccc3(33, 33, 38), ccp(0, 1))
      ed.setLabelShadow(itemUI.get_txt, ccc3(33, 33, 38), ccp(0, 1))
      self:RefreshItemInfo(itemUI, taskDataList[i])
      if taskDataList[i].taskState == ed.weeklyjobData.TaskState.Finish then
        finishNum = finishNum + 1
      end
    end
    local itemHeight = 85
    local itemSpace = 2
    self.draglist:initListHeight(itemHeight * taskNum + itemSpace * (taskNum - 1))
  end
  ed.setString(self.ui.total_progress, string.format("(%d/%d)", finishNum, taskNum))
end

function GuildWeeklyjobWin:doPressInList()
  local function handler(x, y)
    for k, v in ipairs(self.taskUIList or {}) do
      local btn
      
      if v.data.taskState == ed.weeklyjobData.TaskState.Todo then
        btn = v.go_btn
      elseif v.data.taskState == ed.weeklyjobData.TaskState.Complete then
        btn = v.get_btn
      end
      if nil ~= btn and not tolua.isnull(btn) and ed.checkVisible(btn) and ed.containsPoint(btn, x, y) then
        btn:setScale(0.9)
        return v
      end
    end
    return nil
  end
  
  return handler
end

function GuildWeeklyjobWin:doClickInList()
  local function handler(x, y, itemUI)
    if not itemUI then
      return
    end
    if itemUI.data.taskState == ed.weeklyjobData.TaskState.Todo then
      if itemUI.fast_btn then
        itemUI.fast_btn.handler(self)
      end
    elseif itemUI.data.taskState == ed.weeklyjobData.TaskState.Complete then
      local overfull = {}
      for k, v in ipairs(itemUI.data.reward) do
        if ed.player:isItemOverfull({
          id = v.id,
          type = v.type,
          amount = v.amount
        }) and v._type ~= "simple_chest" then
          table.insert(overfull, {
            id = v.id,
            amount = v.amount,
            kind = v.type,
            type = v.type
          })
        end
      end
      if 0 < #overfull then
        local panel = ed.ui.maillocalbox.create({
          type = "deleItem",
          tag = 2,
          btnStr = T("\229\143\150\230\182\136"),
          str = T("\229\165\150\229\138\177\228\184\173\229\144\171\230\156\137\233\162\134\229\143\150\229\144\142\229\176\134\228\188\154\232\182\133\232\191\135\228\184\138\233\153\144\231\154\132\231\137\169\229\147\129,\232\182\133\228\184\138\233\153\144\231\137\169\229\147\129\229\176\134\232\162\171<lable color=mailRed>\230\184\133\233\153\164</lable>\227\128\130<br/>\232\182\133\232\191\135\228\184\138\233\153\144\231\137\169\229\147\129:"),
          item = overfull,
          clickGeft = function()
            ed.taskNetwork:dailyjobReward(itemUI.data.id)
          end,
          clickBack = function()
          end
        }):popWindow()
      else
        ed.taskNetwork:dailyjobReward(itemUI.data.id)
      end
    end
  end
  
  return handler
end

function GuildWeeklyjobWin:cancelPressInList()
  local function handler(x, y, v)
    if not v then
      return
    end
    if not tolua.isnull(v.go_btn) then
      v.go_btn:setScale(1)
    end
    if not tolua.isnull(v.get_btn) then
      v.get_btn:setScale(1)
    end
  end
  
  return handler
end

function GuildWeeklyjobWin:initUI()
  local container = self.container
  local ui = {}
  self.ui = ui
  local readnode = ed.readnode.create(container, ui)
  readnode:addNode(ed.uieditor.GuildWeeklyjobWin)
  ed.setLabelStroke(self.ui.title, ed.toccc3(7674890), 1.5)
  ed.setLabelStroke(self.ui.des, ed.toccc3(7218969), 1)
  self.ui.title:setFontName(ed.fontBold)
  self.ui.total_progress:setPositionX(self.ui.title:getPositionX() + self.ui.title:getContentSize().width + 2)
  ed.setLabelStroke(self.ui.total_progress, ed.toccc3(7218969), 1.5)
  self.draglist = ed.UITool.createDraglist(self.ui.layer_item, {
    priority = -300,
    doPressIn = self:doPressInList(),
    cancelPressIn = self:cancelPressInList(),
    doClickIn = self:doClickInList()
  })
  self:buildDraglist()
end

function GuildWeeklyjobWin:registerTouchHandlers()
  ed.UITool.registerBtn(self, "btn_back", function()
    self:destroy()
  end, {normalScale = 0.8, pressScale = 0.75})
end

function GuildWeeklyjobWin:registerEvents()
  self:registerOnEnterHandler("OnEnterWeeklyjob", function()
    if self.isFirstEnter then
      self.isFirstEnter = false
    else
      ed.taskNetwork:sendWeeklyjob(ed.weeklyjobData.ModuleType.Guild)
    end
  end)
  self:listenEvent("GuildWeeklyjobWinRefresh", function()
    local taskDataList = ed.weeklyjobData:getTaskList(ed.weeklyjobData.ModuleType.Guild)
    local taskNum = #taskDataList
    local finishNum = 0
    for i = 1, taskNum do
      self:RefreshItemInfo(self.taskUIList[i], taskDataList[i])
      if taskDataList[i].taskState == ed.weeklyjobData.TaskState.Finish then
        finishNum = finishNum + 1
      end
    end
    ed.setString(self.ui.total_progress, string.format("(%d/%d)", finishNum, taskNum))
    self.draglist.listLayer:stopAllActions()
    self.draglist.listLayer:runAction(CCEaseExponentialOut:create(CCMoveTo:create(0.5, ccp(0, 0))))
  end)
end

function GuildWeeklyjobWin:popWindow(zOrder)
  base.popWindow(self, zOrder)
end
