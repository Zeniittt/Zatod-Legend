local base = ed.ui.popwindow
local AutoChessRankIconPanel = newclass(base.mt)
ed.ui.AutoChessRankIconPanel = AutoChessRankIconPanel

function AutoChessRankIconPanel:initData(param)
  self.oldScore = ed.AutoChessRankManager:getMyRankScore()
  local scoreDiff = ed.AutoChessRankManager:getScoreDiff()
  self.newScore = ed.AutoChessRankManager:getNewRankScore(self.oldScore, scoreDiff)
  self.oldScore = 50
  self.newScore = 100
  self.isRunningAnim = false
  self.starFcaList = {}
  self.activeStarRes = "UI/alpha/1080P/common/detail_star.png"
  self.notActiveStarRes = "UI/alpha/1080P/common/detail_star_grey.png"
end

local useCircle = false

function AutoChessRankIconPanel:getRotation(count, i)
  if useCircle then
    return ed.AutoChessRankManager:getRotation(count, i)
  else
    return 0
  end
end

function AutoChessRankIconPanel:getPosition(cx, cy, r, rotation, count, i)
  if useCircle then
    return ed.AutoChessRankManager:getPosAtCircle(cx, cy, r, rotation)
  else
    local sepx = 54
    local ox = cx - sepx * (count - 1) / 2
    ox = ox + sepx * (i - 1)
    local oy = cy + r
    return ccp(ox, oy)
  end
end

function AutoChessRankIconPanel:updateStars(score)
  local info = ed.AutoChessRankManager:getRankGradeInfoByScore(score)
  local cx, cy = self.ui.iconGrade:getPosition()
  local r = 164
  local activeStars = ed.AutoChessRankManager:getRankGradeStarsByScore(score)
  local allStars = info.stars
  for i = 1, 6 do
    local star = self.ui["star" .. i]
    ed.setTexture(star, self.activeStarRes)
    star:setVisible(false)
  end
  for i = 1, allStars do
    local star = self.ui["star" .. i]
    local rotation = self:getRotation(allStars, i)
    local pos = self:getPosition(cx, cy, r, rotation, allStars, i)
    star:setRotation(rotation)
    star:setPosition(pos)
    if i > activeStars then
      ed.setTexture(star, self.notActiveStarRes)
    end
    star:setVisible(true)
  end
end

function AutoChessRankIconPanel:addLabelToBgFca(componentName, text)
  local labelContainer = CCNode:create()
  local label = ed.createLabelTTF(text, 20)
  labelContainer:addChild(label)
  self.bgFca:addNodeToComponent(labelContainer, componentName, 0)
  return label
end

function AutoChessRankIconPanel:addSpriteToBgFca(componentName, res)
  local spriteContainer = CCNode:create()
  local sprite = ed.createSprite(res)
  spriteContainer:addChild(sprite)
  self.bgFca:addNodeToComponent(spriteContainer, componentName, 0)
  return sprite
end

function AutoChessRankIconPanel:createBgFca(res)
  local bgFca = ed.createFcaNode(res)
  self.mainLayer:addChild(bgFca)
  ed.layout.centerInScreen(bgFca)
  self:addFca(bgFca)
  self.bgFca = bgFca
  self.bgFcaRes = res
  self.ui.iconGrade:setVisible(false)
  self.ui.labelGrade:setVisible(false)
  self.labelGrade = self:addLabelToBgFca("title", "")
  self.labelGrade2 = self:addLabelToBgFca("title2", "")
  self.labelGrade2:setVisible(false)
  self.iconGrade = self:addSpriteToBgFca("grade", "UI/alpha/1080P/chess/season/6.png")
  self.iconGrade2 = self:addSpriteToBgFca("grade2", "UI/alpha/1080P/chess/season/6.png")
  self.iconGrade2:setVisible(false)
end

function AutoChessRankIconPanel:addStarFca(up)
  local fca = ed.createFcaNode("eff_UI_autochess_scorechange")
  fca:setAction(up and "Start_1" or "Start_2")
  self:addFca(fca)
  self.ui.bg:addChild(fca, 5)
  table.insert(self.starFcaList, fca)
  return fca
end

function AutoChessRankIconPanel:putStarFcaOverStar(starNode, starFca)
  local x, y = starNode:getPosition()
  starFca:setPosition(ccp(x, y))
end

function AutoChessRankIconPanel:setStarsFcaVisible(visible)
  for k, v in ipairs(self.starFcaList) do
    v:setVisible(visible)
  end
end

function AutoChessRankIconPanel:setStarsTexture(active)
  for i = 1, 6 do
    local star = self.ui["star" .. i]
    ed.setTexture(star, active and self.activeStarRes or self.notActiveStarRes)
  end
end

