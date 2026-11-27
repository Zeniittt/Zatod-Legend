local base = ed.ui.commonscene
local SevenDayScene = newclass(base.mt)
ed.ui.SevenDayScene = SevenDayScene

function SevenDayScene:getInitDayId()
  local data = ed.SevenDayManager.dayOfTasks
  for k, day in ipairs(data) do
    local tasks = day.tasks
    for id, task in ipairs(tasks) do
      if task.progress < task.target then
        return k, 1
      end
    end
    if day.challengeTimes > ed.getServerTime() then
      tasks = day.challengeTasks
      for id, task in ipairs(tasks) do
        if task.progress < task.target then
          return k, 2
        end
      end
    end
  end
  return 1
end

function SevenDayScene:initData()
  self.selectDay, self.subPage = self:getInitDayId()
end

function SevenDayScene:adaptUI()
  ed.layout.layoutWithMagin(self.ui.bg_title, {left = 70, top = 18})
end

function SevenDayScene:initLabels()
  ed.setLabelStroke(self.ui.label_time1, ed.toccc3(3547672), 1)
  ed.setLabelStroke(self.ui.label_time2, ed.toccc3(2627341), 1)
  ed.setLabelStroke(self.ui.label_score_tip, ed.toccc3(4534043), 1)
  ed.setLabelStroke(self.ui.label_normal_selected, ed.toccc3(14581260), 1)
  ed.setLabelStroke(self.ui.label_challenge_selected, ed.toccc3(14581260), 1)
  self.ui.label_score_tip:setFontName(ed.fontBold)
  ed.setLabelStroke(self.ui.label_heroname, ed.toccc3(12411925), 1)
  ed.setLabelFontName(self.ui.label_heroname, ed.fontBold)
  if ed.isAreaZh() then
    ed.setLabelDimensions(self.ui.label_heroname, CCSizeMake(24, 0))
  else
    self.ui.icon_heroname:setRotation(90)
    self.ui.label_heroname:setRotation(-90)
    ed.layout.relateLayout(self.ui.bg_time, self.ui.icon_heroname, {top = 40}, true)
    ed.adaptLabel(self.ui.label_heroname, {maxWidth = 150, minScale = 0.7})
  end
  local autoTextTitle = ed.ui.autoText.new()
  autoTextTitle:initParam({
    context = T("\229\129\154<lable color=ccc3(255,252,231) strokeColor=serverDayTitle strokeSize=3>7\230\151\165</lable>\228\187\187\229\138\161\233\128\129 <lable color=ccc3(255,252,231) strokeColor=serverDayTitle strokeSize=3>\229\134\155\229\155\162\230\140\135\230\140\165\229\174\152</lable>"),
    fontSize = 42,
    strokeColor = ed.toccc3(16770933),
    strokeSize = 3,
    color = ed.toccc3(4403243),
    shadowColor = ccc3(0, 0, 0),
    shadowOffset = ccp(0, 8),
    fontName = ed.fontBold,
    maxWidth = 2800
  })
  local atWid, _ = autoTextTitle:getCurContentSize()
  local maxWid = self.ui.layer_title:getContentSize().width
  if atWid > maxWid then
    autoTextTitle.node:setScale(maxWid / atWid)
  end
  self.ui.layer_title:addChild(autoTextTitle.node)
  ed.layout.centerYInParent(autoTextTitle.node)
  ed.adaptLabel()
end

function SevenDayScene:clickTaskGoto(data)
  ed.activityTaskTool.taskSkip(data.type, data.progressId)
end

function SevenDayScene:doPressInBtnList()
  local function handler(x, y)
    for k, v in ipairs(self.btnList or {}) do
      if v.data ~= self.selectDay and ed.containsPoint(v.bg, x, y) then
        return v
      end
    end
    return nil
  end
  
  return handler
end

function SevenDayScene:doClickInBtnList()
  local function handler(x, y, v)
    if not v then
      return
    end
    self.btnList[self.selectDay].selected:setVisible(false)
    self.btnList[self.selectDay].normal:setVisible(true)
    self.selectDay = v.data
    if self.selectDay > ed.SevenDayManager.curDay then
    end
    self:refreshMainDraglist()
    self:refreshTypeTab()
    self:updateRedLight()
    self.btnList[self.selectDay].selected:setVisible(true)
    self.btnList[self.selectDay].normal:setVisible(false)
  end
  
  return handler
end

function SevenDayScene:cancelPressInBtnList()
  local function handler(x, y, v)
    if not v then
      return
    end
  end
  
  return handler
