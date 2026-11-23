local function rogueBless1311onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local info = buff.info
  
  local owner = buff.owner
  if 0 < damage and damage_type == "AD" and not transferred and source and not source.config.is_summoned and source.camp == 1 and ed.engine.rogueSkillMgr:getBless(1311) then
    local bless1311 = ed.engine.rogueSkillMgr.rogueBlessList[1311]
    local p = (bless1311.isReinforced and bless1311.info["Script Arg5"] or bless1311.info["Script Arg1"]) / 100
    if p >= ed.rand() then
      owner:takeDamage(amount * (bless1311.isReinforced and bless1311.info["Script Arg6"] or bless1311.info["Script Arg2"]) / 100, "AD", "hp", source, 1, 1, true)
    end
  end
  return damage
end

local function initBuff(buff)
  local caster = buff.caster
  local owner = buff.owner
  buff.onDamaged = override(buff.onDamaged, rogueBless1311onDamaged)
  return buff
end

return initBuff
