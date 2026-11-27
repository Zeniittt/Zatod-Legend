module("ed.battlehero", package.seeall)
local ed = ed
local math = math
BruceWayne = {}
BruceWayne.atk3_1_gainMp = 60
BruceWayne.atk3_3_attackRange = 300
BruceWayne.deathRatio = 0.1
BruceWayne.skillatk_2_powerRatio = 2
BruceWayne.skillatk4_fear_BuffID = 1395
BruceWayne.skillatk3_1_BuffID = 1401
BruceWayne.skillatk4_dead_BuffID = 1403
BruceWayne.skillawake_BuffID = 1404
BruceWayne.skillatk4_SelfBuffID = 1405
BruceWayne.skillatk4_fix_BuffID = 1406
BruceWayne.skillatk4_fearShow_BuffID = 1407
BruceWayne.skillawake_HPR_BuffID = 1408

function BruceWayne.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.fearLevel = 0
  hero.awakeBuff = false
  hero.atk_count = 0
  hero.atk3_count = 0
end

function BruceWayne.skillult_start(basefunc, skill, target)
  local caster = skill.caster
  basefunc(skill, target)
  local binfo = ed.lookupDataTable("Buff", nil, BruceWayne.skillatk4_SelfBuffID)
  local buff = caster:addBuff(binfo, caster)
  if ed.run_with_scene and (not ed.engine.hero_background or ed.engine.hero_background[1] ~= "BruceWayne_Ghtham") then
    local effect_BatLight = "eff_point_BruceWayne_ult.cha"
    local origin = {400, 0}
    caster.BruceWayne_batLight = ed.scene:playEffectOnScene(effect_BatLight, origin, nil, nil, 1)
  end
end

function BruceWayne.skillult_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  local caster = skill.caster
  local target = skill.target or caster.ai.target
  local skillultb = caster.skills.BruceWayne_ultb
  caster.oriPosition = {
    caster.position[1] - caster.direction * 50,
    caster.position[2]
  }
  local binfo = ed.lookupDataTable("Buff", nil, BruceWayne.skillatk4_SelfBuffID)
  local buff = caster:addBuff(binfo, caster)
  if attack_counter == 0 then
    if ed.run_with_scene and caster.BruceWayne_batLight then
      local z = 1
      ed.scene:removeEffect(caster.BruceWayne_batLight, z)
    end
    if ed.engine.hero_background and ed.engine.hero_background[3] ~= true then
      if ed.engine.hero_background and ed.engine.hero_background[1] == "BruceWayne_Ghtham" then
        ed.engine.hero_background = ed.engine.genHeroBackground("BruceWayne_Ghtham", 999, nil)
      else
        ed.engine.hero_background = ed.engine.genHeroBackground("BruceWayne_Ghtham", 999, nil)
        if ed.run_with_scene and not ed.IsMultiArena() then
          ed.scene:onBackgroundAppear(1, "battle_bg/bbg_BruceWayne_Gotham.jpg")
        end
      end
    end
  elseif attack_counter == 1 then
    local direction = caster.position[1] - target.position[1]
    if 0 < direction then
      caster.position = {
        target.position[1] + 35,
        target.position[2]
      }
    else
      caster.position = {
        target.position[1] - 35,
        target.position[2]
      }
    end
  elseif attack_counter == 12 then
    for unit in ed.engine:foreachAliveUnit(caster.foecamp) do
      if caster.direction > 0 and caster.position[1] < unit.position[1] and unit.position[1] - caster.position[1] < 150 or caster.direction < 0 and caster.position[1] > unit.position[1] and caster.position[1] - unit.position[1] < 150 then
        unit:knockup(0.3, ed.edpMult({
          caster.direction,
          0
        }, 50), false)
        if ed.run_with_scene then
          ed.scene:playEffectOnScene("eff_point_BruceWayne_ult2.cha", target.position, {
            target.direction,
            1
          }, nil, 0)
        end
      end
    end
  end
  if attack_counter < 13 then
    basefunc(skill)
  end
