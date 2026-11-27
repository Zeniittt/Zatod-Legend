local base = ed.ui.popwindow
local taskScene = newclass(base.mt)
ed.ui.taskScene = taskScene
local pagekey = {
  "pass",
  "day",
  "role",
  "ach"
}
local playerLvKey = {day = "DailyLogin", pass = "DailyPass"}
local pageName = {
  day = T("\230\151\165\229\184\184"),
  pass = T("\229\165\150\229\138\177"),
  role = T("\228\187\187\229\138\161"),
  ach = T("\230\136\144\229\176\177")
}
ed.UITool.registViewOpenFunc("taskScene", function(param)
  ed.ui.taskScene.create(param or {}):popWindow()
end)

function taskScene.create(param)
  local self = base.create("taskScene")
  setmetatable(self, taskScene.mt):init(param or {}):show({skipAnim = true})
  return self
end

function taskScene:init(param)
  self.param = setmetatable(param or {}, {
    __index = {page = 1}
  })
  self.pageObj = {}
  self.touchKey = {}
  local newPagekey = {}
  for i, v in ipairs(pagekey or {}) do
    if not playerLvKey[v] or not ed.playerlimit.getAreaUnlockPrompt(playerLvKey[v]) then
      self.pageObj[v] = require("ui_new.modules.task.taskScene.pages." .. v .. "Page")
      table.insert(newPagekey, v)
    end
  end
  self.pagekey = newPagekey
  self:createRegisterButtonClick()
  self:uiCreate()
  self:registerBtnEvents()
  return self
end

function taskScene:uiCreate()
  self.containers, self.ui = ed.editorui(ed.uieditor.taskLaye)
  self.container:addChild(self.containers)
  self:initWinsize(self.ui)
  self:btnCreate()
  self:layerIsShow()
end

