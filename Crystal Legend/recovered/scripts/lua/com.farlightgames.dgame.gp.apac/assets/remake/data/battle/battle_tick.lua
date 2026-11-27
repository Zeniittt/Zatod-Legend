module("battle_tick", package.seeall)
local isHost = true
local teamIndex = 1
HOST = 1
GUEST = 0
local selfOperations = {}
local selfOriginalOperations = {}
local targetOperations = {}
local delayTicks = 0
local noBolckTicks = 5
local heartbeat_tick_interval = 120
local realTimePvp = false
local multiPvp = false
local replayMode
local currentAckTick = 0
local mpOperations = {}
local mpTimePvp = false
local tickBuff

local function log(...)
  local s = string.format(...)
  if tickBuff then
    tickBuff:append(s)
    tickBuff:append("\n")
  end
end

local function addOperation(operations, tick, opType)
  local validNum = 0
  if not operations then
    return validNum
  end
  for _, v in ipairs(operations) do
    local operation = {
      op = v.op,
      tick = tick,
      unit_index = v.unit_index,
      ext = v.ext,
      slot = v.slot,
      isHost = v.isHost,
      hid = v.hid,
      teamIndex = v.teamIndex
    }
    if opType == nil or opType == v.op then
      table.insert(ed.engine.operation_list, operation)
      if v.op == ed.opManualSkill and (not v.slot or v.slot == 1) then
        validNum = validNum + 1
      end
    end
  end
  return validNum
end

local function addAllOperation(mode, tick)
  local useTick = math.max(0, tick - delayTicks)
  if mode == "host" then
    local validNum = addOperation(selfOperations[useTick], tick)
    addOperation(targetOperations[useTick], tick, validNum ~= 0 and 5 or nil)
  else
    local validNum = addOperation(targetOperations[useTick], tick)
    addOperation(selfOperations[useTick], tick, validNum ~= 0 and 5 or nil)
  end
end

function init(host)
  selfOperations = {}
  selfOriginalOperations = {}
  targetOperations = {}
  isHost = host or true
  realTimePvp = false
  tickBuff = ed.StringBufferCreate()
  currentAckTick = 0
  replayMode = nil
end

function getCurrentTick()
  return currentAckTick
end

function isReplayMode()
  return replayMode
end

function enterReplayMode()
  replayMode = true
end

function setRealTimePvp(turn)
  realTimePvp = turn
end

function getRealTimePvp()
  return realTimePvp
end

function setMultiPvp(turn)
  multiPvp = turn
end

function getMultPvp()
  return multiPvp
end

function setHost(host)
  isHost = host
end

function getHost()
  return isHost
end

function setTeamIndex(index)
  teamIndex = index
end

function getTeamIndex()
  return teamIndex
end

local function sendSelfOperation(tick)
  local ops = makebitOperations(selfOriginalOperations[tick])
  if 0 < #ops then
    local msg = ed.upmsg.real_pvp()
    msg._sync_operations = ed.upmsg.sync_operations()
    msg._sync_operations._device_id = ed.my_device_id or ""
    local op_data = ed.upmsg.sync_operation()
    op_data._tick = tick
    op_data._operation = ops
    msg._sync_operations._ops = {op_data}
    ed.socket_udp:SendMsg("real_pvp", msg)
  end
end

local function sendHeartbeat()
  local msg = ed.upmsg.real_pvp()
  msg._udp_penetrate = ed.upmsg.udp_penetrate()
  msg._udp_penetrate._device_id = ed.my_device_id or ""
  ed.socket_udp:SendMsg("real_pvp", msg)
end

function submitOperation(tick)
  if not realTimePvp then
    return
  end
  if ed.run_with_scene and replayMode == nil then
    local temp = tick % heartbeat_tick_interval
    if ed.IsMultiArena() then
      local ops = makebitOperations(selfOriginalOperations[tick])
      if 0 < #ops then
        ed.CrArenaNetwork:sendSelfOperation(tick, ops)
      end
    else
      if temp == 1 then
        sendHeartbeat()
      end
      sendSelfOperation(tick)
    end
  end
  local useTick = math.max(0, tick - delayTicks)
  local opp = tick % 2
  if isHost then
    if opp == 1 then
      addAllOperation("host", tick)
    else
      addAllOperation("nohost", tick)
    end
  elseif opp == 1 then
    addAllOperation("nohost", tick)
  else
    addAllOperation("host", tick)
  end
end

function addSelfOperation(operation)
  if realTimePvp or mpTimePvp then
    if not selfOriginalOperations[operation.tick] then
      selfOriginalOperations[operation.tick] = {}
    end
    table.insert(selfOriginalOperations[operation.tick], operation)
  else
    table.insert(ed.engine.operation_list, operation)
  end
end

function setTargetOperation(tick, operations)
  if not tick then
    return
  end
  if targetOperations[tick] then
    return
  end
  targetOperations[tick] = splitOperations(operations or {})
end

