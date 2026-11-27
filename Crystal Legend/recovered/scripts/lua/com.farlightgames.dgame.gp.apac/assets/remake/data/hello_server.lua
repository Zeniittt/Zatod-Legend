package.path = package.path .. ";./lib/?.lua;./lua/?.lua"
if package.config:sub(1, 1) == "\\" then
  package.cpath = package.cpath .. ";./lib/?.dll"
else
  package.cpath = package.cpath .. ";./lib/?.so"
end
require("socket")
require("edebug")
require("tools")
require("stringbuffer")
require("debug.serialize")
require("debug.dump")
require("util/localstorage")

function ccc3()
end

require("../btcheck-config")
os.execute("mkdir -p bclog")
local host = check_server_ip
local port = check_server_port
if 1 < #arg and arg[1] == "assist" then
  local server_addr = arg[2]
  local server_ip, server_port = string.match(server_addr, "([%a%d.-]+):(%d+)")
  host = server_ip
  port = server_port
end
local memmoey_limit = 307200
local vm_memory_limit = 102400
local insert = table.insert
local ipairs = ipairs
local ctl = require("lua_vm_controller")
local curJob

local function dumpErrorMsg(from, result)
  from = from or "dump"
  result = result or ""
  if "cheat" ~= from then
    local fmt = string.format
    local suffix = curJob and fmt("%s%i", curJob.type, curJob.msg._checkid) or os.date("%Y-%m-%d %H-%M-%S")
    eddebug.dump("bclog", suffix)
  end
  if curJob then
    local msg = curJob.msg
    local file = io.open(string.format("bclog/%s_%s_%s%i.bclog", from, result, curJob.type, msg._checkid), "w")
    if file then
      file:write(getBtlog())
      file:close()
    end
    file = io.open(string.format("bclog/%s_%s_%s%imsg.lua", from, result, curJob.type, msg._checkid), "w")
    if file then
      ed.exportLuaModule(file, msg, ".data")
    end
  end
end

local function dumpChessErrorMsg(from, result, index)
  from = from or "dump"
  result = result or ""
  if curJob then
    local msg = curJob.msg
    local file = io.open(string.format("bclog/%s_%i_%i_%i_%s%i.bclog", from, msg._gameid, msg._round, index, curJob.type, msg._checkid), "w")
    if file then
      file:write(getBtlog())
      file:close()
    end
    file = io.open(string.format("bclog/%s_%i_%i_%s%imsg.lua", from, msg._gameid, msg._round, curJob.type, msg._checkid), "w")
    if file then
      ed.exportLuaModule(file, msg, ".data")
    end
  end
end

local LOG_CLOSE = 1
local LOG_INFO = 2
local LOG_DEBUG = 3
local log_level = LOG_CLOSE
local debug_file = false

local function write_log(format, ...)
  local str = string.format(format, ...)
  local file = io.open(debug_file, "a+")
  if file then
    file:write(os.date(), " ", str, "\n")
    file:close()
  end
end

local function loginfo(...)
  if log_level >= LOG_INFO then
    write_log(...)
  end
end

local function logdebug(...)
  if log_level >= LOG_DEBUG then
    write_log(...)
  end
end

local logerror = write_log

local function logMsg(msg, logfile)
  logfile = logfile or "info.log"
  local file = io.open(logfile, "a")
  if file then
    file:write(os.date(), " ", msg, "\n")
    file:close()
  end
end

