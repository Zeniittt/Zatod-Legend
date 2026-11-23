local CupArenaMatchHeadIcon = newclass()
ed.ui.CupArenaMatchHeadIcon = CupArenaMatchHeadIcon
local NodeZOrder = {
  SelfTip = 1,
  Icon = 2,
  Mask = 3,
  Frame = 4,
  Camp = 5
}

function CupArenaMatchHeadIcon.create(stageLevel, dir, isFinal)
  local self = {}
  setmetatable(self, CupArenaMatchHeadIcon.mt)
  self:initHeadIcon(stageLevel, dir, isFinal)
  return self
end

function CupArenaMatchHeadIcon:initHeadIcon(stageLevel, dir, isFinal)
  self.ui = {}
  self.dir = dir
  self.stageLevel = stageLevel
  self.isFinal = isFinal
  local rootNode = CCNode:create()
  self.ui.rootNode = rootNode
  local frameImg
  if isFinal then
    if 0 == stageLevel then
      frameImg = ed.createSprite("UI/alpha/1080P/cuparena/knockout/course/course_frame_1.png")
      self.ui.rootNode:setScale(1)
    elseif 1 == stageLevel then
      frameImg = ed.createSprite("UI/alpha/1080P/cuparena/knockout/course/course_frame_2.png")
      self.ui.rootNode:setScale(0.9)
    elseif 2 == stageLevel then
      frameImg = ed.createSprite("UI/alpha/1080P/cuparena/knockout/course/course_frame_3.png")
      self.ui.rootNode:setScale(0.8)
    elseif 3 == stageLevel then
      frameImg = ed.createSprite("UI/alpha/1080P/cuparena/knockout/course/course_frame_4.png")
      self.ui.rootNode:setScale(0.78)
    end
  else
    frameImg = ed.createSprite("UI/alpha/1080P/cuparena/knockout/course/course_frame_4.png")
    if 0 == stageLevel then
      self.ui.rootNode:setScale(1)
    elseif 1 == stageLevel then
      self.ui.rootNode:setScale(0.9)
    else
      self.ui.rootNode:setScale(0.8)
    end
  end
  if frameImg then
    self.ui.rootNode:addChild(frameImg, NodeZOrder.Frame)
    frameImg:setPositionY(6)
    self.ui.frameImg = frameImg
  end
end

function CupArenaMatchHeadIcon:updateHeadData(data)
  self.headData = data
  if nil ~= self.ui.headIcon then
    self.ui.headIcon:removeFromParentAndCleanup(true)
    self.ui.headIcon = nil
  end
  if nil == data then
    if nil ~= self.ui.campIcon then
      self.ui.campIcon:setVisible(false)
    end
    if nil == self.ui.unknownIcon then
      local icon = ed.createSprite("UI/alpha/1080P/cuparena/knockout/course/course_player_unknown.png")
      self.ui.rootNode:addChild(icon, NodeZOrder.Icon)
      icon:setScale(1.02)
      icon:setPositionY(5.5)
      self.ui.unknownIcon = icon
    else
      self.ui.unknownIcon:setVisible(true)
    end
    self:setSelf(false)
  else
    if nil ~= self.ui.unknownIcon then
      self.ui.unknownIcon:setVisible(false)
    end
    local summary = data._summary
    local headIcon, headFrame, _ = ed.getHeroIconByID({
      id = summary._avatar
    })
    headFrame:setVisible(false)
    self.ui.rootNode:addChild(headIcon, NodeZOrder.Icon)
    headIcon:setScaleX(self.dir * 1.02)
    headIcon:setScaleY(1.02)
    self.ui.headIcon = headIcon
    local campTableItem = ed.getDataTable("CupArenaCamp")[data._camp_id]
    if nil == self.ui.campIcon then
      local campIcon = ed.createSprite(campTableItem["Camp Symbol Min"])
      self.ui.rootNode:addChild(campIcon, NodeZOrder.Camp)
      campIcon:setPosition(ccp(-25 * self.dir, 25))
      campIcon:setScale(0.55)
      self.ui.campIcon = campIcon
    else
      ed.setTexture(self.ui.campIcon, campTableItem["Camp Symbol Min"])
      self.ui.campIcon:setVisible(true)
    end
    self:setSelf(ed.CupArenaManager:isSelfByOppoData(data))
  end
