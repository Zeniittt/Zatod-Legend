module("ed.battlehero", package.seeall)
local ed = ed
WorldSven = {}
WorldSven.ragelosthp = 600000
WorldSven.rage2losthp = 200000
WorldSven.buffID = "WorldSven_ult"
WorldSven.stage2hp = 30000000
WorldSven.stage2ragelosthp = 400000

function WorldSven.reset(basefunc, hero)
  basefunc(hero)
  hero.direction = -1
  hero.position[1] = 700
  hero.position[2] = 0
  local bid = 4572
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = hero:addBuff(binfo, hero)
  buff.update = override(buff.update, WorldSven.rage_buff_update)
  hero.lastrageStack = 0
end

function WorldSven.rage_buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local owner = buff.owner
  if owner.lastrageStack and owner.rageStack and owner.lastrageStack ~= owner.rageStack then
    buff:setAttribute("AD", 700 * owner.rageStack ^ 1.3)
    buff:setAttribute("AP", 750 * owner.rageStack ^ 1.3)
    buff:setAttribute("ARM", 150 * owner.rageStack ^ 1.3)
    buff:setAttribute("MR", 150 * owner.rageStack ^ 1.3)
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

function WorldSven.skillult_buffOnRemoved(basefunc, buff)
  buff.owner[WorldSven.buffID] = nil
  local caster = buff.caster
  if caster.changePeriod_Sven then
    if ed.protoAwake(caster.proto, 186) then
      caster:enterActionStageFromOneStage(3, 186)
    else
      caster:enterActionStageFromOneStage(1, 186)
    end
    if ed.run_with_scene then
      local effect_name = "eff_impact_Lion_atk3.cha"
      local origin = caster.position
      local effect_z = 1
      ed.scene:playEffectOnScene(effect_name, origin, {
        caster.direction,
        1
      }, nil, effect_z)
    end
    caster.changePeriod_Sven = nil
    caster.ultBuff_Sven = false
    if ed.run_with_scene then
      local panel = caster.heroPanel
      if panel then
        if ed.protoAwake(caster.proto, 186) then
          panel:setPortrait("UI/DOTA-HERO/SwitchSven.png")
        else
          panel:setPortrait("UI/DOTA-HERO/SwitchSven.png")
        end
      end
    end
    local skillatk = caster.skills.WorldSven_atk
    if skillatk then
      skillatk.cd_remaining = 3
    end
  end
  basefunc(buff)
end

function WorldSven.skillult_createBuff(basefunc, skill, target)
  local caster = skill.caster
  local attack_counter = skill.attack_counter
  if attack_counter == 1 then
    caster.changePeriod_Sven = true
  end
  local buff = basefunc(skill, target)
  buff.onRemoved = override(buff.onRemoved, WorldSven.skillult_buffOnRemoved)
  target[WorldSven.buffID] = buff
  return buff
end

function WorldSven.skillult_canCastWithTarget(basefunc, skill, target)
  local caster = skill.caster
  if caster[WorldSven.buffID] then
    return false
  end
  return basefunc(skill, target)
end

function WorldSven.skillult_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  if caster.changePeriod_Sven then
    if ed.protoAwake(caster.proto, 186) then
      local binfo
      local bid = 831
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      caster:addBuff(binfo, caster)
      caster:enterActionStageFromOneStage(4, 186)
    else
      local binfo
      local bid = 831
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      caster:addBuff(binfo, caster)
      caster:enterActionStageFromOneStage(2, 186)
    end
  end
  if ed.run_with_scene then
    local panel = caster.heroPanel
    if panel then
      if ed.protoAwake(caster.proto, 186) then
        panel:setPortrait("UI/DOTA-HERO/SwitchSven_s.png")
      else
        panel:setPortrait("UI/DOTA-HERO/SwitchSven_s.png")
      end
    end
  end
  local skillatk3 = caster.skills.WorldSven_atk3
  local skillatk = caster.skills.WorldSven_atk
  if skillatk3 and skillatk then
    skillatk.cd_remaining = 999
  end
end

