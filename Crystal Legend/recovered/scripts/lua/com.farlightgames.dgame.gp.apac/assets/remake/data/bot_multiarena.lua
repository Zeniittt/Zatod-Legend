package.path = package.path .. ";./lib/?.lua;./lua/?.lua"
require("edebug")
require("tools")
require("ui/awake/runetools")
local getRuneInfoFunction = require("battle/bot_rune")
local output_folder = "bot_multiarena_log"
local re_max = 20
local generation_max = 4000
local lord_list = {
  2,
  6,
  15,
  16,
  17,
  26,
  40,
  98,
  10021
}
local herolist = {
  1,
  2,
  3,
  4,
  5,
  6,
  7,
  8,
  9,
  10,
  11,
  12,
  13,
  14,
  17,
  18,
  19,
  20,
  21,
  22,
  23,
  24,
  25,
  26,
  27,
  28,
  29,
  30,
  31,
  32,
  33,
  34,
  35,
  36,
  37,
  38,
  39,
  40,
  41,
  42,
  43,
  44,
  45,
  46,
  47,
  48,
  49,
  50,
  51,
  52,
  54,
  55,
  56,
  57,
  58,
  59,
  60,
  61,
  62,
  63,
  64,
  65,
  66,
  67,
  68,
  69,
  70,
  71,
  72,
  73,
  74,
  75,
  76,
  77,
  78,
  79,
  80,
  81,
  82,
  83,
  84,
  86,
  87,
  88,
  89,
  90,
  91,
  92,
  93,
  94,
  95,
  10001,
  10002,
  10005,
  10008,
  10009,
  10011,
  10012,
  10013,
  10014,
  10015,
  10016,
  10017,
  10018,
  10019,
  10020,
  10021,
  10022,
  10023,
  10024,
  10025,
  10026,
  10027,
  10028,
  10029,
  10030,
  10031,
  10032,
  10033,
  10034,
  10035,
  10036,
  10037,
  10038,
  10039,
  10040,
  10041,
  10042,
  10043,
  10044,
  10046
}
local member_cnt = 2
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

local function randomSelectHeroList()
  local temp = {}
  local len = #herolist
  for i = 1, len do
    local jdx = math.random(i, len)
    herolist[i], herolist[jdx] = herolist[jdx], herolist[i]
  end
  for k = 1, 20 do
    table.insert(temp, herolist[k])
  end
  return temp
end

local function createHero(hid)
  local hero = {
    _tid = hid,
    _stars = 5,
    _level = 100,
    _rank = 16,
    _exp = 0,
    _gs = 100,
    _state = "idle",
    _str = 0,
    _agi = 0,
    _int = 0,
    _str_var = 1000,
    _agi_var = 1000,
    _int_var = 1000,
    _aro_exp = 0,
    _status = 1,
    _hero_rune = {_status = 0},
    _cost_gold = 0,
    _cost_diamond = 0,
    _current_fashion = 0,
    _fashion_list = nil,
    _items = {},
    _skill_levels = {}
  }
  return hero
end

local function createMember(isHost, teamIndex, aicd)
  local member = {
    ai = MultiArenaAi.Create(aicd),
    heroList = {},
    last3hero = {},
    rp = 1,
    magicList = {
      40001,
      40002,
      40003,
      40004,
      40006,
      40008,
      40009,
      40010,
      40011,
      40013
    },
    isHost = isHost,
    teamIndex = teamIndex
  }
  local ls = randomSelectHeroList()
  for k, hid in ipairs(ls) do
    table.insert(member.heroList, createHero(hid))
  end
  return member
end

local function createTeam(isHost, lordId)
  local aicd = 3
  local team = {
    lord = createHero(lordId),
    lordId = lordId,
    isHost = isHost,
    score = 0,
    roundscore = 0,
    lastscore = 0,
    weight = math.random(),
    members = {}
  }
  for k = 1, member_cnt do
    table.insert(team.members, createMember(isHost, k, 6 + k))
  end
  return team
end

local function randomHero(list)
  local len = #herolist
  local idx = math.random(1, len)
  if not list[herolist[idx]] then
    return herolist[idx]
  else
    return randomHero(list)
  end
