module("ed.battlehero", package.seeall)
local ed = ed
WorldGA = {}
WorldGA.ragelosthp = 600000
WorldGA.stage2hp = 30000000
WorldGA.rage2losthp = 200000
WorldGA.stage2ragelosthp = 400000

function WorldGA.hero_takeDamage(basefunc, hero, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
  local amount = struct_table
  if type(struct_table) == "table" then
    damage_type = struct_table.damage_type
    field = struct_table.field
    source = struct_table.source
    coefficient = struct_table.coefficient
    crit_mod = struct_table.crit_mod
    amount = struct_table.amount
  end
  field = field or "hp"
  coefficient = coefficient or 1
  crit_mod = crit_mod or 1
  local lost = basefunc(hero, amount, damage_type, field, source, coefficient, crit_mod, transferred)
  if damage_type == "AD" then
    local skillult = hero.skills.WorldGA_ult
    if skillult and hero.name ~= "Rubick" then
      if ed.run_with_scene then
        local effect_night = "eff_point_GA_ult_1.cha"
        local origin = hero.position
        ed.scene:playEffectOnScene(effect_night, origin, nil, nil, 1)
      end
      hero.GA_atk2_AD = hero.GA_atk2_AD + 1
      for i, tbuff in ipairs(hero.buff_list) do
        if tbuff.info.ID == 510 and tbuff.caster == hero then
          hero.GA_atk2_AD = hero.GA_atk2_AD + 1
          break
        end
      end
    end
  elseif damage_type == "AP" then
    local skillult = hero.skills.WorldGA_ult
    if skillult and hero.name ~= "Rubick" then
      if ed.run_with_scene then
        local effect_night = "eff_point_GA_ult_2.cha"
        local origin = hero.position
        ed.scene:playEffectOnScene(effect_night, origin, nil, nil, 0)
      end
      hero.GA_atk2_AP = hero.GA_atk2_AP + 1
      for i, tbuff in ipairs(hero.buff_list) do
        if tbuff.info.ID == 510 and tbuff.caster == hero then
          hero.GA_atk2_AP = hero.GA_atk2_AP + 1
          break
        end
      end
    end
  end
  return lost
end

function WorldGA.hero_handleUnitDieEventToAll(basefunc, self, unit, killer_unit)
  basefunc(self, unit, killer_unit)
  local skillult = self.skills.WorldGA_ult
  if skillult and not unit.config.is_summoned and self.name ~= "Rubick" and self:isAlive() then
    if ed.run_with_scene then
      local effect_night = "eff_point_GA_ult_3.cha"
      local origin = self.position
      ed.scene:playEffectOnScene(effect_night, origin, nil, nil, 1)
    end
    self.GA_atk2_SOUL = self.GA_atk2_SOUL + 1
    for i, tbuff in ipairs(self.buff_list) do
      if tbuff.info.ID == 510 and tbuff.caster == self then
        self.GA_atk2_SOUL = self.GA_atk2_SOUL + 1
        break
      end
    end
  end
end

function WorldGA.skillatk3_takeEffectAt(basefunc, skill, location, source)
  local caster = skill.caster
  local originfo = skill.info
  if skill.attack_counter == 1 then
    basefunc(skill, location, source)
  else
    local skillatk3_1 = caster.skills.WorldGA_atk3_1
    if skillatk3_1 then
      skillatk3_1:takeEffectAt(caster.position)
      skill.caster.GA_atk2_LOSE = skill.caster.GA_atk2_LOSE + 1
    end
  end
end

function WorldGA.skillatk3_1_takeEffectOn(basefunc, skill, target)
  local originfo = skill.info
  for i, tbuff in ipairs(target.buff_list) do
    if tbuff.info.ID == 511 then
      local buff = tbuff
      skill.info = ed.wraptable(originfo, {
        ["Knock Up"] = 0.15,
        ["Knock Back"] = 10,
        ["Plus Ratio"] = 0.85
      })
    end
  end
  basefunc(skill, target)
  skill.info = originfo
end

function WorldGA.skillatk2_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  projectile.height = 50
  projectile:enableJump(999)
  projectile:enableTrack(skill.target)
  skill.atk2_projectile = projectile
  return projectile
end

function WorldGA.skillatk2_takeEffectOn(basefunc, skill, target)
  local orig_mp = target.mp
  local orig_hp = target.hp
  local hp_percent = orig_hp / target.attribs.HP
  local mp_percent = orig_mp / 1000
  if hp_percent > mp_percent then
    local losthp = (hp_percent - mp_percent) * target.attribs.HP
    if losthp > target.attribs.HP * 0.5 then
      losthp = target.attribs.HP * 0.5
    end
    if losthp > skill.info["Script Arg3"] then
      losthp = skill.info["Script Arg3"]
    end
    local getmp = losthp / target.attribs.HP * 1000 - skill.level * 2
    if getmp <= 1 then
      getmp = 1
    end
    skill.BossGA_atk2target_position = {
      target.position[1],
      target.position[2]
    }
    skill.BossGA_atk2target_height = target.height
    target:takeDamage(losthp / skill.caster.attribs.PDM, "Holy", "hp", skill.caster, 1, 1)
    skill.caster.GA_atk2_LOSE = skill.caster.GA_atk2_LOSE + 1
    if ed.run_with_scene then
      local effect_night = "eff_impact_GA_atk2.cha"
      local origin = target.position
      ed.scene:playEffectOnScene(effect_night, origin, nil, nil, 1)
    end
  else
    basefunc(skill, target)
    skill.atk2_projectile.jumps = -1
    skill.atk2_projectile:terminate()
  end
end

function WorldGA.atk4_buff_onRemoved(basefunc, buff)
  local caster = buff.caster
  local skillatk4_1 = caster.skills.WorldGA_atk4_1
  if skillatk4_1 then
    skillatk4_1.cd_remaining = 999
  end
  local skillatk = caster.skills.WorldGA_atk
  if skillatk then
    skillatk.cd_remaining = 0
  end
  basefunc(buff)
end

function WorldGA.skillatk4_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  buff.onRemoved = override(buff.onRemoved, WorldGA.atk4_buff_onRemoved)
  local skillawake = owner.skills.WorldGA_awake
  if skillawake then
    local AP = skillawake.level * skillawake.info["Growth 1 Value"]
    local HPR = skillawake.level * skillawake.info["Growth 2 Value"]
    buff:setAttribute("AP", AP)
    buff:setAttribute("HPR", HPR)
  end
  local skillatk4_1 = owner.skills.WorldGA_atk4_1
  if skillatk4_1 then
    skillatk4_1.cd_remaining = 0
  end
  local skillatk = owner.skills.WorldGA_atk
  if skillatk then
    skillatk.cd_remaining = 999
  end
  return buff
end

function WorldGA.skillult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  if skill.caster.GA_atk2_type == "AD" then
    buff:setAttribute("Control Effects", {"disarm"})
    buff:setAttribute("Effect", "eff_buff_Earth_atk2.cha")
  elseif skill.caster.GA_atk2_type == "AP" then
    buff:setAttribute("Control Effects", {"silence"})
    buff:setAttribute("Effect", "eff_buff_silence.cha")
  elseif skill.caster.GA_atk2_type == "SOUL" then
    buff:setAttribute("HAST", -5)
    buff:setAttribute("MSPD", -68)
  end
  return buff
end

function WorldGA.skillult_start(basefunc, skill, target)
  local caster = skill.caster
  local skillult2 = caster.skills.WorldGA_ult2
  if skillult2 then
    skillult2:takeEffectOn(caster)
  end
  basefunc(skill, target)
end

function WorldGA.skillult_takeEffectOn(basefunc, skill, target)
  basefunc(skill, target)
  if skill.caster.GA_atk2_type == "AD" then
    local bid = 507
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = target:addBuff(binfo, skill.caster)
  elseif skill.caster.GA_atk2_type == "AP" then
    local bid = 508
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = target:addBuff(binfo, skill.caster)
  elseif skill.caster.GA_atk2_type == "SOUL" then
    local bid = 509
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = target:addBuff(binfo, skill.caster)
  end
end

function WorldGA.skillult_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  if attack_counter == 1 then
    local potion_type
    if skill.caster.GA_atk2_AD > skill.caster.GA_atk2_AP * 3 and skill.caster.GA_atk2_AD > skill.caster.GA_atk2_SOUL * 9 then
      potion_type = "AD"
    elseif skill.caster.GA_atk2_AP * 3 > skill.caster.GA_atk2_AD and skill.caster.GA_atk2_AP * 3 > skill.caster.GA_atk2_SOUL * 9 then
      potion_type = "AP"
    else
      potion_type = "SOUL"
    end
    local num = skill.caster.GA_atk2_AD + skill.caster.GA_atk2_AP + skill.caster.GA_atk2_SOUL
    local ratio = 0.5 + num * 0.004 + skill.caster.GA_atk2_SOUL * 2
    local originfo = skill.info
    skill.info = ed.wraptable(originfo, {
      ["Plus Ratio"] = ratio,
      ["Point Effect"] = "eff_point_GA_ult_" .. potion_type .. ".cha"
    })
    skill.caster.GA_atk2_type = potion_type
    basefunc(skill)
    skill.info = originfo
    skill.caster.GA_atk2_AP = 0
    skill.caster.GA_atk2_AD = 0
    skill.caster.GA_atk2_SOUL = 0
  elseif attack_counter == 0 then
    if skill.caster.manually_casting and skill.attack_counter == 0 then
      ed.engine:unfreeze()
      skill.caster.manually_casting = false
    end
    skill.attack_counter = skill.attack_counter + 1
  end
end

function WorldGA.skillult_finish(basefunc, skill)
  basefunc(skill)
  for i, tbuff in ipairs(skill.caster.buff_list) do
    if tbuff.info.ID == 510 then
      local buff = tbuff
      buff.timer = 0
    end
  end
end

function WorldGA.reset(basefunc, hero)
  basefunc(hero)
  hero.GA_atk2_AP = 0
  hero.GA_atk2_AD = 0
  hero.GA_atk2_SOUL = 0
  hero.GA_atk2_LOSE = 0
  hero.GA_atk2_type = nil
  local bid = 4572
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = hero:addBuff(binfo, hero)
  buff.update = override(buff.update, WorldGA.rage_buff_update)
  hero.lastrageStack = 0
end

function WorldGA.rage_buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local owner = buff.owner
  if owner.lastrageStack and owner.rageStack and owner.lastrageStack ~= owner.rageStack then
    buff:setAttribute("AD", 700 * owner.rageStack ^ 1.1)
    buff:setAttribute("AP", 750 * owner.rageStack ^ 1.1)
    buff:setAttribute("ARM", 150 * owner.rageStack ^ 1.1)
    buff:setAttribute("MR", 150 * owner.rageStack ^ 1.1)
    buff:setAttribute("CRIT", 50 * owner.rageStack)
    buff:setAttribute("MCRIT", 10 * owner.rageStack)
    if owner.rageStack > 50 then
      buff:setAttribute("PIMU", 1 * (owner.rageStack - 50))
      buff:setAttribute("MIMU", 1 * (owner.rageStack - 50))
      buff:setAttribute("AD", 220 * owner.rageStack ^ 1.2)
      buff:setAttribute("AP", 250 * owner.rageStack ^ 1.2)
      buff:setAttribute("ARM", 8 * owner.rageStack ^ 1.2)
      buff:setAttribute("MR", 4 * owner.rageStack ^ 1.2)
      buff:setAttribute("CRIT", 50 * owner.rageStack)
      buff:setAttribute("MCRIT", 10 * owner.rageStack)
    end
    owner:resetBuffApply(buff)
    owner.lastrageStack = owner.rageStack
  end
end

function WorldGA.update(basefunc, hero, dt)
  basefunc(hero, dt)
  if not hero.lastRageHp then
    hero.lastRageHp = hero.hp
    hero.rageStack = 0
  end
  if hero.attribs.HP - hero.hp < WorldGA.stage2hp then
    while hero.lastRageHp - hero.hp >= WorldGA.ragelosthp do
      local binfo
      local bid = 4573
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, hero, hero)
      hero:addBuff(buff, hero)
      hero.lastRageHp = hero.lastRageHp - WorldGA.ragelosthp
      hero.rageStack = hero.rageStack + 1
    end
  else
    if not hero.stage2ragebuff then
      local binfo
      local bid = 1604
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      hero.stage2ragebuff = hero:addBuff(binfo, hero)
      local binfo2
      local bid2 = 1620
      local binfo2 = ed.lookupDataTable("Buff", nil, bid2)
      hero:addBuff(binfo2, hero)
    end
    while hero.lastRageHp - hero.hp >= WorldGA.stage2ragelosthp do
      local binfo
      local bid = 4573
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, hero, hero)
      hero:addBuff(buff, hero)
      hero.lastRageHp = hero.lastRageHp - WorldGA.rage2losthp
      hero.rageStack = hero.rageStack + 1
    end
  end
