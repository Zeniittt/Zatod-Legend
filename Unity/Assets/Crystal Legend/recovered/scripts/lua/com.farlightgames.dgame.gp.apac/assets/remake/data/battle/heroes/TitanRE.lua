module("ed.battlehero", package.seeall)
local ed = ed
TitanRE = {}
TitanRE.blink_distance = 30
TitanRE.ragelosthp = 35000
TitanRE.rage2losthp = 15000
TitanRE.stage2hp = 1750000
TitanRE.stage2ragelosthp = 7500

function TitanRE.reset(basefunc, unit)
  basefunc(unit)
  unit.ultDuelStance = false
  unit.enemydeadcount = 0
  unit.TitanRE_atk4_timer = 0
  unit.TitanRE_atk4_count = 0
  local bid = 4572
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = unit:addBuff(binfo, unit)
  buff.update = override(buff.update, TitanRE.rage_buff_update)
  unit.lastrageStack = 0
end

function TitanRE.hero_handleUnitDieEvent(basefunc, self, unit, killer_unit)
  basefunc(self, unit, killer_unit)
  local skillult = self.skills.TitanRE_ult
  if not unit.config.is_summoned and unit.camp == -self.camp then
    self.enemydeadcount = self.enemydeadcount + 1
  end
end

function TitanRE.skillult_canCastWithTarget(basefunc, skill, target)
  local hero = skill.caster
  if not basefunc(skill, target) or hero.mp < 1000 and skill.caster.name == "TitanRE" or hero.ultDuelStance == true or hero.manually_casting or hero.current_skill and hero.current_skill.info["Skill Name"] == "TitanRE_atk2" then
    return false
  end
  return true
end

function TitanRE.skillult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  local caster = buff.caster
  owner.ultDuelStance = true
  buff.update = override(buff.update, TitanRE.ult_buff_update)
  buff.onRemoved = override(buff.onRemoved, TitanRE.ult_buff_onRemoved)
  return buff
end

function TitanRE.skillult_takeEffectOn(basefunc, skill, target, source)
  basefunc(skill, target, source)
  local caster = skill.caster
  local skillults = caster.skills.TitanRE_ults
  skillults:takeEffectAt({400, 0}, caster)
end

function TitanRE.ult_buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local caster = buff.caster
  local skillults = caster.skills.TitanRE_ults
  if buff.owner.mp == 0 and buff.owner:isAlive() then
    buff.owner.removeBuff(buff.owner, buff)
  end
  for target in ed.engine:foreachAliveUnit(skillults:targetCamp()) do
    local haveultbuff = false
    for i, tbuff in ipairs(target.buff_list) do
      if tbuff.info.ID == 11021902 then
        haveultbuff = true
        break
      end
    end
    if not haveultbuff then
      skillults:takeEffectOn(target, caster)
    end
  end
end

function TitanRE.ult_buff_onRemoved(basefunc, buff)
  basefunc(buff)
  local owner = buff.owner
  owner.ultDuelStance = false
  for target in ed.engine:foreachAliveUnit(-owner.camp) do
    for i, tbuff in ipairs(target.buff_list) do
      if tbuff.info.ID == 11021902 then
        local enemybuff = tbuff
        enemybuff.timer = -1
        break
      end
    end
  end
end

function TitanRE.power(basefunc, skill, source, target, damage_type)
  local ret = basefunc(skill, source, target, damage_type)
  local caster = skill.caster
  if caster.ultDuelStance then
    local skillult = caster.skills.TitanRE_ult
    if skillult then
      local dmgratio = 1 + skillult.info["Script Arg2"] / 100 * skill.caster.mp / 1000
      if caster.enemydeadcount > 0 then
        dmgratio = dmgratio * (1 + caster.enemydeadcount * skillult.info["Script Arg4"] / 100)
      end
      ret = ret * dmgratio
    end
  end
  return ret
end

function TitanRE.skillatk2_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  local target = skill.target
  if target then
    projectile:enableTrack(target)
    local target_position = {
      target.position[1],
      target.position[2]
    }
    local distance = target_position[1] - skill.caster.position[1]
    projectile.velocity = {
      distance / 0.5,
      0
    }
  end
  return projectile
end

