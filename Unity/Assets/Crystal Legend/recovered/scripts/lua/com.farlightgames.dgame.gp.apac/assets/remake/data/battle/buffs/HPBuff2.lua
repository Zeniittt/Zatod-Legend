local function HPBuff2_update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  local owner = buff.owner
  local hasteSpeedUp = owner:getHasteSpeed()
  local adjustedDt = dt * hasteSpeedUp
  if buff.HPBuff2_CD then
    buff.HPBuff2_CD = buff.HPBuff2_CD + adjustedDt
  else
    buff.HPBuff2_CD = 0
  end
  if buff.HPBuff2_CD >= 1.5 then
    local skill = owner.basic_skill
    local target = skill:selectTarget()
    local Damage_values = ed.getDataTable("SoloCardSkill")[23]["Level Arg 1"]
    if target then
      local Owner_HP = owner.attribs.HP
      if ed.run_with_scene then
        ed.scene:playEffectOnScene("eff_impact_Puck_atk.cha", target.position, {
          target.direction,
          1
        }, nil, 1)
      end
      target:takeDamage({
        amount = Owner_HP * (Damage_values[buff.rank] or 0) / 100,
        damage_type = "AD",
        field = "hp",
        source = owner,
        coefficient = 1,
        crit_mod = 1,
        soloParams = {type = 1, id = 23}
      })
      owner.periodicSkillCount = owner.periodicSkillCount + 1
    end
    buff.HPBuff2_CD = 0
  end
end

local function initBuff(buff)
  local owner = buff.owner
  buff.HPBuff2_CD = 0
  buff.update = override(buff.update, HPBuff2_update)
  return buff
end

return initBuff
