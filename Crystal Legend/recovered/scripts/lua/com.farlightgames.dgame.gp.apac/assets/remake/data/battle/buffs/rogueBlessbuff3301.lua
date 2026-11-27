local function rogueBless3301onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local info = buff.info
  
  local owner = buff.owner
  if 0 < damage and not transferred and source and not source.config.is_summoned and source.camp == 1 and ed.engine.rogueSkillMgr:getBless(3301) then
    local bless3301 = ed.engine.rogueSkillMgr.rogueBlessList[3301]
    if skill and source and skill == source.basic_skill and not source.config.is_summoned then
      local p = (bless3301.isReinforced and bless3301.info["Script Arg5"] or bless3301.info["Script Arg1"]) / 100 * source.attribs.HP
      owner:takeDamage(p, "Holy", "hp", source, 1, 1, true)
    end
  end
  return damage
end

local function initBuff(buff)
  local caster = buff.caster
  local owner = buff.owner
  buff.onDamaged = override(buff.onDamaged, rogueBless3301onDamaged)
  return buff
end

return initBuff
