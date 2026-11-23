local function rogueBless8201_1onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local info = buff.info
  
  local owner = buff.owner
  if 0 < damage and bCrit and source and not source.config.is_summoned and source.camp == 1 and not transferred and field and field == "hp" then
    local rogueBless8201countadd = 1
    if ed.engine.rogueSkillMgr:getBless(8202) then
      local bless8202 = ed.engine.rogueSkillMgr.rogueBlessList[8202]
      local p = (bless8202.isReinforced and bless8202.info["Script Arg1"] or bless8202.info["Script Arg5"]) / 100
      if p >= ed.rand() then
        rogueBless8201countadd = 2
      end
    end
    if source.rogueBless8201count and source.rogueBless8201maxcount and not source.belss8201Triggered then
      source.rogueBless8201count = math.min(source.rogueBless8201count + rogueBless8201countadd, source.rogueBless8201maxcount)
    end
    if source.belss8201Triggered then
      source.belss8201Triggered = false
    end
    if ed.engine.rogueSkillMgr:getBless(8402) then
      local bless8402 = ed.engine.rogueSkillMgr.rogueBlessList[8402]
      if source.rogueBless8201count and 0 < source.rogueBless8201count then
        source:takeHeal(bless8402.info["Script Arg1"] * source.rogueBless8201count, "hp", source)
      elseif source.belss8201Triggered then
        source:takeHeal(bless8402.info["Script Arg1"] * source.rogueBless8201maxcount, "hp", source)
      end
    end
  end
  return damage
end

local function initBuff(buff)
  local caster = buff.caster
  local owner = buff.owner
  buff.onDamaged = override(buff.onDamaged, rogueBless8201_1onDamaged)
  return buff
end

return initBuff
