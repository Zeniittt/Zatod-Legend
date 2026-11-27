local class = {}
class.__index = class
ed.dragonBoatBoatMgr = class

function class.create(params)
  local self = {}
  setmetatable(self, class)
  self:init(params)
  return self
end

function class:init(params)
  self.params = params
  self.container = params.container
  self.sceneSelf = params.sceneSelf
  self.mgr = ed.dragonBoatMgr.getInstance()
  self.speedUpBGScope = {}
  self.yPositions = {}
  local winSize = ed.display.winSize
  self.area3 = {
    r = 250,
    l = 230,
    b = 150,
    t = 310
  }
  self.area2 = {
    r = winSize.width * 0.5 + 15,
    l = winSize.width * 0.5 + 15,
    b = 200,
    t = 200
  }
  self.area1 = {
    r = winSize.width - 130 - ed.display.halfFixedWidth * 0.6,
    l = winSize.width - 200 - ed.display.halfFixedWidth * 0.6,
    b = 150,
    t = 310
  }
end

function class:getRandomPointInArea(rank, oriPos)
  if rank == 2 and oriPos then
    return oriPos
  end
  local area = self["area" .. rank]
  local ret
  if rank == 2 or oriPos then
    ret = ccp(math.random(area.l, area.r), oriPos and oriPos.y or math.random(area.b, area.t))
  else
    local selfY = self.area2.t
    local yrandom = math.random(0, 100)
    if rank < 2 then
      local coeff = yrandom / 100
      yrandom = (selfY + 30) * coeff + area.t * (1 - coeff)
    elseif 2 < rank then
      local coeff = yrandom / 100
      yrandom = area.b * coeff + (selfY - 30) * (1 - coeff)
    end
    ret = ccp(math.random(area.l, area.r), yrandom)
  end
  return ret
end

function class:addBoat(params)
  local rank = params.rank
  local targetPos = self:getRandomPointInArea(rank)
  local oriPos = ccp(targetPos.x, targetPos.y)
  if not params.inScreen then
    if rank == 1 then
      oriPos.x = ed.display.winSize.width + 300
    elseif rank == 3 then
      oriPos.x = -200
    end
  end
  local starRank = self.mgr.topRank and rank or self.mgr.starRank + (rank - 2)
  local boat = ed.dragonBoatClass.create({
    container = self.container,
    skin = params.skin,
    mgr = self,
    oriPos = oriPos,
    rank = rank,
    userInfo = params.userInfo,
    starRank = starRank,
    stayInScreen = not params.inScreen,
    feet = params.feet,
    sceneSelf = self.sceneSelf,
    notFade = params.notFade
  })
  boat:boating(targetPos, self.hasAccelerate and self.accelerateTime or nil)
  return boat
end

function class:setBoatRank(boat, params)
  local newRank = params.rank
  local newSkin = params.skin
  local random = params.random
  if newSkin then
    boat:setSkin(newSkin)
  end
  boat:setStarRank(self.mgr.starRank + (newRank - 2))
  if newRank <= 3 and 1 <= newRank and (random or boat.rank ~= newRank) then
    boat.rank = newRank
    local targetPos = self:getRandomPointInArea(newRank, boat.oriPos)
    boat:boating(targetPos, self.hasAccelerate and self.accelerateTime or nil)
  elseif 3 < newRank then
    boat.rank = newRank
    local targetPos = ccp(-500, boat.oriPos.y)
    boat:boating(targetPos, self.hasAccelerate and self.accelerateTime or nil, true)
  elseif newRank < 1 then
    boat.rank = newRank
    local targetPos = ccp(ed.display.winSize.width + 500, boat.oriPos.y)
    boat:boating(targetPos, self.hasAccelerate and self.accelerateTime or nil, true)
  end
end

