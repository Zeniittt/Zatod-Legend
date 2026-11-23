local class = newclass("g")
ed.rogueLikeResultHandle = class

function class.create(mgr)
  local self = {}
  setmetatable(self, {__index = class})
  setmetatable(class, {__index = mgr})
  self:init()
  return self
end

function class:getHandleFunc(type)
  return self.handleFunction[type]
end

function class:init()
  self.handleFunction = {
    stage = self.stage,
    team_mp_cut_point = self.team_mp_cut_point,
    team_mp_cut_percent = self.team_mp_cut_percent,
    team_mp_add_percent = self.team_mp_add_percent,
    team_mp_add_point = self.team_mp_add_point,
    team_hp_cut_point = self.team_hp_cut_point,
    team_hp_cut_percent = self.team_hp_cut_percent,
    team_hp_add_percent = self.team_hp_add_percent,
    team_hp_add_point = self.team_hp_add_point,
    pearl_add = self.pearl_add,
    random_destiny_all_bless = self.random_destiny_all_bless,
    enhance_all_bless = self.enhance_all_bless,
    pearl_store = self.pearl_store,
    pearl_bonus = self.pearl_bonus,
    appoint_bless = self.appoint_bless,
    retry_times_add = self.retry_times_add,
    retry_times_cut = self.retry_times_cut,
    normal_bless = self.normal_bless,
    pearl_cut = self.pearl_cut,
    pearl_cut_all = self.pearl_cut_all,
    reinforced_bless_add = self.reinforced_bless_add,
    bless_enhance = self.bless_enhance,
    low_bless_cut = self.low_bless_cut,
    total_bless_cut = self.total_bless_cut,
    weakest_hero_cure = self.weakest_hero_cure,
    hero_reborn = self.hero_reborn,
    kill_hero = self.kill_hero,
    bought_bless = self.bought_bless,
    hero_add = self.hero_add,
    battle_end = self.battle_end,
    revelation_pick = self.revelation_pick,
    normal_sheep_reward = self.normal_sheep_reward,
    gold_sheep_reward = self.gold_sheep_reward,
    random_bless_range = self.random_bless_range,
    pearl_random_calculate = self.pearl_random_calculate,
    get_current_bless = self.get_current_bless,
    core_bless = self.core_bless,
    hero_reborn_add = self.hero_reborn_add,
    roll_add = self.roll_add,
    refresh_add = self.refresh_add,
    des_energy_add_percent = self.des_energy_add_percent,
    shop_rebate = self.shop_rebate,
    pearl_add_percent = self.pearl_add_percent
  }
end

function class:stage(rogueResult)
  local stageId = rogueResult._params[1]
  local curChapter = self:getCurChapter()
  local battleStatus = curChapter._battle_status
  if battleStatus == "defeat" then
    ed.UITool.openView("rogueBattleFail", {stageId = stageId, showEndFailTips = true})
    return "fail"
  end
  local roomData = self:getRoomData(curChapter._cur_room_id)
  for _, rogueResult in ipairs(roomData.results or {}) do
    if rogueResult._type == "battle_end" then
      return "success"
    end
  end
  ed.UITool.openView("rogueBattlePrepare", {
    mode = "fight",
    stageId = stageId,
    destinyId = curChapter._destiny,
    chapterId = curChapter._chapter_id,
    difficulty = curChapter._difficulty
  })
  return "waiting"
end

function class:team_mp_cut_point(rogueResult)
  return "success"
end

function class:team_mp_cut_percent(rogueResult)
  return "success"
end

function class:team_mp_add_percent(rogueResult)
  return "success"
end

function class:team_mp_add_point(rogueResult)
  return "success"
end

function class:team_hp_cut_point(rogueResult)
  return "success"
end

function class:team_hp_cut_percent(rogueResult)
  return "success"
end

function class:team_hp_add_percent(rogueResult)
  return "success"
end

function class:team_hp_add_point(rogueResult)
  return "success"
end

function class:pearl_add(rogueResult)
  local addAmount = rogueResult._params[1]
  ed.UITool.openView("rogueRewardWindow", {
    type = "add",
    amount = addAmount,
    closeCallBack = function()
      self:continueHandleRogueResult()
    end
  })
  return "waiting"
