local function onAttackSlot5(buff, skill)
  local owner = buff.owner
  
  if ed.rand() < 0.3 then
    local value = ed.getDataTable("SoloCardSkill")[98]["Level Arg 1"][buff.rank]
    local skill = owner.basic_skill
    local target = skill:selectTarget()
    if target then
      target:addWeak(value, {type = 1, id = 84}, owner)
    end
  end
end

local function initBuff(buff)
  function buff.onAttackSlot5(skill)
    onAttackSlot5(buff, skill)
  end
  
  return buff
end

return initBuff
