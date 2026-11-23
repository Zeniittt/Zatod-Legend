local function rogueCharm25onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local info = buff.info
  
  local owner = buff.owner
  if damage and 0 < damage and not transferred and source and not source.config.is_summoned and bCrit and field and field == "hp" and ed.engine.rogueSkillMgr:getCharm(25) then
    local charmEffect = ed.engine.rogueSkillMgr:getCharm(25)
    local mp = charmEffect.info["Script Arg" .. charmEffect.level]
    source:takeHeal(mp, "mp", source)
  end
  return damage
end

local function initBuff(buff)
  local caster = buff.caster
  local owner = buff.owner
  buff.onDamaged = override(buff.onDamaged, rogueCharm25onDamaged)
  return buff
end

return initBuff
