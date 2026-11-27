module("ed.battlehero", package.seeall)
local ed = ed
TitanJUGG = {}
TitanJUGG.ragelosthp = 35000
TitanJUGG.rage2losthp = 15000
TitanJUGG.stage2hp = 1750000
TitanJUGG.stage2ragelosthp = 7500

function TitanJUGG.arcana_power(basefunc, skill, source, target, damage_type)
  local power = basefunc(skill, source, target, damage_type)
  local caster = skill.caster
  power = power * 1.25
  return power
end

function TitanJUGG.skillult_start(basefunc, skill, target)
  local caster = skill.caster
  local bid1 = 11014810
  local binfo1 = ed.lookupDataTable("Buff", nil, bid1)
  caster:addBuff(binfo1, caster)
  basefunc(skill, target)
end

function TitanJUGG.skillult_finish(basefunc, skill, target)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 11014810 then
      tbuff.timer = -1
    end
  end
  if caster.TitanJUGG_hasArcana and caster.TitanJUGG_hasArcana > 3 then
    local bid = 4615
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    caster:addBuff(binfo, caster)
  end
  basefunc(skill, target)
  if caster.manually_casting then
    ed.engine:unfreeze()
    caster.manually_casting = false
  end
end

function TitanJUGG.skillult_projectile_hit(basefunc, projectile, target)
  local skill = projectile.skill
  if target == skill.target then
    basefunc(projectile, target)
    projectile:terminate()
  end
end

function TitanJUGG.skillult_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  projectile.hit = override(projectile.hit, TitanJUGG.skillult_projectile_hit)
  return projectile
end

function TitanJUGG.skillatk2_start(basefunc, skill, target)
  local caster = skill.caster
  caster.skillatk2_casting = true
  basefunc(skill, target)
end

function TitanJUGG.skillatk2_finish(basefunc, skill, target)
  local caster = skill.caster
  if caster.skillatk2_casting then
    caster.skillatk2_casting = false
  end
  basefunc(skill, target)
end

function TitanJUGG.skillatk2_onPhaseFinished(basefunc, skill)
  local caster = skill.caster
  local target = skill.target
  if target == nil or not skill.target:isAlive() then
    skill:selectTarget(nil)
  end
  if not target then
    skill:interrupt()
    return
  end
  if skill.current_phase_idx == 1 then
    skill.startPos = {
      caster.position[1],
      caster.position[2]
    }
    skill.startDir = caster.direction
    if target and target:isAlive() then
      local moveDir = skill.target.position[1] > caster.position[1] and -1 or 1
      caster:setPosition({
        skill.target.position[1] + moveDir * 75,
        skill.target.position[2]
      })
    end
    basefunc(skill)
  else
    basefunc(skill)
  end
end

function TitanJUGG.skillatk2_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local target = skill.target
  local mp_lost = 0
  if caster.TitanJUGG_hasArcana > 1 then
    mp_lost = 100
  end
  local attack_counter = skill.attack_counter
  if target and target:isAlive() then
    local old_position = target.position[2]
    if attack_counter == 0 then
      local bid = 11014806
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      caster:addBuff(binfo, caster)
      skill.attack_counter = skill.attack_counter + 1
    elseif skill.attack_counter == 1 then
      skill:takeEffectAt(target.position, caster)
      caster.notPopupBattleInfo = true
      caster:takeHeal(150, "mp", skill.caster)
      caster.notPopupBattleInfo = false
      if caster.TitanJUGG_hasArcana > 1 then
        target:takeDamage(mp_lost, "Holy", "mp", caster, 1, 1, true)
      end
      skill.attack_counter = skill.attack_counter + 1
    elseif skill.attack_counter == 2 then
      target.position[2] = old_position
      local skillatk2s = caster.skills.TitanJUGG_atk2s
      if skillatk2s then
        skillatk2s:takeEffectAt(target.position, caster)
        caster.notPopupBattleInfo = true
        caster:takeHeal(150, "mp", skill.caster)
        caster.notPopupBattleInfo = false
        if caster.TitanJUGG_hasArcana > 1 then
          target:takeDamage(mp_lost, "Holy", "mp", caster, 1, 1, true)
        end
        skill.attack_counter = skill.attack_counter + 1
      end
    end
  end
end

function TitanJUGG.hero_reset(basefunc, hero)
  hero.skillatk2_casting = false
  basefunc(hero)
  hero.ArcanaCount = 0
  if hero.TitanJUGG_hasArcana > 2 then
    hero.ArcanaCount = hero.ArcanaCount + 1
  end
  if hero.TitanJUGG_hasArcana > 2 then
    local bid = 4617
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, hero, hero)
    hero:addBuff(buff, hero)
    buff.onDamaged = override(buff.onDamaged, TitanJUGG.buffonDamaged)
  end
  local bid = 4572
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = hero:addBuff(binfo, hero)
  buff.update = override(buff.update, TitanJUGG.rage_buff_update)
  hero.lastrageStack = 0
end

function TitanJUGG.hero_handleUnitDieEvent(basefunc, self, unit, killer_unit)
  basefunc(self, unit, killer_unit)
  if unit and self.TitanJUGG_hasArcana > 2 and unit ~= self and not unit.config.is_summoned and unit.camp == self.camp then
    self.ArcanaCount = self.ArcanaCount + 1
  end
end

