local function HealBuff3_update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  local owner = buff.owner
  local hasteSpeedUp = owner:getHasteSpeed()
  local adjustedDt = dt * hasteSpeedUp
  buff.HealBuff3_CD = buff.HealBuff3_CD + adjustedDt
  if buff.HealBuff3_CD >= 2 then
    local Heal_2 = owner.battledata:getTakeHeal()
    local HealBuff3_values = ed.getDataTable("SoloCardSkill")[35]["Level Arg 1"]
    local HealBuff3_Min = ed.getDataTable("SoloCardSkill")[35]["Level Arg 2"]
    local Heal_Dvalue = Heal_2 - buff.preHeal
    local Heal_Power = Heal_Dvalue * ((HealBuff3_values[buff.rank] or 0) * 0.01)
    Heal_Power = math.max(Heal_Power, HealBuff3_Min[buff.rank] or 0)
    local skill = owner.basic_skill
    local target = skill:selectTarget()
    if target then
      local group = ed.getDataTable("SoloSkillGroup")[1000][12]
      local skill_info = ed.SoloSkill.getSoloSkillInfo(group, 1)
      local skill = ed.SoloSkillCreate(skill_info, buff.owner, 1)
      skill.target = target
      
      function skill.launchPoint(skill)
        return {
          owner.position[1],
          owner.position[2]
        }, 30
      end
      
      function skill.takeEffectOn(skill, target, projectile)
        if ed.run_with_scene then
          ed.scene:playEffectOnScene("eff_point_KOTL_atk3.cha", target.position, {
            target.direction * 0.25,
            0.25
          }, nil, 1)
        end
        target:takeDamage({
          amount = Heal_Power,
          damage_type = "AD",
          field = "hp",
          source = owner,
          soloParams = {type = 1, id = 35}
        })
      end
      
      local projectile = ed.SoloProjectileCreate(skill)
      ed.engine:addProjectile(projectile)
      owner.periodicSkillCount = owner.periodicSkillCount + 1
    end
    buff.preHeal = Heal_2
    buff.HealBuff3_CD = 0
  end
end

local function initBuff(buff)
  local owner = buff.owner
  buff.HealBuff3_CD = 0
  buff.preHeal = 0
  buff.update = override(buff.update, HealBuff3_update)
  return buff
end

return initBuff
