module("ed.battlehero", package.seeall)
local ed = ed
TitanRazor = {}
TitanRazor.ultBid = 1569
TitanRazor.atk3Bid = 1571
TitanRazor.invBid = 1573
TitanRazor.threshold = 0.15

function TitanRazor.skillatk2_Start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  if caster:isAlive() and ed.run_with_scene then
    ed.scene:playEffectOnScene("eff_impact_TitanRazor_atk2.cha", {
      caster.position[1],
      caster.position[2]
    }, {
      caster.direction * 1,
      1
    }, nil, 1)
  end
end

function TitanRazor.skillatk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local owner = target
  local ult_buff = false
  for _, tbuff in ipairs(owner.buff_list) do
    if tbuff.info.ID == TitanRazor.ultBid then
      ult_buff = true
    end
  end
  if ult_buff and caster:isAlive() and caster.name == "TitanRazor" and not caster.config.is_summoned then
    local atk2_buff_HAST = math.min(-90, buff.info.HAST * 2)
    local atk2_buff_MSPD = math.min(-90, buff.info.MSPD * 2)
    buff:setAttribute("HAST", atk2_buff_HAST)
    buff:setAttribute("MSPD", atk2_buff_MSPD)
  end
  return buff
end

function TitanRazor.hero_collectMPchange(basefunc, self, config)
  local unit = config.unit
  local caster = self
  local skillatk3 = caster.skills.TitanRazor_atk3
  local MPStealRatio = (skillatk3.info["Script Arg3"] + math.floor(caster.attribs.AGI) * 0.005) / 100
  local MPStealMAX = skillatk3.info["Script Arg2"]
  local TitanRazor_atk3_state = {
    0,
    0,
    0
  }
  MPStealRatio = math.max(0, MPStealRatio)
  MPStealRatio = math.min(1, MPStealRatio)
  if unit.camp == caster.foecamp and skillatk3 and not unit.buff_effects.uncontrollable and caster:isAlive() then
    for _, tbuff in ipairs(unit.buff_list) do
      if tbuff.info.ID == TitanRazor.atk3Bid then
        TitanRazor_atk3_state[1] = 1
      end
      if tbuff.info.ID == TitanRazor.ultBid then
        TitanRazor_atk3_state[2] = 1
      end
    end
    if TitanRazor_atk3_state[1] == 1 and TitanRazor_atk3_state[2] == 1 then
      local MPChange = math.floor(math.abs(config.mp_change))
      if 0 < MPChange and TitanRazor_atk3_state[3] == 0 then
        TitanRazor_atk3_state[3] = 1
        local MPSteal = MPChange * MPStealRatio
        MPSteal = math.min(MPSteal, MPStealMAX)
        if unit.name ~= "TitanRazor" then
          caster.TitanRazor_MP_buffer = 0
          caster:setMP(caster.mp + MPSteal)
        elseif unit.info.Name == "TitanRazor" and not caster.unit_is_TitanRazor then
          caster.TitanRazor_MP_buffer = 0
          caster.unit_is_TitanRazor = true
          caster:setMP(caster.mp + MPSteal)
        end
        caster.unit_is_TitanRazor = false
      end
    end
    if TitanRazor_atk3_state[1] == 1 and 0 < config.mp_change then
      config.mp = unit.mp
    end
  end
end

function TitanRazor.skillatk3_ProjectileHit(basefunc, projectile, target)
  basefunc(projectile, target)
  local caster = projectile.caster
  local ult_buff = false
  for _, tbuff in ipairs(target.buff_list) do
    if tbuff.info.ID == TitanRazor.ultBid then
      ult_buff = true
    end
  end
  if ult_buff and caster:isAlive() and ed.run_with_scene then
    ed.scene:playEffectOnScene("eff_buff_TitanRazor_atk3_2.cha", {
      caster.position[1],
      caster.position[2]
    }, {
      caster.direction * 1,
      1
    }, nil, 1)
  end
end

function TitanRazor.skillatk3_CreateProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  local caster = skill.caster
  if projectile and caster.name == "TitanRazor" and not caster.config.is_summoned then
    projectile.hit = override(projectile.hit, TitanRazor.skillatk3_ProjectileHit)
  end
  return projectile
