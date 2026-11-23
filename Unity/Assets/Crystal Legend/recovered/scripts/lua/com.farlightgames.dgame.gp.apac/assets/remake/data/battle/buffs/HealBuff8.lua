local function onHitMiss(buff)
  local HealBuff8_values = ed.getDataTable("SoloCardSkill")[40]["Level Arg 1"]
  
  buff.owner:takeHeal(HealBuff8_values[buff.rank] or 0, "hp", buff.owner, nil, {type = 1, id = 40})
end

local function initBuff(buff)
  function buff.onHitMiss()
    onHitMiss(buff)
  end
  
  return buff
end

return initBuff
