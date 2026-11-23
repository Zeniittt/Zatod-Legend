module("job_handler", package.seeall)

local function checkDynaResult(msg)
  local selfHeros, enemyHeros = ed.engine:getBattleResult()
  for i = 1, #selfHeros do
    local bcData = selfHeros[i]
    local clientData = msg._self_dyna_end[i]
    if bcData._hp_perc ~= clientData._hp_perc or bcData._mp_perc ~= clientData._mp_perc or bcData._custom_data ~= clientData._custom_data then
      return false
    end
  end
  for i = 1, #enemyHeros do
    local bcData = enemyHeros[i]
    local clientData = msg._oppo_dyna_end[i]
    if bcData._hp_perc ~= clientData._hp_perc or bcData._mp_perc ~= clientData._mp_perc or bcData._custom_data ~= clientData._custom_data then
      return false
    end
  end
  return true
end

local function checkDreamlandResult(msg)
  local totalDamage = math.floor(ed.engine:getPlayerTotalDamage(ed.emCampPlayer))
  if totalDamage ~= msg._damage then
    return false
  end
  return true
end

local function checkMonstersealResult(msg)
  local totalDamage = math.floor(ed.engine:getPlayerTotalDamage(ed.emCampPlayer))
  if totalDamage ~= msg._damage then
    return false
  end
  return true
end

local function checkRealPvpResullt(msg)
  return battle_check.String2Result(msg._result) == ed.engine.battleResult
end

local function checkGuildInstanceResult(msg)
  local wave = ed.engine.wave_id
  if wave ~= msg._end_wave then
    return false
  end
  local enemyHp = ed.engine:getEnemyHpInfo()
  local totalDamage = math.floor(ed.engine:getPlayerTotalDamage(ed.emCampPlayer))
  if math.abs(totalDamage - msg._dps) > 0.2 * msg._dps then
    return false
  end
  for i = 1, #enemyHp do
    if enemyHp[i] ~= msg._hp_end[i] then
      return false
    end
  end
  return true
end

local function checkAncientsResult(msg)
  local enemyHp = ed.engine:getEnemyHpInfo()
  for i = 1, #enemyHp do
    if enemyHp[i] ~= msg._hp_end[i] then
      return false
    end
  end
  return true
end

local function checkTestBattleCheckResult(msg)
  local checkResult = ed.engine:getBattleCheckResult(ed.engine.battleResult)
  if battle_check.String2Result(msg._result) ~= checkResult.result or msg._self_demage ~= checkResult.selfDamage or msg._oppo_demage ~= checkResult.targetDamage then
    return false
  end
  local selfHeros, enemyHeros = checkResult.selfHeroHpMp, checkResult.enemyHeroHpMp
  for i = 1, #selfHeros do
    local bcData = selfHeros[i]
    local clientData = msg._self_hero_hp_mp[i]
    if bcData._hp_perc ~= clientData._hp_perc or bcData._mp_perc ~= clientData._mp_perc or bcData._custom_data ~= clientData._custom_data then
      return false
    end
  end
  for i = 1, #enemyHeros do
    local bcData = enemyHeros[i]
    local clientData = msg._oppo_hero_hp_mp[i]
    if bcData._hp_perc ~= clientData._hp_perc or bcData._mp_perc ~= clientData._mp_perc or bcData._custom_data ~= clientData._custom_data then
      return false
    end
  end
  return true
end

local function checkArcanaTrialResult(msg)
  local enemyHp = ed.engine:getEnemyHpInfo()
  local totalDamage = math.floor(ed.engine:getPlayerTotalDamage(ed.emCampPlayer))
  print("checkArcanaTrialResult Damage -> client:" .. totalDamage .. "_msg.damage = " .. msg._damage)
  if totalDamage ~= msg._damage then
    return false
  end
  local progress = ed.engine:getArcanaProgress()
  print("checkArcanaTrialResult Progress-> client:" .. progress .. "_msg.damage = " .. msg._end_progress)
  if progress ~= msg._end_progress then
    return false
  end
  return true
end

local function checkMythBossResult(msg)
  local enemyHp = ed.engine:getEnemyHpInfo()
  local totalDamage = math.floor(ed.engine:getPlayerTotalDamage(ed.emCampPlayer))
  print("checkMythBossResult Damage -> client:" .. totalDamage .. "_msg.damage = " .. msg._damage)
  if totalDamage ~= msg._damage then
    return false
  end
  return true