end

function class:random_destiny_all_bless(rogueResult)
  local blessIdList = rogueResult._params
  self:addNewBlessList(blessIdList)
  ed.UITool.openView("rogueBlessChooseScene", {
    blessIdList = blessIdList,
    chooseAmount = 0,
    refreshTimes = 0,
    refreshMax = 0,
    rogueResult = rogueResult,
    tips = T("\232\142\183\229\190\151\228\186\134\229\134\176\229\165\179\231\140\171\231\154\132\231\164\188\231\137\169\239\188\129"),
    closeCallBack = function()
      self:continueHandleRogueResult()
    end
  })
  return "waiting"
end

function class:enhance_all_bless(rogueResult)
  local blessIdList = rogueResult._params or {}
  if #blessIdList == 0 then
    return "success"
  end
  local curChapter = self:getCurChapter()
  for index, rogueBless in ipairs(curChapter._bless_list or {}) do
    local blessId = rogueBless._bless
    if ed.isElementInTable(blessId, blessIdList) then
      rogueBless._level = 2
    end
  end
  ed.UITool.openView("rogueBlessReinforceWindow", {
    blessIdList = blessIdList,
    closeCallBack = function()
      self:continueHandleRogueResult()
    end
  })
  return "waiting"
end

function class:pearl_store(rogueResult)
  local storeAmount = rogueResult._params[1]
  local curChapter = self:getCurChapter()
  ed.UITool.openView("rogueRewardWindow", {
    type = "lose",
    amount = storeAmount,
    closeCallBack = function()
      self:continueHandleRogueResult()
    end
  })
  return "waiting"
end

function class:pearl_bonus(rogueResult)
  local base = rogueResult._params[1]
  local multiple = rogueResult._params[2]
  local addAmount = base * multiple
  ed.UITool.openView("rogueRewardWindow", {
    type = "add",
    amount = addAmount,
    closeCallBack = function()
      self:continueHandleRogueResult()
    end
  })
  return "waiting"
end

function class:appoint_bless(rogueResult)
  local blessIdList = rogueResult._params or {}
  local chooseAmount = rogueResult._need_choose or 0
  local refreshTimes = rogueResult._refresh_time or 0
  local refreshMax = rogueResult._refresh_max or 0
  local pos = rogueResult._pos or {}
  local blessCfg = ed.getDataTable("RogueBless")[blessIdList[1]]
  local destinyName
  if blessCfg then
    destinyName = ed.getDataTable("RogueDestiny")[blessCfg["Destiny ID"]]["Display Name"]
  end
  if chooseAmount > #pos or chooseAmount == 0 then
    ed.UITool.openView("rogueBlessChooseScene", {
      blessIdList = blessIdList,
      chooseAmount = chooseAmount,
      refreshTimes = refreshTimes,
      refreshMax = refreshMax,
      rogueResult = rogueResult,
      tips = string.format(T("\232\175\183\233\128\137\230\139\1691\228\184\170%s\231\154\132\231\165\157\231\166\143"), destinyName or "")
    })
    return "waiting"
  end
  return "success"
end

function class:retry_times_add(rogueResult)
  return "success"
end

function class:retry_times_cut(rogueResult)
  return "success"
end

function class:normal_bless(rogueResult)
  local blessIdList = rogueResult._params or {}
  local chooseAmount = rogueResult._need_choose or 0
  local refreshTimes = rogueResult._refresh_time or 0
  local refreshMax = rogueResult._refresh_max or 0
  local pos = rogueResult._pos or {}
  if chooseAmount > #pos or chooseAmount == 0 then
    ed.UITool.openView("rogueBlessChooseScene", {
      blessIdList = blessIdList,
      chooseAmount = chooseAmount,
      refreshTimes = refreshTimes,
      refreshMax = refreshMax,
      rogueResult = rogueResult
    })
    return "waiting"
  else
    return "success"
  end
end