end

function SevenDayScene:doPressInList()
  local function handler(x, y)
    for k, v in ipairs(self.uiList or {}) do
      if ed.containsPoint(v.btn_get, x, y) then
        v.btn_get:setScale(0.95)
        
        return v
      end
      if ed.containsPoint(v.reward1, x, y) then
        return v
      end
      if ed.containsPoint(v.reward2, x, y) then
        return v
      end
      if v.data.count > 0 and ed.containsPoint(v.rewardscore, x, y) then
        return v
      end
    end
    return nil
  end
  
  return handler
end

function SevenDayScene:doClickInList()
  local function handler(x, y, v)
    if not v then
      return
    end
    if ed.containsPoint(v.btn_get, x, y) then
      if v.data.taskState == 2 then
        if v.data.isExpire then
          ed.showToast(T("\228\187\187\229\138\161\229\183\178\232\191\135\230\156\159"))
        elseif self.selectDay > ed.SevenDayManager.curDay then
          ed.showToast(T("\228\187\187\229\138\161\230\156\170\229\188\128\229\144\175"))
        else
          self:clickTaskGoto(v.data)
        end
      elseif v.data.taskState == 1 then
        ed.SevenDayNetwork:sendGetTaskReward(v.data.id)
      end
    end
    if ed.containsPoint(v.reward1, x, y) and v.data.rewards[1] then
      ed.ui.packageDetailWin.create(v.data.rewards[1]):popWindow()
    end
    if ed.containsPoint(v.reward2, x, y) and v.data.rewards[2] then
      ed.ui.packageDetailWin.create(v.data.rewards[2]):popWindow()
    end
    if ed.containsPoint(v.rewardscore, x, y) and v.data.count > 0 then
      ed.ui.packageDetailWin.create({
        type = "taskcount",
        amount = v.count
      }):popWindow()
    end
  end
  
  return handler
end

function SevenDayScene:cancelPressInList()
  local function handler(x, y, v)
    if not v then
      return
    end
    v.btn_get:setScale(1)
  end
  
  return handler
end

function SevenDayScene:refreshScore()
  if self.scoreUI then
    self.scoreUI:removeFromParentAndCleanup(true)
  end
  self.scoreUI = ed.getNumberNode({
    text = ed.SevenDayManager.curProgress,
    folder = "herohot_num",
    padding = 0
  }).node
  self.scoreUI:setPosition(-28, 10)
  self.ui.icon_score:addChild(self.scoreUI)
end

function SevenDayScene:createBarItem(v, isLast)
  local container, ui = ed.editorui(ed.uieditor.SevenDayRewardItem)
  local iconReward
  if v.reward.type == "Hero" then
    iconReward = ed.readhero.createPureIcon({
      id = v.reward.id
    }).icon
    ui.mask = ed.UITool.createHeroMask(iconReward)
  else
    iconReward = ed.createItemIcon(v.reward)
    ui.mask = ed.UITool.createItemMask(iconReward)
  end
  iconReward:setScale(0.65)
  ed.setString(ui.num, v.target)
  ed.setLabelStroke(ui.num, ed.toccc3(3876115), 1)
  ed.UITool.replaceUI(ui, "bg", "icon_reward", iconReward)
  if isLast then
    iconReward:setScale(1)
    ui.icon:setVisible(false)
    iconReward:setPosition(ccp(77, 50))
    ui.bg:setPositionX(-13)
  end
  local eff = ed.createSprite("UI/alpha/1080P/taskModel/player_award_list_item_eff.png")
  eff:runAction(CCRepeatForever:create(CCRotateBy:create(0.7, 360)))
  eff:setPosition(ccp(45, 45))
  eff:setVisible(false)
  ui.light = eff
  ui.icon_reward:addChild(eff)
  self:btRegisterButtonClick({
    button = iconReward,
    key = "reward" .. v.target,
    clickHandler = function()
      if v.taskState == 1 then
        ed.SevenDayNetwork:sendGetLineReward(v.id)
      elseif v.reward.type == "Hero" then
        ed.UITool.openView("heroShowPop", {
          type = "notHave",
          id = v.reward.id
        })
      else
        ed.ui.packageDetailWin.create({
          id = v.reward.id,
          type = v.reward.type
        }):popWindow()
      end
    end,
    force = true,
    mcpMode = true
  })
  return container, ui
end

