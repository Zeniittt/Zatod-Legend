module("ed.battlehero", package.seeall)
local ed = ed
PetNalunlun = {}
PetNalunlun.PetNalunlun_startBuffID = 1349

function PetNalunlun.hero_update(basefunc, pet, dt)
  basefunc(pet, dt)
  if not pet.petNalunlun_buffadded then
    local bid = PetNalunlun.PetNalunlun_startBuffID
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    pet:addBuff(binfo, pet)
    pet.petNalunlun_buffadded = true
  end
  local master = pet.owner
  if not pet.petNalunlun_firsttick then
    pet.petNalunlun_firsttick = ed.engine.ticks
  end
  if ed.engine.ticks - pet.petNalunlun_firsttick > 40 and not pet.petNalunlun_skillpasv_casted then
    local skillpasv = pet.skills.PetNalunlun_pasv
    if skillpasv then
      master:addBuff(skillpasv:createBuff(master), master)
      pet.petNalunlun_skillpasv_casted = true
    end
  end
  if not pet.petNalunlun_skillatk1_started and master.current_skill and master.current_skill.info.Manual then
    pet.petNalunlun_skillatk1_started = true
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
  if pet.petNalunlun_skillatk1_started and not pet.petNalunlun_skillatk1_casted then
    if not pet.petNalunlun_skillatk1_countdown then
      pet.petNalunlun_skillatk1_countdown = 0
    end
    pet.petNalunlun_skillatk1_countdown = pet.petNalunlun_skillatk1_countdown + dt
    if pet.petNalunlun_skillatk1_countdown > 0.2 and pet.actor then
      pet.actor.node:setVisible(true)
    end
    if pet.petNalunlun_skillatk1_countdown > 1.1 then
      local binfo1 = ed.lookupDataTable("Buff", nil, 4132)
      local skillatk1 = pet.skills.PetNalunlun_atk1
      if skillatk1 then
        local newTarget = skillatk1:selectTarget(nil)
        if newTarget then
          pet:castSkill(skillatk1, newTarget)
        end
      end
      pet.petNalunlun_skillatk1_casted = true
    end
  end
  if pet.actor and pet.petNalunlun_skillatk1_casted and (pet.action_name == "Idle" or pet.action_name == "Move") and not pet.petNalunlun_skillatk1_invisible then
    pet.actor.node:setVisible(false)
    pet.petNalunlun_skillatk1_invisible = true
    local effect_name = "eff_point_mirror_die.cha"
    ed.scene:playEffectOnScene(effect_name, {
      pet.position[1],
      pet.position[2] - 1
    }, {0.6, 0.6}, nil, 1)
  end
end

function PetNalunlun.hero_reset(basefunc, pet)
  basefunc(pet)
  pet.petNalunlun_buffadded = nil
  pet.petNalunlun_skillpasv_casted = nil
  pet.petNalunlun_firsttick = nil
  pet.petNalunlun_skillatk1_countdown = nil
  pet.petNalunlun_skillatk1_started = nil
  pet.petNalunlun_skillatk1_casted = nil
  pet.petNalunlun_skillatk1_invisible = nil
end

function PetNalunlun.init_hero(hero)
  hero.update = override(hero.update, PetNalunlun.hero_update)
  hero.reset = override(hero.reset, PetNalunlun.hero_reset)
  return hero
end

return PetNalunlun.init_hero