end

local function checkFiveBossResult(msg)
  local totalDamage = math.floor(ed.engine:getPlayerTotalDamage(ed.emCampPlayer))
  print("checkFiveBossResult Damage -> client:" .. totalDamage .. "_msg.damage = " .. msg._damage)
  if totalDamage ~= msg._damage then
    return false
  end
  return true
end

local function checkRaceTowerResult(msg)
  local totalDamage = math.floor(ed.engine:getPlayerTotalDamage(ed.emCampPlayer))
  local resultNum = battle_check.String2Result(msg._result)
  print("checkRaceTowerResult Result -> client:" .. msg._result .. "," .. resultNum .. "  ed.engine.battleResult:" .. ed.engine.battleResult)
  if resultNum ~= ed.engine.battleResult then
    return false
  end
  return true
end

local function checkGuildMountBossResult(msg)
  local totalDamage = math.floor(ed.engine:getPlayerTotalDamage(ed.emCampPlayer))
  print("checkGuildMountBossResult Damage -> client:" .. totalDamage .. "_msg.damage = " .. msg._damage)
  if totalDamage ~= msg._damage then
    return false
  end
  local finalHpList = ed.engine:getSelfFinalHpPercent()
  for i, v in ipairs(finalHpList) do
    if math.abs(msg._end_hp_list[i] - math.floor(v)) > 1 then
      for _, m in ipairs(finalHpList) do
        print(string.format("------finalHp--Server-->%d", math.floor(m)))
      end
      for _, n in ipairs(msg._end_hp_list) do
        print(string.format("------finalHp--Client-->%d", n))
      end
      return false
    end
  end
  return true
end

local function stageHandler(job)
  local msg = job.msg
  local result, _result
  local stars_expected = msg._result ~= "victory" and 0 or msg._stars
  local heroTaskCheckFailed = false
  if msg._unit_battle_data and 0 < #msg._unit_battle_data then
    local ubdtbl = msg._unit_battle_data[1]
    local clientTbl = ubdtbl._unit_kill_list or {}
    local serverTbl = ed.engine:getScecificHeroKillList(ubdtbl._unit_hid) or {}
    if #clientTbl == #serverTbl then
      for i = 1, #clientTbl do
        if clientTbl[i] ~= serverTbl[i] then
          heroTaskCheckFailed = true
        end
      end
    else
      heroTaskCheckFailed = true
    end
    if ubdtbl._unit_max_damage ~= ed.engine:getSpecificHeroDamage(ubdtbl._unit_hid) then
      heroTaskCheckFailed = true
    end
  else
  end
  result = stars_expected == ed.engine.result_stars and not heroTaskCheckFailed
  _result = result and 1 or 2
  local param = {result = result, _result = _result}
  return param
end

local function arenaHandler()
  local result = ed.engine.result_stars > 0
  local pvp_result = {}
  local battle_hero_data = {}
  pvp_result._hero_data = ed.engine:getHeroPvPBattleData()
  battle_hero_data[1] = pvp_result
  local _result = result and 3 or 4
  return {
    result = result,
    _result = _result,
    _pvp_result = battle_hero_data,
    _battle_times = math.ceil(ed.engine.ticks / 8)
  }
end

local function tbcHandler(job)
  local msg = job.msg
  local energy_beans = msg._energy_beans or 0
  local result = checkDynaResult(msg)
  local pvp_result = {}
  local battle_hero_data = {}
  result = result and energy_beans == ed.engine.useEnergyBeanNumber
  pvp_result._hero_data = ed.engine:getHeroPvPBattleData()
  battle_hero_data[1] = pvp_result
  local _result = result and 1 or 2
  return {
    result = result,
    _result = _result,
    _pvp_result = battle_hero_data
  }
end

local function checkThroneTowerDynaResult(msg)
  local selfHeros, enemyHeros = ed.engine:getBattleResult()
  for i = 1, #selfHeros do
    local bcData = selfHeros[i]
    local clientData = msg._self_dyna_end[i]
    if bcData._hp_perc ~= clientData._hp_perc or bcData._mp_perc ~= clientData._mp_perc or bcData._custom_data ~= clientData._custom_data then
      return false
    end
  end
  return true
end

local function towerHandler(job)
  local msg = job.msg
  local result = checkThroneTowerDynaResult(msg)
  local _result = result and 1 or 2
  return {result = result, _result = _result}
