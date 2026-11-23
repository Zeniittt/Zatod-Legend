module("ed.battlehero", package.seeall)
local ed = ed
AwakeBossLC = {}
AwakeBossLC.velocity = 480
AwakeBossLC.startPosition = {-250, 1050}
AwakeBossLC.skillatk4_coef = 4
AwakeBossLC.uncon = 12004711

function AwakeBossLC.skillatk4_canCastWithTarget(basefunc, skill, target)
  local caster = skill.caster
  local ret, err = basefunc(skill, target)
  if not ret then
    return ret, err
  end
  if caster.ultGoing_AwakeBossLC then
    return false, "ultGoing"
  end
  return true
end

function AwakeBossLC.skillatk4_start(basefunc, self, target)
  local info = self.info
  local caster = self.caster
  if do_battle_log then
    btlog("%s began to cast %s --> %s", self.caster:display(), self:display(), target and target:display() or "nil")
  end
  self.target = target
  self:selectTarget(target)
  self.cd_remaining = info.CD
  self.casting = true
  self.attack_counter = 0
  if caster.currentActionStage == 1 then
    self:startPhase(1)
  else
    self:startPhase(2)
  end
  self.is_update = true
  caster.global_cd = info["Global CD"]
  caster:setMP(caster.mp - info["Cost MP"] * (1 - caster.attribs.CDR / 100))
  if caster.actor then
    local effect_name = info["Launch Effect"]
    if effect_name then
      caster.actor:addEffect(effect_name, -1)
    end
  end
  caster.originposition_AwakeBossLC = {
    caster.position[1],
    caster.position[2]
  }
  caster.skillatk4_affected_units_AwakeBossLC = {}
  local hasBuff = false
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 12004701 and tbuff.timer < 5 then
      tbuff.timer = self.info["Script Arg2"] - 5
      hasBuff = true
      break
    end
  end
  local shard = caster.proto._shard
  local bid = AwakeBossLC.uncon
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  caster:addBuff(binfo, caster)
end

function AwakeBossLC.skillatk4_onPhaseFinished(basefunc, skill)
  local caster = skill.caster
  if skill.current_phase_idx == 1 or skill.current_phase_idx == 2 then
    caster.ultGoing_AwakeBossLC = true
    caster.walk_v = {
      caster.direction * AwakeBossLC.velocity,
      0
    }
    skill:startPhase(3)
  elseif skill.current_phase_idx == 3 then
    caster.ultGoing_AwakeBossLC = nil
    caster.walk_v = {0, 0}
    basefunc(skill)
  elseif skill.current_phase_idx == 4 then
    basefunc(skill)
  end
end

function AwakeBossLC.atk4buff_onRemoved(basefunc, buff)
  basefunc(buff)
  local owner = buff.owner
  owner.ultBuff_AwakeBossLC = false
end

function AwakeBossLC.skillatk4_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local hasBuff = false
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 12004701 and tbuff.timer < 5 then
      tbuff.timer = skill.info["Script Arg2"] - 5
      hasBuff = true
      break
    end
  end
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == AwakeBossLC.uncon then
      local buff = tbuff
      buff.timer = -1
    end
  end
  if not hasBuff then
    local bid = 12004701
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = caster:addBuff(binfo, caster)
    if buff then
      buff.onRemoved = override(buff.onRemoved, AwakeBossLC.atk4buff_onRemoved)
      buff.timer = skill.info["Script Arg2"]
      caster.ultBuff_AwakeBossLC = true
    end
  end
  skill.crossing = nil
  skill.crossing2 = nil
  caster.ultGoing_AwakeBossLC = nil
  caster.walk_v = {0, 0}
  caster.skillatk4_affected_units_AwakeBossLC = {}
end

function AwakeBossLC.skillatk4_onAttackFrame(basefunc, skill)
  if skill.caster.manually_casting then
    ed.engine:unfreeze()
    skill.caster.manually_casting = false
  end
  skill.attack_counter = skill.attack_counter + 1
end

