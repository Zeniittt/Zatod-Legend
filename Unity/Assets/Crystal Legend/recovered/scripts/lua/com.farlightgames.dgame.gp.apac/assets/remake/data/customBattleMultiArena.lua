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
  local msg, mode = battle_check.getMsg("../dump__multiarena100014msg")
  battle_check.enterBattle(msg, mode)
end, EDDebug)
