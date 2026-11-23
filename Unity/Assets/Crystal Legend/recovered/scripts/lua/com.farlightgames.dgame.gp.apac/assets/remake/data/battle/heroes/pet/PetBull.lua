module("ed.battlehero", package.seeall)
local ed = ed
PetBull = {}
PetBull.PetBull_startBuffID = 1349

function PetBull.skillatk1_takeEffectAt(basefunc, skill, location, source)
  local caster = skill.caster
  if skill.attack_counter == 1 then
    if skill.target then
      local position1 = skill.target.position[1] - caster.direction * 75
      caster:setPosition({
        position1,
        skill.target.position[2] - 1
      })
    end
  else
    basefunc(skill, location, source)
  end
end

function PetBull.hero_update(basefunc, pet, dt)
  basefunc(pet, dt)
  if not pet.petbull_buffadded then
    local bid = PetBull.PetBull_startBuffID
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    pet:addBuff(binfo, pet)
    pet.petbull_buffadded = true
  end
  local master = pet.owner
  if not pet.petbull_firsttick then
    pet.petbull_firsttick = ed.engine.ticks
  end
  if ed.engine.ticks - pet.petbull_firsttick > 80 and not pet.petbull_skillpasv_casted then
    local skillpasv = pet.skills.PetBull_pasv
    if skillpasv then
      master:addBuff(skillpasv:createBuff(master), master)
      pet.petbull_skillpasv_casted = true
    end
  end
  if not pet.petbull_skillatk1_started and master.current_skill and master.current_skill.info.Manual then
    pet.petbull_skillatk1_started = true
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
  if pet.petbull_skillatk1_started and not pet.petbull_skillatk1_casted then
    if not pet.petbull_skillatk1_countdown then
      pet.petbull_skillatk1_countdown = 0
    end
    pet.petbull_skillatk1_countdown = pet.petbull_skillatk1_countdown + dt
    if pet.petbull_skillatk1_countdown > 0.2 and pet.actor then
      pet.actor.node:setVisible(true)
    end
    if pet.petbull_skillatk1_countdown > 0.8 then
      local skillatk1 = pet.skills.PetBull_atk1
      if skillatk1 then
        local newTarget = skillatk1:selectTarget(nil)
        if newTarget then
          local newDir = master.position[1] > newTarget.position[1] and -1 or 1
          pet.direction = newDir
          pet:castSkill(skillatk1, newTarget)
        end
      end
      pet.petbull_skillatk1_casted = true
    end
  end
  if pet.actor and pet.petbull_skillatk1_casted and (pet.action_name == "Idle" or pet.action_name == "Move") and not pet.petbull_skillatk1_invisible then
    pet.actor.node:setVisible(false)
    pet.petbull_skillatk1_invisible = true
    local effect_name = "eff_point_mirror_die.cha"
    ed.scene:playEffectOnScene(effect_name, {
      pet.position[1] + pet.direction * 70,
      pet.position[2] - 1
    }, {0.6, 0.6}, nil, 1)
  end
end

function PetBull.hero_reset(basefunc, pet)
  basefunc(pet)
  pet.petbull_buffadded = nil
  pet.petbull_skillpasv_casted = nil
  pet.petbull_firsttick = nil
  pet.petbull_skillatk1_countdown = nil
  pet.petbull_skillatk1_started = nil
  pet.petbull_skillatk1_casted = nil
  pet.petbull_skillatk1_invisible = nil
end

function PetBull.init_hero(hero)
  hero.update = override(hero.update, PetBull.hero_update)
  hero.reset = override(hero.reset, PetBull.hero_reset)
  local skillatk1 = hero.skills.PetBull_atk1
  if skillatk1 then
    skillatk1.takeEffectAt = override(skillatk1.takeEffectAt, PetBull.skillatk1_takeEffectAt)
  end
  return hero
end

return PetBull.init_hero
