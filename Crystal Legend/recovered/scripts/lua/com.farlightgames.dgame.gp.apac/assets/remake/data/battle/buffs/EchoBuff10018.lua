local function Echobuff10018_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local dmg = basefunc(buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  
  if dmg and source and source.config.is_summoned == true and field == "hp" then
    dmg = dmg * 1.6
  end
  return dmg
end

local function initBuff(buff)
  buff.onDamaged = override(buff.onDamaged, Echobuff10018_onDamaged)
  return buff
end

return initBuff
