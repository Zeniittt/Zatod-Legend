function ccc3(r, g, b)
end

package.path = package.path .. ";./lib/?.lua;./lua/?.lua"
require("edebug")
require("tools")
require("pet/pet")
require("hero")
ed.enableBotMode = true
ed.enableMaxAttStrategy = true
local repeatMax = 2000
local generationMax = 400
local arenaHeroStar = 5
local arenaLevel = 80
local maxRank = 13
local maxShardLevel = 25
local peakbuff
local output_folder = "2025-0612-level-" .. arenaLevel .. "-Star-" .. arenaHeroStar .. "-maxRank-" .. maxRank .. "-NoLegendEquip" .. "-4-"
local pvp_bot_csv = "BotPVPTeams"
local bot_parameter_list = {
  maxRank = maxRank,
  pvp = {
    arenaLevel = arenaLevel,
    generationNum = generationMax,
    heroStar = arenaHeroStar,
    teamNumber = 20,
    showHeroDisplayName = true,
    has_legendEquip = false,
    SelectedHeroeIds = {
      [1] = true,
      [2] = true,
      [3] = true,
      [4] = true,
      [5] = true,
      [6] = true,
      [7] = true,
      [8] = true,
      [9] = true,
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
      [20] = true,
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
      [34] = true,
      [35] = true,
      [37] = true,
      [38] = true,
      [39] = true,
      [40] = true,
      [41] = true,
      [42] = true,
      [43] = true,
      [44] = true,
      [45] = true,
      [46] = true,
      [47] = true,
      [49] = true,
      [50] = true,
      [51] = true,
      [52] = true,
      [53] = true,
      [54] = true,
      [55] = true,
      [56] = true,
      [57] = true,
      [58] = true,
      [59] = true,
      [60] = true,
      [61] = true,
      [62] = true,
      [63] = true,
      [64] = true,
      [65] = true,
      [66] = true,
      [67] = true,
      [68] = true,
      [70] = true,
      [71] = true,
      [72] = true,
      [73] = true,
      [74] = true,
      [75] = true,
      [76] = true,
      [77] = true,
      [80] = true,
      [81] = true,
      [83] = true,
      [86] = true,
      [91] = true,
      [95] = true,
      [99] = true,
      [10002] = true,
      [10004] = true,
      [10009] = true,
      [10011] = true,
      [10012] = true,
      [10013] = true,
      [10014] = true,
      [10020] = true,
      [10021] = true,
      [10022] = true,
      [10023] = true,
      [10025] = true,
      [10028] = true,
      [10029] = true,
      [10043] = true,
      [10049] = true,
      [10076] = true,
      [10102] = true,
      [10103] = true,
      [10110] = true,
      [10203] = true
    },
    cullHeroeIds = {},
    fashionList = {},
    shardList = {
      [1] = 1000011,
      [13] = 1000131,
      [10] = 1000101,
      [26] = 1000261,
      [7] = 1000071,
      [68] = 1000681,
      [25] = 1000251,
      [30] = 1000301,
      [50] = 1000501,
      [37] = 1000371,
      [54] = 1000541,
      [55] = 1000551,
      [24] = 1000241,
      [31] = 1000311,
      [6] = 1000061,
      [11] = 1000111,
      [42] = 1000421,
      [46] = 1000461,
      [12] = 1000121,
      [16] = 1000161,
      [27] = 1000271,
      [10022] = 1100221
    },
    astrolabeList = {
      [2] = {
        _level = 80,
        _stars = {
          {
            _index = 1,
            _id = 2,
            _value = 50
          },
          {
            _index = 2,
            _id = 3,
            _value = 1200
          },
          {
            _index = 3,
            _id = 4,
            _value = 65
          },
          {
            _index = 4,
            _id = 7,
            _value = 21
          },
          {
            _index = 5,
            _id = 9,
            _value = 33
          }
        }
      },
      [29] = {
        _level = 80,
        _stars = {
          {
            _index = 1,
            _id = 1,
            _value = 50
          },
          {
            _index = 2,
            _id = 3,
            _value = 1200
          },
          {
            _index = 3,
            _id = 4,
            _value = 65
          },
          {
            _index = 4,
            _id = 7,
            _value = 9
          },
          {
            _index = 5,
            _id = 10,
            _value = 9
          }
        }
      },
      [10076] = {
        _level = 80,
        _stars = {
          {
            _index = 1,
            _id = 2,
            _value = 50
          },
          {
            _index = 2,
            _id = 3,
            _value = 1200
          },
          {
            _index = 3,
            _id = 4,
            _value = 100
          },
          {
            _index = 4,
            _id = 5,
            _value = 52
          },
          {
            _index = 5,
            _id = 8,
            _value = 25
          }
        }
      },
      [35] = {
        _level = 80,
        _stars = {
          {
            _index = 1,
            _id = 2,
            _value = 50
          },
          {
            _index = 2,
            _id = 3,
            _value = 1200
          },
          {
            _index = 3,
            _id = 4,
            _value = 100
          },
          {
            _index = 4,
            _id = 5,
            _value = 52
          },
          {
            _index = 5,
            _id = 10,
            _value = 22
          }
        }
      },
      [47] = {
        _level = 80,
        _stars = {
          {
            _index = 1,
            _id = 1,
            _value = 50
          },
          {
            _index = 2,
            _id = 3,
            _value = 1200
          },
          {
            _index = 3,
            _id = 4,
            _value = 65
          },
          {
            _index = 4,
            _id = 7,
            _value = 22
          },
          {
            _index = 5,
            _id = 9,
            _value = 37
          }
        }
      },
      [49] = {
        _level = 80,
        _stars = {
          {
            _index = 1,
            _id = 1,
            _value = 50
          },
          {
            _index = 2,
            _id = 3,
            _value = 1200
          },
          {
            _index = 3,
            _id = 5,
            _value = 52
          },
          {
            _index = 4,
            _id = 6,
            _value = 40
          },
          {
            _index = 5,
            _id = 10,
            _value = 10
          }
        }
      },
      [17] = {
        _level = 80,
        _stars = {
          {
            _index = 1,
            _id = 2,
            _value = 50
          },
          {
            _index = 2,
            _id = 3,
            _value = 1200
          },
          {
            _index = 3,
            _id = 4,
            _value = 100
          },
          {
            _index = 4,
            _id = 5,
            _value = 52
          },
          {
            _index = 5,
            _id = 10,
            _value = 22
          }
        }
      },
      [58] = {
        _level = 80,
        _stars = {
          {
            _index = 1,
            _id = 1,
            _value = 50
          },
          {
            _index = 2,
            _id = 3,
            _value = 1200
          },
          {
            _index = 3,
            _id = 4,
            _value = 65
          },
          {
            _index = 4,
            _id = 7,
            _value = 22
          },
          {
            _index = 5,
            _id = 9,
            _value = 37
          }
        }
      },
      [81] = {
        _level = 80,
        _stars = {
          {
            _index = 1,
            _id = 1,
            _value = 50
          },
          {
            _index = 2,
            _id = 3,
            _value = 1200
          },
          {
            _index = 3,
            _id = 5,
            _value = 52
          },
          {
            _index = 4,
            _id = 6,
            _value = 40
          },
          {
            _index = 5,
            _id = 10,
            _value = 10
          }
        }
      },
      [61] = {
        _level = 80,
        _stars = {
          {
            _index = 1,
            _id = 2,
            _value = 50
          },
          {
            _index = 2,
            _id = 3,
            _value = 1200
          },
          {
            _index = 3,
            _id = 4,
            _value = 100
          },
          {
            _index = 4,
            _id = 5,
            _value = 52
          },
          {
            _index = 5,
            _id = 10,
            _value = 22
          }
        }
      },
      [72] = {
        _level = 80,
        _stars = {
          {
            _index = 1,
            _id = 1,
            _value = 50
          },
          {
            _index = 2,
            _id = 3,
            _value = 1200
          },
          {
            _index = 3,
            _id = 4,
            _value = 65
          },
          {
            _index = 4,
            _id = 7,
            _value = 22
          },
          {
            _index = 5,
            _id = 9,
            _value = 37
          }
        }
      },
      [10110] = {
        _level = 80,
        _stars = {
          {
            _index = 1,
            _id = 1,
            _value = 50
          },
          {
            _index = 2,
            _id = 3,
            _value = 1200
          },
          {
            _index = 3,
            _id = 5,
            _value = 52
          },
          {
            _index = 4,
            _id = 6,
            _value = 40
          },
          {
            _index = 5,
            _id = 10,
            _value = 10
          }
        }
      }
    },
    petList = {},
    specialHeroIds = {},
    highlight = {},
    uniqueLegendEquipIds = {
      [1] = true,
      [2] = true,
      [3] = true,
      [4] = true
    },
    normalLegendEquipIds = {
      [5] = true,
      [6] = true,
      [7] = true,
      [8] = true
    },
    p_uniqueLegendEquip = 0.5,
    specialHeroLegendEquips = {},
    legendEquipsStar = {
      [1] = 3,
      [2] = 3,
      [3] = 3,
      [4] = 3,
      [5] = 5,
      [6] = 5,
      [7] = 5,
      [8] = 5
    },
    checkSameTeamWithLegendEquip = true
  },
  comment = "100,aller",
  stage = {}
}
local multiplier = 3125
local moder = 34359738337
local randomSeed = 1

