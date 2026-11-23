module("ed.battlehero", package.seeall)
local ed = ed
PetBoxCat = {}
PetBoxCat.PetBoxCat_startBuffID = 1349
PetBoxCat.offset_list = {
  {0, 0},
  {-19, 5},
  {5, -14},
  {-36, 28},
  {39, -50}
}

function PetBoxCat.createProjectile(basefunc, skill)
  local count = (skill.info["Script Arg1"] - skill.attack_counter) / 5 + 1
  local origtarget = skill.target
  for i = 1, count do
    local projectile = basefunc(skill)
    local h = projectile.height
    local v = projectile.zSpeed
    local a = skill.info["Tile Gravity"]
    local A = 0.5 * a
    local B = v
    local C = h
    local delta = B ^ 2 - 4 * A * C
    local t = (-B - delta ^ 0.5) / (2 * A)
    if 1 < i then
      skill:selectTarget()
    end
    if i == 1 or skill.target ~= origtarget then
      local target_position = {
        skill.target.position[1],
        skill.target.position[2]
      }
      local distance = ed.edpSub(target_position, {
        skill.caster.position[1] + 45 * skill.caster.direction,
        skill.caster.position[2]
      })
      projectile.velocity = ed.edpMult(distance, 1 / t)
      ed.engine:addProjectile(projectile)
    end
  end
  return nil
end

function PetBoxCat.hero_update(basefunc, pet, dt)
  basefunc(pet, dt)
  if not pet.PetBoxCat_buffadded then
    local bid = PetBoxCat.PetBoxCat_startBuffID
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    pet:addBuff(binfo, pet)
    pet.PetBoxCat_buffadded = true
  end
  local master = pet.owner
  if not pet.PetBoxCat_firsttick then
    pet.PetBoxCat_firsttick = ed.engine.ticks
  end
  if master.hp <= master.attribs.HP * 0.3 and not pet.PetBoxCat_skillpasv_casted then
    local skillpasv = pet.skills.PetBoxCat_pasv
    if skillpasv then
      master:addBuff(skillpasv:createBuff(master), master)
      pet.PetBoxCat_skillpasv_casted = true
    end
  end
  if not pet.PetBoxCat_skillatk1_started and master.current_skill and master.current_skill.info.Manual then
    pet.PetBoxCat_skillatk1_started = true
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
  if pet.PetBoxCat_skillatk1_started and not pet.PetBoxCat_skillatk1_casted then
    if not pet.PetBoxCat_skillatk1_countdown then
      pet.PetBoxCat_skillatk1_countdown = 0
    end
    pet.PetBoxCat_skillatk1_countdown = pet.PetBoxCat_skillatk1_countdown + dt
    if pet.PetBoxCat_skillatk1_countdown > 0.2 and pet.actor then
      pet.actor.node:setVisible(true)
    end
    if pet.PetBoxCat_skillatk1_countdown > 0.8 then
      local skillatk1 = pet.skills.PetBoxCat_atk1
      if skillatk1 then
        local newTarget = skillatk1:selectTarget(nil)
        if newTarget then
          pet:castSkill(skillatk1, newTarget)
        end
      end
      pet.PetBoxCat_skillatk1_casted = true
    end
  end
  if pet.actor and pet.PetBoxCat_skillatk1_casted and (pet.action_name == "Idle" or pet.action_name == "Move") and not pet.PetBoxCat_skillatk1_invisible then
    pet.actor.node:setVisible(false)
    pet.PetBoxCat_skillatk1_invisible = true
    local effect_name = "eff_point_mirror_die.cha"
    ed.scene:playEffectOnScene(effect_name, {
      pet.position[1],
      pet.position[2] - 1
    }, {0.6, 0.6}, nil, 1)
  end
end

function PetBoxCat.hero_reset(basefunc, pet)
  basefunc(pet)
  pet.PetBoxCat_buffadded = nil
  pet.PetBoxCat_skillpasv_casted = nil
  pet.PetBoxCat_firsttick = nil
  pet.PetBoxCat_skillatk1_countdown = nil
  pet.PetBoxCat_skillatk1_started = nil
  pet.PetBoxCat_skillatk1_casted = nil
  pet.PetBoxCat_skillatk1_invisible = nil
end

function PetBoxCat.init_hero(hero)
  hero.update = override(hero.update, PetBoxCat.hero_update)
  hero.reset = override(hero.reset, PetBoxCat.hero_reset)
  local skillatk1 = hero.skills.PetBoxCat_atk1
  if skillatk1 then
    skillatk1.createProjectile = override(skillatk1.createProjectile, PetBoxCat.createProjectile)
  end
  return hero
end

return PetBoxCat.init_hero
