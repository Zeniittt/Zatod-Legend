local activityBbgsPage = newclass("g")
ed.ui.activityBbgsPage = activityBbgsPage

function activityBbgsPage.create(base, param, pageKey)
  local this = {param = param, pageKey = pageKey}
  setmetatable(activityBbgsPage, {__index = base})
  setmetatable(this, {__index = activityBbgsPage})
  this:initView(param)
  return this
end

function activityBbgsPage:initView(param)
  local container, ui = ed.editorui(ed.uieditor.activity_bbgs_page)
  self.ui = ui
  self.container = container
  self.pageIndex = 1
  self.items = {}
  self.pageData = {}
  if ed.display.winSize.width < 2160 then
    self.ui.Panel_3618:setPositionX(self.ui.Panel_3618:getPositionX() - 50)
  end
  local txt = ed.ui.gradientLabel.create({
    text = "\230\176\184\231\148\159\230\162\166\229\162\131\230\156\128\233\171\152\228\188\164\229\174\179\231\180\175\232\174\161\229\133\168\230\156\141\229\137\1411000/\230\156\172\230\156\141\229\137\1413\231\142\169\229\174\182\229\143\175\232\142\183\229\190\151",
    fontSize = 17,
    startColor = ed.toccc3(9582089),
    endColor = ed.toccc3(12800786)
  })
  txt.node:setPosition(ccp(233, 13))
  ui.ImageView_3562:addChild(txt.node)
  local showId = ed.getDataTable("DreamlandNewYearRankLocal")[1][1]["Reward ID 1"]
  local icon = ed.createItemIcon({id = showId, amount = 1})
  icon:setPosition(ccp(463, 13))
  ui.ImageView_3562:addChild(icon)
  icon:setScale(0.45)
  self:btRegisterButtonClick({
    button = icon,
    key = "bbgsPageDailyShowIcon",
    force = true,
    mcpMode = true,
    pressScale = 0.4,
    normalScale = 0.45,
    clickHandler = function()
      ed.ui.packageDetailWin.create({id = showId, amount = 1}):popWindow()
    end
  })
  ui.Label_time:setString(param.endTimeStr or "")
  ui.Label_time:setStroke(ed.toccc3(9263891), 1.2)
  ui.Label_3652:setStroke(ed.toccc3(8472064), 1.2)
  ui.Label_page1s:setStroke(ed.toccc3(11625472), 1.5)
  ui.Label_page2s:setStroke(ed.toccc3(11625472), 1.5)
  ui.Label_3668:setStroke(ed.toccc3(4728126), 1.5)
  ed.setLabelFontName(ui.Label_3668, ed.fontBold)
  self:createList()
  self:createTitle()
  self:createGroupBtns()
  self:createDailyTask()
  self:sendReq(1)
  self:listenEvent("activity_dreamland_new_year_reply", function(info)
    info = ed.copyProto(info)
    if info._query_rankboard then
      if info._query_rankboard._self_rank and info._query_rankboard._self_rank._param2 then
        self.selfRankData = info._query_rankboard._self_rank
        self.selfRankData._self_pos = info._query_rankboard._self_pos
      end
      if self.addListIng then
        if #self.pageData[self.pageIndex] >= 100 then
          return
        end
        self:addListItem(info._query_rankboard._rank_list or {})
      else
        self.pageData[self.pageIndex] = info._query_rankboard._rank_list or {}
        if #self.pageData[self.pageIndex] >= 100 then
          local items = {}
          for i = 1, 100 do
            table.insert(items, self.pageData[self.pageIndex][i])
          end
          self.pageData[self.pageIndex] = items
        end
        self:refreshList()
      end
    elseif info._daily_record then
      ed.UITool.openView("activityBbgsPop", info._daily_record)
    end
  end)
  self:listenEvent("req_home_page", function(data)
    ed.ui.PlayerInfoPanel.create(data, false):popWindow()
  end)
  self.objWork:activityPull(param._id)
end

function activityBbgsPage:onSceneEnter()
  self.objWork:activityPull(self.param._id)
  self.items = {}
  self.addListIng = false
  self:sendReq(self.pageIndex)
end

function activityBbgsPage:sendReq(type)
  type = type == 1 and 2 or 1
  self.objWork:sendDreamlandNewYearReq("_query_rankboard", {
    type = type,
    rank_left = #self.items + 1,
    rank_right = #self.items + 25
  })
end

function activityBbgsPage:setVisibleCallBack(isVisible)
  self.dragList:setVisible(isVisible)
