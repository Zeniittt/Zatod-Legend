local function rogueCharm26onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local info = buff.info
  
  local owner = buff.owner
  if 0 < damage and not transferred and source and not source.config.is_summoned and source.name == "JUGG" and bCrit and field and field == "hp" and ed.engine.rogueSkillMgr:getCharm(26) then
    local charmEffect = ed.engine.rogueSkillMgr:getCharm(26)
    local charmDmg = math.min(owner.hp * charmEffect.info["Script Arg" .. charmEffect.level] / 100, source.attribs.AD * charmEffect.info["Script Arg" .. charmEffect.level + 3])
    owner:takeDamage(charmDmg, "AD", "hp", source, 1, 1, true)
  end
  return damage
end

local function initBuff(buff)
  local caster = buff.caster
  local owner = buff.owner
  buff.onDamaged = override(buff.onDamaged, rogueCharm26onDamaged)
  return buff
end

return initBuff
