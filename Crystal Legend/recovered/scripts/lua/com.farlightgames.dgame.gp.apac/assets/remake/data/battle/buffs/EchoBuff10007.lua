local function Echobuff10007_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field)
  if source and damage then
    damage = damage * 0.5
  end
  return basefunc(buff, damage, damage_type, source, skill, transferred, field)
end

local function initBuff(buff)
  buff.onDamaged = override(buff.onDamaged, Echobuff10007_onDamaged)
  return buff
end

return initBuff