local function rand()
  local nextSeed = randomSeed * multiplier % moder
  local ret = nextSeed / moder
  randomSeed = nextSeed
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
  randomSeed = seed
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
  EDLog = log
  ed.HpBar = {}
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
  require("bot_analyze")
  if bot_parameter_list.maxRank then
    ed.parameter.unit_max_rank = bot_parameter_list.maxRank
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
  
  local function canPassStage(stageId, botId, lv, stars)
    local bot = ed.lookupDataTable("BotPVETeams", nil, botId)
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
    local stage = ed.lookupDataTable("Stage", nil, stageId)
    ed.engine:enterStage(stage, heroes, true)
    while ed.engine.running do
      ed.engine:tick()
    end
    local result = ed.engine.result_stars
    return result
  end
  
  local function getMinPassLevel(stageId, botId, stars)
    local lvmin = 1
    local lvmax = ed.lookupDataTable("Stage", "Monster Level", stageId) * 2
    while lvmin < lvmax do
      local lv = math.floor((lvmin + lvmax) / 2)
      local result = canPassStage(stageId, botId, lv, stars)
      if 0 < result then
        lvmax = lv
      else
        lvmin = lv + 1
      end
    end
    return lvmax
  end
  
  local function grade_guild(stageId, waveId, botId, levelId, stars)
    local bot = ed.lookupDataTable("BotRaidTeams", nil, botId)
    local heroes = {}
    for i = 1, 5 do
      local id = bot["Hero ID " .. i]
      local hero = {
        _tid = id,
        _level = levelId,
        _stars = stars
      }
      table.insert(heroes, hero)
    end
    sortHeroes(heroes)
    local stage = ed.lookupDataTable("Stage", nil, stageId)
    local guildInstanceInfo = {}
    guildInstanceInfo._wave_index = waveId
    guildInstanceInfo._hp_info = {
      10000,
      10000,
      10000,
      10000,
      10000
    }
    guildInstanceInfo._raid_id = 1
    ed.engine:enterGuildInstance(stage, heroes, guildInstanceInfo, true)
    local totalHp = ed.engine:getEnemyTotalHp()
    while ed.engine.running do
      ed.engine:tick()
    end
    local endTime = ed.engine.ticks * ed.tick_interval
    local percent, dpsHp
    if ed.engine.wave_id ~= waveId then
      percent = 1
      dpsHp = totalHp
      endTime = 90
    else
      percent, dpsHp = ed.engine:getEenemyConsumePercent()
    end
    return percent, dpsHp, endTime
  end
  
  local function grade_guild2(stageId, waveId, botId, levelId, stars, enemyStartHpInfo)
    local bot = ed.lookupDataTable("BotRaidTeams", nil, botId)
    local heroes = {}
    for i = 1, 5 do
      local id = bot["Hero ID " .. i]
      local hero = {
        _tid = id,
        _level = levelId,
        _stars = stars
      }
      table.insert(heroes, hero)
    end
    sortHeroes(heroes)
    local stage = ed.lookupDataTable("Stage", nil, stageId)
    local guildInstanceInfo = {}
    guildInstanceInfo._wave_index = waveId
    if enemyStartHpInfo then
      guildInstanceInfo._hp_info = {}
      for i, info in ipairs(enemyStartHpInfo) do
        guildInstanceInfo._hp_info[i] = math.floor(info.HP / info.SumHP * 10000)
      end
    else
      guildInstanceInfo._hp_info = {
        10000,
        10000,
        10000,
        10000,
        10000
      }
    end
    guildInstanceInfo._raid_id = 1
    ed.engine:enterGuildInstance(stage, heroes, guildInstanceInfo, true)
    local tmpEnemyHpInfo = ed.engine:getEnemyFinalHpInfo()
    enemyStartHpInfo = enemyStartHpInfo or tmpEnemyHpInfo
    while ed.engine.running do
      ed.engine:tick()
    end
    local percent, enemyEndHpInfo
    if ed.engine.wave_id ~= waveId then
      percent = 1
      for i, info in ipairs(tmpEnemyHpInfo) do
        if info.SumHP ~= 0 then
          info.HP = 0
        end
      end
      enemyEndHpInfo = tmpEnemyHpInfo
    else
      percent = ed.engine:getEenemyConsumePercent()
      enemyEndHpInfo = ed.engine:getEnemyFinalHpInfo()
    end
    local tmp = enemyStartHpInfo
    return percent, tmp, enemyEndHpInfo
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
            local lv = getMinPassLevel(stage, i, stars)
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
  
  local function bot_guild()
    local bots = ed.getDataTable("BotRaidTeams")
    local bot_count = 32
    local output_folder = "guild_boss_data"
    os.execute("md " .. output_folder)
    local out = io.open(string.format(output_folder .. "/guild_boss_data_15to20_80to110.txt"), "w+")
    while true do
      print("Input stage ID start: ")
      local stageIdBegin = io.read("*n")
      print("Input stage ID end: ")
      local stageIdEnd = io.read("*n")
      local stageId = 0
      print("Input wave ID: ")
      local waveBegin = io.read("*n")
      local waveEnd = io.read("*n")
      print("Input bot Level Range: ")
      local levelBegin = io.read("*n")
      local levelEnd = io.read("*n")
      print("Input bot stars: 5 ")
      local stars = 5
      local specialLevelList = {
        90,
        100,
        110
      }
      for stageId = stageIdBegin, stageIdEnd do
        if stageId then
          for waveId = waveBegin, waveEnd do
            for levelId = levelBegin, levelEnd do
              local sum = 0
              local squm = 0
              local passNum = 0
              local sumDpsHp = 0
              local i = 1
              local sumTime = 0
              local maxDps = {0}
              local maxTeamCode = {0}
              for i, bot in ipairs(bots) do
                if i > bot_count then
                  break
                end
                local percent, dpsHp, time = grade_guild(stageId, waveId, i, levelId, stars)
                if 1 == percent then
                  passNum = passNum + 1
                end
                sum = sum + percent
                squm = squm + percent * percent
                sumDpsHp = sumDpsHp + dpsHp
                sumTime = sumTime + time
                local sortCode
                for code = 1, #maxDps do
                  if dpsHp >= maxDps[code] then
                    sortCode = code
                    break
                  end
                end
                if sortCode then
                  local tempCode = #maxDps + 1
                  while sortCode < tempCode do
                    maxDps[tempCode] = maxDps[tempCode - 1]
                    maxTeamCode[tempCode] = maxTeamCode[tempCode - 1]
                    tempCode = tempCode - 1
                  end
                  maxDps[tempCode] = dpsHp
                  maxTeamCode[tempCode] = i
                end
              end
              local avg = sum / bot_count
              local stdev = (squm / bot_count - avg * avg) ^ 0.5
              local dpsHpAvg = sumDpsHp / bot_count
              local avgTime = sumTime / bot_count
              str = string.format("stage[%i],wave[%i],Level[%i],Diffculty factor is,%.2f%%,%.2f%%,%i,%.2f,Passinfo,%i,%.2f%% ,Time, %.2f,max3team,%i,%i,%i,%i,%i,%i", stageId, waveId, levelId, avg * 100, stdev * 100, math.floor(1 / avg), dpsHpAvg, passNum, passNum / bot_count * 100, avgTime, maxTeamCode[1], maxDps[1], maxTeamCode[2], maxDps[2], maxTeamCode[3], maxDps[3])
              print(str)
              if out then
                out:write(str)
                out:write("\n")
              end
            end
            print("-----------------------------------------------")
          end
        end
      end
      if out then
        out:flush()
        out:close()
      end
    end
  end
  
  local function getDpsNum(sourceHpInfo, finalHpInfo)
    local sumDps = 0
    for i, info in ipairs(sourceHpInfo) do
      if info.SumHP ~= 0 then
        sumDps = sumDps + (info.HP - finalHpInfo[i].HP)
      end
    end
    return sumDps
  end
  
  local function getEveryEnemyDpsNum(sourceHpInfo, finalHpInfo)
    local result = {}
    for i, info in ipairs(sourceHpInfo) do
      local dps = info.HP - finalHpInfo[i].HP
      result[i] = dps
    end
    return result
  end
  
  local function getDpsPercent(sourceHpInfo, sumDpsNum)
    local sumTotalHp = 0
    for i, info in ipairs(sourceHpInfo) do
      sumTotalHp = sumTotalHp + info.SumHP
    end
    return sumDpsNum / sumTotalHp
  end
  
  local function getLeftDpsPercent(finalHpInfo)
    local sumHp = 0
    local sumTotalHp = 0
    for i, info in ipairs(finalHpInfo) do
      sumHp = sumHp + info.HP
      sumTotalHp = sumTotalHp + info.SumHP
    end
    return sumHp / sumTotalHp
  end
  
  local function enterWave(stageId, waveId, levelId, stars, botCount, enemeyHpInfo)
    local bots = ed.getDataTable("BotPVETeams")
    local passNum = 0
    local sumDps = 0
    local sumDpsPercent = 0
    local sumLeftDpsPercent = 0
    local everyEnemyDps = {}
    local _enemySourceHpInfo
    local i = 1
    for i, bot in ipairs(bots) do
      if botCount < i then
        break
      end
      local percent, enemySourceHpInfo, enemyFinalHpInfo = grade_guild2(stageId, waveId, i, levelId, stars, enemeyHpInfo)
      _enemySourceHpInfo = _enemySourceHpInfo or enemySourceHpInfo
      local dps = getDpsNum(enemySourceHpInfo, enemyFinalHpInfo)
      sumDps = sumDps + dps
      sumDpsPercent = sumDpsPercent + getDpsPercent(enemySourceHpInfo, dps)
      sumLeftDpsPercent = sumLeftDpsPercent + getLeftDpsPercent(enemyFinalHpInfo)
      local tmpEveryEnemyDps = getEveryEnemyDpsNum(enemySourceHpInfo, enemyFinalHpInfo)
      for i, v in ipairs(tmpEveryEnemyDps) do
        if not everyEnemyDps[i] then
          everyEnemyDps[i] = v
        else
          everyEnemyDps[i] = everyEnemyDps[i] + v
        end
      end
      if 1 == percent then
        passNum = passNum + 1
      end
    end
    local avgDpsNum = sumDps / botCount
    local avgDpsPercent = sumDpsPercent / botCount
    local avgLeftDpsPercent = sumLeftDpsPercent / botCount
    local passPercent = passNum / botCount
    print(string.format("WaveId %d , dps %.2f , dpsPercent %.2f%% , leftDpsPercent %.2f%% , passPercent %.2f%%", waveId, avgDpsNum, avgDpsPercent * 100, avgLeftDpsPercent * 100, passPercent * 100))
    local nextEnemyHpInfo = {}
    for i, v in ipairs(_enemySourceHpInfo) do
      local hp = _enemySourceHpInfo[i].HP - everyEnemyDps[i] / botCount
      local sumHp = _enemySourceHpInfo[i].SumHP
      nextEnemyHpInfo[i] = {HP = 0, SumHP = 0}
      nextEnemyHpInfo[i].HP = hp
      nextEnemyHpInfo[i].SumHP = sumHp
    end
    local isPassWave = passNum >= botCount / 2
    return isPassWave, nextEnemyHpInfo
  end
  
  local function bot_guild2()
    while true do
      print("Input stage ID: ")
      local stageId = io.read("*n")
      print("Input wave ID: ")
      local waveId = io.read("*n")
      print("Input bot Level ID: ")
      local levelId = 5
      print("Input bot stars: ")
      local stars = io.read("*n")
      if stageId then
        local enemeyHpInfo
        local isPassWave = false
        local bot_count = 100
        while true do
          isPassWave, enemeyHpInfo = enterWave(stageId, waveId, levelId, stars, bot_count, enemeyHpInfo)
          if waveId == 3 then
            if isPassWave then
              break
            end
          elseif isPassWave then
            waveId = waveId + 1
            enemeyHpInfo = nil
          end
        end
      end
    end
  end
  
  local function pvp_ShardCheck(heroid)
    local shardList = bot_parameter_list.pvp.shardList
    if shardList then
      return shardList[heroid]
    end
    return nil
  end
  
  local function pvp_AstrolabeCheck(heroid)
    local astrolabeList = bot_parameter_list.pvp.astrolabeList
    if astrolabeList then
      return astrolabeList[heroid]
    end
    return nil
  end
  
  local function pvp_LegendEquipCheck(heroid)
    local specialHeroLegendEquips = bot_parameter_list.pvp.specialHeroLegendEquips
    local uniqueLegendEquipIds = bot_parameter_list.pvp.uniqueLegendEquipIds
    if specialHeroLegendEquips and specialHeroLegendEquips[heroid] then
      local equipId = specialHeroLegendEquips[heroid]
      return {
        id = equipId,
        isUnique = uniqueLegendEquipIds[equipId]
      }
    end
    return nil
  end
  
  local function pvp_randomLegendEquip(uniqueLegendEquipInTeam)
    local uniqueLegendEquipDic = bot_parameter_list.pvp.uniqueLegendEquipDic
    local uniqueLegendEquipInTeamCnt = 0
    for k, v in pairs(uniqueLegendEquipInTeam) do
      if 0 < v then
        uniqueLegendEquipInTeamCnt = uniqueLegendEquipInTeamCnt + 1
      end
    end
    if uniqueLegendEquipInTeamCnt < #uniqueLegendEquipDic and math.random() < bot_parameter_list.pvp.p_uniqueLegendEquip then
      local equipIdx, uniqueId
      repeat
        equipIdx = math.random(1, #uniqueLegendEquipDic)
        uniqueId = uniqueLegendEquipDic[equipIdx]
      until uniqueLegendEquipInTeam[uniqueId] == nil or uniqueLegendEquipInTeam[uniqueId] == 0
      return uniqueId, true
    end
    local normalLegendEquipDic = bot_parameter_list.pvp.normalLegendEquipDic
    local equipIdx = math.random(1, #normalLegendEquipDic)
    return normalLegendEquipDic[equipIdx], false
  end
  
  local function pvp_checkUniqueLegendEquipInTeam(uniqueLegendEquipInTeam)
    for k, v in pairs(uniqueLegendEquipInTeam) do
      if 1 < v then
        assert(false, "same uniqueLegendEquipInTeam:" .. k)
      end
    end
  end
  
  local function pvp_legendEquipSoltsEquals(sonLegendEquipSolts, teamListLegendEquipSolts)
    if not bot_parameter_list.pvp.has_legendEquip then
      return true
    end
    if not bot_parameter_list.pvp.checkSameTeamWithLegendEquip then
      return true
    end
    local check_hash = {}
    for _, v in ipairs(sonLegendEquipSolts) do
      check_hash[v] = (check_hash[v] or 0) + 1
    end
    for _, v in ipairs(teamListLegendEquipSolts) do
      if not check_hash[v] then
        return false
      end
      check_hash[v] = check_hash[v] - 1
      if check_hash[v] < 0 then
        return false
      end
    end
    return true
  end
  
  local function expected_score(rating_a, rating_b)
    return 1 / (1 + 10 ^ ((rating_b - rating_a) / 400))
  end
  
  local function update_elo_rating(rating_a, rating_b, score_a, score_b, k, is_defense_a)
    local expected_a = expected_score(rating_a, rating_b)
    local expected_b = expected_score(rating_b, rating_a)
    if is_defense_a then
      k = k * 1
    end
    local new_rating_a = rating_a + k * (score_a - expected_a)
    local new_rating_b = rating_b + k * (score_b - expected_b)
    return new_rating_a, new_rating_b
  end
  
  local function pvp_main(arenaLevel, generationNum, thread, retime)
    local totalTime = 0
    local totalTimes2 = 0
    if not arenaLevel then
      print("Arena level = ? ")
      arenaLevel = io.read("*n")
    end
    if not generationNum then
      print("Generation Num = ? ")
      generationNum = io.read("*n")
    end
    ed.srand(os.time())
    local showHeroDisplayName = bot_parameter_list.pvp.showHeroDisplayName
    local heroList = {}
    local heroDisplayName = {}
    for id, info in pairs(ed.getDataTable("Unit")) do
      if type(id) == "number" and bot_parameter_list.pvp.SelectedHeroeIds[id] and not bot_parameter_list.pvp.cullHeroeIds[id] then
        local hero = {
          _tid = id,
          _level = arenaLevel,
          _stars = bot_parameter_list.pvp.heroStar,
          name = ed.lookupDataTable("Unit", "Name", id)
        }
        if pvp_ShardCheck(id) then
          hero._shard = {
            _id = pvp_ShardCheck(id),
            _level = maxShardLevel
          }
        end
        hero._astrolabe = pvp_AstrolabeCheck(id)
        if bot_parameter_list.pvp.specialHeroIds[id] then
          hero._stars = bot_parameter_list.pvp.specialHeroIds[id]
        end
        table.insert(heroList, hero)
        heroDisplayName[hero.name] = ed.lookupDataTable("Unit", "Display Name", id)
      end
    end
    local has_legendEquip = bot_parameter_list.pvp.has_legendEquip
    local uniqueLegendEquipIds = bot_parameter_list.pvp.uniqueLegendEquipIds
    local normalLegendEquipIds = bot_parameter_list.pvp.normalLegendEquipIds
    local uniqueLegendEquipDic = {}
    local normalLegendEquipDic = {}
    for k, v in pairs(uniqueLegendEquipIds) do
      table.insert(uniqueLegendEquipDic, k)
    end
    for k, v in pairs(normalLegendEquipIds) do
      table.insert(normalLegendEquipDic, k)
    end
    bot_parameter_list.pvp.uniqueLegendEquipDic = uniqueLegendEquipDic
    bot_parameter_list.pvp.normalLegendEquipDic = normalLegendEquipDic
    local legendEquipsStar = bot_parameter_list.pvp.legendEquipsStar
    local teams = bot_parameter_list.pvp.teamNumber
    local teamList = {}
    for i = 1, teams do
      for k = 1, #heroList do
        heroList[k].weight = math.random()
      end
      table.sort(heroList, function(a, b)
        return a.weight > b.weight
      end)
      local team = {
        heroes = {
          heroList[1],
          heroList[2],
          heroList[3],
          heroList[4],
          heroList[5]
        },
        position = i,
        score = 0
      }
      sortHeroes(team.heroes)
      table.insert(teamList, team)
      team.legendEquipSolts = {}
      local uniqueLegendEquipInTeam = {}
      if bot_parameter_list.pvp.specifyHeroID then
        local hasSpecifyHero = false
        local tid = bot_parameter_list.pvp.specifyHeroID
        for k = 1, #team.heroes do
          if team.heroes[k]._tid == tid then
            hasSpecifyHero = true
            break
          end
        end
        if not hasSpecifyHero then
          local hero = {
            _tid = tid,
            _level = arenaLevel,
            _stars = bot_parameter_list.pvp.heroStar,
            name = ed.lookupDataTable("Unit", "Name", tid)
          }
          if pvp_ShardCheck(tid) then
            hero._shard = {
              _id = pvp_ShardCheck(tid),
              _level = maxShardLevel
            }
          end
          hero._astrolabe = pvp_AstrolabeCheck(tid)
          hero.__specialLegendEquip = pvp_LegendEquipCheck(tid)
          if bot_parameter_list.pvp.specialHeroIds[hero._tid] then
            hero._stars = bot_parameter_list.pvp.specialHeroIds[hero._tid]
          end
          team.heroes[1] = hero
          if hero.__specialLegendEquip then
            team.legendEquipSolts[1] = hero.__specialLegendEquip.id
            if hero.__specialLegendEquip.isUnique then
              uniqueLegendEquipInTeam[team.legendEquipSolts[1]] = (uniqueLegendEquipInTeam[team.legendEquipSolts[1]] or 0) + 1
            end
          end
        end
      end
      if has_legendEquip then
        local legendEquipCnt = #team.heroes
        local start = team.legendEquipSolts[1] and 2 or 1
        for k = start, legendEquipCnt do
          local hero = team.heroes[k]
          hero.__specialLegendEquip = pvp_LegendEquipCheck(hero._tid)
          if hero.__specialLegendEquip then
            if hero.__specialLegendEquip.isUnique then
              uniqueLegendEquipInTeam[hero.__specialLegendEquip.id] = (uniqueLegendEquipInTeam[hero.__specialLegendEquip.id] or 0) + 1
            end
            team.legendEquipSolts[k] = hero.__specialLegendEquip.id
          else
            local legendEquipId, isUnique = pvp_randomLegendEquip(uniqueLegendEquipInTeam)
            if isUnique then
              uniqueLegendEquipInTeam[legendEquipId] = (uniqueLegendEquipInTeam[legendEquipId] or 0) + 1
            end
            team.legendEquipSolts[k] = legendEquipId
          end
        end
        pvp_checkUniqueLegendEquipInTeam(uniqueLegendEquipInTeam)
      end
    end
    local playerTeamHeroIds = bot_parameter_list.pvp.playerTeam
    local playerTeamSum = 0
    local heroes = {}
    if playerTeamHeroIds then
      for i, tid in ipairs(playerTeamHeroIds) do
        playerTeamSum = playerTeamSum + tid * tid
        table.insert(heroes, {
          _tid = tid,
          _level = arenaLevel,
          _stars = bot_parameter_list.pvp.heroStar,
          name = ed.lookupDataTable("Unit", "Name", tid)
        })
      end
      if #playerTeamHeroIds == 5 then
        table.insert(teamList, {
          heroes = heroes,
          position = teams + 1,
          score = 0
        })
      end
    end
    local output_folder_name = output_folder .. (thread and "thread-" .. thread or "") .. retime
    os.execute("md " .. output_folder_name)
    local params_out = io.open(string.format(output_folder_name .. "/[params].txt"), "w+")
    params_out:write("maxRank=" .. bot_parameter_list.maxRank .. "\n")
    params_out:write("teamNumber=" .. bot_parameter_list.pvp.teamNumber .. "\n")
    params_out:write("level=" .. bot_parameter_list.pvp.arenaLevel .. "\n")
    params_out:write("heroStar=" .. bot_parameter_list.pvp.heroStar .. "\n")
    params_out:write("cullHeroeIds={")
    for id, b in pairs(bot_parameter_list.pvp.cullHeroeIds) do
      if b then
        params_out:write(id .. ",")
      end
    end
    params_out:write("}\n")
    if bot_parameter_list.comment then
      params_out:write("comment=" .. bot_parameter_list.comment .. "\n")
    end
    params_out:flush()
    params_out:close()
    bot_analyze.output_folder = output_folder_name
    local analyze_team = bot_analyze.analyze_team
    local analyze_generationNum = bot_analyze.analyze_generationNum
    local all_out = io.open(string.format(output_folder_name .. "/arena_" .. arenaLevel .. ".txt"), "w+")
    for g = 1, generationNum do
      local teamCnt = #teamList
      for i = 1, #teamList do
        local team = teamList[i]
        team.score = 0
        team.winCnt = 0
        team.battleCnt = 0
        local son = {
          heroes = {},
          score = 0,
          winCnt = 0,
          battleCnt = 0,
          legendEquipSolts = {}
        }
        local pc = math.random()
        local p1, p2
        local kk = 0.3 + 0.6000000000000001 * g / generationNum
        if pc < kk then
          p1 = i
          p2 = i + 1
          p2 = teamCnt < p2 and 1 or p2
          if math.random() < 0.5 then
            p1 = p2
            p2 = i
          end
          local team1 = teamList[p1]
          local team2 = teamList[p2]
          for index = 1, math.floor(#team1.heroes / 2) do
            table.insert(son.heroes, team1.heroes[index])
          end
          for index = math.floor(#team2.heroes / 2) + 1, #team2.heroes do
            table.insert(son.heroes, team2.heroes[index])
          end
        end
        for j = 1, #team.heroes do
          local pm = math.random()
          local k = 0.7 - 0.6499999999999999 * g / generationNum
          if pm < k then
            local new = math.floor(math.random() * #heroList) + 1
            son.heroes[j] = heroList[new]
          elseif not son.heroes[j] then
            son.heroes[j] = team.heroes[j]
          end
        end
        son.legendEquipSolts = {}
        local specialLegendEquipSolts = {}
        local uniqueLegendEquipInSon = {}
        local legendEquipCnt = 0
        if bot_parameter_list.pvp.specifyHeroID then
          local tid = bot_parameter_list.pvp.specifyHeroID
          local hasSpecifyHero = false
          for k = 1, #team.heroes do
            if son.heroes[k]._tid == tid then
              hasSpecifyHero = true
              break
            end
          end
          if not hasSpecifyHero then
            local team = {
              _tid = tid,
              _level = arenaLevel,
              _stars = bot_parameter_list.pvp.heroStar,
              name = ed.lookupDataTable("Unit", "Name", tid)
            }
            if pvp_ShardCheck(tid) then
              team._shard = {
                _id = pvp_ShardCheck(tid),
                _level = maxShardLevel
              }
            end
            team._astrolabe = pvp_AstrolabeCheck(tid)
            team.__specialLegendEquip = pvp_LegendEquipCheck(tid)
            if bot_parameter_list.pvp.specialHeroIds[team._tid] then
              team._stars = bot_parameter_list.pvp.specialHeroIds[team._tid]
            end
            son.heroes[1] = team
            if team.__specialLegendEquip then
              specialLegendEquipSolts[1] = team.__specialLegendEquip.id
              if team.__specialLegendEquip.isUnique then
                uniqueLegendEquipInSon[specialLegendEquipSolts[1]] = (uniqueLegendEquipInSon[specialLegendEquipSolts[1]] or 0) + 1
              end
            end
          end
        end
        if has_legendEquip then
          legendEquipCnt = #son.heroes
          local start = specialLegendEquipSolts[1] and 2 or 1
          for k = start, legendEquipCnt do
            local hero = son.heroes[k]
            if hero.__specialLegendEquip then
              if hero.__specialLegendEquip.isUnique then
                uniqueLegendEquipInSon[hero.__specialLegendEquip.id] = (uniqueLegendEquipInSon[hero.__specialLegendEquip.id] or 0) + 1
              end
              specialLegendEquipSolts[k] = hero.__specialLegendEquip.id
            end
          end
          pvp_checkUniqueLegendEquipInTeam(uniqueLegendEquipInSon)
          if pc < kk then
            local team1 = teamList[p1]
            local team2 = teamList[p2]
            for index = 1, math.floor(#team1.legendEquipSolts / 2) do
              table.insert(son.legendEquipSolts, team1.legendEquipSolts[index])
            end
            for index = math.floor(#team2.legendEquipSolts / 2) + 1, #team2.legendEquipSolts do
              table.insert(son.legendEquipSolts, team2.legendEquipSolts[index])
            end
          end
          for j = 1, legendEquipCnt do
            if specialLegendEquipSolts[j] then
              son.legendEquipSolts[j] = specialLegendEquipSolts[j]
            else
              son.legendEquipSolts[j] = son.legendEquipSolts[j] or team.legendEquipSolts[j]
              local curEquipId = son.legendEquipSolts[j]
              if uniqueLegendEquipInSon[curEquipId] then
                son.legendEquipSolts[j] = nil
              elseif uniqueLegendEquipIds[curEquipId] then
                uniqueLegendEquipInSon[curEquipId] = (uniqueLegendEquipInSon[curEquipId] or 0) + 1
              end
            end
          end
          for j = start, legendEquipCnt do
            local pm = math.random()
            local k = 0.7 - 0.6499999999999999 * g / generationNum
            if pm < k or not son.legendEquipSolts[j] then
              local oldLegendEquip = son.legendEquipSolts[j]
              if oldLegendEquip and uniqueLegendEquipInSon[oldLegendEquip] and 0 < uniqueLegendEquipInSon[oldLegendEquip] then
                son.legendEquipSolts[j] = nil
                uniqueLegendEquipInSon[oldLegendEquip] = uniqueLegendEquipInSon[oldLegendEquip] - 1
              end
              local legendEquipId, isUnique = pvp_randomLegendEquip(uniqueLegendEquipInSon)
              if isUnique then
                uniqueLegendEquipInSon[legendEquipId] = (uniqueLegendEquipInSon[legendEquipId] or 0) + 1
              end
              son.legendEquipSolts[j] = legendEquipId
            end
          end
        end
        local check = true
        for j = 1, #son.heroes do
          for k = j + 1, #son.heroes do
            if son.heroes[j]._tid == son.heroes[k]._tid then
              check = false
            end
          end
        end
        if check then
          local hero_legendEquip_dic = {}
          for j = 1, legendEquipCnt do
            hero_legendEquip_dic[son.heroes[j]._tid] = son.legendEquipSolts[j]
          end
          sortHeroes(son.heroes)
          for j = 1, legendEquipCnt do
            son.legendEquipSolts[j] = hero_legendEquip_dic[son.heroes[j]._tid]
          end
          for t = 1, #teamList do
            local sum1 = 0
            local sum2 = 0
            for tt = 1, 5 do
              sum1 = sum1 + son.heroes[tt]._tid * son.heroes[tt]._tid
              sum2 = sum2 + teamList[t].heroes[tt]._tid * teamList[t].heroes[tt]._tid
            end
            if sum1 == sum2 and pvp_legendEquipSoltsEquals(son.legendEquipSolts, teamList[t].legendEquipSolts) then
              print("remove same team")
              check = false
              break
            end
          end
        end
        if check then
          table.insert(teamList, son)
        end
      end
      local totalTimes = 0
      local drawTimes = 0
      if has_legendEquip then
        for i = 1, #teamList do
          local team = teamList[i]
          for j = 1, #team.heroes do
            team.heroes[j]._legend_equip = {
              _equip = {
                _type_id = team.legendEquipSolts[j],
                _star = legendEquipsStar[team.legendEquipSolts[j]] or 5,
                _rank = 0
              }
            }
          end
        end
      end
      for i = 1, #teamList do
        local teamA = teamList[i]
        for j = i + 1, #teamList do
          local teamB = teamList[j]
          ed.BattleParams = {
            teamB.heroes,
            teamA.heroes,
            randomSeed,
            0
          }
          if peakbuff then
            ed.engine:enterPeakArena(teamB.heroes, teamA.heroes, 1, peakbuff)
          else
            ed.engine:enterArena(teamB.heroes, teamA.heroes, true, true)
          end
          totalTimes = totalTimes + 1
          local tickNum = 0
          while ed.engine.running do
            ed.BattleParams[4] = tickNum
            ed.engine:tick()
            tickNum = tickNum + 1
          end
          if 720 <= tickNum then
            drawTimes = drawTimes + 1
          end
          totalTime = totalTime + tickNum / 8
          totalTimes2 = totalTimes2 + 1
          local result = ed.engine.result_stars
          local winner = 0 < result and teamB or teamA
          local loser = result <= 0 and teamB or teamA
          local winnerScore, loserScore = update_elo_rating(winner.score, loser.score, 1, 0, 20, winner == teamA)
          winner.score = winnerScore
          loser.score = loserScore
          winner.battleCnt = winner.battleCnt + 1
          loser.battleCnt = loser.battleCnt + 1
          winner.winCnt = winner.winCnt + 1
        end
      end
      table.sort(teamList, function(a, b)
        return a.score > b.score
      end)
      local playerTeamIdx = 0
      local playerTeamScore = 0
      for t = 1, #teamList do
        local sum = 0
        for tt = 1, 5 do
          sum = sum + teamList[t].heroes[tt]._tid * teamList[t].heroes[tt]._tid
        end
        if sum == playerTeamSum then
          print("found player team", teamList[t].score)
          playerTeamIdx = t
          playerTeamScore = teamList[t].score
          break
        end
      end
      for i = #teamList, teams + 1, -1 do
        teamList[i] = nil
      end
      if g > generationNum - analyze_generationNum then
        analyze_team(g, teamList)
      end
      local out = io.open(string.format(output_folder_name .. "/arena_%i_Genetation_%i.txt", arenaLevel, g), "w+")
      print("Generation " .. g)
      for i = 1, #teamList do
        local team = teamList[i]
        local format = "%s:(%s)\t %s %s %s %s %s"
        local paras = {i}
        local displayNames = {}
        local windowFormat = "%s%s%s%s%s%s"
        local windowParas = {
          tostring(i)
        }
        local s
        if not team.position then
          s = "new"
        elseif i == team.position then
          s = "="
        else
          s = string.format("%+i", team.position - i)
        end
        windowParas[1] = paras[1] .. ":(" .. s .. ")"
        table.insert(paras, s)
        team.position = i
        for _, h in ipairs(team.heroes) do
          local _str = h.name
          if bot_parameter_list.pvp.highlight[h.name] then
            _str = _str .. bot_parameter_list.pvp.highlight[h.name]
          end
          table.insert(paras, h.name)
          table.insert(windowParas, _str)
          table.insert(displayNames, heroDisplayName[h.name] or h.name)
        end
        for i, ele in ipairs(windowParas) do
          local len = 10 - string.len(ele)
          for k = 1, len do
            windowParas[i] = windowParas[i] .. " "
          end
        end
        local specificStr = string.format(windowFormat, unpack(windowParas))
        local str2 = ""
        if has_legendEquip then
          str2 = string.format(" %d %d %d %d %d", unpack(team.legendEquipSolts))
        end
        local strName = showHeroDisplayName and string.format("     %s %s %s %s %s", unpack(displayNames)) or ""
        print(specificStr .. " score: " .. team.score .. str2)
        local str = string.format(format, unpack(paras))
        if out then
          out:write(str .. str2 .. " score: " .. team.score .. strName)
          out:write("\n")
        end
        local all_format = "%i,%s:(%s),%s,%s,%s,%s,%s,"
        local all_str = string.format(all_format, g, unpack(paras))
        local all_str2 = ""
        if has_legendEquip then
          all_str2 = string.format("%d,%d,%d,%d,%d,", unpack(team.legendEquipSolts))
        end
        if all_out then
          all_out:write(all_str .. all_str2 .. team.score)
          all_out:write("\n")
        end
      end
      print("Average Time: " .. totalTime / totalTimes2)
      print("Draw Times/Total:" .. drawTimes .. "/" .. totalTimes .. "(" .. drawTimes / totalTimes .. ") folder:" .. output_folder_name .. "|" .. bot_parameter_list.comment)
      if AxeAtk3Times then
        print("AxeAtk3Times/TotalLife:" .. AxeAtk3Times .. "/" .. AxeLiveTime .. "=" .. AxeAtk3Times / AxeLiveTime)
      end
      if FVUltLockFriendCnt then
        print("FVUltLockFriendCnt/FVUltTimes:" .. FVUltLockFriendCnt .. "/" .. FVUltTimes .. "=" .. FVUltLockFriendCnt / FVUltTimes)
      end
      if FVUltLockEnemyCnt then
        print("FVUltLockEnemyCnt/FVUltTimes:" .. FVUltLockEnemyCnt .. "/" .. FVUltTimes .. "=" .. FVUltLockEnemyCnt / FVUltTimes)
      end
      if FVUltKillCnt then
        print("FVUltKillCnt/FVUltTimes:" .. FVUltKillCnt .. "/" .. FVUltTimes .. "=" .. FVUltKillCnt / FVUltTimes)
      end
      if FVUltTimes then
        print("FVUltTimes/FVEnterTimes:" .. FVUltTimes .. "/" .. FVEnterTimes .. "=" .. FVUltTimes / FVEnterTimes)
      end
      if playerTeamIdx and 0 < playerTeamIdx then
        local str = string.format("found player team, pos: %d, score: %f", playerTeamIdx, playerTeamScore)
        out:write("\n" .. str .. "\n")
        all_out:write("\n" .. str .. "\n")
      end
      if out then
        out:flush()
        out:close()
      end
      if all_out then
        all_out:flush()
      end
    end
    if all_out then
      all_out:flush()
      all_out:close()
    end
  end
  
  collectgarbage("setpause", 100)
  collectgarbage("setstepmul", 5000)
  if not arg then
    arg = {"-pvp"}
    arg = {"-pvp"}
  end
  if arg[1] == "-pvp" then
    local thread = arg[2]
    local time = os.time()
    math.randomseed(os.time() + (thread or 0))
    for re = 1, repeatMax do
      pvp_main(bot_parameter_list.pvp.arenaLevel, bot_parameter_list.pvp.generationNum, thread, re)
      print("Time: " .. os.time() - time)
    end
  elseif arg[1] == "-guild" then
    bot_guild()
  elseif arg[1] == "-2" then
    bot_guild2()
  else
    bot_main()
  end
end, BotDebug)
