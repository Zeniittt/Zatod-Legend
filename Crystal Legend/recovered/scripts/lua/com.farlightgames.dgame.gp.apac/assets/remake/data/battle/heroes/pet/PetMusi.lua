module("ed.battlehero", package.seeall)
local ed = ed
PetMusi = {}
PetMusi.PetMusi_startBuffID = 1349

function PetMusi.isCrlEftConflictWithUncontrollableSP(buff)
  local negative_effects = {
    frozen = true,
    stun = true,
    immoblilize = true,
    silence = true,
    disarm = true,
    imprisonment = true,
    enchanted = true,
    fear = true,
    taunt = true,
    detaunt = true,
    icefrozen = true
  }
  local isRet = false
  local info = buff.info
  for i, effect in ipairs(info["Control Effects"]) do
    if negative_effects[effect] then
      isRet = true
      break
    end
  end
  return isRet
end

function PetMusi.hero_update(basefunc, pet, dt)
  basefunc(pet, dt)
  if not pet.PetMusi_buffadded then
    local bid = PetMusi.PetMusi_startBuffID
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    pet:addBuff(binfo, pet)
    pet.PetMusi_buffadded = true
  end
  local master = pet.owner
  local skillpasv = pet.skills.PetMusi_pasv
  if master.hp <= master.attribs.HP * 0.7 and not pet.PetMusi_skillpasv_casted and skillpasv then
    master:addBuff(skillpasv:createBuff(master), master)
    pet.PetMusi_skillpasv_casted = true
    local list = master.buff_list
    local debuff_list = {}
    local my_camp = master.camp
    for i = 1, #list do
      local buff = list[i]
      if buff and (not buff.caster or buff.caster.camp ~= my_camp) and (PetMusi.isCrlEftConflictWithUncontrollableSP(buff) or buff.info.Dispel == "YES") then
        debuff_list[#debuff_list + 1] = buff
      end
    end
    for i = 1, #debuff_list do
      master:removeBuff(debuff_list[i])
    end
  end
  if not pet.PetMusi_skillatk1_started and master.current_skill and master.current_skill.info.Manual then
    pet.PetMusi_skillatk1_started = true
    pet:setPosition({
      master.position[1] - 40,
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
  if pet.PetMusi_skillatk1_started and not pet.PetMusi_skillatk1_casted then
    if not pet.PetMusi_skillatk1_countdown then
      pet.PetMusi_skillatk1_countdown = 0
    end
    pet.PetMusi_skillatk1_countdown = pet.PetMusi_skillatk1_countdown + dt
    if pet.PetMusi_skillatk1_countdown > 0.2 and pet.actor then
      pet.actor.node:setVisible(true)
    end
    if pet.PetMusi_skillatk1_countdown > 0.6 then
      local skillatk1 = pet.skills.PetMusi_atk1
      if skillatk1 then
        local newTarget = skillatk1:selectTarget(nil)
        if newTarget then
          pet:castSkill(skillatk1, newTarget)
        end
      end
      pet.PetMusi_skillatk1_casted = true
    end
  end
  if pet.actor and pet.PetMusi_skillatk1_casted and (pet.action_name == "Idle" or pet.action_name == "Move") and not pet.PetMusi_skillatk1_invisible then
    pet.actor.node:setVisible(false)
    pet.PetMusi_skillatk1_invisible = true
    local effect_name = "eff_point_mirror_die.cha"
    ed.scene:playEffectOnScene(effect_name, {
      pet.position[1],
      pet.position[2] - 1
    }, {0.6, 0.6}, nil, 1)
  end
end

function PetMusi.hero_reset(basefunc, pet)
  basefunc(pet)
  pet.PetMusi_buffadded = nil
  pet.PetMusi_skillpasv_casted = nil
  pet.PetMusi_firsttick = nil
  pet.PetMusi_skillatk1_countdown = nil
  pet.PetMusi_skillatk1_started = nil
  pet.PetMusi_skillatk1_casted = nil
  pet.PetMusi_skillatk1_invisible = nil
end

function PetMusi.init_hero(hero)
  hero.update = override(hero.update, PetMusi.hero_update)
  hero.reset = override(hero.reset, PetMusi.hero_reset)
  return hero
end

return PetMusi.init_hero
