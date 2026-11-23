local function rogueBless4301onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local info = buff.info
  
  local owner = buff.owner
  if 0 < damage and not transferred and source and not source.config.is_summoned and source.camp == 1 and ed.engine.rogueSkillMgr:getBless(4301) then
    local bless4301 = ed.engine.rogueSkillMgr.rogueBlessList[4301]
    if skill and source and skill == source.basic_skill and not source.config.is_summoned then
      local p
      if bless4301.isReinforced then
        p = 1
      else
        p = bless4301.info["Script Arg1"] / 100
      end
      if p >= ed.rand() then
        source:takeHeal(bless4301.isReinforced and bless4301.info["Script Arg5"] or bless4301.info["Script Arg2"], "hp", source)
      end
    end
  end
  return damage
end

local function initBuff(buff)
  local caster = buff.caster
  local owner = buff.owner
  buff.onDamaged = override(buff.onDamaged, rogueBless4301onDamaged)
  return buff
end

return initBuff
