local class = newclass("g")
ed.rogueRevelation5 = class

function class.rogueRevelation5createBuff(basefunc, rogueRevelation, target)
  local buff = basefunc(rogueRevelation, target)
  local owner = buff.owner
  buff.timer = rogueRevelation.info["Script Arg1"]
  buff.revelationratio = rogueRevelation.info["Script Arg2"] / 100
  if ed.engine.rogue_mode and ed.engine.rogueSkillMgr:getBless(5102) then
    buff.timer = ed.engine.rogueSkillMgr.rogueBlessList[5102].info["Script Arg1"]
  end
  if ed.engine.rogue_mode and ed.engine.rogueSkillMgr:getBless(5103) then
    buff.revelationratio = ed.engine.rogueSkillMgr.rogueBlessList[5103].info["Script Arg1"] / 100
  end
  owner.revelation5CumulativeDamage = 0
  buff.onDamaged = override(buff.onDamaged, class.rogueRevelation5BuffonDamaged)
  buff.onRemoved = override(buff.onRemoved, class.rogueRevelation5BuffRemove)
  return buff
end

function class.rogueRevelation5BuffonDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local owner = buff.owner
  if 0 < damage and field and field == "hp" then
    owner.revelation5CumulativeDamage = owner.revelation5CumulativeDamage + damage
  end
  return damage
end

function class.rogueRevelation5BuffRemove(basefunc, buff)
  local owner = buff.owner
  local caster = buff.caster
  local magiccaster = ed.engine.rogueSkillMgr.magicCaster
  basefunc(buff)
  if buff.timer <= 0 and not ed.engine.beingEnd then
    owner:takeDamage(buff.revelationratio * owner.revelation5CumulativeDamage, "AP", "hp", magiccaster, 1, 1, true)
    if ed.run_with_scene then
      local effect_name = "eff_impact_WW_atk.cha"
      if effect_name then
        ed.scene:playEffectOnScene(effect_name, owner.position, {1, 1}, nil, 1)
      end
    end
  end
end

function class.init(rogueRevelation)
  rogueRevelation.createBuff = override(rogueRevelation.createBuff, class.rogueRevelation5createBuff)
  for unit in ed.engine:foreachAliveUnit(ed.emCampBoth) do
    local bid = 60015000
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, unit, unit)
    unit:addBuff(buff, unit)
  end
  return rogueRevelation
end

return class.init
