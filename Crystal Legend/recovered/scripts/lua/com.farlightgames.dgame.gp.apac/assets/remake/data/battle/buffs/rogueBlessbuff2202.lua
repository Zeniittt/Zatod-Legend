local function rogueBless2202onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo)
  local info = buff.info
  
  local owner = buff.owner
  if 0 < damage and damage_type == "AP" and not transferred and source and not source.config.is_summoned and source.camp == 1 and ed.engine.rogueSkillMgr:getBless(2202) then
    local bless2202 = ed.engine.rogueSkillMgr.rogueBlessList[2202]
    if source and source.rogueBless2201count then
      owner:takeDamage(source.rogueBless2201count * (bless2202.isReinforced and bless2202.info["Script Arg5"] or bless2202.info["Script Arg1"]), "AP", "hp", source, 1, 1, true)
    end
  end
  return damage
end

local function initBuff(buff)
  local caster = buff.caster
  local owner = buff.owner
  buff.onDamaged = override(buff.onDamaged, rogueBless2202onDamaged)
  return buff
end

return initBuff
