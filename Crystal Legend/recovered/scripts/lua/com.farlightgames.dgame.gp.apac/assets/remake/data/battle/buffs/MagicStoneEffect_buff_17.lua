local function onBuffRemove(basefunc, buff)
  basefunc(buff)
end

local function onBuffAdderServer(basefunc, buff)
  basefunc(buff)
  if buff.owner then
    buff.owner.MagicStoneEffect_buff_17 = 3
  end
end

local function onBuffDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field)
  local lost = basefunc(buff, damage, damage_type, source, skill, transferred, field)
  local owner = buff.owner
  if owner:isAlive() and lost and 0 < lost and damage_type ~= "Heal" and 0 < owner.MagicStoneEffect_buff_17 and owner.hp < owner.attribs.HP * 0.5 then
    owner.MagicStoneEffect_buff_17 = owner.MagicStoneEffect_buff_17 - 1
    owner:takeHeal(math.min(buff.info["Script Arg 1"], 50000), "hp", owner)
    if ed.run_with_scene then
      local effect_name = "eff_impact_heal.cha"
      local origin = owner.position
      if effect_name then
        ed.scene:playEffectOnScene(effect_name, origin, {
          owner.direction * 0.85,
          0.85
        }, nil, 1)
      end
    end
  end
  return lost
end

local function initBuff(buff)
  buff.onRemoved = override(buff.onRemoved, onBuffRemove)
  buff.onAddedServer = override(buff.onAddedServer, onBuffAdderServer)
  buff.onDamaged = override(buff.onDamaged, onBuffDamaged)
  return buff
end

return initBuff
