local function heatbuff3024update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  buff.dt = buff.dt and buff.dt + dt or dt
  local owner = buff.owner
  if buff.dt >= 15 then
    local max = -math.huge
    local ret
    for unit in ed.engine:foreachAliveUnit(-owner.camp) do
      if unit.buff_effects.untargetable or unit.buff_effects.invulnerable then
      elseif unit.buffManager.invisible and unit.camp ~= owner.camp then
      elseif unit.config.is_summoned then
      else
        local v = unit.battledata.takeHeal
        if max < v then
          max = v
          ret = unit
        end
      end
    end
    if ret then
      if ed.run_with_scene then
        local effect_name = "eff_point_DP_fashion_1_atk3.cha"
        local effect_z = -1
        ed.scene:playEffectOnScene(effect_name, ret.position, {0.5, 0.5}, nil, effect_z)
      end
      local bid = 20030242
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      ret:addBuff(binfo, owner)
      buff.dt = 0
    end
  end
end

local function initBuff(buff)
  buff.update = override(buff.update, heatbuff3024update)
  return buff
end

return initBuff
