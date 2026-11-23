module("ed.battlehero", package.seeall)
local ed = ed
TitanPM = {}
TitanPM.skillatk2_buffID = 1587
TitanPM.skillatk4_buffID = 1588
TitanPM.skillatk2_shield_buffID = 1589
TitanPM.skillatk3_MaxAmount = 3
TitanPM.atk2_distance = 193
TitanPM.ult_distance = 250
TitanPM.skillult_timer_buffID = 1590
TitanPM.skillult_invisible = 1591
TitanPM.skillult2_buffID = 1592
TitanPM.skillult2_stun = 1593
TitanPM.ult2_distance = 100
TitanPM.skillatk2_HAST_buffID = 1595
TitanPM.skillultself_buffID = 1597

function TitanPM.enterStage_SkillCD_read(hero)
  if hero.skills.TitanPM_atk then
    hero.TitanPM_skillatk_cdremaining = hero.skills.TitanPM_atk.cd_remaining or 6
  end
  if hero.skills.TitanPM_atk2A then
    hero.TitanPM_skillatk2A_cdremaining = hero.skills.TitanPM_atk2A.cd_remaining or 6
  end
  if hero.skills.TitanPM_atk3A then
    hero.TitanPM_skillatk3A_cdremaining = hero.skills.TitanPM_atk3A.cd_remaining or 6
  end
  if hero.skills.TitanPM_atk2B then
    hero.TitanPM_skillatk2B_cdremaining = hero.skills.TitanPM_atk2B.cd_remaining or 6
  end
  if hero.skills.TitanPM_atk3B then
    hero.TitanPM_skillatk3B_cdremaining = hero.skills.TitanPM_atk3B.cd_remaining or 6
  end
end

function TitanPM.enterStage_SkillCD_write(hero)
  if hero.skills.TitanPM_atk then
    hero.skills.TitanPM_atk.cd_remaining = hero.TitanPM_skillatk_cdremaining or 6
  end
  if hero.skills.TitanPM_atk2A then
    hero.skills.TitanPM_atk2A.cd_remaining = hero.TitanPM_skillatk2A_cdremaining or 6
  end
  if hero.skills.TitanPM_atk3A then
    hero.skills.TitanPM_atk3A.cd_remaining = hero.TitanPM_skillatk3A_cdremaining or 6
  end
  if hero.skills.TitanPM_atk2B then
    hero.skills.TitanPM_atk2B.cd_remaining = hero.TitanPM_skillatk2B_cdremaining or 6
  end
  if hero.skills.TitanPM_atk3B then
    hero.skills.TitanPM_atk3B.cd_remaining = hero.TitanPM_skillatk3B_cdremaining or 6
  end
end

function TitanPM.hero_reset(basefunc, hero)
  basefunc(hero)
  if hero.currentActionStage ~= 1 then
    hero:enterActionStageFromOneStage(1, 10090)
  end
  hero.custom_data = 0
end

function TitanPM.hero_die(basefunc, hero, killer)
  basefunc(hero, killer)
  if hero.TitanPM_fireman and hero.TitanPM_fireman:isAlive() then
    hero.TitanPM_fireman:die()
  end
end

function TitanPM.skillult_canCastWithTarget(basefunc, skill, target)
  local result = basefunc(skill, target)
  local caster = skill.caster
  if result and not caster.TitanPM_fireman then
    return true
  else
    return nil
  end
end

function TitanPM.fireman_die(basefunc, hero, killer)
  hero.config.is_monster = true
  hero.config.is_summoned = true
  hero.manually_casting = false
  if do_battle_log then
    btlog("%s died.", hero:display())
  end
  hero.state = ed.emUnitState_Dying
  if hero.manually_casting then
    hero.manually_casting = false
    ed.engine:unfreeze()
  end
  if hero.current_skill then
    hero.current_skill:interrupt()
  end
  hero.can_cast_manual = false
  hero.walk_v = {0, 0}
  hero.hp = 0
  hero.mp = 0
  if not hero.isDeathWithEffect then
    hero:setAction("Death", false, true)
  else
    hero.action_name = nil
    hero.action_loop = false
    hero.action_duration = 0
    hero.action_elapsed = 0
    local origin = {
      hero.position[1],
      hero.position[2]
    }
    if ed.run_with_scene then
      local effect_name = "eff_point_mirror_die.cha"
      if effect_name then
        ed.scene:playEffectOnScene(effect_name, origin, {
          hero.direction * 0.85,
          0.85
        }, nil, 1)
      end
    end
  end
  ed.engine:onUnitDie(hero, nil)
  if hero.actor then
    hero.actor:onUnitDeath()
  end
  local owner = hero.father
  owner.TitanPM_fireman = nil
  if not ed.engine.running then
    hero:setDeathWithEffectOrNot(true)
  end
