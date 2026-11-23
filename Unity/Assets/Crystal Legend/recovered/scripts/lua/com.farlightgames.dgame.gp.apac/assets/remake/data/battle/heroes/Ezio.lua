module("ed.battlehero", package.seeall)
local ed = ed
Ezio = {}
Ezio.atk3_interval = 12
Ezio.atk3_probability = 1
Ezio.atk2_totaltimes = 5
Ezio.atk2_position = {
  {0, 0},
  {-40, 0},
  {-40, 0},
  {-20, 0},
  {0, 0}
}
Ezio.revengeLevel = 0
Ezio.revengeLevelLast = 0

function Ezio.sawake_revenge_OnRemoved(basefunc, buff)
  local caster = buff.caster
  local skillsawake = caster.skills.Ezio_sawake
  if caster.revengeLevel > 0 then
    caster.revengeLevel = caster.revengeLevel - buff.rank
  end
  if caster:isAlive() then
    local addHp = caster.attribs.HP * skillsawake.info["Script Arg5"] / 100 * buff.rank
    caster:setHP(caster.hp + addHp)
    if caster.actor then
      local str = "+" .. math.floor(addHp + 0.5)
      local color = "green"
      ed.PopupCreate(str, color, caster.actor, false, "heal")
    end
  end
  basefunc(buff)
end

function Ezio.hero_handleUnitDieEvent(basefunc, self, unit, killer_unit)
  basefunc(self, unit, killer_unit)
  local skillult = self.skills.Ezio_ult
  local skillult2 = self.skills.Ezio_ult2
  if skillult and skillult2 and killer_unit == self and self.current_skill == skillult then
    skillult2.cd_remaining = 0
  end
  local skillsawake = self.skills.Ezio_sawake
  if skillsawake and unit:isHero() and unit.camp == self.camp and killer_unit and killer_unit.camp ~= self.camp then
    local bid = 1344
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local Ezio_sawake_revenge = ed.BuffCreate(binfo, killer_unit, self)
    Ezio_sawake_revenge.onRemoved = override(Ezio_sawake_revenge.onRemoved, Ezio.sawake_revenge_OnRemoved)
    killer_unit:addBuff(Ezio_sawake_revenge, self)
    self.revengeLevel = self.revengeLevel + 1
  end
end

function Ezio.hero_die(basefunc, hero, killer)
  for i, unit in ipairs(hero.EzioMirror) do
    if unit and unit:isAlive() then
      unit:die()
    end
  end
  basefunc(hero, killer)
end

function Ezio.actionskill_finish(basefunc, skill)
  basefunc(skill)
  local bid = 211
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = skill.caster:addBuff(binfo, skill.caster)
  skill.caster:die()
end

function Ezio.actionskill_onAttackFrame(basefunc, self)
  if self.caster.manually_casting then
    ed.engine:unfreeze()
    self.caster.manually_casting = false
  end
  self.attack_counter = self.attack_counter + 1
  if not self.target then
    return
  end
  local info = self.info
  local caster = self.caster
  local ttype = info["Track Type"]
  if ttype == "projectile" then
    local projectile = self:createProjectile()
    ed.engine:addProjectile(projectile)
  elseif ttype == "chain" then
    local chain = self:createChain()
    ed.engine:addChain(chain)
  elseif ttype == nil then
    self:takeEffectAt(self.target.position)
  else
    EDDebug("Unkonwn Track Type: '" .. ttype .. "'")
  end
  caster:setMP(caster.mp + info["Gain MP"] * ed.engine.mp_bonus)
  if info["Move Forward"] ~= 0 then
    caster.position[1] = caster.position[1] + info["Move Forward"] * caster.direction
  end
end