function class:refreshRace(notFade, time)
  self.accelerateTime = time or 1.5
  if self.boats == nil then
    if self.mgr.openMovie then
      self:initOnceBoats()
    else
      self:initBoats(notFade)
    end
    self.mgr.lastFrontInfo = self.mgr.frontInfo
    self.mgr.lastBehindInfo = self.mgr.behindInfo
    return
  end
  local oldBoats = self.boats
  self.boats = {}
  local flag = {
    false,
    true,
    false
  }
  local mgr = ed.dragonBoatMgr.getInstance()
  self.hasAccelerate = nil
  self.bgAccelerate = nil
  self.hasAccelerate = self:checkAccelerate(mgr)
  if self.hasAccelerate and ed.isElementInTable(ed.getRoleId(), self.accelerateList) then
    print("Has Accelerate !!!!!!!")
    self.bgAccelerate = true
    CloseScope(self.speedUpBGScope)
    mgr:setBGSpeed(5 * mgr.normalBgSpeed)
    ListenTimer(Timer:Once(self.accelerateTime), function()
      self.selfBoat:stopCallBack()
      mgr:resetBGSpeed()
    end, self.speedUpBGScope)
  end
  local selfAccelerate = ed.isElementInTable(ed.getRoleId(), self.accelerateList)
  local oldFrontUserId = mgr.lastFrontInfo and mgr.lastFrontInfo._user_summary._role_id or nil
  local oldBehindUserId = mgr.lastBehindInfo and mgr.lastBehindInfo._user_summary._role_id or nil
  if mgr.frontInfo then
    local info = mgr.frontInfo
    local userInfo = info._user_summary
    local roleId = info._user_summary._role_id
    if (roleId == oldFrontUserId or roleId == oldBehindUserId) and oldBoats[roleId] then
      self.boats[roleId] = oldBoats[roleId]
      oldBoats[roleId] = nil
      local random = ed.isElementInTable(roleId, self.accelerateList) or selfAccelerate
      self:setBoatRank(self.boats[roleId], {
        rank = 1,
        skin = info._skin,
        random = random
      })
    else
      self.boats[roleId] = self:addBoat({
        rank = 1,
        skin = info._skin,
        userInfo = userInfo,
        feet = info._feet
      })
    end
    if self.hasAccelerate then
      if ed.isElementInTable(roleId, self.accelerateList) then
        if self.bgAccelerate then
          self.boats[roleId]:accelerate(4)
        else
          self.boats[roleId]:accelerate(2)
        end
      elseif self.bgAccelerate then
        self.boats[roleId]:accelerate(3)
      end
    end
    self.boats[roleId]:refreshUI(info)
  end
  if mgr.behindInfo then
    local info = mgr.behindInfo
    local roleId = info._user_summary._role_id
    local userInfo = info._user_summary
    if (roleId == oldFrontUserId or roleId == oldBehindUserId) and oldBoats[roleId] then
      self.boats[roleId] = oldBoats[roleId]
      oldBoats[roleId] = nil
      local random = ed.isElementInTable(roleId, self.accelerateList) or selfAccelerate
      self:setBoatRank(self.boats[roleId], {
        rank = 3,
        skin = info._skin,
        random = random
      })
    else
      self.boats[roleId] = self:addBoat({
        rank = 3,
        skin = info._skin,
        userInfo = userInfo,
        feet = info._feet
      })
    end
    if self.hasAccelerate then
      if ed.isElementInTable(roleId, self.accelerateList) then
        if self.bgAccelerate then
          self.boats[roleId]:accelerate(4)
        else
          self.boats[roleId]:accelerate(2)
        end
      elseif self.bgAccelerate then
        self.boats[roleId]:accelerate(3)
      end
    end
    self.boats[roleId]:refreshUI(info)
  end
  if mgr.raceInfo and self.selfBoat then
    local roleId = ed.getRoleId()
    local info = mgr.raceInfo
    local userInfo = info._user_summary
    self:setBoatRank(self.selfBoat, {
      rank = 2,
      skin = info._skin
    })
    if self.bgAccelerate then
      self.selfBoat:accelerate(1)
    end
    self.selfBoat:refreshUI(info)
  end
  self.oldBoats = oldBoats or {}
  if oldBoats[oldFrontUserId] then
    local boat = oldBoats[oldFrontUserId]
    local feet = mgr.lastFrontInfo._feet
    local curRank = 4
    if mgr.frontInfo then
      curRank = feet > mgr.frontInfo._feet and 0 or 4
    end
    local random = ed.isElementInTable(oldFrontUserId, self.accelerateList) or selfAccelerate
    self:setBoatRank(boat, {
      rank = curRank,
      skin = mgr.lastFrontInfo._skin,
      random = random
    })
    if self.hasAccelerate then
      if ed.isElementInTable(oldFrontUserId, self.accelerateList) then
        if self.bgAccelerate then
          boat:accelerate(4)
        else
          boat:accelerate(2)
        end
      elseif self.bgAccelerate then
        boat:accelerate(3)
      end
    end
    boat:refreshUI(mgr.lastFrontInfo)
  end
  if oldBoats[oldBehindUserId] then
    local boat = oldBoats[oldBehindUserId]
    local feet = mgr.lastBehindInfo._feet
    local curRank = 0
    if mgr.behindInfo then
      curRank = feet > mgr.behindInfo._feet and 0 or 4
    end
    local random = ed.isElementInTable(oldBehindUserId, self.accelerateList) or selfAccelerate
    self:setBoatRank(boat, {
      rank = curRank,
      skin = mgr.lastBehindInfo._skin,
      random = random
    })
    if self.hasAccelerate then
      if ed.isElementInTable(oldBehindUserId, self.accelerateList) then
        if self.bgAccelerate then
          boat:accelerate(4)
        else
          boat:accelerate(2)
        end
      elseif self.bgAccelerate then
        boat:accelerate(3)
      end
    end
    boat:refreshUI(mgr.lastBehindInfo)
  end
  self.mgr.lastFrontInfo = self.mgr.frontInfo
  self.mgr.lastBehindInfo = self.mgr.behindInfo
