module("ed.battlehero", package.seeall)
local ed = ed
Hecate = {}

function Hecate.projectile_update(basefunc, projectile, dt)
  basefunc(projectile, dt)
  if projectile.totalTime then
    projectile.totalTime = projectile.totalTime + dt
    if projectile.totalTime > 0.8 then
      local v = 600
      local target = projectile.skill.target
      if not target then
        return
      end
      projectile:enableTrack(target)
      local targetpos = target.position
      local targetxyV = ed.edpSub(targetpos, projectile.position)
      local targetzV = -projectile.height + 40
      local u = (targetxyV[1] * targetxyV[1] + targetxyV[2] * targetxyV[2] + targetzV * targetzV) ^ (-0.5)
      local targetV = {
        targetxyV[1] * u,
        targetxyV[2] * u,
        targetzV * u
      }
      projectile.velocity[1] = projectile.velocity[1] + targetV[1] * v
      projectile.velocity[2] = projectile.velocity[2] + targetV[2] * v
      projectile.zSpeed = projectile.zSpeed + targetV[3] * v
      projectile.totalTime = nil
    end
  end
end

function Hecate.skillatk3_takeEffectOn(basefunc, skill, target, source)
  local caster = skill.caster
  local mpdamage = skill.info["Script Arg2"]
  if source then
    caster:takeHeal(mpdamage, "mp", skill.caster)
  else
    basefunc(skill, target, source)
    target:takeDamage(mpdamage, "Holy", "mp", skill.caster)
    local originfo = skill.info
    skill.info = ed.wraptable(originfo, {
      ["AOE Origin"] = "self",
      ["Target Type"] = "self",
      ["Target Camp"] = 1,
      ["Affected Camp"] = 1
    })
    skill.target = caster
    local projectile = skill:createProjectile()
    ed.engine:addProjectile(projectile)
    projectile.direction = -projectile.direction
    projectile.position = {
      target.position[1],
      target.position[2]
    }
    projectile.update = override(projectile.update, Hecate.projectile_update)
    projectile.totalTime = 0.1
    skill.info = originfo
  end
end

function Hecate.skillult_onAttackFrame(basefunc, self)
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

function Hecate.skillult_startPhase(basefunc, skill, idx)
  local attack_counter = skill.attack_counter
  local caster = skill.caster
  local target = skill.target
  if attack_counter == 0 then
    caster.origposition = {
      caster.position[1],
      caster.position[2]
    }
  elseif attack_counter == 1 then
    target = target or skill:selectTarget(nil)
    if target then
      caster.position = {
        target.position[1] - caster.direction * 80,
        target.position[2]
      }
    end
  elseif attack_counter == 2 then
    caster:setPosition({
      caster.origposition[1],
      caster.origposition[2]
    })
  end
  basefunc(skill, idx)
end

function Hecate.skillult_takeEffectAt(basefunc, skill, location, source)
  local caster = skill.caster
  local attack_counter = skill.attack_counter
  if skill.attack_counter == 1 then
  elseif attack_counter == 2 then
    basefunc(skill, location, source)
    local skillawake = caster.skills.Hecate_awake
    if skillawake and skill.target and not skill.target:isAlive() then
      for unit in ed.engine:foreachAliveUnit(caster.camp) do
        unit:addBuff(skillawake:createBuff(unit))
      end
    end
  end
end

function Hecate.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local bid = 385
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
end

function Hecate.skillult_power(basefunc, skill, source, target, damage_type)
  local retValue, i = basefunc(skill, source, target, damage_type)
  if target.mp / 1000 < 0.3 then
    return retValue * 1.3, i
  end
  return retValue, i
end

function Hecate.skillatk_onPhaseFinished(basefunc, self)
  self:finish()
end

function Hecate.skillatk_start(basefunc, self, target)
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
  if ran < 0.9 then
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

function Hecate.init_hero(hero)
  local skillult = hero.skills.Hecate_ult
  local skillatk = hero.skills.Hecate_atk
  local skillatk3 = hero.skills.Hecate_atk3
  if skillult then
    skillult.startPhase = override(skillult.startPhase, Hecate.skillult_startPhase)
    skillult.start = override(skillult.start, Hecate.skillult_start)
    skillult.takeEffectAt = override(skillult.takeEffectAt, Hecate.skillult_takeEffectAt)
    skillult.onAttackFrame = override(skillult.onAttackFrame, Hecate.skillult_onAttackFrame)
    skillult.power = override(skillult.power, Hecate.skillult_power)
  end
  if skillatk then
    skillatk.start = override(skillatk.start, Hecate.skillatk_start)
    skillatk.onPhaseFinished = override(skillatk.onPhaseFinished, Hecate.skillatk_onPhaseFinished)
  end
  if skillatk3 then
    skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, Hecate.skillatk3_takeEffectOn)
  end
  return hero
end

return Hecate.init_hero
