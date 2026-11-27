local ed = ed
local class = {
  mt = {}
}
class.mt.__index = class
ed.ui.heropackagelsr = class
local base = ed.ui.baselsr
setmetatable(class, base.mt)

local function create()
  local self = base.create("heropackage")
  setmetatable(self, class.mt)
  return self
end

class.create = create

local function clickListButton(self)
  ed.playEffect(ed.sound.heroPackage.changeList)
end

class.clickListButton = clickListButton

local function clickHeroOwned(self)
  ed.playEffect(ed.sound.heroPackage.clickHero)
end

class.clickHeroOwned = clickHeroOwned

local function summonSuccess(self)
  ed.playEffect(ed.sound.heroPackage.summonHero)
end

class.summonSuccess = summonSuccess

local function summonFailed(self)
  ed.showToast(T("\229\143\172\229\148\164\232\139\177\233\155\132\229\164\177\232\180\165"))
end

class.summonFailed = summonFailed
