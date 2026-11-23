local ed = ed
local class = {
  mt = {}
}
class.mt.__index = class
ed.ui.mainlsr = class
local base = ed.ui.baselsr
setmetatable(class, base.mt)

local function create()
  local self = base.create("main")
  setmetatable(self, class.mt)
  return self
end

class.create = create

local function enterScene(self, param)
  ed.playMusic(ed.music.map)
  self:teachOpenModule()
end

class.enterScene = enterScene

local function exitScene(self, param)
  self.refresh_dailyjob_callback = nil
end

class.exitScene = exitScene

local function clickcot(self)
  ed.playEffect(ed.sound.main.clickcot)
end

class.clickcot = clickcot

local function clickpve(self)
  ed.playEffect(ed.sound.main.clickPVE)
end

class.clickpve = clickpve

local function clickpvp(self)
  ed.playEffect(ed.sound.main.clickPVP)
end

class.clickpvp = clickpvp

local function clickshop(self)
  ed.playEffect(ed.sound.main.clickShop)
end

class.clickshop = clickshop

local function clicksshop(self)
  ed.playEffect(ed.sound.main.clickSpecialShop)
end

class.clicksshop = clicksshop

local function clickssshop(self)
  ed.playEffect(ed.sound.main.clickSoSpecialShop)
end

class.clickssshop = clickssshop

local function clickstarshop(self)
  ed.playEffect(ed.sound.main.clickStarShop)
end

class.clickstarshop = clickstarshop

local function clickancients(self)
  ed.playEffect(ed.sound.main.clickAncients)
end

class.clickancients = clickancients

local function clickfashion(self)
  ed.playEffect(ed.sound.main.clickFashion)
end

class.clickancients = clickancients

local function clickthronetower(self)
  ed.playEffect(ed.sound.main.clickThroneTower)
end

class.clickthronetower = clickthronetower

local function clickhandbook(self)
  ed.playEffect(ed.sound.main.clickHandbook)
end

class.clickhandbook = clickhandbook

local function clickestren(self)
  ed.playEffect(ed.sound.main.clickEstrenUpgrade)
end

class.clickestren = clickestren

local function clicktavern(self)
  ed.playEffect(ed.sound.main.clickTarvern)
end

class.clicktavern = clicktavern

local function clickexercise(self)
  ed.playEffect(ed.sound.main.clickexercise)
end

class.clickexercise = clickexercise

local function clickheroawake(self)
  ed.playEffect(ed.sound.main.clickheroawake)
end

class.clickheroawake = clickheroawake

local function clicktoppvp(self)
  ed.playEffect(ed.sound.main.clicktoppvp)
end

class.clickheroawake = clicktoppvp

local function clickMailbox(self)
  ed.playEffect(ed.sound.main.clickMailbox)
end

class.clickMailbox = clickMailbox

local function clickgm(self)
  ed.playEffect(ed.sound.main.clickGM)
end

class.clickgm = clickgm

local function clickMainButton(self, param)
  local key = param.key
  local keys = {
    shop = {t = "openShop", k = "shop"},
    pvp = {t = "openpvp", k = "PVP"},
    estren = {
      t = "openEnhance",
      k = "Enhance"
    },
    exercise = {
      t = "openExercise",
      k = "Exercise"
    },
    spring = {t = "openSpring", k = "Spring"},
    babel = {t = "openBabel", k = "Babel"},
    multiplaying = {
      t = "openRealArena",
      k = "RealArena"
    },
    WarBuilding = {
      t = "openWarTerritory",
      k = "WarBuilding"
    },
    LegendArena = {
      t = "openLegendArena",
      k = "LegendArena"
    }
  }
  local d = keys[key]
  if not d then
    return
  end
end

class.clickMainButton = clickMainButton

local function teachOpenModule(self)
  local scene = ed.getCurrentScene() or {}
  if scene.identity ~= "main" then
    return
  end
  local res = ed.ui.mainres
  local topContainer = scene.topContainer
  local middleContainer = scene.middleContainer
  local mainLayer = scene.mainLayer
  local keys = {
    PVP = {t = "openpvp", k = "pvp"},
    Enhance = {
      t = "openEnhance",
      k = "estren"
    },
    Exercise = {
      t = "openExercise",
      k = "exercise"
    },
    Awake = {t = "openAwake", k = "estren"},
    Spring = {t = "openSpring", k = "spring"},
    TopPvp = {t = "openTopPvp", k = "toppvp"},
    Crusade = {
      t = "openCrusade",
      k = "volcano"
    }
  }
  self:openSpecialMailbox()
  local res = ed.ui.mainres
  local topContainer = scene.topContainer
  local scene = ed.getCurrentScene() or {}
  if scene.identity ~= "main" then
    return
  end
  local mainLayer = scene.mainLayer
  local r = res.res_pos.mailbox
  local node = scene.tavernFca
end

class.teachOpenModule = teachOpenModule

function class:openSpecialMailbox()
  local needSync = ed.player:checkSyncMailData()
  local scene = ed.getCurrentScene() or {}
  if scene.identity ~= "main" then
    return
  end
  if needSync then
    function ed.netreply.getMail()
      xpcall(function()
        if ed.player:checkSpecialMail(ed.player:getMailData()) then
          local res = ed.ui.mainres
          
          local topContainer = scene.topContainer
          local mainLayer = scene.mainLayer
          local r = res.res_pos.mailbox
        end
      end, EDDebug)
    end
    
    if ed.canTeach("openSpecialMailbox") then
      local msg = ed.upmsg.get_maillist()
      ed.send(msg, "get_maillist")
    end
    return
  end
end

function class:openArtifactTeach()
  local scene = ed.getCurrentScene() or {}
  if scene.identity ~= "main" then
    return
  end
  local res = ed.ui.mainres
  local topContainer = scene.topContainer
  local mainLayer = scene.mainLayer
  local r = res.res_pos.spring
end
