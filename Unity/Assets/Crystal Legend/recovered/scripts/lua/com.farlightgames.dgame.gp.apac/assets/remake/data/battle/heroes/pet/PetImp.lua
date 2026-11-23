module("ed.battlehero", package.seeall)
local ed = ed
PetImp = {}
PetImp.PetImp_startBuffID = 1349

function PetImp.hero_update(basefunc, pet, dt)
  basefunc(pet, dt)
  if not pet.petImp_buffadded then
    local bid = PetImp.PetImp_startBuffID
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    pet:addBuff(binfo, pet)
    pet.petImp_buffadded = true
  end
  local master = pet.owner
  if not pet.petImp_firsttick then
    pet.petImp_firsttick = ed.engine.ticks
  end
  if ed.engine.ticks - pet.petImp_firsttick > 120 and not pet.petImp_skillpasv_casted then
    local skillpasv = pet.skills.PetImp_pasv
    if skillpasv then
      master:addBuff(skillpasv:createBuff(master), master)
      pet.petImp_skillpasv_casted = true
    end
  end
  if not pet.petImp_skillatk1_started and master.current_skill and master.current_skill.info.Manual then
    pet.petImp_skillatk1_started = true
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
  if pet.petImp_skillatk1_started and not pet.petImp_skillatk1_casted then
    if not pet.petImp_skillatk1_countdown then
      pet.petImp_skillatk1_countdown = 0
    end
    pet.petImp_skillatk1_countdown = pet.petImp_skillatk1_countdown + dt
    if pet.petImp_skillatk1_countdown > 0.2 and pet.actor then
      pet.actor.node:setVisible(true)
    end
    if pet.petImp_skillatk1_countdown > 1.1 then
      local binfo1 = ed.lookupDataTable("Buff", nil, 4132)
      local skillatk1 = pet.skills.PetImp_atk1
      if skillatk1 then
        local newTarget = skillatk1:selectTarget(nil)
        if newTarget then
          newTarget:addBuff(skillatk1:createBuff(newTarget), master)
          pet:setAction("atk", false)
        end
      end
      pet.petImp_skillatk1_casted = true
    end
  end
  if pet.actor and pet.petImp_skillatk1_casted and (pet.action_name == "Idle" or pet.action_name == "Move") and not pet.petImp_skillatk1_invisible then
    pet.actor.node:setVisible(false)
    pet.petImp_skillatk1_invisible = true
    local effect_name = "eff_point_mirror_die.cha"
    ed.scene:playEffectOnScene(effect_name, {
      pet.position[1],
      pet.position[2] - 1
    }, {0.6, 0.6}, nil, 1)
  end
end

function PetImp.hero_reset(basefunc, pet)
  basefunc(pet)
  pet.petImp_buffadded = nil
  pet.petImp_skillpasv_casted = nil
  pet.petImp_firsttick = nil
  pet.petImp_skillatk1_countdown = nil
  pet.petImp_skillatk1_started = nil
  pet.petImp_skillatk1_casted = nil
  pet.petImp_skillatk1_invisible = nil
end

function PetImp.init_hero(hero)
  hero.update = override(hero.update, PetImp.hero_update)
  hero.reset = override(hero.reset, PetImp.hero_reset)
  return hero
end

return PetImp.init_hero
