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

require("battle/battle_check")
xpcall(function()
  do_battle_log = true
  loadShader()
  local msg = require("../cheat_487929_8_solo903056msg")
  local mode = "solo"
  local battleDatas = msg._battles
  ed.run_with_scene = true
  ed.run_chess_check = true
  ed.engine = ed.SoloBattleEngine
  ed.scene = ed.SoloBattleScene
  local battleMsg = battleDatas[1]
  if not ed.run_with_scene then
    local serverTime = 0
    battle_check.enterBattle(battleMsg, mode)
    local startTime = os.clock()
    while ed.engine.running do
      ed.engine:tick()
    end
    serverTime = serverTime + (os.clock() - startTime)
    ed.engine:saveBattleLog()
    print(">>>>>>>>>>>>>>>>> ticks = " .. ed.engine.ticks)
  else
    ed.SoloModel:setFactions({
      1,
      2,
      3,
      4,
      5,
      6,
      7,
      8
    })
    ed.engine = ed.SoloBattleEngine
    ed.PopupCreate = ed.SoloPopupCreate
    ed.SoloBattleEngine:enterSolo()
    local scene = ed.SoloBattleScene.create()
    ed.pushScene(scene)
    ListenTimer(Timer:Once(1), function()
      do_battle_log = true
      local panel = scene.SoloPanel
      ed.srand(battleMsg._rseed)
      panel.eventTick = 0
      panel.realTime = 0
      panel.ticks = 0
      panel.ui.bg_oppo_panel:setVisible(true)
      ed.engine:clearAllSoloUnits()
      ed.SoloManager:enterStage(ed.SoloManager.GAMESTAGE.BATTLE)
      ed.engine:enterSoloCheck(battleMsg)
    end)
  end
end, EDDebug)
