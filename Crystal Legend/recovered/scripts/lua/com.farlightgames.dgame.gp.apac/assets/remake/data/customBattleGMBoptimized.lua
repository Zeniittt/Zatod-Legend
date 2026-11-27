ed.enableMaxAttStrategy = true
ed.isTestBattle = true
local StartHealth = 10000

local function loadShader()
  local list = {
    "GrayScalingShader",
    "FrozenShader",
    "StoneShader",
    "PoisonShader",
    "BanishShader",
    "InvisibleShader",
    "Blur",
    "IceShader",
    "MirrorShader",
    "FireShader",
    "RubickShader",
    "MorSwitchShader_R",
    "MorSwitchShader_G",
    "MorNewSwitchShader_R",
    "MorNewSwitchShader_G",
    "MorFashionShader_R",
    "MorShader_E",
    "MorShader_G",
    "MorShader_R",
    "NanaShader",
    "DarkenShader",
    "ParasitismShader",
    "SandShader",
    "DinaShader",
    "PuckShader",
    "KaelShader",
    "BKBShader"
  }
  for i = 1, #list do
    EDLoadShader(list[i])
  end
end

local shardList = {
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
  [16] = 1000161
}

local function ShardCheck(heroid)
  if shardList then
    return shardList[heroid]
  end
  return nil
end

ed.run_with_scene = false

local function startCustomBattle(tid, BOSSID)
  local left_star = 5
  local left_level = 80
  local left_rank = 13
  local left = {
    {
      _tid = tid[1],
      _level = left_level,
      _stars = left_star,
      rank = left_rank,
      _shard = {
        _id = ShardCheck(tid[1]),
        _level = 25
      }
    },
    {
      _tid = tid[2],
      _level = left_level,
      _stars = left_star,
      rank = left_rank,
      _shard = {
        _id = ShardCheck(tid[2]),
        _level = 25
      }
    },
    {
      _tid = tid[3],
      _level = left_level,
      _stars = left_star,
      rank = left_rank,
      _shard = {
        _id = ShardCheck(tid[3]),
        _level = 25
      }
    },
    {
      _tid = tid[4],
      _level = left_level,
      _stars = left_star,
      rank = left_rank,
      _shard = {
        _id = ShardCheck(tid[4]),
        _level = 25
      }
    },
    {
      _tid = tid[5],
      _level = left_level,
      _stars = left_star,
      rank = left_rank,
      _shard = {
        _id = ShardCheck(tid[5]),
        _level = 25
      }
    }
  }
  local randSeed = os.time() % 10000
  ed.srand(randSeed)
  local stageId = ed.getDataTable("GuildMountBoss")[BOSSID]["Stage ID"]
  local stage = ed.lookupDataTable("Stage", nil, stageId)
  local guildBossData = {id = BOSSID, health = StartHealth}
  ed.engine:enterGuildMountBoss(stage, left, true, guildBossData)
  ed.engine.custom_mode = true
  if ed.run_with_scene then
    loadShader()
    local stage = ed.lookupDataTable("Stage", nil, stageId)
    local battle = ed.lookupDataTable("Battle", nil, stageId, 1)
    ed.scene:reset(stage, battle, {
      guildMountBossInfo = {}
    })
    ed.pushScene(ed.scene)
  else
    ed.engine.running = true
    while ed.engine.running do
      ed.engine:tick()
    end
  end
end

local function calculateScore(team, BOSSID)
  startCustomBattle(team, BOSSID)
  local damage = math.floor(ed.engine:getPlayerTotalDamage(ed.emCampPlayer))
  local startHealth = StartHealth
  local endHealth = math.floor(ed.engine:geEenemyFinalHpPercent() * 10000)
  local HealthChange = endHealth - startHealth
  return damage, HealthChange
end

function table.contains(tbl, element)
  for _, value in ipairs(tbl) do
    if value == element then
      return true
    end
  end
  return false
end