function class:pearl_cut(rogueResult)
  local cutAmount = rogueResult._params[1]
  ed.UITool.openView("rogueRewardWindow", {
    type = "lose",
    amount = cutAmount,
    closeCallBack = function()
      self:continueHandleRogueResult()
    end
  })
  return "waiting"
end

function class:pearl_cut_all(rogueResult)
  local curChapter = self:getCurChapter()
  local curAmount = curChapter._pearl or 0
  ed.UITool.openView("rogueRewardWindow", {
    type = "lose",
    amount = curAmount,
    closeCallBack = function()
      self:continueHandleRogueResult()
    end
  })
  return "waiting"
end

function class:reinforced_bless_add(rogueResult)
  local blessIdList = rogueResult._params or {}
  self:addNewBlessList(blessIdList, 2)
  ed.UITool.openView("rogueBlessChooseScene", {
    blessIdList = blessIdList,
    chooseAmount = 0,
    rogueResult = rogueResult,
    tips = T("\232\142\183\229\190\151\228\186\134\229\183\178\229\188\186\229\140\150\231\154\132\231\165\157\231\166\143"),
    closeCallBack = function()
      self:continueHandleRogueResult()
    end
  })
  return "waiting"
end

function class:bless_enhance(rogueResult)
  local blessIdList = rogueResult._params or {}
  local curChapter = self:getCurChapter()
  for index, rogueBless in ipairs(curChapter._bless_list or {}) do
    if ed.isElementInTable(rogueBless._bless, blessIdList) then
      rogueBless._level = 2
    end
  end
  local tipStr
  if rogueResult._from == "charm" then
    tipStr = T("\231\148\177\228\186\142\230\138\164\231\172\166\230\149\136\230\158\156\239\188\140\231\165\157\231\166\143\232\142\183\229\190\151\228\186\134\229\188\186\229\140\150")
  else
    tipStr = T("\231\165\157\231\166\143\232\142\183\229\190\151\228\186\134\229\188\186\229\140\150")
  end
  ed.UITool.openView("rogueBlessReinforceWindow", {
    blessIdList = blessIdList,
    tips = tipStr,
    closeCallBack = function()
      self:continueHandleRogueResult()
    end
  })
  return "waiting"
end

function class:low_bless_cut(rogueResult)
  local blessIdList = rogueResult._params or {}
  local chooseAmount = rogueResult._need_choose or 0
  local pos = rogueResult._pos or {}
  if chooseAmount > #pos or chooseAmount == 0 then
    ed.UITool.openView("rogueBlessChooseScene", {
      blessIdList = blessIdList,
      chooseAmount = chooseAmount,
      rogueResult = rogueResult,
      tips = T("\232\175\183\233\128\137\230\139\169\230\138\155\229\188\1311\228\184\170\231\165\157\231\166\143"),
      type = "delete_bless"
    })
    return "waiting"
  end
  return "success"
end

function class:total_bless_cut(rogueResult)
  local blessIdList = rogueResult._params or {}
  local chooseAmount = rogueResult._need_choose or 0
  local pos = rogueResult._pos or {}
  if chooseAmount > #pos or chooseAmount == 0 then
    ed.UITool.openView("rogueBlessChooseScene", {
      blessIdList = blessIdList,
      chooseAmount = chooseAmount,
      rogueResult = rogueResult,
      tips = T("\232\175\183\233\128\137\230\139\169\230\138\155\229\188\1311\228\184\170\231\165\157\231\166\143"),
      type = "delete_bless"
    })
    return "waiting"
  end
  return "success"
end

function class:weakest_hero_cure(rogueResult)
  local heroIdList = rogueResult._params
  return "success"
end

function class:hero_reborn(rogueResult)
  local heroIdList = rogueResult._params
  ed.rogueLikeNet.sendSyncHeroInfos()
  return "success"
end

function class:kill_hero(rogueResult)
  local heroIdList = rogueResult._params
  return "success"
end

function class:bought_bless(rogueResult)
  return "success"
end