end

function BruceWayne.skillatk_start(basefunc, skill, target)
  local caster = skill.caster
  basefunc(skill, target)
  if caster.atk_count % 2 == 0 then
    skill:startPhase(1)
    caster.atk_count = caster.atk_count + 1
  else
    skill:startPhase(2)
    caster.atk_count = caster.atk_count + 1
  end
end

function BruceWayne.skillatk_takeEffectOn(basefunc, skill, target, source, shift)
  local caster = skill.caster
  basefunc(skill, target, source, shift)
  if skill.current_phase_idx == 2 then
    target:knockup(0.3, ed.edpMult({
      caster.direction,
      0
    }, 50), shift)
  end
end

function BruceWayne.skillatk_power(basefunc, skill, source, target, damage_type)
  local caster = skill.caster
  local power = basefunc(skill, source, target, damage_type)
  if skill.current_phase_idx == 2 then
    return power * BruceWayne.skillatk_2_powerRatio
  else
    return power
  end
end

function BruceWayne.skillatk_onPhaseFinished(basefunc, skill)
  skill:finish()
end

function BruceWayne.skillatk2_createProjectile(basefunc, skill)
  local caster = skill.caster
  local projectile = basefunc(skill)
  projectile:enableTrack(skill.target)
  caster.batDart = projectile
  return caster.batDart
end

function BruceWayne.skillatk2_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local attack_counter = skill.attack_counter
  local target = skill.target or caster.ai.target
  if attack_counter == 0 then
    local binfo = ed.lookupDataTable("Buff", nil, BruceWayne.skillatk4_SelfBuffID)
    local buff = caster:addBuff(binfo, caster)
    basefunc(skill)
  elseif attack_counter == 1 then
    local posDir = caster.position[1] - target.position[1]
    if 0 < posDir then
      caster.position = {
        target.position[1] - 80,
        target.position[2]
      }
    else
      caster.position = {
        target.position[1] + 80,
        target.position[2]
      }
    end
    local binfo = ed.lookupDataTable("Buff", nil, BruceWayne.skillatk4_SelfBuffID)
    local buff = caster:addBuff(binfo, caster)
  end
end

function BruceWayne.skillatk3_start(basefunc, skill, target)
  local caster = skill.caster
  basefunc(skill, target)
  local attackUnitCount = 0
  caster.attack_list = {}
  for unit in ed.engine:foreachAliveUnit(caster.foecamp) do
    if unit.config.is_summoned or unit.buffManager.invisible then
    elseif math.abs(unit.position[1] - caster.position[1]) < BruceWayne.atk3_3_attackRange then
      caster.attack_list[attackUnitCount] = unit
      attackUnitCount = attackUnitCount + 1
    end
  end
  if 3 <= attackUnitCount then
    skill:startPhase(2)
  else
    skill:startPhase(1)
  end
end

function BruceWayne.skillatk3_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local attack_counter = skill.attack_counter
  local attack_list = caster.attack_list
  local target = skill.target or caster.ai.target
  if skill.current_phase_idx == 1 and attack_counter == 1 then
    caster:setMP(caster.mp + BruceWayne.atk3_1_gainMp)
    target:idle()
    local binfo = ed.lookupDataTable("Buff", nil, BruceWayne.skillatk3_1_BuffID)
    local buff = target:addBuff(binfo, caster)
    target:knockup(0.8, ed.edpMult({
      caster.direction,
      0
    }, 200))
  end
  if skill.current_phase_idx == 2 and attack_counter == 0 and ed.run_with_scene then
    ed.scene:playEffectOnScene("eff_point_BruceWayne_atk3_2.cha", target.position, {
      target.direction,
      1
    }, nil, 0)
  end
  if skill.current_phase_idx == 2 and attack_counter == 1 or skill.current_phase_idx == 3 and attack_counter == 2 or skill.current_phase_idx == 4 and attack_counter == 5 then
    target = attack_list[skill.current_phase_idx - 2]
    target:knockup(0.2, ed.edpMult({
      caster.direction,
      0
    }, 30))
  end
  if (skill.current_phase_idx == 2 and attack_counter == 2 or skill.current_phase_idx == 3 and attack_counter == 3) and ed.run_with_scene then
    ed.scene:playEffectOnScene("eff_impact_BruceWayne_ult", caster.position, {
      caster.direction,
      1
    }, nil, 0)
  end
  basefunc(skill)
