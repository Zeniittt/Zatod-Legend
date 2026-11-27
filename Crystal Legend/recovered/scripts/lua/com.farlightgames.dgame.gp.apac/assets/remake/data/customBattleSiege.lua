module("ed", package.seeall)
CustomBattleSiege = {}
CustomBattleSiege.__index = CustomBattleSiege

function CustomBattleSiege.create(stageId)
  local siege = {}
  setmetatable(siege, CustomBattleSiege)
  siege:initData(stageId)
  siege:loadShader()
  return siege
end

function CustomBattleSiege:initData(stageId)
  assert(stageId ~= nil and tonumber(stageId), "Invalid stageID!")
  local superAwakeId = 1
  self.siegeStageID = stageId
  self.superAwakeHeroID = superAwakeId
  self.siegeBattleHeroIDs = {
    superAwakeId,
    85,
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
    15,
    16,
    18,
    19,
    20,
    21,
    17,
    63,
    47,
    71,
    77,
    87,
    92
  }
  local ed = ed
  ed.srand(33)
  ed.run_with_scene = true
  ed.warschool = 0
  ed.bookReadingLevel = 0
  ed.enableMaxAttStrategy = true
  ed.parameter.unit_max_rank = 16
  self:initCustomHeroes()
end

function CustomBattleSiege:initCustomHeroes()
  local function heroCanAwake(id)
    if ed.lookupDataTable("Unit", "Can Awake", id) then
      return true
    end
    return false
  end
  
  local heroes = {}
  for _, id in ipairs(self.siegeBattleHeroIDs) do
    local hero = ed.commonmsg.hero()
    hero._tid = id
    hero._level = 100
    hero._stars = 5
    hero._rank = 16
    hero._arousal = {_status = 1}
    local wrapHero = ed.HeroCreate()
    wrapHero:setup(hero)
    heroes[#heroes + 1] = wrapHero
  end
  self.siegeBattleHeroes = heroes
end

local shaderList = {
  "RubickShader",
  "GrayScalingShader",
  "FrozenShader",
  "StoneShader",
  "PoisonShader",
  "BanishShader",
  "InvisibleShader",
  "Blur",
  "IceShader",
  "MirrorShader",
  "MorSwitchShader_R",
  "MorSwitchShader_G",
  "MorShader_E",
  "MorShader_G",
  "MorShader_R",
  "MorNewSwitchShader_R",
  "MorNewSwitchShader_G"
}

function CustomBattleSiege:loadShader()
  for idx = 1, #shaderList do
    EDLoadShader(shaderList[idx])
  end
end

function CustomBattleSiege:startSiegeBattle()
  local stageId = self.siegeStageID
  local param = {
    superAwakeHeroID = self.superAwakeHeroID,
    siegeBattleHeroes = self.siegeBattleHeroes,
    siegeStageID = stageId,
    warschool = nil,
    bookLevels = bookReadingLevel
  }
  engine:enterSiege(param)
  local stage = lookupDataTable("Stage", nil, stageId)
  local battle = lookupDataTable("Battle", nil, stageId, 1)
  scene:reset(stage, battle, {
    siegeInfo = {}
  })
  pushScene(scene)
end

local isBattleCheck = false
if isBattleCheck then
  require("battle/battle_check")
  ed.enableMaxAttStrategy = false
  do_battle_log = true
  local msg, mode = battle_check.getMsg("../dump_siege518076msg")
  battle_check.enterBattle(msg, mode)
else
  local stageId = 70000
  local siege = CustomBattleSiege.create(stageId)
  siege:startSiegeBattle()
end