end

local function chaosTowerHandler(job)
  local msg = job.msg
  local result = battle_check.String2Result(msg._result) == ed.engine.battleResult
  local _result = result and 1 or 2
  return {result = result, _result = _result}
end

local function dreamHandler(job)
  local pvp_result = {}
  local battle_hero_data = {}
  pvp_result._hero_data = ed.engine:getHeroPvPBattleData()
  battle_hero_data[1] = pvp_result
  local msg = job.msg
  local result = checkDreamlandResult(msg)
  local _result = result and 1 or 2
  return {
    result = result,
    _result = _result,
    _pvp_result = battle_hero_data
  }
end

local function monsterHandler(job)
  local msg = job.msg
  local result = checkMonstersealResult(msg)
  local _result = result and 1 or 2
  return {result = result, _result = _result}
end

local function guildHandler(job)
  local msg = job.msg
  local result = checkGuildInstanceResult(msg)
  local _result = result and 1 or 2
  local totalDamage = math.floor(ed.engine:getPlayerTotalDamage(ed.emCampPlayer))
  return {
    result = result,
    _result = _result,
    _total_damage = totalDamage
  }
end

local function excavHandler(job, time)
  local msg = job.msg
  local result, _result, auto_excavate_result
  if msg._battle_type == "robot" then
    result = ed.engine.battleResult == 0
    _result = ed.engine.battleResult == 0 and 3 or 4
    auto_excavate_result = {}
    auto_excavate_result._battle_length = time
    auto_excavate_result._self_heros, auto_excavate_result._oppo_heros = ed.engine:getBattleResult()
    if time == 90 then
      local istimeout = true
      for i, v in ipairs(auto_excavate_result._self_heros) do
        if 0 < v._hp_perc then
          istimeout = false
          break
        end
      end
      for i, v in ipairs(auto_excavate_result._oppo_heros) do
        if 0 < v._hp_perc then
          istimeout = false
          break
        end
      end
      if istimeout then
        _result = 5
      end
    end
  else
    result = checkDynaResult(msg)
    _result = result and 1 or 2
  end
  return {
    result = result,
    _result = _result,
    auto_excavate_result = auto_excavate_result
  }
end

local function wcaHandler(job, time, battle_result, battle_hero_data)
  local msg = job.msg
  local result = checkRealPvpResullt(msg)
  local real_pvp_result = {}
  real_pvp_result._self_data, real_pvp_result._oppo_data = ed.engine:getHeroBattleData()
  local _result = ed.engine.battleResult == 0 and 3 or 4
  return {
    result = result,
    _result = _result,
    real_pvp_result = real_pvp_result,
    _pvp_result = battle_hero_data
  }
end

local function multiArenaHandler(job, time, battle_result, battle_hero_data)
  local msg = job.msg
  local result = checkRealPvpResullt(msg)
  local multi_arena_pvp_result = {}
  multi_arena_pvp_result = ed.engine:getMultiArenaTargetData()
  if msg._host_result then
    local eg = ed.engine
    if msg._host_result ~= eg.btResult2String() then
      result = false
    end
  end
  if msg._guest_result then
    local eg = ed.engine
    if msg._guest_result == eg.btResult2String() then
      result = false
    end
  end
  local _result = ed.engine.battleResult == 0 and 3 or 4
  return {
    result = result,
    _result = _result,
    multi_arena_pvp_result = multi_arena_pvp_result,
    _pvp_result = battle_hero_data
  }
end

local function toppvpHandler(job, time, battle_result, battle_hero_data)
  local round = job.round or 1
  local round_victory_count = 0
  local round_defeat_count = 0
  local result = false
  local _round_result = {}
  for i = 1, round do
    if battle_result[i] == 0 then
      _round_result[i] = 3
      round_victory_count = round_victory_count + 1
      if round_victory_count == 2 then
        result = true
        break
      end
    else
      _round_result[i] = 4
      round_defeat_count = round_defeat_count + 1
      if round_defeat_count == 2 then
        result = false
        break
      end
    end
  end
  local _result = result and 3 or 4
  return {
    result = result,
    _result = _result,
    _round_result = _round_result,
    _pvp_result = battle_hero_data
  }
end

local function anciHandler(job)
  local msg = job.msg
  local result = checkAncientsResult(msg)
  local _result = result and 1 or 2
  return {result = result, _result = _result}
