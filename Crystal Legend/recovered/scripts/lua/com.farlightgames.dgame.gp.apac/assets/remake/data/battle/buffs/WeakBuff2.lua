local function WeakBuff2_update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  local owner = buff.owner
  if not buff.isTrigged then
    local skill = owner.basic_skill
    local target = skill:selectTarget()
    if target then
      buff.isTrigged = true
      local value = ed.getDataTable("SoloCardSkill")[92]["Level Arg 1"][buff.rank]
      target:addWeak(value, {type = 1, id = 92}, owner)
      if ed.run_with_scene then
        local effect_name = "eff_point_solo_card92.cha"
        ed.scene:playEffectOnScene(effect_name, target.position, {
          target.direction,
          1
        }, nil, 1)
      end
      return
    end
  end
end

local function initBuff(buff)
  buff.update = override(buff.update, WeakBuff2_update)
  return buff
end

return initBuff
