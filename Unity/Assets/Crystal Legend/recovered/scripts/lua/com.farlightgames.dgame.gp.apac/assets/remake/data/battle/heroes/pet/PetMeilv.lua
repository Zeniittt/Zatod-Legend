module("ed.battlehero", package.seeall)
local ed = ed
PetMeilv = {}
PetMeilv.PetMeilv_startBuffID = 1349

function PetMeilv.pasvbuff_onDamaged(basefunc, buff, damage, damage_type, source, skill)
  local owner = buff.owner
  local defence, dd, dc, immunity, crit
  local level = owner.level
  if damage_type == "AD" then
    defence = math.max(0, owner.attribs.ARM - source.attribs.ARMP)
    crit = source.attribs.CRIT
    immunity = owner.attribs.PIMU or 0
    dd = defence * 8
    dc = defence * 8
  elseif damage_type == "AP" then
    defence = math.max(0, owner.attribs.MR - source.attribs.MRI)
    crit = source.attribs.MCRIT
    immunity = owner.attribs.MIMU or 0
    dd = defence * 12
    dc = defence * 2.5
  elseif damage_type == "Holy" then
    defence = 0
    crit = 0
    immunity = 0
    dd = 0
    dc = 0
  else
    EDDebug("Unknown Damage Type '" .. damage_type .. "'")
  end
  immunity = immunity + owner.attribs.ALLIMU
  local lastdamage = owner:getLostHPAfterImmunity(damage, immunity, damage_type)
  local oridmg = basefunc(buff, damage, damage_type, source, skill)
  local hasMagicianBuff = false
  if source.info.Name == "Magician" then
    local Magician_ult_caster = source
    for _, tbuff in ipairs(owner.buff_list) do
      if tbuff.info.ID == Magician.ultTargetInviBuff and tbuff.caster == Magician_ult_caster then
        hasMagicianBuff = true
      end
    end
  end
  if lastdamage >= owner.attribs.HP * 0.3 and not hasMagicianBuff then
    oridmg = 0
    buff.timer = 0
    if ed.run_with_scene then
      ed.scene:playEffectOnScene("eff_buff_Lantern_atk2_destroy.cha", {
        owner.position[1],
        owner.position[2] - 2
      }, {
        owner.direction,
        1
      }, nil, 0)
    end
  end
  return oridmg
end

function PetMeilv.pasv_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.onDamaged = override(buff.onDamaged, PetMeilv.pasvbuff_onDamaged)
  return buff
end

function PetMeilv.hero_update(basefunc, pet, dt)
  basefunc(pet, dt)
  if not pet.petMeilv_buffadded then
    local bid = PetMeilv.PetMeilv_startBuffID
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    pet:addBuff(binfo, pet)
    pet.petMeilv_buffadded = true
  end
  local master = pet.owner
  if not pet.petMeilv_firsttick then
    pet.petMeilv_firsttick = ed.engine.ticks
  end
  if ed.engine.ticks - pet.petMeilv_firsttick > 40 and not pet.petMeilv_skillpasv_casted then
    local skillpasv = pet.skills.PetMeilv_pasv
    if skillpasv then
      master:addBuff(skillpasv:createBuff(master), master)
      pet.petMeilv_skillpasv_casted = true
    end
  end
  if not pet.petMeilv_skillatk1_started and master.current_skill and master.current_skill.info.Manual then
    pet.petMeilv_skillatk1_started = true
    pet:setPosition({
      master.position[1] - 20,
      master.position[2] - 20
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
  if pet.petMeilv_skillatk1_started and not pet.petMeilv_skillatk1_casted then
    if not pet.petMeilv_skillatk1_countdown then
      pet.petMeilv_skillatk1_countdown = 0
    end
    pet.petMeilv_skillatk1_countdown = pet.petMeilv_skillatk1_countdown + dt
    if pet.petMeilv_skillatk1_countdown > 0.2 and pet.actor then
      pet.actor.node:setVisible(true)
    end
    if pet.petMeilv_skillatk1_countdown > 1.1 and not pet.petMeilv_skillatk1_casted then
      local skillatk1 = pet.skills.PetMeilv_atk1
      local skillatk2 = pet.skills.PetMeilv_atk2
      if skillatk1 then
        local newTarget = skillatk1:selectTarget(nil)
        if newTarget then
          pet:castSkill(skillatk1, newTarget)
        end
      end
      if skillatk2 then
        skillatk2:takeEffectOn(master)
      end
      pet.petMeilv_skillatk1_casted = true
    end
  end
  if pet.actor and pet.petMeilv_skillatk1_casted and (pet.action_name == "Idle" or pet.action_name == "Move") and not pet.petMeilv_skillatk1_invisible then
    pet.actor.node:setVisible(false)
    pet.petMeilv_skillatk1_invisible = true
    local effect_name = "eff_point_mirror_die.cha"
    ed.scene:playEffectOnScene(effect_name, {
      pet.position[1],
      pet.position[2] - 1
    }, {0.6, 0.6}, nil, 1)
  end
end

function PetMeilv.hero_reset(basefunc, pet)
  basefunc(pet)
  pet.petMeilv_buffadded = nil
  pet.petMeilv_skillpasv_casted = nil
  pet.petMeilv_firsttick = nil
  pet.petMeilv_skillatk1_countdown = nil
  pet.petMeilv_skillatk1_started = nil
  pet.petMeilv_skillatk1_casted = nil
  pet.petMeilv_skillatk1_invisible = nil
end

function PetMeilv.init_hero(hero)
  hero.update = override(hero.update, PetMeilv.hero_update)
  hero.reset = override(hero.reset, PetMeilv.hero_reset)
  local skillpasv = hero.skills.PetMeilv_pasv
  if skillpasv then
    skillpasv.createBuff = override(skillpasv.createBuff, PetMeilv.pasv_createBuff)
  end
  return hero
end

return PetMeilv.init_hero
