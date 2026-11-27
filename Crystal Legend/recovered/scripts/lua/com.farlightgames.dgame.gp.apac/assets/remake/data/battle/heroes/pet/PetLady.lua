module("ed.battlehero", package.seeall)
local ed = ed
PetLady = {}
PetLady.PetLady_startBuffID = 1349

function PetLady.hero_update(basefunc, pet, dt)
  basefunc(pet, dt)
  if not pet.PetLady_buffadded then
    local bid = PetLady.PetLady_startBuffID
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    pet:addBuff(binfo, pet)
    pet.PetLady_buffadded = true
  end
  local master = pet.owner
  if not pet.PetLady_firsttick then
    pet.PetLady_firsttick = ed.engine.ticks
  end
  if ed.engine.ticks - pet.PetLady_firsttick > 40 and not pet.PetLady_skillpasv_casted then
    local skillpasv = pet.skills.PetLady_pasv
    if skillpasv then
      master:addBuff(skillpasv:createBuff(master), master)
      pet.PetLady_skillpasv_casted = true
    end
  end
  if not pet.PetLady_skillatk1_started and master.current_skill and master.current_skill.info.Manual then
    pet.PetLady_skillatk1_started = true
    pet:setPosition({
      master.position[1] - 45,
      master.position[2]
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
  if pet.PetLady_skillatk1_started and not pet.PetLady_skillatk1_casted then
    if not pet.PetLady_skillatk1_countdown then
      pet.PetLady_skillatk1_countdown = 0
    end
    pet.PetLady_skillatk1_countdown = pet.PetLady_skillatk1_countdown + dt
    if pet.PetLady_skillatk1_countdown > 0.2 and pet.actor then
      pet.actor.node:setVisible(true)
    end
    if pet.PetLady_skillatk1_countdown > 0.8 then
      local skillatk1 = pet.skills.PetLady_atk1
      if skillatk1 then
        pet:castSkill(skillatk1, master)
      end
      pet.PetLady_skillatk1_casted = true
    end
  end
  if pet.actor and pet.PetLady_skillatk1_casted and (pet.action_name == "Idle" or pet.action_name == "Move") and not pet.PetLady_skillatk1_invisible then
    pet.actor.node:setVisible(false)
    pet.PetLady_skillatk1_invisible = true
    local effect_name = "eff_point_mirror_die.cha"
    ed.scene:playEffectOnScene(effect_name, {
      pet.position[1],
      pet.position[2] - 1
    }, {0.6, 0.6}, nil, 1)
  end
end

function PetLady.hero_reset(basefunc, pet)
  basefunc(pet)
  pet.PetLady_buffadded = nil
  pet.PetLady_skillpasv_casted = nil
  pet.PetLady_firsttick = nil
  pet.PetLady_skillatk1_countdown = nil
  pet.PetLady_skillatk1_started = nil
  pet.PetLady_skillatk1_casted = nil
  pet.PetLady_skillatk1_invisible = nil
end

function PetLady.init_hero(hero)
  hero.update = override(hero.update, PetLady.hero_update)
  hero.reset = override(hero.reset, PetLady.hero_reset)
  local skillatk1 = hero.skills.PetLady_atk1
  return hero
end

return PetLady.init_hero