function setSelfOperation(tick, operations)
  if not tick then
    return
  end
  if selfOperations[tick] then
    return
  end
  selfOperations[tick] = splitOperations(operations or {})
end

function canUpdate(dt)
  if not realTimePvp and not mpTimePvp then
    return true
  end
  if replayMode then
    return true
  end
  jumpTicks()
  local currentTicks = ed.engine.ticks
  if currentTicks <= noBolckTicks then
    ed.engine.driveByTypes = "noBolck"
    return true
  end
  local nextTick = ed.engine.next_tick - dt * ed.engine:getSpeedRate()
  if 0 < nextTick then
    ed.engine.driveByTypes = "nextTick"
    return true
  end
  if realTimePvp then
    local myOps = selfOperations[currentTicks - delayTicks]
    local targetOps = targetOperations[currentTicks - delayTicks]
    if myOps and targetOps then
      ed.engine.driveByTypes = "Ops"
      return true
    end
  end
  if mpTimePvp then
    local mpOps = mpOperations[currentTicks]
    if mpOps then
      return true
    end
  end
  return false
end

function jumpTicks()
  local maxTick = currentAckTick
  local currentTick = ed.engine.ticks
  local dif = maxTick - currentTick
  if 1 < dif then
    ed.engine:setSpeedRate(100)
  else
    ed.engine:setSpeedRate(1)
    ed.engine.recovering = false
  end
end

function DumpLog()
  local folder = CCFileUtils:sharedFileUtils():getWritablePath()
  if EDFLAGWIN32 then
    folder = "btlog"
  end
  local path = string.format("%s/%s%s.log", folder, os.date("%Y-%m-%d %H-%M-%S"), ed.config.device_id)
  local file = io.open(path, "w")
  if file then
    file:write(tostring(tickBuff))
    file:close()
  end
end

function getLog()
  return tostring(tickBuff)
end

local function syncOperations(data)
  if not data then
    return true
  end
  setSelfOperation(data._tick, data._self_ops)
  setTargetOperation(data._tick, data._oppo_ops)
end

function initMp()
  mpTimePvp = false
  currentAckTick = 0
  mpOperations = {}
  selfOriginalOperations = {}
end

function sendMpOperation(tick)
  local ops = makebitOperations(selfOriginalOperations[tick])
  if 0 < #ops then
    if ed.engine.multiplayerMode then
      ed.multiplayer_network:sendSelfOperation(ed.multiplayer_udp, tick, ops)
    elseif ed.engine.multistageTeamwork_mode then
      ed.multistage.msnetwork:sendSelfOperation(ed.multistage_udp, tick, ops)
    end
  end
end

function receiveMpOperation(data)
  if not data then
    return
  end
  for nowTick = currentAckTick + 1, data._cur_tick do
    mpOperations[nowTick] = {}
  end
  for _, oper in ipairs(data._operations or {}) do
    local nowTick = oper._tick
    mpOperations[nowTick] = parseOperations(oper)
  end
  currentAckTick = data._cur_tick
end

function parseOperations(oper)
  local opList = {}
  for _, unit in ipairs(oper._unit or {}) do
    local outList = checkOperations(unit)
    for _, v in ipairs(outList) do
      local param = splitSingleOperation(v)
      table.insert(opList, param)
    end
  end
  return opList
end

function checkOperations(op_unit)
  local outList = {}
  for _, value in ipairs(op_unit._ops) do
    local op = ed.splitbits(value, 3)
    local index
    if op == ed.opControlTarget or op == ed.opControlTouch then
      index = ed.splitbits(value, 4, 7, 6, 3)
    elseif op == ed.opEnergyBean then
      index = ed.splitbits(value, 4, 3)
    else
      index = ed.splitbits(value, 4, 5, 3)
    end
    local unit = ed.engine.unit_list[index]
    if unit and ed.multiplayer_battle:checkOwner(op_unit._key, unit.tid) then
      table.insert(outList, value)
    else
      print("***/ [Find Unit] " .. index .. " : " .. (unit and unit.tid or "nil"))
    end
  end
  return outList
end

function submitMpOperation(tick)
  if not mpTimePvp then
    return
  end
  if ed.run_with_scene then
    sendMpOperation(tick)
  end
  addOperation(mpOperations[tick], tick)
end

function setMpTimePvp(turn)
  mpTimePvp = turn
end

function getMpTimePvp()
  return mpTimePvp
end

local function OnRealPvpRsp(data, udp)
  if not data then
    return
  end
  for i, operation in ipairs(data._ops or {}) do
    syncOperations(operation)
  end
  for i = currentAckTick + 1, data._cur_tick do
    syncOperations({_tick = i})
  end
  currentAckTick = data._cur_tick
  local msg_new = ed.upmsg.real_pvp()
  msg_new._sync_acks = ed.upmsg.sync_acks()
  msg_new._sync_acks._device_id = ed.my_device_id or ""
  msg_new._sync_acks._tick = currentAckTick
  udp:SendMsg("real_pvp", msg_new)