function generateRandomCombinations(pool, teamSize, numCombinations)
  local combinations = {}
  local poolSize = #pool
  for _ = 1, numCombinations do
    local team = {}
    local tempPool = {
      unpack(pool)
    }
    for _ = 1, teamSize do
      local index = math.random(#tempPool)
      table.insert(team, table.remove(tempPool, index))
    end
    table.insert(combinations, team)
  end
  return combinations
end

local function selectTop3Teams(combinations, scores, healthChanges, teamSize)
  local top3Teams = {}
  local top3Scores = {}
  local top3HealthChanges = {}
  local maxScore1 = 0
  local maxIndex1 = -1
  for i, score in ipairs(scores) do
    if score > maxScore1 then
      maxScore1 = score
      maxIndex1 = i
    end
  end
  if maxIndex1 ~= -1 then
    table.insert(top3Teams, combinations[maxIndex1])
    table.insert(top3Scores, scores[maxIndex1])
    table.insert(top3HealthChanges, healthChanges[maxIndex1])
    table.remove(combinations, maxIndex1)
    table.remove(scores, maxIndex1)
    table.remove(healthChanges, maxIndex1)
  end
  local maxScore2 = 0
  local maxIndex2 = -1
  for i, team in ipairs(combinations) do
    local valid = true
    for _, hero in ipairs(team) do
      if table.contains(top3Teams[1], hero) then
        valid = false
        break
      end
    end
    if valid and maxScore2 < scores[i] then
      maxScore2 = scores[i]
      maxIndex2 = i
    end
  end
  if maxIndex2 ~= -1 then
    table.insert(top3Teams, combinations[maxIndex2])
    table.insert(top3Scores, scores[maxIndex2])
    table.insert(top3HealthChanges, healthChanges[maxIndex2])
    table.remove(combinations, maxIndex2)
    table.remove(scores, maxIndex2)
    table.remove(healthChanges, maxIndex2)
  end
  local maxScore3 = 0
  local maxIndex3 = -1
  for i, team in ipairs(combinations) do
    local valid = true
    for _, hero in ipairs(team) do
      if table.contains(top3Teams[1], hero) or table.contains(top3Teams[2], hero) then
        valid = false
        break
      end
    end
    if valid and maxScore3 < scores[i] then
      maxScore3 = scores[i]
      maxIndex3 = i
    end
  end
  if maxIndex3 ~= -1 then
    table.insert(top3Teams, combinations[maxIndex3])
    table.insert(top3Scores, scores[maxIndex3])
    table.insert(top3HealthChanges, healthChanges[maxIndex3])
  end
  return top3Teams, top3Scores, top3HealthChanges
end

local heroPool = {
  17,
  37,
  71,
  47,
  61,
  25,
  41,
  34,
  95,
  31,
  10023,
  75,
  72,
  64,
  11,
  55,
  46,
  54,
  2,
  10020,
  20,
  45
}
local teamSize = 5
local numCombinations = 800
local out = io.open("guild_mount_result_optimized.txt", "w+")
for BOSSID = 1, 98 do
  print("Optimizing for BOSSID: " .. BOSSID)
  local combinations = generateRandomCombinations(heroPool, teamSize, numCombinations)
  local scores = {}
  local healthChanges = {}
  for i, team in ipairs(combinations) do
    scores[i], healthChanges[i] = calculateScore(team, BOSSID)
  end
  local top3Teams, top3Scores, top3HealthChanges = selectTop3Teams(combinations, scores, healthChanges, teamSize)
  local totalScore = 0
  for _, score in ipairs(top3Scores) do
    totalScore = totalScore + score
  end
  out:write(BOSSID)
  out:write(",")
  out:write(totalScore)
  out:write(",")
  for i, team in ipairs(top3Teams) do
    out:write(BOSSID)
    out:write(",")
    out:write(table.concat(team, ", "))
    out:write(",")
    out:write(top3Scores[i])
    out:write(",")
    out:write(top3HealthChanges[i])
    out:write(",")
  end
  out:write("\n")
end
out:close()