end

function WorldGA.getLostHPAfterImmunity(basefunc, hero, damage, immunity, damage_type, source)
  local lost = basefunc(hero, damage, immunity, damage_type, source)
  if hero.hp > WorldGA.stage2hp and hero.hp - lost <= WorldGA.stage2hp then
    return hero.hp - WorldGA.stage2hp
  else
    return lost
  end
end

function WorldGA.init_hero(hero)
  hero.reset = override(hero.reset, WorldGA.reset)
  hero.getLostHPAfterImmunity = override(hero.getLostHPAfterImmunity, WorldGA.getLostHPAfterImmunity)
  hero.handleUnitDieEventToAll = override(hero.handleUnitDieEventToAll, WorldGA.hero_handleUnitDieEventToAll)
  hero.takeDamage = override(hero.takeDamage, WorldGA.hero_takeDamage)
  hero.update = override(hero.update, WorldGA.update)
  local skillatk3 = hero.skills.WorldGA_atk3
  if skillatk3 then
    skillatk3.takeEffectAt = override(skillatk3.takeEffectAt, WorldGA.skillatk3_takeEffectAt)
  end
  local skillatk3_1 = hero.skills.WorldGA_atk3_1
  if skillatk3_1 then
    skillatk3_1.takeEffectOn = override(skillatk3_1.takeEffectOn, WorldGA.skillatk3_1_takeEffectOn)
  end
  local skillatk2 = hero.skills.WorldGA_atk2
  if skillatk2 then
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, WorldGA.skillatk2_takeEffectOn)
    skillatk2.createProjectile = override(skillatk2.createProjectile, WorldGA.skillatk2_createProjectile)
  end
  local skillatk4 = hero.skills.WorldGA_atk4
  if skillatk4 then
    skillatk4.createBuff = override(skillatk4.createBuff, WorldGA.skillatk4_createBuff)
  end
  local skillult = hero.skills.WorldGA_ult
  if skillult then
    skillult.start = override(skillult.start, WorldGA.skillult_start)
    skillult.onAttackFrame = override(skillult.onAttackFrame, WorldGA.skillult_onAttackFrame)
    skillult.finish = override(skillult.finish, WorldGA.skillult_finish)
    skillult.createBuff = override(skillult.createBuff, WorldGA.skillult_createBuff)
  end
  return hero
end

return WorldGA.init_hero