function TitanRE.skillatk2_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  local caster = skill.caster
  if attack_counter == 0 then
    local owner = skill.caster
    local bid = 11021903
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = owner:addBuff(binfo, owner)
    basefunc(skill)
  elseif attack_counter == 1 then
    local target = skill.target
    target = target or skill:selectTarget(nil)
    skill.attack_counter = skill.attack_counter + 1
    if target then
      skill.target = target
      local direction = 0 < target.position[1] - caster.position[1] and 1 or -1
      local position1 = target.position[1] - direction * TitanRE.blink_distance
      if target.buff_effects.stable or 799 < position1 or position1 < 1 then
        position1 = position1 - direction * TitanRE.blink_distance
        if 799 < position1 then
          position1 = 780
        elseif position1 < 1 then
          position1 = 10
        end
      end
      caster.position = {
        position1,
        target.position[2]
      }
    end
  else
    for i, tbuff in ipairs(caster.buff_list) do
      if tbuff.info.ID == 11021903 then
        local buff = tbuff
        buff.timer = -1
        break
      end
    end
    local skillatk2s = caster.skills.TitanRE_atk2s
    local target = skill.target
    target = target or skillatk2s:selectTarget(nil)
    if target then
      skillatk2s:takeEffectAt(target.position, caster)
      skill.attack_counter = skill.attack_counter + 1
    end
  end
end

function TitanRE.skillatk2_takeEffectOn(basefunc, skill, target, source)
  basefunc(skill, target, source)
end

function TitanRE.takeDamage(basefunc, unit, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
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
  local self = unit
  if not self:isAlive() then
    return
  end
  local control_effects = {
    stun = true,
    frozen = true,
    icefrozen = true,
    immoblilize = true,
    silence = true,
    disarm = true,
    doom = true,
    imprisonment = true,
    enchanted = true,
    fear = true,
    taunt = true,
    detaunt = true,
    polymorph = true
  }
  
  local function isCrlEftConflictWithControl(self)
    local isRet = false
    local info = self.info
    for i, effect in ipairs(info["Control Effects"]) do
      if control_effects[effect] then
        isRet = true
        break
      end
    end
    return isRet
  end
  
  local damagetypeok = false
  if damage_type == "AD" then
    damagetypeok = true
  elseif self.TitanRE_hasArcana and self.TitanRE_hasArcana > 2 then
    damagetypeok = true
  end
  if 0 < amount and not transferred and damagetypeok then
    local castingSkill = false
    local cur_skill = unit.current_skill
    if cur_skill and cur_skill.info["Skill Name"] == "TitanRE_atk3" then
      castingSkill = true
    elseif cur_skill and cur_skill.info["Skill Name"] ~= "TitanRE_atk" then
      local noAF = 0
      for _, phase in ipairs(cur_skill.phase_list) do
        noAF = noAF + #phase.event_list
      end
      if noAF > cur_skill.attack_counter then
        castingSkill = true
      end
    end
    local becontrol = false
    for i, tbuff in ipairs(unit.buff_list) do
      if isCrlEftConflictWithControl(tbuff) then
        becontrol = true
        break
      end
    end
    local skillatk3 = unit.skills.TitanRE_atk3
    local atkpro = skillatk3.info["Script Arg2"] / 100
    if skillatk3 then
      if not castingSkill and not becontrol then
        if atkpro > ed.rand() then
          skillatk3.cd_remaining = 0
          unit.global_cd = 0
          if type(struct_table) == "table" then
            struct_table.amount = 0
          else
            struct_table = 0
          end
        end
      elseif (castingSkill or becontrol) and atkpro > ed.rand() then
        if type(struct_table) == "table" then
          struct_table.amount = 0
        else
          struct_table = 0
        end
      end
    end
  end
  return basefunc(unit, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
end

function TitanRE.skillatk3_takeEffectOn(basefunc, skill, target, source)
  local isHit, dmg, Crit, lfs_amount = basefunc(skill, target, source)
  local caster = skill.caster
  if isHit then
    target:hurt()
    if caster.TitanRE_hasArcana and caster.TitanRE_hasArcana > 1 then
      local bid = 11021904
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = target:addBuff(binfo, caster)
    end
  end
end

function TitanRE.hero_update(basefunc, unit, dt)
  basefunc(unit, dt)
  local hero = unit
  local skillatk4 = unit.skills.TitanRE_atk4
  if skillatk4 then
    unit.TitanRE_atk4_timer = unit.TitanRE_atk4_timer + dt
    if unit.TitanRE_atk4_timer >= 4 and unit:isAlive() then
      unit.TitanRE_atk4_timer = 0
      local max = -math.huge
      local chosen
      for target in ed.engine:foreachAliveUnit(skillatk4:targetCamp()) do
        if target.buff_effects.untargetable then
        elseif target.buff_effects.uncontrollable then
        elseif target.config.is_summoned then
        elseif target.buffManager.invisible and target.camp ~= unit.camp then
        elseif 0 > target.position[1] or target.position[1] > 800 then
        elseif target.TitanREatk4bechosen then
          target.TitanREatk4bechosen = false
        else
          local haveatk4buff = false
          for i, tbuff in ipairs(target.buff_list) do
            if tbuff.info.ID == 11021905 then
              haveatk4buff = true
              break
            end
          end
          if haveatk4buff then
          else
            local v = ed.rand()
            if max < v then
              max = v
              chosen = target
            end
          end
        end
      end
      if chosen then
        skillatk4:takeEffectOn(chosen, unit)
        chosen.TitanREatk4bechosen = true
      end
    end
  end
  if not hero.lastRageHp then
    hero.lastRageHp = hero.hp
    hero.rageStack = 0
  end
  if hero.attribs.HP - hero.hp < TitanRE.stage2hp then
    while hero.lastRageHp - hero.hp >= TitanRE.ragelosthp do
      local binfo
      local bid = 4573
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, hero, hero)
      hero:addBuff(buff, hero)
      hero.lastRageHp = hero.lastRageHp - TitanRE.ragelosthp
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
    while hero.lastRageHp - hero.hp >= TitanRE.stage2ragelosthp do
      local binfo
      local bid = 4573
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, hero, hero)
      hero:addBuff(buff, hero)
      hero.lastRageHp = hero.lastRageHp - TitanRE.rage2losthp
      hero.rageStack = hero.rageStack + 1
    end
  end
