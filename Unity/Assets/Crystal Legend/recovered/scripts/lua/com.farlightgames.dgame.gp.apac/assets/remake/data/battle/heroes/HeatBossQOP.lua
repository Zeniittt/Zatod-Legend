module("ed.battlehero", package.seeall)
local ed = ed
HeatBossQOP = {}
HeatBossQOP.atk3buff = 10036501
HeatBossQOP.atk3Evobuff = 10036503
HeatBossQOP.atk3shardbuff = 10036504
HeatBossQOP.enchbuff = 10036505
HeatBossQOP.dyingbuff = 10036506
HeatBossQOP.strengthen = 10036509
HeatBossQOP.uncontrollable = 10036510

function HeatBossQOP.skillatk2_createProjectile(basefunc, skill)
  local caster = skill.caster
  local origTarget = skill.target
  local counter = 0
  local maxcounter = 0
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 20050101 then
      maxcounter = 1
    end
    if tbuff.info.ID == 20050102 then
      maxcounter = 2
    end
    if tbuff.info.ID == 20050103 then
      maxcounter = 3
    end
    if tbuff.info.ID == 20050104 then
      maxcounter = 4
    end
  end
  local projectile = basefunc(skill, origTarget)
  projectile.dmgModifier = 1
  projectile:enableTrack(origTarget)
  ed.engine:addProjectile(projectile)
  for unit in ed.engine:foreachAliveUnit(skill:affectedCamp()) do
    if counter >= maxcounter then
      break
    end
    if unit.buff_effects.untargetable then
    elseif unit.buffManager.invisible and unit.camp ~= skill.caster.camp then
    elseif unit == origTarget then
    else
      counter = counter + 1
      skill.target = unit
      local projectile = basefunc(skill, unit)
      projectile:enableTrack(unit)
      ed.engine:addProjectile(projectile)
    end
  end
end

function HeatBossQOP.skillatk3_start(basefunc, skill, target)
  basefunc(skill, target)
  local bid = HeatBossQOP.atk3buff
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local caster = skill.caster
  caster:addBuff(binfo, caster)
  caster.oriposition = caster.position
end

function HeatBossQOP.skillatk3_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == HeatBossQOP.atk3buff then
      local buff = tbuff
      buff.timer = -1
    end
  end
end

function HeatBossQOP.skillatk3_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  local hero = skill.caster
  local target = skill.target
  if attack_counter == 0 then
    local DOPPosition = HeatBossQOP.DOP_in_battlefield(hero, 130, hero.foecamp)
    hero.position = DOPPosition
    skill.attack_counter = skill.attack_counter + 1
  elseif attack_counter == 1 then
    basefunc(skill)
  elseif attack_counter == 2 then
    hero.position = hero.oriposition
    skill.attack_counter = skill.attack_counter + 1
  end
end

function HeatBossQOP.DOP_in_battlefield(caster, radius, camp)
  local position = {400, 0}
  local count = 0
  local maxcount = 0
  local distance = 0
  local mindistance = 9999
  for x = 0, 800, 25 do
    for y = -100, 100, 25 do
      for unit in ed.engine:foreachAliveUnit(camp) do
        local unitdistance = ed.edpDistanceSQ({x, y}, unit.position)
        if (unit.buffManager.invisible or unit.buff_effects.untargetable or unit.buff_effects.invulnerable) and unit.camp ~= caster.camp then
        elseif unitdistance <= radius * radius then
          count = count + 1
          distance = distance + unitdistance
        end
      end
      if maxcount < count then
        maxcount = count
        mindistance = distance
        position = {x, y}
      end
      if count == maxcount and distance < mindistance then
        mindistance = distance
        position = {x, y}
      end
      count = 0
      distance = 0
    end
  end
  if 0 < maxcount then
    return position
  else
    position = {400, 0}
    return position
  end
end

function HeatBossQOP.skillatk3_takeEffectOn(basefunc, skill, target, source, shift)
  local ishit, damage = basefunc(skill, target, source, shift)
  local caster = skill.caster
  if ishit then
    local bid = HeatBossQOP.atk3Evobuff
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, target, caster)
    target:addBuff(buff, caster)
  end
  return ishit, damage
