module("ed.battlehero", package.seeall)
local ed = ed
TitanSword = {}

function TitanSword.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local hero = skill.caster
  local bid = 4377
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  hero:addBuff(binfo, hero)
end

function TitanSword.skillult_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 4377 then
      tbuff.timer = 2.5
    end
  end
  caster.TitanSword_ultchange = true
  if caster.TitanSword_ultchange then
    if caster.currentActionStage == 1 then
      caster:enterActionStageFromOneStage(2, 10113)
    elseif caster.currentActionStage == 3 then
      caster:enterActionStageFromOneStage(4, 10113)
    end
    if ed.run_with_scene then
      local panel = caster.heroPanel
      if panel and caster.name == "TitanSword" and (caster.currentActionStage == 2 or caster.currentActionStage == 4) then
        panel:setPortrait("UI/DOTA-HERO/TitanSword2.jpg")
      end
    end
  end
end

function TitanSword.skillults_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 4376 or tbuff.info.ID == 4377 then
      tbuff.timer = -1
    end
  end
  caster.TitanSword_ultchange = false
  if not caster.TitanSword_ultchange then
    if caster.currentActionStage == 2 then
      caster:enterActionStageFromOneStage(1, 10113)
    end
    if caster.currentActionStage == 4 then
      caster:enterActionStageFromOneStage(3, 10113)
    end
    if ed.run_with_scene then
      local panel = caster.heroPanel
      if panel and caster.name == "TitanSword" and (caster.currentActionStage == 1 or caster.currentActionStage == 3) then
        panel:setPortrait("UI/DOTA-HERO/TitanSword.jpg")
      end
    end
  end
end

function TitanSword.skillult_canCastWithTarget(basefunc, skill, target)
  local hero = skill.caster
  local skillatk4 = hero.skills.TitanSword_atk4
  if not basefunc(skill, target) or hero.TitanSword_ultchange or hero.mp < 800 and hero.name == "TitanSword" or skillatk4.casting or skill.casting then
    return false
  end
  return true
end

function TitanSword.skillult_onAttackFrame(basefunc, skill)
  basefunc(skill)
  if ed.run_with_scene then
    ed.scene:startCameraShakeAnimationY(5, 0.1, 5)
  end
end

function TitanSword.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  local skillatk3 = hero.skills.TitanSword_atk3
  local skillatk3s = hero.skills.TitanSword_atk3s
  local skillults = hero.skills.TitanSword_ults
  if (skillatk3 or skillatk3s) and not hero.TitanSword_atk3_extradmg and hero.hp > hero.attribs.HP * 0.7 and not hero.current_skill then
    hero.TitanSword_atk3_extralfs = false
    hero.TitanSword_atk3_extradmg = true
    if hero.currentActionStage == 3 then
      hero:enterActionStageFromOneStage(1, 10113)
    end
    if hero.currentActionStage == 4 then
      hero:enterActionStageFromOneStage(2, 10113)
    end
  end
  if (skillatk3 or skillatk3s) and not hero.TitanSword_atk3_extralfs and hero.hp < hero.attribs.HP * 0.3 and not hero.current_skill then
    hero.TitanSword_atk3_extralfs = true
    hero.TitanSword_atk3_extradmg = false
    if hero.currentActionStage == 1 then
      hero:enterActionStageFromOneStage(3, 10113)
    end
    if hero.currentActionStage == 2 then
      hero:enterActionStageFromOneStage(4, 10113)
    end
  end
end

function TitanSword.getDamage(basefunc, skill, target, power, damage_type, field, source, crit_mod)
  local caster = skill.caster
  local skillatk3 = caster.skills.TitanSword_atk3
  local skillatk3s = caster.skills.TitanSword_atk3s
  local damage_ratio = 0.87
  if caster.TitanSword_hasArcana and caster.TitanSword_hasArcana > 2 then
    damage_ratio = 1
  end
  if caster.TitanSword_atk3_extradmg and (skillatk3 or skillatk3) then
    local dice = ed.rand()
    local rand_value = 1 + (dice - 0.5) * 0.4
    local extradmg = skillatk3.info["Script Arg2"] or skillatk3s.info["Script Arg2"]
    power = power + extradmg * rand_value
    caster:takeDamage(extradmg * rand_value, "AD", "hp", caster)
  elseif caster.TitanSword_atk3_extralfs then
    power = power * damage_ratio
  end
  if target and target:isAlive() and not target.buff_effects.invulnerable then
    local dmg = target:takeDamage({
      amount = power,
      damage_type = damage_type,
      field = field,
      source = source,
      crit_mod = crit_mod,
      skill = skill
    })
    return dmg
  else
    local dmg = 0
    return dmg
  end
end

