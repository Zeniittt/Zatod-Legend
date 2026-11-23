module("ed.battlehero", package.seeall)
local ed = ed
AwakeBossPudge = {}
AwakeBossPudge.startTime = 1.5
AwakeBossPudge.midTime = 2.25
AwakeBossPudge.totalTime = 4.083333
AwakeBossPudge.ratio = 0.0646875
AwakeBossPudge.startPosPix = 1274
AwakeBossPudge.endPosPix = 4992
AwakeBossPudge.hookScale = {
  startPos = AwakeBossPudge.startPosPix * AwakeBossPudge.ratio,
  endPos = AwakeBossPudge.endPosPix * AwakeBossPudge.ratio
}
AwakeBossPudge.hookTime = {startTime = 1.5, midTime = 2.25}
AwakeBossPudge.hookRange = 50
AwakeBossPudge.autohookGap = 0.125
AwakeBossPudge.skillatk2_buff_interval = 1

function AwakeBossPudge.ultTimeToPosition(hook, skill)
  local current_time = skill.current_phase_elapsed
  local positionX = skill.caster.position[1]
  local direction = skill.caster.direction
  local animratio = skill.caster.config.size_mod
  if current_time >= AwakeBossPudge.startTime and current_time <= AwakeBossPudge.midTime then
    local t = current_time - AwakeBossPudge.startTime
    local t2 = AwakeBossPudge.hookTime.midTime - AwakeBossPudge.hookTime.startTime
    local s = ((AwakeBossPudge.hookScale.endPos - AwakeBossPudge.hookScale.startPos) * t / t2 + AwakeBossPudge.hookScale.startPos) * animratio
    positionX = positionX + s * direction - 15
  elseif current_time < AwakeBossPudge.startTime then
    positionX = positionX + 70
  end
  return positionX
end

function AwakeBossPudge.checkHook(hook, skill, target)
  local success = false
  local victim
  local position = hook:ultTimeToPosition(skill)
  local min = AwakeBossPudge.hookRange
  local caster = skill.caster
  local targetposition = target.position
  local distant = math.abs(targetposition[1] - position)
  if min > distant then
    victim = target
    success = true
  end
  return success, victim
end

function AwakeBossPudge.pullVictim(hook, victim)
  local caster = hook.skill.caster
  local direction = caster.direction
  if victim.buff_effects.stable then
    return false
  end
  local caster = hook.skill.caster
  victim:knockup(0.2, {
    caster.position[1] + direction * 80 - victim.position[1],
    caster.position[2] - victim.position[2]
  })
  return true
end

function AwakeBossPudge.withdrawHook(hook, skill)
  local actor = skill.caster.actor
  skill.current_phase_elapsed = AwakeBossPudge.totalTime - 0.375
  skill.caster.action_elapsed = skill.caster.action_duration - 0.375
  if actor then
    actor.puppet:setActionElapsed(skill.caster.action_elapsed)
  end
end

function AwakeBossPudge.createHook(skill)
  local hook = {}
  hook.skill = skill
  hook.ultTimeToPosition = AwakeBossPudge.ultTimeToPosition
  hook.pullVictim = AwakeBossPudge.pullVictim
  hook.withdrawHook = AwakeBossPudge.withdrawHook
  hook.checkHook = AwakeBossPudge.checkHook
  skill.hook = hook
  return skill.hook
end

function AwakeBossPudge.skillult_takeEffectAt(basefunc, skill)
end

function AwakeBossPudge.skillult_update(basefunc, skill, dt_action, dt_cd)
  basefunc(skill, dt_action, dt_cd)
  local hook = skill.hook
  local caster = skill.caster
  if skill.target then
    local current_time = skill.current_phase_elapsed
    local positionX = skill.caster.position[1]
    local direction = skill.caster.direction
    local animratio = skill.caster.config.size_mod
    if not (current_time >= AwakeBossPudge.startTime and current_time <= AwakeBossPudge.midTime) or skill.target.buff_effects.invulnerable then
    else
      local success, victim = hook:checkHook(skill, skill.target)
      if success and victim then
        hook:pullVictim(victim)
        skill:takeEffectOn(victim)
        hook:withdrawHook(skill)
      end
    end
  end
end

function AwakeBossPudge.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  if skill.evo_rank and skill.evo_rank >= 3 then
    local bid = 12002007
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, caster, caster)
    caster:addBuff(buff, caster)
  end
end

