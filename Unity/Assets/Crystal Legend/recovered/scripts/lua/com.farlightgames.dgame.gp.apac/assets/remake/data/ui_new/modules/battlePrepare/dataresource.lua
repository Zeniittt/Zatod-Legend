module("ed.battleprepare", package.seeall)
Model = {}
Model.__index = Model

function Model:create(param)
  local obj = {}
  setmetatable(obj, self)
  obj:init(param)
  return obj
end

function Model:release()
  self.listData = {}
  self.selectList = {}
  self.mustList = {}
  self.forbidList = {}
end

function Model:init(param)
  self.param = param
  local param = param or {}
  self.stageid = param.stageid
  self.type = param.type
  self.maxNum = param.maxNum or 5
  self.minNum = param.minNum
  self.dispatchNum = param.dispatchNum or 0
  self.listData = {}
  self.selectList = {}
  self.mustList = {}
  self.forbidList = {}
  self.preList = {}
  self.enemyHeroList = {}
  self.dispatchList = {}
  self:initHeros(param.filterHandler)
  self:setMustList(param.mustList or {})
  self:setPreList(param.preList or {})
  self:setForbidList(param.forbidList or {})
  self:setFirstList(param.firstList or {})
  self:setEnemyHeroList(param.enemyHeroList or {})
  self:setDispatchList(param.dispatchList or {})
  self:setDispatchMercenaryHero(param.dispatchMercenaryHero)
  self.dispatchHash = self:creatDispatchHash()
  self.canDispatchNum = param.canDispatchNum
end

function Model:initHeros(filterHandler)
  local all, front, middle, back = ed.readhero.classify("prepare", "position")
  local collect = ed.herorecommend.manager:filtrCollectHero(all)
  self.listData = {
    all = filterHandler and filterHandler(all) or all,
    collect = filterHandler and filterHandler(collect) or collect,
    front = filterHandler and filterHandler(front) or front,
    middle = filterHandler and filterHandler(middle) or middle,
    back = filterHandler and filterHandler(back) or back
  }
end

function Model:setMaxNum(num)
  self.maxNum = num
end

function Model:getMaxNum()
  return self.maxNum
end

function Model:setMinNum(num)
  self.minNum = num
end

function Model:getMinNum()
  return self.minNum
end

function Model:setMustList(list)
  self.mustList = list
end

function Model:getMustList()
  return self.mustList
end

function Model:isLockedMove()
  return self.maxNum == 5
end

function Model:setPreList(list)
  self.preList = list
  local temp = {}
  for k, hid in ipairs(self.preList) do
    temp[hid] = k
  end
  for k, hid in ipairs(self:getMustList()) do
    if not temp[hid] then
      table.insert(self.preList, hid)
    end
  end
end

function Model:getPreList()
  return self.preList
end

function Model:setFirstList(list)
  self.firstList = list
end

function Model:getFirstList()
  return self.firstList
end

function Model:isFirst(hId)
  for k, id in ipairs(self:getFirstList()) do
    if id == hId then
      return true
    end
  end
  return false
end

function Model:isDead(hId)
  local hero = ed.player.heroes[hId]
  if not hero or not self.type then
    return false
  end
  local hp = hero:hp_perc(self.type)
  if hp and hp == 0 then
    return true
  end
  return false
end

function Model:isDispatch(hId)
  if self.type == "multi_stage" and not self.dispatchHash[hId] then
    local seNum = 0
    for _, id in ipairs(self.selectList) do
      if not self.dispatchHash[id] then
        seNum = seNum + 1
      end
    end
    if seNum >= self.canDispatchNum then
      return true
    end
  end
  return false
end

function Model:mercenaryIsDispatch()
  local mercenary = ed.GuildManager.multistageMercenary
  if mercenary then
    return false
  end
  local seNum = 0
  for _, id in ipairs(self.selectList) do
    if not self.dispatchHash[id] then
      seNum = seNum + 1
    end
  end
  if seNum >= self.canDispatchNum then
    return true
  end
  return false
end

function Model:isNotOwn(hId)
  if not ed.player.heroes[hId] then
    return true
  end
  return false
end

function Model:setEnemyHeroList(list)
  self.enemyHeroList = list
end

function Model:getEnemyHeroList()
  return self.enemyHeroList
end

function Model:setForbidList(list)
  self.forbidList = list
end

function Model:getForbidList()
  return self.forbidList
end

function Model:getForbidListHash()
  local temp = {}
  for k, hid in ipairs(self:getForbidList()) do
    temp[hid] = k
  end
  return temp
end

function Model:isMercenary()
  return self.mercenaryHero
end

function Model:getListData()
  return self.listData
end

function Model:getRecommendListData()
  if self.recommendListData then
    return self.recommendListData
  else
    local idlist = ed.herorecommend.manager:getStageRecommend(self.stageid)
    if idlist then
      self.recommendListData = self:createRecommendListData(idlist)
      return self.recommendListData
    end
  end