function AwakeBossLC.hero_update(basefunc, hero, dt)
  local skillatk4 = hero.skills.AwakeBossLC_atk4
  if skillatk4 and hero.ultGoing_AwakeBossLC then
    local info = skillatk4.info
    local direction = hero.direction
    local location = hero.position
    local origin = {
      location[1] + info["X Shift"] * direction,
      location[2]
    }
    local shape = info["AOE Shape"]
    local arg1 = info["Shape Arg1"]
    local arg2 = info["Shape Arg2"]
    for unit in ed.engine:foreachAliveUnit(skillatk4:affectedCamp()) do
      local skillatk4_affected_units_AwakeBossLC = hero.skillatk4_affected_units_AwakeBossLC
      if not skillatk4_affected_units_AwakeBossLC[unit] then
        local p2 = ed.edpSub(unit.position, origin)
        p2[1] = p2[1] * direction
        if skillatk4.testPointInShape(p2, shape, arg1, arg2) then
          skillatk4_affected_units_AwakeBossLC[unit] = true
          skillatk4:takeEffectOn(unit, hero)
        end
      end
    end
    if not skillatk4.crossing and not skillatk4.crossing2 then
      if hero.position[1] > 799 - AwakeBossLC.velocity / 8 and hero.direction == 1 then
        hero.position[1] = AwakeBossLC.startPosition[1]
        skillatk4.crossing = true
        hero.skillatk4_affected_units_AwakeBossLC = {}
      elseif hero.position[1] < 1 + AwakeBossLC.velocity / 8 and hero.direction == -1 then
        hero.position[1] = AwakeBossLC.startPosition[2]
        skillatk4.crossing2 = true
        hero.skillatk4_affected_units_AwakeBossLC = {}
      end
    end
    if skillatk4.crossing and hero.position[1] > hero.originposition_AwakeBossLC[1] - 80 then
      local distance = hero.originposition_AwakeBossLC[1] - hero.position[1]
      skillatk4.crossing = nil
      hero.walk_v = {
        distance / 0.25,
        0
      }
    end
    if hero.skills.AwakeBossLC_atk4.crossing2 and hero.position[1] < hero.originposition_AwakeBossLC[1] + 80 then
      local distance = hero.originposition_AwakeBossLC[1] - hero.position[1]
      skillatk4.crossing2 = nil
      hero.walk_v = {
        distance / 0.25,
        0
      }
    end
  end
  basefunc(hero, dt)
end

function AwakeBossLC.hero_reset(basefunc, hero)
  basefunc(hero)
  local skillatk4 = hero.skills.AwakeBossLC_atk4
  if skillatk4 then
    hero.skills.AwakeBossLC_atk4.crossing = nil
    hero.skills.AwakeBossLC_atk4.crossing2 = nil
  end
  hero.originposition_AwakeBossLC = nil
  hero.ultGoing_AwakeBossLC = nil
  hero.walk_v = {0, 0}
  hero.skillatk4_affected_units_AwakeBossLC = {}
  hero.DamageTime = nil
  hero.AllDamageTime = nil
end

function AwakeBossLC.basefunc1(basefunc, skill)
  if skill.caster.manually_casting and skill.attack_counter == 7 then
    ed.engine:unfreeze()
    skill.caster.manually_casting = false
  end
  skill.attack_counter = skill.attack_counter + 1
  if (skill.info["Target Type"] == "random" or skill.target == nil or not skill.target:isAlive()) and skill.attack_counter == 1 then
    skill:selectTarget(nil)
  end
  if not skill.target then
    return
  end
  local info = skill.info
  local caster = skill.caster
  local ttype = info["Track Type"]
  if ttype == "projectile" then
    local projectile = skill:createProjectile()
    ed.engine:addProjectile(projectile)
  elseif ttype == "chain" then
    local chain = skill:createChain()
    ed.engine:addChain(chain)
  elseif ttype == nil then
    skill:takeEffectAt(skill.target.position)
  else
    EDDebug("Unkonwn Track Type: '" .. ttype .. "'")
  end
  caster:setMP(caster.mp + info["Gain MP"] * ed.engine.mp_bonus)
  if info["Move Forward"] ~= 0 then
    caster.position[1] = caster.position[1] + info["Move Forward"] * caster.direction
  end
end

function AwakeBossLC.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  if skill.target then
    skill.target:unfreezeActor()
  end
end

function AwakeBossLC.skillatk4_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local buffInfo = buff.info
  local owner = buff.owner
  local caster = buff.caster
  local attribName = buffInfo.Tenacity
  local TEN_final = ed.Buff.getTenValue(buffInfo, owner, caster)
  if skill.evo_rank and skill.evo_rank >= 3 then
    buff.timer = skill.evo_rank3["Script Arg1"] * math.max(0.01, 1 - TEN_final / 100)
  end
  return buff
