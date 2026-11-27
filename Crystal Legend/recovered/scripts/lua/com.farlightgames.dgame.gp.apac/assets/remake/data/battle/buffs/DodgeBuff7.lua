local function DodgeBuff7_update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  local owner = buff.owner
  local hasteSpeedUp = owner:getHasteSpeed()
  local adjustedDt = dt * hasteSpeedUp
  if buff.DodgeBuff7_CD then
    buff.DodgeBuff7_CD = buff.DodgeBuff7_CD + adjustedDt
  else
    buff.DodgeBuff7_CD = 0
  end
  if buff.DodgeBuff7_CD >= 1 then
    local skill = owner.basic_skill
    local target = skill:selectTarget()
    local Damage_values = ed.getDataTable("SoloCardSkill")[15]["Level Arg 1"]
    if target then
      local group = ed.getDataTable("SoloSkillGroup")[1000][11]
      local skill_info = ed.SoloSkill.getSoloSkillInfo(group, 1)
      local skill = ed.SoloSkillCreate(skill_info, owner, 1)
      skill.target = target
      
      function skill.launchPoint(skill)
        return {
          owner.position[1],
          owner.position[2]
        }, 30
      end
      
      function skill.takeEffectOn(skill, target, projectile)
        local Owner_DODG = owner.attribs.DODG
        local Owner_CRIT = owner.attribs.CRIT
        if ed.run_with_scene then
          ed.scene:playEffectOnScene("eff_impact_burst.cha", target.position, {
            target.direction,
            1
          }, nil, 1)
        end
        target:takeDamage({
          amount = (Owner_DODG + Owner_CRIT) * (Damage_values[buff.rank] or 0),
          damage_type = "AD",
          field = "hp",
          source = owner,
          coefficient = 1,
          crit_mod = 1,
          soloParams = {type = 1, id = 15}
        })
      end
      
      local projectile = ed.SoloProjectileCreate(skill)
      ed.engine:addProjectile(projectile)
      owner.periodicSkillCount = owner.periodicSkillCount + 1
    end
    buff.DodgeBuff7_CD = 0
  end
end

local function initBuff(buff)
  local owner = buff.owner
  buff.DodgeBuff7_CD = 0
  buff.update = override(buff.update, DodgeBuff7_update)
  return buff
end

return initBuff