local battle_type = {
  stage = "_pve_msg",
  arena = "_pvp_msg",
  tbc = "_tbc_msg",
  throne_tower = "_throne_tower_msg",
  chaos_tower = "_chaos_tower_check_msg",
  dreamland = "_dreamland_msg",
  monsterseal = "_devilseal_msg",
  guild = "_guild_msg",
  excav = "_excav_msg",
  wca = "_rtpvp_msg",
  toppvp = "_toppvp_msg",
  ancients = "_ancients_msg",
  gvg = "_gvg_check_msg",
  gcw = "_gcw_msg",
  quest = "_quest_msg",
  test_battle_check = "_test_battle_check_msg",
  siege = "_siege_check_msg",
  nightmare = "_nightmare_check_msg",
  assassinate = "_ass_check_msg",
  multiplayer = "_multiplayer_check_msg",
  babel = "_babel_msg",
  nian = "_nian_check_msg",
  legend = "_legend_check_msg",
  multiarena = "_multi_arena_check_msg",
  multistage = "_multi_stage_check_msg",
  msb = "_msb_check_msg",
  stargate = "_stargate_check_msg",
  chess = "_chess_check_msg",
  arcanaTrial = "_arcana_trial_check_msg",
  cuparena = "_cup_arena_check_msg",
  mythBoss = "_myth_boss_check_msg",
  fiveBoss = "_five_boss_check_msg",
  raceTower = "_race_tower_check_msg",
  guildMount = "_guild_mount_check_msg",
  seasonArena = "_season_arena_check_msg",
  seasonTower = "_season_tower_check_msg",
  fancyTower = "_fancy_tower_check_msg",
  activityAdventure = "_act_adventure_check_msg",
  fancyAbyss = "_fancy_abyss_check_msg",
  awakeStage = "_awake_dungeon_check_msg",
  peakArena = "_peak_arena_check_msg",
  hadesHeat = "_heat_check_msg",
  guildClash = "_guild_clash_check_msg",
  rogueCheck = "_rogue_check_msg",
  solo = "_solo_check_msg",
  crevicedefend = "_crevice_defend_check_msg"
}
local connection

local function connect()
  print("trying to connect ... ")
  connection, err = socket.connect(host, port)
  if not connection then
    print("socket.connect() failed. | " .. err)
    collectgarbage("collect")
    return
  end
  connection:settimeout(0)
  connection:setoption("keepalive", true)
  print("connectted success")
end

