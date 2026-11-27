local TestData = {}

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

function ed.TestChooseHero()
  ed.SoloModel:updateHero({_hid = 43, _insid = 1})
  ed.engine:onPrepareJoinBattle({
    hero = {
      _hid = 43,
      _powers = {}
    },
    camp = 1,
    params = {
      _cards = {},
      _card_factions = {}
    }
  })
end

local mainPanel

function ed.TestSoloProjectile()
  ListenTimer(Timer:Always(1), function()
    local projectile = ed.SoloProjectileCreate(ed.engine.leftUnit, ed.engine.rightUnit)
    ed.engine:addProjectile(projectile)
  end)
end

local function TestBattle(mainPanel)
  loadShader()
  local leftHeroId = 70
  local rightHeroId = 70
  ed.SoloManager:enterStage(ed.SoloManager.GAMESTAGE.BATTLE)
  ed.SoloModel:resetBattleDataList(leftHeroId, rightHeroId)
  mainPanel.dataPanel:onBattleStart()
  mainPanel.battleScene:setSpeedRate(1)
  ed.engine:clearAllSoloUnits()
  ed.engine.ticks = 0
  ed.engine.time_limit = 60
  mainPanel.ui.bg_oppo_panel:setVisible(true)
  ed.engine:resetStage()
  ed.engine.canTick = true
  ed.engine.running = true
  ed.engine:onPrepareJoinBattle({
    hero = {
      _hid = rightHeroId,
      _powers = {}
    },
    camp = -1,
    params = {
      _cards = {},
      _card_factions = {}
    },
    isBattle = true
  })
  ed.SoloModel:updateHero({_hid = leftHeroId})
  ed.engine:onPrepareJoinBattle({
    camp = 1,
    hero = {
      _hid = leftHeroId,
      _powers = {}
    },
    params = {
      _cards = {
        {_cid = 117, _level = 5}
      },
      _card_factions = {
        {_faction = 11, _level = 4}
      }
    },
    isBattle = true
  })
end

function ed.SoloBattleTest(mainPanel)
  TestBattle(mainPanel)
end
