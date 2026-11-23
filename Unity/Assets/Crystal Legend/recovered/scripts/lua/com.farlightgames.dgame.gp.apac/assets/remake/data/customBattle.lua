ed.enableMaxAttStrategy = true
ed["Show Gizmo"] = true
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
  local left_level = 80
  local right_star = 5
  local right_level = 80
  local useFieldId = 26
  local left = {
    {
      _tid = 47,
      _level = left_level,
      _stars = left_star,
      _legend_equip = {
        _equip = {
          _type_id = 9,
          _star = 3,
          _rank = 1
        }
      }
    }
  }
  local right = {
    {
      _tid = 1,
      _level = right_level,
      _stars = right_star
    }
  }
  local stage = ed.lookupDataTable("Stage", nil, -1)
  local battle = ed.lookupDataTable("Battle", nil, -1, 1)
  ed.parameter.unit_max_rank = 13
  local randSeed = os.time() % 10000
  print(randSeed)
  ed.srand(randSeed)
  ed.run_with_scene = true
  local bookReadingLevel = {
    selfBookReadingLevel = ed.bookReadingLevel,
    oppoBookReadingLevel = ed.bookReadingLevel
  }
  ed.engine:enterArena(left, right, true, true, nil, bookReadingLevel or nil, nil, useFieldId, useBonus and bonusInfo or nil)
  ed.scene:reset(stage, battle)
  ed.pushScene(ed.scene)
end

startCustomBattle()
