local base = ed.ui.popwindow
local AutoChessRankGradeListWindow = newclass(base.mt)
ed.AutoChessRankGradeListWindow = AutoChessRankGradeListWindow
local AutoChessRankGradeListWindowScope = {}

function AutoChessRankGradeListWindow:initData(param)
  self.myGradeInfo = ed.AutoChessRankManager:getMyRankGradeInfo()
  self.myGradeId = self.myGradeInfo.id
  self.myScore = ed.AutoChessRankManager:getMyRankScore()
  self.info = ed.AutoChessRankManager:getCurrentSeasonInfo()
  self.infoList = ed.AutoChessRankManager:getRankGradeInfoList()
end

function AutoChessRankGradeListWindow:createItem(info)
  local container, ui = ed.editorui(ed.uieditor.AutoChessRankGradeItem)
  ed.setLabelShadow(ui.labelGradeName, ccc3(0, 0, 0), ccp(0, 2))
  local higherGrade = info.minScore > self.myScore
  local isMyGrade = self.myGradeId == info.id
  if isMyGrade then
    ed.setTexture(ui.bg, "UI/alpha/1080P/chess/season/orange.png")
  elseif higherGrade then
    ed.setTexture(ui.bg, "UI/alpha/1080P/chess/season/purple.png")
  else
    ed.setTexture(ui.bg, "UI/alpha/1080P/chess/season/blue.png")
  end
  ed.setTexture(ui.iconGrade, info.gradeIcon)
  local seasonInfo = ed.AutoChessRankManager:getCurrentSeasonInfo()
  local data = ed.getDataTable("ChessGradeReward")[seasonInfo.id][info.id]
  local rewardData = {
    id = data["Reward ID1"],
    type = data["Reward Type1"],
    amount = data["Reward Amount1"]
  }
  local rewardIcon = ed.createItemIcon(rewardData, nil, 1)
  rewardIcon:setPosition(ccp(45, 46))
  ui.iconReward:addChild(rewardIcon)
  ed.setString(ui.labelGradeName, info.name)
  local isOpened = ed.AutoChessRankManager:isGradeRewardOpened(info.id)
  if isOpened then
    ui.icon_mask:setVisible(true)
  elseif info.id <= self.myGradeId then
    ui.icon_light:setVisible(true)
    ui.icon_light:runAction(CCRepeatForever:create(CCRotateBy:create(0.2, 60)))
  end
  local centerx, centery = ui.iconGrade:getPosition()
  centery = centery + 22
  local r = 54
  local allStars = info.stars
  
  local function isActive(i)
    if info.maxScore <= self.myScore then
      return true
    end
    if higherGrade then
      return false
    end
    return i <= self.myScore - info.minScore + 1
  end
  
  for i = 1, allStars do
    local star = ui["star" .. i]
    local rotation = ed.AutoChessRankManager:getRotation(allStars, i)
    local pos = ed.AutoChessRankManager:getPosAtCircle(centerx, centery, r, rotation)
    star:setRotation(rotation)
    star:setPosition(pos)
    star:setVisible(true)
    if not isActive(i) then
      ed.setSpriteStone(star)
    end
  end
  return container, ui
end

function AutoChessRankGradeListWindow:doPressInList()
  local function handler(x, y)
    for k, v in ipairs(self.uiList or {}) do
      if ed.containsPoint(v.ui.iconReward, x, y) then
        return v
      end
    end
    return nil
  end
  
  return handler
end

function AutoChessRankGradeListWindow:cancelPressInList()
  local function handler(x, y, v)
    if not v then
      return
    end
  end
  
  return handler
end

function AutoChessRankGradeListWindow:openGradeRewardAsync(gradeId)
  if ed.AutoChessRankManager:isDebug() then
    FireEvent("AutoChessTookGradeRewards", gradeId, {
      {
        _id = 0,
        _type = "diamond",
        _amount = 50
      }
    })
  else
    ed.AutoChessNetwork:sendChessGradeReward(gradeId)
  end
end

function AutoChessRankGradeListWindow:doClickInList()
  local function handler(x, y, v)
    if not v then
      return
    end
    local info = v.data
    local isOpened = ed.AutoChessRankManager:isGradeRewardOpened(info.id)
    if isOpened then
      return
    elseif info.id <= self.myGradeId then
      self:openGradeRewardAsync(info.id)
    end
  end
  
  return handler
end

function AutoChessRankGradeListWindow:refreshDraglist(flag)
  self.draglist:clearList()
  local uiList = {}
  
  local function getPos(i)
    return ccp(i * 180 - 90, 160)
  end
  
  local oldX, oldY = 0, 0
  if flag then
    oldX, oldY = self.draglist:getListPos()
  end
  for k, info in ipairs(self.infoList) do
    local container, ui = self:createItem(info)
    self.draglist:addItem(container)
    container:setPosition(getPos(k))
    table.insert(uiList, {
      container = container,
      ui = ui,
      data = info
    })
  end
  self.draglist:initListWidth(180 * #self.infoList)
  if flag then
    self.draglist:setListPos(ccp(oldX, oldY))
  end
  self.uiList = uiList
end

function AutoChessRankGradeListWindow:makeItemCenter()
  local posX = 0
  for k, v in ipairs(self.uiList) do
    if v.data.id == self.myGradeId then
      posX = v.container:getPositionX() - 435
    end
  end
  posX = math.min(-posX, 0)
  posX = math.max(posX, -180 * #self.infoList + 870)
  self.draglist:setListPos(ccp(posX, 0))
end

function AutoChessRankGradeListWindow:initUI()
  ed.editorui(ed.uieditor.AutoChessRankGradeListWindow, {
    container = self.container,
    ui = self.ui
  })
  ed.setString(self.ui.title, self.info.name)
  ed.setLabelStroke(self.ui.title, ed.toccc3(6373674), 1.5)
  self.ui.title:setFontName(ed.fontBold)
  self.draglist = ed.UITool.createDraglist(self.ui.layer_item, {
    doPressIn = self:doPressInList(),
    cancelPressIn = self:cancelPressInList(),
    doClickIn = self:doClickInList()
  })
  self:refreshDraglist()
  self:makeItemCenter()
end

function AutoChessRankGradeListWindow:registerTouchHandlers()
  ed.UITool.registerBtn(self, "btn_back", function()
    self:destroy()
  end, {normalScale = 0.8, pressScale = 0.75})
  ed.UITool.registerBtn(self, "btn_rule", function()
    ed.ui.AutoChessArenaRule.create():popWindow()
  end, {pressScale = 0.95})
end

function AutoChessRankGradeListWindow:registerEvents()
  self:listenEvent("AutoChessRankGradeListRefresh", function(gradeId, rewards)
    ed.UITool.showRewardsFromServer(rewards)
    self:refreshDraglist(true)
  end)
end

function AutoChessRankGradeListWindow.create(param)
  local self = base.create("AutoChessRankGradeListWindow")
  setmetatable(self, AutoChessRankGradeListWindow.mt)
  self:initData(param)
  self:initUI()
  self:registerTouchHandlers()
  self:registerEvents()
  self.refreshCliprectConfig = {
    draglist = self.draglist
  }
  self:popWindow()
  return self
end