end

function CupArenaMatchHeadIcon:updateMatchData(data)
  self.matchData = data
end

function CupArenaMatchHeadIcon:setWinner(isWinner)
  if isWinner then
    if nil ~= self.ui.maskImg then
      self.ui.maskImg:setVisible(false)
    end
  elseif nil == self.ui.maskImg then
    self.ui.maskImg = ed.createSprite("UI/alpha/1080P/common/main_head_mask.png")
    self.ui.rootNode:addChild(self.ui.maskImg, NodeZOrder.Mask)
    self.ui.maskImg:setOpacity(127)
  else
    self.ui.maskImg:setVisible(true)
  end
end

function CupArenaMatchHeadIcon:setSelf(isSelf)
  if isSelf then
    if nil == self.ui.selfTipImg then
      local tipImg = ed.createSprite("UI/alpha/1080P/cuparena/knockout/course/course_frame_light.png")
      self.ui.rootNode:addChild(tipImg, NodeZOrder.SelfTip)
      tipImg:setPositionY(5.5)
      self.ui.selfTipImg = tipImg
    else
      self.ui.selfTipImg:setVisible(true)
    end
  elseif self.ui.selfTipImg then
    self.ui.selfTipImg:setVisible(false)
  end
end

function CupArenaMatchHeadIcon:setParent(parentNode)
  parentNode:addChild(self.ui.rootNode)
  local parentSize = parentNode:getContentSize()
  self.ui.rootNode:setPosition(ccp(parentSize.width * 0.5, parentSize.height * 0.5))
end

function CupArenaMatchHeadIcon:registerClickFunc(delegate, key, func)
  local posX, posY = self.ui.rootNode:getPosition()
  local config = {
    button = self.ui.rootNode,
    key = key,
    centerOffset = ccp(posX, posY - 5),
    radius = 35,
    clickHandler = function(_, x, y)
      ed.playEffect(ed.sound.deo.common_back)
      func(self, x, y)
    end,
    force = true,
    mcpMode = true,
    mcp_dis = 30,
    clickInterval = 0.3,
    priority = -1
  }
  delegate:btRegisterButtonClick(config)
end

function CupArenaMatchHeadIcon:getHeadPos()
  local worldPos = self.ui.rootNode:convertToWorldSpace(ed.ccpZero)
  return worldPos
end

function CupArenaMatchHeadIcon:getHeadSize()
  return CCSizeMake(80 * self.ui.rootNode:getScaleX(), 80 * self.ui.rootNode:getScaleY())
end

function CupArenaMatchHeadIcon:getHeadScale()
  return self.ui.rootNode:getScaleX()
end

function CupArenaMatchHeadIcon:isLastStageLevel()
  if self.isFinal then
    return self.stageLevel == 3
  else
    return self.stageLevel == 4
  end
end

function CupArenaMatchHeadIcon:getOperateData()
  if nil == self.headData then
    return
  end
  local data = {
    roleId = self.headData._role_id
  }
  if nil ~= self.matchData then
    data.matchId = self.matchData._match_id
  end
  return data
end

function CupArenaMatchHeadIcon:runAction(action)
  self.ui.rootNode:runAction(action)
end

function CupArenaMatchHeadIcon:stopAllActions()
  self.ui.rootNode:stopAllActions()
end

function CupArenaMatchHeadIcon.calcuHeadDir(headPanel, centerPanel)
  return headPanel ~= centerPanel and headPanel:getPositionX() > centerPanel:getPositionX() and -1 or 1
end