function AutoChessRankIconPanel:playAnim1(score, newGrade)
  self.bgFca:setAction("Start4")
  local scope = {}
  local t1 = 2.2
  local t2 = 2.3
  local tickSep = (t2 - t1) / 10
  local scale = 1
  ListenTimer(Timer:Once(2.2), function()
    ListenTimer(Timer:Always(0.01), function()
      scale = scale - 0.2
      if scale < 0 then
        CloseScope(scope)
        return
      end
      self.iconGrade:setScale(scale)
    end, scope)
    self.labelGrade:setVisible(false)
  end)
  ListenTimer(Timer:Once(t2), function()
    CloseScope(scope)
    self:updateStars(score)
  end)
  ListenTimer(Timer:Once(2.7), function()
    ed.setTexture(self.iconGrade, newGrade.iconRes)
    self.iconGrade:setScale(1)
    self.iconGrade:setVisible(true)
    ed.setString(self.labelGrade, newGrade.name)
    self.labelGrade:setVisible(true)
    self:setMyNewScore()
    self.isRunningAnim = false
  end)
  self:listenTimer(Timer:Once(5), function()
    self.bgFca:setLoopAction("Loop4")
  end)
end

function AutoChessRankIconPanel:runStarActionSeq(oldStars, oldGrade, score, newStars)
  local arr = CCArray:create()
  local delayTime = 0.5
  local first = true
  
  local function addToArr(action)
    if first then
      first = false
    else
      arr:addObject(CCDelayTime:create(delayTime))
    end
    arr:addObject(action)
  end
  
  for i = oldStars + 1, math.min(oldGrade.stars, 6) do
    local star = self.ui["star" .. i]
    addToArr(CCCallFunc:create(function()
      local fca = self:addStarFca(true)
      self:putStarFcaOverStar(star, fca)
    end))
  end
  addToArr(CCCallFunc:create(function()
    self:setStarsFcaVisible(false)
    self:updateStars(score)
    self:setStarsTexture(false)
  end))
  first = true
  for i = 1, newStars do
    local star = self.ui["star" .. i]
    addToArr(CCCallFunc:create(function()
      local fca = self:addStarFca(true)
      self:putStarFcaOverStar(star, fca)
    end))
  end
  local seq = CCSequence:create(arr)
  self.ui.iconGrade:runAction(seq)
end

function AutoChessRankIconPanel:playAnim2(oldStars, oldGrade, score, newStars, newGrade)
  self.bgFca:setAction("Start3")
  local scope = {}
  local t1 = 2.2
  local t2 = 2.3
  local tickSep = (t2 - t1) / 10
  local scale = 1
  ListenTimer(Timer:Once(t1), function()
    ListenTimer(Timer:Always(tickSep), function()
      scale = scale - 0.2
      if scale < 0 then
        CloseScope(scope)
        return
      end
      self.iconGrade:setScale(scale)
    end, scope)
    self.labelGrade:setVisible(false)
  end)
  ListenTimer(Timer:Once(t2), function()
    self.iconGrade:setVisible(false)
    CloseScope(scope)
  end)
  ListenTimer(Timer:Once(2.7), function()
    self:runStarActionSeq(oldStars, oldGrade, score, newStars)
    ed.setTexture(self.iconGrade2, newGrade.iconRes)
    self.iconGrade2:setVisible(true)
    ed.setString(self.labelGrade2, newGrade.name)
    self.labelGrade2:setVisible(true)
    self:setMyNewScore()
    self.isRunningAnim = false
  end)
  self:listenTimer(Timer:Once(3.3), function()
    self.bgFca:setLoopAction("Loop3")
  end)
end

function AutoChessRankIconPanel:playAnim3(oldStars, oldGrade, score, newStars, newGrade)
  self.bgFca:setAction("Start2")
  ed.setString(self.labelGrade2, newGrade.name)
  self.labelGrade2:setVisible(true)
  ListenTimer(Timer:Once(2.4), function()
    self.labelGrade:setVisible(false)
  end)
  self:listenTimer(Timer:Once(3), function()
    self:runStarActionSeq(oldStars, oldGrade, score, newStars)
    self:setMyNewScore()
    self.isRunningAnim = false
  end)
  self:listenTimer(Timer:Once(3.9), function()
    self.bgFca:setLoopAction("Loop2")
  end)
end