end

function TitanPM:UltonAttackFrame()
  if self.caster.manually_casting and self.attack_counter == 2 then
    ed.engine:unfreeze()
    self.caster.manually_casting = false
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
  local MPGR = caster.attribs.MPGainRatio or 0
  self:createTrackType(ttype)
  if MPGR then
    caster:setMP(caster.mp + info["Gain MP"] * ed.engine.mp_bonus * (1 + MPGR / 100))
  end
  if info["Move Forward"] ~= 0 then
    caster.position[1] = caster.position[1] + info["Move Forward"] * caster.direction
  end
end

function TitanPM.skillult_onAttackFrame(basefunc, skill)
  TitanPM.UltonAttackFrame(skill)
  local attack_counter = skill.attack_counter
  if attack_counter == 2 then
    local caster = skill.caster
    local skilllevel = {
      skill.level,
      skill.level,
      skill.level,
      skill.level,
      skill.level,
      skill.level,
      skill.level,
      skill.level
    }
    if caster and caster:isAlive() then
      local proto = {
        _tid = 10090,
        _level = skill.level or 1,
        _skill_levels = skilllevel,
        _stars = caster.stars,
        _rank = caster.rank
      }
      local config = {
        is_monster = true,
        estimate_rank = true,
        hp_mod = caster.camp == ed.emCampEnemy and ed.engine.guildInstance_mode and 2 or caster.config.hp_mod,
        dps_mod = caster.config.dps_mod or 1,
        summoner = caster
      }
      local fireman = ed.UnitCreate(proto, caster.camp, config)
      local pos = {
        caster.position[1] + caster.direction * TitanPM.ult_distance,
        caster.position[2]
      }
      fireman.direction = -caster.direction
      fireman.father = caster
      local bid = TitanPM.skillult_timer_buffID
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, fireman, caster)
      buff.onRemoved = override(buff.onRemoved, TitanPM.skillult_buff_buffOnRemoved)
      fireman:addBuff(buff, caster)
      caster.TitanPM_fireman = fireman
      fireman:setActionStageChangeByManual(true)
      if caster.currentActionStage == 1 then
        TitanPM.enterStage_SkillCD_read(caster)
        fireman:enterActionStageFromOneStage(4, 10090)
      elseif caster.currentActionStage == 2 then
        TitanPM.enterStage_SkillCD_read(caster)
        fireman:enterActionStageFromOneStage(3, 10090)
      end
      fireman.die = override(fireman.die, TitanPM.fireman_die)
      fireman.rebuild = override(fireman.rebuild, TitanPM.fireman_rebuild)
      for i, attrib in pairs(caster.attribs) do
        fireman.attribs[i] = attrib
      end
      fireman.attribs.AGI = caster.attribs.AGI * 1.1
      ed.engine:summonUnit(fireman, pos, caster, "Idle")
      fireman.config.is_summoned = false
    end
  end
end

function TitanPM.fireman_rebuild(basefunc, hero)
  basefunc(hero)
  local caster = hero.father
  for i, attrib in pairs(caster.attribs) do
    hero.attribs[i] = attrib
  end
  hero.attribs.AGI = caster.attribs.AGI * 1.1
end

function TitanPM.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local bid = TitanPM.skillultself_buffID
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
end

function TitanPM.skillult_buff_buffOnRemoved(basefunc, buff)
  basefunc(buff)
  local hero = buff.caster
  if hero.TitanPM_fireman then
    hero.TitanPM_fireman.config.is_monster = true
    hero.TitanPM_fireman.config.is_summoned = true
    hero.TitanPM_fireman.manually_casting = false
  end
  if hero.hp > 0 then
    if hero.TitanPM_fireman and hero.TitanPM_fireman:isAlive() then
      local bid = TitanPM.skillult_invisible
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = hero.TitanPM_fireman:addBuff(binfo, hero)
      hero.TitanPM_fireman:die()
      hero.TitanPM_fireman = nil
    end
    if not ed.engine.beingEnd then
      local bid = TitanPM.skillult2_buffID
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = hero:addBuff(binfo, hero)
      if hero.current_skill and hero.current_skill ~= hero.manual_skill then
        hero.current_skill:interrupt()
      end
      local skillult2 = hero.skills.TitanPM_ult2
      hero:castSkill(skillult2, nil)
    end
  end
