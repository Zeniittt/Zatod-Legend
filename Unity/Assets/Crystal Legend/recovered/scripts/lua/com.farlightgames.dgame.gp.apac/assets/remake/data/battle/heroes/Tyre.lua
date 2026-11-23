module("ed.battlehero", package.seeall)
local ed = ed
Tyre = {}
Tyre.grownSize = 1.4

function Tyre.hero_getRuntimeScale(basefunc, self)
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
    if self.ultBuff_Tyre then
      return self.direction * Tyre.grownSize, Tyre.grownSize
    end
    return self.direction, 1
  end
end

function Tyre.skillult_onAttackFrame(basefunc, self)
  if self.caster.manually_casting and self.attack_counter == 1 then
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

function Tyre.skillult_takeEffectAt(basefunc, skill, location, source)
  local attack_counter = skill.attack_counter
  local caster = skill.caster
  if attack_counter == 2 then
    basefunc(skill, location, source)
    caster.ultBuff_Tyre = true
    if not ed.engine.guildInstance_mode or caster.camp ~= ed.emCampEnemy then
      local maxHP = caster.attribs.HP
      caster.attribs.HP = caster.attribs.HP * skill.info["Script Arg2"]
      caster.config.hp_mod = caster.config.hp_mod and caster.config.hp_mod * skill.info["Script Arg2"] or skill.info["Script Arg2"]
      caster.hp = caster.attribs.HP * (skill.info["Script Arg2"] - 1) + caster.hp
    end
  elseif attack_counter == 1 then
    caster:startScalingAction(Tyre.grownSize, 1)
  end
end

function Tyre.skillult_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  caster:endScalingAction()
  if caster.ultBuff_Tyre then
    local cd1, cd2, cd3
    if caster.skills.Tyre_atk then
      cd1 = caster.skills.Tyre_atk.cd_remaining
    end
    if caster.skills.Tyre_atk2 then
      cd2 = caster.skills.Tyre_atk2.cd_remaining
    end
    if caster.skills.Tyre_atk3 then
      cd3 = caster.skills.Tyre_atk3.cd_remaining
    end
    caster.growingBuff_Tyre = true
    if ed.protoAwake(caster.proto, 79) then
      caster:enterActionStageFromOneStage(4, 79)
    else
      caster:enterActionStageFromOneStage(2, 79)
    end
    if cd1 then
      caster.skills.Tyre_atk.cd_remaining = cd1
    end
    if cd2 then
      caster.skills.Tyre_atk2.cd_remaining = cd2
    end
    if cd3 then
      caster.skills.Tyre_atk3.cd_remaining = cd3
    end
  end
end

function Tyre.buff_onRemoved(basefunc, buff)
  local owner = buff.owner
  if ed.engine.beingEnd and buff.info.ID == 314 then
    basefunc(buff)
    owner.GodBuffState_Tyre = nil
    if ed.engine.time_limit <= 0 and (ed.engine.crusade_mode or ed.engine.excavate_mode) then
      owner.ultBuff_Tyre = nil
      owner:die()
    end
  elseif ed.engine.beingEnd and buff.info.ID == 313 then
    basefunc(buff)
  elseif buff.info.ID == 310 then
    if not owner.GodBuffState_Tyre or ed.engine.beingEnd then
      basefunc(buff)
      local cd1, cd2, cd3
      if owner.skills.Tyre_atk then
        cd1 = owner.skills.Tyre_atk.cd_remaining
      end
      if owner.skills.Tyre_atk2 then
        cd2 = owner.skills.Tyre_atk2.cd_remaining
      end
      if owner.skills.Tyre_atk3 then
        cd3 = owner.skills.Tyre_atk3.cd_remaining
      end
      owner.ultBuff_Tyre = nil
      owner.growingBuff_Tyre = nil
      if ed.protoAwake(owner.proto, 79) then
        owner:enterActionStageFromOneStage(3, 79)
      else
        owner:enterActionStageFromOneStage(1, 79)
      end
      if cd1 then
        owner.skills.Tyre_atk.cd_remaining = cd1
      end
      if cd2 then
        owner.skills.Tyre_atk2.cd_remaining = cd2
      end
      if cd3 then
        owner.skills.Tyre_atk3.cd_remaining = cd3
      end
      if not ed.engine.guildInstance_mode or owner.camp ~= ed.emCampEnemy then
        local para = owner.skills.Tyre_ult.info["Script Arg2"]
        owner.attribs.HP = owner.attribs.HP / para
        local maxHP = owner.attribs.HP
        owner.config.hp_mod = owner.config.hp_mod / para
        if owner.hp > owner.attribs.HP then
          owner.hp = owner.attribs.HP
        end
      end
      if ed.run_with_scene then
        ed.scene:playEffectOnScene("eff_point_Tyre_ult.cha", {
          owner.position[1],
          owner.position[2] - 1
        }, {
          owner.direction,
          1
        }, nil, 0)
      end
    else
      return
    end
  elseif buff.info.ID == 314 then
    if buff.protect == 1 then
      basefunc(buff)
      owner.ultBuff_Tyre = nil
      owner.GodBuffState_Tyre = nil
      owner:die()
    else
      return
    end
  elseif buff.info.ID == 313 and buff.protect == 2 then
    basefunc(buff)
  end
end

