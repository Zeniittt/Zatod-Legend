local activityAllStarPage = newclass("g")
ed.ui.activityAllStarPage = activityAllStarPage

function activityAllStarPage.create(base, param, pageKey)
  local this = {}
  setmetatable(activityAllStarPage, {__index = base})
  setmetatable(this, {__index = activityAllStarPage})
  local container, ui = ed.editorui(ed.uieditor.activity_allstar_page)
  this.ui = ui
  this.param = param
  this.pageKey = pageKey or ""
  this.container = container
  this:initView(param)
  return this
end

function activityAllStarPage:initView(param)
  local task, pass = param._tasks
  for _, v in pairs(ed.passDataMgr:getDisplayPass()) do
    if v.type == "AllStar" then
      pass = v
      break
    end
  end
  if not pass then
    ed.showToast("not pass")
    return
  end
  self.simplePassId = pass.id
  self.ui.Label_time:setString(T("\229\137\169\228\189\153:%s", param.endTimeStr or 0))
  self:showTask(task)
  self:showReward(ed.passDataMgr:getPassRewardList(pass.id))
  self:refreshPassInfo()
  self:setButtonClick()
  self.ui.Label_3426:setStroke(ccc3(ed.colorToStr("#732c07")), 1.2)
  self.ui.Label_3423:setStroke(ccc3(ed.colorToStr("#7b3b3a")), 1.2)
  self.ui.Label_time:setStroke(ccc3(ed.colorToStr("#713118")), 1.2)
  self.ui.Label_3423:setString(0)
  self.ui.Label_3416:setFontName(ed.fontBold)
  self.ui.Label_3416_Copy0:setFontName(ed.fontBold)
  self.ui.Label_button_1:setStroke(ccc3(ed.colorToStr("#843e3a")), 1.2)
  self.ui.Label_button_2:setStroke(ccc3(ed.colorToStr("#843e3a")), 1.2)
  self.ui.Label_button_selected_1:setStroke(ccc3(ed.colorToStr("#fffdf8")), 1.2)
  self.ui.Label_button_selected_2:setStroke(ccc3(ed.colorToStr("#fffdf8")), 1.2)
  self.ui.Label_pay:setStroke(ccc3(ed.colorToStr("#764413")), 1.2)
  self.ui.red_button_2:setVisible(0 < ed.passDataMgr:getPassRewardCount(self.simplePassId))
  self.ui.red_button_1:setVisible(ed.activityHints.allStarTaskRed and 0 < ed.activityHints.allStarTaskRed)
  self.objWork:activityPull(param._id)
end

function activityAllStarPage:refreshPassInfo()
  local data = ed.passDataMgr:getPassData(self.simplePassId)
  local rank = data.rank or 0
  self.ui.ImageView_pay:setVisible(rank ~= 1 and self.dragList:isVisible())
  local isMax = false
  local expMax = ed.getDataTable("SimplePass")[self.simplePassId]["Level" .. ed.passDataMgr:getCurrentLevel(self.simplePassId) + 1] or 0
  if expMax == 0 then
    expMax = ed.getDataTable("SimplePass")[self.simplePassId]["Level" .. ed.passDataMgr:getCurrentLevel(self.simplePassId)] or 0
    isMax = true
  end
  local passExp = data.extend._pass_exp
  if expMax < passExp then
    passExp = expMax
  end
  if not isMax then
    local newExp = ed.getDataTable("SimplePass")[self.simplePassId]["Level" .. ed.passDataMgr:getCurrentLevel(self.simplePassId)] or 0
    expMax = expMax - newExp
    passExp = passExp - newExp
  end
  self.ui.Label_exp:setString(isMax and T("\229\183\178\230\187\161\231\186\167") or T("%d/%d", passExp, expMax))
  if not self.progressBox then
    self.progressBox = ed.taskProModule.new(self.ui.ImageView_progress, 15)
    self.progressBox:setPro(passExp / expMax)
  else
    if ed.passDataMgr:getCurrentLevel(self.simplePassId) > tonumber(self.ui.Label_3423:getString()) then
      self.progressBox:addPro(1)
    end
    if passExp == 0 and ed.passDataMgr:getCurrentLevel(self.simplePassId) ~= tonumber(self.ui.Label_3423:getString()) then
      self.progressBox:addPro(passExp / expMax, true)
    elseif passExp ~= 0 then
      self.progressBox:addPro(passExp / expMax, true)
    end
  end
  self.ui.Label_3423:stopAllActions()
  self.ui.Label_3423:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(function()
    self.ui.Label_3423:setString(ed.passDataMgr:getCurrentLevel(self.simplePassId))
  end)))
