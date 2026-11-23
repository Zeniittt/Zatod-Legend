local page = {}

function page.create(sceneSelf, dataObj)
  local container, ui = ed.editorui(ed.uieditor.achTaskLaye)
  ui.Label_3512:limitWidthByScale(70)
  ed.right2(ui.ImageView_357, ui.Label_3512, 12)
  ui.label_ach_count:setPositionX(ui.ImageView_357:getPositionX())
  return setmetatable({
    sceneSelf = sceneSelf,
    dataObj = dataObj,
    container = container,
    ui = ui,
    param = {page = 1},
    index = 1,
    dailyItemSize = {width = 773, height = 96}
  }, {__index = page}):init()
end

function page:init()
  self:uiCreate()
  if false then
    self:refreshpage("open_panel")
  else
    ed.taskNetwork:achievementPush()
  end
  self:registerEvents()
  self:registerBtnEvents()
  return self
end

function page:registerEvents()
  self.sceneSelf:listenEvent("achTaskReply", function(refreshType)
    self:refreshpage(refreshType)
  end)
end

local pageKey = {
  "Hero",
  "Player",
  "Guild",
  "Dungeon"
}
local pageName = {
  Hero = T("\232\139\177\233\155\132"),
  Player = T("\231\142\169\229\174\182"),
  Guild = T("\229\133\172\228\188\154"),
  Dungeon = T("\229\137\175\230\156\172")
}
local dragLists = {}

