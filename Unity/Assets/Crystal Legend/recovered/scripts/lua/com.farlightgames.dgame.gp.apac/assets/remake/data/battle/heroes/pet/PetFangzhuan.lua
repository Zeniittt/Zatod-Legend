module("ed.battlehero", package.seeall)
local ed = ed
PetFangzhuan = {}
PetFangzhuan.PetFangzhuan_startBuffID = 1349

function PetFangzhuan.hero_update(basefunc, pet, dt)
  basefunc(pet, dt)
  if not pet.petFangzhuan_buffadded then
    local bid = PetFangzhuan.PetFangzhuan_startBuffID
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    pet:addBuff(binfo, pet)
    pet.petFangzhuan_buffadded = true
  end
  local master = pet.owner
  if not pet.petFangzhuan_firsttick then
    pet.petFangzhuan_firsttick = ed.engine.ticks
  end
  if master.hp <= master.attribs.HP * 0.5 and not pet.petFangzhuan_skillpasv_casted then
    local skillpasv = pet.skills.PetFangzhuan_pasv
    if skillpasv then
      master:addBuff(skillpasv:createBuff(master), master)
      pet.petFangzhuan_skillpasv_casted = true
    end
  end
  if not pet.petFangzhuan_skillatk1_started and master.current_skill and master.current_skill.info.Manual then
    pet.petFangzhuan_skillatk1_started = true
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
  if pet.petFangzhuan_skillatk1_started and not pet.petFangzhuan_skillatk1_casted then
    if not pet.petFangzhuan_skillatk1_countdown then
      pet.petFangzhuan_skillatk1_countdown = 0
    end
    pet.petFangzhuan_skillatk1_countdown = pet.petFangzhuan_skillatk1_countdown + dt
    if pet.petFangzhuan_skillatk1_countdown > 0.2 and pet.actor then
      pet.actor.node:setVisible(true)
    end
    if pet.petFangzhuan_skillatk1_countdown > 1.1 then
      local binfo1 = ed.lookupDataTable("Buff", nil, 4132)
      local skillatk1 = pet.skills.PetFangzhuan_atk1
      if skillatk1 then
        local newTarget = skillatk1:selectTarget(nil)
        if newTarget then
          pet:castSkill(skillatk1, newTarget)
        end
      end
      pet.petFangzhuan_skillatk1_casted = true
    end
  end
  if pet.actor and pet.petFangzhuan_skillatk1_casted and (pet.action_name == "Idle" or pet.action_name == "Move") and not pet.petFangzhuan_skillatk1_invisible then
    pet.actor.node:setVisible(false)
    pet.petFangzhuan_skillatk1_invisible = true
    local effect_name = "eff_point_mirror_die.cha"
    ed.scene:playEffectOnScene(effect_name, {
      pet.position[1],
      pet.position[2] - 1
    }, {0.6, 0.6}, nil, 1)
  end
end

function PetFangzhuan.hero_reset(basefunc, pet)
  basefunc(pet)
  pet.petFangzhuan_buffadded = nil
  pet.petFangzhuan_skillpasv_casted = nil
  pet.petFangzhuan_firsttick = nil
  pet.petFangzhuan_skillatk1_countdown = nil
  pet.petFangzhuan_skillatk1_started = nil
  pet.petFangzhuan_skillatk1_casted = nil
  pet.petFangzhuan_skillatk1_invisible = nil
end

function PetFangzhuan.init_hero(hero)
  hero.update = override(hero.update, PetFangzhuan.hero_update)
  hero.reset = override(hero.reset, PetFangzhuan.hero_reset)
  return hero
end

return PetFangzhuan.init_hero
