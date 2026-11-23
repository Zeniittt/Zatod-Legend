module("ed.battlehero", package.seeall)
local ed = ed
WorldLion = {}
WorldLion.ragelosthp = 35000
WorldLion.rage2losthp = 15000
WorldLion.stage2hp = 1750000
WorldLion.stage2ragelosthp = 7500

function WorldLion.rage_buff_update(basefunc, buff, dt)
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

function WorldLion.hero_reset(basefunc, hero)
  basefunc(hero)
  local bid = 4572
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = hero:addBuff(binfo, hero)
  buff.update = override(buff.update, WorldLion.rage_buff_update)
  hero.lastrageStack = 0
end

function WorldLion.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  if not hero.lastRageHp then
    hero.lastRageHp = hero.hp
    hero.rageStack = 0
  end
  if hero.attribs.HP - hero.hp < WorldLion.stage2hp then
    while hero.lastRageHp - hero.hp >= WorldLion.ragelosthp do
      local binfo
      local bid = 4573
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, hero, hero)
      hero:addBuff(buff, hero)
      hero.lastRageHp = hero.lastRageHp - WorldLion.ragelosthp
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
    while hero.lastRageHp - hero.hp >= WorldLion.stage2ragelosthp do
      local binfo
      local bid = 4573
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, hero, hero)
      hero:addBuff(buff, hero)
      hero.lastRageHp = hero.lastRageHp - WorldLion.rage2losthp
      hero.rageStack = hero.rageStack + 1
    end
  end
end

function WorldLion.skill2_takeEffectOn(basefunc, skill, target, source)
  local is_hit, dmg = basefunc(skill, target, source)
  local caster = skill.caster
  local skillatk2s = caster.skills.WorldLion_atk2s
  if is_hit and target then
    local hasBeenduck = false
    for i, tbuff in ipairs(target.buff_list) do
      if tbuff.info.ID == 10034302 then
        hasBeenduck = true
      end
    end
    if hasBeenduck then
      skillatk2s:takeEffectAt(target.position, caster)
      hasBeenduck = false
    end
  end
  return is_hit, dmg
end

function WorldLion.skillatk2s_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff:setAttribute("fearrange", 5)
  return buff
end

function WorldLion.skillatk3_selectTarget(basefunc, skill, default)
  local target = basefunc(skill, default)
  local target
  local maxDamage = -1
  local caster = skill.target
  for unit in ed.engine:foreachAliveUnit(skill:targetCamp()) do
    if unit.buff_effects.invulnerable then
    elseif unit.buff_effects.untargetable then
    elseif unit.position[1] < ed.engine.stage_rect.minX then
    elseif unit.position[1] > ed.engine.stage_rect.maxX then
    elseif unit.config.is_summoned then
    else
      local unit_damage = unit.battledata:getDamage()
      if maxDamage <= unit_damage then
        maxDamage = unit_damage
        target = unit
      end
    end
  end
  return target
end

function WorldLion.skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local owner = buff.owner
  if owner then
    for i, tbuff in ipairs(owner.buff_list) do
      if tbuff.caster.camp ~= caster.camp then
        tbuff.timer = -1
      end
    end
  end
  buff.onRemoved = override(buff.onRemoved, WorldLion.atk3buff_onRemoved)
  buff.update = override(buff.update, WorldLion.DuckBuff_update)
  return buff
end

function WorldLion.atk3buff_onRemoved(basefunc, buff)
  basefunc(buff)
  local owner = buff.owner
  if owner then
  end
end

function WorldLion.DuckBuff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local owner = buff.owner
  if owner then
    for i, tbuff in ipairs(owner.buff_list) do
      local caster = tbuff.caster
      if caster.camp == owner.camp and dt >= tbuff.info.Time - tbuff.timer then
        buff.timer = -1
      end
    end
  end
end

function WorldLion.skillatk3_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local skillatk3s = caster.skills.WorldLion_atk3s
  if skillatk3s then
    for unit in ed.engine:foreachAliveUnit(skill:targetCamp()) do
      local hasBeenduck = false
      for i, tbuff in ipairs(unit.buff_list) do
        if tbuff.info.ID == 10034302 then
          hasBeenduck = true
        end
      end
      if hasBeenduck then
        skillatk3s:takeEffectAt(unit.position, caster)
        hasBeenduck = false
      end
    end
  end
  basefunc(skill)
end

function WorldLion.skillult_createChain(basefunc, skill)
  local info = skill.info
  local self = ed.Entity.create()
  local class = {
    mt = {}
  }
  local caster = skill.caster
  self.skill = skill
  self.source = skill.caster
  self.target = skill.target
  self.jumps_remaining = info["Chain Jumps"]
  self.jump_timer = 0
  self.affect_times = {}
  setmetatable(self, ed.Chain.mt)
  for unit in ed.engine:foreachAliveUnit(skill:targetCamp()) do
    for i, tbuff in ipairs(unit.buff_list) do
      if tbuff.info.ID == 10034302 then
        self.jumps_remaining = self.jumps_remaining + 1
      end
    end
  end
  self:jump()
  return self
end

function WorldLion.init_hero(hero)
  hero.reset = override(hero.reset, WorldLion.hero_reset)
  hero.update = override(hero.update, WorldLion.hero_update)
  local skill2 = hero.skills.WorldLion_atk2
  local skillatk2s = hero.skills.WorldLion_atk2s
  local skill3 = hero.skills.WorldLion_atk3
  local skillult = hero.skills.WorldLion_ult
  if skill2 then
    hero:preloadEffect("eff_launch_spike.cha")
    skill2.takeEffectOn = override(skill2.takeEffectOn, WorldLion.skill2_takeEffectOn)
  end
  if skillatk2s then
    skillatk2s.createBuff = override(skillatk2s.createBuff, WorldLion.skillatk2s_createBuff)
  end
  if skill3 then
    skill3.createBuff = override(skill3.createBuff, WorldLion.skillatk3_createBuff)
    skill3.onAttackFrame = override(skill3.onAttackFrame, WorldLion.skillatk3_onAttackFrame)
    skill3.selectTarget = override(skill3.selectTarget, WorldLion.skillatk3_selectTarget)
  end
  if skillult then
    skillult.createChain = override(skillult.createChain, WorldLion.skillult_createChain)
  end
  return hero
end

return WorldLion.init_hero
