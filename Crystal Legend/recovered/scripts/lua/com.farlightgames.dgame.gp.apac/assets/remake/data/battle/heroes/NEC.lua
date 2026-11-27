module("ed.battlehero", package.seeall)
local ed = ed
NEC = {}
NEC.ult = 10002001
NEC.atk3 = 10002003

function NEC.NECult_castManualSkill(basefunc, hero)
  basefunc(hero)
  local target = hero.skills.NEC_ult.target
  if not target then
    return
  end
  if not target:isHasUncontrolBufEffect() then
    target:unfreezeActor()
  else
  end
  local bid = NEC.ult
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = target:addBuff(binfo, hero)
end

function NEC.skillult_update(basefunc, skill, dt_action, dt_cd)
  basefunc(skill, dt_action, dt_cd)
  if not skill.NEC_ult_effect and skill.current_phase_elapsed > 0.1 and skill.target then
    local origin = skill.target.position
    local scale = {
      skill.target.direction,
      1
    }
    if ed.run_with_scene then
      local effect_name = "eff_point_NEC_ult.cha"
      if not effect_name then
        return
      end
      ed.scene:playEffectOnScene(effect_name, origin, scale, nil, 1)
    end
    skill.NEC_ult_effect = true
  end
end

function NEC.skillult_onAttackFrame(basefunc, skill)
  local target = skill.target
  basefunc(skill)
end

function NEC.skillult_takeEffectOn(basefunc, skill, target)
  if not target:isAlive() then
    return
  end
  local caster = skill.caster
  local losthp = target.attribs.HP - target.hp
  local ratio = skill.info["Script Arg2"] or 0
  if skill.evo_rank and skill.evo_rank >= 3 then
    ratio = ratio + skill.evo_rank3["Script Arg1"]
  end
  local power = losthp * ratio
  local powermax = skill.info["Script Arg3"] + skill.info["Script Arg5"] * caster.attribs.AP or 0
  local powermin = skill.info["Script Arg4"] + skill.info["Script Arg5"] * caster.attribs.AP or 0
  if skill.evo_rank and skill.evo_rank >= 1 then
    powermin = powermin + skill.evo_rank1["Script Arg1"]
  end
  if skill.evo_rank and skill.evo_rank >= 2 then
    powermax = powermax + skill.evo_rank2["Script Arg1"]
  end
  power = power > powermax and powermax or power < powermin and powermin or power
  skill.info["Basic Num"] = power
  basefunc(skill, target)
end

function NEC.skillult_start(basefunc, skill)
  skill.NEC_ult_effect = nil
  basefunc(skill)
end

function NEC.skillatk2_createProjectile(basefunc, skill)
  local shape = "circle"
  local arg1 = 220
  local arg2 = 0
  local caster = skill.caster
  skill:takeEffectOn(caster)
  for unit in ed.engine:foreachAliveUnit(skill:affectedCamp()) do
    local p2 = ed.edpSub(unit.position, caster.position)
    if not unit.buff_effects.untargetable and unit ~= caster and ed.Skill.testPointInShape(p2, shape, arg1, arg2) then
      local projectile = basefunc(skill)
      projectile:enableTrack(unit)
      ed.engine:addProjectile(projectile)
    end
  end
  return nil
end

function NEC.skillatk2_takeEffectOn(basefunc, skill, target)
  local caster = skill.caster
  if caster.camp == target.camp then
    skill.info["Damage Type"] = "Heal"
    skill.info["Impact Effect"] = "eff_impact_heal.cha"
  else
    skill.info["Damage Type"] = "AP"
    skill.info["Impact Effect"] = "eff_impact_slash.cha"
  end
  basefunc(skill, target)
end

function NEC.hero_update(basefunc, unit, dt)
  basefunc(unit, dt)
  if unit.custom_data == 1 then
    unit.dt = unit.dt and unit.dt + dt or dt
    if unit.dt == dt then
      unit.unitonDying = false
    end
  end
  if unit:isAlive() and ed.engine.rogue_mode and ed.engine.rogueSkillMgr:getCharm(16) and unit.camp == 1 then
    local charmEffect = ed.engine.rogueSkillMgr:getCharm(16)
    local skill = unit.skills.NEC_charm
    local timer = unit.charm_refresh_timer - dt
    while timer < 0 do
      timer = timer + 1
      skill:takeEffectAt(unit.position, unit)
    end
    unit.charm_refresh_timer = timer
  end
end

function NEC.skillcharm_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = buff.caster
  local owner = buff.owner
  local charmEffect = ed.engine.rogueSkillMgr:getCharm(16)
  local dmg = -owner.attribs.HP * charmEffect.info["Script Arg" .. charmEffect.level] / 100
  if owner.config.is_boss then
    dmg = dmg / 4
  end
  buff:setAttribute("HPR", dmg)
  return buff
end

