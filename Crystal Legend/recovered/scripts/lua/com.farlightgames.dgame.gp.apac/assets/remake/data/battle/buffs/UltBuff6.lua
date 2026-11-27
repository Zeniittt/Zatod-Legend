local function onAttackSlot5(buff, skill)
  local owner = buff.owner
  
  if ed.rand() <= 0.35 then
    local UltBuff6_values = ed.getDataTable("SoloCardSkill")[48]["Level Arg 1"]
    owner:takeHeal(UltBuff6_values[buff.rank] or 0, "mp", owner, nil, {type = 1, id = 48})
  end
end

local function initBuff(buff)
  function buff.onAttackSlot5(skill)
    onAttackSlot5(buff, skill)
  end
  
  return buff
end

return initBuff
