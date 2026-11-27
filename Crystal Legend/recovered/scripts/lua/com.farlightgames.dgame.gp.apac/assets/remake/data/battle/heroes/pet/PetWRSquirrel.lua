module("ed.battlehero", package.seeall)
local ed = ed
local PetWRSquirrel = {}
PetWRSquirrel.hidden_id = 1349
PetWRSquirrel.PetWRSquirrel_pasv_id = 6095
PetWRSquirrel.PetWRSquirrel_atk1 = 6096

function PetWRSquirrel.hero_update(basefunc, pet, dt)
  basefunc(pet, dt)
  local master = pet.owner
  if not pet.PetWRSquirrel_buffadded then
    local bid = PetWRSquirrel.hidden_id
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    pet:addBuff(binfo, pet)
    pet.PetWRSquirrel_buffadded = true
  end
  if not pet.PetWRSquirrel_firsttick then
    pet.PetWRSquirrel_firsttick = ed.engine.ticks
  end
  if ed.engine.ticks - pet.PetWRSquirrel_firsttick > 40 and not pet.PetWRSquirrel_skillpasv_casted then
    local skillpasv = pet.skills.PetWRSquirrel_pasv
    if skillpasv then
      master:addBuff(skillpasv:createBuff(master), master)
      pet.PetWRSquirrel_skillpasv_casted = true
    end
  end
  if not pet.PetWRSquirrel_skillatk1_started and master.current_skill and master.current_skill.info.Manual then
    pet.PetWRSquirrel_skillatk1_started = true
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
  if not pet.PetWRSquirrel_skillatk1_countdown then
    pet.PetWRSquirrel_skillatk1_countdown = 0
  end
  if pet.PetWRSquirrel_skillatk1_started and not pet.skill_down then
    pet.PetWRSquirrel_skillatk1_countdown = pet.PetWRSquirrel_skillatk1_countdown + dt
  end
  if pet.PetWRSquirrel_skillatk1_started and not pet.PetWRSquirrel_skillatk1_casted then
    if pet.PetWRSquirrel_skillatk1_countdown > 0.2 and pet.actor then
      pet.actor.node:setVisible(true)
    end
    if 1 < pet.PetWRSquirrel_skillatk1_countdown then
      local skillatk1 = pet.skills.PetWRSquirrel_atk1
      if skillatk1 then
        local newTarget = skillatk1:selectTarget(nil)
        if newTarget then
          pet:castSkill(skillatk1, newTarget)
          pet:setAction("atk", false)
        end
      end
      pet.PetWRSquirrel_skillatk1_casted = true
    end
  end
  if pet.position_updating and not pet.PetWRSquirrel_skillatk1_invisible then
    local position_defining = pet.target_updating.position[1]
    if 799 < position_defining or position_defining < 1 then
    end
    pet:setPosition({
      position_defining,
      pet.target_updating.position[2]
    })
  end
  if not pet.skill_down and 2 < pet.PetWRSquirrel_skillatk1_countdown and pet.actor and pet.PetWRSquirrel_skillatk1_casted and (pet.action_name == "Idle" or pet.action_name == "Move") and not pet.PetWRSquirrel_skillatk1_invisible then
    pet.actor.node:setVisible(false)
    pet.PetWRSquirrel_skillatk1_invisible = true
    local effect_name = "eff_point_mirror_die.cha"
    ed.scene:playEffectOnScene(effect_name, {
      pet.position[1],
      pet.position[2]
    }, {0.6, 0.6}, nil, 1)
    pet.skill_down = true
  end
end

function PetWRSquirrel.hero_reset(basefunc, pet)
  basefunc(pet)
  pet.PetWRSquirrel_buffadded = nil
  pet.skill_down = nil
  pet.position_updating = nil
  pet.PetWRSquirrel_skillpasv_casted = nil
  pet.PetWRSquirrel_firsttick = nil
  pet.PetWRSquirrel_skillatk1_countdown = nil
  pet.PetWRSquirrel_skillatk1_started = nil
  pet.PetWRSquirrel_skillatk1_casted = nil
  pet.PetWRSquirrel_skillatk1_invisible = nil
end

function PetWRSquirrel.init_hero(hero)
  hero.update = override(hero.update, PetWRSquirrel.hero_update)
  hero.reset = override(hero.reset, PetWRSquirrel.hero_reset)
  return hero
end

return PetWRSquirrel.init_hero
