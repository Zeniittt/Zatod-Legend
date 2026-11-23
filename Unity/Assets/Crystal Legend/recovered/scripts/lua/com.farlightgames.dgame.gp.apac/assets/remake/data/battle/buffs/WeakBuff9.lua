local function onHitMiss(buff)
  local owner = buff.owner
  
  local value = ed.getDataTable("SoloCardSkill")[99]["Level Arg 1"][buff.rank]
  local skill = owner.basic_skill
  local target = skill:selectTarget()
  if target then
    target:addWeak(value, {type = 1, id = 99}, owner)
  end
end

local function initBuff(buff)
  function buff.onHitMiss()
    onHitMiss(buff)
  end
  
  return buff
end

return initBuff
