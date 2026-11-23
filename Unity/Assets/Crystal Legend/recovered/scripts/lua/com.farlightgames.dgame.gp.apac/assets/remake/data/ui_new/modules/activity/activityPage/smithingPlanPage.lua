local smithingPlanPage = newclass("g")
ed.ui.smithingPlanPage = smithingPlanPage

function smithingPlanPage.create(base, param, pageKey)
  local this = {param = param, pageKey = pageKey}
  setmetatable(smithingPlanPage, {__index = base})
  setmetatable(this, {__index = smithingPlanPage})
  this:initView(param)
  this:setButtonClick()
  return this
end

function smithingPlanPage:initView(param)
  local container, ui = ed.editorui(ed.uieditor.activity_smithing_plan_page)
  self.ui = ui
  self.container = container
  local actiDataTable = ed.getDataTable("Activity")[param._cfg_id]
  self.legendEquipId = actiDataTable["Extra AN"][1] or 1
  local legendEquipCfg = ed.getDataTable("LegendEquip")[self.legendEquipId]
  ed.createSpriteTools({
    res = legendEquipCfg.Painting,
    pos = ccp(10, 20),
    parent = self.ui.Panel_mod,
    scale = 1
  })
  local label = ed.ui.gradientLabel.create({
    text = T("\228\188\160\229\165\135\194\183\229\134\176\231\148\178"),
    fontSize = 29,
    fontName = ed.fontBold,
    startColor = ed.toccc3(15202815),
    endColor = ed.toccc3(7657726),
    strokeStartColor = ed.toccc3(1998232),
    strokeEndColor = ed.toccc3(2508691),
    strokeSize = 3
  })
  label.node:setPosition(10, 110)
  self.ui.Panel_mod:addChild(label.node, 9)
  label:setString(legendEquipCfg["Equip Name"])
  local label = ed.ui.gradientLabel.create({
    text = T("\229\143\175\233\148\187\233\128\160\232\142\183\229\190\151"),
    fontSize = 13,
    startColor = ed.toccc3(16776931),
    endColor = ed.toccc3(16775582),
    strokeColor = ed.toccc3(4726807),
    strokeSize = 1
  })
  label.node:setPosition(68, 15)
  self.ui.ImageView_24596:addChild(label.node, 9)
  self.ui.gotoSceneLabel = label.node
  ui.Label_time:setStroke(ed.toccc3(9263891), 1.2)
  self.ui.Label_time:setString(T("\229\137\169\228\189\153 %s", param.endTimeStr or 0))
  local task = param._tasks
  local task1, task2 = self:splitTaskState(task)
  self:initTaskList(task1)
  self:initDragList(task2)
  self.objWork:activityPull(param._id)
  local halfFixedWidth = ed.display.halfFixedWidth
  self.ui.Panel_title:setPositionX(self.ui.Panel_title:getPositionX() - halfFixedWidth * 0.2)
  self.ui.Panel_mod:setPositionX(self.ui.Panel_mod:getPositionX() - halfFixedWidth * 0.2)
  self.ui.Panel_task:setPositionX(self.ui.Panel_task:getPositionX() + halfFixedWidth * 0.2)
  self.ui.Panel_item:setPositionX(self.ui.Panel_item:getPositionX() + halfFixedWidth * 0.2)
  self.ui.ImageView_24599:setPositionX(self.ui.ImageView_24599:getPositionX() + halfFixedWidth * 0.2)
  local eff_Light = ed.createSpine("effect/eff_UI_smithing_plan_axe/eff_UI_smithing_plan_axe", 0.5)
  eff_Light:setAnimation(0, "Idle", true)
  eff_Light:setPosition(ccp(10, -90))
  self.ui.Panel_mod:addChild(eff_Light)
end

function smithingPlanPage:pageUpDate(param)
  self.param = param
  local task = param._tasks
  local task1, task2 = self:splitTaskState(task)
  self:refreshTaskList(task1)
  self:refreshDragList(task2)
end

