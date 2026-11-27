local page = {}

function page.create(sceneSelf, dataObj)
  local container, ui = ed.editorui(ed.uieditor.dayTaskLaye)
  return setmetatable({
    sceneSelf = sceneSelf,
    dataObj = dataObj,
    container = container,
    ui = ui,
    dailyItemSize = {width = 760, height = 70}
  }, {__index = page}):init()
end

function page:init()
  self:uiCreate()
  self:dragListCreate()
  self:dayTaskBoxCreate()
  ed.taskNetwork:dailyjobOpen()
  self:registerEvents()
  self:registerBtnEvents()
  ed.GobackManager:setDailyTaskRedLight(false)
  return self
end

function page:dragListCreate()
  local thisCon = self.ui.panel_list_pos:getContentSize()
  local info = {
    cliprect = CCRectMake(0, 0, thisCon.width, thisCon.height),
    container = self.ui.panel_list_pos,
    noshade = true,
    zorder = 10,
    priority = -300,
    doPressIn = function(x, y)
      return y
    end,
    cancelPressIn = function(x, y, oldy)
      self.touch = math.abs(oldy - y) < 20
    end
  }
  self.dragList = ed.draglist.create(info)
  self.dragList:setUpdateListItemVisibleEnable(true)
end

function page:dayTaskBoxCreate()
  local ui = {
    item_pos = self.ui.item_pos,
    task_str1 = self.ui.task_str1,
    task_str2 = self.ui.task_str2,
    task_str3 = self.ui.task_str3,
    down_bg_img = self.ui.down_bg_img,
    item_box_img = self.ui.item_box_img,
    image_tips = self.ui.image_tips
  }
  local param = {
    reward = self.dataObj:getDailyPassReward()
  }
  self.dayTaskBox = ed.dayTaskBoxModule.new(self, param, ui, {width = 779, height = 70})
end

function page:dayTaskBoxRefresh()
  local reward = self.dataObj:getDailyPassReward()
  self.dayTaskBox:refresh(self.dayTaskData, reward)
end

function page:registerEvents()
  self.sceneSelf:listenEvent("dailyjobReply", function(refreshType)
    self:refreshpage(refreshType)
  end)
  self.sceneSelf:listenEvent("PlayerLevelUp", function(level)
    self:dayTaskBoxRefresh()
  end)
end

function page:refreshpage(refreshType)
  if refreshType == "_open_panel" then
    self.dayTaskData = self.dataObj.dayTaskData
    self.dayTaskList = self.dataObj.dayTaskList
    self:dragLisCreate()
    self:dayTaskBoxRefresh()
    local passData = self.dataObj.passData or {}
    self.ui.label_level:setString((passData.level or 0) > 9 and passData.level or "0" .. (passData.level or 0))
    local exp, toExp, per = self.dataObj:getNewLvToExp()
    self.ui.label_exp_str:setString(string.format("%d/%d", exp, toExp))
    local dt = passData.exp_end_time - ed.getServerTime()
    self.timeOver = dt <= 0
    if not self.expProgressBox then
      self.expProgressBox = ed.taskProModule.new(self.ui.day_task_progress, 15)
      self.expProgressBox:setPro(per)
    elseif not self.timeOver and not self.dataObj.isToMax then
      self.expProgressBox:addPro(per)
    end
    if self.dataObj.isToMax then
      self.expProgressBox:setPro(1)
      self.ui.label_exp_str:setString("max")
    end
    if self.dataObj.titleText then
      ed.setLabelString(self.ui.label_title, self.dataObj.titleText)
      self.ui.label_title:setVisible(true)
      self.ui.label_title:limitWidthByScale(170)
    end
  elseif refreshType == "open_box_chest" then
    self.dayTaskData = self.dataObj.dayTaskData
    self:dayTaskBoxRefresh()
  elseif refreshType == "job_rewards_reply" then
    self.dayTaskList = self.dataObj.dayTaskList
    local passData = self.dataObj.passData
    self.ui.label_level:setString((passData.level or 0) > 9 and passData.level or "0" .. passData.level)
    local exp, toExp, per = self.dataObj:getNewLvToExp()
    self.ui.label_exp_str:setString(string.format("%d/%d", exp, toExp))
    if not self.timeOver then
      if not self.expProgressBox then
        self.expProgressBox = ed.taskProModule.new(self.ui.day_task_progress)
        self.expProgressBox:setPro(per)
      elseif self.dataObj.isToMax then
        self.expProgressBox:setPro(1)
        self.ui.label_exp_str:setString("max")
      else
        self.expProgressBox:addPro(per)
      end
    end
    self:dragListRefresh()
    self:dayTaskBoxRefresh()
  elseif refreshType == "increase_dailyjobCount" then
    self.dayTaskList = self.dataObj.dayTaskList
    self:dragListRefresh()
  end
