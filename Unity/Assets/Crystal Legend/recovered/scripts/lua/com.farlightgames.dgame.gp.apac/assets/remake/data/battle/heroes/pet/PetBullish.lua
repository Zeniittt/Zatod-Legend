module("ed.battlehero", package.seeall)
local ed = ed
PetBullish = {}
PetBullish.PetBullish_startBuffID = 1349

function PetBullish.atk_onAttackFrame(basefunc, skill)
  local pet = skill.caster
  if ed.run_with_scene and not ed.IsMultiArena() then
    local effect_smoke = "eff_impact_Bullish_atk.cha"
    local origin = {
      ed.engine.stage_rect.maxX / 2,
      ed.engine.stage_rect.maxY / 2 - 180
    }
    pet.atk_effect = ed.scene:playEffectOnScene(effect_smoke, origin, {1, 1}, nil, -1)
  end
  basefunc(skill)
end

function PetBullish.hero_update(basefunc, pet, dt)
  basefunc(pet, dt)
  if not pet.PetBullish_buffadded then
    local bid = PetBullish.PetBullish_startBuffID
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    pet:addBuff(binfo, pet)
    pet.PetBullish_buffadded = true
  end
  local master = pet.owner
  local skillpasv = pet.skills.PetBullish_pasv
  if master.hp <= master.attribs.HP * 0.3 and not pet.PetBullish_skillpasv_casted and skillpasv then
    skillpasv:takeEffectOn(master, master)
    pet.PetBullish_skillpasv_casted = true
  end
  if not pet.PetBullish_skillatk1_started and master.current_skill and master.current_skill.info.Manual then
    pet.PetBullish_skillatk1_started = true
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
  if pet.PetBullish_skillatk1_started and not pet.PetBullish_skillatk1_casted then
    if not pet.PetBullish_skillatk1_countdown then
      pet.PetBullish_skillatk1_countdown = 0
    end
    pet.PetBullish_skillatk1_countdown = pet.PetBullish_skillatk1_countdown + dt
    if pet.PetBullish_skillatk1_countdown > 0.2 and pet.actor then
      pet.actor.node:setVisible(true)
    end
    if pet.PetBullish_skillatk1_countdown > 1.5 then
      local skillatk1 = pet.skills.PetBullish_atk1
      if skillatk1 then
        local newTarget = skillatk1:selectTarget(nil)
        if newTarget then
          pet:castSkill(skillatk1, newTarget)
        end
      end
      pet.PetBullish_skillatk1_casted = true
    end
  end
  if pet.actor and pet.PetBullish_skillatk1_casted and (pet.action_name == "Idle" or pet.action_name == "Move") and not pet.PetBullish_skillatk1_invisible then
    pet.actor.node:setVisible(false)
    pet.PetBullish_skillatk1_invisible = true
    local effect_name = "eff_point_mirror_die.cha"
    ed.scene:playEffectOnScene(effect_name, {
      pet.position[1],
      pet.position[2] - 1
    }, {0.6, 0.6}, nil, 1)
  end
end

function PetBullish.hero_reset(basefunc, pet)
  basefunc(pet)
  pet.PetBullish_buffadded = nil
  pet.PetBullish_skillpasv_casted = nil
  pet.PetBullish_firsttick = nil
  pet.PetBullish_skillatk1_countdown = nil
  pet.PetBullish_skillatk1_started = nil
  pet.PetBullish_skillatk1_casted = nil
  pet.PetBullish_skillatk1_invisible = nil
end

function PetBullish.init_hero(hero)
  hero.update = override(hero.update, PetBullish.hero_update)
  hero.reset = override(hero.reset, PetBullish.hero_reset)
  local atk = hero.skills.PetBullish_atk1
  if atk then
    atk.onAttackFrame = override(atk.onAttackFrame, PetBullish.atk_onAttackFrame)
  end
  return hero
end

return PetBullish.init_hero
