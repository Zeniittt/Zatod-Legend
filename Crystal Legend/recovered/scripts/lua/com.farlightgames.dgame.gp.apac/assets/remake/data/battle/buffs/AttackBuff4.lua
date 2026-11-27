local function AttackBuff4_update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  local owner = buff.owner
  local hasteSpeedUp = owner:getHasteSpeed()
  local adjustedDt = dt * hasteSpeedUp
  if buff.AttackBuff4_CD then
    buff.AttackBuff4_CD = buff.AttackBuff4_CD + adjustedDt
  end
  if buff.AttackBuff4_CD >= 1 then
    local skill = owner.basic_skill
    local target = skill:selectTarget()
    local Damage_values = ed.getDataTable("SoloCardSkill")[4]["Level Arg 1"]
    local MinDamage_values = ed.getDataTable("SoloCardSkill")[4]["Level Arg 2"]
    if target then
      local Target_AD = target.attribs.AD
      local Owner_AD = owner.attribs.AD
      local damage = math.max(MinDamage_values[buff.rank], (Owner_AD - Target_AD) * Damage_values[buff.rank])
      target:takeDamage({
        amount = damage,
        damage_type = "AP",
        field = "hp",
        source = owner,
        soloParams = {type = 1, id = 4}
      })
      if ed.run_with_scene then
        local effect_name = "eff_impact_Dancer_ult.cha"
        local effect_z = 1
        ed.scene:playEffectOnScene(effect_name, target.position, {
          target.direction * 0.6,
          0.6
        }, nil, effect_z)
      end
      owner.periodicSkillCount = owner.periodicSkillCount + 1
    end
    buff.AttackBuff4_CD = 0
  end
end

local function initBuff(buff)
  local owner = buff.owner
  buff.AttackBuff4_CD = 0
  buff.update = override(buff.update, AttackBuff4_update)
  return buff
end

return initBuff
