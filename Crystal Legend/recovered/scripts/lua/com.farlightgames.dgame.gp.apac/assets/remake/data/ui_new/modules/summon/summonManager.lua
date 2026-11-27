local SummonManager = {}
SummonManager.__index = SummonManager
SummonManager.newbieEndTime = 0

function SummonManager.getInstance()
  if not SummonManager.instance then
    SummonManager.instance = SummonManager.create()
  end
  return SummonManager.instance
end

function SummonManager.create()
  local self = {}
  setmetatable(self, SummonManager)
  self:init()
  return self
end

function SummonManager:init()
  ed.defineProperty(self, "wishList", {}, nil, function(self, list)
    self.wishList = {}
    if not ed.tableIsNilOrEmpty(list) then
      for _, v in ipairs(list) do
        self.wishList[v._pos] = v
      end
    end
    for i = 1, 2 do
      if not self.wishList[i] then
        self.wishList[i] = {
          _pos = i,
          _hero = 0,
          _succeeded = 0
        }
      end
    end
  end)
  ed.defineProperty(self, "userSelectedWishList", nil)
  ed.defineProperty(self, "luckyPoint", 100)
  ed.defineProperty(self, "normalSummonCount", 0)
  ed.defineProperty(self, "userNormalSummonCount", 0)
end

function SummonManager:sortWishList(tb)
  table.sort(tb, function(a, b)
    return a._pos < b._pos
  end)
end

function SummonManager:findHeroInWishList(id)
  for i, wish in ipairs(self:getWishList()) do
    if wish._hero == id then
      return wish
    end
  end
  return nil
end

function SummonManager:getAllWishingHeros(name)
  local list = {}
  local group = ed.getDataTable("SummonCircleGroup")[3]
  assert(group, "SummonCircleGroup is null!")
  for i, item in ipairs(group) do
    if "Hero" == item["Reward Type"] then
      local timeStr = item["Online Time"]
      if timeStr then
        local onlineTime = ed.getTimeByYMDHMS(timeStr)
        if onlineTime <= ed.getServerTime() then
          table.insert(list, item["Reward ID"])
        end
      end
    end
  end
  return list
end

function SummonManager:getNormalCfgConstant(name)
  return ed.lookupDataTable("SummonCircleConfig", "Value", name)
end

function SummonManager:getDestinyCfgConstant(name)
  return ed.lookupDataTable("SummonDestinyConfig", "Value", name)
end

function SummonManager:wishListIsOpened()
  return self:getNormalSummonCount() >= self:getNormalCfgConstant("Wish List UnLock Times")
end

function SummonManager:handleMsg(msg, msgName)
  local handle = self:getHandle(msgName)
  if not handle then
    warn(msgName .. "`s handler not defined!")
    return
  end
  handle(self, msg)
end

local function convertHeroToStone(tid, amount)
  if amount and amount < 1 then
    return 0
  end
  local amount = amount or 1
  local unitTb = ed.getDataTable("Unit")[tid]
  local num = ed.summonMgr:getFragmentNumByStar(unitTb["Initial Stars"])
  local id = ed.readhero.getStoneid(tid)
  ed.player:addEquip(id, num * amount)
  return num * amount
end

