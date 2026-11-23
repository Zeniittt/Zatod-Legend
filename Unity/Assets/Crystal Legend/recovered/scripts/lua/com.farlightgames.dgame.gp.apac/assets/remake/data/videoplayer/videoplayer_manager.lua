module("ed.videoplayer", package.seeall)
manager = {}
manager.__index = manager

function manager.create()
  local object = {}
  setmetatable(object, manager)
  object:initData()
  object:registerEventHandler()
  return object
end

function manager:initData()
  self.currentVideoId = nil
  self.myVideo = false
end

function manager:getCurrentVideoId()
  return self.currentVideoId
end

function manager:isMyVideo()
  return self.myVideo
end

function manager:sendplayerVideo(videoid)
  network:sendQueryVideo(videoid)
end

function manager:queryVideoSummary(videoid)
  network:sendQueryVideoSummary(videoid)
end

function manager:addMyBarrage(sendText, colorflag)
  self.sendText = sendText
  self.colorflag = colorflag
end

function manager:registerEventHandler()
  ListenEvent("send_barrage_reply", function(info)
    self:doSendBarrageReply(info)
  end)
  ListenEvent("video_data_reply", function(info)
    self:doVideoDataReply(info)
  end)
  ListenEvent("barrage_data_reply", function(info)
    self:doBarrageDataReply(info)
  end)
end

function manager:doSendBarrageReply(info)
  if info == "success" and self.sendText and self.colorflag then
    ed.scene:addMyBarrage(self.sendText, self.colorflag)
    self.sendText = nil
    self.colorflag = nil
  end
end

function manager:doVideoDataReply(info)
  self:initVideoData(info)
  self:playVideo(info)
  network:sendQueryBarrage(info._id)
end

function manager:initVideoData(info)
  self.currentVideoId = info._id
  if info._battle_module == "dreamland" then
    for _, user in ipairs(info._video_user) do
      if self:userIsMy(user._user_key) then
        self.myVideo = true
      end
    end
  end
end

function manager:userIsMy(userkey)
  return userkey._svr_id == tonumber(game_server_id) and userkey._uid == tonumber(ed.getUserid())
end

function manager:doBarrageDataReply(info)
  local barrageList = info._content or {}
  local barrageArray = {}
  for _, barrage in ipairs(barrageList) do
    local tick = barrage._tick
    if not barrageArray[tick] then
      barrageArray[tick] = {}
    end
    table.insert(barrageArray[tick], barrage)
  end
  ed.scene:resetBarrage(barrageArray)
  if ed.videoplayer.battleEnd then
    ed.videoplayer.battleEnd:setBarrage(barrageArray)
  end
  local barrageUserList = info._user_map or {}
  local userSummaryList = {}
  for i, userInfo in ipairs(barrageUserList) do
    local userKey = userInfo._user_key
    userSummaryList[userKey._svr_id .. "-" .. userKey._uid] = userInfo._user_summary
  end
  self.userSummaryList = userSummaryList
end

function manager:getUserSummary(sid, uid)
  return self.userSummaryList[sid .. "-" .. uid] or {}
end

function manager:playVideo(info)
  local stage = ed.lookupDataTable("Stage", nil, info._stage_id)
  local operations = self:getOperations(info)
  local manualBattle = self:getManualBattle(info)
  local multiMode = self:getMultiMode(info)
  local param = {
    stageInfo = stage,
    heroList = info._heroes,
    bookReadingLevel = 0,
    operations = operations,
    rseed = info._rseed,
    mode = info._battle_module,
    manualBattle = manualBattle,
    multiMode = multiMode,
    stageBuff = info._scene_buff
  }
  self:enterBattle(param, info)
  ed.videoplayer.battleEnd = endlayer.create(param, info)
end

function manager:getManualBattle(info)
  if info._battle_type == "multi_pve" then
    return true
  else
    return false
  end
end

function manager:getMultiMode(info)
  if info._battle_type == "multi_pve" then
    return true
  else
    return false
  end
end

