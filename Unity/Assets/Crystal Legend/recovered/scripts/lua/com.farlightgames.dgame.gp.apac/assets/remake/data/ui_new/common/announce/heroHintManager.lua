local HeroHintMgr = {}
ed.heroHintManager = HeroHintMgr
HeroHintMgr.__index = HeroHintMgr

function HeroHintMgr.create(scene)
  local object = {}
  setmetatable(object, HeroHintMgr)
  object:initConfig()
  object:initData(scene)
  return object
end

function HeroHintMgr:closeEvents()
  CloseScope(self.heroHintMgrScope)
end

function HeroHintMgr:reset(scene)
  self.mainScene = scene
  self.heroHintTable = {}
  self:update()
end

function HeroHintMgr:initData(scene)
  self.mainScene = scene
  self.heroHintTable = {}
  self.incd = false
  self.globelcd = 180
  self.heroHintMgrScope = {}
  self.heroTaskTable = ed.getDataTable("OfflineQuestInHeroTalk")
end

function HeroHintMgr:initConfig()
  self.config = {
    excavate = {
      heroStates = {"Excavate"},
      position = ccp(1120, 150),
      showRect = CCRectMake(0, 0, 400, 480),
      showtime = 10
    },
    pve = {
      heroStates = {"Elite", "Challenge"},
      position = ccp(1761, 203),
      showRect = CCRectMake(0, 0, 400, 480),
      showtime = 10
    },
    spring = {
      heroStates = {"Spring"},
      position = ccp(1390, 105),
      showRect = CCRectMake(0, 0, 400, 480),
      showtime = 10
    },
    warmake = {
      heroStates = {"School"},
      position = ccp(440, 245),
      showRect = CCRectMake(0, 0, 400, 480),
      showtime = 10
    }
  }
end

function HeroHintMgr:update()
  if self.incd then
    return
  end
  local fcas = self.mainScene.mainFcas
  local types = {}
  if fcas then
    for type, config in pairs(self.config) do
      local node = fcas[type]
      local rect = config.showRect
      if self:isInRect(node, rect) then
        table.insert(types, type)
      end
    end
  end
  local type = self:randomInArray(types)
  if type then
    self:showHeroHint(type)
  end
end

function HeroHintMgr:isInRect(node, rect)
  if not node or not rect then
    return false
  end
  local worldPos = self:getNodeWorldSpace(node)
  local inRect = ed.isPointInRect(rect, worldPos.x, worldPos.y)
  return inRect
end

function HeroHintMgr:getNodeWorldSpace(node)
  if not node then
    return ccp(0, 0)
  end
  local position = ccp(node:getPosition())
  local nodeParent = node:getParent()
  local worldPos = nodeParent:convertToWorldSpace(position)
  return worldPos
end

function HeroHintMgr:showHeroHint(type)
  if self.incd then
    return
  end
  local heroid = self:getHintHeroid(type)
  if not heroid then
    return
  end
  local heroHintid = self:createHeroHint(type, heroid)
  if heroHintid then
    self.incd = true
    local cd = self.globelcd
    local config = self.config[type]
    local showtime = config.showtime
    ListenTimer(Timer:Once(cd), function()
      self.incd = false
    end)
    ListenTimer(Timer:Once(showtime), function()
      self:removeHeroHint(heroHintid)
    end, self.heroHintMgrScope)
  end
end

function HeroHintMgr:getHintHeroid(type)
  local config = self.config[type]
  local heroStates = config.heroStates
  local hintHeros = {}
  for i = 1, #heroStates do
    local heroState = heroStates[i]
    local heros = ed.offlinequest.offline_mgr:getHeroesInConcernedSystem(heroState)
    if heros then
      for j = 1, #heros do
        local heroid = heros[j]
        table.insert(hintHeros, heroid)
      end
    end
  end
  return self:randomInArray(hintHeros)
end

local heroHintid = 0

function HeroHintMgr:createHeroHint(type, heroid)
  local config = self.config[type]
  local hintStr = self:getHintStr(heroid)
  local heroHint = ed.createHeroHint(heroid, hintStr)
  if not heroHint then
    return
  end
  heroHintid = heroHintid + 1
  local offsetpos = config.position
  heroHint:setPosition(offsetpos)
  local fcas = self.mainScene.mainFcas
  local node = fcas[type]
  local parent = node:getParent()
  parent:setZOrder(20)
  parent:addChild(heroHint, 30)
  self.heroHintTable[heroHintid] = heroHint
  return heroHintid
end

function HeroHintMgr:removeHeroHint(heroHintid)
  local heroHint = self.heroHintTable[heroHintid]
  if heroHint then
    heroHint:removeFromParentAndCleanup(true)
  else
    EDLog("heroHintid %d does not find in heroHintTable", heroHintid)
  end
end

function HeroHintMgr:getHintStr(heroid)
  local row = self.heroTaskTable[heroid]
  if not row then
    EDLog("hero have no take to say,heroid %d", heroid)
    return
  end
  local takeContents = {}
  for i = 1, 5 do
    local takeContent = row["Talk Content" .. i]
    if takeContent then
      takeContents[i] = takeContent
    else
      break
    end
  end
  return self:randomInArray(takeContents)
end

function HeroHintMgr:randomInArray(array)
  local arrayLen = #array
  if 0 < arrayLen then
    local index = math.random(arrayLen)
    local item = array[index]
    return item
  else
    return nil
  end
end
