ed.enableMaxAttStrategy = true
ed["Show Gizmo"] = false
do_battle_log = true
ed.isTestBattle = true
ed.warschool = 0
ed.bookReadingLevel = 0
local getRuneInfoFunction = require("battle/bot_rune")
local getPetBagFunction = require("battle/bot_pet")

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
    "MorShader_E",
    "MorShader_G",
    "MorShader_R",
    "DarkenShader",
    "ParasitismShader",
    "SandShader",
    "DinaShader",
    "PuckShader",
    "KaelShader",
    "BKBShader",
    "MorNewSwitchShader_R",
    "MorNewSwitchShader_G",
    "MorFashionShader_R",
    "HalfInvisibleShader"
  }
  for i = 1, #list do
    EDLoadShader(list[i])
  end
end

local function startCustomBattle()
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
  local left_star = 5
  local left_level = 79
  local right_star = 5
  local right_level = 80
  local useFieldId = 26
  local left = {
    {
      _tid = 1,
      _level = left_level,
      _stars = left_star
    },
    {
      _tid = 2,
      _level = left_level,
      _stars = left_star
    },
    {
      _tid = 3,
      _level = left_level,
      _stars = left_star
    },
    {
      _tid = 4,
      _level = left_level,
      _stars = left_star
    },
    {
      _tid = 5,
      _level = left_level,
      _stars = left_star
    },
    {
      _tid = 6,
      _level = left_level,
      _stars = left_star
    },
    {
      _tid = 7,
      _level = left_level,
      _stars = left_star
    },
    {
      _tid = 8,
      _level = left_level,
      _stars = left_star
    },
    {
      _tid = 9,
      _level = left_level,
      _stars = left_star
    },
    {
      _tid = 10,
      _level = left_level,
      _stars = left_star
    },
    {
      _tid = 11,
      _level = left_level,
      _stars = left_star
    },
    {
      _tid = 12,
      _level = left_level,
      _stars = left_star
    },
    {
      _tid = 13,
      _level = left_level,
      _stars = left_star
    },
    {
      _tid = 14,
      _level = left_level,
      _stars = left_star
    },
    {
      _tid = 15,
      _level = left_level,
      _stars = left_star
    }
  }
  local right = {
    {
      _tid = 1,
      _level = right_level,
      _stars = right_star
    },
    {
      _tid = 2,
      _level = right_level,
      _stars = right_star
    },
    {
      _tid = 3,
      _level = right_level,
      _stars = right_star
    },
    {
      _tid = 4,
      _level = right_level,
      _stars = right_star
    },
    {
      _tid = 5,
      _level = right_level,
      _stars = right_star
    },
    {
      _tid = 6,
      _level = left_level,
      _stars = left_star
    },
    {
      _tid = 7,
      _level = left_level,
      _stars = left_star
    },
    {
      _tid = 8,
      _level = left_level,
      _stars = left_star
    },
    {
      _tid = 9,
      _level = left_level,
      _stars = left_star
    },
    {
      _tid = 10,
      _level = left_level,
      _stars = left_star
    },
    {
      _tid = 11,
      _level = left_level,
      _stars = left_star
    },
    {
      _tid = 12,
      _level = left_level,
      _stars = left_star
    },
    {
      _tid = 13,
      _level = left_level,
      _stars = left_star
    },
    {
      _tid = 14,
      _level = left_level,
      _stars = left_star
    },
    {
      _tid = 15,
      _level = left_level,
      _stars = left_star
    }
  }
  local stage = ed.lookupDataTable("Stage", nil, -1)
  local battle = ed.lookupDataTable("Battle", nil, -1, 1)
  ed.parameter.unit_max_rank = 12
  local randSeed = os.time() % 10000
  print(randSeed)
  ed.srand(randSeed)
  ed.run_with_scene = true
  ed.engine:enterMoba(left, right, true, true)
  ed.scene:reset(stage, battle, {
    mobaInfo = {}
  })
  ed.scene:setSpeedRate(2.5)
  ed.pushScene(ed.scene)
end

startCustomBattle()