end

local function gvgHandler(job, time)
  local result = ed.engine.battleResult == 0
  local _result = ed.engine.battleResult == 0 and 3 or 4
  local gvg_result = {}
  gvg_result._battle_length = time
  gvg_result._self_heros, gvg_result._oppo_heros = ed.engine:getBattleResult()
  return {
    result = result,
    _result = _result,
    gvg_result = gvg_result
  }
end

local function gcwHandler(job, time)
  local result = ed.engine.battleResult == 0
  local _result = ed.engine.battleResult == 0 and 3 or 4
  local gcw_result = {}
  gcw_result._battle_length = time
  gcw_result._self_heros, gcw_result._oppo_heros = ed.engine:getBattleResult()
  return {
    result = result,
    _result = _result,
    gcw_result = gcw_result
  }
end

local function questHandler()
  local result = ed.engine.battleResult == 0
  local _result = ed.engine.battleResult == 0 and 3 or 4
  return {result = result, _result = _result}
end

local function testHandler(job)
  local msg = job.msg
  local result = checkTestBattleCheckResult(msg)
  local _result = result and 1 or 2
  return {result = result, _result = _result}
end

local function siegeHandler(job)
  local msg = job.msg
  local _, state = ed.engine:getSiegeBattleState()
  local result = msg._result == state
  local _result = result and 1 or 2
  return {result = result, _result = _result}
end

local function nightmareHandler(job)
  local msg = job.msg
  msg._dead_monster_infos = msg._dead_monster_infos or {}
  local waveIdx = ed.engine:getCurrentEnemyWaveIndex()
  local deadMonsterInfos = ed.engine:getNightmareDeadMonsters()
  local waveCheck = waveIdx == msg._current_wave_idx
  local lootCheck = #deadMonsterInfos == #msg._dead_monster_infos
  local _result = waveCheck and lootCheck and 1 or 2
  if 1 == _result then
    local deadCheakFlag = false
    table.sort(deadMonsterInfos)
    table.sort(msg._dead_monster_infos)
    for idx, deadPackInfo in ipairs(msg._dead_monster_infos) do
      if deadPackInfo ~= deadMonsterInfos[idx] then
        deadCheakFlag = true
        break
      end
    end
    _result = deadCheakFlag and 2 or 1
  end
  local result = _result == 1
  return {result = result, _result = _result}
end

local function assassinateHandler(job)
  local msg = job.msg
  local result = checkDynaResult(msg)
  local ticks = ed.engine.ticks
  local assTicks = msg._ass_ticks
  if ticks ~= assTicks then
    result = false
  end
  local _result = result and 1 or 2
  return {result = result, _result = _result}
end

local function multiplayerHandler(job, time, battle_result, battle_hero_data)
  local msg = job.msg
  local damage = math.floor(ed.engine:getPlayerTotalDamage(ed.emCampPlayer))
  local rt = {_damage = damage}
  local result = true
  if msg._damages and #msg._damages > 0 then
    for _, dmg in ipairs(msg._damages) do
      local notequal = math.abs(dmg - damage) > 1
      if notequal then
        result = false
        break
      end
    end
  end
  return {
    result = result,
    _result = 1,
    multiplayer_result = rt
  }
end

local function babelHandler(job)
  local msg = job.msg
  local result, _result
  result = msg._stars == ed.engine.result_stars
  result = result and msg._result == "victory"
  _result = result and 1 or 2
  local param = {result = result, _result = _result}
  return param
end

local function checkNianResult(msg)
  local totalDamage = math.floor(ed.engine:getPlayerTotalDamage(ed.emCampPlayer))
  if math.abs(totalDamage - msg._damage) > 0.2 * msg._damage then
    return false
  end
  return true
end

local function nianHandler(job)
  local msg = job.msg
  local result = checkNianResult(msg)
  local _result = result and 1 or 2
  return {result = result, _result = _result}
end

local winRound = {
  [1] = 1,
  [3] = 2,
  [5] = 3,
  [7] = 4,
  [9] = 5
}

