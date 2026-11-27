module("ed.battlehero", package.seeall)
local ed = ed
PetLadyPlus = {}
PetLadyPlus.PetLadyPlus_startBuffID = 1349

function PetLadyPlus.hero_update(basefunc, pet, dt)
  basefunc(pet, dt)
  if not pet.PetLadyPlus_buffadded then
    local bid = PetLadyPlus.PetLadyPlus_startBuffID
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    pet:addBuff(binfo, pet)
    pet.PetLadyPlus_buffadded = true
  end
  local master = pet.owner
  if not pet.PetLadyPlus_firsttick then
    pet.PetLadyPlus_firsttick = ed.engine.ticks
  end
  if ed.engine.ticks - pet.PetLadyPlus_firsttick > 80 and not pet.PetLadyPlus_skillpasv_casted then
    local skillpasv = pet.skills.PetLadyPlus_pasv
    if skillpasv then
      master:addBuff(skillpasv:createBuff(master), master)
      pet.PetLadyPlus_skillpasv_casted = true
    end
  end
  if not pet.PetLadyPlus_skillatk1_started and master.current_skill and master.current_skill.info.Manual then
    pet.PetLadyPlus_skillatk1_started = true
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
  if pet.PetLadyPlus_skillatk1_started and not pet.PetLadyPlus_skillatk1_casted then
    if not pet.PetLadyPlus_skillatk1_countdown then
      pet.PetLadyPlus_skillatk1_countdown = 0
    end
    pet.PetLadyPlus_skillatk1_countdown = pet.PetLadyPlus_skillatk1_countdown + dt
    if pet.PetLadyPlus_skillatk1_countdown > 0.2 and pet.actor then
      pet.actor.node:setVisible(true)
    end
    if pet.PetLadyPlus_skillatk1_countdown > 0.8 then
      local skillatk1 = pet.skills.PetLadyPlus_atk1
      if skillatk1 then
        local newTarget = skillatk1:selectTarget(nil)
        if newTarget then
          pet:castSkill(skillatk1, newTarget)
        end
      end
      pet.PetLadyPlus_skillatk1_casted = true
    end
  end
  if pet.actor and pet.PetLadyPlus_skillatk1_casted and (pet.action_name == "Idle" or pet.action_name == "Move") and not pet.PetLadyPlus_skillatk1_invisible then
    pet.actor.node:setVisible(false)
    pet.PetLadyPlus_skillatk1_invisible = true
    local effect_name = "eff_point_mirror_die.cha"
    ed.scene:playEffectOnScene(effect_name, {
      pet.position[1],
      pet.position[2] - 1
    }, {0.6, 0.6}, nil, 1)
  end
end

function PetLadyPlus.hero_reset(basefunc, pet)
  basefunc(pet)
  pet.PetLadyPlus_buffadded = nil
  pet.PetLadyPlus_skillpasv_casted = nil
  pet.PetLadyPlus_firsttick = nil
  pet.PetLadyPlus_skillatk1_countdown = nil
  pet.PetLadyPlus_skillatk1_started = nil
  pet.PetLadyPlus_skillatk1_casted = nil
  pet.PetLadyPlus_skillatk1_invisible = nil
end

function PetLadyPlus.init_hero(hero)
  hero.update = override(hero.update, PetLadyPlus.hero_update)
  hero.reset = override(hero.reset, PetLadyPlus.hero_reset)
  return hero
end

return PetLadyPlus.init_hero
