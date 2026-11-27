local function onAttackSlot1(buff)
  local owner = buff.owner
  
  local skill = owner.basic_skill
  local target = skill:selectTarget()
  if target then
    local drug = ed.getDataTable("SoloCardSkill")[62]["Level Arg 1"][buff.rank]
    target:addDrug(drug, {type = 1, id = 62}, owner)
  end
end

local function initBuff(buff)
  local owner = buff.owner
  
  function buff.onAttackSlot1(skill)
    onAttackSlot1(buff, skill)
  end
  
  return buff
end

return initBuff
