local function rogueBless5315_1onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local info = buff.info
  
  local owner = buff.owner
  if 0 < damage and field and field == "hp" then
    owner.rogueBless5315_1CumulativeDamage = owner.rogueBless5315_1CumulativeDamage + damage
  end
  return damage
end

local function rogueBless5315_1onRemove(basefunc, buff)
  local owner = buff.owner
  local caster = buff.caster
  basefunc(buff)
  local revelation = ed.engine.rogueSkillMgr:getRogueRevelation()
  if revelation.destinyId == 5 then
    buff.revelationratio = revelation.info["Script Arg2"] / 100
  else
    local destinyInfo = ed.getDataTable("RogueDestiny")[5]
    buff.revelationratio = destinyInfo["Script Arg2"] / 100
  end
  if ed.engine.rogue_mode and ed.engine.rogueSkillMgr:getBless(5103) then
    buff.revelationratio = ed.engine.rogueSkillMgr.rogueBlessList[5103].info["Script Arg1"] / 100
  end
  if buff.timer <= 0 and not ed.engine.beingEnd then
    owner:takeDamage(buff.revelationratio * owner.rogueBless5315_1CumulativeDamage, "AP", "hp", caster, 1, 1, true)
    if ed.run_with_scene then
      local effect_name = "eff_impact_WW_atk.cha"
      if effect_name then
        ed.scene:playEffectOnScene(effect_name, owner.position, {1, 1}, nil, 1)
      end
    end
  end
end

local function initBuff(buff)
  local caster = buff.caster
  local owner = buff.owner
  owner.rogueBless5315_1CumulativeDamage = 0
  buff.onDamaged = override(buff.onDamaged, rogueBless5315_1onDamaged)
  buff.onRemoved = override(buff.onRemoved, rogueBless5315_1onRemove)
  return buff
end

return initBuff