end

function TitanRazor.DOP_in_battlefield(caster, radius, camp)
  local position = {400, 0}
  local count = 0
  local maxcount = 0
  local distance = 0
  local mindistance = 9999
  for x = 0, 800, 25 do
    for y = -100, 100, 25 do
      for unit in ed.engine:foreachAliveUnit(camp) do
        local unitdistance = ed.edpDistanceSQ({x, y}, unit.position)
        if unit.buffManager.invisible and unit.camp ~= caster.camp then
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
    return caster.position
  end
end

function TitanRazor.skillatk4_Start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  caster.skillatk4_target = target
  if caster.name == "TitanRazor" and not caster.config.is_summoned then
    local bid = TitanRazor.invBid
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, caster, caster)
    caster.TitanRazor_invBuff = caster:addBuff(buff, caster)
  end
end

function TitanRazor.skillatk4_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  for _, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == TitanRazor.invBid then
      tbuff.timer = -1
    end
  end
  if caster.TitanRazor_atk4Cancast == true then
    caster.TitanRazor_atk4_backCount = caster.TitanRazor_atk4_backCount - 1
    caster.TitanRazor_atk4Cancast = false
  end
end

function TitanRazor.skillatk4_onPhaseFinished(basefunc, skill)
  local currentPhase = skill.current_phase_idx
  local caster = skill.caster
  local target = skill.target or caster.skillatk4_target
  if caster.TitanRazor_atk4Cancast ~= true then
    if currentPhase == 1 then
      if target then
        local PortalPosition = target.position
        local position1 = PortalPosition[1] + caster.direction * 50
        if target.buff_effects.stable then
          position1 = position1 - caster.direction * 60
        end
        if PortalPosition[1] < 50 then
          position1 = PortalPosition[1] + 50
        end
        if PortalPosition[1] > 750 then
          position1 = PortalPosition[1] - 50
        end
        caster:setPosition({
          position1,
          PortalPosition[2]
        })
      else
        local PortalPosition = TitanRazor.DOP_in_battlefield(caster, 100, caster.camp)
        caster:setPosition({
          PortalPosition[1],
          PortalPosition[2]
        })
      end
      skill:startPhase(2)
    else
      skill:finish()
    end
  elseif currentPhase == 1 then
    local PortalPosition = TitanRazor.DOP_in_battlefield(caster, 100, caster.camp)
    caster:setPosition({
      PortalPosition[1],
      PortalPosition[2]
    })
    skill:startPhase(2)
  else
    skill:finish()
  end
end

function TitanRazor.skillatk4_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local currentPhase = skill.current_phase_idx
  local skillatk4 = caster.skills.TitanRazor_atk4
  local skillatk4s = caster.skills.TitanRazor_atk4s
  if skillatk4 and not caster.config.is_summoned and skill.attack_counter == 1 and currentPhase == 2 and caster.TitanRazor_atk4Cancast ~= true then
    skillatk4s:takeEffectAt(caster.position)
  end
  basefunc(skill)
end

function TitanRazor.skillatk4s_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local owner = target
  local ult_buff = false
  local skillatk4 = caster.skills.TitanRazor_atk4
  for _, tbuff in ipairs(owner.buff_list) do
    if tbuff.info.ID == TitanRazor.ultBid then
      ult_buff = true
    end
  end
  if caster:isAlive() and caster.name == "TitanRazor" and not caster.config.is_summoned and ult_buff then
    local TitanRazor_PIMU = skillatk4.info["Script Arg3"]
    local TitanRazor_MIMU = skillatk4.info["Script Arg3"]
    buff:setAttribute("PIMU", TitanRazor_PIMU)
    buff:setAttribute("MIMU", TitanRazor_MIMU)
  end
  return buff
end

function TitanRazor.skillult_CreateBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local skillult = caster.skills.TitanRazor_ult
  local TitanRazor_AGI = caster.attribs.AGI
  local TitanRazor_ult_Ratio = TitanRazor_AGI / 10
  local TitanRazor_HPR = skillult.info["Script Arg2"] + -TitanRazor_ult_Ratio
  if caster:isAlive() and caster.name == "TitanRazor" and not caster.config.is_summoned and buff then
    buff:setAttribute("HPR", TitanRazor_HPR)
  end
  return buff
