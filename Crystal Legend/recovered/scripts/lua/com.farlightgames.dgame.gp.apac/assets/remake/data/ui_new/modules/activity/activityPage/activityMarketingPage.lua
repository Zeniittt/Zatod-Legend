local activityMarketingPage = newclass("g")
ed.ui.activityMarketingPage = activityMarketingPage

function activityMarketingPage.create(base, param, pageKey)
  local this = {param = param, pageKey = pageKey}
  setmetatable(activityMarketingPage, {__index = base})
  setmetatable(this, {__index = activityMarketingPage})
  this:initView(param)
  return this
end

function activityMarketingPage:initView(param)
  local uiConfig = ed.uieditor.activity_marketing_page
  if param._extend and param._extend._tag == "xinfu" then
    uiConfig = ed.copyProto(uiConfig)
    for _, v in ipairs(uiConfig) do
      if v.t == "Sprite" or v.t == "Scale9Sprite" then
        v.base.res = string.gsub(v.base.res, "/snakehappynewyear/old_", "/snakehappynewyear/new_")
      end
    end
    self.xinfu = true
  end
  local container, ui = ed.editorui(uiConfig)
  self.ui = ui
  self.container = container
  self.pageIndex = 1
  local task = param._tasks
  self.param = param
  self:initDragList(task)
  if self.xinfu then
    ui.Label_3614:setString(T("\233\128\154\229\133\179\230\136\152\229\189\185\230\140\135\229\174\154\231\171\160\232\138\130\229\143\175\228\187\165\233\162\134\229\143\150\228\187\187\229\138\161\229\165\150\229\138\177"))
    ui.Label_3614:setStroke(ed.toccc3(14964296), 1.2)
    ui.ImageView_3612:setVisible(false)
  else
    ui.Label_3614:setStroke(ed.toccc3(14839600), 1.2)
    ed.layout.layoutWithMagin(ui.ImageView_3612, {
      right = 200 + ed.display.halfFixedWidth,
      top = 20 + ed.display.halfFixedHeight
    })
    ui.Label_3613:setStroke(ed.toccc3(10702351), 1.2)
    ui.Label_3613:setString(T("\231\155\174\229\137\141\230\180\187\232\183\131\229\186\166\239\188\154%s", task[#task]._progress))
  end
  ui.Label_time:setString(T("\229\137\169\228\189\153:%s", param.endTimeStr or ""))
  ui.Label_time:setStroke(ed.toccc3(14443074), 1.2)
  ed.setLabelFontName(ui.Label_3614, ed.fontBold)
  self:btRegisterButtonClick({
    button = ui.btn,
    key = "marketingbtn",
    force = true,
    mcpMode = true,
    pressScale = 0.96,
    clickHandler = function()
      ed.activityTaskTool.taskSkip(task[1]._cond_type, task[1]._cond_id)
    end
  })
  if self.xinfu then
    ui.btntxt = ed.ui.gradientLabel.create({
      text = "\229\137\141\229\190\128",
      fontSize = 36,
      fontName = ed.fontBold,
      startColor = ed.toccc3(16768621),
      endColor = ed.toccc3(16776123),
      strokeSize = 3,
      strokeStartColor = ed.toccc3(14443074),
      strokeEndColor = ed.toccc3(16422443)
    })
  else
    ui.btntxt = ed.ui.gradientLabel.create({
      text = "\229\137\141\229\190\128",
      fontSize = 36,
      fontName = ed.fontBold,
      startColor = ed.toccc3(12667689),
      endColor = ed.toccc3(16738131),
      strokeSize = 3,
      strokeColor = ed.toccc3(16773793)
    })
  end
  ui.btntxt.node:setPosition(ccp(145.25, 53))
  ui.btn:addChild(ui.btntxt.node)
  self.objWork:activityPull(self.param._id)
end

function activityMarketingPage:initDragList(task)
  if ed.display.winSize.width < 1200 then
    self.ui.Panel_item:setPositionX(self.ui.Panel_item:getPositionX() + 85)
  end
  local thisCon = self.ui.Panel_item:getContentSize()
  self.items = {}
  local info = {
    cliprect = CCRectMake(0, 0, thisCon.width, thisCon.height),
    container = self.ui.Panel_item,
    priority = -300,
    noshade = true,
    zorder = 10,
    doClickIn = self:doClickInList(),
    cancelClickIn = self:cancelPressInList(),
    doPressIn = self:doPressInList(),
    cancelPressIn = self:cancelPressInList()
  }
  self.dragList = ed.draglist.create(info)
  for i, v in ipairs(task) do
    local item = self.itemBox.create(self, v)
    self.dragList:addItem(item.ui.bg, ccp(i * 210 - 105, thisCon.height / 2 + 6))
    self.items[v._id] = item
  end
  self.dragList:initListWidth(#task * 210)
end

function activityMarketingPage:setVisibleCallBack(isVisible)
  self.dragList:setVisible(isVisible)
end

function activityMarketingPage:onSceneEnter()
  self.objWork:activityPull(self.param._id)
end

function activityMarketingPage:pageUpDate(param)
  self.param = param
  local task = param._tasks
  for _, v in ipairs(task) do
    self.items[v._id]:update(v)
  end
  if self.ui.ImageView_3612:isVisible() then
    self.ui.Label_3613:setString(T("\231\155\174\229\137\141\230\180\187\232\183\131\229\186\166\239\188\154%s", task[#task]._progress))
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
    res = "UI/alpha/1080P/activity/snakehappynewyear/" .. (self.mainSelf.xinfu and "new" or "old") .. "_1.png",
    pos = ccp(0, 0)
  })
  ed.createLabelTools({
    txt = ed.activityTaskTool.getTaskDesc(param),
    size = 18,
    pos = ccp(116.5, 225),
    color = ed.toccc3(7878699),
    parent = bg
  })
  local reward = param._rewards[1]
  local item = ed.taskItemModule.new(self, {
    id = reward._id,
    type = reward._type,
    amount = reward._amount,
    passRes = "UI/alpha/1080P/rogue/collect/collect_event_done.png"
  }, nil, param._id, false, false, true)
  item.icon:setPosition(116.5, 162.5)
  bg:addChild(item.icon)
  item.icon:setScale(1)
  local state = ed.createLabelTools({
    txt = "",
    size = 18,
    pos = ccp(116.5, 100),
    color = ed.toccc3(13326883),
    parent = bg,
    stroke = {
      ccc3(ed.colorToStr("#FFF297")),
      1.3
    }
  })
  self.ui = {
    bg = bg,
    item = item,
    state = state
  }
  self:update(param)
end

function itemBox:update(param)
  self.param = param
  local isCompleted = param._progress >= param._cond_target
  local isFinished = param._cur_reward_times and param._cur_reward_times >= param._max_reward_times
  if isFinished then
    self.ui.state:setString(T("\229\183\178\229\174\140\230\136\144"))
    self.ui.item:refresh(2)
  elseif isCompleted then
    self.ui.state:setString("\229\143\175\233\162\134\229\143\150")
    self.ui.item:refresh(1)
  else
    self.ui.state:setString("")
    self.ui.item:refresh(0)
  end
end

activityMarketingPage.itemBox = itemBox

function activityMarketingPage:doPressInList()
  local function handler(x, y)
    if ed.containsPoint(self.ui.btn, x, y) then
      return
    end
    for _, v in pairs(self.items) do
      if ed.containsPoint(v.ui.bg, x, y) then
        v.ui.bg:setScale(0.95)
        return {
          icon = v.ui.bg,
          fun = function(param)
            local isCompleted = param._progress >= param._cond_target
            local isFinished = param._cur_reward_times and param._cur_reward_times >= param._max_reward_times
            if isFinished then
              ed.showToast(T("\229\183\178\233\162\134\229\143\150"))
            elseif isCompleted then
              self.objWork:activitySubmit(self.param._id, param._id)
            else
              local reward = param._rewards[1]
              ed.UITool.openView("packageDetail", {
                id = reward._id,
                type = reward._type,
                amount = reward._amount
              })
            end
          end,
          param = v.param
        }
      end
    end
  end
  
  return handler
end

function activityMarketingPage:cancelPressInList()
  local function handler(x, y, info)
    info.icon:setScale(info.normalScale or 1)
  end
  
  return handler
end

function activityMarketingPage:doClickInList()
  local function handler(x, y, info)
    if info.fun then
      info.fun(info.param or {})
    end
  end
  
  return handler
end