function NEC.onDying(basefunc, self, killer)
  local skillatk2 = self.skills.NEC_atk2
  local skillatk3 = self.skills.NEC_atk3
  if self.custom_data ~= 1 then
    self.custom_data = 1
    self.unitonDying = true
    self.state = ed.emUnitState_Idle
    local bid = 10002005
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    self:addBuff(binfo, self)
    for i, tbuff in ipairs(self.buff_list) do
      if tbuff.caster ~= self then
        local buff = tbuff
        buff.timer = -1
      end
    end
    self.can_cast_manual = false
    self.walk_v = {0, 0}
    self.hp = 0
    self.mp = 0
    self:setHP(1)
    if skillatk3 then
      skillatk3:takeEffectOn(self, self)
      if skillatk2 and skillatk3.evo_rank and skillatk3.evo_rank >= 3 then
        skillatk2.cd_remaining = 0
      end
    end
  else
    basefunc(self, killer)
  end
end

function NEC.reset(basefunc, hero)
  basefunc(hero)
  hero.custom_data = 0
  hero.charm_refresh_timer = 1
end

function NEC.skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local hpr = buff.info.HPR
  local mimu = buff.info.MIMU
  if skill.evo_rank and skill.evo_rank >= 1 then
    buff:setAttribute("HPR", hpr + skill.evo_rank1["Script Arg1"] * (1 + caster.attribs.HEAL / 100))
  end
  if skill.evo_rank and skill.evo_rank >= 2 then
    buff:setAttribute("MIMU", mimu + skill.evo_rank2["Script Arg1"])
  end
  return buff
end

function NEC.hero_handleUnitDieEvent(basefunc, self, unit, killer_unit)
  basefunc(self, unit, killer_unit)
  local skillpasvs = self.skills.NEC_pasvs
  if skillpasvs and unit.camp ~= self.camp then
    skillpasvs:takeEffectOn(self, self)
  end
end

function NEC.init_hero(hero)
  local skillult = hero.skills.NEC_ult
  local skillatk2 = hero.skills.NEC_atk2
  local skillatk3 = hero.skills.NEC_atk3
  local skillpasv = hero.passive_skill_list[1]
  local skillcharm = hero.skills.NEC_charm
  if skillcharm then
    skillcharm.createBuff = override(skillcharm.createBuff, NEC.skillcharm_createBuff)
  end
  if skillult then
    hero.castManualSkill = override(hero.castManualSkill, NEC.NECult_castManualSkill)
    skillult.takeEffectOn = override(skillult.takeEffectOn, NEC.skillult_takeEffectOn)
    skillult.update = override(skillult.update, NEC.skillult_update)
    skillult.start = override(skillult.start, NEC.skillult_start)
    skillult.onAttackFrame = override(skillult.onAttackFrame, NEC.skillult_onAttackFrame)
  end
  if skillatk2 then
    hero:preloadEffect("eff_point_NEC_ult.cha")
    hero:preloadEffect("eff_impact_heal.cha")
    hero:preloadEffect("eff_impact_slash.cha")
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, NEC.skillatk2_takeEffectOn)
    skillatk2.createProjectile = override(skillatk2.createProjectile, NEC.skillatk2_createProjectile)
    if skillatk2.evo_rank and 1 <= skillatk2.evo_rank then
      skillatk2.info = ed.wraptable(skillatk2.info, {
        ["Plus Ratio"] = skillatk2.evo_rank1["Script Arg1"]
      })
    end
    if skillatk2.evo_rank and skillatk2.evo_rank >= 2 then
      skillatk2.info = ed.wraptable(skillatk2.info, {
        ["Plus Ratio"] = skillatk2.evo_rank2["Script Arg1"]
      })
    end
    if skillatk2.evo_rank and skillatk2.evo_rank >= 3 then
      skillatk2.info = ed.wraptable(skillatk2.info, {
        ["Plus Ratio"] = skillatk2.evo_rank3["Script Arg1"]
      })
    end
  end
  if skillatk3 then
    hero.update = override(hero.update, NEC.hero_update)
    hero.onDying = override(hero.onDying, NEC.onDying)
    hero.reset = override(hero.reset, NEC.reset)
    skillatk3.createBuff = override(skillatk3.createBuff, NEC.skillatk3_createBuff)
  end
  if skillpasv then
    hero.handleUnitDieEventToAll = override(hero.handleUnitDieEventToAll, NEC.hero_handleUnitDieEvent)
    local aname = skillpasv["Passive Attr"]
    if skillpasv.evo_rank and 1 <= skillpasv.evo_rank then
      skillpasv["Basic Num"] = skillpasv["Basic Num"] + skillpasv.evo_rank1["Script Arg1"]
    end
    if skillpasv.evo_rank and skillpasv.evo_rank >= 2 then
      skillpasv["Basic Num"] = skillpasv["Basic Num"] + skillpasv.evo_rank2["Script Arg1"]
    end
    if skillpasv.evo_rank and skillpasv.evo_rank >= 3 then
      skillpasv["Basic Num"] = skillpasv["Basic Num"] + skillpasv.evo_rank3["Script Arg1"]
    end
    hero:rebuild()
  end
  return hero
end

return NEC.init_hero
