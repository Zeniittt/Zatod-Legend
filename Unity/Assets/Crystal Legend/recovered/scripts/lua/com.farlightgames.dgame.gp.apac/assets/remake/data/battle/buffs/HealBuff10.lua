local function onAttackSlot1(buff)
  local owner = buff.owner
  
  local HealBuff10_values = ed.getDataTable("SoloCardSkill")[42]["Level Arg 1"]
  owner:takeHeal(HealBuff10_values[buff.rank] or 0, "hp", owner, nil, {type = 1, id = 42})
end

local function initBuff(buff)
  function buff.onAttackSlot1()
    onAttackSlot1(buff)
  end
  
  return buff
end

return initBuff