function TitanJUGG.buffonDamaged(basefunc, buff, damage, damage_type, source)
  local owner = buff.owner
  local defence, dd, dc, immunity, crit
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
  local lastdamage = owner:getLostHPAfterImmunity(damage, immunity, damage_type, source)
  if not (not (lastdamage < owner.hp) and owner:isAlive()) or 0 >= owner.ArcanaCount or owner.TitanJUGG_hasArcana < 3 then
    return damage
  elseif lastdamage >= owner.hp and owner.TitanJUGG_hasArcana > 2 and 0 < owner.ArcanaCount and not owner.config.is_boss then
    damage = 0
    local hp = 0.2 * owner.attribs.HP
    owner:takeHeal(hp, "hp", owner)
    owner.ArcanaCount = owner.ArcanaCount - 1
    local bid = 4646
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    owner:addBuff(binfo, owner)
    return damage
  else
    return damage
  end
end

function TitanJUGG.onDying(basefunc, self, killer)
  local unrebirth = ed.engine.guildInstance_mode and self.camp == ed.emCampEnemy
  if self.TitanJUGG_hasArcana > 2 and self.ArcanaCount > 0 and not unrebirth and not self.config.is_summoned and (not self.config.is_boss or ed.engine.babelMode) then
    self.ArcanaCount = self.ArcanaCount - 1
    self.state = ed.emUnitState_Birth
    self.can_cast_manual = false
    self.walk_v = {0, 0}
    self.hp = 0.3 * self.attribs.HP
    self.mp = 0
    local bid = 4645
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    self:addBuff(binfo, self)
  else
    basefunc(self, killer)
  end
end

function TitanJUGG.getRuntimeScale(basefunc, self)
  local scale = 1
  return self.direction * scale, scale
end

function TitanJUGG.skillatk_finish(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local skillatk4 = caster.skills.TitanJUGG_atk4
  local skillatk2 = caster.skills.TitanJUGG_atk2
  local Patk = skillatk4.info["Script Arg2"] / 100
  local Patk2 = skillatk4.info["Script Arg3"] / 100
  local p = ed.rand()
  if Patk2 > p then
    caster.global_cd = 0
    skillatk2.cd_remaining = 0
  elseif Patk > p then
    caster.global_cd = 0
    skill.cd_remaining = 0
  end
end

function TitanJUGG.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  if not hero.lastRageHp then
    hero.lastRageHp = hero.hp
    hero.rageStack = 0
  end
  if hero.attribs.HP - hero.hp < TitanJUGG.stage2hp then
    while hero.lastRageHp - hero.hp >= TitanJUGG.ragelosthp do
      local binfo
      local bid = 4573
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, hero, hero)
      hero:addBuff(buff, hero)
      hero.lastRageHp = hero.lastRageHp - TitanJUGG.ragelosthp
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
    while hero.lastRageHp - hero.hp >= TitanJUGG.stage2ragelosthp do
      local binfo
      local bid = 4573
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, hero, hero)
      hero:addBuff(buff, hero)
      hero.lastRageHp = hero.lastRageHp - TitanJUGG.rage2losthp
      hero.rageStack = hero.rageStack + 1
    end
  end
end

function TitanJUGG.rage_buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local owner = buff.owner
  if owner.lastrageStack and owner.rageStack and owner.lastrageStack ~= owner.rageStack then
    buff:setAttribute("AD", 300 * owner.rageStack ^ 1.1)
    buff:setAttribute("AP", 350 * owner.rageStack ^ 1.1)
    buff:setAttribute("ARM", 10 * owner.rageStack ^ 1.1)
    buff:setAttribute("MR", 5 * owner.rageStack ^ 1.1)
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

function TitanJUGG.init_hero(hero)
  local skillult = hero.skills.TitanJUGG_ult
  local skillatk = hero.skills.TitanJUGG_atk
  local skillatk2s = hero.skills.TitanJUGG_atk2s
  local skillatk2 = hero.skills.TitanJUGG_atk2
  local skillatk3 = hero.skills.TitanJUGG_atk3
  local skillatk4 = hero.skills.TitanJUGG_atk4
  hero.TitanJUGG_hasArcana = ed.getProtoArcanaLevel(hero.proto)
  hero.reset = override(hero.reset, TitanJUGG.hero_reset)
  hero.update = override(hero.update, TitanJUGG.hero_update)
  if skillult then
    if hero.TitanJUGG_hasArcana and hero.TitanJUGG_hasArcana > 3 then
      skillult.power = override(skillult.power, TitanJUGG.arcana_power)
    end
    skillult.start = override(skillult.start, TitanJUGG.skillult_start)
    skillult.finish = override(skillult.finish, TitanJUGG.skillult_finish)
    skillult.createProjectile = override(skillult.createProjectile, TitanJUGG.skillult_createProjectile)
  end
  if skillatk2 then
    skillatk2.onPhaseFinished = override(skillatk2.onPhaseFinished, TitanJUGG.skillatk2_onPhaseFinished)
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, TitanJUGG.skillatk2_onAttackFrame)
    skillatk2.start = override(skillatk2.start, TitanJUGG.skillatk2_start)
    skillatk2.finish = override(skillatk2.finish, TitanJUGG.skillatk2_finish)
  end
  if skillatk3 then
  end
  if skillatk4 and skillatk then
    skillatk.finish = override(skillatk.finish, TitanJUGG.skillatk_finish)
  end
  return hero
end

return TitanJUGG.init_hero