end

function activityAllStarPage:pageUpDate(param)
  self.param = param
  local task = param._tasks
  self:initTaskDragList(task)
  ed.passNetWork:simplePassOpenPanel(self.simplePassId)
  self.ui.red_button_2:setVisible(ed.passDataMgr:getPassRewardCount(self.simplePassId) > 0)
  self.ui.red_button_1:setVisible(ed.activityHints.allStarTaskRed and 0 < ed.activityHints.allStarTaskRed)
end

function activityAllStarPage:showReward(reward)
  self:initDragList(reward)
end

function activityAllStarPage:showTask(task)
  self:initTaskDragList(task)
end

function activityAllStarPage:initTaskDragList(task)
  for i, v in ipairs(task) do
    if v._cond_type == "act_item_expire" then
      table.remove(task, i)
      break
    end
  end
  for i, v in ipairs(task) do
    local taskState = 0
    local isCompleted = v._progress >= v._cond_target
    local isFinished = v._cur_reward_times and v._cur_reward_times >= v._max_reward_times
    if isFinished then
      taskState = 2
    elseif isCompleted then
      taskState = 1
    end
    v.taskState = taskState
  end
  table.sort(task, function(a, b)
    local sortType = {
      [0] = 2,
      [1] = 3,
      [2] = 1
    }
    if sortType[a.taskState] == sortType[b.taskState] then
      return a._id < b._id
    else
      return sortType[a.taskState] > sortType[b.taskState]
    end
  end)
  if not self.taskDragList then
    self.items = {}
    local thisCon = self.ui.Panel_task_item:getContentSize()
    local info = {
      cliprect = CCRectMake(0, 0, thisCon.width, thisCon.height),
      container = self.ui.Panel_task_item,
      priority = -300,
      noshade = true,
      zorder = 10,
      doClickIn = self:doClickInList(),
      cancelClickIn = self:cancelClickInList(),
      doPressIn = self:doPressInList(),
      cancelPressIn = self:cancelPressInList()
    }
    self.taskDragList = ed.draglist.create(info)
    self.taskDragList:setVisible(false)
    for i, v in ipairs(task) do
      local item = self.taskItemBox.create(self, v, i)
      self.taskDragList:addItem(item.ui.layer, ccp(thisCon.width / 2, thisCon.height - 70 * i + 31))
      self.items[v._id] = item
    end
    self.taskDragList:initListHeight(#task * 70 + 6)
  else
    local isMoveTop
    local thisCon = self.ui.Panel_task_item:getContentSize()
    for i, v in ipairs(task) do
      if self.items[v._id].index ~= i then
        self.items[v._id].ui.layer:runAction(CCEaseExponentialOut:create(CCMoveTo:create(0.5, ccp(thisCon.width / 2, thisCon.height - 70 * i + 31))))
        if self.tasking and self.tasking == self.items[v._id].index and not isMoveTop then
          isMoveTop = true
        end
      end
      self.items[v._id]:update(v, i)
    end
    if isMoveTop then
      self.taskDragList.listLayer:stopAllActions()
      self.taskDragList.listLayer:runAction(CCEaseExponentialOut:create(CCMoveTo:create(0.5, ccp(0, 0))))
    end
  end
end

function activityAllStarPage:initDragList(reward)
  local moveIndex
  if not self.dragList then
    self.passItems = {}
    local thisCon = self.ui.Panel_item:getContentSize()
    local info = {
      cliprect = CCRectMake(0, 0, thisCon.width, thisCon.height),
      container = self.ui.Panel_item,
      priority = -300,
      noshade = true,
      zorder = 10,
      doClickIn = self:doClickInList(),
      cancelClickIn = self:cancelClickInList(),
      doPressIn = self:doPressInList(),
      cancelPressIn = self:cancelPressInList()
    }
    self.dragList = ed.draglist.create(info)
    for i, v in ipairs(reward) do
      local item = self.itemBox.create(self, v, i)
      self.dragList:addItem(item.ui.bg, ccp(76.5 * i - 38.25, thisCon.height / 2 + 1))
      table.insert(self.passItems, item)
      if not moveIndex and item.ui.up:isVisible() then
        moveIndex = i
      end
    end
    self.dragList:initListWidth(#reward * 76.5)
    self.dragList.listLayer:stopAllActions()
    local thisCon = self.ui.Panel_item:getContentSize()
    moveIndex = moveIndex or ed.passDataMgr:getCurrentLevel(self.simplePassId)
    if 14 < moveIndex then
      local setPosIndex = moveIndex - 7
      local movex = setPosIndex * 76.5 * -1 + thisCon.width / 2 + 30
      movex = ed.clamp(movex, (#reward * 76.5 - thisCon.width) * -1, 0)
      self.dragList.listLayer:setPositionX(0 < movex and 0 or movex)
    end
    local movex = moveIndex * 76.5 * -1 + thisCon.width / 2 + 30
    movex = ed.clamp(movex, (#reward * 76.5 - thisCon.width) * -1, 0)
    self.dragList.listLayer:runAction(CCEaseExponentialOut:create(CCMoveTo:create(0.8, ccp(0 < movex and 0 or movex, 0))))
  else
    for i, v in ipairs(self.passItems) do
      v:update(reward[i])
      if not moveIndex and v.ui.up:isVisible() then
        moveIndex = i
      end
    end
  end
end

function activityAllStarPage:setButtonClick()
  for index = 1, 2 do
    self:btRemoveMainTouchHandler({
      key = "activityAllStarPage_number" .. index
    })
    self:btRegisterButtonClick({
      button = self.ui["button_" .. index],
      selected = self.ui["button_selected_" .. index],
      key = "activityAllStarPage_number" .. index,
      radioGroupName = "activityAllStarPage_number",
      clickHandler = function(param, x, y)
        self.pageTouch = ed.containsPoint(self.ui.Panel_task_item, x, y)
        self.dragList:setVisible(index == 2)
        self.taskDragList:setVisible(index == 1)
        self.ui.ImageView_3415:setVisible(index == 2)
        local data = ed.passDataMgr:getPassData(self.simplePassId)
        local rank = data.rank or 0
        self.ui.ImageView_pay:setVisible(rank ~= 1 and index == 2)
      end
    })
  end
  self:btRemoveMainTouchHandler({
    key = "ImageView_pay"
  })
  self:btRegisterButtonClick({
    button = self.ui.ImageView_pay,
    key = "ImageView_pay",
    force = true,
    mcpMode = true,
    pressScale = 0.94,
    clickHandler = function()
      ed.showConfirmDialog({
        text = T("\230\152\175\229\144\166\232\180\173\228\185\176\232\190\137\231\133\140\228\185\139\232\183\175"),
        rightHandler = function()
          ed.passDataMgr:doRechargePass(self.simplePassId, 1)
        end
      })
    end
  })
  self:listenEvent("UpdatePassData", function(id)
    if id == self.simplePassId then
      self:refreshPassInfo()
      self:showReward(ed.passDataMgr:getPassRewardList(id))
      ed.activityHints:updateReds({
        _act_id = self.param._id
      })
      FireEvent("MainRedTagChange", ed.ui.configs.mainButton.ButtonType.ACTIVITY)
      self.ui.red_button_2:setVisible(ed.passDataMgr:getPassRewardCount(self.simplePassId) > 0)
      self.ui.red_button_1:setVisible(ed.activityHints.allStarTaskRed and 0 < ed.activityHints.allStarTaskRed)
    end
  end)
  self:listenEvent("passBuySuccess", function(id, rank)
    if id == self.simplePassId then
      self:refreshPassInfo()
      self:showReward(ed.passDataMgr:getPassRewardList(id))
      ed.activityHints:updateReds({
        _act_id = self.param._id
      })
      FireEvent("MainRedTagChange", ed.ui.configs.mainButton.ButtonType.ACTIVITY)
      self.ui.red_button_2:setVisible(ed.passDataMgr:getPassRewardCount(self.simplePassId) > 0)
      self.ui.red_button_1:setVisible(ed.activityHints.allStarTaskRed and 0 < ed.activityHints.allStarTaskRed)
    end
  end)
end

function activityAllStarPage:setVisibleCallBack(isVisible)
  if self.taskDragList then
    self.taskDragList:setVisible(isVisible and not self.ui.ImageView_3415:isVisible())
  end
  if self.dragList then
    self.dragList:setVisible(isVisible and self.ui.ImageView_3415:isVisible())
  end
end

local itemBox = {}

function itemBox.create(mainSelf, param, index)
  local this = setmetatable({
    mainSelf = mainSelf,
    param = param,
    index = index
  }, {__index = itemBox})
  this:initUi(param)
  return this
end

function itemBox:initUi(param)
  local bg = ed.createSpriteTools({
    res = "UI/alpha/1080P/allstar/allstar_pass/rewardlist1.png",
    pos = ccp(0, 0)
  })
  local up = ed.createSpriteTools({
    res = "UI/alpha/1080P/allstar/allstar_pass/rewardlist4.png",
    pos = ccp(38, 137.75),
    parent = bg,
    notShow = true
  })
  ed.createLabelTools({
    txt = T("%d\231\186\167", self.index),
    size = 17,
    pos = ccp(38, 260),
    color = ccc3(242, 228, 172),
    parent = bg,
    font = ed.fontBold
  })
  local pos = {182, 72}
  self.items = {}
  for i, v in ipairs(pos) do
    local item = ed.taskItemModule.new(self, {
      id = param[i].rewardId,
      type = param[i].rewardType,
      amount = param[i].rewardAmount,
      index = i
    }, nil, self.index .. i, false, false, false)
    item.icon:setPosition(38, v)
    bg:addChild(item.icon)
    item.icon:setScale(0.85)
    self.items[i] = item
  end
  self.ui = {bg = bg, up = up}
  self:update(param)
end

function itemBox:update(param)
  local imgType = {
    NOT_REACHED = 0,
    LOCK = 0,
    AVAILABLE = 1,
    RECEIVED = 2
  }
  local show = false
  for i, v in ipairs(self.items) do
    v:refresh(imgType[param[i].rewardState])
    show = show or param[i].rewardState == ed.passDefine.REWARD_STATE_AVAILABLE
  end
  self.ui.up:setVisible(show)
  self.param = param
end

function itemBox:btRegisterButtonClickToListItems(param)
end

activityAllStarPage.itemBox = itemBox
local taskItemBox = {}

function taskItemBox.create(mainSelf, param, index)
  local this = setmetatable({
    mainSelf = mainSelf,
    param = param,
    index = index
  }, {__index = taskItemBox})
  this:initUi(param)
  return this
end

function taskItemBox:initUi(param)
  local layer = CCLayer:create()
  local bg1 = ed.createSpriteTools({
    res = "UI/alpha/1080P/allstar/allstar_pass/tasklist2.png",
    parent = layer
  })
  ed.createLabelTools({
    txt = T("\229\183\178\229\174\140\230\136\144"),
    size = 16,
    pos = ccp(50.75, 30),
    color = ccc3(111, 94, 71),
    parent = ed.createSpriteTools({
      res = "UI/alpha/1080P/taskModel/day_task/daily_task_pass.png",
      parent = bg1,
      pos = ccp(600, 33.5)
    })
  })
  local bg2 = ed.createSpriteTools({
    res = "UI/alpha/1080P/allstar/allstar_pass/tasklist1.png",
    parent = layer
  })
  local goBtn = ed.createSpriteTools({
    res = "UI/alpha/1080P/common/button_mini_sys.png",
    parent = bg2,
    pos = ccp(600, 33.5)
  })
  ed.createLabelTools({
    txt = T("\229\137\141\229\190\128"),
    size = 18,
    pos = ccp(50.75, 20.75),
    ed.toccc3(16776678),
    parent = goBtn
  })
  local bg3 = ed.createSpriteTools({
    res = "UI/alpha/1080P/allstar/allstar_pass/task_bg2.png",
    parent = layer
  })
  local getBtn = ed.createSpriteTools({
    res = "UI/alpha/1080P/common/button_com_mini.png",
    parent = bg3,
    pos = ccp(600, 33.5)
  })
  ed.createLabelTools({
    txt = T("\233\162\134\229\143\150"),
    size = 18,
    pos = ccp(50.75, 20.75),
    ed.toccc3(16776678),
    parent = getBtn
  })
  local progressBg = ed.createSpriteTools({
    res = "UI/alpha/1080P/taskModel/day_task/day_task_progress_3.png",
    parent = bg3,
    pos = ccp(121.5, 19)
  })
  local progress = ed.createSpriteTools({
    res = "UI/alpha/1080P/taskModel/day_task/day_task_progress_4.png",
    parent = progressBg,
    pos = ccp(1, 4.75),
    anchor = ccp(0, 0.5),
    rectMake = CCRectMake(5, 1, 181.5, 1),
    sizeMake = CCSizeMake(191.5, 9.5)
  })
  self.progressBoxFinish = ed.taskProModule.new(progress, 15)
  self.progressBoxFinish:setPro(param._progress / param._cond_target)
  local progressBg2 = ed.createSpriteTools({
    res = "UI/alpha/1080P/taskModel/day_task/day_task_progress_1.png",
    parent = layer,
    pos = ccp(-210, -14)
  })
  local progress = ed.createSpriteTools({
    res = "UI/alpha/1080P/taskModel/day_task/day_task_progress_2.png",
    parent = progressBg2,
    pos = ccp(1, 4.75),
    anchor = ccp(0, 0.5),
    rectMake = CCRectMake(5, 1, 181.5, 1),
    sizeMake = CCSizeMake(191.5, 9.5)
  })
  local progressLabel = ed.createLabelTools({
    txt = T("%s/%s", param._progress, param._cond_target),
    size = 15,
    pos = ccp(-210, -14),
    color = ccc3(242, 228, 172),
    parent = layer,
    stroke = {
      ccc3(ed.colorToStr("#272524")),
      1.3
    }
  })
  local des = ed.createLabelTools({
    txt = ed.activityTaskTool.getTaskDesc(param),
    size = 18,
    pos = ccp(-302, 9.5),
    color = ccc3(242, 228, 172),
    parent = layer,
    anchor = ccp(0, 0.5)
  })
  self.progressBox = ed.taskProModule.new(progress, 15)
  self.progressBox:setPro(param._progress / param._cond_target)
  self.items = {}
  for i, v in ipairs(param._rewards or {}) do
    local item = ed.taskItemModule.new(self, {
      id = v._id,
      type = v._type,
      amount = v._amount
    }, nil, param._id .. i, false, false, true)
    item.icon:setPosition(-20 + i * 74, 0)
    layer:addChild(item.icon)
    item.icon:setScale(0.7)
    table.insert(self.items, item)
  end
  self.ui = {
    bg1 = bg1,
    bg2 = bg2,
    bg3 = bg3,
    layer = layer,
    des = des,
    progressBg = progressBg,
    progressBg2 = progressBg2,
    progressLabel = progressLabel,
    getBtn = getBtn,
    goBtn = goBtn
  }
  self.desColor = {
    {
      color = ccc3(250, 227, 183),
      stroke = ed.toccc3(3877927)
    },
    {
      color = ccc3(255, 255, 255),
      stroke = ed.toccc3(6701072)
    },
    {
      color = ccc3(218, 203, 212),
      stroke = ed.toccc3(2565412)
    }
  }
  self:update(param)
end

function taskItemBox:update(param, index)
  self.ui.bg1:setVisible(param.taskState == 2)
  self.ui.bg2:setVisible(param.taskState == 0)
  self.ui.bg3:setVisible(param.taskState == 1)
  self.ui.des:setColor(self.desColor[param.taskState + 1].color)
  self.ui.des:setStroke(self.desColor[param.taskState + 1].stroke, 1)
  for _, v in ipairs(self.items) do
    v:refresh(param.taskState)
  end
  self.ui.progressBg2:setVisible(param.taskState ~= 1)
  self.ui.progressBg:setVisible(param.taskState == 1)
  self.ui.progressLabel:setString(T("%s/%s", param._progress, param._cond_target))
  if self.param and self.param._progress ~= param._progress and 0 < param._progress then
    self.progressBox:addPro(param._progress / param._cond_target)
    self.progressBoxFinish:addPro(param._progress / param._cond_target)
  end
  self.param = param
  self.index = index
end

function taskItemBox:btRegisterButtonClickToListItems(param)
end

activityAllStarPage.taskItemBox = taskItemBox

function activityAllStarPage:doPressInList()
  local function handler(x, y)
    if self.dragList:isVisible() then
      for i, v in ipairs(self.passItems or {}) do
        for ii, vv in ipairs(v.items or {}) do
          if ed.containsPoint(vv.icon, x, y) then
            vv.icon:setScale(0.8)
            
            return {
              icon = vv.icon,
              fun = function()
                local data = vv.param or {}
                local rewardData = v.param[ii]
                if rewardData.rewardState == ed.passDefine.REWARD_STATE_AVAILABLE then
                  ed.passNetWork:simplePassReq({
                    passId = self.simplePassId,
                    isAllReward = false,
                    rewardPos = rewardData.rewardPos,
                    rewardIndex = rewardData.rewardIndex
                  })
                else
                  ed.UITool.openView("packageDetail", data)
                end
              end,
              normalScale = 0.85
            }
          end
        end
      end
      return
    end
    for k, v in pairs(self.items or {}) do
      if v.param.taskState and v.param.taskState == 1 and ed.containsPoint(v.ui.getBtn, x, y) then
        v.ui.getBtn:setScale(0.95)
        return {
          icon = v.ui.getBtn,
          fun = function()
            self.objWork:activitySubmit(self.param._id, v.param._id)
          end
        }
      elseif v.param.taskState and v.param.taskState == 0 and ed.containsPoint(v.ui.goBtn, x, y) then
        v.ui.goBtn:setScale(0.95)
        return {
          icon = v.ui.goBtn,
          fun = function()
            if v.param._cond_type == "add_hero" or v.param._cond_type == "hero_evolve" then
              ed.UITool.openView("summonScene", {page = 1})
            else
              ed.activityTaskTool.taskSkip(v.param._cond_type, v.param._cond_id)
            end
            self.objWork:setEnterHandler(self.param._id)
            self.tasking = v.index
          end
        }
      end
      for _, vv in pairs(v.items) do
        if ed.containsPoint(vv.icon, x, y) then
          vv.icon:setScale(0.65)
          return {
            icon = vv.icon,
            fun = function()
              ed.UITool.openView("packageDetail", vv.param or {})
            end,
            normalScale = 0.7
          }
        end
      end
    end
  end
  
  return handler
end

function activityAllStarPage:cancelPressInList()
  local function handler(x, y, info)
    info.icon:setScale(info.normalScale or 1)
  end
  
  return handler
end

function activityAllStarPage:cancelClickInList()
  local function handler(x, y, info)
    info.icon:setScale(info.normalScale or 1)
  end
  
  return handler
end

function activityAllStarPage:doClickInList()
  local function handler(x, y, info)
    if info.fun then
      info.fun()
    end
  end
  
  return handler
end
