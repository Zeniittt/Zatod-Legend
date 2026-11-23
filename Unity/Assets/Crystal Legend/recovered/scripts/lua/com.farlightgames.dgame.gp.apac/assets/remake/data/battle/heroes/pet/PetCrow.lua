module("ed.battlehero", package.seeall)
local ed = ed
PetCrow = {}
PetCrow.PetCrow_startBuffID = 1349

function PetCrow.hero_update(basefunc, pet, dt)
  basefunc(pet, dt)
  if not pet.petcrow_buffadded then
    local bid = PetCrow.PetCrow_startBuffID
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    pet:addBuff(binfo, pet)
    pet.petcrow_buffadded = true
  end
  local master = pet.owner
  if master.hp <= master.attribs.HP * 0.3 and not pet.petcrow_skillpasv_casted then
    local skillpasv = pet.skills.PetCrow_pasv
    if skillpasv then
      master:addBuff(skillpasv:createBuff(master), master)
      pet.petcrow_skillpasv_casted = true
    end
  end
  if not pet.petcrow_skillatk1_started and master.current_skill and master.current_skill.info.Manual then
    pet.petcrow_skillatk1_started = true
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
  if pet.petcrow_skillatk1_started and not pet.petcrow_skillatk1_casted then
    if not pet.petcrow_skillatk1_countdown then
      pet.petcrow_skillatk1_countdown = 0
    end
    pet.petcrow_skillatk1_countdown = pet.petcrow_skillatk1_countdown + dt
    if pet.petcrow_skillatk1_countdown >= 0.125 and pet.actor then
      pet.actor.node:setVisible(true)
    end
    if pet.petcrow_skillatk1_countdown >= 0.25 and pet.action_name ~= "atk" then
      pet:setAction("atk", false)
    end
    if pet.petcrow_skillatk1_countdown > 0.5 then
      local skillatk1 = pet.skills.PetCrow_atk1
      if skillatk1 then
        master:addBuff(skillatk1:createBuff(master), master)
      end
      pet.petcrow_skillatk1_casted = true
    end
  end
  if pet.actor and pet.petcrow_skillatk1_casted and (pet.action_name == "Idle" or pet.action_name == "Move") and not pet.petcrow_skillatk1_invisible then
    pet.actor.node:setVisible(false)
    pet.petcrow_skillatk1_invisible = true
    local effect_name = "eff_point_mirror_die.cha"
    ed.scene:playEffectOnScene(effect_name, {
      pet.position[1],
      pet.position[2] - 1
    }, {0.6, 0.6}, nil, 1)
  end
end

function PetCrow.hero_reset(basefunc, pet)
  basefunc(pet)
  pet.petcrow_buffadded = nil
  pet.petcrow_skillpasv_casted = nil
  pet.petcrow_skillatk1_started = nil
  pet.petcrow_skillatk1_countdown = nil
  pet.petcrow_skillatk1_casted = nil
  pet.petcrow_skillatk1_invisible = nil
end

function PetCrow.init_hero(hero)
  hero.update = override(hero.update, PetCrow.hero_update)
  hero.reset = override(hero.reset, PetCrow.hero_reset)
  return hero
end

return PetCrow.init_hero
