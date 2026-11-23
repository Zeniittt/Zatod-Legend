local function onHeal(buff, healAmount, reason, params)
  local owner = buff.owner
  
  if ed.rand() < 0.3 then
    local value = ed.getDataTable("SoloCardSkill")[100]["Level Arg 1"][buff.rank]
    local skill = owner.basic_skill
    local target = skill:selectTarget()
    if target then
      target:addWeak(value, {type = 1, id = 100}, owner)
    end
  end
end

local function initBuff(buff)
  function buff.onHeal(healAmount, reason, params)
    onHeal(buff, healAmount, reason, params)
  end
  
  return buff
end

return initBuff
