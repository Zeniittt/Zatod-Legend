local function onAttackSlot5(buff, skill)
  local owner = buff.owner
  
  local skill = owner.basic_skill
  local target = skill:selectTarget()
  if target and ed.rand() < 0.3 then
    local drug = ed.getDataTable("SoloCardSkill")[57]["Level Arg 1"][buff.rank]
    target:addDrug(drug, {type = 1, id = 57}, owner)
  end
end

local function initBuff(buff)
  function buff.onAttackSlot5(skill)
    onAttackSlot5(buff, skill)
  end
  
  return buff
end

return initBuff
