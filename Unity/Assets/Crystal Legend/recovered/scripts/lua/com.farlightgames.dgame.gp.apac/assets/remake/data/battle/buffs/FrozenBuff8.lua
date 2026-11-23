local function onHitCrit(buff)
  local owner = buff.owner
  
  local skill = owner.basic_skill
  local target = skill:selectTarget()
  if target then
    local value = ed.getDataTable("SoloCardSkill")[71]["Level Arg 1"][buff.rank]
    target:addFrozen(value, {type = 1, id = 71}, owner)
  end
end

local function initBuff(buff)
  function buff.onHitCrit()
    onHitCrit(buff)
  end
  
  return buff
end

return initBuff
