module("ed.battlehero", package.seeall)
local ed = ed
FancyAbyssbuff11_2 = {}

function FancyAbyssbuff11_2.createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  local fancy12_stageId = ed.engine.stage_info and ed.engine.stage_info["Stage ID"] or 0
  if 12112000 < fancy12_stageId and fancy12_stageId < 12112011 then
    buff:setAttribute("MRI", 100)
  end
  if 12112010 < fancy12_stageId and fancy12_stageId < 12112016 then
    buff:setAttribute("MRI", 200)
  end
  if 12112015 < fancy12_stageId and fancy12_stageId < 12112021 then
    buff:setAttribute("MRI", 400)
  end
  return buff
end

function FancyAbyssbuff11_2.init_fieldSkill(skill)
  skill.createBuff = override(skill.createBuff, FancyAbyssbuff11_2.createBuff)
  return skill
end

return FancyAbyssbuff11_2.init_fieldSkill
