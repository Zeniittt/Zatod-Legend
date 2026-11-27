local function heatbuff3019update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  buff.dt = buff.dt and buff.dt + dt or dt
  local owner = buff.owner
  if buff.dt >= 14 then
    local max = -math.huge
    local ret
    for unit in ed.engine:foreachAliveUnit(-owner.camp) do
      if unit.buff_effects.untargetable or unit.buff_effects.invulnerable then
      elseif unit.buffManager.invisible and unit.camp ~= owner.camp then
      elseif unit.config.is_summoned then
      else
        local v = -unit.hp
        if max < v then
          max = v
          ret = unit
        end
      end
    end
    if ret then
      local dmg = ret.attribs.HP * 0.15 / owner.config.dps_mod
      if ed.run_with_scene then
        local effect_name = "eff_impact_Zeus_ult.cha"
        ed.scene:playEffectOnScene(effect_name, ret.position, {
          ret.direction,
          1
        }, nil, 1)
      end
      ret:takeDamage(dmg, "Holy", "hp", owner)
      buff.dt = 0
    end
  end
end

local function initBuff(buff)
  buff.update = override(buff.update, heatbuff3019update)
  return buff
end

return initBuff