function Ezio.skillatk2_playAction(baseskill, actionNum)
  local caster = baseskill.caster
  local awakeornot = baseskill.originUnit_Rubick and ed.protoAwake(baseskill.originUnit_Rubick.proto) or ed.protoAwake(caster.proto, 10015)
  local Sawakeornot = baseskill.originUnit_Rubick and ed.protoSuperAwake(baseskill.originUnit_Rubick.proto) or ed.protoSuperAwake(caster.proto, 10015)
  local skillevel = {
    baseskill.level,
    baseskill.level,
    baseskill.level,
    baseskill.level,
    baseskill.level,
    baseskill.level,
    baseskill.level,
    baseskill.level,
    baseskill.level,
    baseskill.level,
    baseskill.level
  }
  local proto = {
    _tid = Sawakeornot and 260 or awakeornot and 205 or 194,
    _level = baseskill.level or 1,
    _stars = caster.stars,
    _skill_levels = skillevel,
    _rank = caster.rank,
    _fashion = {
      _current_fashion = caster.fashion_id
    }
  }
  local config = {
    is_monster = true,
    estimate_rank = true,
    hp_mod = caster.camp == ed.emCampEnemy and ed.engine.guildInstance_mode and 2 or caster.config.hp_mod,
    dps_mod = caster.config.dps_mod or 1
  }
  local EzioMirror = ed.UnitCreate(proto, caster.camp, config)
  table.insert(caster.EzioMirror, EzioMirror)
  local bid = 405
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = EzioMirror:addBuff(binfo, caster)
  local actionskill = EzioMirror.skills["EzioMir_atk2_" .. actionNum]
  if awakeornot then
    actionskill = EzioMirror.skills["EzioMir2_atk2_" .. actionNum]
  end
  if Sawakeornot then
    actionskill = EzioMirror.skills["EzioMir3_atk2_" .. actionNum]
  end
  actionskill.target = baseskill.target
  local position = {
    actionskill.target.position[1] + Ezio.atk2_position[actionNum][1],
    actionskill.target.position[2] + Ezio.atk2_position[actionNum][2]
  }
  actionskill.finish = override(actionskill.finish, Ezio.actionskill_finish)
  actionskill.onAttackFrame = override(actionskill.onAttackFrame, Ezio.actionskill_onAttackFrame)
  ed.engine:summonUnit(EzioMirror, position, caster, "Death")
  EzioMirror:castSkill(actionskill, actionskill.target)
end

function Ezio.skillult_start(basefunc, skill, target)
  local owner = skill.caster
  local bid = 404
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = owner:addBuff(binfo, owner)
  owner.Ezio_Ultorginposition = {}
  owner.Ezio_Ultorginposition[1] = owner.position[1] + owner.direction
  owner.Ezio_Ultorginposition[2] = owner.position[2]
  basefunc(skill, target)
  if skill.target then
    skill.target:unfreezeActor()
  end
end

function Ezio.skillult_finish(basefunc, skill)
  basefunc(skill)
  local unit = skill.caster
  for i, tbuff in ipairs(unit.buff_list) do
    if tbuff.info.ID == 404 then
      tbuff.timer = 0
    end
  end
  if unit.Ezio_Ultorginposition then
    unit:setPosition({
      unit.Ezio_Ultorginposition[1],
      unit.Ezio_Ultorginposition[2]
    })
  end
end

function Ezio.onAttackFrame_basefunc1(basefunc, skill)
  if skill.caster.manually_casting and skill.attack_counter == 10 then
    ed.engine:unfreeze()
    skill.caster.manually_casting = false
  end
  skill.attack_counter = skill.attack_counter + 1
  if (skill.info["Target Type"] == "random" or skill.target == nil or not skill.target:isAlive()) and skill.attack_counter == 0 then
    skill:selectTarget(nil)
  end
  if not skill.target then
    return
  end
  local info = skill.info
  local caster = skill.caster
  skill:takeEffectAt(skill.target.position)
  caster:setMP(caster.mp + info["Gain MP"] * ed.engine.mp_bonus)
  if info["Move Forward"] ~= 0 then
    caster.position[1] = caster.position[1] + info["Move Forward"] * caster.direction
  end
end

