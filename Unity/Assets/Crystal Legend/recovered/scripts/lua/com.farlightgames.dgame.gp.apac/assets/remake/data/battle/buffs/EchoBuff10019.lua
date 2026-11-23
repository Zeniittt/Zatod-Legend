local function Echobuff10019_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local dmg = basefunc(buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  
  if dmg and damage_type == "AD" or damage_type == "AP" and field == "hp" then
    dmg = dmg * 1.5
  end
  return dmg
end

local function initBuff(buff)
  buff.onDamaged = override(buff.onDamaged, Echobuff10019_onDamaged)
  return buff
end

return initBuff