function SevenDayScene:initTop()
  self.ui.bar_deco:setZOrder(3)
  local x, y = self.ui.bar:getPosition()
  local thisCon = self.ui.bar:getContentSize()
  local progress = CCProgressTimer:create(self.ui.bar)
  progress:setType(kCCProgressTimerTypeBar)
  progress:setPosition(thisCon.width / 2 + x, thisCon.height / 2)
  self.ui.bg_bar:addChild(progress)
  progress:setMidpoint(ccp(0, 0.5))
  progress:setBarChangeRate(ccp(1, 0))
  self.ui.bar:setVisible(false)
  self.dayProgress = progress
  self.ui.bar_deco:setPositionX(0)
  local progressReward = ed.SevenDayManager.progressRewards
  self.rewardUIList = {}
  for k, v in ipairs(progressReward) do
    local container, ui = self:createBarItem(v, k == #progressReward)
    ui.data = v
    local posx = v.target / ed.SevenDayManager.maxProgress * thisCon.width
    container:setPosition(ccp(posx, -1.8))
    self.ui.bg_bar:addChild(container, 1)
    table.insert(self.rewardUIList, ui)
  end
end

function SevenDayScene:refreshProgressRewards()
  for k, v in ipairs(self.rewardUIList) do
    v.mask:setVisible(v.data.taskState == 3)
    v.light:setVisible(v.data.taskState == 1)
  end
end

function SevenDayScene:refreshBar()
  local percent = ed.SevenDayManager.curProgress / ed.SevenDayManager.maxProgress
  local width = 473 * percent
  self.dayProgress:runAction(CCProgressTo:create(0.5, percent * 100))
  self.ui.bar_deco:runAction(CCMoveTo:create(0.5, ccp(width, 13)))
  if percent == 1 then
    self.ui.bar_deco:setVisible(false)
  end
end

function SevenDayScene:refreshTop()
  local time = ed.SevenDayManager.totalEndTime - ed.getServerTime()
  ed.setString(self.ui.label_time2, ed.time2dhms(time))
  self:refreshScore()
  self:refreshProgressRewards()
  self:refreshBar()
end

function SevenDayScene:initUI()
  local container, ui = ed.editorui(ed.uieditor.SevenDayScene)
  self.ui, self.container = ui, container
  self.mainLayer:addChild(container)
  self:setBackground("UI/alpha/1080P/bg/newshop_bg1.jpg")
  self:setBackButton(function()
    ed.playEffect(ed.sound.common.back)
    ed.SevenDayManager.win = nil
  end)
  local _, titleTxt = ed.UITool.createSceneTitle(T("\228\184\131\230\151\165\229\138\169\229\138\155"), self.ui.bg_title, {
    position = ccp(13, 18)
  })
  ed.layout.relateLayout(titleTxt, self.ui.btn_tips, {
    right = titleTxt:getContentSize().width * 0.5 + 20
  })
  self:adaptUI()
  self:initLabels()
  self:initTop()
  self:createBtnDraglist()
  self:createDraglist()
  self:updateSubBtn()
end

function SevenDayScene:createBtnDraglist()
  self.btnDraglist = ed.UITool.createDraglist(self.ui.layer_btn, {
    priority = -131,
    doPressIn = self:doPressInBtnList(),
    cancelPressIn = self:cancelPressInBtnList(),
    doClickIn = self:doClickInBtnList()
  })
  self.btnList = {}
  self.btnDraglist:clearList()
  local size = self.ui.layer_btn:getContentSize()
  local py, gapY = 51, 0
  local ox, oy = size.width / 2, size.height + py / 2
  
  local function getPos(i)
    return ccp(ox, oy - (py + gapY) * i)
  end
  
  for i = 1, ed.SevenDayManager.maxDay do
    local container, ui = self:createBtnItem(i)
    ui.data = i
    table.insert(self.btnList, ui)
    self.btnDraglist:addItem(container)
    container:setPosition(getPos(i))
  end
  self.btnDraglist:initListHeight((py + gapY) * ed.SevenDayManager.maxDay)
end

function SevenDayScene:createDraglist()
  self.draglist = ed.UITool.createDraglist(self.ui.layer_item, {
    priority = -131,
    doPressIn = self:doPressInList(),
    cancelPressIn = self:cancelPressInList(),
    doClickIn = self:doClickInList()
  })
end

function SevenDayScene:refreshUI()
  self:refreshTop()
  self:refreshTypeTab()
  self:refreshBtnDraglist()
  self:refreshTasks()
  self:updateRedLight()
end

function SevenDayScene:createBtnItem(i)
  local container, ui = ed.editorui(ed.uieditor.SevenDayTabBtn)
  ed.setString(ui.normal_mid, i)
  ed.setString(ui.selected_mid, i)
  ed.setString(ui.locked_mid, i)
  ui.normal_mid:setFontName(ed.fontBold)
  ui.selected_mid:setFontName(ed.fontBold)
  ui.locked_mid:setFontName(ed.fontBold)
  return container, ui
end

function SevenDayScene:refreshBtnDraglist()
  for i, ui in ipairs(self.btnList) do
    if i <= ed.SevenDayManager.curDay then
      ui.locked:setVisible(false)
      ui.normal:setVisible(true)
      local red1, red2 = ed.SevenDayManager:getTabRedLight(i)
      ui.redlight:setVisible(red1 or red2)
    end
    if self.selectDay == i then
      ui.normal:setVisible(false)
      ui.selected:setVisible(true)
    end
  end
end

function SevenDayScene:createItem(v)
  local container, ui = ed.editorui(ed.uieditor.SevenDayTaskItem)
  ed.setLabelShadow(ui.label_get, ed.toccc3(0), ccp(1, 0))
  ed.setString(ui.task, string.format("%s", v.desc))
  local label_wid = self.subPage == 2 and 240 or 190
  ui.task:limitSizeByScale(label_wid, 50)
  ui.btn_get:setVisible(v.taskState == 1 or v.taskState == 2)
  ui.completed:setVisible(v.taskState == 3)
  ed.setString(ui.desc, string.format(T("\229\174\140\230\136\144\232\191\155\229\186\166(%d/%d)"), v.progress, v.target))
  if v.taskState == 1 then
    ed.setTexture(ui.bg, "UI/alpha/1080P/activity/seven_day/seven_day_task_1.png")
    ed.setLabelStroke(ui.task, ed.toccc3(4204293), 1)
  elseif v.taskState == 3 then
    ed.setTexture(ui.bg, "UI/alpha/1080P/activity/seven_day/seven_day_task_3.png")
    ed.setLabelColor(ui.task, ed.toccc3(10066329))
    ed.setLabelStroke(ui.task, ed.toccc3(2561538), 1)
    ed.setLabelColor(ui.desc, ed.toccc3(2695971))
  elseif v.taskState == 2 then
    ed.setString(ui.label_get, T("\229\137\141\229\190\128"))
    ed.setLabelStroke(ui.task, ed.toccc3(4204293), 1)
    if v.isExpire then
      ed.setTexture(ui.btn_get, "UI/alpha/1080P/common/button_mini_grey.png")
    else
      ed.setTexture(ui.btn_get, "UI/alpha/1080P/common/button_mini_sys.png")
    end
  end
  for k, v in ipairs(v.rewards) do
    local icon = ed.createItemIcon(v)
    icon:setScale(0.6)
    ed.UITool.replaceUI(ui, "bg", "reward" .. k, icon)
  end
  if 0 < v.count then
    local icon = ed.createItemIcon({
      type = "taskcount",
      amount = v.count
    })
    icon:setScale(0.6)
    ed.UITool.replaceUI(ui, "bg", "rewardscore", icon)
  end
  return container, ui
end

function SevenDayScene:updateRedLight()
  local redlight1, redlight2 = false, false
  if self.selectDay <= ed.SevenDayManager.curDay then
    redlight1, redlight2 = ed.SevenDayManager:getTabRedLight(self.selectDay)
  end
  self.ui.redlight1:setVisible(redlight1)
  self.ui.redlight2:setVisible(redlight2)
  self.btnList[self.selectDay].redlight:setVisible(redlight1 or redlight2)
end

function SevenDayScene:refreshTypeTab()
  local time = ed.SevenDayManager:getChallengeTaskTime(self.selectDay)
  local timeStr = T("\233\153\144\230\151\182\228\187\187\229\138\161(\229\183\178\231\187\147\230\157\159)")
  if self.selectDay > ed.SevenDayManager.curDay then
    timeStr = T("\233\153\144\230\151\182\228\187\187\229\138\161(\230\156\170\229\188\128\229\144\175)")
  end
  local serverTime = ed.getServerTime()
  if time > serverTime then
    local h, m = ed.second2hms(time - serverTime)
    timeStr = string.format(T("\233\153\144\230\151\182\228\187\187\229\138\161(%s)"), string.format("%02d:%02d", h, m))
  end
  ed.setString(self.ui.label_challenge, timeStr)
  ed.setString(self.ui.label_challenge_selected, timeStr)
end

function SevenDayScene:refreshTasks()
  if not self.uiList then
    self:refreshMainDraglist()
  else
    for i, ui in ipairs(self.uiList) do
      local v = ui.data
      ui.btn_get:setVisible(v.taskState == 1 or v.taskState == 2)
      ui.completed:setVisible(v.taskState == 3)
      ed.setString(ui.desc, string.format(T("\229\174\140\230\136\144\232\191\155\229\186\166(%d/%d)"), v.progress, v.target))
      if v.taskState == 1 then
        ed.setString(ui.label_get, T("\233\162\134\229\143\150"))
        ed.setTexture(ui.bg, "UI/alpha/1080P/activity/seven_day/seven_day_task_1.png")
        ed.setLabelStroke(ui.task, ed.toccc3(4204293), 1)
      elseif v.taskState == 3 then
        ed.setTexture(ui.bg, "UI/alpha/1080P/activity/seven_day/seven_day_task_3.png")
        ed.setLabelColor(ui.task, ed.toccc3(10066329))
        ed.setLabelStroke(ui.task, ed.toccc3(2561538), 1)
        ed.setLabelColor(ui.desc, ed.toccc3(2695971))
      elseif v.taskState == 2 then
        ed.setString(ui.label_get, T("\229\137\141\229\190\128"))
        ed.setLabelStroke(ui.task, ed.toccc3(4204293), 1)
        if v.isExpire then
          ed.setTexture(ui.btn_get, "UI/alpha/1080P/common/button_mini_grey.png")
        end
      end
    end
  end
end

function SevenDayScene:refreshMainDraglist()
  self.uiList = {}
  self.draglist:clearList()
  local size = self.ui.layer_item:getContentSize()
  local py, gapY = 66.5, 2
  local ox, oy = size.width / 2, size.height + py / 2
  
  local function getPos(i)
    return ccp(ox, oy - (py + gapY) * i)
  end
  
  local data = ed.SevenDayManager:getTaskData(self.selectDay, self.subPage)
  for k, v in ipairs(data) do
    local container, ui = self:createItem(v)
    ui.data = v
    ui.container = container
    table.insert(self.uiList, ui)
    self.draglist:addItem(container)
    container:setPosition(getPos(k))
  end
  self.draglist:initListHeight((py + gapY) * #data)
end

function SevenDayScene:updateSubBtn()
  self.ui.btn_challenge:setVisible(self.subPage ~= 1)
  self.ui.label_challenge:setVisible(self.subPage == 1)
  self.ui.btn_normal:setVisible(self.subPage == 1)
  self.ui.label_normal:setVisible(self.subPage ~= 1)
end

local strPage = {
  T("\226\128\156\232\191\142\230\142\165\230\140\145\230\136\152\239\188\140\231\187\143\229\142\134\232\175\149\231\130\188\239\188\140\232\156\149\229\143\152\229\188\186\229\164\167\239\188\140\232\142\183\229\190\151\232\131\156\229\136\169\239\188\140\229\177\158\228\186\142\228\189\160\231\154\132\229\134\155\229\155\162\230\140\135\230\140\165\239\188\129\226\128\157<br/>") .. T("                                 \226\128\148\226\128\148\226\128\148\226\128\148 \227\128\144\232\136\185\233\149\191\231\154\132\228\185\166\230\161\140\229\136\187\229\173\151\227\128\145<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\230\180\187\229\138\168\230\140\129\231\187\173\230\151\182\233\151\180\228\184\18630\229\164\169\227\128\130<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\230\136\144\233\149\191\228\187\187\229\138\161\228\184\186\231\180\175\232\174\161\228\187\187\229\138\161\239\188\14030\229\164\169\229\134\133\232\190\190\230\136\144\233\131\189\229\143\175\228\187\165\233\162\134\229\143\150\229\165\150\229\138\177\227\128\130<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\233\153\144\230\151\182\228\187\187\229\138\161\229\143\170\232\131\189\229\156\168\232\167\163\233\148\129\229\189\147\229\164\169\233\153\144\230\151\182\229\174\140\230\136\144\233\162\134\229\143\150\229\165\150\229\138\177\239\188\140\233\128\190\230\151\182\229\176\134\228\188\154\232\191\135\230\156\159\229\164\177\230\149\136\227\128\130<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\230\175\143\229\164\169\228\188\154\232\167\163\233\148\129\230\150\176\228\187\187\229\138\161\239\188\140\229\174\140\230\136\144\228\187\187\229\138\161\229\176\134\232\142\183\229\190\151\229\165\150\229\138\177\229\143\138\231\167\175\229\136\134\231\130\185\230\149\176\239\188\140\231\180\175\232\174\161\231\167\175\229\136\134\231\130\185\230\156\128\231\187\136\229\143\175\228\187\165\233\162\134\229\143\150\229\134\155\229\155\162\230\140\135\230\140\165\227\128\130<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\233\156\128\232\166\129\230\179\168\230\132\143\231\154\132\230\152\175\239\188\140\230\180\187\229\138\16830\229\164\169\229\144\142\232\191\135\230\156\159\239\188\140\229\165\150\229\138\177\230\178\161\230\156\137\233\162\134\229\143\150\231\154\132\232\175\157\229\176\177\228\188\154\230\182\136\229\164\177\229\147\166\227\128\130<br/>")
}

function SevenDayScene:registerTouchHandlers()
  self:btRegisterRectClick({
    rect = CCRectMake(442, 382.5, 200, 35),
    key = "normal_task",
    parent = self.ui.bg,
    force = true,
    clickHandler = function()
      self.subPage = 1
      self:updateSubBtn()
      self:refreshMainDraglist()
    end
  })
  self:btRegisterRectClick({
    rect = CCRectMake(672, 382.5, 200, 35),
    key = "challenge_task",
    parent = self.ui.bg,
    force = true,
    clickHandler = function()
      self.subPage = 2
      self:updateSubBtn()
      self:refreshMainDraglist()
    end
  })
  ed.UITool.registerBtn(self, "btn_tips", function()
    ed.ui.commonRulePop.create({
      title = T("\232\167\132\229\136\153\232\175\180\230\152\142"),
      txt = strPage
    }):popWindow()
  end)
end

function SevenDayScene:setTaskComplete()
  local size = self.ui.layer_item:getContentSize()
  local py, gapY = 66.5, 2
  local ox, oy = size.width / 2, size.height + py / 2
  
  local function getPos(i)
    return ccp(ox, oy - (py + gapY) * i)
  end
  
  local add = 0
  for k, ui in ipairs(self.uiList) do
    if ui.data.id == ed.SevenDayNetwork.tmpTaskId then
      add = 1
      ui.completed:setVisible(true)
      ui.btn_get:setVisible(false)
      ed.setTexture(ui.bg, "UI/alpha/1080P/activity/seven_day/seven_day_task_3.png")
      ed.setLabelColor(ui.task, ed.toccc3(10066329))
      ed.setLabelStroke(ui.task, ed.toccc3(2561538), 1)
      ed.setLabelColor(ui.desc, ed.toccc3(2695971))
      ui.container:runAction(CCEaseExponentialOut:create(CCMoveTo:create(1, getPos(#self.uiList))))
    else
      ui.container:runAction(CCEaseExponentialOut:create(CCMoveTo:create(1, getPos(k - add))))
    end
  end
  local tmp
  local newUI = {}
  for k, ui in ipairs(self.uiList) do
    if ui.data.id == ed.SevenDayNetwork.tmpTaskId then
      tmp = ui
      ed.SevenDayNetwork.tmpTaskId = nil
    else
      table.insert(newUI, ui)
    end
  end
  self.uiList = newUI
end

function SevenDayScene:registerEvents()
  self:listenEvent("RefreshSevenDayScene", function()
    self:refreshUI()
  end)
  self:listenEvent("SevenDayTaskReward", function()
    self:refreshTop()
    self:setTaskComplete()
    self:updateRedLight()
  end)
  self:listenEvent("SevenDayLineReward", function()
    self:refreshProgressRewards()
  end)
  self:listenEvent("midas_reply", function(msgReply)
    ed.SevenDayNetwork:sendOpenPanel()
  end)
  self:listenEvent("CloseChatMainWin", function(msgReply)
    ed.SevenDayNetwork:sendOpenPanel()
  end)
end

function SevenDayScene.create()
  local self = base.create("SevenDayScene", {noBottomButton = true})
  setmetatable(self, SevenDayScene.mt)
  self:initData()
  self:initUI()
  self:registerTouchHandlers()
  self:registerEvents()
  self:registerOnEnterHandler("SevenDaySceneOnEnter", function()
    ed.SevenDayNetwork:sendOpenPanel()
  end)
  self:registerOnPopSceneHandler("OnPopSevenDayScene", function()
    FireEvent("RefreshRightTopButtons")
  end)
  ed.SevenDayManager.win = self
  return self
end