end

function HeatBossQOP.hero_takeDamage(basefunc, self, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
  self.Gender = nil
  local p = 0.2
  for i, tbuff in ipairs(self.buff_list) do
    if tbuff.info.ID == 20050111 then
      p = 0.25
    end
    if tbuff.info.ID == 20050112 then
      p = 0.3
    end
    if tbuff.info.ID == 20050113 then
      p = 0.35
    end
    if tbuff.info.ID == 20050114 then
      p = 0.4
    end
  end
  if type(struct_table) == "table" then
    if struct_table.source and struct_table.source.info.Gender == T("\231\148\183") then
      self.Gender = T("\231\148\183")
      if p > ed.rand() then
        local bid = HeatBossQOP.enchbuff
        local binfo = ed.lookupDataTable("Buff", nil, bid)
        local buff = ed.BuffCreate(binfo, struct_table.source, self)
        struct_table.source:addBuff(buff, self)
      end
    end
  elseif source and source.info.Gender == T("\231\148\183") then
    self.Gender = T("\231\148\183")
    if p > ed.rand() then
      local bid = HeatBossQOP.enchbuff
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, source, self)
      source:addBuff(buff, self)
    end
  end
  return basefunc(self, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
end

function HeatBossQOP.skill_getLostHPAfterImmunity(basefunc, self, damage, immunity)
  if self.Gender == T("\231\148\183") then
    local reduce = 0.2
    for i, tbuff in ipairs(self.buff_list) do
      if tbuff.info.ID == 20050121 then
        reduce = 0.25
      end
      if tbuff.info.ID == 20050122 then
        reduce = 0.3
      end
      if tbuff.info.ID == 20050123 then
        reduce = 0.35
      end
      if tbuff.info.ID == 20050124 then
        reduce = 0.4
      end
    end
    damage = damage * (1 - reduce)
  end
  return basefunc(self, damage, immunity)
end

function HeatBossQOP.onDying(basefunc, self, killer)
  local heatbossokalive = false
  for u in ed.engine:foreachAliveUnit(self.camp) do
    if u.tid == 366 and u:isAlive() then
      heatbossokalive = true
    end
  end
  if heatbossokalive then
    self.unitonDying = true
    self.state = ed.emUnitState_Birth
    local list = self.buff_list
    local debuff_list = {}
    for i = 1, #list do
      local buff = list[i]
      if buff and buff.caster ~= self then
        debuff_list[#debuff_list + 1] = buff
      end
    end
    for i = 1, #debuff_list do
      debuff_list[i].timer = -1
    end
    local bid = HeatBossQOP.dyingbuff
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, self, self)
    self:addBuff(buff, self)
    if buff then
      buff.timer = 999
      buff.update = override(buff.update, HeatBossQOP.DyingBuff_update)
      buff.onRemoved = override(buff.onRemoved, HeatBossQOP.DyingBuff_onRemoved)
    end
    for i, ubuff in ipairs(self.buff_list) do
      if ubuff.info.HPR < 0 then
        ubuff.timer = 0
      end
    end
    self.can_cast_manual = false
    self.walk_v = {0, 0}
    self.hp = 1
    self.mp = 0
    self.HeatBossQOP_Dying = true
    self:setAction("Death2", false, true)
  else
    basefunc(self, killer)
  end
end

function HeatBossQOP.setHP(basefunc, unit, hp, reason)
  local heatbossokalive = false
  for u in ed.engine:foreachAliveUnit(unit.camp) do
    if u.tid == 366 and u:isAlive() then
      heatbossokalive = true
    end
  end
  if hp <= 0 and heatbossokalive then
    hp = 1
    unit:setAction("Death2", false, true)
    local bid = HeatBossQOP.dyingbuff
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, unit, unit)
    unit:addBuff(buff, unit)
    if buff then
      buff.timer = 999
      buff.update = override(buff.update, HeatBossQOP.DyingBuff_update)
      buff.onRemoved = override(buff.onRemoved, HeatBossQOP.DyingBuff_onRemoved)
    end
    for i, ubuff in ipairs(unit.buff_list) do
      if 0 > ubuff.info.HPR then
        ubuff.timer = 0
      end
    end
    unit.HeatBossQOP_Dying = true
  end
  basefunc(unit, hp, reason)