end

function TitanRE.skillatk4_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  if caster.TitanRE_hasArcana and caster.TitanRE_hasArcana > 3 then
    local bid = 11021906
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = target:addBuff(binfo, caster)
  end
  buff.onRemoved = override(buff.onRemoved, TitanRE.skillatk4buff_onRemoved)
  return buff
end

function TitanRE.skillatk4buff_onRemoved(basefunc, buff)
  basefunc(buff)
  local owner = buff.owner
  local caster = buff.caster
  for i, tbuff in ipairs(owner.buff_list) do
    if tbuff.info.ID == 11021906 then
      local buff = tbuff
      buff.timer = -1
    end
  end
  caster.TitanRE_atk4_count = caster.TitanRE_atk4_count - 1
end

function TitanRE.skillatk_takeEffectOn(basefunc, skill, target, source)
  local ishit, dmg, Crit, lfs_amount = basefunc(skill, target, source)
  local caster = skill.caster
  source = source or caster
  local skillult = caster.skills.TitanRE_ult
  if ishit and caster.ultDuelStance then
    local dmgratio = 1 + skillult.info["Script Arg2"] / 100 * skill.caster.mp / 1000
    target:takeDamage(caster.attribs.AP * dmgratio * (1 + caster.enemydeadcount * skillult.info["Script Arg4"] / 100), "AP", "hp", source, 1, 1, true)
  end
  return ishit, dmg, Crit, lfs_amount
end

function TitanRE.rage_buff_update(basefunc, buff, dt)
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

function TitanRE.init_hero(hero)
  hero.ultDuelStance = false
  hero.reset = override(hero.reset, TitanRE.reset)
  hero.update = override(hero.update, TitanRE.hero_update)
  hero.handleUnitDieEventToAll = override(hero.handleUnitDieEventToAll, TitanRE.hero_handleUnitDieEvent)
  hero.TitanRE_hasArcana = ed.getProtoArcanaLevel(hero.proto)
  hero.enemydeadcount = 0
  hero.TitanRE_atk4_timer = 0
  hero.TitanRE_atk4_count = 0
  local skillult = hero.skills.TitanRE_ult
  local skillatk = hero.skills.TitanRE_atk
  local skillatk2 = hero.skills.TitanRE_atk2
  local skillatk2s = hero.skills.TitanRE_atk2s
  local skillatk3 = hero.skills.TitanRE_atk3
  local skillatk4 = hero.skills.TitanRE_atk4
  if skillult then
    skillult.createBuff = override(skillult.createBuff, TitanRE.skillult_createBuff)
    skillult.canCastWithTarget = override(skillult.canCastWithTarget, TitanRE.skillult_canCastWithTarget)
    skillult.takeEffectOn = override(skillult.takeEffectOn, TitanRE.skillult_takeEffectOn)
  end
  if skillatk then
    skillatk.takeEffectOn = override(skillatk.takeEffectOn, TitanRE.skillatk_takeEffectOn)
    skillatk.power = override(skillatk.power, TitanRE.power)
  end
  if skillatk2 then
    skillatk2.createProjectile = override(skillatk2.createProjectile, TitanRE.skillatk2_createProjectile)
    skillatk2.power = override(skillatk2.power, TitanRE.power)
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, TitanRE.skillatk2_onAttackFrame)
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, TitanRE.skillatk2_takeEffectOn)
  end
  if skillatk2s then
    skillatk2s.power = override(skillatk2s.power, TitanRE.power)
  end
  if skillatk3 then
    skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, TitanRE.skillatk3_takeEffectOn)
    hero.takeDamage = override(hero.takeDamage, TitanRE.takeDamage)
    skillatk3.power = override(skillatk3.power, TitanRE.power)
  end
  if skillatk4 then
    hero.TitanRE_atk4_timer = 0
    skillatk4.createBuff = override(skillatk4.createBuff, TitanRE.skillatk4_createBuff)
  end
  return hero
end

return TitanRE.init_hero
