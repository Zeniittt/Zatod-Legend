module("ed.battlehero", package.seeall)
local ed = ed
SuperGuildBot = {}
SuperGuildBot.atk3BuffID = 407
SuperGuildBot.State_Close = 1
SuperGuildBot.State_Remote = 2

function SuperGuildBot.skillult2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.extraDamageValue = skill.info["Script Arg2"] * 0.01
  return buff
end

function SuperGuildBot.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  for i, tbuff in pairs(skill.caster.buff_list) do
    if tbuff.info.ID == SuperGuildBot.atk3BuffID then
      tbuff.timer = tbuff.timer + 5
    end
  end
end

function SuperGuildBot.skillult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.extraDamageValue = skill.info["Script Arg1"] * 0.01
  return buff
end

function SuperGuildBot.skillult_onAttackFrame(basefunc, self)
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
  local ttype = info["Track Type"]
  if ttype == "projectile" then
  elseif ttype == "chain" then
  elseif ttype == "region" then
  elseif ttype == nil then
  else
    EDDebug("Unkonwn Track Type: '" .. ttype .. "'")
  end
  caster:setMP(caster.mp + info["Gain MP"] * ed.engine.mp_bonus)
  if info["Move Forward"] ~= 0 then
    caster.position[1] = caster.position[1] + info["Move Forward"] * caster.direction
  end
  self.ultTakeEffectTimer = 0.5
end

function SuperGuildBot.hero_castManualSkill(basefunc, hero)
  local skillult2 = hero.skills.SuperGuildBot_ult_2
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
  if hero.GuildBot_State == SuperGuildBot.State_Remote or not skillult2 then
    hero:castSkill(hero.manual_skill, hero.ai.target)
  else
    hero:castSkill(skillult2, hero)
  end
  hero.manually_casting = true
  ed.engine:freeze(hero.camp)
  hero:unfreeze()
  hero.can_cast_tick = -1
end

function SuperGuildBot.skillpasv_takeEffectAt(basefunc, skill, location, source)
  local originfo = skill.info
  skill.info = ed.wraptable(originfo, {
    ["No Dodge"] = true,
    ["Buff ID"] = 0
  })
  basefunc(skill, location, source)
  skill.info = originfo
end

function SuperGuildBot.skillatk_2_onAttackFrame(basefunc, skill)
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

function SuperGuildBot.hero_reset(basefunc, hero)
  basefunc(hero)
  local skillult = hero.skills.SuperGuildBot_ult
  skillult.ultTakeEffectTimer = nil
  skillult.ultTakeEffectTimer2 = nil
  skillult.ultTakeEffectTimer2_location = nil
  if hero.hp / hero.attribs.HP < 0.5 then
    hero:enterActionStageFromOneStage(2, 10010)
    hero.GuildBot_State = SuperGuildBot.State_Close
  else
    hero:enterActionStageFromOneStage(1, 10010)
    hero.GuildBot_State = SuperGuildBot.State_Remote
  end
  local skillspecial = hero.skills.SuperGuildBot_special
  if skillspecial then
    local buff = hero:addBuff(skillspecial:createBuff(hero))
    local ratiohp = skillspecial.info["Script Arg3"] * 0.01
    local ratioother = skillspecial.info["Script Arg4"] * 0.01
    local hppercent = hero.hp / hero.attribs.HP
    local guildBotPKratio = 0
    if #ed.engine.alive_units[-hero.camp] == 1 and ed.engine.alive_units[-hero.camp][1].name == "SuperGuildBot" then
      guildBotPKratio = 50
    end
    buff:setAttribute("AD", hero.attribs.AD * ratioother * guildBotPKratio)
    buff:setAttribute("AP", hero.attribs.AP * ratioother * guildBotPKratio)
    buff:setAttribute("ARM", hero.attribs.ARM * ratioother)
    buff:setAttribute("MR", hero.attribs.MR * ratioother)
    hero:rebuild()
    hero.attribs.HP = hero.attribs.HP * (1 + ratiohp)
    hero.config.hp_mod = hero.config.hp_mod and hero.config.hp_mod * (1 + ratiohp) or 1 + ratiohp
    hero.hp = hero.attribs.HP * hppercent
  end
end

