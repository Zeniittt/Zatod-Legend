module("ed.battlehero", package.seeall)
local ed = ed
PetGinkyeknom = {}
PetGinkyeknom.PetGinkyeknom_startBuffID = 1349

function PetGinkyeknom.skill1_onRemoved(basefunc, buff)
  local master = buff.owner
  master:startScalingAction(1, 1)
  basefunc(buff)
end

function PetGinkyeknom.skill1_1_onRemoved(basefunc, buff)
  local master = buff.owner
  master:startScalingAction(1, 1)
  basefunc(buff)
end

function PetGinkyeknom.skill1_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.onRemoved = override(buff.onRemoved, PetGinkyeknom.skill1_onRemoved)
  local master = skill.caster.owner
  master:startScalingAction(1.4, 1.3)
  return buff
end

function PetGinkyeknom.skill1_1_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.onRemoved = override(buff.onRemoved, PetGinkyeknom.skill1_1_onRemoved)
  local master = skill.caster.owner
  master:startScalingAction(0.6, 1.3)
  return buff
end

function PetGinkyeknom.hero_update(basefunc, pet, dt)
  basefunc(pet, dt)
  if not pet.petGinkyeknom_buffadded then
    local bid = PetGinkyeknom.PetGinkyeknom_startBuffID
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    pet:addBuff(binfo, pet)
    pet.petGinkyeknom_buffadded = true
  end
  local master = pet.owner
  if not pet.petGinkyeknom_firsttick then
    pet.petGinkyeknom_firsttick = ed.engine.ticks
  end
  if master.hp <= master.attribs.HP * 0.3 and not pet.petGinkyeknom_skillpasv_casted then
    local skillpasv = pet.skills.PetGinkyeknom_pasv
    if skillpasv then
      master:addBuff(skillpasv:createBuff(master), master)
      pet.petGinkyeknom_skillpasv_casted = true
    end
  end
  if not pet.petGinkyeknom_skillatk1_started and master.current_skill and master.current_skill.info.Manual then
    pet.petGinkyeknom_skillatk1_started = true
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
  if pet.petGinkyeknom_skillatk1_started and not pet.petGinkyeknom_skillatk1_casted then
    if not pet.petGinkyeknom_skillatk1_countdown then
      pet.petGinkyeknom_skillatk1_countdown = 0
    end
    pet.petGinkyeknom_skillatk1_countdown = pet.petGinkyeknom_skillatk1_countdown + dt
    if pet.petGinkyeknom_skillatk1_countdown > 0.2 and pet.actor then
      pet.actor.node:setVisible(true)
    end
    if pet.petGinkyeknom_skillatk1_countdown > 0.5 then
      local skillatk1 = pet.skills.PetGinkyeknom_atk1
      local skillatk2 = pet.skills.PetGinkyeknom_atk1_1
      if master.hp >= master.attribs.HP * 0.5 then
        if skillatk1 then
          master:addBuff(skillatk1:createBuff(master), master)
          pet:setAction("atk", false)
        end
      elseif skillatk2 then
        master:addBuff(skillatk2:createBuff(master), master)
        pet:setAction("atk", false)
      end
      pet.petGinkyeknom_skillatk1_casted = true
    end
  end
  if pet.actor and pet.petGinkyeknom_skillatk1_casted and (pet.action_name == "Idle" or pet.action_name == "Move") and not pet.petGinkyeknom_skillatk1_invisible then
    pet.actor.node:setVisible(false)
    pet.petGinkyeknom_skillatk1_invisible = true
    local effect_name = "eff_point_mirror_die.cha"
    ed.scene:playEffectOnScene(effect_name, {
      pet.position[1],
      pet.position[2] - 1
    }, {0.6, 0.6}, nil, 1)
  end
end

function PetGinkyeknom.hero_reset(basefunc, pet)
  basefunc(pet)
  pet.petGinkyeknom_buffadded = nil
  pet.petGinkyeknom_skillpasv_casted = nil
  pet.petGinkyeknom_skillatk1_started = nil
  pet.petGinkyeknom_skillatk1_countdown = nil
  pet.petGinkyeknom_skillatk1_casted = nil
  pet.petGinkyeknom_skillatk1_invisible = nil
end

function PetGinkyeknom.init_hero(hero)
  hero.update = override(hero.update, PetGinkyeknom.hero_update)
  hero.reset = override(hero.reset, PetGinkyeknom.hero_reset)
  local skill1 = hero.skills.PetGinkyeknom_atk1
  local skill1_1 = hero.skills.PetGinkyeknom_atk1_1
  if skill1 then
    skill1.createBuff = override(skill1.createBuff, PetGinkyeknom.skill1_createBuff)
  end
  if skill1_1 then
    skill1_1.createBuff = override(skill1_1.createBuff, PetGinkyeknom.skill1_1_createBuff)
  end
  return hero
end

return PetGinkyeknom.init_hero