function WorldSven.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  local caster = hero
  local boss = hero
  local skillatk = caster.skills.WorldSven_atk
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 831 then
      for i, pbuff in ipairs(caster.buff_list) do
        if pbuff.info.ID == 202 and not caster.undoom then
          if skillatk then
            skillatk.cd_remaining = 1
          end
          caster.undoom = true
          break
        end
      end
    end
  end
  if not boss.lastRageHp then
    boss.lastRageHp = boss.hp
    boss.lastRageHp = boss.hp
    boss.rageStack = 0
  end
  if hero.attribs.HP - hero.hp < WorldSven.stage2hp then
    while boss.lastRageHp - boss.hp >= WorldSven.ragelosthp do
      local binfo
      local bid = 4573
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, boss, boss)
      boss:addBuff(buff, boss)
      boss.lastRageHp = boss.lastRageHp - WorldSven.ragelosthp
      boss.rageStack = boss.rageStack + 1
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
    while hero.lastRageHp - hero.hp >= WorldSven.stage2ragelosthp do
      local binfo
      local bid = 4573
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, hero, hero)
      hero:addBuff(buff, hero)
      hero.lastRageHp = hero.lastRageHp - WorldSven.rage2losthp
      boss.rageStack = boss.rageStack + 1
    end
  end
end

function WorldSven.getLostHPAfterImmunity(basefunc, hero, damage, immunity, damage_type, source)
  local lost = basefunc(hero, damage, immunity, damage_type, source)
  if hero.hp > WorldSven.stage2hp and hero.hp - lost <= WorldSven.stage2hp then
    return hero.hp - WorldSven.stage2hp
  else
    return lost
  end
end

function WorldSven.skillult_onAttackFrame(basefunc, self)
  local attack_counter = self.attack_counter
  if self.caster.manually_casting and self.attack_counter == 1 then
    ed.engine:unfreeze()
    self.caster.manually_casting = false
    self.attack_counter = self.attack_counter + 1
  else
    if attack_counter == 0 and ed.run_with_scene then
      ed.scene:startCameraShakeAnimationY(3, 1.2, 10)
    end
    self.attack_counter = self.attack_counter + 1
    if self.info["Target Type"] == "random" or self.target == nil or not self.target:isAlive() then
      self:selectTarget(nil)
    end
    if not self.target then
      return
    end
    local info = self.info
    local caster = self.caster
    local ttype = info["Track Type"]
    if ttype == "projectile" then
      local projectile = self:createProjectile()
      ed.engine:addProjectile(projectile)
    elseif ttype == "chain" then
      local chain = self:createChain()
      ed.engine:addChain(chain)
    elseif ttype == nil then
      self:takeEffectAt(self.target.position)
    else
      EDDebug("Unkonwn Track Type: '" .. ttype .. "'")
    end
    caster:setMP(caster.mp + info["Gain MP"] * ed.engine.mp_bonus)
    if info["Move Forward"] ~= 0 then
      caster.position[1] = caster.position[1] + info["Move Forward"] * caster.direction
    end
  end
end

function WorldSven.sillatk2_createProjectile(basefunc, skill)
  local target = skill.target
  local projectile = basefunc(skill, target)
  projectile:enableTrack(target)
  ed.engine:addProjectile(projectile)
end

function WorldSven.skillatk3_getDamage(basefunc, self, target, power, damage_type, field, source, crit_mod)
  local caster = self.caster
  local skill = caster.skills.WorldSven_atk3
  local distanceSQ = (target.position[1] - caster.position[1]) ^ 2 + (target.position[2] - caster.position[2]) ^ 2
  if distanceSQ > skill.info["Max Range"] ^ 2 then
    power = power * 5
  end
  local dmg = target:takeDamage({
    amount = power,
    damage_type = damage_type,
    field = field,
    source = source,
    crit_mod = crit_mod,
    skill = self
  })
  return dmg
end

function WorldSven.init_hero(hero)
  hero:setActionStageChangeByManual(true)
  hero.update = override(hero.update, WorldSven.hero_update)
  hero.reset = override(hero.reset, WorldSven.reset)
  hero.getLostHPAfterImmunity = override(hero.getLostHPAfterImmunity, WorldSven.getLostHPAfterImmunity)
  if ed.protoAwake(hero.proto, 186) then
    hero:enterActionStageFromOneStage(3, 186)
  end
  local skillult = hero.skills.WorldSven_ult
  if skillult then
    skillult.createBuff = override(skillult.createBuff, WorldSven.skillult_createBuff)
    skillult.finish = override(skillult.finish, WorldSven.skillult_finish)
    skillult.canCastWithTarget = override(skillult.canCastWithTarget, WorldSven.skillult_canCastWithTarget)
    skillult.onAttackFrame = override(skillult.onAttackFrame, WorldSven.skillult_onAttackFrame)
  end
  local skillatk2 = hero.skills.WorldSven_atk2
  if skillatk2 then
    skillatk2.createProjectile = override(skillatk2.createProjectile, WorldSven.sillatk2_createProjectile)
  end
  local skillatk3 = hero.skills.WorldSven_atk3
  if skillatk3 then
    skillatk3.getDamage = override(skillatk3.getDamage, WorldSven.skillatk3_getDamage)
  end
  return hero
end

return WorldSven.init_hero