function SummonManager:openScene(msg)
  local activityData = ed.activityHints.activityData or {}
  local isTimelySummonOpen = false
  for k, v in ipairs(activityData) do
    if v._type == "timely_summon" and v._start_time < ed.getServerTime() and ed.getServerTime() < v._end_time then
      isTimelySummonOpen = true
      break
    end
  end
  local isNewbieSummonOpen = ed.getServerTime() < ed.summonMgr.newbieEndTime
  local isRiseStarSummonOpen = ed.getServerTime() < ed.summonMgr.rise_starEndTime
  if self.page then
    if self.page == 1 then
      ed.pushScene(ed.ui.summonScene.create(1))
    elseif self.page == 2 then
      local summonCount = ed.summonMgr:getNormalSummonCount() or 0
      summonCount = summonCount + ed.summonMgr.timelySummonCount + ed.summonMgr.newbieSummonCount
      if summonCount < 200 then
        ed.showToast(string.format(T("\229\156\168\232\139\177\233\155\132/\233\153\144\230\151\182/\230\150\176\230\137\139\229\143\172\229\148\164\228\184\173\231\180\175\232\174\161\229\143\172\229\148\164200\230\172\161\229\144\142\232\167\163\233\148\129\239\188\136\229\189\147\229\137\141\232\191\155\229\186\166\239\188\154%d/200\239\188\137"), summonCount))
        return
      else
        ed.pushScene(ed.ui.summonScene.create(2))
      end
    elseif self.page == 3 then
      if isTimelySummonOpen then
        ed.pushScene(ed.ui.summonScene.create(3))
      else
        ed.showToast(T("\233\153\144\230\151\182\229\143\172\229\148\164\230\156\170\229\188\128\229\144\175"))
      end
    elseif self.page == 5 then
      if isRiseStarSummonOpen then
        ed.pushScene(ed.ui.summonScene.create(5))
      else
        ed.showToast(T("\230\152\159\232\190\137\229\143\172\229\148\164\230\156\170\229\188\128\229\144\175"))
      end
    end
  elseif isRiseStarSummonOpen or isNewbieSummonOpen then
    if isRiseStarSummonOpen then
      ed.pushScene(ed.ui.summonScene.create(5))
    elseif isNewbieSummonOpen then
      ed.pushScene(ed.ui.summonScene.create(4))
    end
  elseif isTimelySummonOpen then
    ed.pushScene(ed.ui.summonScene.create(3))
  else
    ed.pushScene(ed.ui.summonScene.create(1))
  end
end