function TitanSword.takeEffectOn(basefunc, skill, target, source, shift)
  local caster = skill.caster
  local originfo = skill.info
  local skillatk3 = caster.skills.TitanSword_atk3
  local skillatk3s = caster.skills.TitanSword_atk3s
  if caster.TitanSword_atk3_extralfs and (skillatk3 or skillatk3s) then
    local lfs = skill.info["LFS%"]
    skill.info = ed.wraptable(originfo, {
      ["LFS%"] = lfs * ((skillatk3.info["Script Arg3"] or skillatk3s.info["Script Arg3"]) * 0.01 + 1)
    })
  end
  basefunc(skill, target, source, shift)
  skill.info = originfo
end

function TitanSword.hero_reset(basefunc, hero)
  basefunc(hero)
  if hero.currentActionStage == 2 then
    hero:enterActionStageFromOneStage(1, 10113)
  elseif hero.currentActionStage == 4 then
    hero:enterActionStageFromOneStage(3, 10113)
  end
  for i, tbuff in ipairs(hero.buff_list) do
    if tbuff.info.ID == 4376 or tbuff.info.ID == 4377 then
      tbuff.timer = -1
    end
  end
  hero.TitanSword_ultchange = false
end

function TitanSword.skillatk4_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  local caster = skill.caster
  local target = skill.target
  if attack_counter then
    if attack_counter == 0 then
      local MPGR = caster.attribs.MPGainRatio
      repeat
        if MPGR ~= nil then
        end
        caster:setMP(caster.mp + skill.info["Gain MP"] * ed.engine.mp_bonus)
        do break end -- pseudo-goto
        caster:setMP(caster.mp + skill.info["Gain MP"] * ed.engine.mp_bonus * (1 + MPGR / 100))
      until true
      local region_position = {
        caster.position[1] + 200 * caster.direction,
        0
      }
      caster.atk4_region_position = region_position
      local skillatk4region = caster.skills.TitanSword_atk4_region
      if skill.atk4_region then
        skill.atk4_region:terminate()
      end
      if skillatk4region then
        skillatk4region.target = caster
        local region = skillatk4region:createRegion()
        region.position = region_position
        skill.atk4_region = region
        caster.atk4_region = region
        ed.engine:addRegion(region)
      end
      skill.attack_counter = skill.attack_counter + 1
    elseif attack_counter == 1 then
      if skill.atk4_region then
        skill.atk4_region:terminate()
      end
      skill:takeEffectAt(caster.position, caster)
    end
  end
end

function TitanSword.skillatk4_start(basefunc, skill, target)
  local caster = skill.caster
  skill.info["No Dodge"] = true
  if caster.TitanSword_hasArcana and caster.TitanSword_hasArcana > 1 then
    local bid = 4378
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    caster:addBuff(binfo, caster)
  else
    local bid = 4382
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    caster:addBuff(binfo, caster)
  end
  basefunc(skill, target)
end

function TitanSword.skillatk4_finish(basefunc, skill)
  basefunc(skill)
  if skill.atk4_region then
    skill.atk4_region:terminate()
  end
  for i, tbuff in ipairs(skill.caster.buff_list) do
    if tbuff.info.ID == 4378 or tbuff.info.ID == 4382 then
      tbuff.timer = -1
    end
  end
end

function TitanSword.skillatk4region_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  buff.update = override(buff.update, TitanSword.skillatk4buff_update)
  buff.knock_count = 0
  local direction = (target.position[1] - caster.position[1]) * caster.direction
  if direction < 0 then
    buff.timer = -1
  end
  return buff
end

function TitanSword.skillatk4buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  buff.knock_count = buff.knock_count - 1
  local caster = buff.caster
  local owner = buff.owner
  local region_position = {
    caster.position[1] + 30 * caster.direction,
    0
  }
  local time = 0.05
  local distance = -2
  local distanceplus = 0
  local distance_last = -2
  local direction = {1, 0}
  local DistanceSQ = ed.edpDistanceSQ(owner.position, region_position)
  local range = 30
  local atk4_range = 200
  if buff.knock_count < 0 then
    if owner.position[1] == region_position[1] then
      direction = ed.edpNormalize({
        caster.direction,
        0
      })
    elseif DistanceSQ < range * range then
      local directionold = ed.edpNormalize(ed.edpCompMult({1, 1}, ed.edpSub(owner.position, region_position)))
      direction[1] = -directionold[2]
      direction[2] = directionold[1]
      distance_last = distance + distanceplus
    else
      direction = ed.edpNormalize(ed.edpCompMult({1, 1}, ed.edpSub(owner.position, region_position)))
      distance_last = distance + distanceplus * (atk4_range - math.sqrt(DistanceSQ)) / (atk4_range - range)
    end
    owner:knockup(time, ed.edpMult(direction, distance_last), true)
    buff.knock_count = 0
  end
end

function TitanSword.skillult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  if caster.TitanSword_hasArcana and caster.TitanSword_hasArcana > 3 then
    local MPR = buff.info.MPR
    buff:setAttribute("MPR", MPR + 27)
  end
  buff.update = override(buff.update, TitanSword.skillult_buffUpdate)
  return buff
end

