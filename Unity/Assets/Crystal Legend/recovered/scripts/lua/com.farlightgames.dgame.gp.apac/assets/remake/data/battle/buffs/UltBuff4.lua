local function UltBuff4_update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  local owner = buff.owner
  owner.DamageAmount1 = owner.battledata:getDamage()
  if owner.DamageAmount1 > owner.DamageAmount2 then
    owner.DamageAmount2 = owner.DamageAmount1
    if ed.rand() > 0.5 then
      local UltBuff4_values = ed.getDataTable("SoloCardSkill")[46]["Level Arg 1"]
      owner:takeHeal(UltBuff4_values[buff.rank], "mp", owner, nil, {type = 1, id = 46})
    end
  end
end

local function initBuff(buff)
  local owner = buff.owner
  if owner then
    owner.DamageAmount1 = 0
    owner.DamageAmount2 = 0
  end
  buff.update = override(buff.update, UltBuff4_update)
  return buff
end

return initBuff
