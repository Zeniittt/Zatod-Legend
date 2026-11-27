local bg_conf = {
  [1] = {
    res = "db_water.png",
    oriPos = ccp(480, 164),
    speedScale = 1,
    name = "water",
    continuity = true,
    z = 1
  },
  [2] = {
    res = "db_sky.png",
    oriPos = ccp(480, 523),
    speedScale = 0,
    name = "sky",
    z = 2
  },
  [3] = {
    res = "db_cloud.png",
    oriPos = ccp(510, 523),
    speedScale = 0.08,
    name = "cloud",
    randomRange = 60,
    z = 3
  },
  [4] = {
    res = "db_mountain2.png",
    oriPos = ccp(486, 480),
    speedScale = 0.1,
    name = "far_mountain",
    randomRange = 60,
    z = 4
  },
  [5] = {
    res = "db_mountain1.png",
    oriPos = ccp(490, 508),
    speedScale = 0.2,
    name = "near_mountain",
    randomRange = 200,
    z = 5
  },
  [6] = {
    res = "db_island.png",
    oriPos = ccp(623, 408),
    speedScale = 0.5,
    name = "island",
    randomRange = 200,
    z = 6
  },
  [7] = {
    res = "db_foreground.png",
    oriPos = ccp(636, -13),
    speedScale = 2,
    name = "rock",
    randomRange = 960,
    z = 7
  }
}

function ed.getMoonFestivalRaceBGConf()
  return bg_conf
end

local class = {}
class.__index = class
ed.moonFestivalRaceBGClass = class

function class.create(params)
  local self = {}
  setmetatable(self, class)
  self:init(params)
  return self
end

function class:init(params)
  self:initData(params)
  self:initBG()
end

function class:initData(params)
  self.conf = params.conf
  self.sceneSelf = params.sceneSelf
  self.container = params.container
end

function class:initBG()
  local leftBg = ed.createSprite(self.getUIRes(self.conf.res))
  leftBg:setScale(2)
  local wid = leftBg:getContentSize().width * 2
  self.leftBg = leftBg
  leftBg:setPosition(self.conf.oriPos)
  self.container:addChild(leftBg)
  leftBg:setZOrder(self.conf.z)
  if self.conf.continuity or self.conf.randomRange then
    local rightBg = ed.createSprite(self.getUIRes(self.conf.res))
    rightBg:setScale(2)
    self.rightBg = rightBg
    self.container:addChild(rightBg)
    rightBg:setZOrder(self.conf.z)
    rightBg:setPosition(self.conf.oriPos)
    self:refreshPos()
  end
end

function class:setBgBlur(opacity)
  local wid = self.leftBg:getContentSize().width
  self:setBlur(self.leftBg, opacity or 300, wid * 2)
  if self.rightBg then
    self:setBlur(self.rightBg, opacity or 300, wid * 2)
  end
end

function class:resetBgBlur()
  ed.resetSpriteShader(self.leftBg)
  ed.resetSpriteShader(self.rightBg)
end

function class:setBlur(sprite, radius, cellNum)
  ed.setHorizontalBlur(sprite, radius, cellNum)
end

function class:update(dt)
  local bgSpeed = ed.dragonBoatMgr.getInstance().bgSpeed
  if bgSpeed < 0 then
    local posX = self.rightBg:getPositionX()
    local wid = self.rightBg:getContentSize().width * 2
    if posX - wid * 0.5 > ed.display.winSize.width then
      self.leftBg, self.rightBg = self.rightBg, self.leftBg
      self:refreshPos()
    end
  else
    local posX = self.leftBg:getPositionX()
    local wid = self.leftBg:getContentSize().width * 2
    if 0 > posX + wid * 0.5 then
      self.leftBg, self.rightBg = self.rightBg, self.leftBg
      self:refreshPos()
    end
  end
  local deltaX = self.conf.speedScale * ed.dragonBoatMgr.getInstance().bgSpeed * dt
  ed.UITool.setPositionBy(self.leftBg, ccp(-deltaX, 0))
  ed.UITool.setPositionBy(self.rightBg, ccp(-deltaX, 0))
end

function class.getUIRes(name)
  return "UI/alpha/1080P/dragonboat/db_main_bg/" .. name
end

function class:refreshPos()
  local inter = -1
  if self.conf.randomRange then
    local random_num = math.random(0, self.conf.randomRange)
    print(random_num)
    inter = random_num
  end
  if 0 > ed.dragonBoatMgr.getInstance().bgSpeed then
    self.left2(self.leftBg, self.rightBg, inter, self.conf.continuity)
  else
    self.right2(self.rightBg, self.leftBg, inter, self.conf.continuity)
  end
end

function class.right2(node, ref, inter, ignoreScreen)
  ed.right2(node, ref, inter)
  if not ignoreScreen then
    local posX = node:getPositionX()
    local wid = node:getContentSize().width * 2
    if posX - wid * 0.5 < ed.display.winSize.width then
      node:setPositionX(ed.display.winSize.width + wid * 0.5)
    end
  end
end

function class.left2(node, ref, inter, ignoreScreen)
  ed.left2(node, ref, inter)
  if not ignoreScreen then
    local posX = node:getPositionX()
    local wid = node:getContentSize().width * 2
    if posX + wid * 0.5 > 0 then
      node:setPositionX(-wid * 0.5)
    end
  end
end
