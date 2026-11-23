module("ed", package.seeall)
local setLength = CCNode.setScaleX
local setVisible = CCNode.setVisible
local epsilon = epsilon
local max = math.max
local min = math.min
local GuildHpBar = {}
GuildHpBar.__index = GuildHpBar

function GuildHpBar.create(length)
  local self = {
    type = "HP",
    what = "GuildHpBar",
    node = CCNode:create(),
    background = createScale9Sprite("UI/alpha/1080P/common/guildraid_hpbar_boss_bg.png"),
    midlayer = createScale9Sprite("UI/alpha/1080P/common/guildraid_hpbar_transition.png"),
    midClipLayer = CCLayer:create(),
    decration = CCSprite:create(),
    foreground = CCSprite:create(),
    foregroundClipLayer = CCLayer:create(),
    bossIconFrameNode = createSprite("UI/alpha/1080P/common/boss_frame.png"),
    inc_speed = 0.3,
    fore_length = 1,
    mid_length = 1,
    percent = 1,
    isMinBlood = false,
    isMaxBlood = false
  }
  self.background:setContentSize(CCSizeMake(365, 13.5))
  self.midlayer:setContentSize(CCSizeMake(363, 12.5))
  setmetatable(self, GuildHpBar)
  self.bloodBarInfo = {
    [1] = 250,
    [2] = 0.004
  }
  self:resetBloodState()
  self.percent = self.bloodPercent
  self.fore_length = self.percent
  self.mid_length = self.percent
  local iconFrameSize = self.bossIconFrameNode:getTextureRect().size
  local backgroundSize = self.background:getContentSize()
  local midlayerSize = self.midlayer:getContentSize()
  local foregroundSize = self.foreground:getTextureRect().size
  local hpBarLength = length - iconFrameSize.width
  local scale = math.min(hpBarLength * 0.9 / backgroundSize.width, 1)
  local offsetX = backgroundSize.width - (backgroundSize.width - midlayerSize.width) / 2
  local offsetY = backgroundSize.height / 2
  local offsetXLeft = (backgroundSize.width - midlayerSize.width) / 2
  local offsetYDown = (backgroundSize.height - midlayerSize.height) / 2
  self.node:addChild(self.background)
  self.background:setScaleX(scale)
  self.background:setPosition(ccpZero)
  self.background:setAnchorPoint(ccp(0.5, 0.5))
  self.background:addChild(self.decration, 0)
  self.decration:setAnchorPoint(ccp(1, 0.5))
  self.decration:setPosition(ccp(offsetX, offsetY))
  self.midClipLayer:setAnchorPoint(ccpZero)
  self.midClipLayer:setClipRect(CCRectMake(0, 0, midlayerSize.width, midlayerSize.height))
  self.midClipLayer:addChild(self.midlayer)
  self.midlayer:setAnchorPoint(ccpZero)
  self.background:addChild(self.midClipLayer, 1)
  self.midClipLayer:setPosition(ccp(offsetXLeft, offsetYDown))
  self.foregroundClipLayer:setAnchorPoint(ccpZero)
  self.foregroundClipLayer:setClipRect(CCRectMake(0, 0, foregroundSize.width, foregroundSize.height))
  self.foregroundClipLayer:addChild(self.foreground)
  self.foreground:setAnchorPoint(ccpZero)
  self.background:addChild(self.foregroundClipLayer, 1)
  self.foregroundClipLayer:setPosition(ccp(offsetXLeft, offsetYDown))
  self:setBarPercent(self.midClipLayer, self.midlayer, self.percent)
  self:setBarPercent(self.foregroundClipLayer, self.foreground, self.percent)
  return self
end

ed.ui.GuildHpBarCreate = GuildHpBar.create

