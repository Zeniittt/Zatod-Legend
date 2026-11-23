local function getDynaData(msg)
  local self_dyna_data = {}
  
  for i, h in ipairs(msg._self_heroes) do
    self_dyna_data[h._tid] = msg._self_dyna_start[i]
  end
  local oppo_dyna_data = {}
  for i, h in ipairs(msg._oppo_heroes) do
    oppo_dyna_data[h._tid] = msg._oppo_dyna_start[i]
  end
  return self_dyna_data, oppo_dyna_data
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
    "MirrorShader"
  }
  for i = 1, #list do
    EDLoadShader(list[i])
  end
  local stage_id = -1
  local stage = ed.lookupDataTable("Stage", nil, stage_id)
  local battle = ed.lookupDataTable("Battle", nil, stage_id, 1)
  local scriptName = "100499msg"
  local msg = require(scriptName)
  ed.srand(msg._rseed)
  local oppo_bot = msg._oppo_robot and msg._oppo_robot > 0
  local self_dyna, oppo_dyna = getDynaData(msg)
  ed.engine:enterCrusade(msg._self_heroes, msg._oppo_heroes, oppo_bot, self_dyna, oppo_dyna, stage_id)
  ed.engine:setOperationList(msg._oprations)
  local extraInfo = {}
  extraInfo.crusadeInfo = {}
  ed.scene:reset(stage, battle, extraInfo)
  ed.pushScene(ed.scene)
end

startCustomBattle()
