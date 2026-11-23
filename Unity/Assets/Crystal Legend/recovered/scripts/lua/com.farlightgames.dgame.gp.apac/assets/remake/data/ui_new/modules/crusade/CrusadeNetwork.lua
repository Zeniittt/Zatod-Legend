local CrusadeNetwork = {}
CrusadeNetwork.__index = CrusadeNetwork

function CrusadeNetwork.isDebug()
  return false
end

function CrusadeNetwork.getInstance()
  if not CrusadeNetwork.instance then
    CrusadeNetwork.instance = CrusadeNetwork.create()
  end
  return CrusadeNetwork.instance
end

function CrusadeNetwork.create()
  local self = {}
  setmetatable(self, CrusadeNetwork)
  return self
end

function CrusadeNetwork:dispatch(msg)
  if self.isDebug() then
    print("---------------CrusadeNetwork:dispatchReply----------------")
    ed.pt(msg)
  end
  if msg._open_panel then
    ed.CrusadeManager:handleOpenPanel(msg._open_panel)
  elseif msg._query_oppo then
    ed.CrusadeManager:handleQueryOppo(msg._query_oppo)
  elseif msg._start_bat then
    ed.CrusadeManager:handleBattleStart(msg._start_bat)
  elseif msg._end_bat then
    ed.CrusadeManager:handleBattleEnd(msg._end_bat)
  elseif msg._reset then
    if msg._reset._result == "success" then
      ed.CrusadeManager.rushTimes = false
      ed.CrusadeManager:handleResetCrusade(msg._reset)
    end
  elseif msg._draw_reward then
    ed.CrusadeManager:handleGetReward(msg._draw_reward)
  elseif msg._battle_record then
    ed.CrusadeManager:handleBattleRecord(msg._battle_record)
  elseif msg._query_replay then
    ed.CrusadeManager:handleQueryReplay(msg._query_replay)
  elseif msg._query_summary then
    ed.CrusadeManager:handleQuerySummary(msg._query_summary)
  elseif msg._revive_hero then
    ed.CrusadeManager:handleReliveHero(msg._revive_hero)
  elseif msg._weekly_reward then
    ed.CrusadeManager:handleGetWeeklyReward(msg._weekly_reward)
  elseif msg._tbc_rush then
    ed.CrusadeManager:handleTbcRush(msg._tbc_rush)
    self.getRushReward(msg._tbc_rush)
  end
end

function CrusadeNetwork:createReq()
  local req = ed.upmsg.tbc()
  return req
end

function CrusadeNetwork:sendReq(req)
  if self.isDebug() then
    print("-------------CrusadeNetwork:sendReq--------------")
    ed.pt(req)
  end
  ed.send(req, "tbc")
end

function CrusadeNetwork:sendOpenPanel()
  local req = self:createReq()
  req._open_panel = {}
  self:sendReq(req)
end

function CrusadeNetwork:showHotHero()
  function ed.netreply.herorecommend(data)
    if #data == 0 then
      ed.showToast(T("\230\154\130\230\151\160\231\131\173\233\151\168\232\139\177\233\155\132"))
      
      return
    end
    local mgr = ed.herorecommend.mainpanelMgr.create(data)
    local info = mgr.classifyInfoList[2]
    local hotlist = ed.herorecommend.hotlist.create({
      heroes = info.heroes,
      modeid = info.modeid
    })
    hotlist:popWindow(10)
  end
  
  ed.herorecommend.network:sendOpenPanel()
end

function CrusadeNetwork:showBattleRecord()
  local req = self:createReq()
  req._battle_record = ed.upmsg.tbc_battle_record()
  self:sendReq(req)
end

function CrusadeNetwork:resetBattle(mode)
  local req = self:createReq()
  req._reset = {}
  req._reset._mode = mode
  self:sendReq(req)
end

function CrusadeNetwork:drawReward(index)
  local req = self:createReq()
  req._draw_reward = {}
  req._draw_reward._stage_id = index
  self:sendReq(req)
end

function CrusadeNetwork:reqEnemyInfo(index)
  local req = self:createReq()
  req._query_oppo = {}
  req._query_oppo._stage_id = index
  self:sendReq(req)
