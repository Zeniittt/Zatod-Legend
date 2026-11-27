local class = {}
class.__index = class
ed.ui.dragonBoatPassTask = class

function class.create(params)
  local self = {}
  setmetatable(self, class)
  self:init(params)
  return self
end

function class:init(params)
  self:initData(params)
  self:initUI()
  self:registerEvents()
end

function class:initData(params)
  self.controller = params.controller
  self.cellSize = CCSizeMake(0, 0)
end

function class:initUI()
  local container, ui = ed.editorui(ed.uieditor.DragonBoatPassTask)
  self.container = container
  self.ui = ui
  self:initDraglist()
end

function class:initDraglist()
  local layerSize = self.ui.layer_task:getContentSize()
  local dl = ed.UITool.createDraglist(self.ui.layer_task, {
    priority = -300,
    doPressIn = self:doPressInList(),
    doClickIn = self:doClickInList(),
    cancelPressIn = self:cancelPressInList()
  })
  self.taskDragList = dl
end

function class:refreshDraglist()
  print("refreshDraglist refreshDraglistrefreshDraglistrefreshDraglistrefreshDraglist")
  local task = ed.dragonBoatMgr.getInstance():getActivityTask()
  if not self.listOver then
    self.items = {}
    local thisCon = self.ui.layer_task:getContentSize()
    self.taskDragList:clearList()
    self.listOver = false
    self.ui.layer_task:stopAllActions()
    local index = 1
    ed.timeSchedule(self.ui.layer_task, function()
      if not task[index] then
        self.ui.layer_task:stopAllActions()
        self.listOver = true
        return
      end
      local item = self.taskItemBox.create(self, task[index], index)
      self.taskDragList:addItem(item.ui.layer, ccp(thisCon.width / 2, thisCon.height - 69 * index + 38))
      self.items[task[index]._id] = item
      index = index + 1
    end, 0.01)
    self.taskDragList:initListHeight(#task * 69 + 3)
  else
    local upItems = {}
    local isMoveTop
    local thisCon = self.ui.layer_task:getContentSize()
    for i, v in ipairs(task) do
      if self.items[v._id].index ~= i then
        self.items[v._id].ui.layer:runAction(CCEaseExponentialOut:create(CCMoveTo:create(0.5, ccp(thisCon.width / 2, thisCon.height - 69 * i + 38))))
        if self.tasking and self.tasking == v._id and not isMoveTop then
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

function class:registerEvents()
  self.controller:listenEvent("RefreshDragonBoatActivityTask", function()
    self:refreshDraglist()
    ed.passNetWork:simplePassOpenPanel(ed.dragonBoatMgr.getInstance().passId)
  end)
  self.actId = ed.dragonBoatMgr.getInstance().activityInfo._id
  self.controller:registerOnEnterHandler("onEnter", function(type)
    ed.activityHints.network:activityPull(self.actId)
  end)
  ed.activityHints.network:activityPull(self.actId)
end

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
    res = "UI/alpha/1080P/dragonboat/db_pass/db_bg_list_claimed.png",
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
    res = "UI/alpha/1080P/dragonboat/db_pass/db_list_going.png",
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
    res = "UI/alpha/1080P/dragonboat/db_pass/db_list_activated.png",
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

class.taskItemBox = taskItemBox

function class:doPressInList()
  local function handler(x, y)
    for k, v in pairs(self.items or {}) do
      if v.param.taskState and v.param.taskState == 1 and ed.containsPoint(v.ui.getBtn, x, y) then
        v.ui.getBtn:setScale(0.95)
        
        return {
          icon = v.ui.getBtn,
          fun = function()
            ed.activityHints.network:activitySubmit(self.actId, v.param._id)
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
            self.tasking = v.param._id
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

function class:cancelPressInList()
  local function handler(x, y, info)
    info.icon:setScale(info.normalScale or 1)
  end
  
  return handler
end

function class:doClickInList()
  local function handler(x, y, info)
    if info.fun then
      info.fun(info.param or {})
    end
  end
  
  return handler
end
