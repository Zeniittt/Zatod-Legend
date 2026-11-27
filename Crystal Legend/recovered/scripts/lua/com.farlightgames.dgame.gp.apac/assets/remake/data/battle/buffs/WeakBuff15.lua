local function WeakBuff15_update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  local owner = buff.owner
  local hasteSpeedUp = owner:getHasteSpeed()
  local adjustedDt = dt * hasteSpeedUp
  buff.triggerCD = buff.triggerCD + adjustedDt
  if buff.triggerCD >= 0.6 then
    local skill = owner.basic_skill
    local target = skill:selectTarget()
    if target then
      local value = buff.skillCount * ed.getDataTable("SoloCardSkill")[105]["Level Arg 1"][buff.rank]
      target:takeDamage({
        amount = math.floor(value),
        damage_type = "AP",
        field = "hp",
        source = owner,
        coefficient = 1,
        crit_mod = 1,
        soloParams = {type = 1, id = 105}
      })
      if ed.run_with_scene then
        local effect_name = "eff_impact_TitanFV_atk3.cha"
        local effect_z = 1
        ed.scene:playEffectOnScene(effect_name, target.position, {
          target.direction,
          1
        }, nil, effect_z)
      end
      owner.periodicSkillCount = owner.periodicSkillCount + 1
    end
    buff.triggerCD = 0
  end
end

local function initBuff(buff)
  local owner = buff.owner
  local skillCount = 0
  if owner.cards then
    for k, v in pairs(owner.cards) do
      local cardTb = ed.getDataTable("SoloCardSkill")[k]
      if cardTb and (cardTb.Tag1 == 9 or cardTb.Tag2 == 9 or cardTb.Tag1 == 10 or cardTb.Tag2 == 10) then
        skillCount = skillCount + 1
      end
    end
  end
  buff.triggerCD = 0
  buff.skillCount = skillCount
  buff.cardId = 105
  buff.update = override(buff.update, WeakBuff15_update)
  return buff
end

return initBuff