end

local function selectOtherHero(list)
  local temp = {}
  for i, v in ipairs(list) do
    temp[v._tid] = i
  end
  return randomHero(temp)
end

local function evolutionTeam(team)
  local t = team
  if t.roundscore < t.lastscore then
    for k, m in ipairs(t.members) do
      for _, p in ipairs(m.last3hero) do
        local idx = p.idx
        local hero = p.hero
        m.heroList[idx] = hero
      end
    end
  end
  t.lastscore = t.roundscore
  for k, m in ipairs(t.members) do
    local p = {}
    for a = 1, 3 do
      m.rp = m.rp + 1
      if m.rp > 20 then
        m.rp = 1
      end
      table.insert(p, m.rp)
    end
    for b, idx in ipairs(p) do
      local param = {
        idx = idx,
        hero = m.heroList[idx]
      }
      m.last3hero[b] = param
    end
    for _, idx in ipairs(p) do
      local h = selectOtherHero(m.heroList)
      m.heroList[idx] = createHero(h)
    end
  end
end

local function createTeamList()
  local list = {}
  for k, hid in ipairs(lord_list) do
    table.insert(list, createTeam(nil, hid))
  end
  table.sort(list, function(a, b)
    return a.weight > b.weight
  end)
  return list
end

local function randSort(list)
  local len = #list
  for i = 1, len do
    local jdx = math.random(i, len)
    list[i], list[jdx] = list[jdx], list[i]
  end
end

local function createBattleInfo(ta, tb)
  local list = {
    isHost = true,
    teamIndex = 1,
    host = {
      lord = ta.lord,
      lord_index = 1,
      member_list = {}
    },
    guest = {
      lord = tb.lord,
      lord_index = 1,
      member_list = {}
    }
  }
  for k = 1, #ta.members do
    local member = ta.members[k]
    randSort(member.heroList)
    randSort(member.magicList)
    local temp = {
      index = member.teamIndex,
      heroes = ed.copyTable(member.heroList),
      magics = ed.copyTable(member.magicList),
      warschool_books = {},
      bookreading_level = 90
    }
    table.insert(list.host.member_list, temp)
  end
  for k = 1, #tb.members do
    local member = tb.members[k]
    randSort(member.heroList)
    randSort(member.magicList)
    local temp = {
      index = member.teamIndex,
      heroes = ed.copyTable(member.heroList),
      magics = ed.copyTable(member.magicList),
      warschool_books = {},
      bookreading_level = 90
    }
    table.insert(list.guest.member_list, temp)
  end
  return list
end

local totalTimes = 0
local drawTimes = 0
local totalTime = 0
local totalTimes2 = 0

local function roundBattle(teamA, teamB)
  ed.srand(os.time())
  local battle_info = createBattleInfo(teamA, teamB)
  local param = {
    isHost = true,
    team_index = 1,
    btInfo = battle_info
  }
  battle_tick.enterReplayMode(true)
  ed.BattleParams = {
    teamB,
    teamA,
    random_seed,
    0
  }
  ed.engine:enterMultiArena(param)
  for k, m in ipairs(teamA.members) do
    m.ai:ResetCamp(teamA.isHost, m.teamIndex)
  end
  for k, m in ipairs(teamB.members) do
    m.ai:ResetCamp(teamB.isHost, m.teamIndex)
  end
  totalTimes = totalTimes + 1
  local tickNum = 0
  local dt = 0.125
  while ed.engine.running do
    ed.BattleParams[4] = tickNum
    ed.engine:tick()
    if tickNum % 2 == 0 then
      for k, m in ipairs(teamA.members) do
        m.ai:Update(dt)
      end
      for k, m in ipairs(teamB.members) do
        m.ai:Update(dt)
      end
    else
      for k, m in ipairs(teamB.members) do
        m.ai:Update(dt)
      end
      for k, m in ipairs(teamA.members) do
        m.ai:Update(dt)
      end
    end
    tickNum = tickNum + 1
  end
  if 1920 <= tickNum then
    drawTimes = drawTimes + 1
  end
  totalTime = totalTime + tickNum / 8
  totalTimes2 = totalTimes2 + 1
  local _result = ed.engine.battleResult == 0
  local winner = _result and teamA or teamB
  winner.score = winner.score + 1
  winner.roundscore = winner.roundscore + 1
