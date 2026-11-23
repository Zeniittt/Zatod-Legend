module("ed.battlehero", package.seeall)
local ed = ed
PetRogue = {}
PetRogue.PetRogue_startBuffID = 1349

function PetRogue.atk4Projectile_hit(basefunc, projectile, target)
  if target ~= projectile.skill.target then
    return
  else
    basefunc(projectile, target)
    if not projectile.terminated then
      projectile:terminate()
    end
  end
end

function PetRogue.skillatk4_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  projectile.hit = override(projectile.hit, PetRogue.atk4Projectile_hit)
  return projectile
end

function PetRogue.hero_update(basefunc, pet, dt)
  basefunc(pet, dt)
  if not pet.petrogue_buffadded then
    local bid = PetRogue.PetRogue_startBuffID
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    pet:addBuff(binfo, pet)
    pet.petrogue_buffadded = true
  end
  local master = pet.owner
  if not pet.petrogue_firsttick then
    pet.petrogue_firsttick = ed.engine.ticks
  end
  if ed.engine.ticks - pet.petrogue_firsttick > 80 and not pet.petrogue_skillpasv_casted then
    local skillpasv = pet.skills.PetRogue_pasv
    if skillpasv then
      master:addBuff(skillpasv:createBuff(master), master)
      pet.petrogue_skillpasv_casted = true
    end
  end
  if not pet.petrogue_skillatk1_started and master.current_skill and master.current_skill.info.Manual then
    pet.petrogue_skillatk1_started = true
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
  if pet.petrogue_skillatk1_started and not pet.petrogue_skillatk1_casted then
    if not pet.petrogue_skillatk1_countdown then
      pet.petrogue_skillatk1_countdown = 0
    end
    pet.petrogue_skillatk1_countdown = pet.petrogue_skillatk1_countdown + dt
    if pet.petrogue_skillatk1_countdown > 0.3 and pet.actor then
      pet.actor.node:setVisible(true)
    end
    if pet.petrogue_skillatk1_countdown > 0.3 then
      local skillatk1 = pet.skills.PetRogue_atk1
      if skillatk1 then
        local newTarget = skillatk1:selectTarget(nil)
        if newTarget then
          local newDir = master.position[1] > newTarget.position[1] and -1 or 1
          pet.direction = newDir
          pet:castSkill(skillatk1, newTarget)
        end
      end
      pet.petrogue_skillatk1_casted = true
    end
  end
  if pet.actor and pet.petrogue_skillatk1_casted and (pet.action_name == "Idle" or pet.action_name == "Move") and not pet.petrogue_skillatk1_invisible then
    pet.actor.node:setVisible(false)
    pet.petrogue_skillatk1_invisible = true
    local effect_name = "eff_point_mirror_die.cha"
    ed.scene:playEffectOnScene(effect_name, {
      pet.position[1],
      pet.position[2] - 1
    }, {0.6, 0.6}, nil, 1)
  end
end

function PetRogue.hero_reset(basefunc, pet)
  basefunc(pet)
  pet.petrogue_buffadded = nil
  pet.petrogue_skillpasv_casted = nil
  pet.petrogue_firsttick = nil
  pet.petrogue_skillatk1_countdown = nil
  pet.petrogue_skillatk1_started = nil
  pet.petrogue_skillatk1_casted = nil
  pet.petrogue_skillatk1_invisible = nil
end

function PetRogue.init_hero(hero)
  hero.update = override(hero.update, PetRogue.hero_update)
  hero.reset = override(hero.reset, PetRogue.hero_reset)
  local skillatk1 = hero.skills.PetRogue_atk1
  if skillatk1 then
    skillatk1.createProjectile = override(skillatk1.createProjectile, PetRogue.skillatk4_createProjectile)
  end
  return hero
end

return PetRogue.init_hero