function class:hero_add(rogueResult)
  local chooseHeroAmount = rogueResult._need_choose or 0
  local pos = rogueResult._pos or {}
  local curChapter = self:getCurChapter()
  if 0 < chooseHeroAmount and chooseHeroAmount > #pos then
    ed.UITool.openView("rogueBattlePrepare", {
      selectHeroAmount = chooseHeroAmount,
      mode = "add_hero",
      destinyId = curChapter._destiny,
      chapterId = curChapter._chapter_id,
      difficulty = curChapter._difficulty
    })
    return "waiting"
  end
  return "success"
end

function class:battle_end(rogueResult)
  return "success"
end

function class:revelation_pick(rogueResult)
  local blessIdList = rogueResult._params or {}
  local chooseAmount = rogueResult._need_choose or 0
  local refreshTimes = rogueResult._refresh_time or 0
  local refreshMax = rogueResult._refresh_max or 0
  local pos = rogueResult._pos or {}
  if chooseAmount > #pos or chooseAmount == 0 then
    local curChapter = self:getCurChapter() or {}
    local destinyId = curChapter._destiny
    local collectAmount = 0
    for index, rogueBless in ipairs(curChapter._bless_list or {}) do
      local blessId = rogueBless._bless
      local isDestinyBless = ed.isElementInTable(blessId, ed.getDataTable("RogueDestiny")[destinyId].DestinyBless)
      if ed.getDataTable("RogueBless")[blessId]["Destiny ID"] == destinyId and isDestinyBless then
        collectAmount = collectAmount + 1
      end
    end
    ed.UITool.openView("rogueBlessChooseScene", {
      blessIdList = blessIdList,
      chooseAmount = chooseAmount,
      refreshTimes = refreshTimes,
      refreshMax = refreshMax,
      rogueResult = rogueResult,
      tips = string.format(T("\229\183\178\230\148\182\233\155\134<lable color=ccc3(243,123,27)>%s</lable>\228\184\170%s\231\154\132\231\165\157\231\166\143\239\188\140\232\175\183\233\128\137\230\139\1691\228\184\170\230\183\177\229\186\166\229\144\175\231\164\186"), collectAmount, ed.getDataTable("RogueDestiny")[destinyId]["Display Name"])
    })
    return "waiting"
  end
  return "success"
end

function class:normal_sheep_reward(rogueResult)
  local blessIdList = rogueResult._params or {}
  local chooseAmount = rogueResult._need_choose or 0
  local refreshTimes = rogueResult._refresh_time or 0
  local refreshMax = rogueResult._refresh_max or 0
  local pos = rogueResult._pos or {}
  if chooseAmount > #pos or chooseAmount == 0 then
    ed.UITool.openView("rogueBlessChooseScene", {
      blessIdList = blessIdList,
      chooseAmount = chooseAmount,
      refreshTimes = refreshTimes,
      refreshMax = refreshMax,
      rogueResult = rogueResult,
      tips = T("\228\189\160\230\138\147\228\189\143\228\186\134\229\176\143\231\190\138\239\188\140\232\175\183\233\128\137\230\139\1691\228\184\170\231\165\157\231\166\143")
    })
    return "waiting"
  end
  return "success"
end

function class:gold_sheep_reward(rogueResult)
  local blessIdList = rogueResult._params or {}
  local chooseAmount = rogueResult._need_choose or 0
  local refreshTimes = rogueResult._refresh_time or 0
  local refreshMax = rogueResult._refresh_max or 0
  local pos = rogueResult._pos or {}
  if chooseAmount > #pos or chooseAmount == 0 then
    ed.UITool.openView("rogueBlessChooseScene", {
      blessIdList = blessIdList,
      chooseAmount = chooseAmount,
      refreshTimes = refreshTimes,
      refreshMax = refreshMax,
      rogueResult = rogueResult,
      tips = T("\228\189\160\230\138\147\228\189\143\228\186\134\233\135\145\231\190\138\239\188\140\232\175\183\233\128\137\230\139\1691\228\184\170\231\165\157\231\166\143")
    })
    return "waiting"
  end
  return "success"
end

