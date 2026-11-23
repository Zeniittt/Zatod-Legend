package.path = package.path .. ";./lib/?.lua;./lua/?.lua"
require("socket")
require("edebug")
require("tools")
require("stringbuffer")
require("debug.serialize")
require("debug.dump")

function ccc3()
end

require("../btcheck-config")
local logdir = "analyselog"
os.execute("mkdir -p " .. logdir)
local input_file = assert(arg[1], "no specify input file")
local memmoey_limit = 307200
local insert = table.insert
local ipairs = ipairs

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

local function load_file(file_name)
  local file = assert(io.open(file_name, "r"))
  local content = file:read("*a")
  local msg = loadstring(content)()
  return msg
end

local function parse_battle_type(file_name)
  local _, _, type = string.find(file_name, "__([%a_]+)%d+msg.lua")
  assert(type, "parse battle type failed, " .. file_name)
  assert(battle_type[type], "battle type invalid, " .. type)
  return type
end

local function create_job(file_name)
  local msg = load_file(file_name)
  local type = parse_battle_type(file_name)
  local job = {
    msg = msg,
    name = file_name,
    type = type
  }
  local param = {}
  if type == "toppvp" then
    job.round = 3
    win_round = 2
  end
  return job
end

local curJob = create_job(input_file)

function main()
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
  
  local function clearString(t)
    for key, val in pairs(t) do
      local vt = type(val)
      if "table" == vt then
        clearString(val)
      elseif "string" == vt then
        if string.find(val, "[^(x00-x7f)]") then
          t[key] = nil
        elseif string.find(val, "%.jpg") then
          t[key] = nil
        elseif string.find(val, "%.png") then
          t[key] = nil
        end
      end
    end
  end
  
  print(string.format("before load table Memory usage: %i kb", checkMemoryUsage()))
  for i = 1, #defaultBattleCsvTable do
    local csvFile = defaultBattleCsvTable[i]
    local csvTable = ed.getDataTable(csvFile)
  end
  print(string.format("after load table Memory usage: %i kb", checkMemoryUsage()))
  local up = pb_loader("bcup")()
  local down = pb_loader("bcdown")()
  local upmsg = up.battlecheck_reply
  local downmsg = down.battlecheck
  local jobQueue = Queue.create(4096)
  local reportQueue = Queue.create(4096)
  local checkFailQueue = Queue.create(4096)
  collectgarbage("collect")
  
  local function addFailJob(cheat, job)
    if cheat then
      print("job failed", job.name)
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
    local _pvp_result = param._pvp_result
    local _multiplayer_result = param.multiplayer_result
    local _battle_times = param._battle_times
    local multi_arena_pvp_result = param.multi_arena_pvp_result
    local msb_result = param.msb_result
    local _total_damage = param._total_damage
    local _team_info = param._team_info
    local _hero_dyna = param._hero_dyna
    local _chess_result = param._chess_result
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
    if _pvp_result then
      msg._pvp_result = _pvp_result
    end
    if _multiplayer_result then
      msg._multiplayer_result = _multiplayer_result
    end
    if _chess_result then
      msg._chess_result = _chess_result
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
  
  do_battle_log = true
  ed.debug_mode = true
  
  local function doChessJob(job, reCheck)
    local msg = job.msg
    local mode = job.type
    local round = job.round or 1
    local battleDatas = msg._battles
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
      end
    end
    local resultParam = {_chess_result = chessResults}
    ed.printTable(resultParam)
    do return end
    local checktime = true
    if not reCheck then
      report(msg._checkid, 0, _result, checktime, resultParam)
      addFailJob(_result == 2, job)
    else
      dumpErrorMsg("cheat", tostring(_result))
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
      end
    end
    local resultParam = {_solo_result = soloResults}
    local checktime = true
    if not reCheck then
      report(msg._checkid, 0, _result, checktime, resultParam)
    else
      dumpErrorMsg("cheat", tostring(_result))
    end
  end
  
  local function dojob(job, reCheck)
    local msg = job.msg
    local mode = job.type
    if mode == "chess" then
      doChessJob(job, reCheck)
      return
    end
    if mode == "solo" then
      doSoloJob(job, reCheck)
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
      round = 7
      if 7 < #(msg._self_heroes or {}) or 7 < #(msg._oppo_heroes or {}) then
        round = 9
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
    local battle_result = {}
    local battle_hero_data = {}
    local win_count = 0
    local lose_count = 0
    local serverTime = 0
    local self_team_idx = 1
    local oppo_team_idx = 1
    local team_info = {}
    local round_hero_dyna = {}
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
      table.insert(team_info, {self_team_idx = self_team_idx, oppo_team_idx = oppo_team_idx})
      print("battle_mode", mode)
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
      param = job_handler.job_handler[job.type](job, time, battle_result, battle_hero_data, team_info, round_hero_dyna, round)
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
    if (job.type == "stage" or job.type == "tbc" or job.type == "guild" or job.type == "throne_tower" or job.type == "dreamland" or job.type == "monsterseal") and msg._cli_battle_time < time / 6 then
      checktime = false
    end
    if job.type == "chaos_tower" or job.type == "guildMount" or job.type == "seasonArena" or job.type == "seasonTower" or job.type == "fancyTower" then
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
  
  dojob(curJob)
  print(string.format("dojob finish Memory usage: %i kb", checkMemoryUsage()))
end

main()