end

function TitanPM.skillult_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  if caster.currentActionStage == 1 then
    caster:enterActionStageFromOneStage(5, 10090)
    TitanPM.enterStage_SkillCD_write(caster)
  elseif caster.currentActionStage == 2 then
    caster:enterActionStageFromOneStage(6, 10090)
    TitanPM.enterStage_SkillCD_write(caster)
  end
end

function TitanPM.skillult2_start(basefunc, skill, target)
  basefunc(skill)
  local caster = skill.caster
  if target and target:isAlive() then
    local bid = TitanPM.skillult2_stun
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = target:addBuff(binfo, caster)
  end
end

function TitanPM.skillult2_onAttackFrame(basefunc, skill)
  skill.info["No Dodge"] = true
  local caster = skill.caster
  local attack_counter = skill.attack_counter
  local target = skill.target
  if attack_counter == 0 and target then
    caster:setPosition({
      target.position[1] - caster.direction * TitanPM.ult2_distance,
      target.position[2]
    })
  end
  basefunc(skill)
end

function TitanPM.skillult2_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == TitanPM.skillult2_buffID then
      tbuff.timer = 0
    end
    if tbuff.info.ID == TitanPM.skillultself_buffID then
      tbuff.timer = 0
    end
  end
  if caster.currentActionStage == 5 then
    TitanPM.enterStage_SkillCD_read(caster)
    caster:enterActionStageFromOneStage(1, 10090)
    TitanPM.enterStage_SkillCD_write(caster)
  elseif caster.currentActionStage == 6 then
    TitanPM.enterStage_SkillCD_read(caster)
    caster:enterActionStageFromOneStage(2, 10090)
    TitanPM.enterStage_SkillCD_write(caster)
  end
end

function TitanPM.skillatk2AB_start(basefunc, skill, target)
  local caster = skill.caster
  local bid = TitanPM.skillatk2_buffID
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
  skill.TitanPM_atk2count = 0
  basefunc(skill, target)
end

function TitanPM.skillatk2AB_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  caster:setPosition({
    caster.position[1] + caster.direction * TitanPM.atk2_distance,
    caster.position[2]
  })
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == TitanPM.skillatk2_buffID then
      tbuff.timer = 0
    end
  end
  if skill.info["Skill Group ID"] == 1902 then
    if skill.TitanPM_atk2count and 0 < skill.TitanPM_atk2count then
      local caster = skill.caster
      local bid = TitanPM.skillatk2_shield_buffID
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, caster, caster)
      buff.shield = skill.info["Script Arg2"] * skill.TitanPM_atk2count
      caster:addBuff(buff, caster)
    end
  elseif skill.TitanPM_atk2count and 0 < skill.TitanPM_atk2count then
    local caster = skill.caster
    local bid = TitanPM.skillatk2_HAST_buffID
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, caster, caster)
    buff:setAttribute("HAST", 35 * skill.TitanPM_atk2count)
    buff:setAttribute("MSPD", 35 * skill.TitanPM_atk2count)
    caster:addBuff(binfo, caster)
  end
end

function TitanPM.skillatk2AB_takeEffectOn(basefunc, skill, target, source, shift)
  local result = basefunc(skill, target, source, shift)
  local caster = skill.caster
  if result then
    skill.TitanPM_atk2count = skill.TitanPM_atk2count + 1
  end
end

function TitanPM.skillatk2A_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local attack_counter = skill.attack_counter
  if attack_counter == 0 then
    basefunc(skill)
  end
end

function TitanPM.skillatk2B_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local attack_counter = skill.attack_counter
  if attack_counter == 0 then
    basefunc(skill)
  end
end

function TitanPM.testPointInShape(p, shape, arg1, arg2)
  if shape == "rectangle" then
    return p[1] >= 0 and arg1 >= p[1] and p[2] >= -arg2 * 0.5 and p[2] <= arg2 * 0.5
  elseif shape == "circle" then
    return p[1] * p[1] + p[2] * p[2] <= arg1 * arg1
  elseif shape == "halfcircle" then
    return p[1] >= 0 and p[1] * p[1] + p[2] * p[2] <= arg1 * arg1
  elseif shape == "quartercircle" then
    return p[1] >= 0 and p[2] <= p[1] and p[2] >= -p[1] and p[1] * p[1] + p[2] * p[2] <= arg1 * arg1
  else
    EDDebug("Unkonwn AOE Type: '" .. shape .. "', spelling mistake?")
  end
