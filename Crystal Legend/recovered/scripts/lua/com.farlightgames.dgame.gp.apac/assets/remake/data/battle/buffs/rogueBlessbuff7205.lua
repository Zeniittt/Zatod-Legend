local function rogueBless7205onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local info = buff.info
  
  local owner = buff.owner
  if 0 < damage and field and field == "hp" and ed.engine.rogueSkillMgr:getBless(7205) then
    local bless7205 = ed.engine.rogueSkillMgr.rogueBlessList[7205]
    local bless7205haveshield = false
    for i, tbuff in ipairs(owner.buff_list) do
      if tbuff.shield and 0 < tbuff.shield then
        bless7205haveshield = true
        break
      end
    end
    if owner.revelation7buff then
      bless7205haveshield = true
    end
    if bless7205haveshield then
      damage = damage * (1 - (bless7205.isReinforced and bless7205.info["Script Arg5"] or bless7205.info["Script Arg1"]) / 100)
    end
  end
  return damage
end

local function initBuff(buff)
  local caster = buff.caster
  local owner = buff.owner
  buff.onDamaged = override(buff.onDamaged, rogueBless7205onDamaged)
  return buff
end

return initBuff
