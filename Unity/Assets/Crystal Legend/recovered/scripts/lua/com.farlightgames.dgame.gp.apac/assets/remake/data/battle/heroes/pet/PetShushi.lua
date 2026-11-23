module("ed.battlehero", package.seeall)
local ed = ed
PetShushi = {}
PetShushi.PetShushi_startBuffID = 1349

function PetShushi.skill1_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  local v = 900
  local caster = skill.caster
  local target = projectile.skill.target
  if not target then
    return
  end
  projectile:enableTrack(target)
  projectile.height = 300
  projectile.position = {
    caster.position[1],
    caster.position[2]
  }
  PetShushi.targetpos = {
    target.position[1] - 60 * caster.direction,
    target.position[2]
  }
  local targetxyV = ed.edpSub(PetShushi.targetpos, projectile.position)
  local targetzV = -projectile.height
  local u = (targetxyV[1] * targetxyV[1] + targetxyV[2] * targetxyV[2] + targetzV * targetzV) ^ (-0.5)
  local targetV = {
    u * targetxyV[1],
    u * targetxyV[2],
    u * targetzV
  }
  projectile.velocity[1] = targetV[1] * v
  projectile.velocity[2] = targetV[2] * v
  projectile.zSpeed = targetV[3] * v
  return projectile
end

function PetShushi.hero_update(basefunc, pet, dt)
  basefunc(pet, dt)
  if not pet.petShushi_buffadded then
    local bid = PetShushi.PetShushi_startBuffID
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    pet:addBuff(binfo, pet)
    pet.petShushi_buffadded = true
  end
  local master = pet.owner
  if not pet.petShushi_firsttick then
    pet.petShushi_firsttick = ed.engine.ticks
  end
  if master.hp <= master.attribs.HP * 0.7 and not pet.petShushi_skillpasv_casted then
    local skillpasv = pet.skills.PetShushi_pasv
    if skillpasv then
      master:addBuff(skillpasv:createBuff(master), master)
      pet.petShushi_skillpasv_casted = true
    end
  end
  if not pet.petShushi_skillatk1_started and master.current_skill and master.current_skill.info.Manual then
    pet.petShushi_skillatk1_started = true
    pet:setPosition({
      master.position[1],
      master.position[2] - 45
    })
    pet.direction = master.direction
    pet:setAction("Idle")
    if ed.run_with_scene then
      local effect_name = "eff_point_Pet_born.cha"
      ed.scene:playEffectOnScene(effect_name, {
        pet.position[1],
        pet.position[2] - 1
      }, {1, 1}, nil, 1)
    end
  end
  if pet.petShushi_skillatk1_started and not pet.petShushi_skillatk1_casted then
    if not pet.petShushi_skillatk1_countdown then
      pet.petShushi_skillatk1_countdown = 0
    end
    pet.petShushi_skillatk1_countdown = pet.petShushi_skillatk1_countdown + dt
    if pet.petShushi_skillatk1_countdown > 0.2 and pet.actor then
      pet.actor.node:setVisible(true)
    end
    if pet.petShushi_skillatk1_countdown > 1.1 then
      local binfo1 = ed.lookupDataTable("Buff", nil, 4132)
      local skillatk1 = pet.skills.PetShushi_atk1
      if skillatk1 then
        local newTarget = skillatk1:selectTarget(nil)
        if newTarget then
          pet:castSkill(skillatk1, newTarget)
        end
      end
      pet.petShushi_skillatk1_casted = true
    end
  end
  if pet.actor and pet.petShushi_skillatk1_casted and (pet.action_name == "Idle" or pet.action_name == "Move") and not pet.petShushi_skillatk1_invisible then
    pet.actor.node:setVisible(false)
    pet.petShushi_skillatk1_invisible = true
    local effect_name = "eff_point_mirror_die.cha"
    ed.scene:playEffectOnScene(effect_name, {
      pet.position[1],
      pet.position[2] - 1
    }, {0.6, 0.6}, nil, 1)
  end
end

function PetShushi.hero_reset(basefunc, pet)
  basefunc(pet)
  pet.petShushi_buffadded = nil
  pet.petShushi_skillpasv_casted = nil
  pet.petShushi_firsttick = nil
  pet.petShushi_skillatk1_countdown = nil
  pet.petShushi_skillatk1_started = nil
  pet.petShushi_skillatk1_casted = nil
  pet.petShushi_skillatk1_invisible = nil
end

function PetShushi.init_hero(hero)
  local skill1 = hero.skills.PetShushi_atk1
  if skill1 then
    skill1.createProjectile = override(skill1.createProjectile, PetShushi.skill1_createProjectile)
  end
  hero.update = override(hero.update, PetShushi.hero_update)
  hero.reset = override(hero.reset, PetShushi.hero_reset)
  return hero
end

return PetShushi.init_hero