end

local function teamDisplay(team)
  local str = "\t"
  for _, m in ipairs(team.members) do
    for _, h in ipairs(m.heroList) do
      local sh = string.format("%s", h._tid)
      str = str .. "|" .. sh
    end
    str = str .. "\t"
  end
  return str
end

local function saveRoundLog(teamList, output_folder_name, all_out, g)
  local out = io.open(string.format(output_folder_name .. "/multiarena_Genetation_%i.txt", g), "w+")
  print("Generation " .. g)
  for i = 1, #teamList do
    local team = teamList[i]
    local format = "%s:\t %5s"
    local paras = {i}
    local windowFormat = "%s%s"
    local windowParas = {
      tostring(i)
    }
    windowParas[1] = paras[1]
    table.insert(paras, team.lordId)
    table.insert(windowParas, team.lordId)
    for i, ele in ipairs(windowParas) do
      local len = 10 - string.len(ele)
      for k = 1, len do
        windowParas[i] = windowParas[i] .. " "
      end
    end
    local specificStr = string.format(windowFormat, unpack(windowParas))
    local s = string.format(" score: %4s", team.score)
    local cs = string.format(" cscore: %4s", team.roundscore)
    local ps = string.format(" pscore: %4s", team.lastscore)
    print(specificStr .. s .. "\t" .. cs .. "\t" .. ps)
    local str = string.format(format, unpack(paras))
    local scr = string.format(" score %4s \t cscore: %4s \t pscore: %4s", team.score, team.roundscore, team.lastscore)
    local scamp = teamDisplay(team)
    if out then
      out:write(str .. scr .. scamp)
      out:write("\n")
    end
    local all_format = "%i,%s:,%s"
    local all_str = string.format(all_format, g, unpack(paras))
    if all_out then
      all_out:write(all_str .. "" .. team.score)
      all_out:write("\n")
    end
  end
  print("Average Time: " .. totalTime / totalTimes2)
  print("Draw Times/Total:" .. drawTimes .. "/" .. totalTimes .. "(" .. drawTimes / totalTimes .. ") folder:" .. output_folder_name .. "|" .. "100,aller")
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

local function multiarena_battle(retime)
  local teamList = createTeamList()
  local output_folder_name = output_folder .. retime
  os.execute("md " .. output_folder_name)
  local params_out = io.open(string.format(output_folder_name .. "/[params].txt"), "w+")
  params_out:flush()
  params_out:close()
  local all_out = io.open(string.format(output_folder_name .. "/multiarena" .. ".txt"), "w+")
  for k, t in ipairs(teamList) do
    t.lastscore = 0
  end
  for g = 1, generation_max do
    for k, t in ipairs(teamList) do
      t.roundscore = 0
    end
    for k = 1, #teamList do
      local teamA = teamList[k]
      teamA.isHost = true
      for j = k + 1, #teamList do
        local teamB = teamList[j]
        teamB.isHost = false
        roundBattle(teamA, teamB)
      end
    end
    for k = #teamList, 1, -1 do
      local teamA = teamList[k]
      teamA.isHost = true
      for j = k - 1, 1, -1 do
        local teamB = teamList[j]
        teamB.isHost = false
        roundBattle(teamA, teamB)
      end
    end
    table.sort(teamList, function(a, b)
      return a.score > b.score
    end)
    saveRoundLog(teamList, output_folder_name, all_out, g)
    for k = 1, 3 do
      local idx = #teamList - (k - 1)
      evolutionTeam(teamList[idx])
    end
  end
  if all_out then
    all_out:flush()
    all_out:close()
  end
end

xpcall(function()
  local ed = ed
  ed.run_with_scene = false
  do_battle_log = true
  CCNode = {}
  CCSprite = {}
  
  function ccp(x, y)
    return {x = x, y = y}
  end
  
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
  require("bot_multiarena_ai")
  for re = 1, re_max do
    multiarena_battle(re)
  end
end, EDDebug)