end

function HeatBossQOP.DyingBuff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local unit = buff.owner
  if buff.owner.heatbossoksacrifice == true and not unit.Resurrection then
    unit.Resurrection = true
    buff.timer = 3.5
    buff.owner:setAction("Resurrection", false, true)
  end
end

function HeatBossQOP.DyingBuff_onRemoved(basefunc, buff)
  buff.owner.HeatBossQOP_Dying = false
  buff.owner.unitonDying = false
  basefunc(buff)
end

function HeatBossQOP.hero_handleUnitDieEvent(basefunc, self, unit, killer_unit)
  basefunc(self, unit, killer_unit)
  local skillatk6 = self.skills.HeatBossQOP_atk6
  local skillatk6s = self.skills.HeatBossQOP_atk6s
  if skillatk6 and skillatk6s and unit.tid == 366 and not self.skillatk6havecasted and not unit.skillatk4_takeeffecton then
    local maxdmg = skillatk6s:selectTarget()
    if maxdmg and not maxdmg.buff_effects.untargetable and not maxdmg.buff_effects.invulnerable and not maxdmg.buffManager.invisible and not maxdmg.buff_effects.uncontrollable then
      skillatk6s:takeEffectOn(maxdmg, self)
    end
    for enemy in ed.engine:foreachAliveUnit(-self.camp) do
      if enemy and not enemy.buff_effects.untargetable and not enemy.buff_effects.invulnerable and not enemy.buffManager.invisible and not enemy.buff_effects.uncontrollable and enemy ~= maxdmg then
        skillatk6:takeEffectOn(enemy, self)
      end
    end
    self.skillatk6havecasted = true
  end
end

function HeatBossQOP.reset(basefunc, hero)
  basefunc(hero)
  hero.heatbossoksacrifice = false
  hero.skillatk6havecasted = false
  hero.Resurrection = false
end

function HeatBossQOP.init_hero(hero)
  local skillult = hero.skills.HeatBossQOP_ult
  local skillatk = hero.skills.HeatBossQOP_atk
  local skillatk2 = hero.skills.HeatBossQOP_atk2
  local skillatk3 = hero.skills.HeatBossQOP_atk3
  local skillatk4 = hero.skills.HeatBossQOP_atk4
  local skillatk5 = hero.skills.HeatBossQOP_atk5
  local skillatk6 = hero.skills.HeatBossQOP_atk6
  hero.reset = override(hero.reset, HeatBossQOP.reset)
  if skillult then
  end
  if skillatk2 then
    skillatk2.createProjectile = override(skillatk2.createProjectile, HeatBossQOP.skillatk2_createProjectile)
  end
  if skillatk3 then
    skillatk3.start = override(skillatk3.start, HeatBossQOP.skillatk3_start)
    skillatk3.finish = override(skillatk3.finish, HeatBossQOP.skillatk3_finish)
    skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, HeatBossQOP.skillatk3_onAttackFrame)
    skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, HeatBossQOP.skillatk3_takeEffectOn)
  end
  if skillatk4 then
    hero.takeDamage = override(hero.takeDamage, HeatBossQOP.hero_takeDamage)
    hero.getLostHPAfterImmunity = override(hero.getLostHPAfterImmunity, HeatBossQOP.skill_getLostHPAfterImmunity)
  end
  if skillatk5 then
    hero.onDying = override(hero.onDying, HeatBossQOP.onDying)
  end
  if skillatk6 then
    hero.handleUnitDieEventToAll = override(hero.handleUnitDieEventToAll, HeatBossQOP.hero_handleUnitDieEvent)
  end
  return hero
end

return HeatBossQOP.init_hero
