module("ed.battlehero", package.seeall)
local ed = ed
GuildBot = {}
GuildBot.atk3BuffID = 407
GuildBot.ult2BuffID = 408
GuildBot.State_Close = 1
GuildBot.State_Remote = 2

function GuildBot.skillult2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.extraDamageValue = skill.info["Script Arg2"] * 0.01
  return buff
end

function GuildBot.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  for i, tbuff in pairs(skill.caster.buff_list) do
    if tbuff.info.ID == GuildBot.atk3BuffID then
      tbuff.timer = tbuff.timer + 5
    end
  end
end

function GuildBot.skillult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.extraDamageValue = skill.info["Script Arg1"] * 0.01
  return buff
end

function GuildBot.skillult_onAttackFrame(basefunc, self)
  if self.caster.manually_casting then
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
  caster:setMP(caster.mp + info["Gain MP"] * ed.engine.mp_bonus)
  if info["Move Forward"] ~= 0 then
    caster.position[1] = caster.position[1] + info["Move Forward"] * caster.direction
  end
  self.ultTakeEffectTimer = 0.5
end

function GuildBot.hero_castManualSkill(basefunc, hero)
  local skillss = hero.skills.GuildBot_switch
  if skillss and hero.mp < 1000 and skillss:canCastWithTarget(hero.ai.target) then
    hero:castSkill(hero.skills.GuildBot_switch, hero)
  else
    basefunc(hero)
    local skillult = hero.skills.GuildBot_ult
    local skillult2 = hero.skills.GuildBot_ult_2
    if not hero:isAlive() then
      return
    end
    if not hero.manual_skill then
      return
    end
    if hero.manual_skill:canTrigger() then
      hero.manual_skill:trigger()
      return
    end
    if not hero.manual_skill:canCastWithTarget(hero.ai.target) then
      return
    end
    if hero.current_skill then
      hero.current_skill:interrupt()
    end
    if hero.GuildBot_State == GuildBot.State_Remote or not skillult2 then
      hero:castSkill(hero.manual_skill, hero.ai.target)
    else
      hero:castSkill(skillult2, hero)
    end
    hero.manually_casting = true
    ed.engine:freeze(hero.camp)
    hero:unfreeze()
    hero.can_cast_tick = -1
  end
end

function GuildBot.skillpasv_takeEffectAt(basefunc, skill, location, source)
  local originfo = skill.info
  skill.info = ed.wraptable(originfo, {
    ["No Dodge"] = true,
    ["Buff ID"] = 0
  })
  basefunc(skill, location, source)
  skill.info = originfo
end

function GuildBot.hero_reset(basefunc, hero)
  basefunc(hero)
  local skillult = hero.skills.GuildBot_ult
  if skillult then
    skillult.ultTakeEffectTimer = nil
    skillult.ultTakeEffectTimer2 = nil
    skillult.ultTakeEffectTimer2_location = nil
  end
end

