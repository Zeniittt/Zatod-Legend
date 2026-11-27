local ed = ed
local class = {
  mt = {}
}
ed.Loot = class
class.mt.__index = class

local function BallCreate(deliverer, balltype, idx, dsIdx, duration, skill, fromLaunchPoint)
  local ballFcaAcotr = "eff_UI_Kael_dropball"
  if ed.engine.playerKaelHero and deliverer.camp == ed.emCampPlayer then
    if 531 == ed.engine.playerKaelHero.fashion_id then
      ballFcaAcotr = "eff_UI_Kael_fashion_1_dropball"
    end
  elseif ed.engine.enemyKaelHero and deliverer.camp == ed.emCampEnemy and 531 == ed.engine.enemyKaelHero.fashion_id then
    ballFcaAcotr = "eff_UI_Kael_fashion_1_dropball"
  end
  local self = {
    what = "Ball",
    idx = idx,
    node = CCNode:create(),
    ballType = balltype,
    deliverer = deliverer,
    position = {
      deliverer.position[1],
      deliverer.position[2]
    },
    height = 0,
    terminated = false,
    bound = CCDirector:sharedDirector():getVisibleOrigin().x,
    ball = ed.createFcaActor(ballFcaAcotr),
    duration = duration,
    status = 0,
    slotIdx = dsIdx,
    canpick = false,
    oriVelocity = 500,
    velocity = 500,
    tapped = false
  }
  setmetatable(self, class.mt)
  self.ball:setPosition(ed.ccpZero)
  self.ball:setAction(balltype .. "_drop")
  self.status = 1
  self.node:addChild(self.ball, 1)
  if fromLaunchPoint and skill then
    self.position, self.height = skill:launchPoint()
  end
  local pos = FlipXPosition(self.position)
  local p = ed.toViewPosition(pos, self.height)
  self.node:setPosition(p)
  self.dstPoint = ed.engine.slotPositions[dsIdx]
  self.rad = math.atan((self.dstPoint[2] - p.y) / (self.dstPoint[1] - p.x))
  local len = math.sqrt(ccpLengthSQ(ccp(self.dstPoint[1] - p.x, self.dstPoint[2] - p.y)))
  self.node:setRotation(-math.deg(math.atan2(self.dstPoint[2] - p.y, self.dstPoint[1] - p.x)))
  ed.sceneui.ballSlots[idx] = self
  local flytime = len / 500
  if 0.25 < flytime then
    flytime = 0.25
  end
  self.node:runAction(CCSequence:create(ccArrayMake(CCMoveTo:create(flytime, ccp(self.dstPoint[1], self.dstPoint[2])), CCCallFunc:create(function()
    self.canpick = true
    self.node:setRotation(0)
    self.ball:setAction(balltype .. "_birth")
  end), CCDelayTime:create(0.4), CCCallFunc:create(function()
    self.status = 2
    self.ball:setAction(self.ballType .. "_stay")
    self.ball:setLoop(true)
  end), CCDelayTime:create(duration - 1 - 0.4 - 0.4), CCCallFunc:create(function()
    self.status = 3
    self.ball:setAction(self.ballType .. "_fade")
    self.ball:setLoop(true)
  end))))
  return self
end

ed.BallCreate = BallCreate
class.BallCreate = BallCreate
local Status = {
  1,
  2,
  3,
  4,
  5
}
local acce = 150

local function update(self, dt)
  if self.terminated then
    return
  end
  self.ball:update(dt)
end

class.update = update

local function onTapped(self)
  if self.tapped then
    return
  end
  local kael
  if self.deliverer.camp == ed.emCampPlayer then
    kael = ed.engine.playerKaelHero
  else
    kael = ed.engine.enemyKaelHero
  end
  local ballmodel = kael.deliveredBalls[self.idx]
  if not ballmodel then
    return
  end
  if ballmodel.tapped then
    return
  end
  local s, myslotidx = ed.engine:getAvailableBallSlot(self.deliverer)
  if s then
    self.tapped = true
    s:preOccupy()
  else
    self.ball:setAction(self.ballType .. "_vibrate")
    self.ball:setLoop(false)
    local picknode = ed.createFcaNode("eff_UI_Kael_notpick")
    picknode:setPosition(ed.sceneui.ballPositions[2])
    ed.scene:addEffect(picknode, 2)
    return
  end
  ballmodel.tapped = true
  ed.engine:manualTapBall(self.deliverer, self.idx, myslotidx)
end

class.onTapped = onTapped

local function onTapped2(self, myslotidx)
  local kael
  if self.deliverer.camp == ed.emCampPlayer then
    kael = ed.engine.playerKaelHero
  else
    kael = ed.engine.enemyKaelHero
  end
  local s = kael.energy_ball_manager.slots[myslotidx]
  local i = myslotidx
  local picknode = ed.createFcaNode("eff_UI_Kael_pickball_" .. self.ballType)
  picknode:setPosition(ccp(self.dstPoint[1], self.dstPoint[2]))
  ed.scene:addEffect(picknode, 2)
  self.terminated = true
  self.node:setVisible(false)
  ed.sceneui.ballSlots[self.idx] = nil
  self.status = 6
end

class.onTapped2 = onTapped2
