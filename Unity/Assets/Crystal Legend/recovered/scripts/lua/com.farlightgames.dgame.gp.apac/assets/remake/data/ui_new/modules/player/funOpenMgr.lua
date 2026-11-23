local funOpenMgr = {}
funOpenMgr.__index = funOpenMgr
ed.funOpenMgr = funOpenMgr

function funOpenMgr.getInstance()
  if not funOpenMgr.instance then
    funOpenMgr.instance = funOpenMgr.create()
  end
  return funOpenMgr.instance
end

function funOpenMgr.create()
  local self = {}
  setmetatable(self, funOpenMgr)
  self:init()
  return self
end

function funOpenMgr:init()
  ed.defineProperty(self, "level", ed.player:getLevel())
end

function funOpenMgr:getLevel()
  return self.level
end

local showingLv
ListenEvent("PlayerLevelUp", function(level, prelevel)
  local inBattle = ed.getCurrentScene().identity == "battle"
  if inBattle then
    return
  end
  if showingLv then
    showingLv = level
    return
  end
  local mgrIns = ed.funOpenMgr.getInstance()
  if level <= mgrIns:getLevel() then
    mgrIns:setLevel(level)
    showingLv = nil
    return
  end
  showingLv = level
  ListenTimer(Timer:Once(1), function()
    ed.ui.funOpenWindow.create(prelevel or mgrIns:getLevel(), showingLv):popWindow(900)
    mgrIns:setLevel(showingLv)
    showingLv = nil
  end)
end)

function funOpenMgr:openLevelUpWindow(level)
  local mgrIns = ed.funOpenMgr.getInstance()
  ed.ui.funOpenWindow.create(mgrIns:getLevel(), level):popWindow(900)
  mgrIns:setLevel(level)
end

ListenEvent("mainSceneEnter", function()
  ed.funOpenMgr.getInstance()
end)
