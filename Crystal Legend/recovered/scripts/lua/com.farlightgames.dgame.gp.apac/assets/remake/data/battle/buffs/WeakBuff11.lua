local function onAttackSlot1(buff)
  local owner = buff.owner
  
  local value = ed.getDataTable("SoloCardSkill")[101]["Level Arg 1"][buff.rank] or 0
  local skill = owner.basic_skill
  local target = skill:selectTarget()
  if target then
    target:addWeak(value, {type = 1, id = 101}, owner)
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