end

function TitanRazor.hero_takeDamage(basefunc, self, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
  local finaldamage, bc = basefunc(self, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
  local hero = self
  if finaldamage and finaldamage > hero.attribs.HP * TitanRazor.threshold and hero.TitanRazor_atk4_backCount > 0 then
    hero.TitanRazor_atk4Cancast = true
  end
  return finaldamage, bc
end

function TitanRazor.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  local skillult = hero.skills.TitanRazor_ult
  local skillatk2 = hero.skills.TitanRazor_atk2
  local skillatk3 = hero.skills.TitanRazor_atk3
  local skillatk4 = hero.skills.TitanRazor_atk4
  local OtherSkillCasting = false
  hero.TitanRazor_atk4Tick = hero.TitanRazor_atk4Tick and hero.TitanRazor_atk4Tick + dt or dt
  if skillult and skillult.casting or skillatk2 and skillatk2.casting or skillatk3 and skillatk3.casting then
    OtherSkillCasting = true
  else
    OtherSkillCasting = false
  end
  if skillatk4 and OtherSkillCasting == false and hero.TitanRazor_atk4Cancast == true and not skillatk4.casting then
    hero:castSkill(skillatk4, hero)
    hero.TitanRazor_TotalDamage = 0
  end
end

function TitanRazor.TitanRazor_skillallPower(basefunc, self, target, power, damage_type, field, source, crit_mod)
  local hero = self.caster
  local power_Ratio = 0.1
  local power = power * power_Ratio
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

function TitanRazor.hero_die(basefunc, hero)
  basefunc(hero)
  hero.TitanRazor_TotalDamage = 0
  hero.TitanRazor_atk4Cancast = false
  hero.TitanRazor_atk4Tick = 0
end

function TitanRazor.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.TitanRazor_TotalDamage = 0
  hero.TitanRazor_atk4Cancast = false
  hero.TitanRazor_atk4Tick = 0
  hero.TitanRazor_atk4_backCount = 2
end

function TitanRazor.init_hero(hero)
  hero.reset = override(hero.reset, TitanRazor.hero_reset)
  hero.update = override(hero.update, TitanRazor.hero_update)
  hero.die = override(hero.die, TitanRazor.hero_die)
  local skillatk2 = hero.skills.TitanRazor_atk2
  local skillatk3 = hero.skills.TitanRazor_atk3
  local skillatk4 = hero.skills.TitanRazor_atk4
  local skillatk4s = hero.skills.TitanRazor_atk4s
  local skillult = hero.skills.TitanRazor_ult
  if skillatk2 then
    skillatk2.start = override(skillatk2.start, TitanRazor.skillatk2_Start)
    skillatk2.createBuff = override(skillatk2.createBuff, TitanRazor.skillatk2_createBuff)
  end
  if skillatk3 then
    hero.collectMPchange = override(hero.collectMPchange, TitanRazor.hero_collectMPchange)
    skillatk3.createProjectile = override(skillatk3.createProjectile, TitanRazor.skillatk3_CreateProjectile)
  end
  if skillatk4 then
    skillatk4.onPhaseFinished = override(skillatk4.onPhaseFinished, TitanRazor.skillatk4_onPhaseFinished)
    skillatk4.onAttackFrame = override(skillatk4.onAttackFrame, TitanRazor.skillatk4_onAttackFrame)
    skillatk4.start = override(skillatk4.start, TitanRazor.skillatk4_Start)
    skillatk4.finish = override(skillatk4.finish, TitanRazor.skillatk4_finish)
    hero.takeDamage = override(hero.takeDamage, TitanRazor.hero_takeDamage)
  end
  if skillatk4s then
    skillatk4s.createBuff = override(skillatk4s.createBuff, TitanRazor.skillatk4s_createBuff)
  end
  if skillult then
    skillult.createBuff = override(skillult.createBuff, TitanRazor.skillult_CreateBuff)
  end
  return hero
end

return TitanRazor.init_hero
