local class = {}
class.__index = class
local instance

function class.getInstance()
  if not instance then
    instance = class.create()
  end
  return instance
end

function class.create()
  local object = {}
  setmetatable(object, class)
  object:initData()
  return object
end

function class:initData()
  self.seasonTbl = ed.getDataTable("TimeCorridor")
  self.config = ed.getDataTable("TimeCorridorConfig")
  self.limitLevel = tonumber(self.config.PlayerLevel.Value or 10)
  ed.UITool.registViewOpenFunc("timeCorridorScene", function(param)
    if self.limitLevel and ed.player:getLevel() < self.limitLevel then
      ed.showToast(T("\230\136\152\233\152\159\231\173\137\231\186\167\232\190\190\229\136\17610\231\186\167\229\188\128\230\148\190"))
      return
    end
    if ed.timeCorridorMgr.endTime and ed.timeCorridorMgr.endTime <= ed.getServerTime() then
      ed.showToast(T("\230\180\187\229\138\168\229\183\178\229\133\179\233\151\173"))
      ed.timeCorridorMgr.isOpen = false
      FireEvent("RefreshRightTopButtons")
      return
    end
    ed.timeCorridorNet:sendOpenPanel()
  end)
  self.tokenId = ed.lookupDataTable("TimeCorridor", "Token Item ID", self.season or 1)
  self.ticketId = ed.lookupDataTable("TimeCorridor", "Discount Item ID", self.season or 1)
  self.summonPassId = tonumber(self.config["Use Ticket"].Value)
  self.summonCostPassNum = 6
  self.canGetReward = {}
  self.scope = {}
  ListenEvent("ActivityUpdateSuccess", function()
    local activityInfo = ed.activityHints.data:getTimeCorridorActivityInfo()
    if activityInfo and activityInfo._id then
      self.endTime = activityInfo._end_time
      self.activityId = activityInfo._id
      self:refreshActivityProgress(activityInfo)
      FireEvent("MainRedTagChange", ed.ui.configs.mainButton.ButtonType.TIME_CORRIDOR)
    end
    CloseScope(self.scope)
  end, self.scope)
end

function class:handleOpenPanel(msg)
  self:replaceSeasonUI()
  local activityInfo = ed.activityHints.data:getTimeCorridorActivityInfo()
  self.activityId = activityInfo._id
  self:refreshActivityProgress(activityInfo)
  self.endTime = activityInfo._end_time
  self.mainSkinId = self.seasonTbl[self.season]["Main Skin Item ID"]
  self.mainSkinId2 = self.seasonTbl[self.season]["Main Skin Item ID2"]
  self.tokenId = ed.lookupDataTable("TimeCorridor", "Token Item ID", self.season or 1)
  self.ticketId = ed.lookupDataTable("TimeCorridor", "Discount Item ID", self.season or 1)
  self.freeSummonTimes = msg._left_free or 0
  self:initGoods(msg._goods or {})
  self:refreshGoods()
  local scene = ed.ui.timeCorridorScene.create()
  ed.pushScene(scene)
end

function class:handleSummonReply(msg)
  if not msg or not msg._rewards then
    return
  end
  local smashMap = {}
  for i, id in pairs(msg._smash_idx or {}) do
    smashMap[id] = true
  end
  self:addRewards(msg._rewards, smashMap)
  self.freeSummonTimes = msg._left_free
  if msg._item_count then
    local deltaAmount = ed.player:getEquipAmount(self.summonPassId) - msg._item_count
    ed.player:consumeEquip(self.summonPassId, deltaAmount)
  end
  if msg._discount_item then
    local deltaAmount = ed.player:getEquipAmount(self.ticketId) - msg._discount_item
    ed.player:consumeEquip(self.ticketId, deltaAmount)
  end
  FireEvent("TimeCorridorSummonReply", {
    rewards = msg._rewards,
    smashMap = smashMap
  })
end

function class:handleBuyGoodReply(msg)
  if not msg._goods_index then
    ed.showToast("\229\133\145\230\141\162\229\164\177\232\180\165\239\188\129")
    return
  end
  local item = self:getGood(msg._goods_index)
  if not self.boughtGoods[msg._goods_index] then
    self.boughtGoods[msg._goods_index] = {}
    self.boughtGoods[msg._goods_index].maxBuyTimes = self.shopList[msg._goods_index].maxBuyTimes
  end
  self.boughtGoods[msg._goods_index].curBuyTimes = msg._cur_buy_times
  self:refreshGoods()
  if msg._left_token then
    local deltaAmount = ed.player:getEquipAmount(self.tokenId) - msg._left_token
    ed.player:consumeEquip(self.tokenId, deltaAmount)
    FireEvent("ResourceNumChange", "item", self.tokenId)
  end
  if msg._left_diamond then
    ed.player:setrmb({
      _free_diamond = msg._left_diamond
    })
  end
  if msg._rewards then
    ed.player:addRewards(msg._rewards)
  end
  FireEvent("timeCorridorShopReply")
