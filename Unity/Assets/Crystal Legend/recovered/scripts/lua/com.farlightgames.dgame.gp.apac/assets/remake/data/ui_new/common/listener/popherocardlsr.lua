local class = {
  mt = {}
}
class.mt.__index = class
ed.ui.popherocardlsr = class
local base = ed.ui.baselsr
setmetatable(class, base.mt)

local function create()
  local self = base.create("popherocard")
  setmetatable(self, class.mt)
  return self
end

class.create = create

local function createStonePrompt(self)
  ed.playEffect(ed.sound.tavern.createStonePrompt)
end

class.createStonePrompt = createStonePrompt

local function createGetNewHero(self)
  ed.playEffect(ed.sound.tavern.createGetNewHero)
end

class.createGetNewHero = createGetNewHero

local function showCardAnim(self)
  ed.playEffect(ed.sound.tavern.showCardAnim)
end

class.showCardAnim = showCardAnim

local function clickCardLayer(self)
  ed.playEffect(ed.sound.tavern.clickCardLayer)
end

class.clickCardLayer = clickCardLayer

local function createCardLayer(self)
  ed.playEffect(ed.sound.tavern.createCardLayer)
end

class.createCardLayer = createCardLayer

local function closeCardLayer(self)
  ed.playEffect(ed.sound.tavern.closeCardLayer)
end

class.closeCardLayer = closeCardLayer
