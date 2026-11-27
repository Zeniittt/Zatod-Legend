local ed = ed
local class = {
  mt = {}
}
class.mt.__index = class
ed.ui.battlepreparealternationlsr = class
local base = ed.ui.baselsr
setmetatable(class, base.mt)

local function create()
  local self = base.create("localbattleprepare")
  setmetatable(self, class.mt)
  return self
end

class.create = create

local function refreshHeroList(self, param)
end

class.refreshHeroList = refreshHeroList

local function exitScene(self)
end

class.exitScene = exitScene

local function clickgo(self)
  ed.playEffect(ed.sound.prepare.clickGo)
end

class.clickgo = clickgo

local function clickAddHeroTeamFilled(self)
  ed.playEffect(ed.sound.prepare.heroFilled)
end

class.clickAddHeroTeamFilled = clickAddHeroTeamFilled

local function clickAddHero(self, param)
  local getUnitVoiceReady = ed.getUnitVoiceReady or function(tid)
    local tb = ed.getDataTable("Unit")
    return ed.recoverColum(tb[tid]["Voice Ready"])
  end
  local hid = param.hid
  local fashion_id = param.fashion_id
  local effect
  if fashion_id then
    local row = ed.getDataTable("Fashion")[fashion_id]
    effect = row["Voice Ready"]
  else
    effect = getUnitVoiceReady(hid)
  end
  if effect then
    ed.playEffect(effect)
  else
    ed.playEffect(ed.sound.prepare.selectHero)
  end
end

class.clickAddHero = clickAddHero

local function clickTeamRemoveHero(self)
  ed.playEffect(ed.sound.prepare.clickDeleteHero)
end

class.clickTeamRemoveHero = clickTeamRemoveHero

local function clickHeadRemoveHero(self)
  ed.playEffect(ed.sound.prepare.disSelectHero)
end

class.clickHeadRemoveHero = clickHeadRemoveHero

local function clickBack(self)
  ed.playEffect(ed.sound.common.back)
end

class.clickBack = clickBack

local function clickChangeList(self)
  ed.playEffect(ed.sound.prepare.clickFilter)
end

class.clickChangeList = clickChangeList