end

function class:checkAccelerate(mgr)
  local checkList = {
    mgr.lastFrontInfo,
    mgr.lastBehindInfo,
    mgr.frontInfo,
    mgr.behindInfo
  }
  local ret = false
  self.accelerateList = {}
  for _, info in pairs(checkList) do
    if info._use_time and info._use_time > ed.getServerTime() * 1000 - 5000 then
      print(info._use_time)
      print(os.clock())
      print(ed.getServerTime() - 5)
      table.insert(self.accelerateList, info._user_summary._role_id)
      ret = true
    end
  end
  if mgr.raceInfo then
    local info = mgr.raceInfo
    if info._give_num and info._give_num > 0 then
      table.insert(self.accelerateList, info._user_summary._role_id)
      ret = true
    elseif self.selfAccelerate then
      self.selfAccelerate = nil
      table.insert(self.accelerateList, info._user_summary._role_id)
      ret = true
    end
  end
  return ret
end

function class:doUpgrade(skin)
  self:refreshSelf()
end

function class:initOnceBoats()
  if not self.mgr.topRank then
    return self:initBoats()
  end
  local rank = self.mgr.topRank
  if self.onceBoats then
    self:destroyOnceBoats()
  end
  self.onceBoats = {}
  if rank[2] then
    table.insert(self.onceBoats, self:addBoat({
      rank = 2,
      inScreen = true,
      userInfo = rank[2]._user_summary,
      feet = rank[2]._param1,
      skin = rank[2]._param3 or 1
    }))
  end
  if rank[1] then
    table.insert(self.onceBoats, self:addBoat({
      rank = 1,
      inScreen = true,
      userInfo = rank[1]._user_summary,
      feet = rank[1]._param1,
      skin = rank[1]._param3 or 1
    }))
  end
  if rank[3] then
    table.insert(self.onceBoats, self:addBoat({
      rank = 3,
      inScreen = true,
      userInfo = rank[3]._user_summary,
      feet = rank[3]._param1,
      skin = rank[3]._param3 or 1
    }))
  end
  self.mgr.topRank = nil
end

function class:destroyBoats()
  if self.selfBoat then
    self.selfBoat:destroy()
  end
  for k, v in pairs(self.boats or {}) do
    v:destroy()
  end
  for k, v in pairs(self.oldBoats or {}) do
    if v and not tolua.isnull(v.spine) then
      v:destroy()
    end
  end
  CloseScope(self.speedUpBGScope)
  ed.dragonBoatMgr.getInstance():resetBGSpeed()
  self.boats = nil
end

function class:destroyOnceBoats()
  for k, v in pairs(self.onceBoats or {}) do
    v:destroy()
  end
  self.onceBoats = nil
end

function class:initBoats(notFade)
  self.selfBoat = self:addBoat({
    rank = 2,
    skin = self.mgr.skin,
    inScreen = true,
    userInfo = self.mgr.raceInfo._user_summary,
    feet = self.mgr.raceInfo._feet,
    notFade = notFade
  })
  self.boats = {}
  if self.mgr.frontInfo then
    local info = self.mgr.frontInfo
    local roleId = info._user_summary._role_id
    local name = info._user_summary._name
    self.boats[roleId] = self:addBoat({
      rank = 1,
      skin = info._skin,
      inScreen = true,
      userInfo = info._user_summary,
      feet = info._feet,
      notFade = notFade
    })
    if ed.isElementInTable(roleId, self.accelerateList) then
      self.boats[roleId]:accelerate()
    end
  end
  if self.mgr.behindInfo then
    local info = self.mgr.behindInfo
    local roleId = info._user_summary._role_id
    local name = info._user_summary._name
    self.boats[roleId] = self:addBoat({
      rank = 3,
      skin = info._skin,
      inScreen = true,
      userInfo = info._user_summary,
      feet = info._feet,
      notFade = notFade
    })
    if ed.isElementInTable(roleId, self.accelerateList) then
      self.boats[roleId]:accelerate()
    end
  end
end

function class:refreshSelf()
  self:setBoatRank(self.selfBoat, {
    rank = 2,
    skin = self.mgr.skin
  })
end