function SummonManager:handleNormalSummon(msg)
  self:setLuckyPoint(msg._lucky_point)
  self:setNormalSummonCount(self:getUserNormalSummonCount())
  local ticketId = self:getNormalCfgConstant("Use Ticket")
  local ticketNum = ed.player:getEquipAmount(ticketId)
  local num = ticketNum - msg._item_count
  ed.player:consumeEquip(ticketId, ticketNum - msg._item_count)
  if msg._heroes then
    for _, hero in ipairs(msg._heroes) do
      ed.player:resetHero(hero)
      if hero._stars >= 3 then
        self:setHad3StarHero(true)
      end
    end
  end
  local smash_idxs_map = {}
  for _, idx in ipairs(msg._smash_idx or {}) do
    smash_idxs_map[idx] = true
  end
  self.equipQunty = ed.copyProto(ed.player.equip_qunty)
  local wishRefresh = false
  for i, rewardItem in ipairs(msg._reward) do
    if rewardItem._type == "hero" then
      local wish = self:findHeroInWishList(rewardItem._id)
      if wish then
        wish._succeeded = 1
        wishRefresh = true
      end
      if smash_idxs_map[i] then
        convertHeroToStone(rewardItem._id)
      end
    elseif rewardItem._type == "item" then
      ed.player:addEquip(rewardItem._id, rewardItem._amount)
    end
  end
  ed.player:addEquip(218, #msg._reward)
  if wishRefresh then
    FireEvent("SummonSwitchWish", true)
  end
  FireEvent("Summon", msg, smash_idxs_map, num)
end

function SummonManager:handleDestinySummon(msg)
  self.destinySummonCount = self.tmpDestinyTotal
  local ticketNum = ed.player:getEquipAmount(self.destinyItemId)
  local num = ticketNum - msg._item_count
  ed.player:consumeEquip(self.destinyItemId, ticketNum - msg._item_count)
  local smash_idxs_map = {}
  for _, idx in ipairs(msg._smash_idx or {}) do
    smash_idxs_map[idx] = true
  end
  local isFirst = true
  local wishRefresh = false
  local amount = 0
  for i, rewardItem in ipairs(msg._reward) do
    if rewardItem._type == "hero" then
      amount = amount + rewardItem._amount
      if not isFirst then
        local sum = convertHeroToStone(self.destinyTid, rewardItem._amount)
        if 0 < sum then
          smash_idxs_map[i] = sum
        end
      else
        isFirst = false
        if ed.player.heroes[self.destinyTid] then
          local sum = convertHeroToStone(self.destinyTid, rewardItem._amount)
          if 0 < sum then
            smash_idxs_map[i] = sum
          end
        else
          local sum = convertHeroToStone(self.destinyTid, rewardItem._amount - 1)
          if 0 < sum then
            smash_idxs_map[i] = sum
          end
        end
      end
    elseif rewardItem._type == "item" then
      ed.player:addEquip(rewardItem._id, rewardItem._amount)
    end
  end
  if msg._heroes then
    for _, hero in ipairs(msg._heroes) do
      ed.player:resetHero(hero)
    end
  end
  ed.player:addEquip(440, #msg._reward)
  if wishRefresh then
    FireEvent("SummonSwitchWish", true)
  end
  FireEvent("Summon", msg, smash_idxs_map, num)
end

function SummonManager:handleTimelySummon(msg)
  self.timelySummonCount = self.tmpTimelySummonCount
  local ticketId = self.timelyItemId
  local ticketNum = ed.player:getEquipAmount(ticketId)
  local num = ticketNum - msg._item_count
  ed.player:consumeEquip(ticketId, num)
  if msg._heroes then
    for _, hero in ipairs(msg._heroes) do
      ed.player:resetHero(hero)
    end
  end
  local smash_idxs_map = {}
  for _, idx in ipairs(msg._smash_idx or {}) do
    smash_idxs_map[idx] = true
  end
  self.equipQunty = ed.copyProto(ed.player.equip_qunty)
  for i, rewardItem in ipairs(msg._reward) do
    if rewardItem._type == "hero" then
      if smash_idxs_map[i] then
        convertHeroToStone(rewardItem._id)
      end
    elseif rewardItem._type == "item" then
      ed.player:addEquip(rewardItem._id, rewardItem._amount)
    end
  end
  ed.player:addEquip(218, #msg._reward)
  FireEvent("TimelySummonRefresh", num)
  FireEvent("Summon", msg, smash_idxs_map, num)
end

function SummonManager:initNewbieHotHeroes(data)
  self.newbieHotHeroes = data or {}
  self.newbieNewestHeroId = nil
  local beginnerTab = {}
  local curTime = ed.getServerTime()
  local tb = ed.getDataTable("SummonBeginner")
  for k, v in ipairs(tb) do
    if type(k) == "number" then
      beginnerTab[v["Hero ID"]] = true
      local onlineTime = ed.getTimeByYMDHMS(v["Online Time"])
      if curTime >= onlineTime and curTime < onlineTime + 604800 then
        self.newbieNewestHeroId = v["Hero ID"]
      end
    end
  end
  if #self.newbieHotHeroes >= 3 or #self.newbieHotHeroes == 0 then
    return
  end
  local hotHeroes = ed.player._herohot or {}
  for i, v in ipairs(hotHeroes) do
    if beginnerTab[v._heroid] and self.newbieNewestHeroId ~= v._heroid then
      local tmp = ed.downmsg.beginner_hot_hero()
      tmp._hero_id = v._heroid
      tmp._hot_value = 0.01
      table.insert(self.newbieHotHeroes, tmp)
      if #self.newbieHotHeroes >= 3 then
        return
      end
    end
  end
end

function SummonManager:handleNewbieSummon(msg)
  self.newbieSummonCount = self.tmpNewbieSummonCount
  local ticketId = self.newbieItemId
  local ticketNum = ed.player:getEquipAmount(ticketId)
  local num = ticketNum - msg._item_count
  ed.player:consumeEquip(ticketId, ticketNum - msg._item_count)
  if msg._heroes then
    for _, hero in ipairs(msg._heroes) do
      ed.player:resetHero(hero)
    end
  end
  local smash_idxs_map = {}
  for _, idx in ipairs(msg._smash_idx or {}) do
    smash_idxs_map[idx] = true
  end
  self.equipQunty = ed.copyProto(ed.player.equip_qunty)
  for i, rewardItem in ipairs(msg._reward) do
    if rewardItem._type == "hero" then
      if smash_idxs_map[i] then
        convertHeroToStone(rewardItem._id)
      end
    elseif rewardItem._type == "item" then
      ed.player:addEquip(rewardItem._id, rewardItem._amount)
    end
  end
  ed.player:addEquip(218, #msg._reward)
  FireEvent("NewbieSummonRefresh", num)
  FireEvent("Summon", msg, smash_idxs_map, num)
end

function SummonManager:initRiseStarHotHeroes(data)
  self.riseStarHeroList = data or {}
  self.riseStarNewestHeroId = nil
  local beginnerTab = {}
  local curTime = ed.getServerTime()
  local tb = ed.getDataTable("SummonRiseStar")
  for k, v in ipairs(tb) do
    if type(k) == "number" then
      beginnerTab[v["Hero ID"]] = true
      local onlineTime = ed.getTimeByYMDHMS(v["Online Time"])
      if curTime >= onlineTime and curTime < onlineTime + 604800 then
        self.riseStarNewestHeroId = v["Hero ID"]
      end
    end
  end
  if data and #data == 0 then
    return
  end
  if #self.riseStarHeroList >= 3 or #self.riseStarHeroList == 0 then
    return
  end
  local hotHeroes = ed.player._herohot or {}
  for i, v in ipairs(hotHeroes) do
    if beginnerTab[v._heroid] and self.riseStarNewestHeroId ~= v._heroid then
      local isSame = false
      for _, element in pairs(data) do
        if element._hero_id == v._heroid then
          isSame = true
          break
        end
      end
      if not isSame then
        local tmp = ed.downmsg.beginner_hot_hero()
        tmp._hero_id = v._heroid
        tmp._hot_value = 0.01
        table.insert(self.riseStarHeroList, tmp)
      end
      if #self.riseStarHeroList >= 3 then
        return
      end
    end
  end
end

function SummonManager:handleRiseStarSummon(msg)
  self.rise_starSummonCount = self.tmpRiseStarSummonCount
  local ticketId = self.riseStarItemId
  local ticketNum = ed.player:getEquipAmount(ticketId)
  local num = ticketNum - msg._item_count
  ed.player:consumeEquip(ticketId, ticketNum - msg._item_count)
  if msg._heroes then
    for _, hero in ipairs(msg._heroes) do
      ed.player:resetHero(hero)
    end
  end
  local smash_idxs_map = {}
  for _, idx in ipairs(msg._smash_idx or {}) do
    smash_idxs_map[idx] = true
  end
  self.equipQunty = ed.copyProto(ed.player.equip_qunty)
  for i, rewardItem in ipairs(msg._reward) do
    if rewardItem._type == "hero" then
      if smash_idxs_map[i] then
        convertHeroToStone(rewardItem._id)
      end
    elseif rewardItem._type == "item" then
      ed.player:addEquip(rewardItem._id, rewardItem._amount)
    end
  end
  ed.player:addEquip(218, #msg._reward)
  FireEvent("EventSummonRiseStarRefresh", num)
  FireEvent("Summon", msg, smash_idxs_map, num)
end

function SummonManager:getLastRiseStarRecommendTime()
  local key = ed.getRoleKey("last_RiseStar_recommend_time")
  return ed.storage.getInt(key) or 0
end

function SummonManager:updateLastRiseStarRecommendTime()
  local key = ed.getRoleKey("last_RiseStar_recommend_time")
  return ed.storage.setValue(key, ed.getServerTime())
end

local handlers = {
  open_panel = function(self, msg)
    self:setWishList(msg._wish_list)
    self:setLuckyPoint(msg._lucky_point)
    self.destinyTid = msg._hero_id
    self:setNormalSummonCount(msg._total_summon_count)
    self.destinySummonCount = msg._destiny_total_summon_count
    self.destinyItemId = ed.getDataTable("SummonDestinyConfig")["Use Ticket"].Value
    self.timelyItemId = ed.getDataTable("SummonCircleConfig")["Timely Ticket"].Value
    self.timelyItemCost = ed.getDataTable("SummonCircleConfig")["Timely Ticket Value"].Value
    self.timelySummonCount = msg._timely_total_summon_count or 0
    self.newbieItemId = ed.getDataTable("SummonCircleConfig")["Timely Ticket"].Value
    self.newbieItemCost = ed.getDataTable("SummonCircleConfig")["Timely Ticket Value"].Value
    self.newbieSummonCount = msg._beginner_total_summon_count or 0
    self.newbieRewardFlag = msg._beginner_reward_flag
    self.newbieEndTime = msg._beginner_end_time or 0
    self.newbieHeroId = msg._beginner_hero_id
    self.riseStarItemId = ed.getDataTable("SummonCircleConfig")["RiseStar Ticket"].Value
    self.riseStarItemCost = ed.getDataTable("SummonCircleConfig")["Ticket Value"].Value
    if msg._extra_summon_info then
      for i, v in pairs(msg._extra_summon_info) do
        if v._type == "rise_star" then
          self.rise_starHeroId = v._hero_id
          self.rise_starSummonCount = v._total_count or 0
          self.rise_starRewardFlag = v._reward_flag or 0
          self.rise_starEndTime = v._end_time or 0
          self:initRiseStarHotHeroes(v._hot_heroes)
        end
      end
    end
    self:initNewbieHotHeroes(msg._beginner_hot_heroes)
    if ed.asyncload.isCompleted then
      self:openScene(msg)
    else
      ed.asyncload.registLoadingListener(function()
        self:openScene(msg)
      end)
    end
  end,
  summon = function(self, msg)
    if msg._type == "normal" then
      self:handleNormalSummon(msg)
    elseif msg._type == "destiny" then
      self:handleDestinySummon(msg)
    elseif msg._type == "timely" then
      self:handleTimelySummon(msg)
    elseif msg._type == "beginner" then
      self:handleNewbieSummon(msg)
    elseif msg._type == "rise_star" then
      self:handleRiseStarSummon(msg)
    end
  end,
  switch_wish = function(self, msg)
    if msg._result == "success" then
      local list = self:getUserSelectedWishList()
      if list then
        list = ed.copyTable(list)
        self:setWishList(list)
        self:setUserSelectedWishList(nil)
      end
      FireEvent("SummonSwitchWish", true)
    else
      FireEvent("SummonSwitchWish", false)
    end
  end,
  buy_ticket = function(self, msg)
    if msg._result ~= "success" then
      ed.showToast(T("\232\180\173\228\185\176\229\164\177\232\180\165\239\188\129"))
      return
    end
    local ticketId, ticketCost
    if msg._type == "normal" then
      ticketId = ed.summonMgr:getNormalCfgConstant("Use Ticket")
      ticketCost = ed.summonMgr:getNormalCfgConstant("Ticket Value")
    elseif msg._type == "timely" or msg._type == "beginner" then
      ticketId = ed.summonMgr.timelyItemId
      ticketCost = ed.summonMgr.timelyItemCost
    elseif msg._type == "rise_star" then
      ticketId = ed.summonMgr.riseStarItemId
      ticketCost = ed.summonMgr.riseStarItemCost
    end
    local ticketNum = ed.player:getEquipAmount(ticketId)
    local addition = msg._item_count - ticketNum
    ed.player:addrmb(-addition * ticketCost)
    ed.player:addEquip(ticketId, addition)
    ed.showToast(T("\232\180\173\228\185\176\230\136\144\229\138\159\239\188\129"))
  end,
  query_records = function(self, msg)
    FireEvent("SummonRecordRefresh", msg)
  end,
  take_rewards = function(self, msg)
    if msg._type == "beginner" then
      FireEvent("SummonNewbieGetReward", msg)
    elseif msg._type == "rise_star" then
      FireEvent("SummonRiseStarGetReward", msg)
    end
  end,
  error_code = function(self, msg)
    if msg == "destiny_summon_this_batch_passed" then
      self.destinyTid = nil
      FireEvent("SummonClearWish")
    end
    if msg == "destiny_summon_hero_arg_error" then
      FireEvent("SummonClearWish")
    end
  end
}

function SummonManager:getHandle(msgName)
  return handlers[msgName]
end

function SummonManager:isHad3StarHero()
  local key = ed.getRoleKey("had3StarHero")
  return ed.storage.getBool(key)
end

function SummonManager:setHad3StarHero(flag)
  local key = ed.getRoleKey("had3StarHero")
  return ed.storage.setValue(key, flag)
end

function SummonManager:setRedFlag(red)
  self.redFlag = red
end

function SummonManager:setCircleRed(show)
  if nil ~= ed.summonMgr.newbieEndTime then
    self.circleRed = show == 1 and ed.getServerTime() < ed.summonMgr.newbieEndTime
  else
    self.circleRed = show == 1
  end
end

function SummonManager:setRiseCircleRed(show)
  if nil ~= ed.summonMgr.rise_starEndTime then
    self.riseCircleRed = show == 1 and ed.getServerTime() < ed.summonMgr.rise_starEndTime
  else
    self.riseCircleRed = show == 1
  end
end

function SummonManager:getLastNewbieRecommendTime()
  local key = ed.getRoleKey("last_newbie_recommend_time")
  return ed.storage.getInt(key) or 0
end

function SummonManager:updateLastNewbieRecommendTime()
  local key = ed.getRoleKey("last_newbie_recommend_time")
  return ed.storage.setValue(key, ed.getServerTime())
end

function SummonManager:getRedFlag()
  if self.redFlag ~= nil then
    return self.redFlag
  end
  local timelyRedFlag = self:_checkTimelySummonRedFlag()
  if timelyRedFlag then
    return true
  end
  local newbieRedFlag = self:_checkNewbieSummonRedFlag()
  if newbieRedFlag then
    return true
  end
  local riseStarRedFlag = self:_checkRiseStarSummonRedFlag()
  if riseStarRedFlag then
    return true
  end
  return false
end

function SummonManager:_checkTimelySummonRedFlag()
  local activityData = ed.activityHints.activityData or {}
  for _, activity in ipairs(activityData) do
    if activity._type == "timely_summon" then
      local task = activity._tasks and activity._tasks[1]
      if task then
        local progress = task._progress or 0
        local maxProgress = task._cond_target or 0
        local hasReward = task._last_rewards_time and 0 < task._last_rewards_time
        local isActive = ed.getServerTime() < (task._task_end_time or 0)
        return not hasReward and progress >= maxProgress and isActive
      end
    end
  end
  return false
end

function SummonManager:_checkNewbieSummonRedFlag()
  if not self.circleRed then
    return false
  end
  if ed.summonMgr.newbieEndTime then
    return ed.getServerTime() < ed.summonMgr.newbieEndTime
  end
  return true
end

function SummonManager:_checkRiseStarSummonRedFlag()
  if not self.riseCircleRed then
    return false
  end
  if ed.summonMgr.rise_starEndTime then
    return ed.getServerTime() < ed.summonMgr.rise_starEndTime
  end
  return true
end

function SummonManager:getFragmentNumByStar(star)
  return ed.getDataTable("HeroStars")[star]["Convert Fragments"]
end

function SummonManager:openSummonScene(type)
  ed.summonNet:send("open_panel", {})
end

ed.summonMgr = SummonManager.getInstance()
