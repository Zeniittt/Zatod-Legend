local MobaHeroState = {
  Idle = 0,
  Battle = 1,
  Dead = 2
}
local TimeConfig = {
  5,
  10,
  20,
  40,
  80
}
local class = {}
class.__index = class
local instance

function class.getInstance()
  if not instance then
    instance = class.create()
  end
  return instance
end

function class.create()
  local self = {}
  setmetatable(self, class)
  self:initData()
  return self
end

function class:initData()
  self.heroList = {}
  self.enemyList = {}
  self:registerEvent()
end

function class:initBattle(data)
  self.heroList = {}
  self.enemyList = {}
  self.lastJoinHero = 1
  self.lastJoinEnemy = 1
  for k, v in ipairs(data.left) do
    local mobaHero = ed.mobaHero.create(k, v, 1)
    table.insert(self.heroList, mobaHero)
  end
  for k, v in ipairs(data.right) do
    local mobaHero = ed.mobaHero.create(k, v, -1)
    table.insert(self.enemyList, mobaHero)
  end
  for i = 1, 5 do
    self.heroList[i].state = MobaHeroState.Battle
    self.lastJoinHero = i + 1
  end
  for i = 1, 5 do
    self.enemyList[i].state = MobaHeroState.Battle
    self.lastJoinEnemy = i + 1
  end
end

function class:getNextHero(camp, heroIndex)
  for i = heroIndex, heroIndex + 15 do
    local ti = (heroIndex - 1) % 15 + 1
    if camp == 1 then
      if self.heroList[ti].state == MobaHeroState.Idle then
        return ti
      end
    elseif camp == -1 and self.enemyList[ti].state == MobaHeroState.Idle then
      return ti
    end
  end
end

function class:registerEvent()
  ListenEvent("MobaHeroDead", function(camp, heroId)
    if camp == 1 then
      for k, v in ipairs(self.heroList) do
        if v.heroData._tid == heroId then
          v.state = MobaHeroState.Dead
          ed.sceneui.mobaHeroIcons[k]:addShade()
          ed.sceneui.mobaHeroIcons[k].icon:setScale(0.4)
          ed.sceneui.mobaHeroIcons[k].label:setVisible(true)
        end
      end
    elseif camp == -1 then
      for k, v in ipairs(self.enemyList) do
        if v.heroData._tid == heroId then
          v.state = MobaHeroState.Dead
          ed.sceneui.mobaEnemyIcons[k]:addShade()
          ed.sceneui.mobaEnemyIcons[k].icon:setScale(0.4)
          ed.sceneui.mobaEnemyIcons[k].label:setVisible(true)
        end
      end
    end
  end)
end

function class:update(dt)
  if not ed.engine.running then
    return
  end
  for k, v in ipairs(self.heroList) do
    v:update(dt)
  end
  for k, v in ipairs(self.enemyList) do
    v:update(dt)
  end
  local engine = ed.engine
  if #engine.alive_units[ed.emCampPlayer] < 5 then
    local index = self:getNextHero(1, self.lastJoinHero)
    if index then
      local hero = self.heroList[index].heroData
      ed.engine:joinMobaHeroToBattle(ed.emCampPlayer, hero)
      ed.sceneui.mobaHeroIcons[index].icon:setScale(0.5)
      self.heroList[index].state = MobaHeroState.Battle
      self.lastJoinHero = index + 1
    end
  end
  if 5 > #engine.alive_units[ed.emCampEnemy] then
    local index = self:getNextHero(-1, self.lastJoinEnemy)
    if index then
      local hero = self.enemyList[index].heroData
      ed.engine:joinMobaHeroToBattle(ed.emCampEnemy, hero)
      ed.sceneui.mobaEnemyIcons[index].icon:setScale(0.5)
      self.enemyList[index].state = MobaHeroState.Battle
      self.lastJoinEnemy = index + 1
    end
  end
end

ed.MobaManager = class.getInstance()
local mobaHero = newclass()
ed.mobaHero = mobaHero

function mobaHero:initData(index, data, camp)
  self.rebirthTimes = 0
  self.state = MobaHeroState.Idle
  self.timeToRebrith = TimeConfig[1]
  self.heroData = data
  self.index = index
  self.camp = camp
end

function mobaHero:update(dt)
  if self.state == MobaHeroState.Dead then
    self.timeToRebrith = self.timeToRebrith - dt
    if self.camp == 1 then
      ed.sceneui.mobaHeroIcons[self.index].label:setString(math.ceil(self.timeToRebrith))
    else
      ed.sceneui.mobaEnemyIcons[self.index].label:setString(math.ceil(self.timeToRebrith))
    end
    if self.timeToRebrith <= 0 then
      self.rebirthTimes = self.rebirthTimes + 1
      self.state = MobaHeroState.Idle
      if self.camp == 1 then
        ed.sceneui.mobaHeroIcons[self.index]:removeShade()
        ed.sceneui.mobaHeroIcons[self.index].label:setVisible(false)
      else
        ed.sceneui.mobaEnemyIcons[self.index]:removeShade()
        ed.sceneui.mobaEnemyIcons[self.index].label:setVisible(false)
      end
      self.timeToRebrith = TimeConfig[self.rebirthTimes + 1]
    end
  end
end

function mobaHero.create(index, data, camp)
  local self = {}
  setmetatable(self, mobaHero.mt)
  self:initData(index, data, camp)
  return self
end

return class
