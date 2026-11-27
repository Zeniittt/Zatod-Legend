module("ed.battlehero", package.seeall)
local ed = ed
PetMagic = {}
PetMagic.PetMagic_startBuffID = 1349

function PetMagic.hero_update(basefunc, pet, dt)
  basefunc(pet, dt)
  if not pet.petmagic_buffadded then
    local bid = PetMagic.PetMagic_startBuffID
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    pet:addBuff(binfo, pet)
    pet.petmagic_buffadded = true
  end
  local master = pet.owner
  if not pet.petmagic_firsttick then
    pet.petmagic_firsttick = ed.engine.ticks
  end
  if ed.engine.ticks - pet.petmagic_firsttick > 80 and not pet.petmagic_skillpasv_casted then
    local skillpasv = pet.skills.PetMagic_pasv
    if skillpasv then
      master:addBuff(skillpasv:createBuff(master), master)
      pet.petmagic_skillpasv_casted = true
    end
  end
  if not pet.petmagic_skillatk1_started and master.current_skill and master.current_skill.info.Manual then
    pet.petmagic_skillatk1_started = true
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
  if pet.petmagic_skillatk1_started and not pet.petmagic_skillatk1_casted then
    if not pet.petmagic_skillatk1_countdown then
      pet.petmagic_skillatk1_countdown = 0
    end
    pet.petmagic_skillatk1_countdown = pet.petmagic_skillatk1_countdown + dt
    if pet.petmagic_skillatk1_countdown > 0.2 and pet.actor then
      pet.actor.node:setVisible(true)
    end
    if pet.petmagic_skillatk1_countdown > 0.8 then
      local skillatk1 = pet.skills.PetMagic_atk1
      if skillatk1 then
        local newTarget = skillatk1:selectTarget(nil)
        if newTarget then
          local newDir = master.position[1] > newTarget.position[1] and -1 or 1
          pet.direction = newDir
          pet:castSkill(skillatk1, newTarget)
        end
      end
      pet.petmagic_skillatk1_casted = true
    end
  end
  if pet.actor and pet.petmagic_skillatk1_casted and (pet.action_name == "Idle" or pet.action_name == "Move") and not pet.petmagic_skillatk1_invisible then
    pet.actor.node:setVisible(false)
    pet.petmagic_skillatk1_invisible = true
    local effect_name = "eff_point_mirror_die.cha"
    ed.scene:playEffectOnScene(effect_name, {
      pet.position[1],
      pet.position[2] - 1
    }, {0.6, 0.6}, nil, 1)
  end
end

function PetMagic.hero_reset(basefunc, pet)
  basefunc(pet)
  pet.petmagic_buffadded = nil
  pet.petmagic_firsttick = nil
  pet.petmagic_skillpasv_casted = nil
  pet.petmagic_skillatk1_started = nil
  pet.petmagic_skillatk1_countdown = nil
  pet.petmagic_skillatk1_casted = nil
  pet.petmagic_skillatk1_invisible = nil
end

function PetMagic.init_hero(hero)
  hero.update = override(hero.update, PetMagic.hero_update)
  hero.reset = override(hero.reset, PetMagic.hero_reset)
  return hero
end

return PetMagic.init_hero