function Tyre.skillult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.onRemoved = override(buff.onRemoved, Tyre.buff_onRemoved)
  buff:setAttribute("AD", buff.info.AD + buff.owner.attribs.AD * (skill.info["Script Arg2"] - 1))
  return buff
end

function Tyre.skillult_canCastWithTarget(basefunc, skill, target)
  local caster = skill.caster
  local ret, err = basefunc(skill, target)
  if not ret then
    return ret, err
  end
  if caster.ultBuff_Tyre then
    return false, "ultIng"
  end
  return true
end

function Tyre.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.ultBuff_Tyre = nil
  if ed.protoAwake(hero.proto, 79) then
    hero:enterActionStageFromOneStage(3, 79)
  else
    hero:enterActionStageFromOneStage(1, 79)
  end
end

function Tyre.skillatk_onPhaseFinished(basefunc, self)
  self:finish()
end

function Tyre.skillatk_start(basefunc, self, target)
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
end

function Tyre.skillatk_general_takeEffectOn(basefunc, skill, target, source, shift)
  local skill_awake = skill.caster.skills.Tyre_awake
  local rand = skill_awake.level * 0.33
  local stun_rand = ed.rand() * 100
  local result, dmg, Crit = basefunc(skill, target, source, shift)
  if result and (Crit or rand > stun_rand) then
    skill_awake:takeEffectOn(target)
  end
end

function Tyre.skillall_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 310 and tbuff.timer < 5 and not caster.GodBuffState_Tyre then
      caster:removeBuff(tbuff)
    end
  end
end

function Tyre.GodBuff_update(basefunc, self, dt)
  local hpr = self.info.HPR * dt
  if hpr < 0 then
    local damage = math.min(-hpr, self.owner.hp)
    damage = damage * self.owner.dPSStatisticsRatio
    if self.owner ~= self.caster then
      self.caster.battledata:addDamage(damage, "HPR")
      self.owner.battledata:addBearDamage(damage)
    end
  end
  if 0 < hpr then
    self.owner.battledata:addHeal(hpr)
  end
  if self.timer then
    self.timer = self.timer - dt
    if 0 > self.timer then
      if self.info.ID == 313 then
        self.protect = 2
      elseif self.info.ID == 314 then
        self.protect = 1
      end
      self.owner:removeBuff(self)
    end
  end
end

function Tyre.God_addBuff(basefunc, self, buff_Or_Binfo, caster)
  local buff = basefunc(self, buff_Or_Binfo, caster)
  if buff and (buff.info.ID == 313 or buff.info.ID == 314) then
    buff.onRemoved = override(buff.onRemoved, Tyre.buff_onRemoved)
    buff.update = override(buff.update, Tyre.GodBuff_update)
  end
  return buff
end

function Tyre.hero_onDying(basefunc, self, killer)
  if self.ultBuff_Tyre and not self.GodBuffState_Tyre then
    local bid = 313
    local bid2 = 314
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local binfo2 = ed.lookupDataTable("Buff", nil, bid2)
    self:addBuff(binfo, self)
    self:addBuff(binfo2, self)
    self.GodBuffState_Tyre = true
    local list = self.buff_list
    for i = 1, #list do
      if list[i].info.ID == 310 then
        list[i].timer = 99
        break
      end
    end
  elseif not self.GodBuffState_Tyre then
    basefunc(self, killer)
  end
end

function Tyre.init_hero(hero)
  hero:setActionStageChangeByManual(true)
  hero.reset = override(hero.reset, Tyre.hero_reset)
  hero.onDying = override(hero.onDying, Tyre.hero_onDying)
  hero.addBuff = override(hero.addBuff, Tyre.God_addBuff)
  local skillult = hero.skills.Tyre_ult
  local skillawake = hero.skills.Tyre_awake
  if skillult then
    skillult.canCastWithTarget = override(skillult.canCastWithTarget, Tyre.skillult_canCastWithTarget)
    skillult.onAttackFrame = override(skillult.onAttackFrame, Tyre.skillult_onAttackFrame)
    skillult.takeEffectAt = override(skillult.takeEffectAt, Tyre.skillult_takeEffectAt)
    skillult.finish = override(skillult.finish, Tyre.skillult_finish)
    skillult.createBuff = override(skillult.createBuff, Tyre.skillult_createBuff)
  end
  local skillatk = hero.skills.Tyre_atk
  if skillatk then
    skillatk.start = override(skillatk.start, Tyre.skillatk_start)
    skillatk.onPhaseFinished = override(skillatk.onPhaseFinished, Tyre.skillatk_onPhaseFinished)
    skillatk.finish = override(skillatk.finish, Tyre.skillall_finish)
    if skillawake then
      skillatk.takeEffectOn = override(skillatk.takeEffectOn, Tyre.skillatk_general_takeEffectOn)
    end
  end
  local skillatk2 = hero.skills.Tyre_atk2
  if skillatk2 then
    skillatk2.finish = override(skillatk2.finish, Tyre.skillall_finish)
    if skillawake then
      skillatk2.takeEffectOn = override(skillatk.takeEffectOn, Tyre.skillatk_general_takeEffectOn)
    end
  end
  local skillatk3 = hero.skills.Tyre_atk3
  if skillatk3 then
    skillatk3.finish = override(skillatk3.finish, Tyre.skillall_finish)
    if skillawake then
      skillatk3.takeEffectOn = override(skillatk.takeEffectOn, Tyre.skillatk_general_takeEffectOn)
    end
  end
  return hero
end

return Tyre.init_hero