function AutoChessRankIconPanel:playAnim4(oldStars, oldGrade, score, newStars, newGrade)
  self.bgFca:setAction("Start1")
  local diff = newStars - oldStars
  local delayTime = 0.5
  local first = true
  
  local function addToArr(arr, action)
    if first then
      first = false
    else
      arr:addObject(CCDelayTime:create(delayTime))
    end
    arr:addObject(action)
  end
  
  local function addStarFcaActions(arr)
    if 0 <= diff then
      local target = newStars
      for i = oldStars + 1, target do
        local star = self.ui["star" .. i]
        if tolua.isnull(star) then
          return
        end
        addToArr(arr, CCCallFunc:create(function()
          local fca = self:addStarFca(true)
          self:putStarFcaOverStar(star, fca)
        end))
      end
    else
      local target = newStars + 1
      for i = oldStars, target, -1 do
        local star = self.ui["star" .. i]
        if tolua.isnull(star) then
          return
        end
        addToArr(arr, CCCallFunc:create(function()
          local fca = self:addStarFca(false)
          self:putStarFcaOverStar(star, fca)
        end))
      end
    end
  end
  
  local st = 0.5
  ListenTimer(Timer:Once(st), function()
    local arr = CCArray:create()
    addStarFcaActions(arr)
    arr:addObject(CCCallFunc:create(function()
      self:updateStars(score)
    end))
    addToArr(arr, CCCallFunc:create(function()
      self:setMyNewScore()
    end))
    local seq = CCSequence:create(arr)
    self.ui.iconGrade:runAction(seq)
  end)
  ListenTimer(Timer:Once(1.6), function()
    self.bgFca:setLoopAction("Loop1")
    self.isRunningAnim = false
  end)
end

function AutoChessRankIconPanel:loadNewGradeInfo(score, oldScore)
  self.isRunningAnim = true
  local oldGrade = ed.AutoChessRankManager:getRankGradeInfoByScore(oldScore)
  local newGrade = ed.AutoChessRankManager:getRankGradeInfoByScore(score)
  local gradeChanged = oldGrade.id ~= newGrade.id
  local largeGradeChanged = oldGrade.largeGradeId ~= newGrade.largeGradeId
  local levelUpToMaxGrade = newGrade.isMaxGrade and not oldGrade.isMaxGrade
  local oldStars = ed.AutoChessRankManager:getRankGradeStarsByScore(oldScore)
  local newStars = ed.AutoChessRankManager:getRankGradeStarsByScore(score)
  self:createBgFca("eff_UI_autochess_gradeup")
  self:updateStars(oldScore)
  ed.setTexture(self.iconGrade, oldGrade.iconRes)
  ed.setString(self.labelGrade, oldGrade.name)
  if levelUpToMaxGrade then
    self:playAnim1(score, newGrade)
  elseif largeGradeChanged then
    self:playAnim2(oldStars, oldGrade, score, newStars, newGrade)
  elseif gradeChanged then
    self:playAnim3(oldStars, oldGrade, score, newStars, newGrade)
  else
    self:playAnim4(oldStars, oldGrade, score, newStars, newGrade)
  end
end

function AutoChessRankIconPanel:initUI()
  ed.editorui(ed.uieditor.AutoChessRankGradeChangePanel, {
    container = self.container,
    ui = self.ui
  })
  self:loadNewGradeInfo(self.newScore, self.oldScore)
end

function AutoChessRankIconPanel.create(param)
  local self = base.create("AutoChessRankIconPanel")
  setmetatable(self, AutoChessRankIconPanel.mt)
  self:initData(param)
  self:initUI()
  self:registerTouchHandlers()
  self:registerEvents()
  self:popWindow()
  return self
end

function AutoChessRankIconPanel:registerTouchHandlers()
  self:btRegisterClick({
    key = "autochessRankIconPanel",
    clickHandler = function(param, x, y)
      self:closeByScaleTo()
    end,
    force = true,
    priority = 10
  })
end

function AutoChessRankIconPanel:registerEvents()
end

function AutoChessRankIconPanel:setMyNewScore()
  ed.AutoChessRankManager:setMyRankScore(self.newScore)
end

function AutoChessRankIconPanel:setStarsVisible(visible)
  for i = 1, 6 do
    local star = self.ui["star" .. i]
    star:setVisible(visible)
  end
end

function AutoChessRankIconPanel:closeByScaleTo()
  if self.isRunningAnim then
    return
  end
  if self.scalingTo then
    return
  end
  self.scalingTo = true
  for i = 1, 6 do
    local star = self.ui["star" .. i]
    star:setVisible(false)
  end
  self.bgFca:setVisible(false)
  self:setStarsFcaVisible(false)
  local info = ed.AutoChessRankManager:getRankGradeInfoByScore(self.newScore)
  local node = ed.AutoChessRankManager:getGradeIconNode(info)
  node:setPositionY(115)
  self.mainLayer:addChild(node)
  local duration = 0.25
  local aScale = CCScaleTo:create(duration, 0.53)
  local aMove = CCMoveTo:create(duration, ccp(8, 4))
  local s = CCSpawn:createWithTwoActions(aScale, aMove)
  s = CCEaseSineInOut:create(s)
  local f = CCCallFunc:create(function()
    self:destroy()
  end)
  s = CCSequence:createWithTwoActions(s, f)
  node:runAction(s)
end