end

function page:onEnterScene()
  self.dayTaskList = self.dataObj.dayTaskList
  self:dragListRefresh()
  self:dayTaskBoxRefresh()
end

function page:dragLisCreate(isCreate)
  if not isCreate and self.items and #self.items > 0 then
    self:dragListRefresh()
    return
  end
  local posx, posy = self.dragList:getList():getPosition()
  self.dragList:clearList()
  local thisCon = self.ui.panel_list_pos:getContentSize()
  local minScale = 1
  self.items = {}
  for i, v in ipairs(self.dayTaskList) do
    local fb = ed.basetask.createFastButton(self.sceneSelf, v, {isNocreateButton = true})
    v.fastEntry = fb.handler
    local item = ed.taskListItemLayModule.new(self, v, self.dailyItemSize)
    self.dragList:addItem(item.layer, ccp(self.dailyItemSize.width / 2, thisCon.height - i * (self.dailyItemSize.height + 2) + self.dailyItemSize.height / 2 - 10))
    self.items[v.id] = item
    minScale = math.min(minScale, item:getDetailLabelScale())
  end
  if minScale < 1 then
    for k, v in pairs(self.items) do
      v:adaptDetailLabelScale(minScale)
    end
  end
  self.dragList:initListHeight(#self.dragList.listItems * (self.dailyItemSize.height + 2) + self.dailyItemSize.height)
  if posx and posy then
    self.dragList:setListPos(ccp(posx, posy))
  end
  self.dragList.listLayer:runAction(CCEaseExponentialOut:create(CCMoveTo:create(0.5, ccp(0, 0))))
end

function page:dragListRefresh()
  local ismove = true
  local thisCon = self.ui.panel_list_pos:getContentSize()
  for i, v in ipairs(self.dayTaskList) do
    if self.items and self.items[v.id] then
      self.items[v.id].layer:runAction(CCEaseExponentialOut:create(CCMoveTo:create(0.5, ccp(self.dailyItemSize.width / 2, thisCon.height - i * (self.dailyItemSize.height + 2) + self.dailyItemSize.height / 2 - 10))))
      v.fastEntry = self.items[v.id].param.fastEntry
      self.items[v.id]:refresh(v)
    else
      ismove = false
      self:dragLisCreate(true)
      break
    end
  end
  if ismove then
    self.dragList.listLayer:runAction(CCEaseExponentialOut:create(CCMoveTo:create(0.5, ccp(0, 0))))
  end
end

function page:pushDailyjobReward(param)
  ed.taskNetwork:dailyOnekey(self.dataObj.oneKeys)
end

function page:pushSendOpenChest()
  ed.taskNetwork:sendOpenChest(self.dataObj:getActPointChestTable()["ActPointChest ID"])
end

local function btRegisterButtonClickToListItems()
  local index = 1
  return function(self, param)
    self.sceneSelf:btRegisterButtonClick({
      button = param.button,
      key = "day_page_items" .. index,
      radioGroupName = "items",
      param = param,
      clickInterval = 1,
      clickHandler = function(param, x, y)
        if not ed.containsPoint(self.ui.panel_list_pos, x, y) then
          return
        end
        if self.ui.down_bg_img:isVisible() and ed.containsPoint(self.ui.down_bg_img, x, y) and not param.data.box then
          return
        end
        if self.touch then
          local data = param.data or {}
          ed.ui.packageDetailWin.create(data):popWindow()
        end
      end,
      force = true,
      pressScale = 0.75,
      normalScale = 0.8
    })
    index = index + 1
  end
end

page.btRegisterButtonClickToListItems = btRegisterButtonClickToListItems()

function page:registerBtnEvents()
  local index = 1
  
  local function func(node, click, press, normal)
    self.sceneSelf:btRegisterButtonClick({
      button = node,
      key = "day_page_" .. index,
      clickHandler = click,
      force = true,
      pressScale = press or 0.9,
      normalScale = normal or 1
    })
    index = index + 1
  end
  
  func(self.ui.image_icon, function()
    self.sceneSelf:indexLayerShow("pass")
  end)
  func(self.ui.btn_rule_img, function()
    local rule = T(ed.taskData.ruleTxt.day or "", self.dataObj.passData.bonus or 1)
    if self.timeOver then
      rule = T(ed.taskData.ruleTxt.passOver or "")
    end
    ed.ui.commonRulePop.create({
      title = T("\230\151\165\229\184\184\230\180\187\229\138\168"),
      txt = rule
    }):popWindow()
  end)
end

function page:setVisible(vis)
  self.container:setVisible(vis)
end

function page:uiCreate()
  self.ui.label_exp:setStroke(ccc3(96, 56, 37), 1)
  self.ui.label_exp_str:setStroke(ccc3(96, 56, 37), 1)
  self.ui.label_level:setStroke(ccc3(96, 56, 37), 1)
  self.ui.label_title:setStroke(ed.toccc3(11892068), 2)
  self.ui.label_title:setFontName(ed.fontBold)
  self.ui.label_title:setVisible(false)
  local widhtWin = ed.display.winSize.width
  local heightWin = ed.display.winSize.height
  local newWid = ed.display.halfFixedWidth * 2
  local newHei = ed.display.halfFixedHeight * 2
  local ui = self.ui
  ed.right2(ui.label_exp_str, ui.label_exp, 2)
  newWid = newWid * 0.7
  newHei = newHei * 0
  
  local function posfunc(ui, isLeft, isDown)
    local newx, newy = isLeft and newWid / 2 * -1 or newWid / 2, isDown and newHei / 2 * -1 or newHei / 2
    local x, y = ui:getPosition()
    ui:setPosition(x + newx, y + newy)
  end
  
  local function sizefunc(ui)
    local size = ui:getContentSize()
    ui:setContentSize(CCSizeMake(size.width + newWid, size.height + newHei))
  end
  
  sizefunc(ui.title_bg_img)
  sizefunc(ui.img_down)
  posfunc(ui.label_title, true)
  posfunc(ui.image_icon, true)
  posfunc(ui.day_task_progress_bg, true)
  sizefunc(ui.day_task_progress_bg)
  posfunc(ui.day_task_progress, true)
  sizefunc(ui.day_task_progress)
  posfunc(ui.label_exp, true)
  posfunc(ui.label_exp_str, true)
  posfunc(ui.btn_rule_img)
  posfunc(ui.panel_list_pos, true)
  sizefunc(ui.panel_list_pos)
  sizefunc(ui.down_bg_img)
  posfunc(ui.item_box_img, true)
  posfunc(ui.ImageView_262, true)
  posfunc(ui.task_str1, true)
  posfunc(ui.task_str2, true)
  posfunc(ui.task_str3)
  self.dailyItemSize.halfFixedWidth = newWid
  self.dailyItemSize.width = self.dailyItemSize.width + newWid
  self.ui.label_level:setPositionY(self.ui.label_level:getPositionY() - 3)
end

function page:delete()
  CloseEvent("dailyjobReply")
end

return page
