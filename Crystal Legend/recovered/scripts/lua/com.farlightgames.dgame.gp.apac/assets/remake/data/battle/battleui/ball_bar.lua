local ed = ed
local class = {
  mt = {}
}
class.mt.__index = class
local ballPosition = {
  -27,
  0,
  27
}
local epsilon = ed.epsilon
local bornDuration = 0.2
local BallSkillSlots = {
  [535] = 101,
  [536] = 102,
  [537] = 103,
  [538] = 104,
  [539] = 105,
  [5310] = 106,
  [5311] = 107,
  [5312] = 108,
  [5313] = 109,
  [5314] = 110
}

local function getSlot(self)
  local t = {}
  for _, slot in ipairs(self.slots) do
    if slot.ballType ~= "" then
      t[slot.ballType] = (t[slot.ballType] or 0) + 1
    end
  end
  if not t.ice then
    t.ice = 0
  end
  if not t.fire then
    t.fire = 0
  end
  if not t.lightning then
    t.lightning = 0
  end
  for k, v in pairs(ed.KaelSkillElement) do
    if v[1] == t.ice and v[2] == t.fire and v[3] == t.lightning then
      return BallSkillSlots[k]
    end
  end
end

local function addBall(self, ballType, i)
  local sl = self.slots[i]
  if sl.ballStatus ~= 0 then
    self:moveUpward()
  end
  sl.sprite = self:getBornBall()
  sl.sprite:setPosition(ccp(ballPosition[i], 2))
  sl.sprite:setVisible(true)
  sl.sprite:setAction(ballType .. "_get")
  sl.ballType = ballType
  sl.ballStatus = 1
  sl.duration = bornDuration
end

class.addBall = addBall
local moveDuration = 0.2

local function moveUpward(self)
  for i = 1, 3 do
    local sl = self.slots[i]
    if not sl then
      return
    end
    sl.ballStatus = 0
  end
  for i = 1, 3 do
    local sl = self.slots[i]
    sl.sprite:runAction(CCSequence:create(ccArrayMake(CCMoveTo:create(moveDuration, ccpAdd(ccp(ballPosition[i], 2), ccp(0, 30))))))
  end
  if self.showicon:isVisible() then
    local x, y = self.showicon:getPosition()
    self.showicon:runAction(CCMoveTo:create(moveDuration, ccpAdd(ccp(x, y), ccp(0, 30))))
  end
  if self.skillIcon:isVisible() then
    local x, y = self.skillIcon:getPosition()
    self.skillIcon:runAction(CCMoveTo:create(moveDuration, ccpAdd(ccp(x, y), ccp(0, 30))))
  end
end

class.moveUpward = moveUpward

local function playCompose(self)
  local skillicon = ed.readhero.createSkillIcon(53, getSlot(self))
  self.skillIcon = skillicon
  self.node:addChild(skillicon, 2)
  skillicon:setPosition(ccp(0, 2))
  skillicon:setScale(0)
  skillicon:runAction(CCSequence:create(ccArrayMake(CCDelayTime:create(0.2), CCCallFunc:create(function()
    for _, v in ipairs(self.lastBalls) do
      v:setVisible(false)
    end
    self.lastBalls = {}
    self.showicon:setPosition(ccp(0, 2))
    self.showicon:setVisible(true)
    self.showicon:setAction("Start")
  end), CCScaleTo:create(0.2, 0.5), CCDelayTime:create(0.5), CCFadeOut:create(0.3), CCCallFunc:create(function()
    self.skillIcon:setVisible(false)
    for i = 1, 3 do
      local sl = self.slots[i]
      sl.ballStatus = 0
    end
  end))))
  for i = 1, 3 do
    local sl = self.slots[i]
    sl.sprite:setAction(sl.ballType .. "_use")
    sl.sprite:setLoop(false)
    sl.ballStatus = 3
    sl.ballType = ""
    sl.duration = 0
    table.insert(self.lastBalls, sl.sprite)
  end
end

class.playCompose = playCompose

local function getBornBall(self)
  if self.curBallIdx == 7 then
    self.curBallIdx = 0
  end
  self.curBallIdx = self.curBallIdx + 1
  return self.balls[self.curBallIdx]
end

class.getBornBall = getBornBall

local function init(self)
  self.skillCastStatus = 0
  self.showicon = ed.createFcaActor("effect/eff_UI_Kael_showicon", 1)
  for i = 1, 3 do
    self.slots[i] = {
      ballType = "",
      ballStatus = 0,
      duration = 0
    }
  end
  for i = 1, 8 do
    local ball = ed.createFcaActor("effect/eff_UI_Kael_ball", 1)
    self.node:addChild(ball, 1)
    ball:setVisible(false)
    self.balls[i] = ball
  end
  self.curBallIdx = 0
  self.showicon:setVisible(false)
  self.node:addChild(self.showicon, 4)
end

class.init = init

local function BallBarCreate(unit)
  local self = {
    unit = unit,
    node = CCNode:create(),
    ballSprites = {},
    slots = {},
    skillCastStatus = 0,
    skillIcon = nil,
    balls = {},
    lastBalls = {}
  }
  setmetatable(self, class.mt)
  unit.ballBar = self
  self:init()
  return self
end

class.create = BallBarCreate
ed.BallBarCreate = BallBarCreate

local function isSlotsFull(self)
  for i, slot in ipairs(self.slots) do
    if slot.ballType == "" then
      return false
    end
  end
  return true
end

local function update(self, dt)
  local model = self.unit
  if not model.energy_ball_manager or not model:isAlive() then
    return
  end
  for _, v in ipairs(self.slots) do
    if v.ballStatus == 1 and v.duration >= epsilon then
      v.duration = v.duration - dt
      if v.duration < epsilon then
        v.sprite:setAction(v.ballType .. "_wait")
        v.sprite:setLoop(true)
        v.ballStatus = 2
      end
    end
  end
  for _, v in ipairs(self.slots) do
    if v.sprite and v.sprite:isVisible() then
      v.sprite:update(dt)
    end
  end
  if self.showicon:isVisible() then
    self.showicon:update(dt)
  end
  return
end

class.update = update

local function removeBall(self)
  for _, v in pairs(self.balls) do
    v:setVisible(false)
  end
  if self.skillIcon then
    self.skillIcon:setVisible(false)
  end
  if self.showicon then
    self.showicon:setVisible(false)
  end
end

class.removeBall = removeBall
