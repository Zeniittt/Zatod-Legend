package.path = package.path .. ";./lib/?.lua;./lua/?.lua"

function ccc3(r, g, b)
end

require("edebug")
require("tools")
require("pet/pet")
require("hero")
local getRuneInfoFunction = require("battle/bot_rune")
local getPetBagFunction = require("battle/bot_pet")
ed.enableBotMode = true
ed.enableMaxAttStrategy = false
local re_max = 2000
local generation_max = 400
local AllheroStar = 3
local output_folder = "2023-0410-Star" .. AllheroStar .. "-1-"
local pvp_bot_csv = "BotPVPTeams"
local defaultSuperAwake = {
  _status = 0,
  _sun = 0,
  _moon = 0,
  _star = 0
}
local bot_parameter_list = {
  max_rank = 10,
  pvp = {
    arenaLevel = 80,
    generationNum = generation_max,
    heroStar = AllheroStar,
    teamNumber = 20,
    heroAwake = {
      _status = 0,
      _str = 0,
      _int = 0,
      _agi = 0
    },
    heroSuperAwake = defaultSuperAwake,
    heroPet = nil,
    SelectedHeroeIds = {
      [1] = true,
      [2] = true,
      [3] = true,
      [4] = true,
      [5] = true,
      [6] = true,
      [7] = true,
      [8] = true,
      [10] = true,
      [11] = true,
      [12] = true,
      [13] = true,
      [14] = true,
      [15] = true,
      [16] = true,
      [17] = true,
      [18] = true,
      [19] = true,
      [21] = true,
      [22] = true,
      [23] = true,
      [24] = true,
      [25] = true,
      [26] = true,
      [27] = true,
      [28] = true,
      [29] = true,
      [30] = true,
      [31] = true,
      [32] = true,
      [33] = true,
      [35] = true,
      [37] = true,
      [38] = true,
      [39] = true,
      [40] = true,
      [41] = true,
      [42] = true,
      [43] = true,
      [45] = true,
      [46] = true,
      [49] = true,
      [50] = true,
      [52] = true,
      [54] = true,
      [55] = true,
      [61] = true,
      [65] = true,
      [68] = true,
      [73] = true,
      [81] = true,
      [95] = true,
      [10011] = true,
      [10014] = true,
      [10022] = true,
      [10028] = true,
      [10043] = true,
      [10049] = true,
      [10076] = true,
      [10110] = true
    },
    cullHeroeIds = {},
    fashionList = {},
    specialHeroIds = {},
    highlight = {}
  },
  comment = "100,aller",
  stage = {}
}
local multiplier = 3125
local moder = 34359738337
local random_seed = 1

local function rand()
  local next_seed = random_seed * multiplier % moder
  local ret = next_seed / moder
  random_seed = next_seed
  if do_battle_log then
    btlog("Rand:" .. ret)
  end
  return ret
end

ed.rand = rand

local function srand(seed)
  if seed == 0 then
    print("Error:srand(0)")
    seed = 1
  elseif do_battle_log then
    btlog("srand(" .. seed .. ")")
  end
  random_seed = seed
  if ed.run_with_scene then
    ed.battleshare.getRseed(seed)
  end
end

ed.srand = srand

local function descFrame(info)
  local funcname = info.name or "?"
  local short_src = info.short_src or "nil"
  local linedefined = info.linedefined or -1
  local currentline = info.currentline or -1
  if funcname ~= "?" then
    funcname = "'" .. funcname .. "'"
  else
    funcname = string.format("<%s:%i>", short_src, linedefined)
  end
  return string.format("%s:%i: in function %s", short_src, currentline, funcname)
end

function BotDebug(msg)
  if enable_dump then
    if senddumpfile then
      local text = tostring(msg) .. "\n" .. debug.traceback()
      senddumpfile(text)
    end
    enable_dump = false
  end
  local p = EDLog and EDLog or print
  if ed.enableBotMode then
    p = print
  end
  if ed.debug_mode and not EDFLAGWIN32 then
    local _p = p
    
    function p(msg)
      _p(msg)
      debugError.showError(msg)
    end
  end
  if ed.BattleParams then
    for k = 1, 2 do
      local infoStr = ""
      for i = 1, #ed.BattleParams[k] do
        infoStr = infoStr .. ed.BattleParams[k][i].name .. " "
      end
      p(infoStr)
    end
    print("Rand Seed", ed.BattleParams[3])
    print("Tick Num", ed.BattleParams[4])
  end
  p("----------------------------------------")
  p(tostring(msg))
  if msg then
    p("LUA ERROR: " .. tostring(msg))
  end
  local i = 2
  local info = debug.getinfo(i)
  p("Stack traceback:")
  repeat
    p(string.format("[%i]\t%s", i - 2, descFrame(info)))
    i = i + 1
    info = debug.getinfo(i)
  until not info
  p("----------------------------------------")
  if EDFLAGWIN32 then
    EDConsoleEnable(0)
    debug.debug()
    EDConsoleEnable(1)
  elseif EDFLAGSVR then
    debug.debug()
  end
