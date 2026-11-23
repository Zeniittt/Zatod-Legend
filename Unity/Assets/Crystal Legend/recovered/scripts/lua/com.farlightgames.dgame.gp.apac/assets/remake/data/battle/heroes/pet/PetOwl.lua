module("ed.battlehero", package.seeall)
local ed = ed
PetOwl = {}
PetOwl.PetOwl_startBuffID = 1349

function PetOwl.hero_update(basefunc, pet, dt)
  basefunc(pet, dt)
  if not pet.petowl_buffadded then
    local bid = PetOwl.PetOwl_startBuffID
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    pet:addBuff(binfo, pet)
    pet.petowl_buffadded = true
  end
  local master = pet.owner
  if not pet.petowl_firsttick then
    pet.petowl_firsttick = ed.engine.ticks
  end
  if ed.engine.ticks - pet.petowl_firsttick > 80 and not pet.petowl_skillpasv_casted then
    local skillpasv = pet.skills.PetOwl_pasv
    if skillpasv then
      master:addBuff(skillpasv:createBuff(master), master)
      pet.petowl_skillpasv_casted = true
    end
  end
  if not pet.petowl_skillatk1_started and master.current_skill and master.current_skill.info.Manual then
    pet.petowl_skillatk1_started = true
    pet:setPosition({
      master.position[1] - master.direction * 30,
      master.position[2] + 20
    })
    pet.direction = master.direction
    pet:setAction("Idle2")
    if ed.run_with_scene then
      local effect_name = "eff_point_Pet_born.cha"
      ed.scene:playEffectOnScene(effect_name, {
        pet.position[1],
        pet.position[2] - 1
      }, {1, 1}, nil, 1)
    end
  end
  if pet.petowl_skillatk1_started and not pet.petowl_skillatk1_casted then
    if not pet.petowl_skillatk1_countdown then
      pet.petowl_skillatk1_countdown = 0
    end
    pet.petowl_skillatk1_countdown = pet.petowl_skillatk1_countdown + dt
    if pet.petowl_skillatk1_countdown > 0.2 and pet.actor then
      pet.actor.node:setVisible(true)
    end
    if pet.petowl_skillatk1_countdown > 0.8 then
      local skillatk1 = pet.skills.PetOwl_atk1
      if skillatk1 then
        local newTarget = skillatk1:selectTarget(nil)
        if newTarget then
          local newDir = master.position[1] > newTarget.position[1] and -1 or 1
          pet.direction = newDir
          pet:castSkill(skillatk1, newTarget)
        end
      end
      pet.petowl_skillatk1_casted = true
    end
  end
  if pet.actor and pet.petowl_skillatk1_casted and (pet.action_name == "Idle" or pet.action_name == "Move") and not pet.petowl_skillatk1_invisible then
    pet.actor.node:setVisible(false)
    pet.petowl_skillatk1_invisible = true
    local effect_name = "eff_point_mirror_die.cha"
    ed.scene:playEffectOnScene(effect_name, {
      pet.position[1],
      pet.position[2] + 80
    }, {0.6, 0.6}, nil, 1)
  end
end

function PetOwl.hero_reset(basefunc, pet)
  basefunc(pet)
  pet.petowl_buffadded = nil
  pet.petowl_skillpasv_casted = nil
  pet.petowl_firsttick = nil
  pet.petowl_skillatk1_countdown = nil
  pet.petowl_skillatk1_started = nil
  pet.petowl_skillatk1_casted = nil
  pet.petowl_skillatk1_invisible = nil
end

function PetOwl.init_hero(hero)
  hero.update = override(hero.update, PetOwl.hero_update)
  hero.reset = override(hero.reset, PetOwl.hero_reset)
  return hero
end

return PetOwl.init_hero
