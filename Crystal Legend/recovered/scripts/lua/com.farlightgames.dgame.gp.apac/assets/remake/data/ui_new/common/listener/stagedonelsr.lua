local ed = ed
local class = {
  mt = {}
}
class.mt.__index = class
ed.ui.stagedonelsr = class
local base = ed.ui.baselsr
setmetatable(class, base.mt)

local function create()
  local self = base.create("stagedonelsr")
  setmetatable(self, class.mt)
  return self
end

class.create = create

local function createScene(self)
  ed.stopEffect(ed.audioParam.effects.battleResult)
  ed.playEffect(ed.sound.battle.pushResultScene)
end

class.createScene = createScene

local function pressLoot(self)
  ed.playEffect(ed.sound.stageDone.viewLoot)
end

class.pressLoot = pressLoot

local function clickLoot(self)
end

class.clickLoot = clickLoot

local function clickReply(self)
  ed.stopEffect(ed.audioParam.effects.battleResult)
  ed.playEffect(ed.sound.stageDone.replay)
end

class.clickReply = clickReply

local function clickNext(self)
  ed.stopEffect(ed.audioParam.effects.battleResult)
  ed.playEffect(ed.sound.stageDone.statistic)
end

class.clickNext = clickNext

local function showBattleCount(self)
  ed.stopEffect(ed.audioParam.effects.battleResult)
  ed.playEffect(ed.sound.stageDone.nextStage)
end

class.showBattleCount = showBattleCount

local function starAnimEnd(self)
  ed.playEffect(ed.sound.stageDone.pushStarEnd)
end

class.starAnimEnd = starAnimEnd

local function firstStarAnim(self)
  ed.playEffect(ed.sound.stageDone.pushStar1)
end

class.firstStarAnim = firstStarAnim

local function heroBarAnim(self)
  ed.playEffect(ed.sound.stageDone.heroExpGainStart)
end

class.heroBarAnim = heroBarAnim

local function heroLevelup(self)
  ed.playEffect(ed.sound.stageDone.heroLevelUp)
end

class.heroLevelup = heroLevelup

local function firstWinCupShow(self)
  ed.playEffect(ed.sound.deo.battledown_star_three)
end

class.firstWinCupShow = firstWinCupShow

local function secondWinCupShow(self)
  ed.playEffect(ed.sound.deo.battledown_star_two)
end

class.secondWinCupShow = secondWinCupShow