local function legendHandler(job, time, battle_result, battle_hero_data)
  local round = job.msg._round or 1
  local round_victory_count = 0
  local round_defeat_count = 0
  local winRound = winRound[round]
  local result = false
  local _round_result = {}
  for i = 1, round do
    if battle_result[i] == 0 then
      _round_result[i] = 3
      round_victory_count = round_victory_count + 1
      if round_victory_count == winRound then
        result = true
        break
      end
    else
      _round_result[i] = 4
      round_defeat_count = round_defeat_count + 1
      if round_defeat_count == winRound then
        result = false
        break
      end
    end
  end
  local _result = result and 3 or 4
  return {
    result = result,
    _result = _result,
    _round_result = _round_result,
    _pvp_result = battle_hero_data
  }
end

local function cuparenaHandler(job, time, battle_result, battle_hero_data, team_info, round_hero_dyna, round)
  local round_victory_count = 0
  local round_defeat_count = 0
  local winRound = winRound[round]
  local result = false
  local _round_result = {}
  for i = 1, round do
    if battle_result[i] == 0 then
      _round_result[i] = 3
      round_victory_count = round_victory_count + 1
      if round_victory_count == winRound then
        result = true
        break
      end
    else
      _round_result[i] = 4
      round_defeat_count = round_defeat_count + 1
      if round_defeat_count == winRound then
        result = false
        break
      end
    end
  end
  local _result = result and 3 or 4
  return {
    result = result,
    _result = _result,
    _round_result = _round_result,
    _pvp_result = battle_hero_data
  }
end

local function checkMultistageResult(msg)
  local selfHeros = ed.engine:getBattleResult()
  local enemyHeros = ed.engine:getEnemyInfo()
  for i = 1, #selfHeros do
    local bcData = selfHeros[i]
    local clientData = msg._self_dyna_end[i]
    if bcData._hp_perc ~= clientData._hp_perc or bcData._mp_perc ~= clientData._mp_perc or bcData._custom_data ~= clientData._custom_data then
      return false
    end
  end
  for i = 1, #enemyHeros do
    local bcData = enemyHeros[i]
    local clientData = msg._oppo_dyna_end[i]
    if bcData._hp_perc ~= clientData._hp_perc or bcData._mp_perc ~= clientData._mp_perc or bcData._custom_data ~= clientData._custom_data then
      return false
    end
  end
  return true
end

local function multistageHandler(job)
  local msg = job.msg
  local result = checkMultistageResult(msg)
  local _result = result and 1 or 2
  return {result = result, _result = _result}
end

local function msbHandler()
  local selfHero = ed.engine:getBattleResult()
  local enemyInfo = ed.engine:getEnemyInfo()
  local rt = {_self_dyna_end = selfHero, _stage_dyna_end = enemyInfo}
  return {
    result = true,
    _result = 1,
    msb_result = rt
  }
end

local function chessHandler()
  local result = true
  local _result = ed.engine.battleResult == 0 and 3 or 4
  local chess_result = {}
  chess_result._self_alives, chess_result._oppo_alives = ed.engine:getChessBattleResult()
  return {
    result = result,
    _result = _result,
    chess_result = chess_result
  }
end

local function arcanaHandler(job)
  local msg = job.msg
  local result = checkArcanaTrialResult(msg)
  local _result = result and 1 or 2
  return {result = result, _result = _result}
end

local function mythBossHandler(job)
  local msg = job.msg
  local result = checkMythBossResult(msg)
  local _result = result and 1 or 2
  return {result = result, _result = _result}
end

local function fiveBossHandler(job)
  local msg = job.msg
  local result = checkFiveBossResult(msg)
  local _result = result and 1 or 2
  return {result = result, _result = _result}
end

local function raceTowerHandler(job)
  local msg = job.msg
  local result = checkRaceTowerResult(msg)
  local _result = result and 1 or 2
  return {result = result, _result = _result}
end

local function guildMountHandler(job)
  local msg = job.msg
  local result = checkGuildMountBossResult(msg)
  local _result = result and 1 or 2
  return {
    result = result,
    _result = _result,
    _battle_times = ed.engine.ticks * ed.tick_interval * 1000
  }
end

local function seasonArenaHandler(job, time, battle_result, battle_hero_data, team_info, hero_dyna, round)
  local selfWinCount = 0
  local oppoWinCount = 0
  local _round_result = {}
  for i, info in ipairs(team_info) do
    local roundResult = battle_result[i]
    local roundResultProto
    if roundResult == 0 then
      roundResultProto = 3
      selfWinCount = selfWinCount + 1
    elseif roundResult == 1 then
      roundResultProto = 4
      oppoWinCount = oppoWinCount + 1
    elseif roundResult == 3 then
      roundResultProto = 5
    end
    _round_result[i] = roundResultProto
  end
  local result = selfWinCount > oppoWinCount
  local _result = result and 3 or 4
  return {
    result = result,
    _result = _result,
    _round_result = _round_result,
    _pvp_result = battle_hero_data,
    _team_info = team_info,
    _hero_dyna = hero_dyna
  }
