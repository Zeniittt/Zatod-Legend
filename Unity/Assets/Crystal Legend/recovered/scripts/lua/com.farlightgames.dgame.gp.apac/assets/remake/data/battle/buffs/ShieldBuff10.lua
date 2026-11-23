local function onHeal(buff, healAmount, reason, params)
  local owner = buff.owner
  
  if ed.rand() < 0.3 then
    local value = ed.getDataTable("SoloCardSkill")[86]["Level Arg 1"][buff.rank]
    owner:addShield(value)
  end
end

local function initBuff(buff)
  function buff.onHeal(healAmount, reason, params)
    onHeal(buff, healAmount, reason, params)
  end
  
  return buff
end

return initBuff
