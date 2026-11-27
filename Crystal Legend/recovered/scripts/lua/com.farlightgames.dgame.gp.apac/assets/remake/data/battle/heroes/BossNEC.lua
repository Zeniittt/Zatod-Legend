module("ed.battlehero", package.seeall)
local ed = ed
BossNEC = {}

function BossNEC.skill6_start(basefunc, skill, target)
  local caster = skill.caster
  local bid = 56
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
  basefunc(skill)
end

function BossNEC.skill6_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local isRet, duration = skill:getDurationFromAttackFrameToEnd(skill.current_phase, skill.next_event)
  caster:startScalingAction(1.2, 1)
end

function BossNEC.skill6_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  if caster then
    caster:enterActionStageFromOneStage(2, 341)
  end
  local skill2 = caster.skills.BossNEC_atk2
  skill2.originfo = skill2.info
  skill2.info = ed.wraptable(skill2.originfo, {CD = 2})
  caster.config.dps_mod = caster.config.dps_mod and caster.config.dps_mod * 2
  caster:endScalingAction()
end

function BossNEC.BossNECult_castManualSkill(basefunc, hero)
  basefunc(hero)
  local target = hero.skills.BossNEC_atk5.target
  if not target then
    return
  end
  if not target:isHasUncontrolBufEffect() then
    target:unfreezeActor()
  elseif target.actor then
    target.actor:tint(2.5, 2.5, 2.5)
    target.actor.NEC_isTint = true
  end
  local bid = 19
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = target:addBuff(binfo, hero)
end

function BossNEC.skillult_update(basefunc, skill, dt_action, dt_cd)
  basefunc(skill, dt_action, dt_cd)
  if not skill.BossNEC_ult_effect and skill.current_phase_elapsed > 0.1 and skill.target then
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
    if ed.protoSuperAwake(skill.caster.proto, 20) then
      if ed.run_with_scene then
        ed.scene:playEffectOnScene("eff_point_NEC_ult.cha", {
          skill.target.position[1] - 50,
          skill.target.position[2] + 50
        }, {1, 1}, nil, 1)
        ed.scene:playEffectOnScene("eff_point_NEC_ult.cha", {
          skill.target.position[1] + 50,
          skill.target.position[2] - 50
        }, {1, 1}, nil, 1)
        ed.scene:playEffectOnScene("eff_point_NEC_ult.cha", {
          skill.target.position[1] + 100,
          skill.target.position[2] + 100
        }, {1, 1}, nil, 1)
        ed.scene:playEffectOnScene("eff_point_NEC_ult.cha", {
          skill.target.position[1] - 100,
          skill.target.position[2] - 100
        }, {1, 1}, nil, 1)
      end
      local skillsawake = skill.caster.skills.NEC_sawake
      skill.target:takeDamage(skillsawake.info["Script Arg2"] + 230, "Holy", "hp", skill.caster)
    end
    skill.BossNEC_ult_effect = true
  end
end

function BossNEC.skillult_onAttackFrame(basefunc, skill)
  local target = skill.target
  if target and target.actor and target.actor.NEC_isTint then
    target.actor:tint(0.4, 0.4, 0.4)
    target.actor.NEC_isTint = nil
  end
  basefunc(skill)
end

function BossNEC.skillult_takeEffectOn(basefunc, skill, target)
  if not target:isAlive() then
    return
  end
  local losthp = target.attribs.HP - target.hp
  local ratio = skill.info["Script Arg1"] or 0
  local power = losthp * ratio
  local powermax = skill.info["Script Arg3"] or 0
  local powermin = skill.info["Script Arg4"] or 0
  power = power > powermax and powermax or power < powermin and powermin or power
  skill.info["Basic Num"] = power
  basefunc(skill, target)
end

function BossNEC.skillult_start(basefunc, skill)
  skill.BossNEC_ult_effect = nil
  basefunc(skill)
end

function BossNEC.skillatk2_createProjectile(basefunc, skill)
  local shape = "circle"
  local arg1 = 220
  local arg2 = 0
  local caster = skill.caster
  if ed.protoSuperAwake(skill.caster.proto, 20) then
    arg1 = 800
    caster:takeHeal(100, "mp", caster)
    skill.info["Tile Art"] = "eff_tile_NEC_atk2_2.cha"
  end
  skill:takeEffectOn(caster)
  for unit in ed.engine:foreachAliveUnit(skill:affectedCamp()) do
    local p2 = ed.edpSub(unit.position, caster.position)
    if not unit.buff_effects.untargetable and not unit.buff_effects.invulnerable and unit ~= caster and ed.Skill.testPointInShape(p2, shape, arg1, arg2) then
      local projectile = basefunc(skill)
      projectile:enableTrack(unit)
      ed.engine:addProjectile(projectile)
    end
  end
  return nil
end

function BossNEC.skillatk2_takeEffectOn(basefunc, skill, target)
  local caster = skill.caster
  if caster.camp == target.camp then
    skill.info["Damage Type"] = "Heal"
    skill.info["Impact Effect"] = "eff_impact_heal.cha"
  else
    skill.info["Damage Type"] = "AP"
    if ed.protoSuperAwake(skill.caster.proto, 20) then
      skill.info["Damage Type"] = "Holy"
    end
    skill.info["Impact Effect"] = "eff_impact_slash.cha"
  end
  basefunc(skill, target)
end

function BossNEC.init_hero(hero)
  local skillult = hero.skills.BossNEC_atk5
  if skillult then
    hero.castManualSkill = override(hero.castManualSkill, BossNEC.BossNECult_castManualSkill)
    skillult.takeEffectOn = override(skillult.takeEffectOn, BossNEC.skillult_takeEffectOn)
    skillult.update = override(skillult.update, BossNEC.skillult_update)
    skillult.start = override(skillult.start, BossNEC.skillult_start)
    skillult.onAttackFrame = override(skillult.onAttackFrame, BossNEC.skillult_onAttackFrame)
  end
  local skillatk2 = hero.skills.BossNEC_atk2
  if skillatk2 then
    hero:preloadEffect("eff_point_NEC_ult.cha")
    hero:preloadEffect("eff_impact_heal.cha")
    hero:preloadEffect("eff_impact_slash.cha")
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, BossNEC.skillatk2_takeEffectOn)
    skillatk2.createProjectile = override(skillatk2.createProjectile, BossNEC.skillatk2_createProjectile)
  end
  local skillatk6 = hero.skills.BossNEC_atk6
  if skillatk6 then
    skillatk6.start = override(skillatk6.start, BossNEC.skill6_start)
    skillatk6.finish = override(skillatk6.finish, BossNEC.skill6_finish)
    skillatk6.onAttackFrame = override(skillatk6.onAttackFrame, BossNEC.skill6_onAttackFrame)
  end
  return hero
end

return BossNEC.init_hero