end

function class:handleRecordsReply(msg)
  local records = ed.copyProto(msg._records or {})
  FireEvent("TimeCorridorRecordsReply", records)
end

function class:handleNotify(msg)
  self.season = msg._season
  self.isOpen = nil ~= self.season
  if self.isOpen then
    self.commonUIPath = "UI/alpha/1080P/timecorridor/"
    self.seasonUIPath = "UI/alpha/1080P/timecorridor/" .. self.season .. "/"
    local timeCorridorUidKey = ed.storage.getBool(ed.getRoleKey("timeCorridor"))
    FireEvent("RefreshRightTopButtons")
  end
end

function class:getResourceBarInfo()
  local seasonLine = self.seasonTbl[self.season or 1]
  local token = {
    itemId = seasonLine["Token Item ID"]
  }
  local ticket = {
    itemId = seasonLine["Discount Item ID"]
  }
  token.uiRes = self.seasonUIPath .. "timecorridor_token_1.png"
  ticket.uiRes = self.seasonUIPath .. "timecorridor_discount_ticket_2.png"
  return {
    token = token,
    ticket = ticket,
    moon = {
      itemId = 20470,
      uiRes = "UI/alpha/1080P/timecorridor/timecorridor_moon_1.png"
    }
  }
end

function class:getGoodsList()
  self:refreshGoods()
  return self.goodsList
end

function class:getTokenSmallIconRes()
  return self.seasonUIPath .. "timecorridor_token_1.png"
end

function class:getPassSmallIconRes()
  return self.commonUIPath .. "timecorridor_moon_1.png"
end

function class:getGood(index)
  return self.shopList[index]
end

function class:getMainSkinID()
  return self.mainSkinId
end

function class:getMainSkinID2()
  return self.mainSkinId2
end

function class:getRewardGroupById(id)
  if not self.groupTbl then
    self:cacheRewardGroup()
  end
  return self.groupTbl[id].groupId
end

function class:getRewardGroupIndexById(id)
  if not self.groupTbl then
    self:cacheRewardGroup()
  end
  if not self.groupTbl[id] then
    return nil, nil
  end
  return self.groupTbl[id].groupId, self.groupTbl[id].indexId
end

function class:getRewardSmashNumById(id)
  local groupId = self:getRewardGroupById(id)
  if not groupId then
    return 0
  end
  return ed.getDataTable("TimeCorridorPool")[self.season][groupId]["Exchange Amount"] or 0
end

function class:hasRewards()
  for _, v in pairs(self.canGetReward) do
    return true
  end
  return false
end

function class:showRed()
  return not ed.storage.getBool(ed.getRoleKey("timeCorridor")) or self:hasRewards()
end

function class:closeWin()
  local timeCorridorUidKey = ed.getRoleKey("timeCorridor")
  if not ed.storage.getBool(timeCorridorUidKey) then
    ed.storage.setValue(timeCorridorUidKey, true)
  end
  FireEvent("MainRedTagChange", ed.ui.configs.mainButton.ButtonType.TIME_CORRIDOR)
end

function class:cacheRewardGroup()
  local seasonGroupTbl = ed.getDataTable("TimeCorridorPool")[self.season]
  local groupTbl = ed.getDataTable("TimeCorridorGroup")
  self.groupTbl = {}
  for groupId, group in pairs(groupTbl) do
    if seasonGroupTbl[groupId] then
      for ind, reward in pairs(group) do
        if reward["Display Type"] ~= "Item" then
          self.groupTbl[reward["Reward ID"]] = {
            groupId = reward["Group ID"],
            indexId = reward.Index
          }
        end
      end
    end
  end
end