end

local function OnMultiPlayerOperation(data)
  receiveMpOperation(data)
end

local function OnMultiRsp(data)
  if not data then
    return
  end
  for i, operation in ipairs(data._operations or {}) do
    syncOperations(operation)
  end
  for i = currentAckTick + 1, data._cur_tick do
    syncOperations({_tick = i})
  end
  currentAckTick = data._cur_tick
end

if ed.run_with_scene then
  ListenEvent("RealPVPSync", OnRealPvpRsp)
  ListenEvent("Mp_MultiplayerOperations", OnMultiPlayerOperation)
  ListenEvent("MultiSync", OnMultiRsp)
end

function splitSingleOperation(oprs)
  if ed.opBitWidth4 then
    local op_width4 = ed.splitbits(oprs, 4)
    if op_width4 == ed.opDamageToBoss then
      local player_index, damage, op = ed.splitbits(oprs, 4, 24, 4)
      return {
        op = op,
        player_index = player_index,
        damage = damage
      }
    end
  end
  local op = ed.splitbits(oprs, 3)
  if op == ed.opKaelTapBall then
    local uidx, idx, dsIdx, op = ed.splitbits(oprs, 4, 9, 2, 3)
    return {
      op = op,
      unit_index = uidx,
      ext = {idx, dsIdx}
    }
  elseif op == ed.opJoinHeroBattle or op == ed.opJoinMagicBattle then
    local uidx, idx, dsIdx, isHost, teamIndex, op = ed.splitbits(oprs, 8, 10, 9, 1, 1, 3)
    return {
      op = op,
      hid = uidx,
      ext = {idx, dsIdx},
      isHost = isHost,
      teamIndex = teamIndex + 1
    }
  elseif op == ed.opManualSkill then
    local index, order, op = ed.splitbits(oprs, 10, 5, 3)
    local slot = ed.engine:getSlotByOrder(index, order)
    return {
      op = op,
      unit_index = index,
      slot = slot
    }
  elseif op == ed.opEnergyBean then
    local uidx, op = ed.splitbits(oprs, 4, 3)
    return {op = op, unit_index = uidx}
  elseif op == ed.opJoinEchoSkill then
    local echoId, op = ed.splitbits(oprs, 16, 3)
    return {op = op, echoId = echoId}
  elseif op == ed.opExitBattle then
    return {op = op}
  else
    EDDebug("invalid operation " .. oprs)
  end
end

function splitOperations(operations)
  local opList = {}
  if not operations then
    return opList
  end
  for _, v in ipairs(operations) do
    local param = splitSingleOperation(v)
    table.insert(opList, param)
  end
  return opList
end

function makeSingleOperation(oprs)
  local v = oprs
  if v.op == ed.opKaelTapBall then
    return ed.makebits(4, v.unit_index, 9, v.ext[1], 2, v.ext[2], 3, v.op)
  elseif v.op == ed.opJoinHeroBattle or v.op == ed.opJoinMagicBattle then
    return ed.makebits(8, v.hid, 10, v.ext[1], 9, v.ext[2], 1, v.isHost, 1, teamIndex - 1, 3, v.op)
  elseif v.op == ed.opManualSkill then
    local order = ed.engine:getOrderBySlot(v.unit_index, v.slot)
    return ed.makebits(10, v.unit_index, 5, order, 3, v.op)
  elseif v.op == ed.opEnergyBean then
    return ed.makebits(4, v.unit_index, 3, v.op)
  elseif v.op == ed.opJoinEchoSkill then
    return ed.makebits(16, v.echoId, 3, v.op)
  elseif v.op == ed.opExitBattle then
    return ed.makebits(3, v.op)
  elseif v.op == ed.opDamageToBoss and ed.opBitWidth4 then
    return ed.makebits(4, v.player_index, 24, v.damage, 4, v.op)
  else
    EDDebug("invalid operation " .. oprs)
  end
end

function makebitOperations(operations)
  local oplist = {}
  if not operations then
    return oplist
  end
  for _, v in ipairs(operations or {}) do
    local value = makeSingleOperation(v)
    table.insert(oplist, value)
  end
  return oplist
end

function battleEndMakebitOperations(operation_list)
  local list = {}
  local value, param
  for i, op in ipairs(operation_list) do
    value = makeSingleOperation(op)
    param = {
      _tick = op.tick,
      _operation = value
    }
    table.insert(list, param)
  end
  return list
end

function rebuildOperation(data)
  if not data then
    return
  end
  local opDatas = {}
  local lastTick = 0
  local temp
  for k, v in ipairs(data) do
    local tick, op = v._tick, v._operation
    if tick and op then
      if lastTick ~= tick then
        temp = {}
        temp._tick = tick
        temp._operation = {}
        table.insert(temp._operation, op)
        table.insert(opDatas, temp)
      else
        table.insert(temp._operation, op)
      end
      lastTick = tick
    end
  end
  return opDatas
end