end

function BruceWayne.skillatk3_onPhaseFinished(basefunc, skill)
  local caster = skill.caster
  local current_phase_idx = skill.current_phase_idx
  local attack_list = caster.attack_list
  if current_phase_idx == 1 or current_phase_idx == 4 or caster.name ~= "BruceWayne" then
    skill:finish()
  else
    skill.attack_counter = 0
    skill:startPhase(current_phase_idx + 1)
    skill.target = attack_list[skill.current_phase_idx - 2]
    local direction = caster.position[1] - skill.target.position[1]
    if 0 < direction then
      caster.position = {
        skill.target.position[1] + 50,
        skill.target.position[2]
      }
    else
      caster.position = {
        skill.target.position[1] - 50,
        skill.target.position[2]
      }
    end
  end
end

function BruceWayne.skillatk4_canCastWithTarget(basefunc, skill, target)
  local caster = skill.caster
  local canCast = basefunc(skill, target)
  local skillult = caster.skills.BruceWayne_ult
  if not (ed.engine.stage_type ~= "dreamland" and not ed.engine.guildInstance_mode and not ed.engine.babelMode and target.config.what ~= "lordUnit" and target:isAlive()) or target.config.is_summoned or target.buffManager.invisible or target.name == "BruceWayne" or caster.config.is_summoned or caster.name ~= "BruceWayne" or ed.engine.stage_info["Chapter ID"] == 103 then
    return false
  elseif canCast and target.hp < target.attribs.HP * BruceWayne.deathRatio and target.hp < 100000 then
    local binfo = ed.lookupDataTable("Buff", nil, BruceWayne.skillatk4_fix_BuffID)
    local buffDead = target:addBuff(binfo, caster)
    if caster.current_skill and caster.current_skill ~= skillult then
      caster.current_skill:interrupt()
    end
    return true
  else
    return false
  end
end

function BruceWayne.skillatk4_start(basefunc, skill, target)
  local caster = skill.caster
  basefunc(skill, target)
  local binfo = ed.lookupDataTable("Buff", nil, BruceWayne.skillatk4_SelfBuffID)
  local buff = caster:addBuff(binfo, caster)
end

function BruceWayne.skillatk4_takeEffectOn(basefunc, skill, target, source, shift)
  local caster = skill.caster
  basefunc(skill, target, source, shift)
  if target:isAlive() and ed.run_with_scene then
    ed.scene:playEffectOnScene("eff_point_BruceWayne_atk4.cha", target.position, {
      target.direction,
      1
    }, nil, 0)
  end
  for unit in ed.engine:foreachAliveUnit(caster.foecamp) do
    if unit == target or not unit:isAlive() then
    else
      local binfo = ed.lookupDataTable("Buff", nil, BruceWayne.skillatk4_fear_BuffID)
      local buff = ed.BuffCreate(binfo, unit, caster)
      buff:setAttribute("AD", skill.info["Script Arg2"])
      unit:addBuff(buff, caster)
      local binfo = ed.lookupDataTable("Buff", nil, BruceWayne.skillatk4_fearShow_BuffID)
      local sbuff = unit:addBuff(binfo, caster)
    end
  end
end

