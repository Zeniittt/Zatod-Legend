local function heatbuff3027_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field)
  local dmg = basefunc(buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  
  local buffid = buff.info.ID
  local level = buffid - 20030270
  local reduceratio = level * 0.2
  if dmg and source and field == "hp" and source.config.is_summoned == true then
    dmg = dmg * (1 - reduceratio)
  end
  return dmg
end

local function initBuff(buff)
  buff.onDamaged = override(buff.onDamaged, heatbuff3027_onDamaged)
  return buff
end

return initBuff
