local class = newclass("g")
ed.ui.baselsr = class
ed.listener = ed.listener or {}
ed.listener.base = class
local show_report_desc = false

local function create(identity)
  local self = {}
  setmetatable(self, class.mt)
  self.identity = identity
  return self
end

class.create = create

local function report(self, key, param)
  if show_report_desc then
    print("Scene: ", self.identity, " report: ", key)
  end
  if self[key] then
    self[key](self, param)
  end
end

class.report = report
local happen_player_levelup

local function happenPlayerLevelup(self)
  happen_player_levelup = true
end

class.happenPlayerLevelup = happenPlayerLevelup

local function playerLevelup(self)
  if not happen_player_levelup then
    return
  end
  local unlock = {
    SkillUpgrade = "unlockSkillUpgrade",
    Elite = "unlockEliteMode",
    PVP = "unlockpvp",
    Midas = "unlockMidas",
    Enhance = "unlockEnhance",
    Exercise = "unlockExercise",
    Crusade = "unlockCrusade",
    Guild = "unlockGuild",
    WorldChannel = "unlockWorldChannel",
    Spring = "unlockSpring",
    Babel = "unlockBabel",
    ActivitySweep = "unlockActivitySweep",
    RealArena = "unlockRealArena",
    WarBuilding = "unlockWarTerritory",
    RankFastUpgrade = "unlockRankFastUpgrade",
    LegendArena = "unlockLegendArena"
  }
  happen_player_levelup = nil
end

class.playerLevelup = playerLevelup

function class.playerBabelLevelup()
  local level = ed.player:getBabelLevel()
end

local function vipLevelup(self, param)
  param = param or {}
  local previp = param.previp
  ed.announce({
    type = "vipPrivilege",
    param = {previp = previp}
  })
end

class.vipLevelup = vipLevelup
local level_up_hero_list = {}

local function heroLevelup(self, param)
  if not param then
    return
  end
  local hid = param.hid
  table.insert(level_up_hero_list, hid)
  ed.registerGameUpdateHandler("queryHeroes", self:queryHeroesHandler())
end

class.heroLevelup = heroLevelup

local function queryHeroesHandler(self)
  local count = 2
  
  local function handler(dt)
    count = count - dt
    if count < 0 then
      local msg = ed.upmsg.recharge_polling()
      local sync = ed.upmsg.recharge_sync()
      sync._types = {"hero"}
      sync._hero_ids = level_up_hero_list
      msg._sync = sync
      ed.send(msg, "recharge_polling")
      level_up_hero_list = {}
      ed.removeGameUpdateHandler("queryHeroes")
    end
  end
  
  return handler
end

class.queryHeroesHandler = queryHeroesHandler

local function increaseDailyjobCount(self)
  local scene = ed.getCurrentScene()
  if not scene then
    return
  end
  if scene.identity == "main" and scene.checkShortcutButtonTag then
    scene:checkShortcutButtonTag()
  end
end

class.increaseDailyjobCount = increaseDailyjobCount

local function closeMidasWindow(self)
  local scene = ed.getCurrentScene()
  if scene.identity == "shop" then
    scene:refreshCostLabel()
  end
end

class.closeMidasWindow = closeMidasWindow

local function useMidas(self)
  local scene = ed.getCurrentScene()
  if scene.identity == "shop" then
    scene:refreshCostLabel()
  end
end

class.useMidas = useMidas

local function closeRechargeWindow(self)
  local scene = ed.getCurrentScene()
  if scene.identity == "equipStrengthen" then
    scene:refreshFastStrenButton()
  end
  if scene.identity == "main" then
    scene:sbRefreshDailyloginTag()
  end
  if scene.identity == "tavern" then
    scene:refreshItemLayer()
  end
  if ed.isElementInTable(scene.identity, {
    "stageDetailGWMode",
    "stageDetail"
  }) and scene.refreshSweepContainer then
    scene:refreshSweepContainer()
  end
  local midasWindow = ed.getPopWindow("midas")
  if midasWindow then
    midasWindow:refreshMultiUseButton()
  end
end

class.closeRechargeWindow = closeRechargeWindow

local function receiveMail(self)
  local scene = ed.getCurrentScene()
  if scene.identity == "main" then
    scene:refreshMailbox()
  end
end

class.receiveMail = receiveMail

local function sellProp(self, result, amount)
  local scene = ed.getCurrentScene()
  if ed.isElementInTable(scene.identity, {"package", "fragment"}) then
    scene:downSell(result, amount)
  end
end

class.sellProp = sellProp

local function resolveProp(self, result, amount)
  local scene = ed.getCurrentScene()
  if ed.isElementInTable(scene.identity, {"package", "fragment"}) then
    scene:downResolve(result, amount)
  end
end

class.resolveProp = resolveProp
