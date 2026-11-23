local function heatbuff3008update(basefunc, buff, dt)
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
        local v = unit.battledata.damage
        if max < v then
          max = v
          ret = unit
        end
      end
    end
    if ret then
      if ed.run_with_scene then
        local effect_name = "eff_impact_Bone_awake.cha"
        local effect_z = 1
        ed.scene:playEffectOnScene(effect_name, ret.position, {
          ret.direction,
          1
        }, nil, effect_z)
      end
      local bid = 20030082
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      ret:addBuff(binfo, owner)
      buff.dt = 0
    end
  end
end

local function initBuff(buff)
  buff.update = override(buff.update, heatbuff3008update)
  return buff
end

return initBuff
