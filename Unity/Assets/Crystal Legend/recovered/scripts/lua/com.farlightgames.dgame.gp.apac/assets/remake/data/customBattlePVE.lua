ed.enableMaxAttStrategy = true
ed.isTestBattle = true
ed.warSchoolLevel = 0
local warschool
local bookReadingLevel = 0

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
    "MorSwitchShader_R",
    "MorSwitchShader_G",
    "MorShader_E",
    "MorShader_G",
    "MorShader_R",
    "NanaShader",
    "MorNewSwitchShader_R",
    "MorNewSwitchShader_G"
  }
  for i = 1, #list do
    EDLoadShader(list[i])
  end
  local stageId = 30000001
  local waveId = 1
  local herolevel = 100
  local herorank = 16
  local _arousal_status = {
    _status = 1,
    _str = 100,
    _int = 100,
    _agi = 100
  }
  local _rune_info = {
    _status = 1,
    _sun = 0,
    _moon = 0,
    _star = 0
  }
  local _pet_info1 = {
    _type_id = 100009,
    _heart = 5,
    _skill_levels = {100, 100}
  }
  local status = 1
  local stars = 5
  local heros = {
    {
      _tid = "TitanDragon",
      _level = herolevel,
      _stars = 5
    },
    {
      _tid = "TitanRazor",
      _level = herolevel,
      _stars = 5
    },
    {
      _tid = "TitanDH",
      _level = herolevel,
      _stars = 5
    },
    {
      _tid = "TitanPA",
      _level = herolevel,
      _stars = 5
    },
    {
      _tid = "TitanXL",
      _level = herolevel,
      _stars = 5
    }
  }
  ed.parameter.unit_max_rank = herorank
  ed.parameter.team_level_max = 80
  ed.run_with_scene = true
  local stage = ed.lookupDataTable("Stage", nil, stageId)
  local battle = ed.lookupDataTable("Battle", nil, stageId, waveId)
  local randSeed = os.time() % 10000
  print(randSeed)
  ed.engine:enterStage(stage, heros, false, waveId, warschool, bookReadingLevel)
  ed.scene:reset(stage, battle, {})
  ed.pushScene(ed.scene)
end

for i = 1, 3 do
  startCustomBattle()
end
