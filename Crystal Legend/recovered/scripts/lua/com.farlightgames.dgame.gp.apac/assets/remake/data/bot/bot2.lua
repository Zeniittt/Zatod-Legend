package.path = package.path .. ";./lib/?.lua;./lua/?.lua"
require("edebug")
require("tools")
require("battle/battle_tick")
ed.enableBotMode = true
ed.enableMaxAttStrategy = true
ed.warschool = 0
ed.bookReadingLevel = 20
local bot_parameter_list = {
  pvp = {
    generationNum = 10000,
    maxHeroId = 85,
    heroStar = 5,
    teamNumber = 30,
    arenaLevel = 100,
    heroAwake = {
      _status = 1,
      _str = 100,
      _int = 100,
      _agi = 100
    }
  },
  stage = {},
  stage_guild = {}
}
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
  
  local function sortHeroes(list)
    local function attackRange(hid)
      local autoAttack = ed.lookupDataTable("Unit", "Basic Skill", hid)
      
      return ed.lookupDataTable("Skill", "Max Range", autoAttack, 0)
    end
    
    table.sort(list, function(a, b)
      return attackRange(a._tid) < attackRange(b._tid)
    end)
  end
  
  local function trim(str)
    if str == nil then
      return nil, "the string parameter is nil"
    end
    str = string.gsub(str, " ", "")
    return str
  end
  
  local function bot_main()
    local printTime = false
    local tteamA = {}
    local tteamB = {}
    local left = {}
    local right = {}
    local TeamList = {}
    local sumAwins = 0
    local sumBwins = 0
    local sumTies = 0
    local left_star = 5
    local left_level = 100
    local right_star = 5
    local right_level = 100
    local _arousal_status = {
      _status = 1,
      _str = 100,
      _int = 100,
      _agi = 100
    }
    local _rune_info = {_status = 0}
    local left = {
      {
        _tid = "AW",
        _level = left_level,
        _stars = 5,
        _arousal = _arousal_status,
        _hero_rune = _rune_info
      },
      {
        _tid = "WW",
        _level = left_level,
        _stars = 5,
        _arousal = _arousal_status,
        _hero_rune = _rune_info
      },
      {
        _tid = "BS",
        _level = left_level,
        _stars = 5,
        _arousal = _arousal_status,
        _hero_rune = _rune_info
      },
      {
        _tid = "TC",
        _level = left_level,
        _stars = 5,
        _arousal = _arousal_status,
        _hero_rune = _rune_info
      },
      {
        _tid = "SPE",
        _level = left_level,
        _stars = 5,
        _arousal = _arousal_status,
        _hero_rune = _rune_info
      }
    }
    local right = {
      {
        _tid = "WW",
        _level = left_level,
        _stars = 5,
        _arousal = _arousal_status,
        _hero_rune = _rune_info
      },
      {
        _tid = "BS",
        _level = left_level,
        _stars = 5,
        _arousal = _arousal_status,
        _hero_rune = _rune_info
      },
      {
        _tid = "TC",
        _level = left_level,
        _stars = 5,
        _arousal = _arousal_status,
        _hero_rune = _rune_info
      },
      {
        _tid = "SPE",
        _level = left_level,
        _stars = 5,
        _arousal = _arousal_status,
        _hero_rune = _rune_info
      },
      {
        _tid = "FarSeer",
        _level = left_level,
        _stars = 5,
        _arousal = _arousal_status,
        _hero_rune = _rune_info
      }
    }
    for id, info in pairs(ed.getDataTable("Unit")) do
      for i = 1, 5 do
        if left[i]._tid == ed.lookupDataTable("Unit", "Name", id) and not ed.lookupDataTable("Unit", "Can Awake", id) then
          left[i]._arousal = {_status = 0}
        end
        if right[i]._tid == ed.lookupDataTable("Unit", "Name", id) and not ed.lookupDataTable("Unit", "Can Awake", id) then
          right[i]._arousal = {_status = 0}
        end
      end
    end
    sortHeroes(left)
    sortHeroes(right)
    print("teamA: " .. left[1]._tid .. " " .. left[2]._tid .. " " .. left[3]._tid .. " " .. left[4]._tid .. " " .. left[5]._tid)
    print("teamB: " .. right[1]._tid .. " " .. right[2]._tid .. " " .. right[3]._tid .. " " .. right[4]._tid .. " " .. right[5]._tid)
    local totalTimes = 100
    for i = 1, totalTimes / 2 do
      local ticks = 0
      ed.srand(os.time() * ed.rand())
      ed.engine:enterArena(left, right, true, true)
      while ed.engine.running do
        ed.engine:tick()
        ticks = ticks + 1
      end
      if ticks / 8 < 90 then
        local res = ed.engine.result_stars
        if 0 < res then
          sumAwins = sumAwins + 1
          if printTime then
            print("teamA win, time = " .. ticks / 8)
          end
        else
          sumBwins = sumBwins + 1
          if printTime then
            print("teamB win, time = " .. ticks / 8)
          end
        end
      else
        sumTies = sumTies + 1
      end
    end
    for i = 1, totalTimes / 2 do
      local ticks = 0
      ed.srand(os.time() * ed.rand())
      ed.engine:enterArena(right, left, true, true)
      while ed.engine.running do
        ed.engine:tick()
        ticks = ticks + 1
      end
      if ticks / 8 < 90 then
        local res = ed.engine.result_stars
        if res <= 0 then
          sumAwins = sumAwins + 1
          if printTime then
            print("teamA win, time = " .. ticks / 8)
          end
        else
          sumBwins = sumBwins + 1
          if printTime then
            print("teamB win, time = " .. ticks / 8)
          end
        end
      else
        sumTies = sumTies + 1
      end
    end
    print("teamA win percent: " .. sumAwins / totalTimes)
    print("teamB win percent: " .. sumBwins / totalTimes)
    print("Tie       percent: " .. sumTies / totalTimes)
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
  
  local function pvp_main(arenaLevel, generationNum)
    arenaLevel = arenaLevel or bot_parameter_list.pvp.arenaLevel
    generationNum = generationNum or bot_parameter_list.pvp.generationNum
    local MTList = {}
    local DPSList = {}
    local SPTList = {}
    for id, info in pairs(ed.getDataTable("Unit")) do
      if type(id) == "number" and id <= bot_parameter_list.pvp.maxHeroId then
        local mainAttrib = ed.lookupDataTable("Unit", "Main Attrib", id)
        local hero = {
          _tid = id,
          _level = arenaLevel,
          _star = bot_parameter_list.pvp.heroStar,
          _arousal = bot_parameter_list.pvp.heroAwake,
          name = ed.lookupDataTable("Unit", "Name", id),
          type = mainAttrib
        }
        if mainAttrib == "ST" or mainAttrib == "MT" then
          table.insert(MTList, hero)
        elseif mainAttrib == "ADC" or mainAttrib == "APC" then
          table.insert(DPSList, hero)
        elseif mainAttrib == "SPT" then
          table.insert(SPTList, hero)
        end
      end
    end
    local teamList = {}
    local DPSLists1 = {}
    for i = 1, #DPSList do
      for j = i + 1, #DPSList do
        for k = j + 1, #DPSList do
          for v = k + 1, #DPSList do
            table.insert(DPSLists1, {
              DPSList[i],
              DPSList[j],
              DPSList[k],
              DPSList[v]
            })
          end
        end
      end
    end
    for i = 1, #MTList do
      for j = 1, #DPSLists1 do
        local team = {
          heroes = {
            MTList[i],
            DPSLists1[j][1],
            DPSLists1[j][2],
            DPSLists1[j][3],
            DPSLists1[j][4]
          },
          score = 0
        }
        sortHeroes(team.heroes)
        table.insert(teamList, team)
      end
    end
    print("team makeup mode, MT:DPS:SPT = 1:4:0")
    print("total MTLists,DPSLists length: ", trim(#MTList), trim(#DPSLists1))
    local MTLists2 = {}
    local DPSLists2 = {}
    for i = 1, #MTList do
      for j = i + 1, #MTList do
        table.insert(MTLists2, {
          MTList[i],
          MTList[j]
        })
      end
    end
    for i = 1, #DPSList do
      for j = i + 1, #DPSList do
        for k = j + 1, #DPSList do
          table.insert(DPSLists2, {
            DPSList[i],
            DPSList[j],
            DPSList[k]
          })
        end
      end
    end
    for i = 1, #MTLists2 do
      for j = 1, #DPSLists2 do
        local team = {
          heroes = {
            MTLists2[i][1],
            MTLists2[i][2],
            DPSLists2[j][1],
            DPSLists2[j][2],
            DPSLists2[j][3]
          },
          score = 0
        }
        sortHeroes(team.heroes)
        table.insert(teamList, team)
      end
    end
    print("team makeup mode, MT:DPS:SPT = 2:3:0")
    print("total MTLists,DPSLists length: ", trim(#MTLists2), trim(#DPSLists2))
    local DPSLists3 = {}
    for i = 1, #DPSList do
      for j = i + 1, #DPSList do
        for k = j + 1, #DPSList do
          for v = k + 1, #DPSList do
            table.insert(DPSLists3, {
              DPSList[i],
              DPSList[j],
              DPSList[k],
              DPSList[v]
            })
          end
        end
      end
    end
    for i = 1, #MTList do
      for j = 1, #DPSLists3 do
        for k = 1, #SPTList do
          local team = {
            heroes = {
              MTList[i],
              DPSLists3[j][1],
              DPSLists3[j][2],
              DPSLists3[j][3],
              SPTList[k]
            },
            score = 0
          }
          sortHeroes(team.heroes)
          table.insert(teamList, team)
        end
      end
    end
    print("team makeup mode, MT:DPS:SPT = 1:3:0")
    print("total MTLists,DPSLists length: ", trim(#MTList), trim(#DPSLists3))
    local MTLists4 = {}
    local DPSLists4 = {}
    for i = 1, #MTList do
      for j = i + 1, #MTList do
        table.insert(MTLists4, {
          MTList[i],
          MTList[j]
        })
      end
    end
    for i = 1, #DPSList do
      for j = i + 1, #DPSList do
        table.insert(DPSLists4, {
          DPSList[i],
          DPSList[j]
        })
      end
    end
    for i = 1, #MTLists4 do
      for j = 1, #DPSLists4 do
        for k = 1, #SPTList do
          local team = {
            heroes = {
              MTLists4[i][1],
              MTLists4[i][2],
              DPSLists4[j][1],
              DPSLists4[j][2],
              SPTList[k]
            },
            score = 0
          }
          sortHeroes(team.heroes)
          table.insert(teamList, team)
        end
      end
    end
    print("team makeup mode, MT:DPS:SPT = 2:2:1")
    print("total MTLists,DPSLists length: ", trim(#MTLists4), trim(#DPSLists4))
    print("hero level: ", bot_parameter_list.pvp.arenaLevel)
    print("total hero length: ", bot_parameter_list.pvp.maxHeroId)
    print("total MTList length: ", #MTList)
    print("total DPSList length: ", #DPSList)
    print("total SPTList length: ", #SPTList)
    print("total ", #teamList, " teams fighting!")
    os.execute("md arean_pvp2")
    local fightTimes = 0
    for i = 3, #teamList do
      local teamA = teamList[i]
      local start = 0
      local last = i
      repeat
        local mid = math.ceil((start + last) / 2)
        local teamB = teamList[mid]
        local BoN = 5
        local res = 0
        for j = 1, BoN do
          ed.srand(os.time() * ed.rand())
          ed.engine:enterArena(teamA.heroes, teamB.heroes, true, true)
          fightTimes = fightTimes + 1
          while ed.engine.running do
            ed.engine:tick()
          end
          res = 0 < ed.engine.result_stars and res + 1 or res - 1
          if res > BoN / 2 or res < -BoN / 2 then
            break
          end
        end
        if 0 < res then
          last = mid
        else
          start = mid
        end
      until last - 1 == start
      for k = start + 1, i - 1 do
        teamList[i + (start + 1) - k] = teamList[i - 1 + (start + 1) - k]
      end
      teamList[start + 1] = teamA
    end
    print("total fightTimes = ", fightTimes)
    local ttime = os.time()
    local outHeros = {}
    for i = 1, #MTList do
      local hero = {
        name = MTList[i].name,
        type = MTList[i].type,
        score = 0,
        teamCounts = 0
      }
      table.insert(outHeros, hero)
    end
    for j = 1, #DPSList do
      local hero = {
        name = DPSList[j].name,
        type = DPSList[j].type,
        score = 0,
        teamCounts = 0
      }
      table.insert(outHeros, hero)
    end
    for k = 1, #SPTList do
      local hero = {
        name = SPTList[k].name,
        type = SPTList[k].type,
        score = 0,
        teamCounts = 0
      }
      table.insert(outHeros, hero)
    end
    for i = 1, #teamList do
      for j = 1, 5 do
        for k = 1, #outHeros do
          if outHeros[k].name == teamList[i].heroes[j].name then
            outHeros[k].score = outHeros[k].score + (#teamList + 1 - i)
            outHeros[k].teamCounts = outHeros[k].teamCounts + 1
            break
          end
        end
      end
    end
    print("compute score time: ", os.time() - ttime, "s")
    local out = io.open(string.format("arean_pvp2/arena_%i_rank.txt", arenaLevel), "w+")
    local out2 = io.open(string.format("arean_pvp2/arena_%i_hero_socre.txt", arenaLevel), "w+")
    print("-------------------------------------------")
    for i = 1, #teamList do
      local team = teamList[i]
      local format = "%i:(),%s,%s,%s,%s,%s"
      local paras = {i}
      for _, h in ipairs(team.heroes) do
        table.insert(paras, h.name)
      end
      local str = string.format(format, unpack(paras))
      if out then
        out:write(str .. " score: ")
        out:write("\n")
      end
    end
    for i = 1, #outHeros do
      local hero = outHeros[i]
      local format = "%i:%s,%s,score:%s"
      local str = string.format(format, i, hero.name, hero.type, hero.score)
      print(str)
      if out2 then
        out2:write(str)
        out2:write("\n")
      end
    end
    if out then
      out:flush()
      out:close()
    end
    if out2 then
      out2:flush()
      out2:close()
    end
  end
  
  collectgarbage("setpause", 100)
  collectgarbage("setstepmul", 5000)
  if not arg then
    arg = {"-pvp"}
  end
  if arg[1] == "-pvp" then
    local time = os.time()
    pvp_main(bot_parameter_list.pvp.arenaLevel, bot_parameter_list.pvp.generationNum)
    print("Time: " .. os.time() - time .. "s")
  else
    bot_main()
  end
end, EDDebug)
