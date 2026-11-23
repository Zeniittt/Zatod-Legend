local function WeakBuff1_update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  local owner = buff.owner
  local hasteSpeedUp = owner:getHasteSpeed()
  local adjustedDt = dt * hasteSpeedUp
  buff.triggerCD = buff.triggerCD + adjustedDt
  if buff.triggerCD >= 0.5 then
    local skill = owner.basic_skill
    local target = skill:selectTarget()
    if target and ed.run_with_scene and not buff.effect_play then
      local effect_name = "eff_point_solo_card91_1.cha"
      ed.scene:playEffectOnScene(effect_name, target.position, {
        target.direction,
        1
      }, nil, 1)
      local effect_name = "eff_point_solo_card91_2.cha"
      ed.scene:playEffectOnScene(effect_name, target.position, {
        target.direction,
        1
      }, nil, -1)
      buff.effect_play = true
    end
  end
  if buff.triggerCD >= 1 then
    local skill = owner.basic_skill
    local target = skill:selectTarget()
    if target then
      target:takeDamage({
        amount = 100,
        damage_type = "AP",
        field = "hp",
        source = owner,
        coefficient = 1,
        crit_mod = 1,
        soloParams = {type = 1, id = 91}
      })
      target:addWeak(25, {type = 1, id = 91}, owner)
      owner.periodicSkillCount = owner.periodicSkillCount + 1
    end
    buff.triggerCD = 0
    buff.effect_play = false
  end
end

local function initBuff(buff)
  local owner = buff.owner
  buff.triggerCD = 0
  buff.update = override(buff.update, WeakBuff1_update)
  return buff
end

return initBuff