function taskScene:btnCreate()
  local pageIdx = self.param.page
  
  local function func(text)
    local node = CCLayer:create()
    node:setContentSize(CCSizeMake(70, 70))
    node:setAnchorPoint(ccp(0, 0.5))
    local normal = ed.createSprite("UI/alpha/1080P/taskModel/task_pop_btn_1.png")
    normal:setAnchorPoint(ccp(0, 0.5))
    node:addChild(normal)
    local label = ed.createttf(text or "nil", 19)
    label:limitWidthByScale(52)
    label:setPosition(ccp(30, 45))
    label:setColor(ccc3(255, 252, 231))
    label:setStroke(ccc3(96, 56, 37), 1)
    normal:addChild(label)
    local red = ed.createSprite("UI/alpha/1080P/common/digit_red_tag_bg.png")
    red:setPosition(57, 75)
    normal:addChild(red)
    normal:setVisible(false)
    local pass = ed.createSprite("UI/alpha/1080P/taskModel/task_pop_btn_2.png")
    pass:setAnchorPoint(ccp(0, 0.5))
    pass:setPosition(4, 5.5)
    pass:setVisible(false)
    node:addChild(pass)
    local label = ed.createttf(text or "nil", 19)
    label:limitWidthByScale(50)
    label:setPosition(ccp(28, 34))
    label:setColor(ccc3(113, 68, 38))
    pass:addChild(label)
    label:setShadow(ccc3(255, 243, 199), ccp(0, 3))
    local nodeTuch = CCLayer:create()
    nodeTuch:setPosition(25, 8)
    node:addChild(nodeTuch)
    return {
      node = node,
      normal = normal,
      pass = pass,
      red = red,
      nodeTuch = nodeTuch
    }
  end
  
  local function btnFunc(index)
    return function()
      if self.param.page ~= index then
        self.btnList[self.param.page].normal:setVisible(true)
        self.btnList[self.param.page].pass:setVisible(false)
        self.param.page = index
        self.btnList[self.param.page].pass:setVisible(true)
        self.btnList[self.param.page].normal:setVisible(false)
        self:layerIsShow()
      end
    end
  end
  
  local posy = (#pagekey - #self.pagekey) * 88
  self.btnList = {}
  for i, v in ipairs(self.pagekey or {}) do
    self.btnList[i] = func(pageName[v])
    self.btnList[i].node:setPosition(18, 88 * (#self.pagekey + 1 - i) - 15 + posy)
    self.ui.btn_layer:addChild(self.btnList[i].node)
    self.btnList[i].pass:setVisible(pageIdx == i)
    self.btnList[i].normal:setVisible(pageIdx ~= i)
    self.btnList[i].red:setVisible(ed.taskData:getRed(v) > 0)
    self.btnList[i].name = v
    self:btRemoveMainTouchHandler({
      key = "btn_page_" .. i
    })
    self.oldBtRegisterButtonClick(self, {
      button = self.btnList[i].normal,
      key = "btn_page_" .. i,
      clickHandler = btnFunc(i),
      force = true,
      pressScale = 0.9,
      clickInterval = 0.2
    })
  end
end

function taskScene:indexLayerShow(key)
  local index = 1
  for i, v in ipairs(self.btnList) do
    if v.name == key then
      index = i
      break
    end
  end
  self.btnList[self.param.page].normal:setVisible(true)
  self.btnList[self.param.page].pass:setVisible(false)
  self.param.page = index
  self.btnList[self.param.page].pass:setVisible(true)
  self.btnList[self.param.page].normal:setVisible(false)
  self:layerIsShow()
end

function taskScene:refreshPageReds()
  for i, v in ipairs(self.pagekey or {}) do
    self.btnList[i].red:setVisible(ed.taskData:getRed(v) > 0)
  end
end

function taskScene:layerIsShow()
  local pageIdx = self.param.page
  for i, v in ipairs(self.pagekey or {}) do
    if pageIdx == i then
      if self.layerSelf then
        self.layerSelf:delete()
        self:removeTouchHandler()
        self.ui.ui_layer:removeAllChildrenWithCleanup(true)
      end
      self.showKey = v
      self.layerSelf = self.pageObj[v].create(self, ed.taskData:getPageDataObj(v))
      self.ui.ui_layer:addChild(self.layerSelf.container)
      break
    end
  end
end

local olddestroy = taskScene.destroy

local function func(self, param)
  local panel = ed.getPopWindow("psssPageShopPop")
  if panel then
    panel:destroy()
  end
  local panel = ed.getPopWindow("achPagePointPop")
  if panel then
    panel:destroy()
  end
  self:removeTouchHandler()
  ListenTimer(Timer:Once(0.2), function()
    FireEvent("MainRedTagChange", ed.ui.configs.mainButton.ButtonType.TASK)
  end)
  self.layerSelf:delete()
  olddestroy(self, param)
end

taskScene.destroy = func

function taskScene:registerBtnEvents()
  self.oldBtRegisterButtonClick(self, {
    button = self.ui.btn_brak,
    key = "btn_brak",
    clickHandler = function()
      self:destroy({skipAnim = true})
    end,
    force = true,
    pressScale = 0.75,
    normalScale = 0.85
  })
  self:listenEvent("taskPagesReds", function()
    self:refreshPageReds()
  end)
  self:registerOnEnterHandler("onEnter", function()
    self:onEnterScene()
  end)
end

function taskScene:onEnterScene()
  if not self.notOneOpen then
    self.notOneOpen = true
    return
  end
  if self.layerSelf and self.layerSelf.onEnterScene then
    self.layerSelf:onEnterScene()
  end
  if self.layerSelf and self.layerSelf.registerEvents then
    self.layerSelf:delete()
    self.layerSelf:registerEvents()
  end
end

function taskScene:removeTouchHandler()
  for i, v in ipairs(self.touchKey or {}) do
    self:btRemoveMainTouchHandler({key = v})
  end
  self.touchKey = {}
end

function taskScene:createRegisterButtonClick()
  self.oldBtRegisterButtonClick = self.btRegisterButtonClick
  
  function self:btRegisterButtonClick(param)
    if param and param.key then
      table.insert(self.touchKey, param.key)
      self.oldBtRegisterButtonClick(self, param)
    end
  end
end

function taskScene:initWinsize(ui)
  local widhtWin = ed.display.winSize.width
  local heightWin = ed.display.winSize.height
  local newWid = ed.display.halfFixedWidth * 2
  local newHei = ed.display.halfFixedHeight * 2
  local x, y = ui.btn_brak:getPosition()
  ui.btn_brak:setPosition(x - newWid / 2 + 20, y + newHei / 2 - 5)
  newWid = newWid * 0.7
  newHei = newHei * 0
  x, y = ui.btn_layer:getPosition()
  ui.btn_layer:setPosition(x + newWid / 2, y + newHei / 2)
  local size = ui.ImageView_23:getContentSize()
  ui.ImageView_23:setContentSize(CCSizeMake(size.width + newWid, size.height + newHei))
  size = ui.ImageView_23_Copy0:getContentSize()
  ui.ImageView_23_Copy0:setContentSize(CCSizeMake(size.width + newWid, size.height + newHei))
end

function taskScene:getTaskRewardReceiveBtn(taskLine, taskID)
  if self.showKey == "role" and self.pageObj.role then
    return self.layerSelf:getTaskRewardReceiveBtn(taskLine, taskID)
  end
  return nil
end

local function getNameToBtnfunc(btnList, key)
  for i, v in ipairs(btnList) do
    if v.name == key then
      return v
    end
  end
end

function taskScene:getGuideNode(nodeKey)
  local _, _, a, b = string.find(nodeKey, "taskreward_(%d)_(%d)")
  if a and b then
    return self:getTaskRewardReceiveBtn(tonumber(a), tonumber(b))
  elseif nodeKey == "playerTask_cancel" then
    local roleBtn = getNameToBtnfunc(self.btnList, "role")
    if roleBtn and roleBtn.nodeTuch then
      return roleBtn.nodeTuch
    end
  end
  return base.getGuideNode(self, nodeKey)
end

function taskScene:getGuideClipRect(nodeKey)
  if nodeKey == "taskreward_3_1" and self.showKey == "role" then
    local panel = self.layerSelf.ui.task_list_pos
    local wp = panel:convertToWorldSpace(ccp(0, 0))
    return CCRectMake(0, wp.y, ed.display.winSize.width, panel:getContentSize().height)
  end
  return base.getGuideClipRect(self, nodeKey)
end
