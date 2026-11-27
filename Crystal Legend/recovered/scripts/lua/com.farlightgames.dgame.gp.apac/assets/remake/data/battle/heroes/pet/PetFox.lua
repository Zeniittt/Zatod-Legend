module("ed.battlehero", package.seeall)
local ed = ed
PetFox = {}
PetFox.PetFox_startBuffID = 1349

function PetFox.hero_update(basefunc, pet, dt)
  basefunc(pet, dt)
  if not pet.petfox_buffadded then
    local bid = PetFox.PetFox_startBuffID
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    pet:addBuff(binfo, pet)
    pet.petfox_buffadded = true
  end
  local master = pet.owner
  if master.hp <= master.attribs.HP * 0.3 and not pet.petfox_skillpasv_casted then
    local skillpasv = pet.skills.PetFox_pasv
    if skillpasv then
      master:addBuff(skillpasv:createBuff(master), master)
      pet.petfox_skillpasv_casted = true
    end
  end
  if not pet.petfox_skillatk1_started and master.current_skill and master.current_skill.info.Manual then
    pet.petfox_skillatk1_started = true
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
  if pet.petfox_skillatk1_started and not pet.petfox_skillatk1_casted then
    if not pet.petfox_skillatk1_countdown then
      pet.petfox_skillatk1_countdown = 0
    end
    pet.petfox_skillatk1_countdown = pet.petfox_skillatk1_countdown + dt
    if pet.petfox_skillatk1_countdown > 0.2 and pet.actor then
      pet.actor.node:setVisible(true)
    end
    if pet.petfox_skillatk1_countdown > 0.5 then
      local skillatk1 = pet.skills.PetFox_atk1
      if skillatk1 then
        master:addBuff(skillatk1:createBuff(master), master)
        pet:setAction("atk", false)
        if ed.run_with_scene then
          local effect_name = "eff_buff_Fox_atk1.cha"
          ed.scene:playEffectOnScene(effect_name, {
            master.position[1],
            master.position[2] - 1
          }, {1, 1}, nil, 1)
        end
      end
      pet.petfox_skillatk1_casted = true
    end
  end
  if pet.actor and pet.petfox_skillatk1_casted and (pet.action_name == "Idle" or pet.action_name == "Move") and not pet.petfox_skillatk1_invisible then
    pet.actor.node:setVisible(false)
    pet.petfox_skillatk1_invisible = true
    local effect_name = "eff_point_mirror_die.cha"
    ed.scene:playEffectOnScene(effect_name, {
      pet.position[1],
      pet.position[2] - 1
    }, {0.6, 0.6}, nil, 1)
  end
end

function PetFox.hero_reset(basefunc, pet)
  basefunc(pet)
  pet.petfox_buffadded = nil
  pet.petfox_skillpasv_casted = nil
  pet.petfox_skillatk1_started = nil
  pet.petfox_skillatk1_countdown = nil
  pet.petfox_skillatk1_casted = nil
  pet.petfox_skillatk1_invisible = nil
end

function PetFox.init_hero(hero)
  hero.update = override(hero.update, PetFox.hero_update)
  hero.reset = override(hero.reset, PetFox.hero_reset)
  return hero
end

return PetFox.init_hero