end

function TitanPM.skillatk3AB_start(basefunc, skill, target)
  basefunc(skill, target)
  skill.skillatk3_targetcount = TitanPM.skillatk3_MaxAmount
end

function TitanPM.skillatk3A_takeEffectOn(basefunc, skill, target, source, shift)
  if skill.skillatk3_targetcount > 0 then
    local result = basefunc(skill, target, source, shift)
    local caster = skill.caster
    local skillatk3Ap = caster.skills.TitanPM_atk3Ap
    if result and caster and target and skill.skillatk3_targetcount > 0 then
      local projectile = skillatk3Ap:createProjectile()
      projectile.position = {
        target.position[1],
        target.position[2]
      }
      projectile.height = 20
      local v = 150
      if not caster then
        return
      end
      projectile:enableTrack(caster)
      local TitanPM_pos = {
        caster.position[1],
        caster.position[2]
      }
      local targetxyV = ed.edpSub(TitanPM_pos, projectile.position)
      local targetzV = projectile.height
      local u = (targetxyV[1] * targetxyV[1] + targetxyV[2] * targetxyV[2] + targetzV * targetzV) ^ (-0.5)
      local targetV = {
        u * targetxyV[1],
        u * targetxyV[2],
        u * targetzV
      }
      projectile.velocity[1] = targetV[1] * v
      projectile.velocity[2] = targetV[2] * v
      projectile.zSpeed = targetV[3] * v
      ed.engine:addProjectile(projectile)
      skill.skillatk3_targetcount = skill.skillatk3_targetcount - 1
    end
  end
end

function TitanPM.skillatk3B_takeEffectOn(basefunc, skill, target, source, shift)
  if skill.skillatk3_targetcount > 0 then
    local result = basefunc(skill, target, source, shift)
    local caster = skill.caster
    local skillatk3Bp = caster.skills.TitanPM_atk3Bp
    if result and caster and target then
      local projectile = skillatk3Bp:createProjectile()
      projectile.position = {
        target.position[1],
        target.position[2]
      }
      projectile.height = 20
      local v = 150
      if not caster then
        return
      end
      projectile:enableTrack(caster)
      local TitanPM_pos = {
        caster.position[1],
        caster.position[2]
      }
      local targetxyV = ed.edpSub(TitanPM_pos, projectile.position)
      local targetzV = projectile.height
      local u = (targetxyV[1] * targetxyV[1] + targetxyV[2] * targetxyV[2] + targetzV * targetzV) ^ (-0.5)
      local targetV = {
        u * targetxyV[1],
        u * targetxyV[2],
        u * targetzV
      }
      projectile.velocity[1] = targetV[1] * v
      projectile.velocity[2] = targetV[2] * v
      projectile.zSpeed = targetV[3] * v
      ed.engine:addProjectile(projectile)
      skill.skillatk3_targetcount = skill.skillatk3_targetcount - 1
    end
  end
end

function TitanPM.skillatk3_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local skillatk3Ap = caster.skills.TitanPM_atk3Ap
  local skillatk3Bp = caster.skills.TitanPM_atk3Bp
  if skillatk3Ap and skillatk3Ap.TitanPM_tilecount then
    skillatk3Ap.TitanPM_tilecount = 1
  end
  if skillatk3Bp and skillatk3Bp.TitanPM_tilecount then
    skillatk3Bp.TitanPM_tilecount = 1
  end
end

function TitanPM.onDying(basefunc, hero, killer)
  local skillatk4 = hero.skills.TitanPM_atk4
  if skillatk4 and skillatk4.is_update and hero.custom_data ~= 1 then
    if hero.TitanPM_fireman and hero.TitanPM_fireman:isAlive() then
      hero.TitanPM_fireman:die()
    end
    hero.rebirth_timer_SNK = 2.5
    hero.custom_data = 1
    hero.state = ed.emUnitState_Birth
    hero:removeAllBuffs()
    hero.can_cast_manual = false
    hero.walk_v = {0, 0}
    hero.hp = hero.attribs.HP
    hero.mp = 0
    local bid = TitanPM.skillatk4_buffID
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = hero:addBuff(binfo, hero)
    if hero.current_skill then
      hero.current_skill:interrupt()
    end
    hero:castSkill(skillatk4, nil)
  else
    basefunc(hero, killer)
  end
