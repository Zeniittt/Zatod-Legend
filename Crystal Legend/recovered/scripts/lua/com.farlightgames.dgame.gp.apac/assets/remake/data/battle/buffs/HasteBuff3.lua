local function triggerMissile(buff)
  local owner = buff.owner
  
  local skill = owner.basic_skill
  local target = skill:selectTarget()
  if target then
    local damage = ed.getDataTable("SoloCardSkill")[buff.cardId]["Level Arg 1"][buff.rank] or 0
    local group = ed.getDataTable("SoloSkillGroup")[1000][12]
    local skill_info = ed.SoloSkill.getSoloSkillInfo(group, 1)
    local missileSkill = ed.SoloSkillCreate(skill_info, owner, 1)
    missileSkill.target = target
    
    function missileSkill.launchPoint(skill)
      return {
        owner.position[1],
        owner.position[2]
      }, 30
    end
    
    function missileSkill.takeEffectOn(skill, target, projectile)
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
    
    local projectile = ed.SoloProjectileCreate(missileSkill)
    ed.engine:addProjectile(projectile)
  end
end

local function HasteBuff3_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local owner = buff.owner
  if owner.periodicSkillCount >= 10 then
    triggerMissile(buff)
    owner.periodicSkillCount = 0
  end
end

local function initBuff(buff)
  local owner = buff.owner
  buff.cardId = 108
  buff.update = override(buff.update, HasteBuff3_update)
  return buff
end

return initBuff
