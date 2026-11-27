module("ed.battlehero", package.seeall)
local ed = ed
PetTigerlucky = {}
PetTigerlucky.PetTigerlucky_startBuffID = 1349

function PetTigerlucky.hero_update(basefunc, pet, dt)
  basefunc(pet, dt)
  if not pet.PetTigerlucky_buffadded then
    local bid = PetTigerlucky.PetTigerlucky_startBuffID
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    pet:addBuff(binfo, pet)
    pet.PetTigerlucky_buffadded = true
  end
  local master = pet.owner
  local skillpasv = pet.skills.PetTigerlucky_pasv
  if not pet.PetTigerlucky_firsttick then
    pet.PetTigerlucky_firsttick = ed.engine.ticks
  end
  if ed.engine.ticks - pet.PetTigerlucky_firsttick > 40 and not pet.PetTigerlucky_skillpasv_casted and skillpasv then
    local newTarget0 = skillpasv:selectTarget(nil)
    if newTarget0 then
      pet:castSkill(skillpasv, newTarget0)
    end
    pet.PetTigerlucky_skillpasv_casted = true
  end
  if not pet.PetTigerlucky_skillatk1_started and master.current_skill and master.current_skill.info.Manual then
    pet.PetTigerlucky_skillatk1_started = true
    pet:setPosition({
      master.position[1] - 20,
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
  if pet.PetTigerlucky_skillatk1_started and not pet.PetTigerlucky_skillatk1_casted then
    if not pet.PetTigerlucky_skillatk1_countdown then
      pet.PetTigerlucky_skillatk1_countdown = 0
    end
    pet.PetTigerlucky_skillatk1_countdown = pet.PetTigerlucky_skillatk1_countdown + dt
    if pet.PetTigerlucky_skillatk1_countdown > 0.2 and pet.actor then
      pet.actor.node:setVisible(true)
    end
    if pet.PetTigerlucky_skillatk1_countdown > 1.5 then
      local skillatk1 = pet.skills.PetTigerlucky_atk1
      if skillatk1 then
        local newTarget = skillatk1:selectTarget(nil)
        if newTarget then
          pet:castSkill(skillatk1, newTarget)
        end
      end
      pet.PetTigerlucky_skillatk1_casted = true
    end
  end
  if pet.actor and pet.PetTigerlucky_skillatk1_casted and (pet.action_name == "Idle" or pet.action_name == "Move") and not pet.PetTigerlucky_skillatk1_invisible then
    pet.actor.node:setVisible(false)
    pet.PetTigerlucky_skillatk1_invisible = true
    local effect_name = "eff_point_mirror_die.cha"
    ed.scene:playEffectOnScene(effect_name, {
      pet.position[1],
      pet.position[2] - 1
    }, {0.6, 0.6}, nil, 1)
  end
end

function PetTigerlucky.atk1_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local pet = skill.caster
  local effect_Tigerlucky = "eff_point_Tigerlucky_atk1.cha"
  if ed.run_with_scene then
    ed.scene:playEffectOnScene(effect_Tigerlucky, {
      pet.position[1],
      pet.position[2] - 1
    }, {1, 1}, nil, 1)
  end
end

function PetTigerlucky.hero_reset(basefunc, pet)
  basefunc(pet)
  pet.PetTigerlucky_buffadded = nil
  pet.PetTigerlucky_skillpasv_casted = nil
  pet.PetTigerlucky_firsttick = nil
  pet.PetTigerlucky_skillatk1_countdown = nil
  pet.PetTigerlucky_skillatk1_started = nil
  pet.PetTigerlucky_skillatk1_casted = nil
  pet.PetTigerlucky_skillatk1_invisible = nil
end

function PetTigerlucky.init_hero(hero)
  local atk1 = hero.skills.PetTigerlucky_atk1
  if atk1 then
    atk1.onAttackFrame = override(atk1.onAttackFrame, PetTigerlucky.atk1_onAttackFrame)
  end
  hero.update = override(hero.update, PetTigerlucky.hero_update)
  hero.reset = override(hero.reset, PetTigerlucky.hero_reset)
  return hero
end

return PetTigerlucky.init_hero