function manager:enterBattle(param, info)
  ed.startBattleTime = info._timestamp
  ed.srand(info._rseed)
  ed.engine:enterVideoPlayer(param)
  battle_tick.enterReplayMode(true)
  local battle = ed.lookupDataTable("Battle", nil, info._stage_id, 1)
  ed.scene:reset(param.stageInfo, battle, {
    videoplayer = {
      checkid = info._id,
      mode = info._battle_module
    }
  })
  ed.pushScene(ed.scene)
end

function manager:getOperations(info)
  if info._battle_type == "single_pve" or info._battle_type == "single_pvp" then
    return info._single_ops
  else
    local operations = self:getMultiOperations(info)
    return operations
  end
end

function manager:getMultiOperations(info)
  local heroes = self:sortHeroes(info._heroes)
  if info._stage_id == 20105 then
    for idx, hero in ipairs(heroes) do
      if hero._tid == 10001 then
        heroes[1], heroes[idx] = heroes[idx], heroes[1]
        break
      end
    end
  end
  local heroDevice = {}
  for _, user in ipairs(info._battle_user) do
    for _, tid in ipairs(user._select_hero_id or {}) do
      heroDevice[tid] = user._key
    end
  end
  local tickList = {}
  for _, operation in ipairs(info._multi_ops or {}) do
    local tick = operation._tick
    local opList = self:getOpList(heroes, operation, heroDevice)
    for _, op in ipairs(opList) do
      if op.op == ed.opControlTarget or op.op == ed.opControlTouch then
        local v = ed.makebits(4, op.index, 7, op.ext[1], 6, op.ext[2], 3, op.op)
        local param = {_tick = tick, _operation = v}
        table.insert(tickList, param)
      else
        local v = ed.makebits(4, op.index, 5, op.order, 3, op.op)
        local param = {_tick = tick, _operation = v}
        table.insert(tickList, param)
      end
    end
  end
  return tickList
end

function manager:getOpList(heroes, operation, heroDevice)
  local opList = {}
  for _, unit in ipairs(operation._unit or {}) do
    local deviceid = unit._key
    for _, op in ipairs(unit._ops or {}) do
      local optype = ed.splitbits(op, 3)
      local index, order, idx, dsIdx, opp
      if optype == ed.opControlTarget or optype == ed.opControlTouch then
        index, idx, dsIdx, opp = ed.splitbits(op, 4, 7, 6, 3)
        local hero = heroes[index] or {}
        local isSame = self:isSameDeviceId(deviceid, heroDevice[hero._tid or 0])
        if isSame then
          table.insert(opList, {
            index = index,
            ext = {idx, dsIdx},
            op = opp
          })
        end
      else
        index, order, opp = ed.splitbits(op, 4, 5, 3)
        local hero = heroes[index] or {}
        local isSame = self:isSameDeviceId(deviceid, heroDevice[hero._tid or 0])
        if isSame then
          table.insert(opList, {
            index = index,
            order = order,
            op = opp
          })
        end
      end
    end
  end
  return opList
end

function manager:isSameDeviceId(deviceid1, deviceid2)
  if not deviceid1 or not deviceid2 then
    return false
  end
  return deviceid1._uid == deviceid2._uid and deviceid1._svr_id == deviceid2._svr_id
end

function manager:sortHeroes(heroes)
  local newHeroes = {}
  for _, hero in ipairs(heroes) do
    local index = 0
    local aRange = self:getHeroMaxRange(hero._tid)
    for idx, new in ipairs(newHeroes) do
      local bRange = self:getHeroMaxRange(new._tid)
      if aRange < bRange then
        index = idx
        break
      end
    end
    if index ~= 0 then
      table.insert(newHeroes, index, hero)
    else
      table.insert(newHeroes, hero)
    end
  end
  return newHeroes
end

function manager:getHeroMaxRange(hid)
  local basicSkill = ed.getDataTable("Unit")[hid]["Basic Skill"]
  local maxRange = ed.getDataTable("Skill")[basicSkill][0]["Max Range"]
  return maxRange
end

function manager:getMsbDynaData(info)
  local self_dyna_data = {}
  for i, h in ipairs(info._heroes) do
    self_dyna_data[h._tid] = info._self_dyna_start[i]
  end
  return self_dyna_data
end

manager = manager.create()
