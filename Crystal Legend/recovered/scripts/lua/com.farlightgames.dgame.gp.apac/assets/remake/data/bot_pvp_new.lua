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
local GA_PARAMS = {
  CROSSOVER_RATE = 0.8,
  MUTATION_RATE_INIT = 0.7,
  MUTATION_RATE_FINAL = 0.1,
  ELITE_RATIO = 0.4,
  TOURNAMENT_SIZE = 3,
  DIVERSITY_THRESHOLD = 0.3,
  LOCAL_SEARCH_PROB = 0.1,
  MULTI_CROSSOVER_POINTS = 2
}
local ELO_PARAMS = {
  INITIAL_RATING = 1200,
  K_VALUE_NEW = 40,
  K_VALUE_MATURE = 20,
  K_VALUE_EXPERT = 10,
  DEFENSE_MULTIPLIER = 1.2,
  BATTLE_COUNT_THRESHOLD = 10,
  EXPERT_THRESHOLD = 50
}
local output_folder = "2025-0804-level-" .. arenaLevel .. "-Star-" .. arenaHeroStar .. "-maxRank-" .. maxRank .. "-balance" .. "-1-"
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
      [84] = true,
      [86] = true,
      [91] = true,
      [92] = true,
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
      [10022] = 1100221,
      [3] = 1000031,
      [40] = 1000401,
      [5] = 1000051,
      [33] = 1000331
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
      [4] = true,
      [9] = true,
      [10] = true
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
      [8] = 5,
      [9] = 3,
      [10] = 3
    },
    checkSameTeamWithLegendEquip = true
  },
  comment = "PVP Optimized Version - Improved GA and ELO Rating"
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
  
  local function calculate_k_value(team)
    local battleCount = team.battleCnt or 0
    if battleCount < ELO_PARAMS.BATTLE_COUNT_THRESHOLD then
      return ELO_PARAMS.K_VALUE_NEW
    elseif battleCount < ELO_PARAMS.EXPERT_THRESHOLD then
      return ELO_PARAMS.K_VALUE_MATURE
    else
      return ELO_PARAMS.K_VALUE_EXPERT
    end
  end
  
  local function calculate_battle_quality(winner, loser, battleTime)
    local quality = 1
    if battleTime < 30 then
      quality = quality + 0.2
    elseif 60 < battleTime then
      quality = quality - 0.1
    end
    local ratingDiff = math.abs(winner.score - loser.score)
    if 200 < ratingDiff then
      quality = quality * 0.8
    end
    return math.max(0.5, math.min(1.5, quality))
  end
  
  local function update_elo_rating(teamA, teamB, score_a, score_b, battleTime, is_defense_a)
    if not teamA.score or not teamB.score then
      print("Warning: team score is nil, initializing to default value")
      teamA.score = teamA.score or ELO_PARAMS.INITIAL_RATING
      teamB.score = teamB.score or ELO_PARAMS.INITIAL_RATING
    end
    local expected_a = expected_score(teamA.score, teamB.score)
    local expected_b = expected_score(teamB.score, teamA.score)
    local k_a = calculate_k_value(teamA)
    local k_b = calculate_k_value(teamB)
    if is_defense_a and score_b < score_a then
      k_a = k_a * ELO_PARAMS.DEFENSE_MULTIPLIER
    elseif not is_defense_a and score_a < score_b then
      k_b = k_b * ELO_PARAMS.DEFENSE_MULTIPLIER
    end
    local winner = score_b < score_a and teamA or teamB
    local loser = score_a <= score_b and teamA or teamB
    local quality = calculate_battle_quality(winner, loser, battleTime)
    local new_rating_a = teamA.score + k_a * (score_a - expected_a) * quality
    local new_rating_b = teamB.score + k_b * (score_b - expected_b) * quality
    return new_rating_a, new_rating_b
  end
  
  local function calculate_team_diversity(teamList)
    local diversity = 0
    local n = #teamList
    for i = 1, n do
      for j = i + 1, n do
        local similarity = 0
        for k = 1, 5 do
          if teamList[i].heroes[k]._tid == teamList[j].heroes[k]._tid then
            similarity = similarity + 1
          end
        end
        diversity = diversity + (5 - similarity) / 5
      end
    end
    return diversity / (n * (n - 1) / 2)
  end
  
  local function tournament_selection(teamList, tournamentSize)
    local selected = {}
    for i = 1, tournamentSize do
      local idx = math.random(1, #teamList)
      table.insert(selected, teamList[idx])
    end
    table.sort(selected, function(a, b)
      return a.score > b.score
    end)
    return selected[1]
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
        score = ELO_PARAMS.INITIAL_RATING,
        winCnt = 0,
        battleCnt = 0,
        generation = 0,
        diversity = 0
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
    
    local function multi_point_crossover(parent1, parent2)
      local offspring = {
        heroes = {},
        legendEquipSolts = {}
      }
      local crossoverPoints = {}
      for i = 1, GA_PARAMS.MULTI_CROSSOVER_POINTS do
        table.insert(crossoverPoints, math.random(1, 4))
      end
      table.sort(crossoverPoints)
      local useParent1 = true
      local pointIndex = 1
      for i = 1, 5 do
        if pointIndex <= #crossoverPoints and i == crossoverPoints[pointIndex] then
          useParent1 = not useParent1
          pointIndex = pointIndex + 1
        end
        if useParent1 then
          offspring.heroes[i] = parent1.heroes[i]
        else
          offspring.heroes[i] = parent2.heroes[i]
        end
      end
      return offspring
    end
    
    local function local_search(individual, heroList)
      local improved = {
        heroes = {},
        legendEquipSolts = {},
        position = individual.position
      }
      for i = 1, #individual.heroes do
        improved.heroes[i] = individual.heroes[i]
      end
      local replacements = math.random(1, 2)
      for i = 1, replacements do
        local pos = math.random(1, 5)
        local newHero = heroList[math.random(1, #heroList)]
        local isDuplicate = false
        for j = 1, #improved.heroes do
          if j ~= pos and improved.heroes[j]._tid == newHero._tid then
            isDuplicate = true
            break
          end
        end
        if not isDuplicate then
          improved.heroes[pos] = newHero
        end
      end
      return improved
    end
    
    for g = 1, generationNum do
      local currentDiversity = calculate_team_diversity(teamList)
      local teamCnt = #teamList
      local newGeneration = {}
      local eliteCount = math.floor(teamCnt * GA_PARAMS.ELITE_RATIO)
      table.sort(teamList, function(a, b)
        return a.score > b.score
      end)
      for i = 1, eliteCount do
        local elite = {
          heroes = {},
          score = teamList[i].score,
          winCnt = 0,
          battleCnt = 0,
          generation = g,
          legendEquipSolts = {},
          position = teamList[i].position
        }
        for j = 1, #teamList[i].heroes do
          elite.heroes[j] = teamList[i].heroes[j]
        end
        table.insert(newGeneration, elite)
      end
      for i = eliteCount + 1, teamCnt do
        local son = {
          heroes = {},
          score = ELO_PARAMS.INITIAL_RATING,
          winCnt = 0,
          battleCnt = 0,
          generation = g,
          legendEquipSolts = {}
        }
        local adaptiveCrossoverRate = GA_PARAMS.CROSSOVER_RATE
        local adaptiveMutationRate = GA_PARAMS.MUTATION_RATE_INIT - (GA_PARAMS.MUTATION_RATE_INIT - GA_PARAMS.MUTATION_RATE_FINAL) * g / generationNum
        if currentDiversity < GA_PARAMS.DIVERSITY_THRESHOLD then
          adaptiveMutationRate = adaptiveMutationRate * 1.5
        end
        if adaptiveCrossoverRate > math.random() then
          local parent1 = tournament_selection(teamList, GA_PARAMS.TOURNAMENT_SIZE)
          local parent2 = tournament_selection(teamList, GA_PARAMS.TOURNAMENT_SIZE)
          son = multi_point_crossover(parent1, parent2)
          son.score = ELO_PARAMS.INITIAL_RATING
          son.winCnt = 0
          son.battleCnt = 0
          son.generation = g
        else
          local parent = tournament_selection(teamList, GA_PARAMS.TOURNAMENT_SIZE)
          for j = 1, #parent.heroes do
            son.heroes[j] = parent.heroes[j]
          end
          son.position = parent.position
        end
        for j = 1, #son.heroes do
          if adaptiveMutationRate > math.random() then
            local newHero = heroList[math.random(1, #heroList)]
            local isDuplicate = false
            for k = 1, #son.heroes do
              if k ~= j and son.heroes[k] and son.heroes[k]._tid == newHero._tid then
                isDuplicate = true
                break
              end
            end
            if not isDuplicate then
              son.heroes[j] = newHero
            end
          end
        end
        if math.random() < GA_PARAMS.LOCAL_SEARCH_PROB then
          son = local_search(son, heroList)
        end
        for j = 1, 5 do
          if not son.heroes[j] then
            son.heroes[j] = heroList[math.random(1, #heroList)]
          end
        end
        table.insert(newGeneration, son)
      end
      teamList = newGeneration
      for i = 1, #teamList do
        local son = teamList[i]
        son.score = son.score or ELO_PARAMS.INITIAL_RATING
        son.winCnt = son.winCnt or 0
        son.battleCnt = son.battleCnt or 0
        son.generation = son.generation or g
        son.legendEquipSolts = son.legendEquipSolts or {}
        local specialLegendEquipSolts = {}
        local uniqueLegendEquipInSon = {}
        local legendEquipCnt = 0
        if has_legendEquip then
          legendEquipCnt = #son.heroes
          local start = specialLegendEquipSolts[1] and 2 or 1
          for k = start, legendEquipCnt do
            local hero = son.heroes[k]
            hero.__specialLegendEquip = pvp_LegendEquipCheck(hero._tid)
            if hero.__specialLegendEquip then
              if hero.__specialLegendEquip.isUnique then
                uniqueLegendEquipInSon[hero.__specialLegendEquip.id] = (uniqueLegendEquipInSon[hero.__specialLegendEquip.id] or 0) + 1
              end
              specialLegendEquipSolts[k] = hero.__specialLegendEquip.id
            end
          end
          pvp_checkUniqueLegendEquipInTeam(uniqueLegendEquipInSon)
          for j = 1, legendEquipCnt do
            if specialLegendEquipSolts[j] then
              son.legendEquipSolts[j] = specialLegendEquipSolts[j]
            else
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
            if son.heroes[j] then
              hero_legendEquip_dic[son.heroes[j]._tid] = son.legendEquipSolts[j]
            end
          end
          sortHeroes(son.heroes)
          for j = 1, legendEquipCnt do
            if son.heroes[j] then
              son.legendEquipSolts[j] = hero_legendEquip_dic[son.heroes[j]._tid]
            end
          end
        else
          for j = 1, 5 do
            son.heroes[j] = heroList[math.random(1, #heroList)]
          end
          sortHeroes(son.heroes)
          if has_legendEquip then
            local uniqueLegendEquipInSon = {}
            local newLegendEquipCnt = #son.heroes
            son.legendEquipSolts = {}
            for j = 1, newLegendEquipCnt do
              local hero = son.heroes[j]
              hero.__specialLegendEquip = pvp_LegendEquipCheck(hero._tid)
              if hero.__specialLegendEquip then
                if hero.__specialLegendEquip.isUnique then
                  uniqueLegendEquipInSon[hero.__specialLegendEquip.id] = (uniqueLegendEquipInSon[hero.__specialLegendEquip.id] or 0) + 1
                end
                son.legendEquipSolts[j] = hero.__specialLegendEquip.id
              else
                local legendEquipId, isUnique = pvp_randomLegendEquip(uniqueLegendEquipInSon)
                if isUnique then
                  uniqueLegendEquipInSon[legendEquipId] = (uniqueLegendEquipInSon[legendEquipId] or 0) + 1
                end
                son.legendEquipSolts[j] = legendEquipId
              end
            end
          end
          son.position = nil
        end
      end
      local validTeams = {}
      for i = 1, #teamList do
        local team = teamList[i]
        local isDuplicate = false
        for j = 1, #validTeams do
          local sum1 = 0
          local sum2 = 0
          for k = 1, 5 do
            sum1 = sum1 + team.heroes[k]._tid * team.heroes[k]._tid
            sum2 = sum2 + validTeams[j].heroes[k]._tid * validTeams[j].heroes[k]._tid
          end
          if sum1 == sum2 and pvp_legendEquipSoltsEquals(team.legendEquipSolts, validTeams[j].legendEquipSolts) then
            isDuplicate = true
            break
          end
        end
        if not isDuplicate then
          table.insert(validTeams, team)
        end
      end
      while teams > #validTeams do
        for k = 1, #heroList do
          heroList[k].weight = math.random()
        end
        table.sort(heroList, function(a, b)
          return a.weight > b.weight
        end)
        local newTeam = {
          heroes = {
            heroList[1],
            heroList[2],
            heroList[3],
            heroList[4],
            heroList[5]
          },
          score = ELO_PARAMS.INITIAL_RATING,
          winCnt = 0,
          battleCnt = 0,
          generation = g,
          legendEquipSolts = {},
          position = nil
        }
        sortHeroes(newTeam.heroes)
        if has_legendEquip then
          local uniqueLegendEquipInTeam = {}
          local legendEquipCnt = #newTeam.heroes
          for j = 1, legendEquipCnt do
            local hero = newTeam.heroes[j]
            hero.__specialLegendEquip = pvp_LegendEquipCheck(hero._tid)
            if hero.__specialLegendEquip then
              if hero.__specialLegendEquip.isUnique then
                uniqueLegendEquipInTeam[hero.__specialLegendEquip.id] = (uniqueLegendEquipInTeam[hero.__specialLegendEquip.id] or 0) + 1
              end
              newTeam.legendEquipSolts[j] = hero.__specialLegendEquip.id
            else
              local legendEquipId, isUnique = pvp_randomLegendEquip(uniqueLegendEquipInTeam)
              if isUnique then
                uniqueLegendEquipInTeam[legendEquipId] = (uniqueLegendEquipInTeam[legendEquipId] or 0) + 1
              end
              newTeam.legendEquipSolts[j] = legendEquipId
            end
          end
        end
        table.insert(validTeams, newTeam)
      end
      teamList = validTeams
      local totalTimes = 0
      local drawTimes = 0
      if has_legendEquip then
        for i = 1, #teamList do
          local team = teamList[i]
          for j = 1, #team.heroes do
            if team.legendEquipSolts[j] then
              team.heroes[j]._legend_equip = {
                _equip = {
                  _type_id = team.legendEquipSolts[j],
                  _star = legendEquipsStar[team.legendEquipSolts[j]] or 5,
                  _rank = 0
                }
              }
            else
              local defaultEquipId = normalLegendEquipDic[1] or 5
              team.heroes[j]._legend_equip = {
                _equip = {
                  _type_id = defaultEquipId,
                  _star = legendEquipsStar[defaultEquipId] or 5,
                  _rank = 0
                }
              }
            end
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
          local battleTime = tickNum / 8
          local winnerScore, loserScore = update_elo_rating(winner, loser, 1, 0, battleTime, winner == teamA)
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
  local thread = arg and arg[1] or nil
  local time = os.time()
  math.randomseed(os.time() + (thread and tonumber(thread) or 0))
  for re = 1, repeatMax do
    pvp_main(bot_parameter_list.pvp.arenaLevel, bot_parameter_list.pvp.generationNum, thread, re)
    print("Time: " .. os.time() - time)
  end
end, BotDebug)