end

local function checkSeasonTowerResult(msg)
  local resultNum = battle_check.String2Result(msg._result)
  print("checkSeasonTowerResult Result -> client:" .. msg._result .. "," .. resultNum .. "  ed.engine.battleResult:" .. ed.engine.battleResult)
  if resultNum ~= ed.engine.battleResult then
    return false
  end
  if not ed.engine.bot_mode then
    local totalDamage = math.floor(ed.engine:getPlayerTotalDamage(ed.emCampPlayer))
    print("checkSeasonTowerResult Damage -> client:" .. totalDamage .. "_msg.damage = " .. msg._damage)
    if totalDamage ~= msg._damage then
      return false
    end
  end
  return true
end

local function seasonTowerHandler(job)
  local msg = job.msg
  local result = checkSeasonTowerResult(msg)
  local _result = result and 1 or 2
  return {result = result, _result = _result}
end

local function checkPeakArenaResult(msg)
  local resultNum = battle_check.String2Result(msg._result)
  print("checkSeasonTowerResult Result -> client:" .. msg._result .. "," .. resultNum .. "  ed.engine.battleResult:" .. ed.engine.battleResult)
  if resultNum ~= ed.engine.battleResult then
    return false
  end
  if not ed.engine.bot_mode then
    local totalDamage = math.floor(ed.engine:getPlayerTotalDamage(ed.emCampPlayer))
    print("checkSeasonTowerResult Damage -> client:" .. totalDamage .. "_msg.damage = " .. msg._damage)
    if totalDamage ~= msg._damage then
      return false
    end
  end
  return true
end

local function peakArenaHandler(job, time, battle_result, battle_hero_data, team_info, hero_dyna, round)
  local selfWinCount = 0
  local oppoWinCount = 0
  local _round_result = {}
  for i = 1, round do
    local roundResult = battle_result[i]
    local roundResultProto
    if roundResult == 0 then
      roundResultProto = 3
      selfWinCount = selfWinCount + 1
    elseif roundResult == 1 then
      roundResultProto = 4
      oppoWinCount = oppoWinCount + 1
    elseif roundResult == 3 then
      roundResultProto = 5
      oppoWinCount = oppoWinCount + 1
    end
    _round_result[i] = roundResultProto
  end
  local result = selfWinCount > oppoWinCount
  local _result = result and 3 or 4
  return {
    result = result,
    _result = _result,
    _round_result = _round_result,
    _pvp_result = battle_hero_data,
    _team_info = team_info,
    _battle_times = math.ceil(ed.engine.ticks / 8)
  }
end

local function checkFancyTowerResult(msg)
  local resultNum = battle_check.String2Result(msg._result)
  print("checkFancyTowerResult Result -> client:" .. msg._result .. "," .. resultNum .. "  ed.engine.battleResult:" .. ed.engine.battleResult)
  if resultNum ~= ed.engine.battleResult then
    return false
  end
  if not ed.engine.bot_mode then
    local stars = math.floor(ed.engine:getStars())
    if stars ~= msg._stage_star then
      return false
    end
  end
  return true
end

local function fancyTowerHandler(job)
  local msg = job.msg
  local result = checkFancyTowerResult(msg)
  local _result = result and 1 or 2
  return {result = result, _result = _result}
end

local function checkFancyAbyssResult(msg)
  local resultNum = battle_check.String2Result(msg._result)
  print("checkFancyAbyssResult Result -> client:" .. msg._result .. "," .. resultNum .. "  ed.engine.battleResult:" .. ed.engine.battleResult)
  if resultNum ~= ed.engine.battleResult then
    return false
  end
  if not ed.engine.bot_mode then
    local battleTime = math.floor(ed.engine.ticks * ed.tick_interval)
    if battleTime ~= msg._battle_time then
      return false
    end
  end
  return true
end

