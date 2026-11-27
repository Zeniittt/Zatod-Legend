module("ed.battlehero", package.seeall)
local ed = ed
PetMetaDragon = {}
PetMetaDragon.PetMetaDragon_startBuffID = 1349

function PetMetaDragon.hero_update(basefunc, pet, dt)
  basefunc(pet, dt)
  if not pet.petmetadragon_buffadded then
    local bid = PetMetaDragon.PetMetaDragon_startBuffID
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    pet:addBuff(binfo, pet)
    pet.petmetadragon_buffadded = true
  end
  local master = pet.owner
  local hpmax = master.attribs.HP
  if master.hp <= master.attribs.HP * 0.3 and not pet.petmetadragon_skillpasv_casted then
    local skillpasv = pet.skills.PetMetaDragon_pasv
    if skillpasv then
      local buffpasv = skillpasv:createBuff(master)
      buffpasv:setAttribute("HPR", 0.08 * hpmax)
      master:addBuff(buffpasv, master)
      pet.petmetadragon_skillpasv_casted = true
    end
  end
  if not pet.petmetadragon_skillatk1_started and master.current_skill and master.current_skill.info.Manual then
    pet.petmetadragon_skillatk1_started = true
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
  if pet.petmetadragon_skillatk1_started and not pet.petmetadragon_skillatk1_casted then
    if not pet.petmetadragon_skillatk1_countdown then
      pet.petmetadragon_skillatk1_countdown = 0
    end
    pet.petmetadragon_skillatk1_countdown = pet.petmetadragon_skillatk1_countdown + dt
    if pet.petmetadragon_skillatk1_countdown > 0.2 and pet.actor then
      pet.actor.node:setVisible(true)
    end
    if pet.petmetadragon_skillatk1_countdown > 0.5 then
      local skillatk1 = pet.skills.PetMetaDragon_atk1
      if skillatk1 then
        master:addBuff(skillatk1:createBuff(master), master)
        pet:setAction("atk", false)
      end
      pet.petmetadragon_skillatk1_casted = true
    end
  end
  if pet.actor and pet.petmetadragon_skillatk1_casted and (pet.action_name == "Idle" or pet.action_name == "Move") and not pet.petmetadragon_skillatk1_invisible then
    pet.actor.node:setVisible(false)
    pet.petmetadragon_skillatk1_invisible = true
    local effect_name = "eff_point_mirror_die.cha"
    ed.scene:playEffectOnScene(effect_name, {
      pet.position[1],
      pet.position[2] - 1
    }, {0.6, 0.6}, nil, 1)
  end
end

function PetMetaDragon.hero_reset(basefunc, pet)
  basefunc(pet)
  pet.petmetadragon_buffadded = nil
  pet.petmetadragon_skillpasv_casted = nil
  pet.petmetadragon_skillatk1_started = nil
  pet.petmetadragon_skillatk1_countdown = nil
  pet.petmetadragon_skillatk1_casted = nil
  pet.petmetadragon_skillatk1_invisible = nil
end

function PetMetaDragon.init_hero(hero)
  hero.update = override(hero.update, PetMetaDragon.hero_update)
  hero.reset = override(hero.reset, PetMetaDragon.hero_reset)
  return hero
end

return PetMetaDragon.init_hero
