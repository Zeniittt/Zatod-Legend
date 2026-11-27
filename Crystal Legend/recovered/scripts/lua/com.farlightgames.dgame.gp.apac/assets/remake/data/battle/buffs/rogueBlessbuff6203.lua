local function rogueBless6203onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local info = buff.info
  
  local owner = buff.owner
  if 0 < damage and damage_type == "AP" and ed.engine.rogueSkillMgr:getBless(6203) then
    local bless6203 = ed.engine.rogueSkillMgr.rogueBlessList[6203]
    if owner.bless6201count then
      damage = damage * (1 + owner.bless6201count * (bless6203.isReinforced and bless6203.info["Script Arg5"] or bless6203.info["Script Arg1"]) / 100)
    end
  end
  return damage
end

local function initBuff(buff)
  local caster = buff.caster
  local owner = buff.owner
  buff.onDamaged = override(buff.onDamaged, rogueBless6203onDamaged)
  return buff
end

return initBuff