function smithingPlanPage:splitTaskState(task)
  local task1, task2 = {}, {}
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
    table.insert(v._cond_type == "task_progress" and task1 or task2, v)
  end
  table.sort(task1, function(a, b)
    return a._cond_target < b._cond_target
  end)
  table.sort(task2, function(a, b)
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
  return task1, task2
end

function smithingPlanPage:setButtonClick()
  ed.UITool.registerBtn(self, "gotoSceneLabel", function()
    ed.UITool.openView("fireForgeMainScene")
  end, {normalScale = 1, pressScale = 1})
  ed.UITool.registerBtn(self, "ImageView_24597", function()
    ed.UITool.openView("fireForgeMainScene")
  end, {normalScale = 1, pressScale = 1})
  ed.UITool.registerBtn(self, "ImageView_24623", function()
    ed.ui.packageDetailWin.create({
      id = self.legendEquipId,
      type = "LegendEquip"
    }):popWindow()
  end, {normalScale = 1, pressScale = 0.95})
end

function smithingPlanPage:initTaskList(task)
  local progress = CCProgressTimer:create(self.ui.progress)
  progress:setType(kCCProgressTimerTypeBar)
  progress:setMidpoint(ccp(0, 0.5))
  progress:setBarChangeRate(ccp(1, 0))
  self.ui.Panel_task:addChild(progress)
  progress:setPosition(self.ui.progress:getPosition())
  self.progress = progress
  self.ui.progress:setVisible(false)
  self.taskBoxs = {}
  local percentage
  local wid = 515 / (#task + 1)
  local pro = 100 / (#task + 1)
  for i, v in ipairs(task) do
    local box = self.taskBox.create(self, v, i)
    box.ui.lay:setPosition(wid * i, 82.5)
    self.ui.Panel_task:addChild(box.ui.lay)
    table.insert(self.taskBoxs, box)
    if v._progress < v._cond_target and not percentage then
      percentage = pro * i * (v._progress / v._cond_target)
    end
  end
  self.progress:setPercentage(percentage or 100)
end

function smithingPlanPage:refreshTaskList(task)
  local percentage
  local pro = 100 / (#task + 1)
  for i, v in ipairs(task) do
    self.taskBoxs[i]:update(v)
    if v._progress < v._cond_target and not percentage then
      percentage = pro * i * (v._progress / v._cond_target)
    end
  end
  self.progress:runAction(CCProgressTo:create(0.5, percentage or 100))
end

function smithingPlanPage:initDragList(task)
  self.items = {}
  local thisCon = self.ui.Panel_item:getContentSize()
  local info = {
    cliprect = CCRectMake(0, 0, thisCon.width, thisCon.height),
    container = self.ui.Panel_item,
    priority = -300,
    noshade = true,
    zorder = 10,
    doPressIn = self:doPressInList(),
    doClickIn = self:doClickInList(),
    cancelPressIn = self:cancelPressInList()
  }
  self.dragList = ed.draglist.create(info)
  for i, v in ipairs(task) do
    local item = self.itemBox.create(self, v, i)
    self.dragList:addItem(item.ui.bg, ccp(thisCon.width / 2, thisCon.height - 90 * i + 44))
    self.items[v._id] = item
  end
  self.dragList:initListHeight(#task * 90)
end

function smithingPlanPage:refreshDragList(task)
  local listTop
  local thisCon = self.ui.Panel_item:getContentSize()
  for i, v in ipairs(task) do
    if self.items[v._id].index ~= i then
      if v.taskState == 1 then
        listTop = true
      end
      self.items[v._id].ui.bg:runAction(CCEaseExponentialOut:create(CCMoveTo:create(0.5, ccp(thisCon.width / 2, thisCon.height - 90 * i + 44))))
    end
    self.items[v._id]:update(v, i)
  end
  if listTop then
    self.dragList.listLayer:stopAllActions()
    self.dragList.listLayer:runAction(CCEaseExponentialOut:create(CCMoveTo:create(0.5, ccp(0, 0))))
  end
end

local taskBox = {}

function taskBox.create(mainSelf, param, index)
  return setmetatable({
    mainSelf = mainSelf,
    param = param,
    index = index
  }, {__index = taskBox}):init(param)
end

function taskBox:init(param)
  local lay = ed.createCCLayer({})
  local available = ed.createSpriteTools({
    res = "UI/alpha/1080P/activity/smithing_plan/available.png",
    parent = lay
  })
  local reward1 = ed.createSpriteTools({
    res = "UI/alpha/1080P/activity/smithing_plan/reward1.png",
    pos = ccp(0, 0),
    parent = lay
  })
  local reward2 = ed.createSpriteTools({
    res = "UI/alpha/1080P/activity/smithing_plan/reward2.png",
    pos = ccp(0, 0),
    parent = lay
  })
  local reward = param._rewards[1]
  local item = ed.taskItemModule.new(self, {
    id = reward._id,
    type = reward._type,
    amount = reward._amount
  }, nil, param._id, false, false, true)
  item.icon:setPosition(0, 0)
  lay:addChild(item.icon, 99)
  item.icon:setScale(0.8)
  self.ui = {
    lay = lay,
    available = available,
    reward1 = reward1,
    item = item
  }
  self:update(param)
  return self
end

function taskBox:update(param)
  self.ui.available:setVisible(param.taskState == 1)
  self.ui.reward1:setVisible(param.taskState == 1)
  self.ui.item:refresh(param.taskState)
  if self.ui.completereward then
    self.ui.completereward:removeFromParentAndCleanup(true)
  end
  local completereward = ed.createSpriteTools({
    res = "UI/alpha/1080P/activity/smithing_plan/completereward" .. (param.taskState == 1 and 2 or 1) .. ".png",
    pos = ccp(0, -62),
    parent = self.ui.lay
  })
  local color = param.taskState == 1 and "ccc3(255,236,109)" or param.taskState == 2 and "ccc3(198,108,102)" or "ccc3(255,158,115)"
  local color2 = param.taskState == 2 and "ccc3(198,108,102)" or "ccc3(255,241,227)"
  local strokeColor = param.taskState == 1 and "ccc3(121,60,0)" or "ccc3(52,29,38)"
  local tip2 = T("<lable fontSize=f14 color=%s strokeColor=%s strokeSize=1>\229\174\140\230\136\144</lable><lable fontName=fontBold fontSize=f16 color=%s strokeColor=%s strokeSize=1>%d/%d</lable>", color, strokeColor, color2, strokeColor, param._progress, param._cond_target)
  local autoText = ed.ui.autoText.new()
  autoText:initParam({
    context = tip2,
    align = "CENTER",
    lineSpacing = 1
  })
  completereward:addChild(autoText.node)
  autoText.node:setPosition(-134, 11.5)
  self.ui.completereward = completereward
  self.param = param
end

function taskBox:btRegisterButtonClickToListItems(param)
  self.mainSelf:btRegisterButtonClick({
    button = param.button,
    key = "smithingPlan_" .. param.index,
    param = param,
    clickInterval = 1,
    clickHandler = function(param, x, y)
      if self.param.taskState == 1 then
        self.mainSelf.objWork:activitySubmit(self.mainSelf.param._id, self.param._id)
        self.mainSelf.objWork:activityPull(self.mainSelf.param._id)
      else
        local data = param.data or {}
        ed.UITool.openView("packageDetail", data)
      end
    end,
    force = true,
    pressScale = 0.77,
    normalScale = 0.8
  })
end

smithingPlanPage.taskBox = taskBox
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
  self.imgType = {
    [0] = 1,
    [1] = 3,
    [2] = 2
  }
  local bg = ed.createSpriteTools({
    res = string.format("UI/alpha/1080P/activity/smithing_plan/%s.png", param.taskState == 2 and "taskbg2" or param.taskState == 0 and "taskbg3" or "taskbg"),
    pos = ccp(0, 0)
  })
  local seal = ed.createSpriteTools({
    res = "UI/alpha/1080P/activity/smithing_plan/done.png",
    pos = ccp(375, 43.25),
    parent = bg,
    notShow = param.taskState ~= 2
  })
  ed.createLabelTools({
    txt = T("\229\183\178\229\174\140\230\136\144"),
    size = 16,
    pos = ccp(50, 31),
    color = ed.toccc3(7027780),
    parent = seal
  })
  if param.taskState == 2 then
    bg:setOpacity(128)
  end
  local desc = ed.createLabelTools({
    txt = ed.activityTaskTool.getTaskDesc(param),
    size = 18,
    pos = ccp(30, 43.25),
    color = ed.toccc3(3808287),
    anchor = ccp(0, 0.5),
    parent = bg
  })
  local target = ed.createLabelTools({
    txt = string.format("%s/%s", param._progress, param._cond_target),
    size = 18,
    pos = ccp(343, 43.25),
    color = ed.toccc3(3808287),
    parent = bg,
    notShow = param.taskState ~= 0
  })
  ed.setLabelDimensions(desc, CCSizeMake(160, 0))
  local arrows = ed.createSpriteTools({
    res = "UI/alpha/1080P/activity/smithing_plan/arrows.png",
    pos = ccp(405, 43.25),
    parent = bg,
    notShow = param.taskState ~= 0
  })
  arrows:runAction(CCRepeatForever:create(CCSequence:createWithTwoActions(CCMoveBy:create(0.7, ccp(-10, 0)), CCMoveBy:create(0.7, ccp(10, 0)))))
  local button = ed.createSpriteTools({
    res = "UI/alpha/1080P/common/button_com_mini.png",
    pos = ccp(355, 43.25),
    parent = bg,
    notShow = param.taskState ~= 1
  })
  button.txt = ed.createLabelTools({
    txt = T("\233\162\134\229\143\150"),
    size = 17,
    pos = ccp(50, 22),
    color = ccc3(253, 245, 169),
    parent = button
  })
  if param.taskState == 2 then
    desc:setColor(ed.toccc3(15118248))
  end
  local reward = param._rewards[1]
  local item = ed.taskItemModule.new(self, {
    id = reward._id,
    type = reward._type,
    amount = reward._amount
  }, nil, param._id, false, false, true)
  item.icon:setPosition(230, 43.25)
  bg:addChild(item.icon)
  item.icon:setScale(0.8)
  item:refresh(param.taskState)
  self.ui = {
    bg = bg,
    seal = seal,
    desc = desc,
    target = target,
    item = item,
    button = button,
    arrows = arrows
  }
end

function itemBox:update(param, index)
  self.param = param
  self.index = index
  self.ui.bg:setOpacity(param.taskState ~= 2 and 255 or 128)
  ed.setTexture(self.ui.bg, string.format("UI/alpha/1080P/activity/smithing_plan/%s.png", param.taskState == 2 and "taskbg2" or param.taskState == 0 and "taskbg3" or "taskbg"))
  self.ui.target:setString(string.format("%s/%s", param._progress, param._cond_target))
  self.ui.target:setVisible(param.taskState == 0)
  self.ui.arrows:setVisible(param.taskState == 0)
  self.ui.seal:setVisible(param.taskState == 2)
  self.ui.button:setVisible(param.taskState == 1)
  if param.taskState == 2 then
    self.ui.desc:setColor(ed.toccc3(15118248))
  else
    self.ui.desc:setColor(ed.toccc3(3808287))
  end
  self.ui.item:refresh(param.taskState)
end

smithingPlanPage.itemBox = itemBox

function smithingPlanPage:doPressInList()
  local function handler(x, y)
    for _, v in pairs(self.items) do
      if ed.containsPoint(v.ui.button, x, y) then
        if ed.containsPoint(v.ui.arrows, x, y) and v.ui.arrows:isVisible() or ed.containsPoint(v.ui.target, x, y) and v.ui.target:isVisible() then
          return {
            icon = v.ui.arrows,
            
            fun = function(this)
              if this.param._cond_type == "add_hero" or this.param._cond_type == "hero_evolve" then
                ed.UITool.openView("summonScene", {page = 1})
              else
                ed.activityTaskTool.taskSkip(this.param._cond_type, this.param._cond_id)
              end
              self.objWork:setEnterHandler(self.param._id)
            end,
            param = v,
            normalScale = 1
          }
        elseif v.ui.button:isVisible() then
          v.ui.button:setScale(0.95)
          return {
            icon = v.ui.button,
            fun = function(this)
              self.objWork:activitySubmit(self.param._id, this.param._id)
              self.objWork:activityPull(self.param._id)
            end,
            param = v,
            normalScale = 1
          }
        end
      elseif ed.containsPoint(v.ui.item.icon, x, y) then
        v.ui.item.icon:setScale(0.75)
        return {
          icon = v.ui.item.icon,
          fun = function(this)
            local reward = this.param._rewards[1]
            ed.UITool.openView("packageDetail", {
              id = reward._id,
              type = reward._type,
              amount = reward._amount
            })
          end,
          param = v,
          normalScale = 0.8
        }
      end
    end
  end
  
  return handler
end

function smithingPlanPage:cancelPressInList()
  local function handler(x, y, info)
    info.icon:setScale(info.normalScale or 1)
  end
  
  return handler
end

function smithingPlanPage:doClickInList()
  local function handler(x, y, info)
    if info.fun then
      info.fun(info.param or {})
    end
  end
  
  return handler
end
