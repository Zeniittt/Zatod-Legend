module("ed.battlehero", package.seeall)
local ed = ed
PetMT = {}
PetMT.PetMT_startBuffID = 1349
PetMT.offset_list = {
  {0, 0},
  {-19, 5},
  {5, -14},
  {-36, 28},
  {39, -50}
}

function PetMT.hero_update(basefunc, pet, dt)
  basefunc(pet, dt)
  if not pet.PetMT_buffadded then
    local bid = PetMT.PetMT_startBuffID
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    pet:addBuff(binfo, pet)
    pet.PetMT_buffadded = true
  end
  local master = pet.owner
  if not pet.PetMT_firsttick then
    pet.PetMT_firsttick = ed.engine.ticks
  end
  if ed.engine.ticks - pet.PetMT_firsttick > 40 and not pet.PetMT_skillpasv_casted then
    local skillpasv = pet.skills.PetMT_pasv
    if skillpasv then
      master:addBuff(skillpasv:createBuff(master), master)
      pet.PetMT_skillpasv_casted = true
    end
  end
  if not pet.PetMT_skillatk1_started and master.current_skill and master.current_skill.info.Manual then
    pet.PetMT_skillatk1_started = true
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
  if pet.PetMT_skillatk1_started and not pet.PetMT_skillatk1_casted then
    if not pet.PetMT_skillatk1_countdown then
      pet.PetMT_skillatk1_countdown = 0
    end
    pet.PetMT_skillatk1_countdown = pet.PetMT_skillatk1_countdown + dt
    if pet.PetMT_skillatk1_countdown > 1.5 then
      pet:setPosition({
        master.position[1],
        master.position[2] - 45
      })
      if pet.actor then
        pet.actor.node:setVisible(true)
      end
    end
    if pet.PetMT_skillatk1_countdown > 1.5 then
      local skillatk1 = pet.skills.PetMT_atk1
      if skillatk1 then
        local newTarget = skillatk1:selectTarget(nil)
        if newTarget then
          pet:castSkill(skillatk1, newTarget)
        end
      end
      pet.PetMT_skillatk1_casted = true
    end
  end
  if pet.actor and pet.PetMT_skillatk1_casted and (pet.action_name == "Idle" or pet.action_name == "Move") and not pet.PetMT_skillatk1_invisible then
    pet.actor.node:setVisible(false)
    pet.PetMT_skillatk1_invisible = true
    local effect_name = "eff_point_mirror_die.cha"
    ed.scene:playEffectOnScene(effect_name, {
      pet.position[1],
      pet.position[2] - 1
    }, {0.6, 0.6}, nil, 1)
  end
end

function PetMT.hero_reset(basefunc, pet)
  basefunc(pet)
  pet.PetMT_buffadded = nil
  pet.PetMT_skillpasv_casted = nil
  pet.PetMT_firsttick = nil
  pet.PetMT_skillatk1_countdown = nil
  pet.PetMT_skillatk1_started = nil
  pet.PetMT_skillatk1_casted = nil
  pet.PetMT_skillatk1_invisible = nil
end

function PetMT.init_hero(hero)
  hero.update = override(hero.update, PetMT.hero_update)
  hero.reset = override(hero.reset, PetMT.hero_reset)
  return hero
end

return PetMT.init_hero
