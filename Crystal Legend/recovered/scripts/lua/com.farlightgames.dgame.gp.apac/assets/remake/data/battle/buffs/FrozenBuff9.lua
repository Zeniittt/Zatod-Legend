local function onHitMiss(buff)
  local owner = buff.owner
  
  local skill = owner.basic_skill
  local target = skill:selectTarget()
  if target then
    local value = ed.getDataTable("SoloCardSkill")[72]["Level Arg 1"][buff.rank]
    target:addFrozen(value, {type = 1, id = 72}, owner)
  end
end

local function initBuff(buff)
  function buff.onHitMiss()
    onHitMiss(buff)
  end
  
  return buff
end

return initBuff