end

function activityBbgsPage:createTitle()
  ed.createLabelTools({
    txt = T(""),
    size = 30,
    pos = ccp(60, 40),
    color = ed.toccc3(16776423),
    parent = self.ui.bg,
    stroke = {
      ccc3(ed.colorToStr("#3d2824")),
      1.3
    },
    font = ed.fontBold
  })
  self.ui.ImageView_3571:setVisible(self.param._end_time >= ed.getServerTime())
end

function activityBbgsPage:createDailyTask()
  local task = self.param._tasks[1]
  local reward = task._rewards[1]
  if not self.dailyItem then
    local item = ed.taskItemModule.new(self, {
      id = reward._id,
      type = reward._type,
      amount = reward._amount
    }, nil, 1, false, false, true)
    item.icon:setPosition(49, 53)
    self.ui.ImageView_3571:addChild(item.icon)
    item.icon:setScale(0.7)
    self.dailyItem = item
    self:btRegisterButtonClick({
      button = item.icon,
      key = "bbgsPageDailyTaskIcon",
      force = true,
      mcpMode = true,
      pressScale = 0.65,
      normalScale = 0.7,
      clickHandler = function()
        local localtask = self.param._tasks[1]
        local isCompleted = localtask._progress >= localtask._cond_target
        local isFinished = localtask._cur_reward_times and localtask._cur_reward_times >= localtask._max_reward_times
        if not isFinished and isCompleted then
          self.objWork:activitySubmit(self.param._id, localtask._id)
        else
          ed.ui.packageDetailWin.create({
            id = reward._id,
            type = reward._type,
            amount = reward._amount
          }):popWindow()
        end
      end
    })
  end
  if self.dailyText then
    self.dailyText:removeFromParentAndCleanup(true)
  end
  local isCompleted = task._progress >= task._cond_target
  local isFinished = task._cur_reward_times and task._cur_reward_times >= task._max_reward_times
  local update = isFinished and 2 or isCompleted and 1 or 0
  local color = isCompleted and "ccc3(132,255,70)" or "ccc3(255,129,129)"
  self.dailyItem:refresh(update)
  local tip2 = T("\230\140\145\230\136\152\230\176\184\231\148\159\230\162\166\229\162\131(<lable color=%s>%d/%d</lable>)", color, task._progress, task._cond_target)
  local autoText = ed.ui.autoText.new()
  autoText:initParam({
    context = tip2,
    fontSize = 15,
    maxWidth = 999,
    strokeColor = ed.toccc3(1443591),
    strokeSize = 1.2
  })
  self.ui.ImageView_3572:addChild(autoText.node)
  autoText.node:setPosition(42, 10)
  self.dailyText = autoText.node
end

function activityBbgsPage:pageUpDate(param)
  self.param = param
  self:createDailyTask()
end

function activityBbgsPage:createGroupBtns()
  for index = 1, 2 do
    self:btRegisterButtonClick({
      button = self.ui["button" .. index],
      selected = self.ui["Label_page" .. index .. "s"],
      key = "activityBbgsPage_number" .. index,
      radioGroupName = "activityBbgsPage_number",
      clickHandler = function(param, x, y)
        if self.pageIndex ~= index then
          self.pageIndex = index
          self.ui.ImageView_3565:stopAllActions()
          self.ui.ImageView_3565:runAction(CCEaseExponentialInOut:create(CCMoveTo:create(0.1, ccp(self.ui["Label_page" .. index .. "s"]:getPositionX(), self.ui.ImageView_3565:getPositionY()))))
          self.items = {}
          self:sendReq(index)
          self.addListIng = false
        end
      end
    })
  end
  self:btRegisterButtonClick({
    button = self.ui.ImageView_3651,
    key = "bbgsPageDailyGoto",
    force = true,
    mcpMode = true,
    pressScale = 0.8,
    normalScale = 0.85,
    clickHandler = function()
      local task = self.param._tasks[1]
      ed.pt(task)
      ed.activityTaskTool.taskSkip(task._cond_type, task._cond_id)
    end
  })
end

function activityBbgsPage:createList()
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
    cancelPressIn = self:cancelPressInList(),
    stopMoveFun = function()
      if #self.items < 10 or #self.items >= 100 or self.addOver then
        return
      end
      if self.dragList.listHeight > self.dragList.height and self.dragList.listHeight - self.dragList.height == self.dragList.listLayer:getPositionY() then
        self:sendReq(self.pageIndex)
        self.addListIng = true
      end
    end
  }
  self.dragList = ed.draglist.create(info)
