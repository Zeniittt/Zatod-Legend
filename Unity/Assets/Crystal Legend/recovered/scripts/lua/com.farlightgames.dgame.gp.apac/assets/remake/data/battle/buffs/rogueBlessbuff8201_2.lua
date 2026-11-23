local function rogueBless8201_2onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local info = buff.info
  
  local owner = buff.owner
  if 0 < damage and bCrit and source and not source.config.is_summoned and source.camp == 1 and not transferred and field and field == "hp" and source.rogueBless8201count and source.rogueBless8201maxcount and source.rogueBless8201count == source.rogueBless8201maxcount and ed.engine.rogueSkillMgr:getBless(8201) then
    source.rogueBless8201count = 0
    source.belss8201Triggered = true
    local bless8201 = ed.engine.rogueSkillMgr.rogueBlessList[8201]
    local bless8201ratio = (bless8201.isReinforced and bless8201.info["Script Arg6"] or bless8201.info["Script Arg2"]) / 100
    damage = damage * (1 + bless8201ratio)
    if ed.engine.rogueSkillMgr:getBless(8203) then
      local bless8203 = ed.engine.rogueSkillMgr.rogueBlessList[8203]
      local mpadd = bless8203.isReinforced and bless8203.info["Script Arg5"] or bless8203.info["Script Arg1"]
      source:takeHeal(mpadd, "mp", source)
    end
  end
  return damage
end

local function initBuff(buff)
  local caster = buff.caster
  local owner = buff.owner
  buff.onDamaged = override(buff.onDamaged, rogueBless8201_2onDamaged)
  return buff
end

return initBuff
