local function onAttackSlot1(buff)
  local owner = buff.owner
  
  local skill = owner.basic_skill
  local target = skill:selectTarget()
  if target then
    local value = ed.getDataTable("SoloCardSkill")[74]["Level Arg 1"][buff.rank]
    target:addFrozen(value, {type = 1, id = 74}, owner)
  end
end

local function initBuff(buff)
  function buff.onAttackSlot1()
    onAttackSlot1(buff)
  end
  
  return buff
end

return initBuff