end

function activityBbgsPage:addListItem(addData)
  if #addData == 0 then
    self.addOver = true
    self.dragList:initListHeight(self.dragList:getListHeight() + #addData * 64 - 30, false)
    self.dragList.listLayer:runAction(CCEaseExponentialOut:create(CCMoveBy:create(0.5, ccp(0, -30))))
    self.listTxt:setVisible(false)
    return
  end
  local thisCon = self.ui.Panel_item:getContentSize()
  local index = #self.items + 1
  local i = 1
  ed.timeSchedule(self.ui.Panel_item, function()
    if not addData[i] then
      self.ui.Panel_item:stopAllActions()
      self.listOver = true
    end
    local item = self.itemBox.create(self, addData[i], index)
    self.dragList:addItem(item.ui.bg, ccp(thisCon.width / 2, thisCon.height - index * 64 + 32 - 8))
    table.insert(self.items, item)
    table.insert(self.pageData[self.pageIndex], addData[i])
    i = i + 1
    index = index + 1
  end, 0.02)
  if 100 <= #addData + index then
    self.dragList:initListHeight(self.dragList:getListHeight() + #addData * 64 - 30, false)
  else
    self.dragList:initListHeight(self.dragList:getListHeight() + #addData * 64, false)
    if self.listTxt then
      self.listTxt:setPositionY((self.dragList.listHeight - self.dragList.height) * -1 + (self.selfRankData and 60 or 12))
    end
    if 2 < #addData then
      self.dragList.listLayer:runAction(CCEaseExponentialOut:create(CCMoveBy:create(1.5, ccp(0, 70))))
    end
  end
  self.listTxt:setVisible(#addData + index < 100)
end

function activityBbgsPage:refreshList()
  self.items = {}
  self.dragList:clearList()
  self.addOver = false
  local thisCon = self.ui.Panel_item:getContentSize()
  self.ui.Panel_item:stopAllActions()
  local data = self.pageData[self.pageIndex]
  local index = 1
  ed.timeSchedule(self.ui.Panel_item, function()
    if not data[index] or 100 < index then
      self.ui.Panel_item:stopAllActions()
      self.listOver = true
      return
    end
    local item = self.itemBox.create(self, data[index], index)
    local move = index < 7 and 200 or 0
    self.dragList:addItem(item.ui.bg, ccp(thisCon.width / 2, thisCon.height - index * 64 + 32 - 8 - move))
    if move ~= 0 then
      item.ui.bg:runAction(CCEaseExponentialOut:create(CCMoveBy:create(index * 0.05 + 0.1, ccp(0, move))))
    end
    table.insert(self.items, item)
    index = index + 1
  end, 0.02)
  local addHeight = 12
  if self.selfRankData then
    addHeight = 60
    self.ui.ImageView_3570:setVisible(true)
    self.ui.ImageView_3570:removeAllChildrenWithCleanup(true)
    self.selfItem = self.itemBox.create(self, setmetatable({
      bg = ed.createSpriteTools({
        res = "",
        pos = ccp(17, 0),
        parent = self.ui.ImageView_3570
      })
    }, {
      __index = self.selfRankData
    }), self.selfRankData._param2 or self.selfRankData._self_pos or 999)
  end
  self.dragList:initListHeight(#data * 64 + 10 + 15 + addHeight)
  if 10 <= #data and self.dragList.listHeight > self.dragList.height and #data < 100 then
    self.listTxt = ed.createLabelTools({
      txt = T("\230\159\165\231\156\139\230\155\180\229\164\154"),
      size = 16,
      pos = ccp(thisCon.width / 2, (self.dragList.listHeight - self.dragList.height) * -1 + addHeight),
      color = ed.toccc3(16776423),
      parent = self.dragList.listLayer
    })
    self.listTxt:setOpacity(70)
  else
    self.dragList:initListHeight(#data * 64 + addHeight)
  end
  self.ui.empty:setVisible(#data == 0)
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
  local bg = param.bg
  local posx = 0
  if not bg then
    posx = 22
    local bgRes = {
      6,
      7,
      8
    }
    bg = ed.createSpriteTools({
      res = string.format("UI/alpha/1080P/activity/bubugaosheng/bg_%d.png", bgRes[self.index] or 9),
      pos = ccp(0, 0)
    })
  end
  local rank = self.mainSelf.pageIndex == 1 and 1000 or 3
  local height = 61
  if self.index < 4 then
    local rankRes = {
      "rank_1st",
      "rank_2nd",
      "rank_3rd"
    }
    ed.createSpriteTools({
      res = "UI/alpha/1080P/toparena/rank/" .. rankRes[self.index] .. ".png",
      pos = ccp(53, height / 2),
      parent = bg,
      scale = 0.75
    })
  elseif rank < self.index and param.bg then
    ed.createLabelTools({
      txt = T("\230\156\170\228\184\138\230\166\156"),
      size = 18,
      pos = ccp(53, height / 2),
      color = ed.toccc3(16776423),
      stroke = {
        ccc3(ed.colorToStr("#221505")),
        1.3
      },
      parent = bg
    })
  else
    local text = ed.getNumberNode({
      text = self.index,
      folder = "peakarena_rank"
    }).node
    text:setPosition(53, height / 2)
    bg:addChild(text)
  end
  local summary = param._user_summary
  local hand = ed.getTeamHead({
    id = summary._avatar
  })
  bg:addChild(hand)
  hand:setPosition(132, height / 2)
  hand:setScale(0.65)
  local name = ed.getPlayerName(summary._name, summary._medal, {
    anchorPoint = ccp(0, 0.5)
  })
  name:setPosition(166, height / 2 + 12)
  bg:addChild(name)
  ed.createLabelTools({
    txt = param._param4 or tostring(game_server_name),
    size = 14,
    pos = ccp(166, height / 2 - 12),
    color = ed.toccc3(16773256),
    stroke = {
      ccc3(ed.colorToStr("#221505")),
      1.3
    },
    parent = bg,
    anchor = ccp(0, 0.5)
  })
  ed.createLabelTools({
    txt = T("\231\180\175\232\174\161\230\156\128\233\171\152\228\188\164\229\174\179:"),
    size = 16,
    pos = ccp(380 + posx, height / 2 + 15),
    color = ed.toccc3(16776423),
    stroke = {
      ccc3(ed.colorToStr("#221505")),
      1.3
    },
    parent = bg
  })
  local text = ed.getNumberNode({
    text = param._param1 or 0,
    folder = "peak_score"
  }).node
  text:setPosition(377 + posx, height / 2 - 11)
  bg:addChild(text)
  text:setScale(0.6)
  local btn = false
  if param.bg then
    btn = ed.createSpriteTools({
      res = "UI/alpha/1080P/battle/preset/preset_round_button.png",
      pos = ccp(496, height / 2),
      parent = bg
    })
    ed.createSpriteTools({
      res = "UI/alpha/1080P/crusade/btn_statics.png",
      pos = ccp(21.25, 21.75),
      parent = btn
    })
  end
  self.ui = {
    bg = bg,
    hand = hand,
    btn = btn
  }
end

activityBbgsPage.itemBox = itemBox

function activityBbgsPage:doPressInList()
  local function handler(x, y)
    if self.selfItem and ed.containsPoint(self.ui.ImageView_3570, x, y) then
      if ed.containsPoint(self.selfItem.ui.hand, x, y) then
        self.selfItem.ui.hand:setScale(0.6)
        
        return {
          icon = self.selfItem.ui.hand,
          fun = function()
            local summary = self.selfItem.param._user_summary
            ed.PlayerInfoNetwork:requestHomePage(summary._role_id)
          end,
          normalScale = 0.65
        }
      elseif self.selfItem.ui.btn and ed.containsPoint(self.selfItem.ui.btn, x, y) then
        self.selfItem.ui.btn:setScale(0.95)
        return {
          icon = self.selfItem.ui.btn,
          fun = function()
            self.objWork:sendDreamlandNewYearReq("_daily_record")
          end
        }
      end
      return
    end
    for _, v in ipairs(self.items) do
      if ed.containsPoint(v.ui.hand, x, y) then
        v.ui.hand:setScale(0.6)
        return {
          icon = v.ui.hand,
          fun = function()
            local summary = v.param._user_summary
            ed.PlayerInfoNetwork:requestHomePage(summary._role_id)
          end,
          normalScale = 0.65
        }
      end
    end
  end
  
  return handler
end

function activityBbgsPage:cancelPressInList()
  local function handler(x, y, info)
    info.icon:setScale(info.normalScale or 1)
  end
  
  return handler
end

function activityBbgsPage:cancelClickInList()
  local function handler(x, y, info)
    info.icon:setScale(info.normalScale or 1)
  end
  
  return handler
end

function activityBbgsPage:doClickInList()
  local function handler(x, y, info)
    if info.fun then
      info.fun()
    end
  end
  
  return handler
end
