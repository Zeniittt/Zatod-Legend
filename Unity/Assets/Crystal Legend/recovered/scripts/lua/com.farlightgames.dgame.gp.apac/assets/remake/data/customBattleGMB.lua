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

local tid = {}
local tid1 = {
  34,
  17,
  37,
  64,
  54
}
local tid2 = {
  75,
  72,
  11,
  57,
  9
}
local tid3 = {
  61,
  63,
  31,
  2,
  16
}
local tid4 = {
  20,
  61,
  63,
  31,
  2
}
local tid5 = {
  45,
  75,
  72,
  57,
  9
}
tid = {
  tid1,
  tid2,
  tid3,
  tid4,
  tid5
}
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

local out = io.open("guild_mount_result.txt", "w+")
for i = 1, 98 do
  local BOSSID = i
  out:write(BOSSID)
  for j = 1, 5 do
    startCustomBattle(tid[j], BOSSID)
    local damage = math.floor(ed.engine:getPlayerTotalDamage(ed.emCampPlayer))
    local startHealth = StartHealth
    local endHealth = math.floor(ed.engine:geEenemyFinalHpPercent() * 10000)
    print("Round:" .. i, "   Damage:" .. damage)
    out:write(",")
    out:write(j)
    out:write(",")
    out:write(damage)
    out:write(",")
    out:write(startHealth - endHealth)
  end
  out:write("\n")
end
