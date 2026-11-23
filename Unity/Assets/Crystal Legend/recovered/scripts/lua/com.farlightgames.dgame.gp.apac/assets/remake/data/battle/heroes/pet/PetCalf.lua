module("ed.battlehero", package.seeall)
local ed = ed
PetCalf = {}
PetCalf.PetCalf_startBuffID = 1349

function PetCalf.hero_update(basefunc, pet, dt)
  basefunc(pet, dt)
  if not pet.petcalf_buffadded then
    local bid = PetCalf.PetCalf_startBuffID
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    pet:addBuff(binfo, pet)
    pet.petcalf_buffadded = true
  end
  local master = pet.owner
  if master.hp <= master.attribs.HP * 0.3 and not pet.petcalf_skillpasv_casted then
    local skillpasv = pet.skills.PetCalf_pasv
    if skillpasv then
      skillpasv:takeEffectOn(master, master)
      pet.petcalf_skillpasv_casted = true
    end
  end
  if not pet.petcalf_skillatk1_started and master.current_skill and master.current_skill.info.Manual then
    pet.petcalf_skillatk1_started = true
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
  if pet.petcalf_skillatk1_started and not pet.petcalf_skillatk1_casted then
    if not pet.petcalf_skillatk1_countdown then
      pet.petcalf_skillatk1_countdown = 0
    end
    pet.petcalf_skillatk1_countdown = pet.petcalf_skillatk1_countdown + dt
    if pet.petcalf_skillatk1_countdown > 0.2 and pet.actor then
      pet.actor.node:setVisible(true)
    end
    if pet.petcalf_skillatk1_countdown > 0.5 then
      local skillatk1 = pet.skills.PetCalf_atk1
      if skillatk1 then
        master:addBuff(skillatk1:createBuff(master), master)
        pet:setAction("atk", false)
      end
      pet.petcalf_skillatk1_casted = true
    end
  end
  if pet.actor and pet.petcalf_skillatk1_casted and (pet.action_name == "Idle" or pet.action_name == "Move") and not pet.petcalf_skillatk1_invisible then
    pet.actor.node:setVisible(false)
    pet.petcalf_skillatk1_invisible = true
    local effect_name = "eff_point_mirror_die.cha"
    ed.scene:playEffectOnScene(effect_name, {
      pet.position[1],
      pet.position[2] - 1
    }, {0.6, 0.6}, nil, 1)
  end
end

function PetCalf.hero_reset(basefunc, pet)
  basefunc(pet)
  pet.petcalf_buffadded = nil
  pet.petcalf_skillpasv_casted = nil
  pet.petcalf_skillatk1_started = nil
  pet.petcalf_skillatk1_countdown = nil
  pet.petcalf_skillatk1_casted = nil
  pet.petcalf_skillatk1_invisible = nil
end

function PetCalf.init_hero(hero)
  hero.update = override(hero.update, PetCalf.hero_update)
  hero.reset = override(hero.reset, PetCalf.hero_reset)
  return hero
end

return PetCalf.init_hero