function SuperGuildBot.hero_takeDamage(basefunc, unit, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
  local dmg = basefunc(unit, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
  local skillatk3 = unit.skills.SuperGuildBot_atk3
  if skillatk3 then
    unit:addBuff(skillatk3:createBuff(unit))
  end
  local skillpasv = unit.skills.SuperGuildBot_pasv
  if skillpasv then
    local percent = unit.hp / unit.attribs.HP
    if unit.GuildBot_State == SuperGuildBot.State_Remote and percent < 0.5 then
      unit:enterActionStageFromOneStage(2, 10010)
      unit.GuildBot_State = SuperGuildBot.State_Close
    end
  end
  return dmg
end

function SuperGuildBot.hero_onDying(basefunc, hero, killer)
  basefunc(hero, killer)
  local skillpasv = hero.skills.SuperGuildBot_pasv
  if skillpasv then
    skillpasv:takeEffectAt(hero.position)
    if ed.run_with_scene then
      ed.scene:playEffectOnScene("eff_point_GuildBot_atk4.cha", {
        hero.position[1],
        hero.position[2] - 1
      }, {
        hero.direction,
        1
      }, nil, 1)
    end
  end
end

function SuperGuildBot.skillatk_onPhaseFinished(basefunc, self)
  self:finish()
end

function SuperGuildBot.skillatk_start(basefunc, self, target)
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

function SuperGuildBot.skillatk_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  if skill.attackMode == 1 then
    local projectile2 = basefunc(skill)
    local direction = skill.caster.direction
    projectile2.position[1] = projectile.position[1] - 40 * direction
    projectile2.height = projectile.height + 5
    ed.engine:addProjectile(projectile2)
  end
  return projectile
end

function SuperGuildBot.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  local skillult = hero.skills.SuperGuildBot_ult
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
end

function SuperGuildBot.init_hero(hero)
  hero:setActionStageChangeByManual(true)
  hero.takeDamage = override(hero.takeDamage, SuperGuildBot.hero_takeDamage)
  hero.update = override(hero.update, SuperGuildBot.hero_update)
  if hero.name == "SuperGuildBot" then
    hero.reset = override(hero.reset, SuperGuildBot.hero_reset)
    hero.castManualSkill = override(hero.castManualSkill, SuperGuildBot.hero_castManualSkill)
  end
  local skillult = hero.skills.SuperGuildBot_ult
  if skillult then
    skillult.start = override(skillult.start, SuperGuildBot.skillult_start)
    skillult.createBuff = override(skillult.createBuff, SuperGuildBot.skillult_createBuff)
    skillult.onAttackFrame = override(skillult.onAttackFrame, SuperGuildBot.skillult_onAttackFrame)
  end
  local skillatk = hero.skills.SuperGuildBot_atk
  if skillatk then
    skillatk.start = override(skillatk.start, SuperGuildBot.skillatk_start)
    skillatk.onPhaseFinished = override(skillatk.onPhaseFinished, SuperGuildBot.skillatk_onPhaseFinished)
    skillatk.createProjectile = override(skillatk.createProjectile, SuperGuildBot.skillatk_createProjectile)
  end
  local skillatk_2 = hero.skills.SuperGuildBot_atk_2
  if skillatk_2 then
    skillatk_2.start = override(skillatk_2.start, SuperGuildBot.skillatk_start)
    skillatk_2.onPhaseFinished = override(skillatk_2.onPhaseFinished, SuperGuildBot.skillatk_onPhaseFinished)
    skillatk_2.onAttackFrame = override(skillatk_2.onAttackFrame, SuperGuildBot.skillatk_2_onAttackFrame)
  end
  local skillpasv = hero.skills.SuperGuildBot_pasv
  if skillpasv then
    hero.onDying = override(hero.onDying, SuperGuildBot.hero_onDying)
    skillpasv.takeEffectAt = override(skillpasv.takeEffectAt, SuperGuildBot.skillpasv_takeEffectAt)
  end
  local skillult2 = hero.skills.SuperGuildBot_ult_2
  if skillult2 then
    skillult2.start = override(skillult2.start, SuperGuildBot.skillult_start)
    skillult2.createBuff = override(skillult2.createBuff, SuperGuildBot.skillult2_createBuff)
  end
  return hero
end

return SuperGuildBot.init_hero
