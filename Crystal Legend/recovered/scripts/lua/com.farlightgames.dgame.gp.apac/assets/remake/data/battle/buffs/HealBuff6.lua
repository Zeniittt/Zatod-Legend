local function onAttackSlot5(buff, skill)
  local owner = buff.owner
  
  local skill = owner.basic_skill
  local target = skill:selectTarget()
  if target and ed.rand() < 0.3 then
    local value = ed.getDataTable("SoloCardSkill")[38]["Level Arg 1"][buff.rank] or 0
    owner:takeHeal(value, "hp", owner, nil, {type = 1, id = 38})
  end
end

local function initBuff(buff)
  function buff.onAttackSlot5(skill)
    onAttackSlot5(buff, skill)
  end
  
  return buff
end

return initBuff
