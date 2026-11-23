local function FrozenBuff1_update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  local owner = buff.owner
  local hasteSpeedUp = owner:getHasteSpeed()
  local adjustedDt = dt * hasteSpeedUp
  buff.triggerCD = buff.triggerCD + adjustedDt
  if buff.triggerCD >= 2 then
    local skill = owner.basic_skill
    local target = skill:selectTarget()
    if target then
      local value = ed.getDataTable("SoloCardSkill")[64]["Level Arg 1"][buff.rank]
      target:takeDamage({
        amount = value + target.frozenValue * 2,
        damage_type = "AP",
        field = "hp",
        source = owner,
        coefficient = 1,
        crit_mod = 1,
        soloParams = {type = 1, id = 64}
      })
      if ed.run_with_scene then
        ed.scene:playEffectOnScene("eff_point_solo_card64.cha", target.position, {
          target.direction,
          1
        }, nil, 1)
      end
      owner.periodicSkillCount = owner.periodicSkillCount + 1
    end
    buff.triggerCD = 0
  end
end

local function initBuff(buff)
  local owner = buff.owner
  buff.triggerCD = 0
  buff.update = override(buff.update, FrozenBuff1_update)
  return buff
end

return initBuff
