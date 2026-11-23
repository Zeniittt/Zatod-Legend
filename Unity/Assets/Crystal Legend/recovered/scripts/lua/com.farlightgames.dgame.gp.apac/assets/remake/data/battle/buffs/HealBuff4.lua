local function trigger(buff)
  local owner = buff.owner
  
  if ed.rand() < 0.3 then
    local HealBuff4_values = ed.getDataTable("SoloCardSkill")[36]["Level Arg 1"]
    owner:takeHeal(HealBuff4_values[buff.rank] or 0, "hp", owner, nil, {type = 1, id = 36})
  end
end

local function initBuff(buff)
  local owner = buff.owner
  
  function buff.trigger()
    trigger(buff)
  end
  
  return buff
end

return initBuff
