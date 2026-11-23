module("ed.battlehero", package.seeall)
local ed = ed
WorldBaltor = {}
WorldBaltor.ragelosthp = 600000
WorldBaltor.rage2losthp = 200000
WorldBaltor.stage2hp = 30000000
WorldBaltor.stage2ragelosthp = 400000

function WorldBaltor.reset(basefunc, hero)
  basefunc(hero)
  local bid = 4572
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = hero:addBuff(binfo, hero)
  buff.update = override(buff.update, WorldBaltor.rage_buff_update)
  hero.lastrageStack = 0
end

function WorldBaltor.rage_buff_update(basefunc, buff, dt)
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

function WorldBaltor.skillatk_start(basefunc, self, target)
  local info = self.info
  if do_battle_log then
    btlog("%s began to cast %s --> %s", self.caster:display(), self:display(), target and target:display() or "nil")
  end
  self.target = target
  self:selectTarget(target)
  self.cd_remaining = info.CD
  self.casting = true
  self.attack_counter = 0
  local ran = ed.rand()
  if ran < 0.5 then
    self:startPhase(1)
  else
    self:startPhase(2)
  end
  self.is_update = true
  local caster = self.caster
  caster.global_cd = info["Global CD"]
  caster:setMP(caster.mp - info["Cost MP"] * (1 - caster.attribs.CDR / 100))
  if caster.actor then
    local effect_name = info["Launch Effect"]
    if effect_name then
      caster.actor:addEffect(effect_name, -1)
    end
  end
end

function WorldBaltor.skillatk_onPhaseFinished(basefunc, self)
  self:finish()
end

function WorldBaltor.skillatk3_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  projectile.height = 30
  return projectile
end

function WorldBaltor.projectile_update(basefunc, projectile, dt)
  basefunc(projectile, dt)
  if projectile.totalTime then
    projectile.totalTime = projectile.totalTime + dt
    if projectile.totalTime > 0.8 then
      local v = 600
      local target = projectile.skill.target
      if not target then
        return
      end
      projectile:enableTrack(target)
      local targetpos = target.position
      local targetxyV = ed.edpSub(targetpos, projectile.position)
      local targetzV = -projectile.height + 40
      local u = (targetxyV[1] * targetxyV[1] + targetxyV[2] * targetxyV[2] + targetzV * targetzV) ^ (-0.5)
      local targetV = {
        targetxyV[1] * u,
        targetxyV[2] * u,
        targetzV * u
      }
      projectile.velocity[1] = projectile.velocity[1] + targetV[1] * v
      projectile.velocity[2] = projectile.velocity[2] + targetV[2] * v
      projectile.zSpeed = projectile.zSpeed + targetV[3] * v
      projectile.totalTime = nil
    end
  end
end

function WorldBaltor.skillatk2_takeEffectOn(basefunc, skill, target, source)
  if target.config and target.config.is_summoned then
    target:die()
    return false
  end
  return basefunc(skill, target, source)
end

function WorldBaltor.skillultbuff_onRemoved(basefunc, buff)
  if buff.shield and buff.shield > 0 then
    return basefunc(buff)
  else
    local boss = buff.owner
    local binfo
    local bid = 4573
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    for _ = 1, 2 do
      boss:addBuff(binfo, boss)
    end
  end
  return basefunc(buff)
end

function WorldBaltor.skillult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.onRemoved = override(buff.onRemoved, WorldBaltor.skillultbuff_onRemoved)
  return buff
end

function WorldBaltor.boss_update(basefunc, boss, dt)
  basefunc(boss, dt)
  if not boss.lastRageHp then
    boss.lastRageHp = boss.hp
    boss.rageStack = 0
  end
  if boss.attribs.HP - boss.hp < WorldBaltor.stage2hp then
    while boss.lastRageHp - boss.hp >= WorldBaltor.ragelosthp do
      local binfo
      local bid = 4573
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, boss, boss)
      boss:addBuff(buff, boss)
      boss.lastRageHp = boss.lastRageHp - WorldBaltor.ragelosthp
      boss.rageStack = boss.rageStack + 1
    end
  else
    if not boss.stage2ragebuff then
      local binfo
      local bid = 1604
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      boss.stage2ragebuff = boss:addBuff(binfo, boss)
      local binfo2
      local bid2 = 1620
      local binfo2 = ed.lookupDataTable("Buff", nil, bid2)
      boss:addBuff(binfo2, boss)
    end
    while boss.lastRageHp - boss.hp >= WorldBaltor.stage2ragelosthp do
      local binfo
      local bid = 4573
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, boss, boss)
      boss:addBuff(buff, boss)
      boss.lastRageHp = boss.lastRageHp - WorldBaltor.rage2losthp
      boss.rageStack = boss.rageStack + 1
    end
  end
end

function WorldBaltor.getLostHPAfterImmunity(basefunc, hero, damage, immunity, damage_type, source)
  local lost = basefunc(hero, damage, immunity, damage_type, source)
  if hero.hp > WorldBaltor.stage2hp and hero.hp - lost <= WorldBaltor.stage2hp then
    return hero.hp - WorldBaltor.stage2hp
  else
    return lost
  end
end

function WorldBaltor.init_hero(hero)
  hero.update = override(hero.update, WorldBaltor.boss_update)
  hero.reset = override(hero.reset, WorldBaltor.reset)
  hero.getLostHPAfterImmunity = override(hero.getLostHPAfterImmunity, WorldBaltor.getLostHPAfterImmunity)
  local skillult = hero.skills.WorldBaltor_ult
  skillult.createBuff = override(skillult.createBuff, WorldBaltor.skillult_createBuff)
  local skillatk = hero.skills.WorldBaltor_atk
  if skillatk then
    skillatk.start = override(skillatk.start, WorldBaltor.skillatk_start)
    skillatk.onPhaseFinished = override(skillatk.onPhaseFinished, WorldBaltor.skillatk_onPhaseFinished)
  end
  local skillatk2 = hero.skills.WorldBaltor_atk2
  if skillatk2 then
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, WorldBaltor.skillatk2_takeEffectOn)
  end
  local skillatk3 = hero.skills.WorldBaltor_atk3
  if skillatk3 then
    skillatk3.createProjectile = override(skillatk3.createProjectile, WorldBaltor.skillatk3_createProjectile)
  end
  return hero
end

return WorldBaltor.init_hero