function TitanSword.skillult_buffUpdate(basefunc, buff, dt)
  basefunc(buff, dt)
  local hero = buff.owner
  local skillults = hero.skills.TitanSword_ults
  local skillatk4 = hero.skills.TitanSword_atk4
  if buff.owner.mp <= 1 and buff.owner:isAlive() then
    buff.owner.removeBuff(buff.owner, buff)
    if hero.currentActionStage == 2 or hero.currentActionStage == 4 and hero.TitanSword_ultchange and skillults and hero.current_skill ~= skillatk4 then
      skillults.cd_remaining = 0
      hero.global_cd = 0
    end
  end
end

function TitanSword.skillatk2_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  local caster = skill.caster
  return projectile
end

function TitanSword.skillatk2_start(basefunc, skill, target)
  skill.info["No Dodge"] = true
  basefunc(skill, target)
end

function TitanSword.skillatk2_launchPoint(basefunc, skill)
  local caster = skill.caster
  local dir = caster.direction
  return {
    caster.position[1],
    0
  }, 0
end

function TitanSword.hero_die(basefunc, hero, killer)
  basefunc(hero, killer)
  if hero.atk4_region then
    hero.atk4_region:terminate()
  end
end

function TitanSword.init_hero(hero)
  local skillult = hero.skills.TitanSword_ult
  local skillults = hero.skills.TitanSword_ults
  local skillatk = hero.skills.TitanSword_atk
  local skillatks = hero.skills.TitanSword_atks
  local skillatk2 = hero.skills.TitanSword_atk2
  local skillatk2s = hero.skills.TitanSword_atk2s
  local skillatk3 = hero.skills.TitanSword_atk3
  local skillatk3s = hero.skills.TitanSword_atk3s
  local skillatk4 = hero.skills.TitanSword_atk4
  local skillatk4region = hero.skills.TitanSword_atk4_region
  hero.reset = override(hero.reset, TitanSword.hero_reset)
  hero.update = override(hero.update, TitanSword.hero_update)
  hero.die = override(hero.die, TitanSword.hero_die)
  hero:setActionStageChangeByManual(true)
  hero.TitanSword_hasArcana = ed.getProtoArcanaLevel(hero.proto)
  if skillatk then
    skillatk.getDamage = override(skillatk.getDamage, TitanSword.getDamage)
    skillatk.takeEffectOn = override(skillatk.takeEffectOn, TitanSword.takeEffectOn)
  end
  if skillatks then
    skillatks.getDamage = override(skillatks.getDamage, TitanSword.getDamage)
    skillatks.takeEffectOn = override(skillatks.takeEffectOn, TitanSword.takeEffectOn)
  end
  if skillatk2 then
    skillatk2.getDamage = override(skillatk2.getDamage, TitanSword.getDamage)
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, TitanSword.takeEffectOn)
    skillatk2.createProjectile = override(skillatk2.createProjectile, TitanSword.skillatk2_createProjectile)
    skillatk2.launchPoint = override(skillatk2.launchPoint, TitanSword.skillatk2_launchPoint)
    skillatk2.start = override(skillatk2.start, TitanSword.skillatk2_start)
  end
  if skillatk2s then
    skillatk2s.getDamage = override(skillatk2s.getDamage, TitanSword.getDamage)
    skillatk2s.takeEffectOn = override(skillatk2s.takeEffectOn, TitanSword.takeEffectOn)
    skillatk2s.launchPoint = override(skillatk2s.launchPoint, TitanSword.skillatk2_launchPoint)
    skillatk2s.start = override(skillatk2s.start, TitanSword.skillatk2_start)
  end
  if skillatk4 then
    skillatk4.start = override(skillatk4.start, TitanSword.skillatk4_start)
    skillatk4.finish = override(skillatk4.finish, TitanSword.skillatk4_finish)
    skillatk4.getDamage = override(skillatk4.getDamage, TitanSword.getDamage)
    skillatk4.takeEffectOn = override(skillatk4.takeEffectOn, TitanSword.takeEffectOn)
    skillatk4.onAttackFrame = override(skillatk4.onAttackFrame, TitanSword.skillatk4_onAttackFrame)
  end
  if skillatk4region then
    skillatk4region.createBuff = override(skillatk4region.createBuff, TitanSword.skillatk4region_createBuff)
  end
  if skillult then
    skillult.start = override(skillult.start, TitanSword.skillult_start)
    skillult.finish = override(skillult.finish, TitanSword.skillult_finish)
    skillult.onAttackFrame = override(skillult.onAttackFrame, TitanSword.skillult_onAttackFrame)
    skillult.canCastWithTarget = override(skillult.canCastWithTarget, TitanSword.skillult_canCastWithTarget)
    skillult.createBuff = override(skillult.createBuff, TitanSword.skillult_createBuff)
  end
  if skillults then
    skillults.start = override(skillults.start, TitanSword.skillult_start)
    skillults.finish = override(skillults.finish, TitanSword.skillults_finish)
  end
  return hero
end

return TitanSword.init_hero
