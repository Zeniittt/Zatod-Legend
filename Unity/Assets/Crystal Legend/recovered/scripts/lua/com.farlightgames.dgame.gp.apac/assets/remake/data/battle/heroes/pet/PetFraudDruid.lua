module("ed.battlehero", package.seeall)
local ed = ed
PetFraudDruid = {}
PetFraudDruid.PetFraudDruid_startBuffID = 1349

function PetFraudDruid.hero_update(basefunc, pet, dt)
  basefunc(pet, dt)
  if not pet.petFraudDruid_buffadded then
    local bid = PetFraudDruid.PetFraudDruid_startBuffID
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    pet:addBuff(binfo, pet)
    pet.petFraudDruid_buffadded = true
  end
  local master = pet.owner
  if not pet.PetFraudDruid_firsttick then
    pet.PetFraudDruid_firsttick = ed.engine.ticks
  end
  if ed.engine.ticks - pet.PetFraudDruid_firsttick > 40 and not pet.petFraudDruid_skillpasv_casted then
    local skillpasv = pet.skills.PetFraudDruid_pasv
    if skillpasv then
      master:setMP(master.mp + 150)
      master:addBuff(skillpasv:createBuff(master), master)
      pet.petFraudDruid_skillpasv_casted = true
    end
  end
  if not pet.petFraudDruid_skillatk1_started and master.current_skill and master.current_skill.info.Manual then
    pet.petFraudDruid_skillatk1_started = true
    pet:setPosition({
      master.position[1] - master.direction * 40,
      master.position[2] - 15
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
  if pet.petFraudDruid_skillatk1_started and not pet.petFraudDruid_skillatk1_casted then
    if not pet.petFraudDruid_skillatk1_countdown then
      pet.petFraudDruid_skillatk1_countdown = 0
    end
    pet.petFraudDruid_skillatk1_countdown = pet.petFraudDruid_skillatk1_countdown + dt
    if pet.petFraudDruid_skillatk1_countdown > 0.2 and pet.actor then
      pet.actor.node:setVisible(true)
    end
    if pet.petFraudDruid_skillatk1_countdown > 0.5 then
      local skillatk1 = pet.skills.PetFraudDruid_atk1
      local skillatk2 = pet.skills.PetFraudDruid_atk1a
      local skillatk3 = pet.skills.PetFraudDruid_atk1b
      if master.hp >= master.attribs.HP * 0.6 then
        if skillatk3 then
          master:addBuff(skillatk3:createBuff(master), master)
          pet:setAction("atk1", false)
        end
      elseif master.hp < master.attribs.HP * 0.6 and master.hp >= master.attribs.HP * 0.3 then
        if skillatk2 then
          local newTarget2 = skillatk2:selectTarget(nil)
          if newTarget2 then
            pet:castSkill(skillatk2, newTarget2)
          end
        end
      elseif skillatk1 then
        pet:castSkill(skillatk1, master)
      end
      pet.petFraudDruid_skillatk1_casted = true
    end
  end
  if pet.actor and pet.petFraudDruid_skillatk1_casted and (pet.action_name == "Idle" or pet.action_name == "Move") and not pet.petFraudDruid_skillatk1_invisible then
    pet.actor.node:setVisible(false)
    pet.petFraudDruid_skillatk1_invisible = true
    local effect_name = "eff_point_mirror_die.cha"
    ed.scene:playEffectOnScene(effect_name, {
      pet.position[1],
      pet.position[2] - 1
    }, {0.6, 0.6}, nil, 1)
  end
end

function PetFraudDruid.hero_reset(basefunc, pet)
  basefunc(pet)
  pet.petFraudDruid_buffadded = nil
  pet.petFraudDruid_skillpasv_casted = nil
  pet.petFraudDruid_skillatk1_started = nil
  pet.petFraudDruid_skillatk1_countdown = nil
  pet.petFraudDruid_skillatk1_casted = nil
  pet.petFraudDruid_skillatk1_invisible = nil
end

function PetFraudDruid.init_hero(hero)
  hero.update = override(hero.update, PetFraudDruid.hero_update)
  hero.reset = override(hero.reset, PetFraudDruid.hero_reset)
  return hero
end

return PetFraudDruid.init_hero
