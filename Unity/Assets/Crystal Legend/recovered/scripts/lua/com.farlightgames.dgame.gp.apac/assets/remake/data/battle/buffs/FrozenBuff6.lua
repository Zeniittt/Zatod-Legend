local function onAttackSlot5(buff, skill)
  local owner = buff.owner
  
  local skill = owner.basic_skill
  local target = skill:selectTarget()
  if target and ed.rand() < 0.3 then
    local value = ed.getDataTable("SoloCardSkill")[69]["Level Arg 1"][buff.rank]
    target:addFrozen(value, {type = 1, id = 69}, owner)
  end
end

local function initBuff(buff)
  function buff.onAttackSlot5(skill)
    onAttackSlot5(buff, skill)
  end
  
  return buff
end

return initBuff