function AwakeBossPudge.skillult_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 12002007 then
      caster:removeBuff(tbuff)
    end
  end
  local skillatk3 = skill.caster.skills.AwakeBossPudge_atk3
  if skillatk3 and skillatk3.evo_rank and skillatk3.evo_rank >= 3 then
    skill.caster.global_cd = 0
    skillatk3.cd_remaining = 0
  end
end

function AwakeBossPudge.skillatk3_onAttackFrame(basefunc, skill)
  basefunc(skill)
  if not (skill.target and skill.target:isAlive()) or not skill.AwakeBossPudge_target then
    skill:finish()
  end
end

function AwakeBossPudge.skillatk3_buffonRemoved(basefunc, buff)
  basefunc(buff)
  if buff.timer > 0 and buff.caster.current_skill and buff.caster.current_skill.AwakeBossPudge_target then
    buff.caster.current_skill:finish()
  end
end

function AwakeBossPudge.skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.onRemoved = override(buff.onRemoved, AwakeBossPudge.skillatk3_buffonRemoved)
  skill.AwakeBossPudge_target = target
  return buff
end

function AwakeBossPudge.skillatk3_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  if skill.evo_rank and skill.evo_rank >= 2 then
    local bid = 12002007
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, caster, caster)
    caster:addBuff(buff, caster)
  end
end

function AwakeBossPudge.skillatk3_finish(basefunc, skill)
  if skill.AwakeBossPudge_target then
    for _, tbuff in ipairs(skill.AwakeBossPudge_target.buff_list) do
      if tbuff.info.ID == 12002007 then
        local buff = tbuff
        buff.timer = 0
        break
      end
    end
  end
  skill.AwakeBossPudge_target = nil
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 12002007 then
      caster:removeBuff(tbuff)
    end
  end
  return basefunc(skill)
end

function AwakeBossPudge.skillatk3_takeEffectOn(basefunc, skill, target, source)
  local attack_counter = skill.attack_counter
  local originfo = skill.info
  if skill.AwakeBossPudge_target and target ~= skill.AwakeBossPudge_target then
    skill:finish()
    skill.AwakeBossPudge_target = nil
    return false
  end
  if attack_counter == 1 then
    local _, dmg = basefunc(skill, target, source)
    if dmg and 0 < dmg then
      skill.caster:takeHeal(dmg, "hp", skill.caster)
    end
  elseif 2 <= attack_counter and attack_counter <= 5 then
    skill.info = ed.wraptable(originfo, {
      ["Buff ID"] = 0
    })
    local _, dmg = basefunc(skill, target, source)
    target:hurt()
    if dmg and 0 < dmg then
      skill.caster:takeHeal(dmg, "hp", skill.caster)
    end
    skill.info = originfo
  else
    local skill_kick = skill.caster.skills.AwakeBossPudge_atk3_kick
    skill_kick:takeEffectOn(target, source)
  end
end

function AwakeBossPudge.skillatk2_buff_update(basefunc, buff, dt)
  local caster = buff.caster
  local skill = caster.skills.AwakeBossPudge_atk2_enemy
  local timer = buff.refresh_timer - dt
  while timer < 0 do
    timer = timer + AwakeBossPudge.skillatk2_buff_interval
    skill:takeEffectAt(caster.position, caster)
  end
  buff.refresh_timer = timer
  basefunc(buff, dt)
end

function AwakeBossPudge.skillatk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  if skill.evo_rank and skill.evo_rank >= 1 then
    buff:setAttribute("MIMU", skill.evo_rank1["Script Arg1"])
  end
  if skill.evo_rank and skill.evo_rank >= 2 then
    buff:setAttribute("HPR", 0)
  end
  buff.update = override(buff.update, AwakeBossPudge.skillatk2_buff_update)
  buff.refresh_timer = AwakeBossPudge.skillatk2_buff_interval
  return buff
end

function AwakeBossPudge.skillatk2_enemy_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = buff.caster
  local skillatk2 = caster.skills.AwakeBossPudge_atk2
  buff.origin_hpr = buff.info.HPR
  if skillatk2.evo_rank and skillatk2.evo_rank >= 3 then
    local dmgratio = caster.hp * skillatk2.evo_rank3["Script Arg1"] / 100
    buff:setAttribute("HPR", buff.origin_hpr - math.min(dmgratio, skillatk2.evo_rank3["Script Arg2"]))
  end
  return buff
end

function AwakeBossPudge.getLostHPAfterImmunity(basefunc, unit, damage, immunity, damage_type, source, skill, field)
  local lostHP = basefunc(unit, damage, immunity, damage_type, source, skill, field)
  local skillpasv = unit.passive_skill_list[1]
  if skillpasv then
    local distanceSQ = math.min(math.abs(math.sqrt(ed.edpDistanceSQ(unit.position, source.position))), 300)
    if field == "hp" then
      lostHP = lostHP * math.max(distanceSQ / 300, 0.2)
    end
  end
  return lostHP