function BruceWayne.skillatk4_finish(basefunc, skill, target)
  local caster = skill.caster
  local target = skill.target
  if target and target:isAlive() then
    target:knockup(0.5, ed.edpMult({
      caster.direction,
      0
    }, 0))
    target:die()
    target.state = ed.emUnitState_Dead
    target:setAction(nil)
    target.hasCorpse = false
    if target.actor and target.actor.node then
      target.actor.node:setVisible(false)
    end
  end
  basefunc(skill)
end

function BruceWayne.hero_update(basefunc, hero, dt)
  local skillawake = hero.skills.BruceWayne_awake
  basefunc(hero, dt)
  if skillawake and not hero.awakeBuff and hero.name == "BruceWayne" then
    local binfo = ed.lookupDataTable("Buff", nil, BruceWayne.skillawake_BuffID)
    local buff = ed.BuffCreate(binfo, hero, hero)
    buff:setAttribute("HIT", skillawake.info["Script Arg2"])
    buff:setAttribute("ARM", skillawake.info["Script Arg3"])
    buff:setAttribute("MR", skillawake.info["Script Arg4"])
    hero:addBuff(buff, hero)
    hero.awakeBuff = true
  end
end

function BruceWayne.skillmobile_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 651 then
      tbuff.timer = 0
    end
  end
  caster.position[1] = ed.engine.stage_rect.maxX / 2 - 120 * caster:getInitDir()
  local bid = 650
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
  buff.timer = 0.1
end

function BruceWayne.skillmobile_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 650 then
      tbuff.timer = 0
    end
  end
end

function BruceWayne.init_hero(hero)
  local skillmobile = hero.skills.BruceWayne_mobile
  local skillult = hero.skills.BruceWayne_ult
  local skillatk = hero.skills.BruceWayne_atk
  local skillatk2 = hero.skills.BruceWayne_atk2
  local skillatk3 = hero.skills.BruceWayne_atk3
  local skillatk4 = hero.skills.BruceWayne_atk4
  hero.reset = override(hero.reset, BruceWayne.hero_reset)
  hero.update = override(hero.update, BruceWayne.hero_update)
  if skillmobile then
    skillmobile.start = override(skillmobile.start, BruceWayne.skillmobile_start)
    skillmobile.finish = override(skillmobile.finish, BruceWayne.skillmobile_finish)
  end
  if skillult then
    skillult.start = override(skillult.start, BruceWayne.skillult_start)
    skillult.onAttackFrame = override(skillult.onAttackFrame, BruceWayne.skillult_onAttackFrame)
  end
  if skillatk then
    skillatk.start = override(skillatk.start, BruceWayne.skillatk_start)
    skillatk.takeEffectOn = override(skillatk.takeEffectOn, BruceWayne.skillatk_takeEffectOn)
    skillatk.power = override(skillatk.power, BruceWayne.skillatk_power)
    skillatk.onPhaseFinished = override(skillatk.onPhaseFinished, BruceWayne.skillatk_onPhaseFinished)
  end
  if skillatk2 then
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, BruceWayne.skillatk2_onAttackFrame)
    skillatk2.createProjectile = override(skillatk2.createProjectile, BruceWayne.skillatk2_createProjectile)
  end
  if skillatk3 then
    skillatk3.start = override(skillatk3.start, BruceWayne.skillatk3_start)
    skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, BruceWayne.skillatk3_onAttackFrame)
    skillatk3.onPhaseFinished = override(skillatk3.onPhaseFinished, BruceWayne.skillatk3_onPhaseFinished)
  end
  if skillatk4 then
    skillatk4.canCastWithTarget = override(skillatk4.canCastWithTarget, BruceWayne.skillatk4_canCastWithTarget)
    skillatk4.start = override(skillatk4.start, BruceWayne.skillatk4_start)
    skillatk4.takeEffectOn = override(skillatk4.takeEffectOn, BruceWayne.skillatk4_takeEffectOn)
    skillatk4.finish = override(skillatk4.finish, BruceWayne.skillatk4_finish)
  end
  return hero
end

return BruceWayne.init_hero