end

function CrusadeNetwork:reliveHero(heroId, isHire)
  local msg = ed.upmsg.tbc()
  msg._revive_hero = ed.upmsg.tbc_revive_hero()
  msg._revive_hero._heroid = heroId
  msg._revive_hero._is_hire = isHire
  ed.send(msg, "tbc")
end

function CrusadeNetwork:queryReply(recordid)
  local msg = ed.upmsg.tbc()
  msg._query_replay = ed.upmsg.query_replay()
  msg._query_replay._record_index = recordid
  ed.send(msg, "tbc")
end

function CrusadeNetwork:querySummary(recordid)
  local msg = ed.upmsg.tbc()
  msg._query_summary = ed.upmsg.query_summary()
  msg._query_summary._record_index = recordid
  ed.send(msg, "tbc")
end

function CrusadeNetwork:getWeeklyReward()
  local msg = ed.upmsg.tbc()
  msg._weekly_reward = ed.upmsg.tbc_weekly_reward()
  ed.send(msg, "tbc")
end

local function readSweepReward(info)
  local list = {}
  for _, loot in pairs(info.loots or {}) do
    local goldNum = loot.gold or 0
    local ll = {
      exp = 0,
      money = goldNum,
      loots = {}
    }
    for _, item in pairs(loot.items or {}) do
      table.insert(ll.loots, {
        id = item.id,
        amount = item.amount
      })
    end
    table.insert(list, ll)
  end
  local el = {
    loots = {}
  }
  for k, v in pairs(info.items or {}) do
    table.insert(el.loots, {
      name = v.name,
      type = v.type,
      scale = v.scale,
      amount = v.amount,
      add_amount = v.add_amount or 0
    })
  end
  table.insert(list, el)
  return list
end

local function showRushRewardResult(data)
  local rushRewards = {
    loots = {},
    items = {}
  }
  local point = 0
  local bean = 0
  local add_bean = data._extra_bean or 0
  for k, rwd in ipairs(data._tbc_rush_stage) do
    local oneLoot = {
      gold = 0,
      items = {}
    }
    for i, v in ipairs(rwd._rewards) do
      if v._type == "item" then
        local id = v._id
        local amount = v._amount
        table.insert(oneLoot.items, {id = id, amount = amount})
      elseif v._type == "gold" then
        oneLoot.gold = v._amount
      elseif v._type == "crusadepoint" then
        point = point + v._amount
      end
    end
    table.insert(rushRewards.loots, oneLoot)
    if rwd._energy_bean ~= 0 then
      bean = bean + rwd._energy_bean
    end
    ed.record:refreshCommonRecord("completeCrusadeStage")
  end
  if 0 < point then
    table.insert(rushRewards.items, {
      name = T(""),
      type = "crusadepoint",
      scale = 1,
      amount = point
    })
  end
  if 0 < bean then
    table.insert(rushRewards.items, {
      name = T(""),
      type = "energybean",
      scale = 1,
      amount = bean,
      add_amount = add_bean
    })
  end
  local lootList = readSweepReward(rushRewards)
  local sweepWindow = ed.ui.repeatRewardWindow.create(lootList)
  sweepWindow:popWindow()
  
  function sweepWindow.destroyCallback()
    ed.CrusadeManager.LocalObjData.isAdvanceTeam = false
    ed.CrusadeNetwork:sendOpenPanel()
  end
end

function CrusadeNetwork.getRushReward(rewards)
  if not rewards or not rewards._tbc_rush_stage then
    return
  end
  for k, info in ipairs(rewards._tbc_rush_stage) do
    ed.player:addRewards(info._rewards)
    if info._energy_bean then
      ed.player:setEnergyBeanNum(ed.player:getEnergyBeanNum() + info._energy_bean)
    end
  end
  local add_bean = rewards._extra_bean or 0
  ed.player:setEnergyBeanNum(ed.player:getEnergyBeanNum() + add_bean)
  showRushRewardResult(rewards)
end

ed.CrusadeNetwork = CrusadeNetwork.getInstance()
