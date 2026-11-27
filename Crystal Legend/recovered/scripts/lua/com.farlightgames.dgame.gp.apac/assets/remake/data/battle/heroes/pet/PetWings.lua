module("ed.battlehero", package.seeall)
local ed = ed
PetWings = {}
PetWings.PetWings_startBuffID = 1349

function PetWings.hero_update(basefunc, pet, dt)
  basefunc(pet, dt)
  local master = pet.owner
  local hpmax = master.attribs.HP
  if not pet.petWings_buffadded then
    local bid = PetWings.PetWings_startBuffID
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    pet:addBuff(binfo, pet)
    pet.petWings_buffadded = true
  end
  if not pet.petWings_firsttick then
    pet.petWings_firsttick = ed.engine.ticks
  end
  if master.hp <= master.attribs.HP * 0.3 and not pet.petWings_skillpasv_casted then
    local skillpasv = pet.skills.PetWings_pasv
    if skillpasv then
      local buffpasv = skillpasv:createBuff(master)
      buffpasv:setAttribute("HPR", 0.04 * hpmax)
      master:addBuff(buffpasv, master)
      pet.petWings_skillpasv_casted = true
    end
  end
  if not pet.petWings_skillatk1_started and master.current_skill and master.current_skill.info.Manual then
    pet.petWings_skillatk1_started = true
    pet:setPosition({
      master.position[1] - master.direction * 50,
      master.position[2] - 20
    })
    pet.direction = master.direction
    pet:setAction("Idle2")
    if ed.run_with_scene then
      local effect_name = "eff_point_Pet_born.cha"
      ed.scene:playEffectOnScene(effect_name, {
        pet.position[1],
        pet.position[2] - 1
      }, {1, 1}, nil, 1)
    end
  end
  if pet.petWings_skillatk1_started and not pet.petWings_skillatk1_casted then
    if not pet.petWings_skillatk1_countdown then
      pet.petWings_skillatk1_countdown = 0
    end
    pet.petWings_skillatk1_countdown = pet.petWings_skillatk1_countdown + dt
    if pet.petWings_skillatk1_countdown > 0.2 and pet.actor then
      pet.actor.node:setVisible(true)
    end
    if pet.petWings_skillatk1_countdown > 1.2 then
      local skillatk1 = pet.skills.PetWings_atk1
      if skillatk1 then
        master:addBuff(skillatk1:createBuff(master), master)
        pet:setAction("atk", false)
      end
      pet.petWings_skillatk1_casted = true
    end
  end
  if pet.actor and pet.petWings_skillatk1_casted and (pet.action_name == "Idle" or pet.action_name == "Move") and not pet.petWings_skillatk1_invisible then
    pet.actor.node:setVisible(false)
    pet.petWings_skillatk1_invisible = true
    local effect_name = "eff_point_mirror_die.cha"
    ed.scene:playEffectOnScene(effect_name, {
      pet.position[1],
      pet.position[2] + 80
    }, {0.6, 0.6}, nil, 1)
  end
end

function PetWings.skill1_buff_onRemoved(basefunc, buff)
  if buff.timer >= 0 and 0 < buff.shield then
    return basefunc(buff)
  end
  local skill = buff.caster.skills.PetWings_atk1
  local originfo = skill.info
  skill.info = ed.wraptable(originfo, {
    ["Affected Camp"] = -1,
    ["AOE Origin"] = "target",
    ["AOE Shape"] = "circle",
    ["Shape Arg1"] = 200,
    ["Damage Type"] = "AP",
    ["Buff ID"] = 0,
    ["Point Effect"] = "eff_point_DR_atk3.cha",
    ["Impact Effect"] = "eff_impact_LOA_atk2.cha"
  })
  skill:takeEffectAt(buff.owner.position)
  skill.info = originfo
  return basefunc(buff)
end

function PetWings.skill1_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.onRemoved = override(buff.onRemoved, PetWings.skill1_buff_onRemoved)
  return buff
end

function PetWings.hero_reset(basefunc, pet)
  basefunc(pet)
  pet.petWings_buffadded = nil
  pet.petWings_skillpasv_casted = nil
  pet.petWings_firsttick = nil
  pet.petWings_skillatk1_countdown = nil
  pet.petWings_skillatk1_started = nil
  pet.petWings_skillatk1_casted = nil
  pet.petWings_skillatk1_invisible = nil
end

function PetWings.init_hero(hero)
  local skill1 = hero.skills.PetWings_atk1
  if skill1 then
    skill1.createBuff = override(skill1.createBuff, PetWings.skill1_createBuff)
  end
  hero.update = override(hero.update, PetWings.hero_update)
  hero.reset = override(hero.reset, PetWings.hero_reset)
  return hero
end

return PetWings.init_hero