function GuildHpBar:update(dt)
  local node = self.node
  local bloodIndex, bloodPercent, realBloodPercent = self:getBloodBarIndexAndPercent()
  if realBloodPercent < 0 then
    node:removeFromParentAndCleanup(true)
    self.terminated = true
    return
  end
  self.bloodPercent = bloodPercent
  self.percent = bloodPercent
  if self.bloodIndex ~= bloodIndex then
    if bloodIndex > self.bloodIndex then
      self.isMinBlood = true
      self.percent = 0
    else
      self.isMaxBlood = true
      self.percent = 1
    end
  end
  local foreground = self.foreground
  local midlayer = self.midlayer
  local inc_speed = self.inc_speed
  local fore_length = self.fore_length
  local mid_length = self.mid_length
  local percent = self.percent
  if fore_length < percent - epsilon then
    fore_length = fore_length + inc_speed * dt
    if percent < fore_length then
      fore_length = percent
    end
    self.fore_length = fore_length
    self:setBarPercent(self.foregroundClipLayer, foreground, fore_length)
  elseif fore_length > percent + epsilon then
    fore_length = percent
    self.fore_length = fore_length
    self:setBarPercent(self.foregroundClipLayer, foreground, percent)
  end
  if mid_length < fore_length - epsilon then
    self.mid_length = fore_length
    self:setBarPercent(self.midClipLayer, midlayer, fore_length)
  elseif mid_length > fore_length then
    mid_length = mid_length - inc_speed * dt
    self.mid_length = mid_length
    self:setBarPercent(self.midClipLayer, midlayer, mid_length)
  end
  if percent == 0 and self.isMinBlood then
    if fore_length >= mid_length then
      self:resetBloodState()
      self.percent = self.bloodPercent
      self:setBarPercent(self.foregroundClipLayer, foreground, self.percent)
      self:setBarPercent(self.midClipLayer, midlayer, 1)
      self.fore_length = self.percent
      self.mid_length = 1
      self.bloodIndex = bloodIndex
      self.isMinBlood = false
    end
  elseif percent == 1 and self.isMaxBlood and fore_length >= percent - epsilon then
    self:resetBloodState()
    self.percent = self.bloodPercent
    self:setBarPercent(self.midClipLayer, midlayer, 0)
    self:setBarPercent(self.foregroundClipLayer, foreground, 0)
    self.fore_length = 0
    self.mid_length = 0
    self.bloodIndex = bloodIndex
    self.isMaxBlood = false
  end
end

function GuildHpBar:getBloodBarRcsAndPercent(count)
  local ret = {}
  for i = count, 1, -1 do
    local index = math.mod(i, 3)
    local name = ""
    if index == 1 then
      name = "UI/alpha/1080P/raid/damagebar_red.png"
    elseif index == 2 then
      name = "UI/alpha/1080P/raid/damagebar_purple.png"
    elseif index == 0 then
      name = "UI/alpha/1080P/raid/damagebar_blue.png"
    end
    local item = {
      name,
      1 / count
    }
    table.insert(ret, item)
  end
  return ret
end

function GuildHpBar:getBloodBarRcs(index)
  local ind = math.mod(index, 3)
  local name = ""
  if ind == 1 then
    name = "UI/alpha/1080P/raid/damagebar_red.png"
  elseif ind == 2 then
    name = "UI/alpha/1080P/raid/damagebar_purple.png"
  elseif ind == 0 then
    name = "UI/alpha/1080P/raid/damagebar_blue.png"
  end
  return name
end

function GuildHpBar:getBloodBarIndexAndPercent()
  local bloodIndex = 0
  local bloodPercent = 0
  local realBloodPercent = math.floor(engine:getPlayerTotalDamage(emCampPlayer)) / 10000000
  bloodIndex = math.ceil(realBloodPercent / self.bloodBarInfo[2])
  bloodPercent = (bloodIndex * self.bloodBarInfo[2] - realBloodPercent) / self.bloodBarInfo[2]
  if 0 == bloodIndex then
    bloodIndex = 1
  end
  return bloodIndex, bloodPercent, realBloodPercent
end

function GuildHpBar:resetForegroundAndDecration()
  local foregroundRcsName = self:getBloodBarRcs(self.bloodIndex)
  local decrationRcsName
  if self.bloodIndex < self.bloodBarInfo[1] then
    decrationRcsName = self:getBloodBarRcs(self.bloodIndex + 1)
    self.decration:setVisible(true)
  else
    self.decration:setVisible(false)
  end
  if decrationRcsName then
    self.decration:setDisplayFrame(getSpriteFrame(decrationRcsName))
  end
  if foregroundRcsName then
    self.foreground:setDisplayFrame(getSpriteFrame(foregroundRcsName))
  end
end

function GuildHpBar:resetBloodState()
  local bloodIndex, bloodPercent = self:getBloodBarIndexAndPercent()
  self.bloodIndex = bloodIndex
  self.bloodPercent = bloodPercent
  self:resetForegroundAndDecration()
end

function GuildHpBar:setBarPercent(clipLayer, node, percent)
  if clipLayer and node then
    local size
    if node.getTextureRect then
      size = node:getTextureRect().size
    else
      size = node:getContentSize()
    end
    local scale = self.background:getScaleX()
    local startPosX = size.width * scale * (1 - percent)
    clipLayer:setClipRect(CCRectMake(startPosX, 0, size.width, size.height))
  end
end
