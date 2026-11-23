local function rogueTech2_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local owner = buff.owner
  
  local buffid = buff.info.ID
  local shielddmg = 0
  if buffid - 62990000 <= 2 then
    shielddmg = damage * 0.3
  end
  if buffid - 62990000 == 3 then
    shielddmg = damage * 0.4
  end
  for i, tbuff in ipairs(owner.buff_list) do
    if shielddmg == 0 then
      break
    end
    if tbuff.shield then
      if shielddmg <= tbuff.shield then
        tbuff.shield = tbuff.shield - shielddmg
        shielddmg = 0
      else
        shielddmg = shielddmg - tbuff.shield
        tbuff.shield = 0
        tbuff.timer = -1
      end
    end
  end
  return basefunc(buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
end

local function initBuff(buff)
  buff.onDamaged = override(buff.onDamaged, rogueTech2_onDamaged)
  buff.unremoveable = true
  return buff
end

return initBuff