local function fancyAbyssHandler(job)
  local msg = job.msg
  local result = checkFancyAbyssResult(msg)
  local _result = result and 1 or 2
  return {
    result = result,
    _result = _result,
    _battle_times = math.ceil(ed.engine.ticks * ed.tick_interval)
  }
end

local function checkActivityAdventureResult(msg)
  local resultNum = battle_check.String2Result(msg._result)
  print("checkActivityAdventureResult Result -> client:" .. msg._result .. "," .. resultNum .. "  ed.engine.battleResult:" .. ed.engine.battleResult)
  if resultNum ~= ed.engine.battleResult then
    return false
  end
  return true
end

local function activityAdventureHandler(job)
  local msg = job.msg
  local result = checkActivityAdventureResult(msg)
  local _result = result and 1 or 2
  return {result = result, _result = _result}
end

local function checkHadesHeatResult(msg)
  local resultNum = battle_check.String2Result(msg._result)
  print("checkHadesHeatResult Result -> client:" .. msg._result .. "," .. resultNum .. "  ed.engine.battleResult:" .. ed.engine.battleResult)
  if resultNum ~= ed.engine.battleResult then
    return false
  end
  if msg._battle_time ~= math.ceil(ed.engine.ticks * ed.tick_interval) then
    return false
  end
  local engineChooseHeat, engineTotalHeat = ed.engine:getChooseHeat()
  local headIdTable = {}
  for index, heatData in ipairs(engineChooseHeat) do
    local heatId = heatData._heat_id
    if headIdTable[heatId] then
      return false
    else
      headIdTable[heatId] = 1
    end
  end
  local serverChooseHeat = ed.copyProto(msg._choose_heat or {})
  if not ed.tableEqual(serverChooseHeat, engineChooseHeat) then
    return false
  end
  if engineTotalHeat ~= msg._total_heat then
    return false
  end
  local echoSkillMgr = ed.engine:getEchoSkillMgr()
  if echoSkillMgr then
    local echoId = echoSkillMgr:getEchoId()
    if msg._echo_id ~= 0 and msg._echo_id ~= echoId then
      return false
    end
  end
  return true
end

local function hadesHeatHandler(job)
  local msg = job.msg
  local result = checkHadesHeatResult(msg)
  local _result = result and 1 or 2
  return {
    result = result,
    _result = _result,
    _battle_times = math.ceil(ed.engine.ticks * ed.tick_interval)
  }
end

local function guildClashHandler(job, time)
  local result = ed.engine.battleResult == 0
  local _result = ed.engine.battleResult == 0 and 3 or 4
  local guild_clash_result = {}
  guild_clash_result._battle_length = time
  guild_clash_result._self_heros, guild_clash_result._oppo_heros = ed.engine:getBattleResult()
  return {
    result = result,
    _result = _result,
    _guild_clash_result = guild_clash_result
  }
end

local function rogueCheckResult(msg)
  local resultNum = battle_check.String2Result(msg._result)
  print("rogueCheckResult Result -> client:" .. msg._result .. "," .. resultNum .. "  ed.engine.battleResult:" .. ed.engine.battleResult)
  if resultNum ~= ed.engine.battleResult then
    return false
  end
  local clientHeroDynaEnd = msg._dyna_end
  local selfHeros, enemyHeros = ed.engine:getBattleResult()
  for _, clientData in ipairs(clientHeroDynaEnd or {}) do
    local findHero = false
    for _, serverData in ipairs(selfHeros or {}) do
      if clientData._heroid == serverData._heroid then
        findHero = true
        if clientData._hp_perc ~= serverData._hp_perc or clientData._mp_perc ~= serverData._mp_perc then
          return false
        end
      end
    end
    if not findHero then
      return false
    end
  end
  local revelation = ed.engine.rogueSkillMgr:getRogueRevelation() or {}
  if math.abs(revelation.energy - msg._des_energy_end / 10000) > 1 then
    return false
  end
  return true
end

local function rogueCheckHandler(job)
  local msg = job.msg
  local result = rogueCheckResult(msg)
  local _result = result and 1 or 2
  local battleResult, sheepDead, sheepGoldSheep = ed.engine:getRogueBattleResult(ed.engine.battleResult)
  local maxDamage = 0
  local maxDemageHeroId = 0
  local rogue_result
  if result then
    for i, unit in ipairs(ed.engine.unit_list) do
      if unit.camp == ed.emCampPlayer then
        local demage = unit.battledata:getDamage()
        if maxDamage < demage then
          maxDamage = demage
          maxDemageHeroId = unit.tid
        end
      end
    end
    rogue_result = {}
    rogue_result._sheep_dead = sheepDead
    rogue_result._gold_sheep_dead = sheepGoldSheep
    rogue_result._damage = maxDamage
    rogue_result._hero_id = maxDemageHeroId
    rogue_result._battle_length = 0
  end
  return {
    result = result,
    _result = _result,
    _rogue_result = rogue_result
  }
