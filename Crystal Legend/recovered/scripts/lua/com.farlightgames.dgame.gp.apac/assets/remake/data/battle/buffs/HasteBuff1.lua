local function HasteBuff1_update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  local owner = buff.owner
  local baseInterval = 4
  local hasteSpeedUp = owner:getHasteSpeed()
  local adjustedDt = dt * hasteSpeedUp
  buff.triggerCD = buff.triggerCD + adjustedDt
  if baseInterval <= buff.triggerCD then
    local skill = owner.basic_skill
    local target = skill:selectTarget()
    if target then
      local damage = ed.getDataTable("SoloCardSkill")[buff.cardId]["Level Arg 1"][buff.rank] or 0
      local group = ed.getDataTable("SoloSkillGroup")[1000][12]
      local skill_info = ed.SoloSkill.getSoloSkillInfo(group, 1)
      local projectileSkill = ed.SoloSkillCreate(skill_info, owner, 1)
      projectileSkill.target = target
      
      function projectileSkill.launchPoint(skill)
        return {
          owner.position[1],
          owner.position[2]
        }, 30
      end
      
      function projectileSkill.takeEffectOn(skill, target, projectile)
        target:takeDamage({
          amount = damage,
          damage_type = "Holy",
          field = "hp",
          source = owner,
          coefficient = 1,
          crit_mod = 1,
          soloParams = {
            type = 1,
            id = buff.cardId
          }
        })
        if ed.run_with_scene then
        end
      end
      
      local projectile = ed.SoloProjectileCreate(projectileSkill)
      ed.engine:addProjectile(projectile)
      owner.periodicSkillCount = owner.periodicSkillCount + 1
    end
    buff.triggerCD = 0
  end
end

local function initBuff(buff)
  local owner = buff.owner
  buff.triggerCD = 0
  buff.cardId = 106
  buff.update = override(buff.update, HasteBuff1_update)
  return buff
end

return initBuff