function Ezio.skillult_onAttackFrame(basefunc, skill, location, source)
  local originfo = skill.info
  local attack_counter = skill.attack_counter
  local caster = skill.caster
  local target = skill.target
  local dir
  skill.info["No Dodge"] = true
  if attack_counter == 0 then
    Ezio.onAttackFrame_basefunc1(basefunc, skill)
    if target then
      if target.position[1] >= caster.position[1] then
        dir = 1
        caster.direction = 1
      else
        dir = -1
        caster.direction = -1
      end
      caster:setPosition({
        target.position[1],
        target.position[2]
      })
      caster.Ezio_Ultorginposition[1] = target.position[1] - dir * 45
      caster.Ezio_Ultorginposition[2] = target.position[2]
    else
      caster.Ezio_Ultorginposition[1] = caster.position[1]
      caster.Ezio_Ultorginposition[2] = caster.position[2]
      skill:finish()
    end
    caster.EzioUlttarget = skill.target
  elseif 1 <= attack_counter and attack_counter <= 9 and caster.EzioUlttarget == skill.target then
    Ezio.onAttackFrame_basefunc1(basefunc, skill)
  elseif attack_counter == 10 and caster.EzioUlttarget == skill.target then
    skill.info = ed.wraptable(originfo, {
      ["Plus Ratio"] = 2.2
    })
    Ezio.onAttackFrame_basefunc1(basefunc, skill)
    skill.info = originfo
    if ed.run_with_scene then
      ed.scene:startCameraShakeAnimationY(50, 0.1, 2)
    end
  end
end

function Ezio.findNextTarget(skill)
  local caster = skill.caster
  local min = math.huge
  local ret
  for unit in ed.engine:foreachAliveUnit(skill:targetCamp()) do
    if unit.config.is_summoned then
    elseif unit == caster then
    elseif unit.buff_effects.untargetable then
    elseif unit.buffManager.invisible and unit.camp ~= caster.camp then
    elseif unit:isOutOfStage() then
    else
      local times = skill.affect_times[unit] or 0
      if min < times then
      else
        ret = unit
        min = times
      end
    end
  end
  return ret
end

function Ezio.skillatk2_start(basefunc, skill, target)
  skill.affect_times = {}
  local caster = skill.caster
  local bid = 402
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
  target = Ezio.findNextTarget(skill)
  basefunc(skill, target)
end

function Ezio.skillatk2_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  local caster = skill.caster
  local target
  if attack_counter == 0 then
    target = skill.target
    if target then
      skill.target = target
      skill.affect_times[target] = (skill.affect_times[target] and skill.affect_times[target] or 0) + 1
      basefunc(skill)
    else
      skill:finish()
    end
  end
  if attack_counter == 1 then
    target = Ezio.findNextTarget(skill)
    if target then
      skill.target = target
      skill.affect_times[target] = (skill.affect_times[target] and skill.affect_times[target] or 0) + 1
      Ezio.skillatk2_playAction(skill, 1)
    else
      skill:finish()
    end
    skill.attack_counter = skill.attack_counter + 1
  elseif attack_counter == 2 then
    target = Ezio.findNextTarget(skill)
    if target then
      skill.target = target
      skill.affect_times[target] = (skill.affect_times[target] and skill.affect_times[target] or 0) + 1
      Ezio.skillatk2_playAction(skill, 2)
    else
      skill:finish()
    end
    skill.attack_counter = skill.attack_counter + 1
  elseif attack_counter == 3 then
    target = Ezio.findNextTarget(skill)
    if target then
      skill.target = target
      skill.affect_times[target] = (skill.affect_times[target] and skill.affect_times[target] or 0) + 1
      Ezio.skillatk2_playAction(skill, 3)
    else
      skill:finish()
    end
    skill.attack_counter = skill.attack_counter + 1
  elseif attack_counter == 4 then
    target = Ezio.findNextTarget(skill)
    if target then
      skill.target = target
      skill.affect_times[target] = (skill.affect_times[target] and skill.affect_times[target] or 0) + 1
      Ezio.skillatk2_playAction(skill, 4)
    else
      skill:finish()
    end
    skill.attack_counter = skill.attack_counter + 1
  end
end

function Ezio.skillatk2_finish(basefunc, skill)
  basefunc(skill)
  local unit = skill.caster
  for i, tbuff in ipairs(unit.buff_list) do
    if tbuff.info.ID == 402 then
      tbuff.timer = 0
    end
  end
end

