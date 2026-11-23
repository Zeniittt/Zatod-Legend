local function rogueBless5301onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local info = buff.info
  
  local owner = buff.owner
  if 0 < damage and not transferred and source and not source.config.is_summoned and source.camp == 1 and ed.engine.rogueSkillMgr:getBless(5301) then
    local bless5301 = ed.engine.rogueSkillMgr.rogueBlessList[5301]
    if skill and source and skill == source.basic_skill and not source.config.is_summoned then
      local p = (bless5301.isReinforced and bless5301.info["Script Arg5"] or bless5301.info["Script Arg1"]) / 100
      if p >= ed.rand() and owner.rogue5301frozencd and 0 >= owner.rogue5301frozencd and not owner.buff_effects.uncontrollable and not owner.buff_effects.invulnerable then
        local bless5301bid = 60015301
        local bless5301binfo = ed.lookupDataTable("Buff", nil, bless5301bid)
        local bless5301buff = ed.BuffCreate(bless5301binfo, owner, source)
        bless5301buff.timer = bless5301.isReinforced and bless5301.info["Script Arg6"] or bless5301.info["Script Arg2"]
        owner:addBuff(bless5301buff, source)
        owner.rogue5301frozencd = bless5301.isReinforced and bless5301.info["Script Arg7"] or bless5301.info["Script Arg3"]
      end
    end
  end
  return damage
end

local function rogueBless5301update(basefunc, buff, dt)
  basefunc(buff, dt)
  buff.dt = buff.dt and buff.dt + dt or dt
  local owner = buff.owner
  if buff.dt == dt then
    owner.rogue5301frozencd = 0
  end
  if owner.rogue5301frozencd then
    owner.rogue5301frozencd = owner.rogue5301frozencd - dt
  end
end

local function initBuff(buff)
  local caster = buff.caster
  local owner = buff.owner
  buff.onDamaged = override(buff.onDamaged, rogueBless5301onDamaged)
  buff.update = override(buff.update, rogueBless5301update)
  return buff
end

return initBuff