end

function AwakeBossLC.skillult_willCast(basefunc, skill)
  local flag = true
  if skill.caster.skills.AwakeBossLC_atk4 ~= nil and skill.caster.current_skill == skill.caster.skills.AwakeBossLC_atk4 then
    flag = false
  end
  return basefunc(skill) and flag
end

function AwakeBossLC.skillult_onAttackFrame(basefunc, skill)
  local originfo = skill.info
  local attack_counter = skill.attack_counter
  if not skill.caster.target1 or not skill.caster.target1:isAlive() then
  end
  if attack_counter == 0 then
    local caster = skill.caster
    local target = skill.target
    if skill.target and not skill.target.buff_effects.stable then
      target.position = {
        caster.position[1] + caster.direction * 140,
        caster.position[2]
      }
    end
    skill.info = ed.wraptable(originfo, {
      ["Shape Arg1"] = 351,
      ["Knock Up"] = 0.15,
      ["Knock Back"] = 20
    })
    if skill.evo_rank and skill.evo_rank >= 3 then
      skill.info = ed.wraptable(originfo, {
        ["Shape Arg1"] = 351,
        ["Knock Up"] = 0.15,
        ["Knock Back"] = 20,
        ["No Dodge"] = true
      })
    end
    skill.caster.target1 = skill.target
    AwakeBossLC.basefunc1(basefunc, skill)
    skill.info = originfo
    local owner = skill.caster
    local bid = 12004709
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = owner:addBuff(binfo, owner)
  elseif attack_counter == 1 then
    skill.info = ed.wraptable(originfo, {
      ["Shape Arg1"] = 351,
      ["Knock Up"] = 0.8,
      ["Knock Back"] = 1
    })
    if skill.evo_rank and skill.evo_rank >= 3 then
      skill.info = ed.wraptable(originfo, {
        ["Shape Arg1"] = 351,
        ["Knock Up"] = 0.8,
        ["Knock Back"] = 1,
        ["No Dodge"] = true
      })
    end
    skill.target = skill.caster.target1
    AwakeBossLC.basefunc1(basefunc, skill)
    skill.info = originfo
  elseif 2 <= attack_counter and attack_counter <= 5 then
    skill.info = ed.wraptable(originfo, {
      ["Shape Arg1"] = 351,
      ["Knock Up"] = 0.25,
      ["Knock Back"] = 1
    })
    if skill.evo_rank and skill.evo_rank >= 3 then
      skill.info = ed.wraptable(originfo, {
        ["Shape Arg1"] = 351,
        ["Knock Up"] = 0.25,
        ["Knock Back"] = 1,
        ["No Dodge"] = true
      })
    end
    skill.target = skill.caster.target1
    AwakeBossLC.basefunc1(basefunc, skill)
    skill.info = originfo
  elseif attack_counter == 6 then
    skill.info = ed.wraptable(originfo, {
      ["Shape Arg1"] = 351,
      ["Knock Up"] = 0.5,
      ["Knock Back"] = 1
    })
    if skill.evo_rank and skill.evo_rank >= 3 then
      skill.info = ed.wraptable(originfo, {
        ["Shape Arg1"] = 351,
        ["Knock Up"] = 0.5,
        ["Knock Back"] = 1,
        ["No Dodge"] = true
      })
    end
    skill.target = skill.caster.target1
    AwakeBossLC.basefunc1(basefunc, skill)
    skill.info = originfo
  elseif attack_counter == 7 then
    local ratio = 2
    if skill.evo_rank and 2 <= skill.evo_rank then
      ratio = skill.evo_rank2["Script Arg1"]
    end
    skill.info = ed.wraptable(originfo, {
      ["Shape Arg1"] = 351,
      ["Knock Up"] = 0.7,
      ["Knock Back"] = 100,
      ["Plus Ratio"] = ratio
    })
    if skill.evo_rank and skill.evo_rank >= 3 then
      skill.info = ed.wraptable(originfo, {
        ["Shape Arg1"] = 351,
        ["Knock Up"] = 0.7,
        ["Knock Back"] = 100,
        ["Plus Ratio"] = ratio,
        ["No Dodge"] = true
      })
    end
    skill.target = skill.caster.target1
    AwakeBossLC.basefunc1(basefunc, skill)
    skill.info = originfo
    if ed.run_with_scene then
      local effect_moon = "eff_point_LC_ult2.cha"
      local origin = {400, 0}
      ed.scene:playEffectOnScene(effect_moon, origin, nil, nil, -1)
    end
    local caster = skill.caster
    if skill.caster.target1 and not skill.caster.target1:isAlive() then
      if ed.run_with_scene then
        local effect_moon = "eff_point_LC_ult1.cha"
        local casterorigin = skill.caster.position
        ed.scene:playEffectOnScene(effect_moon, casterorigin, {1, 1}, nil, 0)
      end
      local skillult2 = caster.skills.AwakeBossLC_ult_2
      skillult2:takeEffectOn(caster)
    end
    local skillatk2 = caster.skills.AwakeBossLC_atk2
    if skillatk2 then
      skillatk2.cd_remaining = 0.01
    end
    if ed.run_with_scene then
      ed.scene:startCameraShakeAnimationY(5, 0.1, 5)
    end
  end