function Ezio.takeDamage(basefunc, unit, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
  local amount = struct_table
  if type(struct_table) == "table" then
    damage_type = struct_table.damage_type
    field = struct_table.field
    source = struct_table.source
    coefficient = struct_table.coefficient
    crit_mod = struct_table.crit_mod
    amount = struct_table.amount
  end
  local self = unit
  local cur_skill = unit.current_skill
  if not self:isAlive() then
    return
  end
  if damage_type == "AD" and unit.atk3_cd_Ezio <= 0 and (not source or source and source.name ~= "ExSilverDragon") then
    local castingSkill = false
    if cur_skill then
      if cur_skill.info["Skill Name"] == "Ezio_atk" then
        castingSkill = false
      elseif cur_skill.info["Skill Name"] == "Ezio_atk3" then
        castingSkill = true
      else
        local noAF = 0
        for _, phase in ipairs(cur_skill.phase_list) do
          noAF = noAF + #phase.event_list
        end
        if noAF > cur_skill.attack_counter then
          castingSkill = true
        end
      end
    end
    if not castingSkill and ed.rand() <= Ezio.atk3_probability then
      if cur_skill then
        cur_skill:finish()
      end
      unit:onHitMiss(source)
      if do_battle_log then
        btlog("%s: %s --> %s (Miss! by Ezioatk3)", self:display(), source:display(), self:display())
      end
      local color = unit.camp == ed.emCampEnemy and "red" or "blue"
      if unit.actor then
        ed.PopupCreate("dodge", color, unit.actor, nil, "text")
      end
      local skill3 = unit.skills.Ezio_atk3
      local skill3duration = skill3.phase_list[1].duration
      skill3.cd_remaining = 0
      self:castSkill(skill3, skill3.target)
      if unit.global_cd then
        unit.glcd_recover_Ezio = unit.global_cd - skill3duration
      end
      unit.global_cd = 0
      return 0
    else
      return basefunc(unit, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
    end
  else
    return basefunc(unit, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
  end
end

function Ezio.onHitMiss(basefunc, hero, skill)
  basefunc(hero, skill)
  local skillatk = hero.skills.Ezio_atk
  local skillatk2 = hero.skills.Ezio_atk2
  local atkcd = skillatk.cd_remaining
  local atk2cd = skillatk2.cd_remaining
  local skillatk4 = hero.skills.Ezio_pasv2
  if skillatk4 then
    skillatk.cd_remaining = 0 < atkcd and atkcd - 0.25 or 0
    skillatk2.cd_remaining = 0 < atk2cd and atk2cd - 1 or 0
    hero:takeHeal(50, "mp", hero)
  end
end

function Ezio.sawakeBuff_update(basefunc, self, dt)
  local caster = self.caster
  local skillsawake = caster.skills.Ezio_sawake
  if caster.revengeLevelLast ~= caster.revengeLevel then
    self:setAttribute("AD", skillsawake.info["Script Arg4"] * caster.revengeLevel)
    caster:rebuild()
    caster.revengeLevelLast = caster.revengeLevel
  end
  basefunc(self, dt)
end

function Ezio.update(basefunc, unit, dt)
  unit.atk3_cd_Ezio = unit.atk3_cd_Ezio - dt
  basefunc(unit, dt)
  local skillsawake = unit.skills.Ezio_sawake
  if skillsawake and not unit.sawakeBuff then
    local bid = 1344
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local Ezio_sawakeBuff = ed.BuffCreate(binfo, unit, unit)
    Ezio_sawakeBuff.update = override(Ezio_sawakeBuff.update, Ezio.sawakeBuff_update)
    unit:addBuff(Ezio_sawakeBuff, unit)
    unit.sawakeBuff = true
  end
end

function Ezio.skillatk3_start(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local bid = 403
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
end

function Ezio.skillatk3_finish(basefunc, skill)
  basefunc(skill)
  local unit = skill.caster
  unit.atk3_cd_Ezio = Ezio.atk3_interval
  unit.global_cd = unit.glcd_recover_Ezio
  for i, tbuff in ipairs(unit.buff_list) do
    if tbuff.info.ID == 403 then
      tbuff.timer = 0
    end
  end
end

function Ezio.skillatk_onPhaseFinished(basefunc, skill)
  skill:finish()
end

function Ezio.skillatk_start(basefunc, skill, target)
  local info = skill.info
  skill.originfo = skill.info
  if do_battle_log then
    btlog("%s began to cast %s --> %s", skill.caster:display(), skill:display(), target and target:display() or "nil")
  end
  skill.target = target
  skill:selectTarget(target)
  skill.cd_remaining = info.CD
  skill.casting = true
  skill.attack_counter = 0
  local ran = ed.rand()
  if ran < 0.5 then
    skill:startPhase(1)
  else
    skill.info = ed.wraptable(skill.originfo, {
      ["Plus Ratio"] = 0.6
    })
    skill:startPhase(2)
  end
  skill.is_update = true
  local caster = skill.caster
  caster.global_cd = info["Global CD"]
  caster:setMP(caster.mp - info["Cost MP"] * (1 - caster.attribs.CDR / 100))
  if caster.actor then
    local effect_name = info["Launch Effect"]
    if effect_name then
      caster.actor:addEffect(effect_name, -1)
    end
  end
end

function Ezio.skillatk_finish(basefunc, skill)
  basefunc(skill)
  skill.info = skill.originfo
end

function Ezio.getRuntimeScale(basefunc, self)
  if self.isScaleActionRunning then
    local dt = self.dt_action
    self.scaleActionRunningTime = self.scaleActionRunningTime + dt
    if self.scaleActionRunningTime > self.scaleActionDuration then
      local scale = self.scaleActionScaleValue
      return self.direction * scale, scale
    else
      local scale = self.scaleActionRunningTime / self.scaleActionDuration * (self.scaleActionScaleValue - 1) + 1
      return self.direction * scale, scale
    end
  end
  if not self.isScaleActionRunning then
    local m = self.manually_casting
    return self.direction * (m and 1.25 or 1), m and 1.25 or 1
  end
end

function Ezio.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.sawakeBuff = false
  hero.revengeLevel = 0
  hero.revengeLevelLast = 0
  hero.EzioMirror = {}
end

function Ezio.init_hero(hero)
  hero.die = override(hero.die, Ezio.hero_die)
  hero.reset = override(hero.reset, Ezio.hero_reset)
  hero.handleUnitDieEventToAll = override(hero.handleUnitDieEventToAll, Ezio.hero_handleUnitDieEvent)
  local skillatk = hero.skills.Ezio_atk
  if skillatk then
    skillatk.start = override(skillatk.start, Ezio.skillatk_start)
    skillatk.onPhaseFinished = override(skillatk.onPhaseFinished, Ezio.skillatk_onPhaseFinished)
    skillatk.finish = override(skillatk.finish, Ezio.skillatk_finish)
  end
  local skillult = hero.skills.Ezio_ult
  if skillult then
    skillult.onAttackFrame = override(skillult.onAttackFrame, Ezio.skillult_onAttackFrame)
    skillult.start = override(skillult.start, Ezio.skillult_start)
    skillult.finish = override(skillult.finish, Ezio.skillult_finish)
    hero.getRuntimeScale = override(hero.getRuntimeScale, Ezio.getRuntimeScale)
  end
  local skillatk2 = hero.skills.Ezio_atk2
  if skillatk2 then
    skillatk2.start = override(skillatk2.start, Ezio.skillatk2_start)
    skillatk2.finish = override(skillatk2.finish, Ezio.skillatk2_finish)
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, Ezio.skillatk2_onAttackFrame)
  end
  local skillatk3 = hero.skills.Ezio_atk3
  if skillatk3 then
    skillatk3.finish = override(skillatk3.finish, Ezio.skillatk3_finish)
    skillatk3.start = override(skillatk3.start, Ezio.skillatk3_start)
    hero.update = override(hero.update, Ezio.update)
    hero.takeDamage = override(hero.takeDamage, Ezio.takeDamage)
    hero.atk3_cd_Ezio = 0
  end
  local skillatk4 = hero.skills.Ezio_pasv2
  if skillatk4 then
    hero.onHitMiss = override(hero.onHitMiss, Ezio.onHitMiss)
  end
  return hero
end

return Ezio.init_hero
