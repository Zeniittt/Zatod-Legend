module("ed", package.seeall)
local shaderList = {
  "GrayScalingShader",
  "FrozenShader",
  "StoneShader",
  "PoisonShader",
  "BanishShader",
  "InvisibleShader",
  "Blur",
  "IceShader",
  "MirrorShader",
  "VanishShader",
  "FireShader",
  "RubickShader",
  "MorSwitchShader_R",
  "MorSwitchShader_G",
  "MorShader_E",
  "MorShader_G",
  "MorShader_R",
  "HSVtoRGBShader",
  "HSVtoRGBShaderV2",
  "HueShader",
  "NanaShader",
  "DarkenShader",
  "ParasitismShader",
  "SandShader",
  "MorNewSwitchShader_R",
  "MorNewSwitchShader_G"
}

local function loadShader()
  for idx = 1, #shaderList do
    EDLoadShader(shaderList[idx])
  end
end

local function enterAutoChess(param)
  ed.engine:clearAllChessUnits()
  ed.engine:resetStage()
  ed.engine:initAutoChessParam({stageId = 100001})
  ed.engine.autoChessMode = true
  ed.engine.push_interval_tick = 4
  local stage = ed.lookupDataTable("Stage", nil, 100001)
  local battle = ed.lookupDataTable("Battle", nil, 100001, 1)
  ed.scene = ed.AutoChessBattleScene.create(stage, battle, {autoChessMode = true})
  ed.pushScene(ed.scene)
  ed.scene:setSpeedRate(2.5)
  local heroPos = {
    pos_9 = ccp(105, -43),
    pos_5 = ccp(140, 10),
    pos_1 = ccp(170, 45),
    pos_10 = ccp(175, -43),
    pos_6 = ccp(202, 10),
    pos_2 = ccp(225, 45),
    pos_11 = ccp(245, -43),
    pos_7 = ccp(265, 10),
    pos_3 = ccp(280, 45),
    pos_12 = ccp(320, -43),
    pos_8 = ccp(330, 10),
    pos_4 = ccp(340, 45)
  }
  local self_team = param.self_team
  local oppo_team = param.oppo_team
  ed.srand(param.rseed)
  if type(oppo_team._heroes) == "table" then
    for i, hero in ipairs(oppo_team._heroes) do
      local heroData = {
        _tid = hero._hid,
        _insid = hero._insid
      }
      if hero._pet then
        heroData._pet = {
          _insid = hero._pet._insid,
          _pid = hero._pet._pid
        }
      end
      local posIndex = oppo_team._positions[i]
      local pos = heroPos["pos_" .. posIndex]
      pos = ccp(ed.engine.stage_rect.maxX - pos.x, pos.y)
      local chessUnit = ed.engine:createChessBattleUnit(heroData, pos, ed.emCampEnemy)
      ed.engine:addChessUnit(chessUnit)
    end
  end
  if type(self_team._heroes) == "table" then
    for i, hero in ipairs(self_team._heroes) do
      local heroData = {
        _tid = hero._hid,
        _insid = hero._insid
      }
      if hero._pet then
        heroData._pet = {
          _insid = hero._pet._insid,
          _pid = hero._pet._pid
        }
      end
      local posIndex = self_team._positions[i]
      local pos = heroPos["pos_" .. posIndex]
      local chessUnit = ed.engine:createChessBattleUnit(heroData, pos, ed.emCampPlayer)
      ed.engine:addChessUnit(chessUnit)
    end
  end
  ed.engine:clearChessNpc()
  ed.engine:createChessNpcUnit()
end

require("battle/battle_check")
xpcall(function()
  do_battle_log = true
  loadShader()
  local msg = require("../dump__chess314960msg")
  local mode = "chess"
  local battleDatas = msg._battles
  ed.run_with_scene = true
  ed.run_chess_check = true
  ed.engine = ed.AutoChessBattleEngine
  local battleMsg = battleDatas[1]
  if not ed.run_with_scene then
    local serverTime = 0
    for cur_round = 1, 1 do
      battle_check.enterBattle(battleMsg, mode)
      local startTime = os.clock()
      while ed.engine.running do
        ed.engine:tick()
      end
      serverTime = serverTime + (os.clock() - startTime)
    end
    ed.engine:saveBattleLog()
    print(">>>>>>>>>>>>>>>>> ticks = " .. ed.engine.ticks)
  else
    ed.autoSaveChessLog = true
    local param = {
      self_team = battleMsg._self_team,
      oppo_team = battleMsg._oppo_team,
      rseed = battleMsg._rseed
    }
    enterAutoChess(param)
  end
end, EDDebug)
