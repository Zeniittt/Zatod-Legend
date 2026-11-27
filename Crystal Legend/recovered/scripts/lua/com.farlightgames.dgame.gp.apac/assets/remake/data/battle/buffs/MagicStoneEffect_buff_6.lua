local function onBuffRemove(basefunc, buff)
  basefunc(buff)
  
  if buff.owner then
  end
end

local function onBuffAdderServer(basefunc, buff)
  basefunc(buff)
  if buff.owner then
    buff.owner.MagicStoneEffect_buff_6 = true
    buff.owner.MagicStoneEffect_buff_6s = false
  end
end

local function buffUpdate(basefunc, buff, dt)
  basefunc(buff, dt)
  local owner = buff.owner
  if owner:isAlive() and owner.MagicStoneEffect_buff_6s then
    owner.MagicStoneEffect_buff_6s = false
    local Heal_HP = math.min(buff.info["Script Arg 1"], 60000)
    owner:takeHeal(Heal_HP, "hp", owner)
    if ed.run_with_scene then
      ed.scene:playEffectOnScene("eff_impact_heal.cha", owner.position, {
        owner.direction,
        1
      }, nil, 0)
    end
  end
end

local function onBuffDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field)
  local lost = basefunc(buff, damage, damage_type, source, skill, transferred, field)
  local owner = buff.owner
  if owner:isAlive() and lost and lost > owner.attribs.HP * 0.3 and damage_type ~= "Heal" and owner.MagicStoneEffect_buff_6 then
    owner.MagicStoneEffect_buff_6 = false
    owner.MagicStoneEffect_buff_6s = true
  end
  return lost
end

local function initBuff(buff)
  buff.update = override(buff.update, buffUpdate)
  buff.onRemoved = override(buff.onRemoved, onBuffRemove)
  buff.onAddedServer = override(buff.onAddedServer, onBuffAdderServer)
  buff.onDamaged = override(buff.onDamaged, onBuffDamaged)
  return buff
end

return initBuff