function page:btnPageCreate()
  local pageIdx = self.param.page or 1
  
  local function func(text)
    local node = CCLayer:create()
    node:setContentSize(CCSizeMake(70, 70))
    node:setAnchorPoint(ccp(0.5, 0.5))
    local normal = ed.createSprite("UI/alpha/1080P/taskModel/ach_task/ach_task_page_img1.png")
    normal:setAnchorPoint(ccp(0.5, 0.5))
    node:addChild(normal)
    local label = ed.createttf(text or "nil", 19)
    ed.adaptLabel(label, {
      maxWidth = 60,
      singleLine = true,
      minScale = 0.7
    })
    label:setPosition(ccp(34, 17))
    label:setColor(ccc3(255, 252, 231))
    label:setStroke(ccc3(96, 56, 37), 1)
    normal:addChild(label)
    local pass = ed.createSprite("UI/alpha/1080P/taskModel/ach_task/ach_task_page_img2.png")
    pass:setAnchorPoint(ccp(0.5, 0.5))
    pass:setVisible(false)
    node:addChild(pass)
    local red = ed.createSprite("UI/alpha/1080P/common/digit_red_tag_bg.png")
    red:setPosition(29, 11)
    node:addChild(red)
    local label = ed.createttf(text or "nil", 19)
    ed.adaptLabel(label, {
      maxWidth = 60,
      singleLine = true,
      minScale = 0.8
    })
    label:setPosition(ccp(34, 17))
    label:setColor(ccc3(113, 68, 38))
    pass:addChild(label)
    label:setShadow(ccc3(255, 243, 199), ccp(0, 3))
    return {
      node = node,
      normal = normal,
      pass = pass,
      red = red
    }
  end
  
  local function btnFunc(index)
    return function()
      self.btnList[self.param.page].pass:setVisible(false)
      self.param.page = index
      self.btnList[self.param.page].pass:setVisible(true)
      self:layerIsShow()
    end
  end
  
  local posx = (#pageKey - #self.pagekey) * 88
  self.btnList = {}
  for i, v in ipairs(self.pagekey or {}) do
    self.btnList[i] = func(pageName[v])
    self.btnList[i].node:setPosition(88 * i + posx / 2 + 200, 32)
    self.ui.panel_win:addChild(self.btnList[i].node)
    self.btnList[i].pass:setVisible(pageIdx == i)
    self.sceneSelf:btRegisterButtonClick({
      button = self.btnList[i].normal,
      key = "ach_btn_page_" .. i,
      clickHandler = btnFunc(i),
      force = true,
      pressScale = 0.9,
      clickInterval = 1
    })
  end
  self.ui.img_line_L:setPositionX(390 - #self.pagekey * 88 / 2)
  self.ui.img_line_R:setPositionX(450 + #self.pagekey * 88 / 2)
end

function page:refreshPageReds()
  for i, v in ipairs(self.pagekey or {}) do
    self.btnList[i].red:setVisible(self.dataObj:getModeRed(v) > 0)
  end
end

function page:layerIsShow()
  local index = self.param.page
  self.dragListMod = self.dragListMod or {}
  if self.oldIndex then
    self.dragListMod[self.oldIndex]:setVisible(false)
  end
  if self.dragListMod[index] then
    self.dragListMod[index]:setVisible(true)
  else
    self.dragListMod[index] = dragLists.new(self, {
      index = index,
      listData = self.dataObj.achTasks[self.pagekey[index]]
    }, self.ui.ach_list_pos, {})
  end
  self.oldIndex = index
end

local updatecon = false

function page:refreshpage(refreshType)
  if refreshType == "open_panel" then
    updatecon = true
    if not self.pagekey then
      self.pagekey = {}
      for i, v in ipairs(pageKey) do
        if self.dataObj.achTasks[v] then
          table.insert(self.pagekey, v)
        end
      end
      self:btnPageCreate()
      self:layerIsShow()
    else
      self.dragListMod[self.param.page]:refresh({
        listData = self.dataObj.achTasks[self.pagekey[self.param.page]]
      })
    end
    self:refreshPageReds()
    self:titleRefresh()
  elseif refreshType == "require_rewards" and updatecon then
    ed.taskNetwork:achievementPush()
    updatecon = false
  elseif refreshType == "point_rewards" and updatecon then
    ed.taskNetwork:achievementPush()
    updatecon = false
  end
end

function dragLists.new(sceneSelf, param, container, size)
  return setmetatable({
    sceneSelf = sceneSelf,
    container = container,
    param = param,
    size = size
  }, {__index = dragLists}):create()
end

function dragLists:create()
  local thisCon = self.container:getContentSize()
  local info = {
    cliprect = CCRectMake(0, 0, thisCon.width, thisCon.height),
    container = self.container,
    noshade = true,
    zorder = 10,
    priority = -300,
    doPressIn = function(x, y)
      return y
    end,
    cancelPressIn = function(x, y, oldy)
      self.sceneSelf.touch = math.abs(oldy - y) < 50
    end
  }
  self.draglist = ed.draglist.create(info)
  self.items = {}
  for i, v in ipairs(self.param.listData) do
    local item = ed.achListItemLayModule.new(self.sceneSelf, v, self.sceneSelf.dailyItemSize)
    self.draglist:addItem(item.layer, ccp(self.sceneSelf.dailyItemSize.width / 2, thisCon.height - i * self.sceneSelf.dailyItemSize.height + self.sceneSelf.dailyItemSize.height / 2 - 10))
    self.items[v.line_id] = self.items[v.line_id] or {}
    self.items[v.line_id][v.id] = item
  end
  self.draglist:initListHeight(#self.draglist.listItems * self.sceneSelf.dailyItemSize.height + 20)
  return self
end

function dragLists:setVisible(vis)
  self.draglist:setVisible(vis)
end

function dragLists:refresh(param)
  local posx, posy = self.draglist:getList():getPosition()
  local thisCon = self.container:getContentSize()
  self.param.listData = param.listData or self.param.listData
  for i, v in ipairs(self.param.listData) do
    if self.items[v.line_id][v.id] then
      self.items[v.line_id][v.id]:refresh(v)
      self.items[v.line_id][v.id].layer:runAction(CCEaseExponentialOut:create(CCMoveTo:create(0.5, ccp(self.sceneSelf.dailyItemSize.width / 2, thisCon.height - i * self.sceneSelf.dailyItemSize.height + self.sceneSelf.dailyItemSize.height / 2 - 10))))
    else
      local item = ed.achListItemLayModule.new(self.sceneSelf, v, self.sceneSelf.dailyItemSize)
      self.draglist:addItem(item.layer, ccp(self.sceneSelf.dailyItemSize.width / 2, thisCon.height - i * self.sceneSelf.dailyItemSize.height + self.sceneSelf.dailyItemSize.height / 2 - 10))
      self.items[v.line_id] = self.items[v.line_id] or {}
      self.items[v.line_id][v.id] = item
    end
  end
  self.draglist:initListHeight(#self.draglist.listItems * self.sceneSelf.dailyItemSize.height + 20)
  if posx and posy then
    self.draglist:setListPos(ccp(posx, posy))
  end
  self.draglist.listLayer:runAction(CCEaseExponentialOut:create(CCMoveTo:create(0.5, ccp(0, 0))))
end

function page:pusAchReward(task)
  local function func(task)
    return function()
      ed.taskNetwork:achRequireRewards({
        type = task.type,
        
        line_id = task.line_id,
        id = task.id
      })
    end
  end
  
  local push = func(task)
  local geftItem, exceedItem, giveItemAll = ed.itemExceeds(task.reward or {})
  self.dataObj.giveItemAll = ed.copyProto(giveItemAll)
  if 0 < #exceedItem then
    ed.ui.maillocalbox.create({
      type = "deleItem",
      tag = 2,
      item = exceedItem,
      clickGeft = function()
        push()
      end,
      clickBack = function()
      end,
      str = T("\233\131\168\229\136\134\229\165\150\229\138\177\231\137\169\229\147\129\233\162\134\229\143\150\229\144\142\229\176\134\232\182\133\229\135\186\228\184\138\233\153\144\239\188\140\229\187\186\232\174\174\230\184\133\231\144\134\232\131\140\229\140\133\229\144\142\229\134\141\230\157\165\233\162\134\229\143\150\227\128\130(\229\188\186\232\161\140\233\162\134\229\143\150\229\176\134<lable color=mailRed>\230\184\133\233\153\164</lable>\232\182\133\228\184\138\233\153\144\233\131\168\229\136\134)<br/>\232\182\133\232\191\135\228\184\138\233\153\144\231\137\169\229\147\129:"),
      btnStr = T("\229\143\150\230\182\136")
    }):popWindow()
  else
    push()
  end
end

local function btRegisterButtonClickToListItems()
  return function(self, param)
    self.sceneSelf:btRegisterButtonClick({
      button = param.button,
      key = "ach_page_items" .. self.index,
      radioGroupName = "items",
      param = param,
      clickInterval = 1,
      clickHandler = function(param, x, y)
        if not ed.containsPoint(self.ui.ach_list_pos, x, y) then
          print("not list pos")
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
    self.index = self.index + 1
  end
end

page.btRegisterButtonClickToListItems = btRegisterButtonClickToListItems()

function page:uiCreate()
  self.ui.label_ach_num:setStroke(ccc3(ed.colorToStr("#272524")), 1)
  self.ui.label_ach_count:setStroke(ccc3(ed.colorToStr("#272524")), 1)
  ed.setLabelStroke(self.ui.cup_diamond_amount, ed.toccc3(2565412), 1)
  ed.setLabelStroke(self.ui.cup_gold_amount, ed.toccc3(2565412), 1)
  ed.setLabelStroke(self.ui.cup_silver_amount, ed.toccc3(2565412), 1)
  ed.setLabelStroke(self.ui.cup_copper_amount, ed.toccc3(2565412), 1)
  local newWid = ed.display.halfFixedWidth * 2
  local newHei = ed.display.halfFixedHeight * 2
  local ui = self.ui
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
  posfunc(ui.Label_354, true)
  posfunc(ui.label_ach_num, true)
  posfunc(ui.Label_3512)
  posfunc(ui.ImageView_357)
  posfunc(ui.label_ach_count)
  posfunc(ui.btn_ach_pop)
  posfunc(ui.ach_list_pos, true)
  sizefunc(ui.ach_list_pos)
  posfunc(ui.cup_diamond_bg, true)
  posfunc(ui.cup_gold_bg, true)
  posfunc(ui.cup_silver_bg, true)
  posfunc(ui.cup_copper_bg, true)
  self.dailyItemSize.halfFixedWidth = newWid
  self.dailyItemSize.width = self.dailyItemSize.width + newWid
end

function page:titleRefresh()
  local titData = self.dataObj.achTitle or {}
  self.ui.label_ach_num:setString((titData.progress or 0) .. "/" .. (titData.total or 0))
  self.ui.label_ach_count:setString(titData.point or 0)
  self.ui.ach_pop_red:setVisible(self.dataObj:getPointRedVis())
  local labelNameList = {
    "cup_diamond_amount",
    "cup_gold_amount",
    "cup_silver_amount",
    "cup_copper_amount"
  }
  local cupAmountList = titData.cups or {}
  for index = 1, #labelNameList do
    local labelName = labelNameList[index]
    ed.setLabelString(self.ui[labelName], cupAmountList[index] or 0)
  end
end

function page:registerBtnEvents()
  local index = 1
  
  local function func(node, click, press, normal)
    self.sceneSelf:btRegisterButtonClick({
      button = node,
      key = "ach_page_" .. index,
      clickHandler = click,
      force = true,
      clickInterval = 1,
      pressScale = press or 0.9,
      normalScale = normal or 1
    })
    index = index + 1
  end
  
  func(self.ui.btn_ach_pop, function()
    ed.UITool.openView("achPagePointPop", {})
  end)
end

function page:delete()
  CloseEvent("achTaskReply")
end

return page