end

function Model:createRecommendListData(idlist)
  local heroes = manager:createHeroesByIdlist(idlist)
  local listData = manager:classfiyHeroes(heroes)
  local filterHandler = self.param.filterHandler
  if filterHandler then
    return {
      all = filterHandler(listData.all),
      collect = filterHandler(listData.collect),
      front = filterHandler(listData.front),
      middle = filterHandler(listData.middle),
      back = filterHandler(listData.back)
    }
  else
    return listData
  end
end

function Model:getHeroData()
  local all = self.listData.all
  local temp = {}
  for i, hero in ipairs(all) do
    temp[hero._tid] = hero
  end
  return temp
end

function Model:setDispatchList(list)
  self.dispatchList = list
end

function Model:getDispatchList()
  return self.dispatchList
end

function Model:getDispatchHash()
  return self.dispatchHash
end

function Model:getDispatchNum()
  return self.dispatchNum
end

function Model:setDispatchMercenaryHero(hero)
  self.dispatchMercenaryHero = hero
end

function Model:getDispatchMercenaryHero()
  return self.dispatchMercenaryHero
end

function Model:creatDispatchHash()
  local hash = {}
  for _, id in ipairs(self.dispatchList) do
    hash[id] = true
  end
  return hash
end

function Model:isHeroExist(hid)
  for i, hero in ipairs(self.listData.all) do
    if hero._tid == hid then
      return true
    end
  end
  return false
end

function Model:hasHeroInTeam(hid)
  for k, id in ipairs(self.selectList) do
    if id == hid then
      return true
    end
  end
  return false
end

function Model:addMember(hid)
  local maxRange = ed.readhero.getHeroMaxRange(hid)
  local maxRangeHeroId = self.selectList[#self.selectList]
  if #self.selectList == 0 or maxRange > ed.readhero.getHeroMaxRange(maxRangeHeroId) then
    table.insert(self.selectList, hid)
    return #self.selectList
  end
  local minRangeHeroId = self.selectList[1]
  local minRange = ed.readhero.getHeroMaxRange(minRangeHeroId)
  if maxRange <= minRange then
    table.insert(self.selectList, 1, hid)
    return 1
  end
  for i = #self.selectList, 2, -1 do
    local rangHeroId = self.selectList[i]
    local preRangeHeroId = self.selectList[i - 1]
    if maxRange <= ed.readhero.getHeroMaxRange(rangHeroId) and maxRange >= ed.readhero.getHeroMaxRange(preRangeHeroId) then
      table.insert(self.selectList, i, hid)
      return i
    end
  end
end

function Model:addMercenary(hero)
  self.mercenaryHero = hero
  return self:addMember(hero._tid)
end

function Model:removeMercenary(hero)
  self.mercenaryHero = nil
  return self:removeMember(hero._tid)
end

function Model:clearAll()
  self.selectList = {}
  self.mercenaryHero = nil
end

function Model:removeMember(hid)
  for k, id in ipairs(self.selectList) do
    if id == hid then
      table.remove(self.selectList, k)
      return k
    end
  end
  return false
end

function Model:getMercenaryHero()
  return self.mercenaryHero
end

function Model:isRepet(hid)
  if self.mercenaryHero and hid == self.mercenaryHero._tid then
    return true
  end
  return false
end

function Model:mercenaryIsRepet(hid)
  if self.mercenaryHero then
    return false
  end
  for k, id in ipairs(self.selectList) do
    if id == hid then
      return true
    end
  end
  return false
end

function Model:teamWithHero(hid)
  for k, id in ipairs(self.selectList) do
    if id == hid then
      return true
    end
  end
  return false
end

function Model:getHeroNum()
  return #(self.selectList or {})
end

function Model:getTeamGS()
  local team = self:getSelectHeroes()
  local total = 0
  for k, hero in pairs(team) do
    total = total + hero._gs
  end
  return total
end

function Model:isFull()
  return self:getHeroNum() >= self:getMaxNum()
end

function Model:isEnough()
  return self:getMinNum() < self:getHeroNum()
end

function Model:getSelectHeroes()
  local heroList = {}
  local herosHash = self:getHeroData()
  for k, id in ipairs(self.selectList) do
    local hero = herosHash[id]
    if hero then
      table.insert(heroList, hero)
    end
  end
  return heroList
end

function Model:getSelectList()
  return self.selectList
end

function Model:isForbid(hId)
  for k, id in ipairs(self:getForbidList()) do
    if id == hId then
      return true
    end
  end
  return false
end

function Model:isMustHero(hid)
  for k, id in ipairs(self:getMustList()) do
    if hid == id then
      return true
    end
  end
  return false
end

function Model:checkLostHero()
  local temp = {}
  for k, hid in ipairs(self.selectList) do
    temp[hid] = k
  end
  for k, hid in ipairs(self:getMustList()) do
    if not temp[hid] then
      return hid
    end
  end
  return 0
end
