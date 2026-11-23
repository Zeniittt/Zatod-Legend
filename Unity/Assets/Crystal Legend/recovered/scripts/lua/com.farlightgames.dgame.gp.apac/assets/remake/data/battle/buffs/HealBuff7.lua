local function onHitCrit(buff)
  local HealBuff7_values = ed.getDataTable("SoloCardSkill")[39]["Level Arg 1"]
  
  buff.owner:takeHeal(HealBuff7_values[buff.rank] or 0, "hp", buff.owner, nil, {type = 1, id = 39})
end

local function initBuff(buff)
  function buff.onHitCrit()
    onHitCrit(buff)
  end
  
  return buff
end

return initBuff
