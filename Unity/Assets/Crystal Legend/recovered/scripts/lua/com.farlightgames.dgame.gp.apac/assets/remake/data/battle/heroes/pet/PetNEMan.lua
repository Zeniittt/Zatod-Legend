module("ed.battlehero", package.seeall)
local ed = ed
PetNEMan = {}
PetNEMan.PetNEMan_startBuffID = 1349

function PetNEMan.skillatk1_start(basefunc, skill, target)
  local caster = skill.caster
  local master = caster.owner
  local target = target
  local v = 180
  local bid = 49
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
  caster.direction = target.position[1] - caster.position[1] >= 0 and 1 or -1
  caster.walk_v = {
    caster.direction * v,
    0
  }
  basefunc(skill, target)
end

function PetNEMan.skillatk1_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local skill = skill
  local caster = skill.caster
  if skill.attack_counter and skill.attack_counter == 4 then
    local v = -caster.walk_v[1]
    caster.walk_v = {v, 0}
  elseif skill.attack_counter and skill.attack_counter == 8 then
    caster.walk_v = {0, 0}
  end
end

function PetNEMan.skillatk1_finish(basefunc, skill)
  skill.caster.walk_v = {0, 0}
  skill.caster.direction = skill.caster.direction * -1
  basefunc(skill)
end

function PetNEMan.hero_update(basefunc, pet, dt)
  basefunc(pet, dt)
  if not pet.petNEMan_buffadded then
    local bid = PetNEMan.PetNEMan_startBuffID
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    pet:addBuff(binfo, pet)
    pet.petNEMan_buffadded = true
  end
  local master = pet.owner
  if not pet.petNEMan_firsttick then
    pet.petNEMan_firsttick = ed.engine.ticks
  end
  if ed.engine.ticks - pet.petNEMan_firsttick > 40 and not pet.petNEMan_skillpasv_casted then
    local skillpasv = pet.skills.PetNEMan_pasv
    if skillpasv then
      master:addBuff(skillpasv:createBuff(master), master)
      pet.petNEMan_skillpasv_casted = true
    end
  end
  if not pet.petNEMan_skillatk1_started and master.current_skill and master.current_skill.info.Manual then
    pet.petNEMan_skillatk1_started = true
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
  if pet.petNEMan_skillatk1_started and not pet.petNEMan_skillatk1_casted then
    if not pet.petNEMan_skillatk1_countdown then
      pet.petNEMan_skillatk1_countdown = 0
    end
    pet.petNEMan_skillatk1_countdown = pet.petNEMan_skillatk1_countdown + dt
    if pet.petNEMan_skillatk1_countdown > 0.2 and pet.actor then
      pet.actor.node:setVisible(true)
    end
    if pet.petNEMan_skillatk1_countdown > 0.3 then
      local binfo1 = ed.lookupDataTable("Buff", nil, 4132)
      local skillatk1 = pet.skills.PetNEMan_atk1
      if skillatk1 then
        local newTarget = skillatk1:selectTarget(nil)
        if newTarget then
          pet:castSkill(skillatk1, newTarget)
        end
      end
      pet.petNEMan_skillatk1_casted = true
    end
  end
  if pet.actor and pet.petNEMan_skillatk1_casted and (pet.action_name == "Idle" or pet.action_name == "Move") and not pet.petNEMan_skillatk1_invisible then
    pet.actor.node:setVisible(false)
    pet.petNEMan_skillatk1_invisible = true
    local effect_name = "eff_point_mirror_die.cha"
    ed.scene:playEffectOnScene(effect_name, {
      pet.position[1],
      pet.position[2] - 1
    }, {0.6, 0.6}, nil, 1)
  end
end

function PetNEMan.hero_reset(basefunc, pet)
  basefunc(pet)
  pet.petNEMan_buffadded = nil
  pet.petNEMan_skillpasv_casted = nil
  pet.petNEMan_firsttick = nil
  pet.petNEMan_skillatk1_countdown = nil
  pet.petNEMan_skillatk1_started = nil
  pet.petNEMan_skillatk1_casted = nil
  pet.petNEMan_skillatk1_invisible = nil
end

function PetNEMan.init_hero(hero)
  local skillatk1 = hero.skills.PetNEMan_atk1
  if skillatk1 then
    skillatk1.start = override(skillatk1.start, PetNEMan.skillatk1_start)
    skillatk1.onAttackFrame = override(skillatk1.onAttackFrame, PetNEMan.skillatk1_onAttackFrame)
    skillatk1.finish = override(skillatk1.finish, PetNEMan.skillatk1_finish)
  end
  hero.update = override(hero.update, PetNEMan.hero_update)
  hero.reset = override(hero.reset, PetNEMan.hero_reset)
  return hero
end

return PetNEMan.init_hero