end

function TitanPM.skillatk4_finish(basefunc, skill, reason)
  basefunc(skill, reason)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == TitanPM.skillatk4_buffID then
      tbuff.timer = 0
    end
  end
  TitanPM.enterStage_SkillCD_read(caster)
  caster:enterActionStageFromOneStage(2, 10090)
  TitanPM.enterStage_SkillCD_write(caster)
  if ed.run_with_scene then
    local panel = caster.heroPanel
    if panel and caster.name == "TitanPM" then
      if caster.currentActionStage == 1 then
        panel:setPortrait("UI/DOTA-HERO/TitanPM.png")
      elseif caster.currentActionStage == 2 then
        panel:setPortrait("UI/DOTA-HERO/TitanPM2.png")
      end
    end
  end
end

function TitanPM.update(basefunc, hero, dt)
  basefunc(hero, dt)
end

function TitanPM.init_hero(hero)
  hero:setActionStageChangeByManual(true)
  local skillult = hero.skills.TitanPM_ult
  local skillult2 = hero.skills.TitanPM_ult2
  local skillatk2A = hero.skills.TitanPM_atk2A
  local skillatk2B = hero.skills.TitanPM_atk2B
  local skillatk3A = hero.skills.TitanPM_atk3A
  local skillatk3B = hero.skills.TitanPM_atk3B
  local skillatk4 = hero.skills.TitanPM_atk4
  if skillult then
    skillult.onAttackFrame = override(skillult.onAttackFrame, TitanPM.skillult_onAttackFrame)
    skillult.start = override(skillult.start, TitanPM.skillult_start)
    skillult.finish = override(skillult.finish, TitanPM.skillult_finish)
    skillult.canCastWithTarget = override(skillult.canCastWithTarget, TitanPM.skillult_canCastWithTarget)
  end
  if skillult2 then
    skillult2.start = override(skillult2.start, TitanPM.skillult2_start)
    skillult2.finish = override(skillult2.finish, TitanPM.skillult2_finish)
    skillult2.onAttackFrame = override(skillult2.onAttackFrame, TitanPM.skillult2_onAttackFrame)
  end
  if skillatk2A then
    skillatk2A.onAttackFrame = override(skillatk2A.onAttackFrame, TitanPM.skillatk2A_onAttackFrame)
    skillatk2A.start = override(skillatk2A.start, TitanPM.skillatk2AB_start)
    skillatk2A.finish = override(skillatk2A.finish, TitanPM.skillatk2AB_finish)
    skillatk2A.takeEffectOn = override(skillatk2A.takeEffectOn, TitanPM.skillatk2AB_takeEffectOn)
  end
  if skillatk2B then
    skillatk2B.onAttackFrame = override(skillatk2B.onAttackFrame, TitanPM.skillatk2B_onAttackFrame)
    skillatk2B.start = override(skillatk2B.start, TitanPM.skillatk2AB_start)
    skillatk2B.finish = override(skillatk2B.finish, TitanPM.skillatk2AB_finish)
    skillatk2B.takeEffectOn = override(skillatk2B.takeEffectOn, TitanPM.skillatk2AB_takeEffectOn)
  end
  if skillatk3A then
    skillatk3A.start = override(skillatk3A.start, TitanPM.skillatk3AB_start)
    skillatk3A.takeEffectOn = override(skillatk3A.takeEffectOn, TitanPM.skillatk3A_takeEffectOn)
    skillatk3A.finish = override(skillatk3A.finish, TitanPM.skillatk3_finish)
  end
  if skillatk3B then
    skillatk3B.start = override(skillatk3B.start, TitanPM.skillatk3AB_start)
    skillatk3B.takeEffectOn = override(skillatk3B.takeEffectOn, TitanPM.skillatk3B_takeEffectOn)
    skillatk3B.finish = override(skillatk3B.finish, TitanPM.skillatk3_finish)
  end
  if skillatk4 then
    skillatk4.finish = override(skillatk4.finish, TitanPM.skillatk4_finish)
  end
  hero.onDying = override(hero.onDying, TitanPM.onDying)
  hero.reset = override(hero.reset, TitanPM.hero_reset)
  hero.die = override(hero.die, TitanPM.hero_die)
  hero.update = override(hero.update, TitanPM.update)
  return hero
end

return TitanPM.init_hero
