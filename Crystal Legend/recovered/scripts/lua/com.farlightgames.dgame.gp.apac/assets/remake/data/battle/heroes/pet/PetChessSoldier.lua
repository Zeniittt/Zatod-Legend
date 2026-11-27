module("ed.battlehero", package.seeall)
local ed = ed
PetChessSoldier = {}
PetChessSoldier.PetChessSoldier_startBuffID = 1349

function PetChessSoldier.atk1_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local pet = skill.caster
  if pet.actor and pet.PetChessSoldier_skillatk1_casted then
    pet.actor.node:setVisible(false)
    pet.PetChessSoldier_skillatk1_invisible = true
  end
end

function PetChessSoldier.hero_update(basefunc, pet, dt)
  basefunc(pet, dt)
  if not pet.PetChessSoldier_buffadded then
    local bid = PetChessSoldier.PetChessSoldier_startBuffID
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    pet:addBuff(binfo, pet)
    pet.PetChessSoldier_buffadded = true
  end
  local master = pet.owner
  if not pet.petChessSoldier_firsttick then
    pet.petChessSoldier_firsttick = ed.engine.ticks
  end
  if ed.engine.ticks - pet.petChessSoldier_firsttick > 80 and not pet.PetChessSoldier_skillpasv_casted then
    local skillpasv = pet.skills.PetChessSoldier_pasv
    if skillpasv then
      master:addBuff(skillpasv:createBuff(master), master)
      pet.PetChessSoldier_skillpasv_casted = true
    end
  end
  if not pet.PetChessSoldier_skillatk1_started and master.current_skill and master.current_skill.info.Manual then
    pet.PetChessSoldier_skillatk1_started = true
    pet:setPosition({
      master.position[1],
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
  if pet.PetChessSoldier_skillatk1_started and not pet.PetChessSoldier_skillatk1_casted then
    if not pet.PetChessSoldier_skillatk1_countdown then
      pet.PetChessSoldier_skillatk1_countdown = 0
    end
    pet.PetChessSoldier_skillatk1_countdown = pet.PetChessSoldier_skillatk1_countdown + dt
    if pet.PetChessSoldier_skillatk1_countdown > 0.2 and pet.actor then
      pet.actor.node:setVisible(true)
    end
    if pet.PetChessSoldier_skillatk1_countdown > 0.7 then
      local skillatk1 = pet.skills.PetChessSoldier_atk1
      local skillatk1_1 = pet.skills.PetChessSoldier_atk1_1
      if skillatk1 then
        local newTarget = skillatk1:selectTarget(nil)
        if newTarget then
          pet:castSkill(skillatk1, newTarget)
        end
      end
      if skillatk1_1 then
        master:addBuff(skillatk1_1:createBuff(master), master)
        pet:setAction("atk", false)
      end
      pet.PetChessSoldier_skillatk1_casted = true
    end
  end
  if pet.actor and pet.PetChessSoldier_skillatk1_casted and (pet.action_name == "Idle" or pet.action_name == "Move") and not pet.PetChessSoldier_skillatk1_invisible then
    pet.actor.node:setVisible(false)
    pet.PetChessSoldier_skillatk1_invisible = true
    local effect_name = "eff_point_mirror_die.cha"
    ed.scene:playEffectOnScene(effect_name, {
      pet.position[1],
      pet.position[2] - 1
    }, {0.6, 0.6}, nil, 1)
  end
end

function PetChessSoldier.hero_reset(basefunc, pet)
  basefunc(pet)
  pet.PetChessSoldier_buffadded = nil
  pet.PetChessSoldier_skillpasv_casted = nil
  pet.PetChessSoldier_skillatk1_started = nil
  pet.PetChessSoldier_skillatk1_countdown = nil
  pet.PetChessSoldier_skillatk1_casted = nil
  pet.PetChessSoldier_skillatk1_invisible = nil
end

function PetChessSoldier.init_hero(hero)
  hero.update = override(hero.update, PetChessSoldier.hero_update)
  hero.reset = override(hero.reset, PetChessSoldier.hero_reset)
  local skillatk1 = hero.skills.PetChessSoldier_atk1
  if skillatk1 then
    skillatk1.onAttackFrame = override(skillatk1.onAttackFrame, PetChessSoldier.atk1_onAttackFrame)
  end
  return hero
end

return PetChessSoldier.init_hero