local function recv_buffer(size_left, buffer)
  if size_left <= 0 then
    return buffer
  end
  local content, err, partial = connection:receive(size_left)
  if err == "closed" then
    print("socket closed by server.")
    connection:close()
    connection = nil
    return false
  elseif err == "timeout" then
    buffer = buffer .. partial
    return recv_buffer(size_left - #partial, buffer)
  else
    buffer = buffer .. content
    return recv_buffer(size_left - #content, buffer)
  end
end

local result_map = {
  [1] = "honest",
  [2] = "cheat",
  [3] = "victory",
  [4] = "defeat",
  [5] = "timeout"
}
local winRound = {
  [1] = 1,
  [3] = 2,
  [5] = 3,
  [7] = 4,
  [9] = 5
}

local function pack_size(code)
  local length = #code
  local second = string.char(length % 256)
  local first = string.char(math.floor(length / 256))
  return first .. second .. code
end

local function checkMemoryUsage()
  collectgarbage("collect")
  local mem = collectgarbage("count")
  if mem > memmoey_limit then
    print("memory limit exceeded")
    logMsg(string.format("memory limit exceeded, usage: %i kb", mem))
    dumpErrorMsg("memlimit")
    os.exit(1)
  end
  return mem
end

local defaultBattleCsvTable = {
  "AnimDuration",
  "AnimAtkFrame",
  "AnimDurationSp",
  "AnimAtkFrameSp",
  "Battle",
  "Buff",
  "equip",
  "hero_equip",
  "Skill",
  "SkillGroup",
  "Stage",
  "Unit",
  "UnitRank",
  "Puppet",
  "TitanEquipLevel",
  "TarotCard",
  "TarotAbilitySP",
  "TarotAbility",
  "ChessUnit",
  "ChessSkill",
  "ChessSkillGroup",
  "Arcana",
  "ArcanaTrial",
  "MythBoss",
  "FiveBossBoss",
  "RaceTower",
  "GuildMountBoss"
}
xpcall(function()
  local ed = ed
  ed.run_with_scene = false
  CCNode = {}
  CCSprite = {}
  CCLabelTTF = {}
  
  function ccp(x, y)
    return {x = x, y = y}
  end
  
  ed.HpBar = {}
  require("resource_manager")
  require("datatable")
  require("gamedatatables/gamedatatables")
  require("gamedatatables/battlemetatable")
  require("gamedatatables/herotasktable")
  require("gamedatatables/skillgrouptable")
  require("gamedatatables/challengetable")
  require("gamedatatables/unittable")
  require("gamedatatables/chessunittable")
  require("gamedatatables/dotunittable")
  require("battle/edp")
  require("battle/battle_engine")
  require("battle/AutoChessBattleEngine")
  require("battle/SoloBattleEngine")
  require("pb")
  require("battle/battle_check")
  require("helloserver/job_handler")
  require("helloserver/log_handler")
  require("helloserver/queue")
  require("pet/pet")
  for i = 1, #defaultBattleCsvTable do
    local csvFile = defaultBattleCsvTable[i]
    local csvTable = ed.getDataTable(csvFile)
  end
  
  local function combineSomeTables()
    local tb1 = ed.getDataTable("AnimDuration") or {}
    local tb2 = ed.getDataTable("AnimDurationSp") or {}
    for k, v in pairs(tb2) do
      tb1[k] = {}
      for k1, v1 in pairs(v) do
        tb1[k][k1] = v1
      end
    end
  end
  
  combineSomeTables()
  local up = pb_loader("bcup")()
  local down = pb_loader("bcdown")()
  local upmsg = up.battlecheck_reply
  local downmsg = down.battlecheck
  local jobQueue = Queue.create(4096)
  local reportQueue = Queue.create(4096)
  local checkFailQueue = Queue.create(4096)
  local isBclogOnly = false
  collectgarbage("collect")
  
  local function addFailJob(cheat, job)
    if cheat then
      if checkFailQueue:full() then
        return
      end
      checkFailQueue:push(job)
    end
  end
  
  local function addFailJobs(msg, type, bot_mode)
    for _, value in ipairs(msg) do
      local job = {
        msg = value,
        type = type,
        bot_mode = bot_mode
      }
      addFailJob(true, job)
    end
  end
  
  local function jobQueuePush(msg, type, param)
    for i = 1, #msg do
      local job = {
        msg = msg[i],
        type = type
      }
      if param then
        for k, v in pairs(param) do
          job[k] = v
        end
      end
      jobQueue:push(job)
    end
  end
  
  local function recv()
    if not connection then
      connect()
    end
    if not connection then
      return -1
    else
      local total = 0
      repeat
        if jobQueue:full() then
          break
        end
        local count = 0
        local buffer_size_str, err, partial = connection:receive(2)
        if err == "closed" then
          print("connection closed")
          connection:close()
          connection = nil
          break
        end
        logdebug("err = %s, buffer = %s, total = %i, partial = %s", tostring(err), tostring(buffer_size_str), total, tostring(partial))
        if err == "timeout" and buffer_size_str == nil and total == 0 then
          return -1
        end
        if buffer_size_str then
          local buffer_size = string.byte(buffer_size_str, 1) * 256 + string.byte(buffer_size_str, 2)
          local buffer = recv_buffer(buffer_size, "")
          logdebug("buffer_size = %i buffer = %s", buffer_size, buffer)
          if buffer then
            local msg, err = downmsg():Parse(buffer)
            logdebug("msg = %s, err = %s", tostring(msg), tostring(err))
            if msg then
              if msg._open_rank then
                ed.parameter.unit_max_rank = msg._open_rank
              end
              isBclogOnly = msg._bclog_only == 1
              local bot_mode = msg._bot_mode == 1
              for v, k in pairs(battle_type) do
                if msg[k] then
                  local param = {bot_mode = bot_mode}
                  if k == "_toppvp_msg" then
                    param = {round = 3, win_round = 2}
                  end
                  if isBclogOnly then
                    addFailJobs(msg[k], v, bot_mode)
                  else
                    jobQueuePush(msg[k], v, param)
                  end
                  count = count + #msg[k]
                end
              end
            else
              logerror("Pb parse failed, err=%s", tostring(err))
              EDDebug("Pb parse failed. Proto mismatch?")
              connection = nil
            end
          end
        end
        total = total + count
      until count == 0
      return total
    end
  end
  
  local function report(checkID, userid, _result, checktime, param)
    local param = param or {}
    local msg = up.check_result()
    msg._checkid = checkID
    msg._userid = userid or 0
    msg._result = _result
    msg._is_plugin = checktime and 0 or 1
    local _round_result = param._round_result
    local gvg_result = param.gvg_result
    local real_pvp_result = param.real_pvp_result
    local gcw_result = param.gcw_result
    local auto_excavate_result = param.auto_excavate_result
    local _pvp_result = param._pvp_result
    local _multiplayer_result = param.multiplayer_result
    local _battle_times = param._battle_times
    local multi_arena_pvp_result = param.multi_arena_pvp_result
    local msb_result = param.msb_result
    local _total_damage = param._total_damage
    local _team_info = param._team_info
    local _hero_dyna = param._hero_dyna
    local _guild_clash_result = param._guild_clash_result
    local _rogue_result = param._rogue_result
    local _crevice_defend_result = param._crevice_defend_result
    local _chess_result = param._chess_result
    local _solo_result = param._solo_result
    if _round_result then
      msg._round_result = {}
      for i, round_result in ipairs(_round_result) do
        msg._round_result[i] = result_map[round_result]
      end
    end
    if gvg_result then
      msg._gvg_result = gvg_result
    end
    if gcw_result then
      msg._gcw_result = gcw_result
    end
    if real_pvp_result then
      msg._real_pvp_result = real_pvp_result
    end
    if multi_arena_pvp_result then
      msg._multi_arena_battle_result = multi_arena_pvp_result
    end
    if auto_excavate_result then
      msg._auto_excavate_result = auto_excavate_result
    end
    if _pvp_result then
      msg._pvp_result = _pvp_result
    end
    if _multiplayer_result then
      msg._multiplayer_result = _multiplayer_result
    end
    if _chess_result then
      msg._chess_result = _chess_result
    end
    if _solo_result then
      msg._solo_result = _solo_result
    end
    if _guild_clash_result then
      msg._guild_clash_result = _guild_clash_result
    end
    if _rogue_result then
      msg._rogue_result = _rogue_result
    end
    if _crevice_defend_result then
      msg._crevice_defend_result = _crevice_defend_result
    end
    if _battle_times then
      msg._battle_time = _battle_times
    end
    if msb_result then
      msg._msb_result = msb_result
    end
    if _total_damage then
      msg._guild_pve_result = up.guild_pve_result()
      msg._guild_pve_result._damage = _total_damage
    end
    if _team_info then
      msg._stargate_team_info = up.stargate_team_info()
      local team_idxs = {}
      for i, info in pairs(_team_info) do
        local team_idx = up.team_idx()
        team_idx.self_team_idx = info.self_team_idx
        team_idx.oppo_team_idx = info.oppo_team_idx
        table.insert(team_idxs, team_idx)
      end
      msg._stargate_team_info._team_idx = team_idxs
    end
    if _hero_dyna then
      msg._stargate_hero_dyna = up.stargate_hero_dyna()
      local round_hero_dyna = {}
      for i, info in pairs(_hero_dyna) do
        local round = up.stargate_round_hero_dyna()
        local self_hero = {}
        for tid, dyna in pairs(info.self_dyna or {}) do
          local msb_hero = up.msb_hero()
          msb_hero._heroid = tid
          msb_hero._hp_perc = dyna._hp_perc
          msb_hero._mp_perc = dyna._mp_perc
          table.insert(self_hero, msb_hero)
        end
        round._self_hero = self_hero
        local oppo_hero = {}
        for tid, dyna in pairs(info.oppo_dyna or {}) do
          local msb_hero = up.msb_hero()
          msb_hero._heroid = tid
          msb_hero._hp_perc = dyna._hp_perc
          msb_hero._mp_perc = dyna._mp_perc
          table.insert(oppo_hero, msb_hero)
        end
        round._oppo_hero = oppo_hero
        round._trigger_buf = info.trigger_buf and 1 or 0
        table.insert(round_hero_dyna, round)
      end
      msg._stargate_hero_dyna._round_hero_dyna = round_hero_dyna
    end
    reportQueue:push(msg)
  end
  
  local function send(count)
    count = count or reportQueue.size
    if not connection then
      connect()
    end
    if not connection then
      return
    else
      local msg = upmsg()
      msg._result = {}
      for i = 1, count do
        msg._result[i] = reportQueue:pull()
      end
      local code = pack_size(msg:Serialize())
      local r1, r2 = connection:send(code)
      logdebug("send: %d", count)
      if not r1 then
        print("Send report failed|" .. r2)
        logerror("Send report failed|" .. r2)
        for i = 1, count do
          reportQueue:push(msg._result[i])
        end
      else
      end
    end
  end
  
  local function doChessJob(job, reCheck)
    local msg = job.msg
    local mode = job.type
    local round = job.round or 1
    local battleDatas = msg._battles
    local isDump = msg._is_dump == 1
    if isDump then
      job.msg._is_dump = 0
      addFailJob(true, job)
      return
    end
    local chessResults = {}
    local _result = 0
    for i, battleMsg in ipairs(battleDatas) do
      local battle_result = {}
      local serverTime = 0
      for cur_round = 1, round do
        battle_check.enterBattle(battleMsg, mode)
        local startTime = os.clock()
        while ed.engine.running do
          ed.engine:tick()
        end
        serverTime = serverTime + (os.clock() - startTime)
      end
      local param = {}
      if battle_type[job.type] then
        param = job_handler.job_handler[job.type]()
      end
      local time = math.floor(ed.engine.ticks * ed.tick_interval)
      battle_result._battle_time = math.ceil(ed.engine.ticks * ed.tick_interval * 1000 / 1.7)
      battle_result._result = param._result
      battle_result._self_alives = param.chess_result._self_alives
      battle_result._oppo_alives = param.chess_result._oppo_alives
      _result = param._result
      table.insert(chessResults, i, battle_result)
      if not reCheck then
        log_handler.log(job, param.result, time, serverTime, battleMsg)
      else
        dumpChessErrorMsg("cheat", tostring(_result), battleMsg._index)
      end
    end
    local resultParam = {_chess_result = chessResults}
    local checktime = true
    if not reCheck then
      report(msg._checkid, 0, _result, checktime, resultParam)
    else
    end
  end
  
  local function doSoloJob(job, reCheck)
    local msg = job.msg
    local mode = job.type
    local round = job.round or 1
    local battleDatas = msg._battles
    local isDump = msg._is_dump == 1
    if isDump then
      job.msg._is_dump = 0
      addFailJob(true, job)
      return
    end
    local soloResults = {}
    local _result = 0
    for i, battleMsg in ipairs(battleDatas) do
      local battle_result = {}
      local serverTime = 0
      battle_check.enterBattle(battleMsg, mode)
      local startTime = os.clock()
      while ed.engine.running do
        ed.engine:tick()
      end
      serverTime = serverTime + (os.clock() - startTime)
      local param = {}
      if battle_type[job.type] then
        param = job_handler.job_handler[job.type]()
      end
      local time = ed.engine.ticks * ed.tick_interval * 1000
      if 20000 < time then
        time = 20000 + (time - 20000) * 0.5
      end
      battle_result._battle_time = math.ceil(time)
      battle_result._result = param._result
      _result = param._result
      table.insert(soloResults, i, battle_result)
      if not reCheck then
        log_handler.log(job, param.result, time, serverTime, battleMsg)
      else
        dumpChessErrorMsg("cheat", tostring(_result), battleMsg._index)
      end
    end
    local resultParam = {_solo_result = soloResults}
    local checktime = true
    if not reCheck then
      report(msg._checkid, 0, _result, checktime, resultParam)
    else
    end
  end
  
  local vm_ids = {}
  
  local function vm_prepare()
    if vm_ids == nil or #vm_ids == 0 then
      for i = 1, 3 do
        local vm_id = ctl.create_vm()
        vm_ids[i] = vm_id
        ctl.setId(vm_id, i)
        ctl.execute_lua_code(vm_id, [[
                    require "server_job_task"
                ]])
      end
    end
  end
  
  local function vm_cleanup()
    for i = 1, #vm_ids do
      local memory_usage = ctl.getMemoryUsage(vm_ids[i])
      if memory_usage > vm_memory_limit then
        ctl.destroy_vm(vm_ids[i])
        local vm_id = ctl.create_vm()
        vm_ids[i] = vm_id
        ctl.setId(vm_id, i)
        ctl.execute_lua_code(vm_id, [[
                    require "server_job_task"
                ]])
      end
    end
  end
  
  local function doMonopolyBossJob(job, reCheck)
    local msg = job.msg
    local mode = job.type
    local round = job.round or 1
    local serverTime = 0
    vm_prepare()
    for i = 1, 3 do
      local vm_id = vm_ids[i]
      local invoke_success = ctl.invoke(vm_id, "task_job_begin", job, i + 1)
      assert(invoke_success, "invoke [task_job_begin] failed,vm_id:" .. vm_id)
    end
    local startTime = os.clock()
    local has_one_battle_running = true
    local task_battle_running = {
      [1] = true,
      [2] = true,
      [3] = true
    }
    local last_tick_boss_damages
    while has_one_battle_running do
      local boss_damages = {}
      if ed.engine.running then
        ed.engine:damageToBossFOP(last_tick_boss_damages, 1)
        ed.engine:tick()
      end
      has_one_battle_running = ed.engine.running
      boss_damages[1] = boss_damage
      for i = 1, 3 do
        boss_damages[i + 1] = 0
        if task_battle_running[i] then
          local vm_id = vm_ids[i]
          local invoke_success, battle_finish, boss_damage = ctl.invoke(vm_id, "task_job_run", last_tick_boss_damages)
          assert(invoke_success, "invoke [task_job_run] failed,vm_id:" .. vm_id)
          task_battle_running[i] = not battle_finish
          boss_damages[i + 1] = boss_damage
        end
        has_one_battle_running = has_one_battle_running or task_battle_running[i]
      end
      last_tick_boss_damages = {}
      for i = 1, #boss_damages do
        last_tick_boss_damages[i] = boss_damages[i]
      end
    end
    serverTime = serverTime + (os.clock() - startTime)
    for i = 1, 3 do
      local vm_id = vm_ids[i]
      local invoke_success, battleResult = ctl.invoke(vm_id, "task_job_end")
      assert(invoke_success, "invoke [task_job_end] failed,vm_id:" .. vm_id)
    end
    vm_cleanup()
  end
  
  local function dojob(job, reCheck)
    local msg = job.msg
    local mode = job.type
    local bot_mode = job.bot_mode
    print("bot_mode=", bot_mode, job.type)
    if mode == "chess" then
      doChessJob(job, reCheck)
      return
    end
    if mode == "solo" then
      doSoloJob(job, reCheck)
      return
    end
    if mode == "monopolyBoss" then
      xpcall(function()
        doMonopolyBossJob(job, reCheck)
      end, function(msg)
        dumpErrorMsg("dump")
      end)
      return
    end
    local round = job.round or 1
    local win_round = job.win_round or 1
    if mode == "legend" then
      round = msg._round
      win_round = winRound[round]
    end
    if mode == "stargate" then
      round = 20
      msg._round = round
    end
    if mode == "cuparena" then
      round = 5
      if 5 < #(msg._self_heroes or {}) or 5 < #(msg._oppo_heroes or {}) then
        round = 7
      end
      win_round = winRound[round]
    end
    if mode == "seasonArena" then
      round = 10
      win_round = winRound[round]
      msg._round = round
      local selfHeroes = msg._self_heroes or {}
      for i = 1, 3 do
        if not selfHeroes[i] then
          selfHeroes[i] = {}
        end
      end
      local oppoHeroes = msg._oppo_heroes or {}
      for i = 1, 3 do
        if not oppoHeroes[i] then
          oppoHeroes[i] = {}
        end
      end
    end
    if mode == "peakArena" then
      round = 3
      if #(msg._self_heroes or {}) > 3 or #(msg._oppo_heroes or {}) > 3 then
        round = 5
      end
      win_round = winRound[round]
      msg._round = round
      local selfHeroes = msg._self_heroes or {}
      for i = 1, round do
        if not selfHeroes[i] then
          selfHeroes[i] = {}
        end
      end
      local oppoHeroes = msg._oppo_heroes or {}
      for i = 1, round do
        if not oppoHeroes[i] then
          oppoHeroes[i] = {}
        end
      end
    end
    if mode == "crevicedefend" then
      round = 5
      win_round = winRound[round]
    end
    local battle_result = {}
    local battle_hero_data = {}
    local win_count = 0
    local lose_count = 0
    local serverTime = 0
    local self_team_idx = 1
    local oppo_team_idx = 1
    local team_info = {}
    local round_hero_dyna = {}
    local battle_round_damage = {}
    for cur_round = 1, round do
      if battle_check.limitEnterBattle(msg, mode, cur_round, self_team_idx, oppo_team_idx) then
        print("default", "beacase of cheat", "excute battle check end")
        if mode == "cuparena" then
          report(msg._checkid, msg._userid, 4)
        else
          report(msg._checkid, msg._userid, 2)
        end
        return
      end
      local self_dyna, oppo_dyna, triggerBuf
      if mode == "stargate" then
        self_dyna, oppo_dyna, triggerBuf = battle_check.getStarGateDynaData(msg, cur_round, self_team_idx, oppo_team_idx)
        round_hero_dyna[cur_round] = {
          self_dyna = self_dyna,
          oppo_dyna = oppo_dyna,
          trigger_buf = triggerBuf
        }
      elseif mode == "seasonArena" then
        self_dyna, oppo_dyna, triggerBuf = battle_check.getSeasonArenaDynaData(msg, cur_round, self_team_idx, oppo_team_idx)
        round_hero_dyna[cur_round] = {
          self_dyna = self_dyna,
          oppo_dyna = oppo_dyna,
          trigger_buf = triggerBuf
        }
      end
      table.insert(team_info, {self_team_idx = self_team_idx, oppo_team_idx = oppo_team_idx})
      battle_check.enterBattle(msg, mode, cur_round, self_team_idx, oppo_team_idx)
      ed.engine.bot_mode = bot_mode
      if bot_mode then
        for unit in ed.engine:foreachAliveUnit(ed.emCampPlayer) do
          unit.ai.will_cast_manual_skill = true
        end
      end
      local startTime = os.clock()
      while ed.engine.running do
        ed.engine:tick()
      end
      serverTime = serverTime + (os.clock() - startTime)
      battle_result[cur_round] = ed.engine.battleResult
      local pvp_result = {}
      pvp_result._hero_data = ed.engine:getHeroPvPBattleData()
      battle_hero_data[cur_round] = pvp_result
      if mode == "stargate" then
        local selfHeros, enemyHeros = ed.engine:getBattleResult()
        local self_next_team = true
        for i = 1, #selfHeros do
          local hero = selfHeros[i]
          if 0 < hero._hp_perc then
            self_next_team = false
          end
        end
        if self_next_team then
          self_team_idx = self_team_idx + 1
        end
        local oppo_next_team = true
        for i = 1, #enemyHeros do
          local hero = enemyHeros[i]
          if 0 < hero._hp_perc then
            oppo_next_team = false
          end
        end
        if oppo_next_team then
          oppo_team_idx = oppo_team_idx + 1
        end
        if msg._self_heroes[self_team_idx] == nil or msg._oppo_heroes[oppo_team_idx] == nil then
          break
        end
      elseif mode == "seasonArena" then
        local selfHeros, enemyHeros = ed.engine:getBattleResult()
        local self_next_team = true
        for i = 1, #selfHeros do
          local hero = selfHeros[i]
          if 0 < hero._hp_perc then
            self_next_team = false
          end
        end
        if self_next_team then
          self_team_idx = self_team_idx + 1
        end
        local oppo_next_team = true
        for i = 1, #enemyHeros do
          local hero = enemyHeros[i]
          if 0 < hero._hp_perc then
            oppo_next_team = false
          end
        end
        if oppo_next_team then
          oppo_team_idx = oppo_team_idx + 1
        end
        if not self_next_team and not oppo_next_team then
          self_team_idx = self_team_idx + 1
          oppo_team_idx = oppo_team_idx + 1
          battle_result[cur_round] = 3
        end
        if msg._self_heroes[self_team_idx] == nil or msg._oppo_heroes[oppo_team_idx] == nil then
          break
        end
      elseif mode == "crevicedefend" then
        local totalDamage = math.floor(ed.engine:getPlayerTotalDamage(ed.emCampPlayer))
        battle_round_damage[cur_round] = totalDamage
      elseif battle_result[cur_round] == 0 then
        win_count = win_count + 1
        if win_round <= win_count then
          break
        end
      else
        lose_count = lose_count + 1
        if win_round <= lose_count then
          break
        end
      end
    end
    local time = math.floor(ed.engine.ticks * ed.tick_interval)
    local param = {}
    if battle_type[job.type] then
      param = job_handler.job_handler[job.type](job, time, battle_result, battle_hero_data, team_info, round_hero_dyna, round, battle_round_damage)
    end
    local result = param.result
    local _result = param._result
    if bot_mode then
      local battleResult = ed.engine.battleResult
      local map = {
        [0] = 3,
        [1] = 4,
        [2] = 6,
        [3] = 5
      }
      result = true
      _result = map[battleResult]
      param._total_damage = math.floor(ed.engine:getPlayerTotalDamage(ed.emCampPlayer))
      local pvp_result = {}
      local battleHeroData = {}
      pvp_result._hero_data = ed.engine:getHeroPvPBattleData()
      battleHeroData[1] = pvp_result
      param._pvp_result = battleHeroData
    end
    local checktime = true
    if (job.type == "stage" or job.type == "tbc" or job.type == "guild" or job.type == "throne_tower" or job.type == "dreamland" or job.type == "monsterseal") and msg._cli_battle_time < time / 15 then
      checktime = false
    end
    if job.type == "chaos_tower" or job.type == "guildMount" or job.type == "seasonArena" or job.type == "peakArena" then
      param._battle_times = ed.engine.ticks * ed.tick_interval * 1000
    end
    if not reCheck then
      report(msg._checkid, msg._userid, _result, checktime, param)
      local ischeat = not result
      if job.type == "wca" or job.type == "multiarena" then
        log_handler.log(job, _result, time, serverTime, battle_result)
      elseif job.type == "multiplayer" then
        log_handler.log(job, _result, time, serverTime, battle_result)
      else
        log_handler.log(job, result, time, serverTime, battle_result, team_info)
        ischeat = _result == 2
      end
      if job.type ~= "wca" and job.type ~= "arena" then
        addFailJob(ischeat, job)
      end
    else
      dumpErrorMsg("cheat", tostring(result))
    end
  end
  
  local function sleep(time)
    pcall(function()
      socket.select(nil, nil, time)
    end)
  end
  
  local function check(queue, recheck)
    if queue.size > 0 then
      curJob = queue:pull()
      dojob(curJob, recheck)
      print(string.format("JobType %s Memory usage: %i kb", curJob.type, checkMemoryUsage()))
    end
  end
  
  local function reCheck()
    do_battle_log = true
    check(checkFailQueue, true)
  end
  
  local is_soft_closed
  local soft_closed_last_check_time = 0
  math.randomseed(os.time() + tonumber(tostring(os):match("0x%w+")) % 10000)
  local soft_closed_check_interval = math.random(60) + 30
  
  local function check_soft_close()
    if is_soft_closed then
      return
    end
    local nowtime = os.time()
    if nowtime >= soft_closed_last_check_time and nowtime < soft_closed_last_check_time + soft_closed_check_interval then
      return
    end
    soft_closed_last_check_time = nowtime
    is_soft_closed = os.execute("ps -ef|awk '$2=='$$'{print $3}'|xargs -i rm soft_close/{}.pid > /dev/null 2>&1") == 0
  end
  
  local print_log_last_check_time = 0
  local print_log_check_interval = math.random(20) + 10
  local loglevels = {
    [LOG_CLOSE] = "close",
    [LOG_INFO] = "info",
    [LOG_DEBUG] = "debug"
  }
  
  local function check_log_level()
    local level = log_level
    for i = 1, #loglevels do
      local CMD = string.format("ps -ef|awk '$2=='$$'{print $3}'|xargs -i rm log_print/{}.%s.pid > /dev/null 2>&1", loglevels[i])
      if os.execute(CMD) == 0 then
        level = i
      end
    end
    return level
  end
  
  local function close_log_print()
    local cmd = string.format("ps -ef|awk '$2=='$$'{print $3}'|xargs -i mv %s log_print/{}.log > /dev/null 2>&1", debug_file)
    os.execute(cmd)
  end
  
  debug_file = debug_file or string.format("log_print/%d.log", math.random(1000) + 1313)
  
  local function check_print_log()
    local nowtime = os.time()
    if nowtime >= print_log_last_check_time and nowtime < print_log_last_check_time + print_log_check_interval then
      return
    end
    print_log_last_check_time = nowtime
    local level = check_log_level()
    if log_level ~= level then
      write_log("check_log_level: %d", log_level)
    end
    if level == LOG_CLOSE and log_level ~= LOG_CLOSE then
      close_log_print()
    end
    log_level = level
  end
  
  local function server_main()
    collectgarbage("setpause", 100)
    collectgarbage("setstepmul", 5000)
    send(0)
    local needRequest = false
    while true do
      do_battle_log = false
      local nresult = recv()
      needRequest = needRequest or nresult ~= -1
      if jobQueue.size == 0 and reportQueue.size == 0 then
        sleep(0.1)
        reCheck()
      end
      if not reportQueue:full() then
        check(jobQueue)
      end
      if 0 < reportQueue.size then
        send()
      end
      check_soft_close()
      check_print_log()
      if 0 < jobQueue.size then
        logerror("jobQueueSize %d > 0, reportSize %d, failJobSize %d, needRequest %s, nresult %s", jobQueue.size, reportQueue.size, checkFailQueue.size, tostring(needRequest), tostring(nresult))
      end
      if jobQueue.size == 0 and needRequest and not is_soft_closed then
        needRequest = false
        send(0)
      end
      loginfo("nresult = %d, is_soft_closed = %s", nresult, tostring(is_soft_closed))
      logdebug("JobSize: %i, failJobSize: %i", jobQueue.size, checkFailQueue.size)
      if log_level ~= LOG_CLOSE then
        sleep(1)
      end
      if is_soft_closed and jobQueue.size == 0 and reportQueue.size == 0 then
        local mem = checkMemoryUsage()
        local msg = string.format("sort closed exit, Memory usage: %i kb, failJobSize: %i", mem, checkFailQueue.size)
        print(msg)
        logMsg(msg)
        break
      end
    end
  end
  
  server_main()
end, function(msg)
  if enable_debug then
    EDDebug(msg)
  else
    dumpErrorMsg("dump")
  end
end)
