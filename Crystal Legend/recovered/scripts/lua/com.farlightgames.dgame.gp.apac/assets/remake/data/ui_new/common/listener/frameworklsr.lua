local base = ed.ui.baselsr
local class = newclass(base.mt)
ed.ui.frameworklsr = class

local function create()
  local self = base.create("framework")
  setmetatable(self, class.mt)
  return self
end

class.create = create

local function openShortcut(self)
  ed.playEffect(ed.sound.common.popShortcut)
end

class.openShortcut = openShortcut

local function closeShortcut(self)
  ed.playEffect(ed.sound.common.pushShortcut)
end

class.closeShortcut = closeShortcut

local function clickMoney(self)
  ed.playEffect(ed.sound.main.clickMoney)
end

class.clickMoney = clickMoney

local function clickrmb(self)
  ed.playEffect(ed.sound.main.clickRecharge)
end

class.clickrmb = clickrmb

local function clickVitality(self)
  ed.playEffect(ed.sound.main.clickVitality)
end

class.clickVitality = clickVitality

local function clickHeroPackage(self)
  ed.playEffect(ed.sound.main.clickHeroPackage)
end

class.clickHeroPackage = clickHeroPackage

local function clickPackage(self)
  ed.playEffect(ed.sound.main.clickPackage)
end

class.clickPackage = clickPackage

local function clickSummon(self)
  ed.playEffect(ed.sound.main.clickTarvern)
end

class.clickSummon = clickSummon

local function clickFragment(self)
  ed.playEffect(ed.sound.main.clickFragment)
end

class.clickFragment = clickFragment

local function clickTask(self)
  ed.playEffect(ed.sound.main.clickTask)
end

class.clickTask = clickTask

local function clickRecharge(self)
  ed.playEffect(ed.sound.main.clickRecharge)
end

class.clickRecharge = clickRecharge

local function clickSignIn()
  ed.playEffect(ed.sound.main.clickSignIn)
end

class.clickSignIn = clickSignIn

local function clickActivity()
  ed.playEffect(ed.sound.main.clickActivity)
end

class.clickActivity = clickActivity

local function clickActivityAdventure()
  ed.playEffect(ed.sound.main.clickActivityAdventure)
end

class.clickActivityAdventure = clickActivityAdventure

local function clickMail()
  ed.playEffect(ed.sound.main.clickMail)
end

class.clickMail = clickMail

local function clickFriend()
  ed.playEffect(ed.sound.main.clickFriend)
end

class.clickFriend = clickFriend

local function clickBack(self)
  ed.playEffect(ed.sound.common.back)
end

class.clickBack = clickBack
