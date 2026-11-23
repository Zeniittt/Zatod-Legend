local function rogueBless6301onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local info = buff.info
  
  local owner = buff.owner
  if 0 < damage and not transferred and source and not source.config.is_summoned and source.camp == 1 and ed.engine.rogueSkillMgr:getBless(6301) then
    local bless6301 = ed.engine.rogueSkillMgr.rogueBlessList[6301]
    if skill and source and skill == source.basic_skill and not source.config.is_summoned then
      local bless6301bid = 60016301
      local bless6301binfo = ed.lookupDataTable("Buff", nil, bless6301bid)
      local bless6301buff = ed.BuffCreate(bless6301binfo, owner, source)
      bless6301buff:setAttribute("HPR", (bless6301.isReinforced and bless6301.info["Script Arg5"] or bless6301.info["Script Arg1"]) * source.attribs.AD)
      bless6301buff.timer = bless6301.isReinforced and bless6301.info["Script Arg6"] or bless6301.info["Script Arg2"]
      owner:addBuff(bless6301buff, source)
    end
  end
  return damage
end

local function initBuff(buff)
  local caster = buff.caster
  local owner = buff.owner
  buff.onDamaged = override(buff.onDamaged, rogueBless6301onDamaged)
  return buff
end

return initBuff