end

xpcall(function()
  local ed = ed
  ed.run_with_scene = false
  CCNode = {}
  CCSprite = {}
  ed.HpBar = {}
  EDLog = log
  require("resource_manager")
  require("datatable")
  require("battle/edp")
  require("battle/battle_engine")
  require("gamedatatables/gamedatatables")
  require("gamedatatables/unittable")
  require("gamedatatables/rechargemetatable")
  require("gamedatatables/herotasktable")
  require("gamedatatables/challengetable")
  require("gamedatatables/SkillGrouptable")
  if bot_parameter_list.max_rank then
    ed.parameter.unit_max_rank = bot_parameter_list.max_rank
  end
  
  local function sortHeroes(list)
    local function attackRange(hid)
      local autoAttack = ed.lookupDataTable("Unit", "Basic Skill", hid)
      
      return ed.lookupDataTable("Skill", "Max Range", autoAttack, 0)
    end
    
    local function sortCondition(a, b)
      if a._tid ~= b._tid and attackRange(a._tid) == attackRange(b._tid) then
        print("id:" .. a._tid .. " and id:" .. b._tid .. " has equal attack range.")
        debug.debug()
      end
      return attackRange(a._tid) < attackRange(b._tid)
    end
    
    table.sort(list, sortCondition)
  end
  
  local function test(stage_id, bot_id, lv, stars)
    local bot = ed.lookupDataTable("BotPVETeams", nil, bot_id)
    local heroes = {}
    for i = 1, 5 do
      local id = bot["Hero ID " .. i]
      local hero = {
        _tid = id,
        _level = lv,
        _stars = stars
      }
      table.insert(heroes, hero)
    end
    sortHeroes(heroes)
    local stage = ed.lookupDataTable("Stage", nil, stage_id)
    ed.engine:enterStage(stage, heroes, true, nil, nil, nil, useBonus and {
      battleBonus = bonusInfo.selfBonus
    } or nil)
    while ed.engine.running do
      ed.engine:tick()
    end
    local result = ed.engine.result_stars
    return result
  end
  
  local function grade(stage_id, bot_id, stars)
    local lvmin = 1
    local lvmax = ed.lookupDataTable("Stage", "Monster Level", stage_id) * 2
    while lvmin < lvmax do
      local lv = math.floor((lvmin + lvmax) / 2)
      local result = test(stage_id, bot_id, lv, stars)
      if 0 < result then
        lvmax = lv
      else
        lvmin = lv + 1
      end
    end
    return lvmax
  end
  
  local function bot_main()
    local bots = ed.getDataTable("BotPVETeams")
    local bot_count = 32
    while true do
      print("Input PVE Start Stage ID: ")
      local stagebegin = io.read("*n")
      print("Input PVE End Stage ID: ")
      local stageend = io.read("*n")
      print("Input Bot Stars: ")
      local stars = io.read("*n")
      print("***  Please Wait A Minite  ***")
      for stage = stagebegin, stageend do
        local stageInfo = ed.getDataTable("Stage")[stage]
        if stageInfo then
          local sum = 0
          local squm = 0
          for i, bot in ipairs(bots) do
            if i > bot_count then
              break
            end
            local lv = grade(stage, i, stars)
            local log = "Bot:" .. i .. " Lv:" .. lv
            sum = sum + lv
            squm = squm + lv * lv
          end
          local avg = sum / bot_count
          local stdev = (squm / bot_count - avg * avg) ^ 0.5
          print(string.format("Difficulty of Stage [%i] is: Lv %f [Std Dev %f]", stage, avg, stdev))
        end
      end
      print([[

==========================
]])
    end
  end
  
  collectgarbage("setpause", 100)
  collectgarbage("setstepmul", 5000)
  if not arg then
    arg = {"-pvp"}
    arg = {"-pvp"}
  end
  if arg[1] == "-pvp" then
  elseif arg[1] == "-guild" then
  elseif arg[1] == "-2" then
  else
    bot_main()
  end
end, BotDebug)
