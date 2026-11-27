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
ed.enableMaxAttStrategy = true
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
  
  local function pvp_fashionCheck(heroid)
    local fashionList = bot_parameter_list.pvp.fashionList
    if fashionList then
      return fashionList[heroid]
    end
    return nil
  end
  
  local function pvp_main(arenaLevel, generationNum, retime)
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
    local heroList = {}
    for id, info in pairs(ed.getDataTable("Unit")) do
      if type(id) == "number" and bot_parameter_list.pvp.SelectedHeroeIds[id] and not bot_parameter_list.pvp.cullHeroeIds[id] then
        local hero = {
          _tid = id,
          _level = arenaLevel,
          _stars = bot_parameter_list.pvp.heroStar,
          _arousal = bot_parameter_list.pvp.heroAwake,
          _hero_rune = getRuneInfoFunction(id, defaultSuperAwake),
          _pet = bot_parameter_list.pvp.heroPet,
          _fashion = {
            _current_fashion = pvp_fashionCheck(id)
          },
          name = ed.lookupDataTable("Unit", "Name", id)
        }
        if not ed.lookupDataTable("Unit", "Can Awake", id) then
          hero._arousal = {_status = 0}
        end
        if not ed.lookupDataTable("Unit", "Can Awake2", id) then
          hero._hero_rune = {_status = 0}
        end
        if hero._pet then
          hero._pet_bag = getPetBagFunction(hero._tid)
        end
        if bot_parameter_list.pvp.specialHeroIds[id] then
          hero._stars = bot_parameter_list.pvp.specialHeroIds[id]
        end
        table.insert(heroList, hero)
      end
    end
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
      if bot_parameter_list.pvp.specifyHeroID then
        local hasSpecifyHero = false
        for k = 1, #team.heroes do
          if team.heroes[k]._tid == bot_parameter_list.pvp.specifyHeroID then
            hasSpecifyHero = true
            break
          end
        end
        if not hasSpecifyHero then
          local hero = {
            _tid = bot_parameter_list.pvp.specifyHeroID,
            _level = arenaLevel,
            _stars = bot_parameter_list.pvp.heroStar,
            _arousal = bot_parameter_list.pvp.heroAwake,
            _hero_rune = getRuneInfoFunction(bot_parameter_list.pvp.specifyHeroID, defaultSuperAwake),
            _pet = bot_parameter_list.pvp.heroPet,
            _fashion = {
              _current_fashion = pvp_fashionCheck(bot_parameter_list.pvp.specifyHeroID)
            },
            name = ed.lookupDataTable("Unit", "Name", bot_parameter_list.pvp.specifyHeroID)
          }
          if not ed.lookupDataTable("Unit", "Can Awake", hero._tid) then
            hero._arousal = {_status = 0}
          end
          if not ed.lookupDataTable("Unit", "Can Awake2", hero._tid) then
            hero._hero_rune = {_status = 0}
          end
          if hero._pet then
            hero._pet_bag = getPetBagFunction(hero._tid)
          end
          if bot_parameter_list.pvp.specialHeroIds[hero._tid] then
            hero._stars = bot_parameter_list.pvp.specialHeroIds[hero._tid]
          end
          team.heroes[1] = hero
        end
      end
    end
    local output_folder_name = output_folder .. retime
    os.execute("md " .. output_folder_name)
    local params_out = io.open(string.format(output_folder_name .. "/[params].txt"), "w+")
    params_out:write("max_rank=" .. bot_parameter_list.max_rank .. "\n")
    params_out:write("teamNumber=" .. bot_parameter_list.pvp.teamNumber .. "\n")
    params_out:write("level=" .. bot_parameter_list.pvp.arenaLevel .. "\n")
    params_out:write("heroStar=" .. bot_parameter_list.pvp.heroStar .. "\n")
    local heroAwake = bot_parameter_list.pvp.heroAwake
    params_out:write("heroAwake={_status=" .. heroAwake._status .. ",_str=" .. heroAwake._str .. ",_int=" .. heroAwake._int .. ",_agi=" .. heroAwake._agi .. "}\n")
    local heroSuperAwake = bot_parameter_list.pvp.heroSuperAwake
    params_out:write("heroSuperAwake = {_status=" .. heroSuperAwake._status .. "}\n")
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
    local all_out = io.open(string.format(output_folder_name .. "/arena_" .. arenaLevel .. ".txt"), "w+")
    for g = 1, generationNum do
      for i = 1, #teamList do
        local team = teamList[i]
        team.score = 0
        local son = {
          heroes = {},
          score = 0
        }
        for j = 1, #team.heroes do
          local dice = math.random()
          if dice < 0.6 then
            local new = math.floor(math.random() * #heroList) + 1
            son.heroes[j] = heroList[new]
          else
            son.heroes[j] = team.heroes[j]
          end
        end
        if bot_parameter_list.pvp.specifyHeroID then
          local hasSpecifyHero = false
          for k = 1, #team.heroes do
            if son.heroes[k]._tid == bot_parameter_list.pvp.specifyHeroID then
              hasSpecifyHero = true
              break
            end
          end
          if not hasSpecifyHero then
            local team = {
              _tid = bot_parameter_list.pvp.specifyHeroID,
              _level = arenaLevel,
              _stars = bot_parameter_list.pvp.heroStar,
              _arousal = bot_parameter_list.pvp.heroAwake,
              _hero_rune = getRuneInfoFunction(bot_parameter_list.pvp.specifyHeroID, defaultSuperAwake),
              _pet = bot_parameter_list.pvp.heroPet,
              _fashion = {
                _current_fashion = pvp_fashionCheck(bot_parameter_list.pvp.specifyHeroID)
              },
              name = ed.lookupDataTable("Unit", "Name", bot_parameter_list.pvp.specifyHeroID)
            }
            if not ed.lookupDataTable("Unit", "Can Awake", team._tid) then
              team._arousal = {_status = 0}
            end
            if not ed.lookupDataTable("Unit", "Can Awake2", team._tid) then
              team._hero_rune = {_status = 0}
            end
            if team._pet then
              team._pet_bag = getPetBagFunction(team._tid)
            end
            if bot_parameter_list.pvp.specialHeroIds[team._tid] then
              team._stars = bot_parameter_list.pvp.specialHeroIds[team._tid]
            end
            son.heroes[1] = team
          end
        end
        sortHeroes(son.heroes)
        local check = true
        for j = 1, #son.heroes do
          for k = j + 1, #son.heroes do
            if son.heroes[j]._tid == son.heroes[k]._tid then
              check = false
            end
          end
        end
        for t = 1, #teamList do
          local sum1 = 0
          local sum2 = 0
          for tt = 1, 5 do
            sum1 = sum1 + son.heroes[tt]._tid * son.heroes[tt]._tid
            sum2 = sum2 + teamList[t].heroes[tt]._tid * teamList[t].heroes[tt]._tid
          end
          if sum1 == sum2 then
            print("remove same team")
            check = false
            break
          end
        end
        if check then
          table.insert(teamList, son)
        end
      end
      local totalTimes = 0
      local drawTimes = 0
      for i = 1, #teamList do
        local teamA = teamList[i]
        for j = i + 1, #teamList do
          local teamB = teamList[j]
          ed.BattleParams = {
            teamB.heroes,
            teamA.heroes,
            random_seed,
            0
          }
          ed.engine:enterArena(teamB.heroes, teamA.heroes, true, true, warschool or nil, bookReadingLevel or nil, nil, nil, useBonus and bonusInfo or nil)
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
          winner.score = winner.score + 1
        end
      end
      table.sort(teamList, function(a, b)
        return a.score > b.score
      end)
      for i = #teamList, teams + 1, -1 do
        teamList[i] = nil
      end
      local out = io.open(string.format(output_folder_name .. "/arena_%i_Genetation_%i.txt", arenaLevel, g), "w+")
      print("Generation " .. g)
      for i = 1, #teamList do
        local team = teamList[i]
        local format = "%s:(%s)\t %s %s %s %s %s"
        local paras = {i}
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
        end
        for i, ele in ipairs(windowParas) do
          local len = 10 - string.len(ele)
          for k = 1, len do
            windowParas[i] = windowParas[i] .. " "
          end
        end
        local specificStr = string.format(windowFormat, unpack(windowParas))
        print(specificStr .. " score: " .. team.score)
        local str = string.format(format, unpack(paras))
        if out then
          out:write(str .. " score: " .. team.score)
          out:write("\n")
        end
        local all_format = "%i,%s:(%s),%s,%s,%s,%s,%s,"
        local all_str = string.format(all_format, g, unpack(paras))
        if all_out then
          all_out:write(all_str .. "" .. team.score)
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
    local time = os.time()
    for re = 1, re_max do
      pvp_main(bot_parameter_list.pvp.arenaLevel, bot_parameter_list.pvp.generationNum, re)
      print("Time: " .. os.time() - time)
    end
  elseif arg[1] == "-guild" then
  else
    if arg[1] == "-2" then
    else
    end
  end
end, BotDebug)
