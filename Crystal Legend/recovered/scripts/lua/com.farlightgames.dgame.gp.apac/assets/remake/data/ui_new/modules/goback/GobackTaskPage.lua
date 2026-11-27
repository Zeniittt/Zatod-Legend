local TaskPage = newclass("g")
local GobackMainScene = ed.ui.GobackMainScene
GobackMainScene.task = TaskPage
local dx = 80

function TaskPage:doPressInList()
  local function handler(x, y)
    if self.scene.tabIndex ~= 2 then
      return nil
    end
    for k, v in ipairs(self.uiList or {}) do
      if ed.containsPoint(v.icon_reward, x, y) then
        return v
      end
    end
    return nil
  end
  
  return handler
end

function TaskPage:cancelPressInList()
  local function handler(x, y, v)
    if not v then
      return
    end
  end
  
  return handler
end

function TaskPage:doClickInList()
  local function handler(x, y, v)
    if not v then
      return
    end
    local data = v.data
    if v.data.state == 1 or v.data.progress > self.curProgress then
      ed.ui.packageDetailWin.create(v.data.rewards):popWindow()
      return
    end
  end
  
  return handler
end

function TaskPage:createItem(data, k)
  local container, ui = ed.editorui(ed.uieditor.GobackTaskItem)
  local icon = ed.createItemIcon(data.rewards)
  icon:setScale(0.8)
  ed.UITool.replaceUI(ui, "bg", "icon_reward", icon)
  if data.state == 1 then
    ui.mask:setVisible(true)
  elseif data.progress <= self.curProgress then
    local light = ed.createSprite("UI/alpha/1080P/taskModel/player_award_list_item_eff.png")
    light:runAction(CCRepeatForever:create(CCRotateBy:create(0.7, 360)))
    light:setPosition(44, 44)
    icon:addChild(light)
    ui.redlight:setVisible(true)
  end
  ed.setLabelStroke(ui.Label_4173, ed.toccc3(4073745), 1)
  ed.setString(ui.Label_4173, string.format("%d", data.progress))
  return container, ui
end

function TaskPage:initData(param)
  self.scene = param.scene
  self.lineTasks = ed.GobackManager:getLineTasks()
end

function TaskPage:refreshData(hero)
end