end

function AwakeBossLC.skillult_takeEffectAt(basefunc, skill, location, source)
  basefunc(skill, location, source)
  local target = skill.target
  if ed.run_with_scene then
    local effect_moon = "eff_point_LC_atk2_2.cha"
    local casterorigin = target.position
    ed.scene:playEffectOnScene(effect_moon, casterorigin, nil, nil, -1)
  end
end

function AwakeBossLC.skillatk3_createBuff(basefunc, skill, target)
  local caster = skill.caster
  local buff = basefunc(skill, target)
  local owner = buff.owner
  local hpr = buff.info.HPR
  if skill.evo_rank and skill.evo_rank >= 1 then
    hpr = hpr + skill.evo_rank1["Script Arg1"] * (1 + caster.attribs.HEAL / 100)
  end
  if skill.evo_rank and skill.evo_rank >= 2 then
    hpr = hpr + skill.evo_rank2["Script Arg1"] * (1 + caster.attribs.HEAL / 100)
  end
  if skill.evo_rank and skill.evo_rank >= 3 then
    buff:setAttribute("MSPD", skill.evo_rank3["Script Arg1"])
    buff:setAttribute("HAST", skill.evo_rank3["Script Arg1"])
  end
  buff:setAttribute("HPR", hpr)
  local shard = caster.proto._shard
  if shard and shard._id == 1000681 and caster.shardSkillRank and 1 <= caster.shardSkillRank then
    local list = owner.buff_list
    local debuff_list = {}
    local my_camp = owner.camp
    for i = 1, #list do
      local buff = list[i]
      if buff and (not buff.caster or buff.caster.camp ~= my_camp) and buff.info.Dispel == "YES" then
        debuff_list[#debuff_list + 1] = buff
      end
    end
    for i = 1, #debuff_list do
      owner:removeBuff(debuff_list[i])
    end
  end
  return buff
end

function AwakeBossLC.skillatk2_start(basefunc, skill, target)
  skill.hurtnum = 0
  basefunc(skill, target)
end

function AwakeBossLC.skillatk2_takeEffectOn(basefunc, skill, target)
  skill.hurtnum = skill.hurtnum + 1
  basefunc(skill, target)
end

function AwakeBossLC.skillatk2_finish(basefunc, skill)
  basefunc(skill)
  if skill.hurtnum > 0 then
    local owner = skill.caster
    local skillatk2_2 = owner.skills.AwakeBossLC_atk2_2
    if skillatk2_2 then
      local originfo = skillatk2_2.info
      skillatk2_2:takeEffectAt(owner.position, owner)
      skillatk2_2.info = originfo
    end
  end
end

function AwakeBossLC.skillatk2_2_createBuff(basefunc, skill, target)
  local owner = skill.caster
  local skillatk2 = owner.skills.AwakeBossLC_atk2
  local HAST = skillatk2.hurtnum * skillatk2.info["Script Arg2"]
  local MSPD = skillatk2.hurtnum * skillatk2.info["Script Arg2"]
  local buff = basefunc(skill, target)
  buff:setAttribute("HAST", HAST)
  buff:setAttribute("MSPD", MSPD)
  return buff
end

function AwakeBossLC.hero_takeDamage(basefunc, self, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
  if self.DamageTime == nil then
    self.DamageTime = 1
  else
    self.DamageTime = self.DamageTime + 1
  end
  if self.AllDamageTime == nil then
    self.AllDamageTime = 1
  else
    self.AllDamageTime = self.AllDamageTime + 1
  end
  local skillatk4 = self.skills.AwakeBossLC_atk4
  if skillatk4 and self.AllDamageTime >= 10 then
    local originfo = skillatk4.info
    local basic = 71 + (skillatk4.level - 1) * skillatk4.info["Growth 1 Value"]
    if skillatk4.evo_rank and 1 <= skillatk4.evo_rank then
      basic = basic + skillatk4.evo_rank1["Script Arg1"]
    end
    if skillatk4.evo_rank and skillatk4.evo_rank >= 2 then
      basic = basic + skillatk4.evo_rank2["Script Arg1"]
    end
    local hurt = self.DamageTime * basic
    skillatk4.info = ed.wraptable(originfo, {
      ["Basic Num"] = hurt
    })
    skillatk4.cd_remaining = 0.1
    self.AllDamageTime = self.AllDamageTime - 10
  end
  return basefunc(self, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
end

function AwakeBossLC.init_hero(hero)
  hero:setActionStageChangeByManual(true)
  hero.skillatk4_affected_units_AwakeBossLC = {}
  hero.update = override(hero.update, AwakeBossLC.hero_update)
  hero.reset = override(hero.reset, AwakeBossLC.hero_reset)
  if hero.name == "AwakeBossLC" then
    hero.takeDamage = override(hero.takeDamage, AwakeBossLC.hero_takeDamage)
  end
  local shard = hero.proto._shard
  local skillult = hero.skills.AwakeBossLC_ult
  local skillatk4 = hero.skills.AwakeBossLC_atk4
  local skillatk3 = hero.skills.AwakeBossLC_atk3
  local skillatk2 = hero.skills.AwakeBossLC_atk2
  local skillatk2_2 = hero.skills.AwakeBossLC_atk2_2
  if skillult then
    skillult.onAttackFrame = override(skillult.onAttackFrame, AwakeBossLC.skillult_onAttackFrame)
    skillult.start = override(skillult.start, AwakeBossLC.skillult_start)
    skillult.willCast = override(skillult.willCast, AwakeBossLC.skillult_willCast)
    if skillult.evo_rank and skillult.evo_rank >= 1 then
      skillult.info = ed.wraptable(skillult.info, {
        ["Plus Ratio"] = skillult.evo_rank1["Script Arg1"]
      })
    end
  end
  if skillatk4 then
    skillatk4.info["No Speeder"] = true
    skillatk4.onAttackFrame = override(skillatk4.onAttackFrame, AwakeBossLC.skillatk4_onAttackFrame)
    skillatk4.finish = override(skillatk4.finish, AwakeBossLC.skillatk4_finish)
    skillatk4.onPhaseFinished = override(skillatk4.onPhaseFinished, AwakeBossLC.skillatk4_onPhaseFinished)
    skillatk4.start = override(skillatk4.start, AwakeBossLC.skillatk4_start)
    skillatk4.canCastWithTarget = override(skillatk4.canCastWithTarget, AwakeBossLC.skillatk4_canCastWithTarget)
    skillatk4.createBuff = override(skillatk4.createBuff, AwakeBossLC.skillatk4_createBuff)
  end
  if skillatk3 then
    skillatk3.createBuff = override(skillatk3.createBuff, AwakeBossLC.skillatk3_createBuff)
    if shard and shard._id == 1000681 and hero.shardSkillRank and hero.shardSkillRank >= 3 then
      skillatk3.info = ed.wraptable(skillatk3.info, {
        ["AOE Origin"] = "target",
        ["AOE Shape"] = "circle",
        ["Shape Arg1"] = 150
      })
    end
  end
  if skillatk2 then
    skillatk2.start = override(skillatk2.start, AwakeBossLC.skillatk2_start)
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, AwakeBossLC.skillatk2_takeEffectOn)
    skillatk2.finish = override(skillatk2.finish, AwakeBossLC.skillatk2_finish)
    if skillatk2.evo_rank and skillatk2.evo_rank >= 1 then
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
  if skillatk2_2 then
    skillatk2_2.createBuff = override(skillatk2_2.createBuff, AwakeBossLC.skillatk2_2_createBuff)
  end
  return hero
end

return AwakeBossLC.init_hero
