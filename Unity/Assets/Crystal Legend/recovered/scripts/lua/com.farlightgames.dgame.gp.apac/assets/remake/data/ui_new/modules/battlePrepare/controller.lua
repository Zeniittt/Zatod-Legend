module("ed.battleprepare", package.seeall)
Controller = {}
Controller.__index = Controller

function Controller:create(param)
  local obj = {}
  setmetatable(obj, self)
  obj:init(param)
  return obj
end

function Controller:release()
  self.model:release()
  self.modle = nil
end

function Controller:init(param)
  self.param = param
  self.model = Model:create(param)
  self.canEnterBattle = true
  self:registerEventHandler()
end

function Controller:getModel()
  return self.model
end

function Controller:removeMember(hid)
  local index
  if self.removeHandler then
    index = self:removeHandler()
  else
    index = self.model:removeMember(hid)
  end
  return index
end

function Controller:addMember(hid)
  local index
  if self.addMemberHandler then
    ed.asyncload.preloadFcaByUnitID(hid)
    index = self:addMemberHandler(hid)
  else
    ed.asyncload.preloadFcaByUnitID(hid)
    index = self.model:addMember(hid)
  end
  return index
end

function Controller:removeMercenary(hid)
  local hero = self.mercenaryMode:getHero(hid)
  local index = self.model:removeMercenary(hero)
  return index
end

function Controller:addMercenary(hid)
  local hero = self.mercenaryMode:getHero(hid)
  ed.printTable(hero)
  ed.asyncload.preloadFcaByUnitID(hero._tid)
  local index = self.model:addMercenary(hero)
  return index
end

function Controller:clickHeroWithId(hid)
  if self.model:isRepet(hid) then
    return "repet"
  elseif self.model:teamWithHero(hid) then
    if self.model:isMustHero(hid) then
      return "mustadd"
    else
      return "remove"
    end
  elseif self.model:isFull() then
    return "full"
  elseif self.model:isForbid(hid) then
    return "forbid"
  elseif self.model:isFirst(hid) then
    return "first"
  elseif self.model:isDead(hid) then
    return "dead"
  elseif self.model:isDispatch(hid) then
    return "dispatch"
  elseif self.model:isNotOwn(hid) then
    return "own"
  else
    return "add"
  end
end

function Controller:clickMercenaryWithId(hid)
  local hero = self.mercenaryMode:getHero(hid)
  if self.model:mercenaryIsRepet(hero._tid) then
    return "repet"
  elseif self.model:teamWithHero(hero._tid) then
    return "remove"
  elseif self.model:isFull() then
    return "full"
  elseif self.model:isMercenary() then
    return "mercenary"
  elseif self.model:mercenaryIsDispatch(hid) then
    return "dispatch"
  elseif self.mercenaryMode:isDead(hid) then
    return "dead"
  elseif self.mercenaryMode:isHired(hid) then
    return "isHired"
  elseif self.mercenaryMode:isLevelLimit(hid) then
    return "levelLimit"
  else
    return "add"
  end
end

function Controller:Return()
  if self.returnHandler then
    self:returnHandler()
  else
    self:release()
  end
  SendEvent("returnCallBack")
end

function Controller:setReturnHandler(handler)
  self.returnHandler = handler
end

function Controller:setReturnCallBack(handler)
  WaitEvent("returnCallBack", function(hid)
    handler()
  end)
end

function Controller:setRemoveMemberHandler(handler)
  self.removeHandler = handler
end

function Controller:setRemoveMemberCallBack(handler)
  WaitEvent("removeMemverCallBack", function(hid)
    handler(hid)
  end)
end

function Controller:setEnterBattleHandler(handler)
  self.enterBattleHandler = handler
end

function Controller:registerEventHandler()
  WaitEvent("enterBattle", function()
    self:doEnterBattle()
  end)
end

function Controller:doEnterBattle()
  self:enterBattle()
end

function Controller:enterBattle()
  if self.enterBattleHandler then
    self.enterBattleHandler()
  else
    print("u must set a enter battle handler")
  end
end

function Controller:doHireMercenarySuccessReply()
  self:enterBattle()
end

function Controller:setEnterBattleCallBack(handler)
end

function Controller:setAddMemberAffirmHandler(handler)
  self.addMemberAffirm = handler
end

function Controller:setAddMemberHandler(handler)
  self.addMemberHandler = handler
end

function Controller:setAddMemberCallBack(handler)
  WaitEvent("addMemberCallBack", function(hid)
    handler(hid)
  end)
end

function Controller:setOnEnterCallBack(handler)
  WaitEvent("onEnter", function()
    return handler and handler()
  end)
end

function Controller:setOnEixtCallBack(handler)
  WaitEvent("onExit", function()
    return handler and handler()
  end)
end

function Controller:setChangeChannelCallBack(handler)
  WaitEvent("changeChannel", function(channel)
    return handler and handler(channel)
  end)
end

function Controller:getCanEnterBattle()
  return self.canEnterBattle
end

function Controller:setCanEnterBattle(value)
  self.canEnterBattle = value
end

function Controller:initMercenaryMode(data)
  self.mercenaryMode = mercenaryMode.create(self.param, data)
end