function GuildBot.hero_takeDamage(basefunc, unit, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
  local dmg = basefunc(unit, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
  local skillatk3 = unit.skills.GuildBot_atk3
  if skillatk3 then
    unit:addBuff(skillatk3:createBuff(unit))
  end
  return dmg
end

function GuildBot.hero_onDying(basefunc, hero, killer)
  basefunc(hero, killer)
  local skillpasv = hero.skills.GuildBot_pasv
  if skillpasv then
    skillpasv:takeEffectAt(hero.position)
    if ed.run_with_scene then
      ed.scene:playEffectOnScene("eff_point_GuildBot_atk4.cha", {
        hero.position[1],
        hero.position[2] + 1
      }, {
        hero.direction,
        1
      }, nil, 0)
    end
  end
end

function GuildBot.skillatk_onPhaseFinished(basefunc, self)
  self:finish()
end

function GuildBot.skillatk_start(basefunc, self, target)
  local info = self.info
  if do_battle_log then
    btlog("%s began to cast %s --> %s", self.caster:display(), self:display(), target and target:display() or "nil")
  end
  self.target = target
  self:selectTarget(target)
  self.cd_remaining = info.CD
  self.casting = true
  self.attack_counter = 0
  local ran = ed.rand()
  if ran < 0.5 then
    self:startPhase(1)
    self.attackMode = 1
  else
    self:startPhase(2)
    self.attackMode = 2
  end
  self.is_update = true
  local caster = self.caster
  caster.global_cd = info["Global CD"]
  caster:setMP(caster.mp - info["Cost MP"] * (1 - caster.attribs.CDR / 100))
  if caster.actor then
    local effect_name = info["Launch Effect"]
    if effect_name then
      caster.actor:addEffect(effect_name, -1)
    end
  end
end

function GuildBot.skillatk_createProjectile(basefunc, skill)
  local caster = skill.caster
  local projectile = basefunc(skill)
  if skill.attackMode == 1 then
    local projectile2 = basefunc(skill)
    local attack_counter = skill.attack_counter
    local position = skill.caster.position
    local direction = skill.caster.direction
    projectile2.position[1] = projectile.position[1] - 40 * direction
    projectile2.height = projectile.height + 5
    ed.engine:addProjectile(projectile2)
    caster:setMP(caster.mp + skill.info["Gain MP"] * ed.engine.mp_bonus)
  end
  return projectile
end

function GuildBot.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  local skillult = hero.skills.GuildBot_ult
  if skillult then
    if skillult.ultTakeEffectTimer then
      skillult.ultTakeEffectTimer = skillult.ultTakeEffectTimer - dt
      if skillult.ultTakeEffectTimer < 0 then
        local sum = 0
        local location = {400, 0}
        local locations = {0, 0}
        for unit in ed.engine:foreachAliveUnit(-hero.camp) do
          locations[1] = locations[1] + unit.position[1]
          locations[2] = locations[2] + unit.position[2]
          sum = sum + 1
        end
        if 0 < sum then
          location[1] = locations[1] / sum
          location[2] = locations[2] / sum
        end
        if ed.run_with_scene then
          ed.scene:playEffectOnScene("eff_point_GuildBot_ult.cha", {
            location[1],
            location[2]
          }, {
            hero.direction,
            1
          }, nil, 1)
        end
        skillult.ultTakeEffectTimer = nil
        skillult.ultTakeEffectTimer2 = 1.2
        skillult.ultTakeEffectTimer2_location = {
          location[1],
          location[2]
        }
      end
    end
    if skillult.ultTakeEffectTimer2 then
      skillult.ultTakeEffectTimer2 = skillult.ultTakeEffectTimer2 - dt
      if 0 > skillult.ultTakeEffectTimer2 then
        skillult:takeEffectAt(skillult.ultTakeEffectTimer2_location, hero)
        skillult.ultTakeEffectTimer2 = nil
        skillult.ultTakeEffectTimer2_location = nil
      end
    end
  end
  local skillss = hero.skills.GuildBot_switch
  local cancast, reason = skillss:canCastWithTarget(hero.ai.target)
  hero.can_cast_manual = hero.can_cast_manual or skillss and cancast and hero.current_skill ~= hero.skills.GuildBot_ult and hero.current_skill ~= hero.skills.GuildBot_ult_2 and hero:isAlive()
end

function GuildBot.hero_ai_findSkillToCast(basefunc, ai)
  local skill = basefunc(ai)
  if skill and skill.info["Skill Name"] == "GuildBot_switch" then
    local caster = skill.caster
    if ed.engine:arenaMode() or not battle_tick.getRealTimePvp() and caster.camp == ed.emCampEnemy then
      return skill
    end
    if caster.GuildBot_State == GuildBot.State_Remote then
      return caster.skills.GuildBot_atk:canCastWithTarget(caster.ai.target) and caster.skills.GuildBot_atk or nil
    else
      return caster.skills.GuildBot_atk_2:canCastWithTarget(caster.ai.target) and caster.skills.GuildBot_atk_2 or nil
    end
  end
  return skill
end

function GuildBot.skillatk_2_onAttackFrame(basefunc, skill)
  local originfo = skill.info
  if skill.attackMode == 2 then
    skill.info = ed.wraptable(originfo, {
      ["Knock Up"] = 0.3,
      ["Knock Back"] = 200,
      ["AOE Origin"] = false
    })
    if skill.target then
      local bid = 35
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = skill.target:addBuff(binfo, skill.caster)
    end
  end
  basefunc(skill)
  skill.info = originfo
end

function GuildBot.skillss_start(basefunc, self, target)
  local info = self.info
  if do_battle_log then
    btlog("%s began to cast %s --> %s", self.caster:display(), self:display(), target and target:display() or "nil")
  end
  self.target = target
  self:selectTarget(target)
  self.cd_remaining = info.CD
  self.casting = true
  self.attack_counter = 0
  local ran = ed.rand()
  if self.caster.GuildBot_State == GuildBot.State_Remote then
    self:startPhase(1)
  else
    self:startPhase(2)
  end
  self.is_update = true
  local caster = self.caster
  caster.global_cd = info["Global CD"]
  caster:setMP(caster.mp - info["Cost MP"] * (1 - caster.attribs.CDR / 100))
  if caster.actor then
    local effect_name = info["Launch Effect"]
    if effect_name then
      caster.actor:addEffect(effect_name, -1)
    end
  end
  for i, tbuff in pairs(self.caster.buff_list) do
    if tbuff.info.ID == GuildBot.atk3BuffID then
      tbuff.timer = tbuff.timer + 2
    end
  end
end

function GuildBot.skillss_finish(basefunc, skill)
  basefunc(skill)
  local hero = skill.caster
  if hero.GuildBot_State == GuildBot.State_Remote then
    local cd2 = hero.skills.GuildBot_atk2.cd_remaining
    hero:enterActionStageFromOneStage(2, 10006)
    hero.GuildBot_State = GuildBot.State_Close
    if hero.skills.GuildBot_atk_2 then
      hero.skills.GuildBot_atk_2.cd_remaining = 0
    end
    if hero.skills.GuildBot_atk2_2 then
      hero.skills.GuildBot_atk2_2.cd_remaining = cd2
    end
  else
    local cd2 = hero.skills.GuildBot_atk2_2.cd_remaining
    hero:enterActionStageFromOneStage(1, 10006)
    hero.GuildBot_State = GuildBot.State_Remote
    if hero.skills.GuildBot_atk then
      hero.skills.GuildBot_atk.cd_remaining = 0
    end
    if hero.skills.GuildBot_atk2 then
      hero.skills.GuildBot_atk2.cd_remaining = cd2
    end
  end
end

function GuildBot.init_hero(hero)
  hero:setActionStageChangeByManual(true)
  hero.takeDamage = override(hero.takeDamage, GuildBot.hero_takeDamage)
  hero.update = override(hero.update, GuildBot.hero_update)
  if hero.name == "GuildBot" then
    hero.GuildBot_State = GuildBot.State_Remote
    hero.reset = override(hero.reset, GuildBot.hero_reset)
    hero.castManualSkill = override(hero.castManualSkill, GuildBot.hero_castManualSkill)
  end
  local skillult = hero.skills.GuildBot_ult
  if skillult then
    skillult.start = override(skillult.start, GuildBot.skillult_start)
    skillult.createBuff = override(skillult.createBuff, GuildBot.skillult_createBuff)
    skillult.onAttackFrame = override(skillult.onAttackFrame, GuildBot.skillult_onAttackFrame)
  end
  local skillatk = hero.skills.GuildBot_atk
  if skillatk then
    skillatk.start = override(skillatk.start, GuildBot.skillatk_start)
    skillatk.onPhaseFinished = override(skillatk.onPhaseFinished, GuildBot.skillatk_onPhaseFinished)
    skillatk.createProjectile = override(skillatk.createProjectile, GuildBot.skillatk_createProjectile)
  end
  local skillatk_2 = hero.skills.GuildBot_atk_2
  if skillatk_2 then
    skillatk_2.start = override(skillatk_2.start, GuildBot.skillatk_start)
    skillatk_2.onPhaseFinished = override(skillatk_2.onPhaseFinished, GuildBot.skillatk_onPhaseFinished)
    skillatk_2.onAttackFrame = override(skillatk_2.onAttackFrame, GuildBot.skillatk_2_onAttackFrame)
  end
  local skillpasv = hero.skills.GuildBot_pasv
  if skillpasv then
    hero.onDying = override(hero.onDying, GuildBot.hero_onDying)
    skillpasv.takeEffectAt = override(skillpasv.takeEffectAt, GuildBot.skillpasv_takeEffectAt)
  end
  local skillult2 = hero.skills.GuildBot_ult_2
  if skillult2 then
    skillult2.start = override(skillult2.start, GuildBot.skillult_start)
    skillult2.createBuff = override(skillult2.createBuff, GuildBot.skillult2_createBuff)
  end
  local skillss = hero.skills.GuildBot_switch
  if skillss then
    skillss.finish = override(skillss.finish, GuildBot.skillss_finish)
    skillss.start = override(skillss.start, GuildBot.skillss_start)
    hero.ai.findSkillToCast = override(hero.ai.findSkillToCast, GuildBot.hero_ai_findSkillToCast)
    skillss.onPhaseFinished = override(skillss.onPhaseFinished, GuildBot.skillatk_onPhaseFinished)
  end
  return hero
end

return GuildBot.init_hero