function class:random_bless_range(rogueResult)
  local blessIdList = rogueResult._params or {}
  self:addNewBlessList(blessIdList)
  local tipStr
  if rogueResult._from == "charm" then
    tipStr = T("\231\148\177\228\186\142\230\138\164\231\172\166\230\149\136\230\158\156\239\188\140\232\142\183\229\190\151\228\186\134%d\228\184\170\231\165\157\231\166\143", #blessIdList)
  else
    tipStr = T("\232\142\183\229\190\151\228\186\134\233\154\143\230\156\186\231\165\157\231\166\143")
  end
  ed.UITool.openView("rogueBlessChooseScene", {
    blessIdList = blessIdList,
    chooseAmount = 0,
    rogueResult = rogueResult,
    tips = tipStr,
    closeCallBack = function()
      self:continueHandleRogueResult()
    end
  })
  return "waiting"
end

function class:pearl_random_calculate(rogueResult)
  local curChapter = self:getCurChapter()
  local params = rogueResult._params
  local baseNum = params[1]
  local resultList = {}
  for index = 2, #params, 2 do
    local operator = params[index]
    local num = params[index + 1]
    if operator == 1 then
      baseNum = baseNum + num
      table.insert(resultList, {type = "add", amount = num})
    elseif operator == 2 then
      baseNum = baseNum - num
      table.insert(resultList, {type = "lose", amount = num})
    elseif operator == 3 then
      local addAmount = baseNum * num - baseNum
      baseNum = baseNum * num
      table.insert(resultList, {type = "add", amount = addAmount})
    end
  end
  ed.UITool.openView("rogueRewardWindow", {
    amountList = resultList,
    closeCallBack = function()
      self:continueHandleRogueResult()
    end
  })
  return "waiting"
end

function class:get_current_bless(rogueResult)
  local blessIdList = rogueResult._params or {}
  local chooseAmount = rogueResult._need_choose or 0
  local refreshTimes = rogueResult._refresh_time or 0
  local refreshMax = rogueResult._refresh_max or 0
  local pos = rogueResult._pos or {}
  if chooseAmount > #pos or chooseAmount == 0 then
    ed.UITool.openView("rogueBlessChooseScene", {
      blessIdList = blessIdList,
      chooseAmount = chooseAmount,
      refreshTimes = refreshTimes,
      refreshMax = refreshMax,
      rogueResult = rogueResult,
      tips = T("\231\148\177\228\186\142\230\132\159\230\130\159\231\172\148\232\174\176\239\188\140\232\175\183\233\162\157\229\164\150\233\128\137\230\139\1691\228\184\170\231\165\157\231\166\143")
    })
    return "waiting"
  else
    return "success"
  end
end

function class:core_bless(rogueResult)
  local blessIdList = rogueResult._params or {}
  local chooseAmount = rogueResult._need_choose or 0
  local refreshTimes = rogueResult._refresh_time or 0
  local refreshMax = rogueResult._refresh_max or 0
  local pos = rogueResult._pos or {}
  if chooseAmount > #pos or chooseAmount == 0 then
    ed.UITool.openView("rogueBlessChooseScene", {
      blessIdList = blessIdList,
      chooseAmount = chooseAmount,
      refreshTimes = refreshTimes,
      refreshMax = refreshMax,
      rogueResult = rogueResult
    })
    return "waiting"
  else
    return "success"
  end
end

function class:hero_reborn_add(rogueResult)
  return "success"
end

function class:roll_add(rogueResult)
  return "success"
end

function class:refresh_add(rogueResult)
  return "success"
end

function class:des_energy_add_percent(rogueResult)
  return "success"
end

function class:shop_rebate(rogueResult)
  local addAmount = rogueResult._params[1]
  ed.UITool.openView("rogueRewardWindow", {
    type = "add",
    amount = addAmount,
    closeCallBack = function()
      self:continueHandleRogueResult()
    end
  })
  return "waiting"
end

function class:pearl_add_percent(rogueResult)
  local addAmount = rogueResult._params[1]
  ed.UITool.openView("rogueRewardWindow", {
    type = "add",
    amount = addAmount,
    closeCallBack = function()
      self:continueHandleRogueResult()
    end
  })
  return "waiting"
end
