local ed = ed
local class = {
  mt = {}
}
class.mt.__index = class
ed.ui.awakelsr = class
local base = ed.ui.baselsr
setmetatable(class, base.mt)

local function create()
  local self = base.create("awake")
  setmetatable(self, class.mt)
  return self
end

class.create = create

local function tryActiveHeroTask(self)
  ed.playEffect(ed.sound.awake.tryActiveHeroTask)
end

class.tryActiveHeroTask = tryActiveHeroTask

local function showHeroTask(self)
  ed.playEffect(ed.sound.awake.showHeroTask)
end

class.showHeroTask = showHeroTask

local function goHeroTask(self)
  ed.playEffect(ed.sound.awake.goHeroTask)
end

class.goHeroTask = goHeroTask

local function finishedHeroTask(self)
  ed.playEffect(ed.sound.awake.finishedHeroTask)
end

class.finishedHeroTask = finishedHeroTask

local function changeHero(self)
  ed.playEffect(ed.sound.awake.changeHero)
end

class.changeHero = changeHero

local function exitHeroTaskSystem(self)
  ed.playEffect(ed.sound.awake.exitHeroTaskSystem)
end

class.exitHeroTaskSystem = exitHeroTaskSystem

local function clickAwakeBtn(self)
  ed.playEffect(ed.sound.awake.clickAwakeBtn)
end

class.clickAwakeBtn = clickAwakeBtn

local function saveAwake(self)
  ed.playEffect(ed.sound.awake.saveAwake)
end

class.saveAwake = saveAwake

local function giveUpAwake(self)
  ed.playEffect(ed.sound.awake.giveUpAwake)
end

class.giveUpAwake = giveUpAwake

local function npcUpgraded(self)
  ed.playEffect(ed.sound.awake.npcUpgraded)
end

class.npcUpgraded = npcUpgraded

local function attrUpgraded(self)
  ed.playEffect(ed.sound.awake.attrUpgraded)
end

class.attrUpgraded = attrUpgraded

local function expIncreased(self)
  ed.playEffect(ed.sound.awake.expIncreased)
end

class.expIncreased = expIncreased

local function unlockProp(self)
  ed.playEffect(ed.sound.awake.unlockProp)
end

class.unlockProp = unlockProp

local function spCraftSuccess(self)
  ed.playEffect(ed.sound.awake.spCraftSuccess)
end

class.spCraftSuccess = spCraftSuccess

local function giveupAwakeEffect(self)
  ed.playEffect(ed.sound.awake.giveupAwakeEffect)
end

class.giveupAwakeEffect = giveupAwakeEffect

local function safeAwakeEffect(self)
  ed.playEffect(ed.sound.awake.safeAwakeEffect)
end

class.safeAwakeEffect = safeAwakeEffect

local function npcUpgradeBtn(self)
  ed.playEffect(ed.sound.awake.npcUpgradeBtn)
end

class.npcUpgradeBtn = npcUpgradeBtn
