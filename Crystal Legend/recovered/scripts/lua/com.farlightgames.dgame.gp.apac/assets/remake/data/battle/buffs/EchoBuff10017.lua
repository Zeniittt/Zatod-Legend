local function Echobuff10017_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local dmg = basefunc(buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  
  if dmg and field == "hp" then
    dmg = dmg * 1.4
  end
  return dmg
end

local function initBuff(buff)
  buff.onDamaged = override(buff.onDamaged, Echobuff10017_onDamaged)
  return buff
end

return initBuff
