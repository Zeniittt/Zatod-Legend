local function rogueBless6202onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local info = buff.info
  
  local owner = buff.owner
  if 0 < damage and damage_type == "AD" and ed.engine.rogueSkillMgr:getBless(6202) then
    local bless6202 = ed.engine.rogueSkillMgr.rogueBlessList[6202]
    if owner.bless6201count then
      damage = damage * (1 + owner.bless6201count * (bless6202.isReinforced and bless6202.info["Script Arg5"] or bless6202.info["Script Arg1"]) / 100)
    end
  end
  return damage
end

local function initBuff(buff)
  local caster = buff.caster
  local owner = buff.owner
  buff.onDamaged = override(buff.onDamaged, rogueBless6202onDamaged)
  return buff
end

return initBuff