function TaskPage:createDraglist()
  self.draglist = ed.UITool.createDraglist(self.ui.layer_item, {
    priority = -100,
    doPressIn = self:doPressInList(),
    cancelPressIn = self:cancelPressInList(),
    doClickIn = self:doClickInList()
  })
  local bg_bar = self.ui.bg_bar
  bg_bar:removeFromParentAndCleanup(false)
  bg_bar:setPosition(ccp(20, 90))
  local numOfSteps = 6
  local ox = 20
  for i = 1, numOfSteps do
    if self.rewards[i].progress <= self.curProgress then
      ox = ox + dx
    else
      if i == 1 then
        local perc = (self.curProgress - 0) / (self.rewards[i].progress - 0)
        ox = ox + dx * perc
        break
      end
      local perc = (self.curProgress - self.rewards[i - 1].progress) / (self.rewards[i].progress - self.rewards[i - 1].progress)
      ox = ox + dx * perc
      break
    end
  end
  if self.rewards[#self.rewards].progress < self.curProgress then
    ox = dx * numOfSteps + 32
  end
  self.ui.bar:setContentSize(CCSizeMake(ox, 24.5))
  self.ui.icon_cur:setVisible(false)
  self.ui.icon_cur:setPositionX(ox - 8)
  bg_bar:setContentSize(CCSizeMake(dx * numOfSteps + 40, 24.5))
  self.draglist:initListWidth(dx * numOfSteps + 140)
  self.draglist:addItem(bg_bar)
end

function TaskPage:refreshDraglist(oldPos)
  local x, y
  if oldPos then
    x, y = self.draglist.listLayer:getPosition()
  end
  for k, v in ipairs(self.containUI or {}) do
    v:removeFromParentAndCleanup(true)
  end
  self.uiList = {}
  self.containUI = {}
  local listData = self.rewards
  
  local function getPos(index)
    return ccp(12 + dx * index, -30)
  end
  
  for k, v in ipairs(listData) do
    local container, ui = self:createItem(v, k)
    ui.data = v
    table.insert(self.uiList, ui)
    table.insert(self.containUI, container)
    self.ui.bg_bar:addChild(container, 1)
    if v.state == 0 and self.curProgress > v.progress then
      local point = ed.createSprite("UI/alpha/1080P/newshop/secretbox/secretbox_point.png")
      point:setPosition(getPos(k))
      self.ui.bg_bar:addChild(point, 5)
    end
    container:setPosition(getPos(k))
  end
  if oldPos then
    self.draglist.listLayer:setPosition(ccp(x, y))
  end
end

function TaskPage:getCurClipRect()
  local lengthList = {
    29,
    64,
    64,
    63,
    63,
    64,
    63,
    64
  }
  local curWidth = 0
  local curProgress = ed.GobackManager.taskLine
  for i = 1, 8 do
    local task = self.lineTasks[i]
    if curProgress < task.progress then
      if i == 1 then
        curWidth = curWidth + curProgress / (task.progress - 1) * lengthList[i]
        break
      end
      curWidth = curWidth + (curProgress - self.lineTasks[i - 1].progress) / (task.progress - self.lineTasks[i - 1].progress - 1) * lengthList[i]
      break
    elseif curProgress == task.progress then
      curWidth = curWidth + lengthList[i] + 19
      if i == 8 then
        self.maxProgress = true
        curWidth = curWidth + 20
      end
      break
    else
      curWidth = curWidth + lengthList[i] + 19
    end
  end
  curWidth = curWidth * 2340 / 2130 * self.fixScale
  return CCRectMake(0, 0, curWidth, 40)
end

function TaskPage:initUI()
  local container, ui = ed.editorui(ed.uieditor.GobackTaskPage)
  self.mainLayer = container
  self.ui = ui
  local labelText = T("\229\174\140\230\136\144<lable color=ccc3(255,152,196)>\230\151\165\229\184\184\228\187\187\229\138\161</lable>\239\188\140\233\162\134\229\143\150<lable color=ccc3(255,232,126)>\229\155\158\229\189\146\229\138\169\229\138\155\229\165\150\239\188\129</lable>")
  local atText = ed.ui.autoText.new()
  atText:initParam({
    context = labelText,
    fontSize = 27,
    color = ccc3(255, 252, 231),
    strokeColor = ed.toccc3(6700923),
    strokeSize = 1,
    fontName = ed.fontBold,
    maxWidth = 1000
  })
  atText:limitWidthByScale(450)
  ui.tip_pos:addChild(atText.node)
  local width, _ = atText:getCurContentSize()
  atText.node:setPosition(ccp(-width * atText.node:getScale() * 0.5, 0))
  self.atText = atText
  ed.setLabelStroke(self.ui.score, ed.toccc3(6963525), 1)
  ed.setString(self.ui.label_score, ed.GobackManager.taskLine)
  local endTimeStr = T("\229\183\178\231\187\147\230\157\159")
  if ed.GobackManager.endTime > ed.getServerTime() then
    endTimeStr = string.format(T("\229\137\169\228\189\153%s"), ed.time2dhmsV2(ed.GobackManager.endTime - ed.getServerTime()))
  end
  ed.setString(self.ui.time, endTimeStr)
  local fix = math.max(0, 1170 - ed.display.winSize.width)
  self.fixScale = 1 - fix / 2340
  self.ui.bg_bar:setScale(self.fixScale)
  ed.UITool.setPositionBy(self.ui.bg_bar, ccp(fix * 0.22, 0))
  self.numLayer = CCLayer:create()
  self.ui.bg_bar:addChild(self.numLayer)
  self:refreshBar()
end

function TaskPage:refreshBar()
  ed.setString(self.ui.label_score, ed.GobackManager.taskLine)
  self.lineTasks = ed.GobackManager:getLineTasks()
  self.numLayer:removeAllChildrenWithCleanup(true)
  self.ui.layer_bar:setClipRect(self:getCurClipRect())
  local offset = {
    -0.5,
    0.5,
    0,
    -0.8,
    0.5,
    0.5,
    -1.5,
    -1.5
  }
  for k, v in ipairs(self.lineTasks) do
    local icon = ed.createItemIcon(v.reward)
    icon:setScale(0.9)
    ed.UITool.replaceUI(self.ui, "bg_bar", "icon" .. k, icon)
    if v.state == "CanGet" then
      local light = ed.createSprite("UI/alpha/1080P/taskModel/player_award_list_item_eff.png")
      icon:addChild(light)
      self.ui["light" .. k] = light
      light:setPosition(ccp(44, 44))
      light:runAction(CCRepeatForever:create(CCRotateBy:create(0.7, 360)))
    elseif v.state == "Got" then
      local mask = ed.createSprite("UI/alpha/1080P/common/frame/equip_frame_mask.png")
      mask:setPosition(45, 46)
      icon:addChild(mask)
      local tick = ed.createSprite("UI/alpha/1080P/package/selected.png")
      icon:addChild(tick)
      tick:setPosition(ccp(45, 46))
    end
    local label = ed.createttf(v.progress, 16)
    if v.state == "UnGet" then
      label:setColor(ed.toccc3(16776423))
    else
      label:setColor(ed.toccc3(11552279))
    end
    if v.progress > 99 then
      label:setScale(0.85)
    end
    local posX = icon:getPositionX()
    label:setPosition(ccp(posX + offset[k], 142))
    self.ui.bg_bar:addChild(label)
    self.scene:btRemoveMainTouchHandler({
      key = "lineTask" .. k
    })
    self.scene:btRegisterButtonClick({
      button = icon,
      key = "lineTask" .. k,
      clickHandler = function(_, x, y)
        if v.state == "CanGet" then
          ed.GobackNetwork:getTaskReward(k)
        else
          ed.ui.packageDetailWin.create(v.reward):popWindow()
        end
      end,
      clickInterval = 0.3,
      priority = -1
    })
  end
  if self.maxProgress then
    local labelText = T("\229\183\178\232\142\183\229\190\151\230\137\128\230\156\137<lable color=ccc3(255,232,126)>\229\155\158\229\189\146\229\138\169\229\138\155\229\165\150</lable>\239\188\140\228\184\141\230\132\167\230\152\175\230\130\168!")
    if labelText ~= self.atText.str then
      local atText = ed.ui.autoText.new()
      atText:initParam({
        context = labelText,
        fontSize = 27,
        color = ccc3(255, 252, 231),
        strokeColor = ed.toccc3(6700923),
        strokeSize = 1,
        fontName = ed.fontBold,
        maxWidth = 1000
      })
      atText:limitWidthByScale(450)
      self.ui.tip_pos:removeAllChildrenWithCleanup(true)
      self.ui.tip_pos:addChild(atText.node)
      local width, _ = atText:getCurContentSize()
      atText.node:setPosition(ccp(-width * atText.node:getScale() * 0.5, 0))
      self.atText = atText
    end
    self.ui.btn_go:setVisible(false)
  end
end

function TaskPage:refreshUI()
  self:refreshBar()
end

function TaskPage:registerTouchHandlers()
  self.scene:btRegisterButtonClick({
    button = self.ui.btn_go,
    key = "btngo",
    clickHandler = function(_, x, y)
      ed.UITool.openView("taskScene", {page = 2})
    end,
    clickInterval = 0.3,
    pressScale = 0.9,
    priority = -1
  })
end

function TaskPage:registerEvents()
  self.scene:listenEvent("GobackGetLineRewards", function(i)
    local mask = ed.createSprite("UI/alpha/1080P/common/frame/equip_frame_mask.png")
    mask:setPosition(45, 46)
    self.ui["icon" .. i]:addChild(mask)
    local tick = ed.createSprite("UI/alpha/1080P/package/selected.png")
    self.ui["icon" .. i]:addChild(tick)
    tick:setPosition(ccp(45, 46))
    self.ui["light" .. i]:removeFromParentAndCleanup(true)
  end)
  self.scene:listenEvent("DailyJobRewardGot", function()
    ed.GobackNetwork:sendOpenPanel()
  end)
end

function TaskPage.create(param)
  local self = {}
  setmetatable(self, {__index = TaskPage})
  self:initData(param)
  self:initUI()
  self:registerTouchHandlers()
  self:registerEvents()
  return self
end
