module("ed.battlehero", package.seeall)
local ed = ed
local PetDaiZei = {}
PetDaiZei.hidden_id = 1349
PetDaiZei.PetDaiZei_pasv_id = 6095
PetDaiZei.PetDaiZei_atk1 = 6096

function PetDaiZei.hero_update(basefunc, pet, dt)
  basefunc(pet, dt)
  local master = pet.owner
  if not pet.PetDaiZei_buffadded then
    local bid = PetDaiZei.hidden_id
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    pet:addBuff(binfo, pet)
    pet.PetDaiZei_buffadded = true
  end
  if not pet.PetDaiZei_firsttick then
    pet.PetDaiZei_firsttick = ed.engine.ticks
  end
  if ed.engine.ticks - pet.PetDaiZei_firsttick > 40 and not pet.PetDaiZei_skillpasv_casted then
    local skillpasv = pet.skills.PetDaiZei_pasv
    if skillpasv then
      local newTarget = skillpasv:selectTarget(nil)
      if newTarget then
        pet:castSkill(skillpasv, newTarget)
      end
      pet.PetDaiZei_skillpasv_casted = true
    end
  end
  if not pet.PetDaiZei_skillatk1_started and master.current_skill and master.current_skill.info.Manual then
    pet.PetDaiZei_skillatk1_started = true
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
  if not pet.PetDaiZei_skillatk1_countdown then
    pet.PetDaiZei_skillatk1_countdown = 0
  end
  if pet.PetDaiZei_skillatk1_started and not pet.skill_down then
    pet.PetDaiZei_skillatk1_countdown = pet.PetDaiZei_skillatk1_countdown + dt
  end
  if pet.PetDaiZei_skillatk1_started and not pet.PetDaiZei_skillatk1_casted then
    if pet.PetDaiZei_skillatk1_countdown > 0.2 and pet.actor then
      pet.actor.node:setVisible(true)
    end
    if 1 < pet.PetDaiZei_skillatk1_countdown then
      local skillatk1 = pet.skills.PetDaiZei_atk1
      if skillatk1 then
        local newTarget = skillatk1:selectTarget(nil)
        if newTarget then
          pet:castSkill(skillatk1, newTarget)
          pet:setAction("atk", false)
        end
      end
      pet.PetDaiZei_skillatk1_casted = true
    end
  end
  if pet.position_updating and not pet.PetDaiZei_skillatk1_invisible then
    local position_defining = pet.target_updating.position[1] - pet.direction * 50
    if 799 < position_defining or position_defining < 1 then
      position_defining = position_defining - pet.direction * 50
    end
    pet:setPosition({
      position_defining,
      pet.target_updating.position[2]
    })
  end
  if not pet.skill_down and pet.PetDaiZei_skillatk1_countdown > 4 and pet.actor and pet.PetDaiZei_skillatk1_casted and (pet.action_name == "Idle" or pet.action_name == "Move") and not pet.PetDaiZei_skillatk1_invisible then
    pet.actor.node:setVisible(false)
    pet.PetDaiZei_skillatk1_invisible = true
    local effect_name = "eff_point_mirror_die.cha"
    ed.scene:playEffectOnScene(effect_name, {
      pet.position[1] + pet.direction * 100,
      pet.position[2]
    }, {0.6, 0.6}, nil, 1)
    pet.skill_down = true
  end
end

function PetDaiZei.atk1_createBuff(basefunc, skill, target)
end

function PetDaiZei.atk1_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local target = skill.target
  if target then
    if skill.attack_counter == 0 then
      local skillatk1 = caster.skills.PetDaiZei_atk1
      local bid = PetDaiZei.PetDaiZei_atk1
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = skillatk1:createBuff(target)
      target:addBuff(buff, caster)
      skillatk1.createBuff = override(skillatk1.createBuff, PetDaiZei.atk1_createBuff)
      skill.attack_counter = skill.attack_counter + 1
      caster:setPosition({
        target.position[1] - caster.direction * 50,
        target.position[2]
      })
      caster.position_updating = true
      caster.target_updating = target
    end
    if skill.attack_counter == 1 and caster.PetDaiZei_skillatk1_countdown > 1.375 then
      basefunc(skill)
    end
    if skill.attack_counter == 2 and caster.PetDaiZei_skillatk1_countdown > 2.375 then
      basefunc(skill)
    end
  end
end

function PetDaiZei.pasv_onAttackFrame(basefunc, skill)
  if skill.attack_counter == 0 then
    basefunc(skill)
  end
end

function PetDaiZei.hero_reset(basefunc, pet)
  basefunc(pet)
  pet.PetDaiZei_buffadded = nil
  pet.skill_down = nil
  pet.position_updating = nil
  pet.PetDaiZei_skillpasv_casted = nil
  pet.PetDaiZei_firsttick = nil
  pet.PetDaiZei_skillatk1_countdown = nil
  pet.PetDaiZei_skillatk1_started = nil
  pet.PetDaiZei_skillatk1_casted = nil
  pet.PetDaiZei_skillatk1_invisible = nil
end

function PetDaiZei.init_hero(hero)
  local skillpasv = hero.skills.PetDaiZei_pasv
  if skillpasv then
    skillpasv.onAttackFrame = override(skillpasv.onAttackFrame, PetDaiZei.pasv_onAttackFrame)
  end
  local skillatk1 = hero.skills.PetDaiZei_atk1
  if skillatk1 then
    skillatk1.onAttackFrame = override(skillatk1.onAttackFrame, PetDaiZei.atk1_onAttackFrame)
  end
  hero.update = override(hero.update, PetDaiZei.hero_update)
  hero.reset = override(hero.reset, PetDaiZei.hero_reset)
  return hero
end

return PetDaiZei.init_hero