end

local function soloCheckHandler(job)
  local result = true
  local _result = ed.engine.battleResult == 0 and 3 or 4
  local chess_result = {}
  return {
    result = result,
    _result = _result,
    chess_result = chess_result
  }
end

local function checkAwakeStageResult(msg)
  local resultNum = battle_check.String2Result(msg._result)
  if resultNum ~= ed.engine.battleResult then
    return false
  end
  local progress = ed.engine:getAwakeStageProgress(resultNum)
  print("AwakeStage Progress-> client:" .. progress .. "_msg._progress = " .. msg._progress)
  if progress ~= msg._progress then
    return false
  end
  return true
end

local function awakeStageHandler(job)
  local msg = job.msg
  local result = checkAwakeStageResult(msg)
  local _result = result and 1 or 2
  return {result = result, _result = _result}
end

local function checkCreviceDefendResult(result)
  return false
end

local function crevicedefendHandler(job, time, battle_result, battle_hero_data, team_info, round_hero_dyna, round, battle_round_damage)
  local msg = job.msg
  local _round_result = {}
  local crevice_defend_result = {}
  crevice_defend_result.battle_result = {}
  for i = 1, round do
    if battle_result[i] == 0 then
      _round_result[i] = 3
      round_victory_count = round_victory_count + 1
      if round_victory_count == 2 then
        result = true
        break
      end
    else
      _round_result[i] = 4
    end
  end
  for index = 1, round do
    local roundResult = battle_result[i]
    local roundResultProto
    if roundResult == 0 then
      _round_result[i] = 3
      roundResultProto = 3
    elseif roundResult == 1 then
      _round_result[i] = 4
      roundResultProto = 4
    elseif roundResult == 3 then
      roundResultProto = 5
    end
    local round_battle_result = {
      _round = index,
      _result = roundResultProto,
      _damage = battle_round_damage[index]
    }
    crevice_defend_result[index] = round_battle_result
  end
  local result = checkCreviceDefendResult(msg)
  local _result = result and 3 or 4
  return {
    result = result,
    _result = _result,
    _pvp_result = battle_hero_data,
    _crevice_defend_result = crevice_defend_result
  }
end

job_handler = {
  stage = stageHandler,
  arena = arenaHandler,
  tbc = tbcHandler,
  throne_tower = towerHandler,
  chaos_tower = chaosTowerHandler,
  dreamland = dreamHandler,
  monsterseal = monsterHandler,
  guild = guildHandler,
  excav = excavHandler,
  wca = wcaHandler,
  toppvp = toppvpHandler,
  ancients = anciHandler,
  gvg = gvgHandler,
  gcw = gcwHandler,
  quest = questHandler,
  test_battle_check = testHandler,
  siege = siegeHandler,
  nightmare = nightmareHandler,
  assassinate = assassinateHandler,
  multiplayer = multiplayerHandler,
  babel = babelHandler,
  nian = nianHandler,
  legend = legendHandler,
  multiarena = multiArenaHandler,
  multistage = multistageHandler,
  msb = msbHandler,
  chess = chessHandler,
  arcanaTrial = arcanaHandler,
  cuparena = cuparenaHandler,
  mythBoss = mythBossHandler,
  fiveBoss = fiveBossHandler,
  raceTower = raceTowerHandler,
  guildMount = guildMountHandler,
  seasonArena = seasonArenaHandler,
  seasonTower = seasonTowerHandler,
  fancyTower = fancyTowerHandler,
  fancyAbyss = fancyAbyssHandler,
  activityAdventure = activityAdventureHandler,
  awakeStage = awakeStageHandler,
  peakArena = peakArenaHandler,
  hadesHeat = hadesHeatHandler,
  guildClash = guildClashHandler,
  rogueCheck = rogueCheckHandler,
  solo = soloCheckHandler,
  crevicedefend = crevicedefendHandler
}