end

function AwakeBossPudge.power(basefunc, skill, source, target, damage_type)
  local dmg = basefunc(skill, source, target, damage_type)
  if target then
    dmg = target.hp * 0.9
  end
  return dmg
end

function AwakeBossPudge.init_hero(hero)
  local skillult = hero.skills.AwakeBossPudge_ult
  if skillult then
    AwakeBossPudge.createHook(skillult)
    if skillult.evo_rank and skillult.evo_rank >= 1 then
      skillult.info = ed.wraptable(skillult.info, {
        ["Plus Ratio"] = skillult.evo_rank1["Script Arg1"]
      })
    end
    if skillult.evo_rank and skillult.evo_rank >= 2 then
      skillult.info = ed.wraptable(skillult.info, {
        ["Plus Ratio"] = skillult.evo_rank2["Script Arg1"]
      })
    end
    if skillult.evo_rank and skillult.evo_rank >= 3 then
      skillult.info = ed.wraptable(skillult.info, {
        ["Plus Ratio"] = skillult.evo_rank3["Script Arg1"]
      })
    end
    skillult.power = override(skillult.power, AwakeBossPudge.power)
    skillult.start = override(skillult.start, AwakeBossPudge.skillult_start)
    skillult.finish = override(skillult.finish, AwakeBossPudge.skillult_finish)
    skillult.update = override(skillult.update, AwakeBossPudge.skillult_update)
    skillult.takeEffectAt = override(skillult.takeEffectAt, AwakeBossPudge.skillult_takeEffectAt)
  end
  local skillatk2 = hero.skills.AwakeBossPudge_atk2
  local skillatk2_enemy = hero.skills.AwakeBossPudge_atk2_enemy
  if skillatk2 then
    skillatk2.createBuff = override(skillatk2.createBuff, AwakeBossPudge.skillatk2_createBuff)
    if skillatk2_enemy and skillatk2.evo_rank and skillatk2.evo_rank >= 3 then
      skillatk2_enemy.createBuff = override(skillatk2_enemy.createBuff, AwakeBossPudge.skillatk2_enemy_createBuff)
    end
  end
  local skillatk3 = hero.skills.AwakeBossPudge_atk3
  if skillatk3 then
    skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, AwakeBossPudge.skillatk3_onAttackFrame)
    skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, AwakeBossPudge.skillatk3_takeEffectOn)
    skillatk3.createBuff = override(skillatk3.createBuff, AwakeBossPudge.skillatk3_createBuff)
    skillatk3.start = override(skillatk3.start, AwakeBossPudge.skillatk3_start)
    skillatk3.finish = override(skillatk3.finish, AwakeBossPudge.skillatk3_finish)
    local skill_kick = hero.skills.AwakeBossPudge_atk3_kick
    if skillatk3.evo_rank and skillatk3.evo_rank >= 1 then
      skillatk3.info = ed.wraptable(skillatk3.info, {
        ["Plus Ratio"] = skillatk3.evo_rank1["Script Arg1"]
      })
      if skill_kick then
        skill_kick.info = ed.wraptable(skill_kick.info, {
          ["Plus Ratio"] = skillatk3.evo_rank1["Script Arg1"]
        })
      end
    end
  end
  local skillpasv = hero.passive_skill_list[1]
  if skillpasv then
    local aname = skillpasv["Passive Attr"]
    local num = skillpasv["Basic Num"]
    local oriattribs = hero.attribs[aname]
    if skillpasv.evo_rank and skillpasv.evo_rank >= 1 then
      skillpasv["Basic Num"] = skillpasv["Basic Num"] + skillpasv.evo_rank1["Script Arg1"]
    end
    if skillpasv.evo_rank and skillpasv.evo_rank >= 2 then
      skillpasv["Basic Num"] = skillpasv["Basic Num"] + skillpasv.evo_rank2["Script Arg1"]
    end
    if skillpasv.evo_rank and skillpasv.evo_rank >= 3 then
      skillpasv["Basic Num"] = skillpasv["Basic Num"] + skillpasv.evo_rank3["Script Arg1"]
    end
    hero.getLostHPAfterImmunity = override(hero.getLostHPAfterImmunity, AwakeBossPudge.getLostHPAfterImmunity)
    hero:rebuild()
  end
  return hero
end

return AwakeBossPudge.init_hero
