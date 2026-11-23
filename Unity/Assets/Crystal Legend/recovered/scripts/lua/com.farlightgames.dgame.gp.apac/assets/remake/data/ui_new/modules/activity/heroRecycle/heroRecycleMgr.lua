local class = newclass("g")
ed.HeroRecycleMgr = class
class.instance = nil

function class.getInstance()
  if not ed.HeroRecycleMgr.instance then
    ed.HeroRecycleMgr.instance = ed.HeroRecycleMgr.create()
  end
  return ed.HeroRecycleMgr.instance
end

function class.create()
  local self = setmetatable({}, {__index = class})
  self:init()
  return self
end

function class:init()
  self:addEventListen()
end

function class:setOpenViewTag(actId, red)
  ed.storage.setValue(ed.getRoleKey("HeroRecycleViewOpen_" .. actId), red)
  ed.activityHints:updateReds({_act_id = actId})
  FireEvent("MainRedTagChange", ed.ui.configs.mainButton.ButtonType.ACTIVITY)
end

function class:getRed(actId)
  local isOpenView = ed.storage.getBool(ed.getRoleKey("HeroRecycleViewOpen_" .. actId))
  if isOpenView then
    return false
  end
  return true
end

function class:handleCheck(_check)
  FireEvent("HeroRecycleCheck", _check)
end

function class:handlePreview(_preview)
  FireEvent("HeroRecyclePreview", _preview)
end

function class:handleActHeroRecycle(_hero_recycle)
  local activityId = _hero_recycle._act_id
  local task = _hero_recycle._task
  local rewards = _hero_recycle._rewards or {}
  local hero = _hero_recycle._hero
  ed.player:resetHero(hero)
  ed.ui.SummonRewardCardWindow.create({
    title = T("\228\189\160\231\154\132\232\139\177\233\155\132\229\183\178\232\142\183\229\190\151\230\150\176\231\148\159"),
    rewards = {
      {
        id = hero._tid,
        amount = 1,
        type = "hero"
      }
    },
    noRewards = true
  }):popWindow()
  ed.heroDetailManager:setAstrolabeUnlockStatus(hero._tid, 0)
  FireEvent("HeroRecycleTask", task)
end

function class:addEventListen()
  ListenEvent("scope_activity_reply", function(info)
    if info._hero_recycle then
      self:handleActHeroRecycle(info._hero_recycle)
    end
  end)
end
