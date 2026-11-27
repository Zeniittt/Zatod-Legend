local function trigger(buff, value, soloParams)
  local owner = buff.owner
  
  if ed.rand() <= 0.3 then
    local skill = owner.basic_skill
    local target = skill:selectTarget()
    if target then
      local group = ed.getDataTable("SoloSkillGroup")[1000][12]
      local skill_info = ed.SoloSkill.getSoloSkillInfo(group, 1)
      local skill = ed.SoloSkillCreate(skill_info, owner, 1)
      skill.target = target
      
      function skill.launchPoint(skill)
        return {
          owner.position[1],
          owner.position[2]
        }, 30
      end
      
      skill.art = "eff_tile_BatRider_atk.cha"
      
      function skill.takeEffectOn(skill, target, projectile)
        local damage = ed.getDataTable("SoloCardSkill")[buff.cardId]["Level Arg 1"][buff.rank] or 0
        target:takeDamage({
          amount = damage,
          damage_type = "AD",
          field = "hp",
          source = owner,
          coefficient = 1,
          crit_mod = 1,
          soloParams = {
            type = 1,
            id = buff.cardId
          }
        })
      end
      
      local projectile = ed.SoloProjectileCreate(skill)
      ed.engine:addProjectile(projectile)
    end
  end
end

local function initBuff(buff)
  buff.cardId = 80
  
  function buff.onAddShield(value, soloParams)
    return trigger(buff, value, soloParams)
  end
  
  return buff
end

return initBuff
