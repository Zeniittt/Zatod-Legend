local function heatbuff3011update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  buff.dt = buff.dt and buff.dt + dt or dt
  local owner = buff.owner
  local caster = buff.caster
  for unit in ed.engine:foreachAliveUnit(-owner.camp) do
    if unit:isAlive() and unit.config and unit.config.is_summoned and not unit.buff_effects.building then
      unit:die()
      unit.hp = 0
      unit:takeDamage(99999, "Holy", "hp", owner)
    end
  end
end

local function initBuff(buff)
  buff.update = override(buff.update, heatbuff3011update)
  return buff
end

return initBuff