function class:initGoods(goods)
  self.boughtGoods = {}
  for i, v in pairs(goods) do
    self.boughtGoods[v._index] = {
      curBuyTimes = v._cur_buy_times,
      maxBuyTimes = v._max_buy_times
    }
  end
  self.shopList = {}
  self.goodsList = {}
  self.shopTbl = ed.getDataTable("TimeCorridorShop")[self.season]
  for i, k in ipairs(self.shopTbl) do
    local rewardId = k["Reward ID"]
    self.shopList[i] = {
      ind = i,
      tokenType = k["Token Type"],
      tokenAmount = k["Token Amount"],
      rewardType = k["Reward Type"],
      rewardId = rewardId,
      rewardAmount = k["Reward Amount"],
      maxBuyTimes = k["Buy Times"],
      showProgress = k.Progress,
      curBuyTimes = 0,
      status = "onSale",
      isShow = ed.isElementInTable(ed.readequip.value(rewardId, "Category"), {
        T("\229\164\180\229\131\143"),
        T("\229\164\180\229\131\143\230\161\134"),
        T("\232\161\168\230\131\133\229\140\133"),
        T("\231\171\158\230\138\128\229\156\186\232\131\140\230\153\175")
      }) or ed.isElementInTable(ed.readequip.value(rewardId, "Consume Type"), {"\231\154\174\232\130\164"})
    }
    if self.shopList[i].isShow and ed.player:getEquipAmount(rewardId) >= ed.getEquipRow(rewardId)["Max Amount"] then
      self.shopList[i].status = "soldOut"
    end
  end
end

function class:refreshGoods()
  for i, k in pairs(self.boughtGoods) do
    self.shopList[i].curBuyTimes = k.curBuyTimes
    if k.curBuyTimes >= k.maxBuyTimes then
      self.shopList[i].status = "soldOut"
    end
  end
  for i, k in pairs(self.shopList) do
    if k.isShow and ed.player:getEquipAmount(k.rewardId) >= ed.getEquipRow(k.rewardId)["Max Amount"] then
      self.shopList[i].status = "soldOut"
    end
  end
  self.goodsList = ed.copyTable(self.shopList)
end

function class:refreshActivityProgress(msg)
  local summonTaskList = {}
  local progress = 0
  local info = ed.copyProto(msg)
  if info._tasks then
    for i, v in ipairs(info._tasks) do
      if v._cond_type == "time_corridor_progress" then
        local getReward = 0 < v._max_reward_times - v._cur_reward_times
        local achiv = v._cond_target <= v._progress
        table.insert(summonTaskList, {
          reward = v._rewards[1],
          target = v._cond_target,
          achiv = achiv,
          canGetReward = achiv and getReward,
          id = v._id
        })
        if achiv and getReward then
          self.canGetReward[v._id] = true
        end
        progress = v._progress
      end
    end
    self.activityProgress = progress
    self.activityTaskList = summonTaskList
  elseif info._task then
    local v = info._task
    for i, task in pairs(self.activityTaskList) do
      if task.id == v._id then
        local getReward = 0 < v._max_reward_times - v._cur_reward_times
        local achiv = v._cond_target <= v._progress
        task.achiv = achiv
        task.canGetReward = achiv and getReward
        self.canGetReward[v._id] = nil
      end
    end
  end
end

function class:replaceSeasonUI()
  if nil == self.replaceUIOnce then
    local replaceUIList = {
      "timeCorridorScene",
      "timeCorridorShopItem",
      "timeCorridorPoolItem",
      "timeCorridorRewardCardWin"
    }
    for _, str in pairs(replaceUIList) do
      self:replaceSeasonUIRes(ed.uieditor[str])
    end
  end
  self.replaceUIOnce = true
end

function class:addRewards(rewards, smashMap)
  local realRewards = {}
  for i, reward in pairs(rewards) do
    if smashMap[i] then
      table.insert(realRewards, {
        _id = self.tokenId,
        _type = "item",
        _amount = self:getRewardSmashNumById(reward._id)
      })
    elseif ed.readequip.value(reward._id, "Consume Type") == "\231\154\174\232\130\164" then
      ed.player:addEquip(reward._id, 1, nil, nil, {noFashionPop = true})
    else
      table.insert(realRewards, reward)
    end
  end
  ed.player:addRewards(realRewards)
end

function class:replaceSeasonUIRes(config)
  if type(config) == "table" then
    for i, k in pairs(config) do
      config[i] = self:replaceSeasonUIRes(k)
    end
  elseif type(config) == "string" then
    config = string.gsub(config, "timecorridor/1", "timecorridor/" .. self.season)
  end
  return config
end

function class:calcSummonCost(times)
  if times <= 0 then
    return 0
  end
  if times == 1 and 0 < self.freeSummonTimes then
    return 0
  end
  local ticket_num = ed.player:getEquipAmount(ed.timeCorridorMgr.ticketId)
  local useTicket = math.min(ticket_num, times)
  local singleCost = self.summonCostPassNum
  return singleCost * 0.5 * useTicket + singleCost * (times - useTicket)
end

ed.timeCorridorMgr = class.getInstance()
