module("ed", package.seeall)
CustomBattleNightmare = {}
CustomBattleNightmare.__index = CustomBattleNightmare

function CustomBattleNightmare.create(stageId)
  local nightmare = {}
  setmetatable(nightmare, CustomBattleNightmare)
  nightmare:initData(stageId)
  nightmare:loadShader()
  return nightmare
end

function CustomBattleNightmare:initData(stageId)
  assert(stageId ~= nil and tonumber(stageId), "Invalid stageID!")
  self.stageId = stageId
  self.mercenaryId = 12
  self.nightmareBattleUnitIds = {
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

function CustomBattleNightmare:initCustomHeroes()
  local function createHeros(heroIds)
    local heroes = {}
    
    for _, id in ipairs(heroIds) do
      local hero = ed.commonmsg.hero()
      hero._tid = id
      hero._level = 100
      hero._stars = 5
      hero._rank = 16
      hero._arousal = {_status = 0}
      hero._hero_rune = {_status = 0}
      local wrapHero = ed.HeroCreate()
      wrapHero:setup(hero)
      heroes[#heroes + 1] = wrapHero
      if self.mercenaryId == id then
        wrapHero:setMercenaryData({})
      end
    end
    return heroes
  end
  
  self.nightmareBattleUnits = createHeros(self.nightmareBattleUnitIds)
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

function CustomBattleNightmare:loadShader()
  for idx = 1, #shaderList do
    EDLoadShader(shaderList[idx])
  end
end

function CustomBattleNightmare:startNightmareBattle()
  local stageId = self.stageId
  local param = {
    stageId = self.stageId,
    nightmareBattleUnits = self.nightmareBattleUnits,
    warschool = nil,
    bookLevels = bookReadingLevel
  }
  engine:enterNightmare(param)
  local stage = lookupDataTable("Stage", nil, stageId)
  local battle = lookupDataTable("Battle", nil, stageId, 1)
  scene:reset(stage, battle, {
    nightmareInfo = {}
  })
  pushScene(scene)
  ed.player.loots = {
    ed.makebits(7, 1, 3, 3, 1, 0, 16, 101)
  }
  print(ed.splitbits(ed.player.loots[1], EDTables.globalConfig.waveIDBitNum, 3, 1, EDTables.globalConfig.itemIDBitNum))
end

local isBattleCheck = true
if isBattleCheck then
  require("battle/battle_check")
  ed.enableMaxAttStrategy = false
  do_battle_log = true
  CustomBattleNightmare.loadShader()
  local msg, mode = battle_check.getMsg("../cheat_nightmare1474msg")
  battle_check.enterBattle(msg, mode)
  ed.player.loots = msg._all_drop_infos
  ed.player._tutorial = {
    [149] = 1,
    [150] = 1
  }
else
  local stageId = 80000
  local nightmare = CustomBattleNightmare.create(stageId)
  nightmare:startNightmareBattle()
end
