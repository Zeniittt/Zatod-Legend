module("ed.battlehero", package.seeall)
local ed = ed
Baltor = {}
Baltor.sawake_bid1 = 4080
Baltor.sawake_bid2 = 4081
Baltor.sawake_bid3 = 4082

function Baltor.skillatk_start(basefunc, self, target)
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

function Baltor.skillatk_onPhaseFinished(basefunc, self)
  self:finish()
end

function Baltor.skillatk3_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  local h = projectile.height
  local v = projectile.zSpeed
  local a = skill.info["Tile Gravity"]
  local A = 0.5 * a
  local B = v
  local C = h
  local delta = B ^ 2 - 4 * A * C
  local t = (-B - delta ^ 0.5) / (2 * A)
  local target_position = {
    skill.target.position[1] - 100 * skill.caster.direction,
    skill.target.position[2]
  }
  local distance = ed.edpSub(target_position, skill.caster.position)
  projectile.velocity = ed.edpMult(distance, 1 / t)
  ed.engine:addProjectile(projectile)
end

function Baltor.projectile_update(basefunc, projectile, dt)
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

function Baltor.skillatk2_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  projectile.update = override(projectile.update, Baltor.projectile_update)
  return projectile
end

function Baltor.skillult_start(basefunc, skill, target)
  local owner = skill.caster
  local bid = 367
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = owner:addBuff(binfo, owner)
  basefunc(skill, target)
end

function Baltor.skillult_finish(basefunc, skill)
  basefunc(skill)
  for i, tbuff in ipairs(skill.caster.buff_list) do
    if tbuff.info.ID == 367 then
      local buff = tbuff
      buff.owner:removeBuff(buff)
    end
  end
end

function Baltor.skillult_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  local caster = skill.caster
  if attack_counter == 1 then
    if skill.info["Target Type"] == "random" or skill.target == nil or not skill.target:isAlive() then
      skill:selectTarget(nil)
    end
    skill.attack_counter = skill.attack_counter + 1
    if skill.target then
      skill:takeEffectAt(skill.target.position)
    else
      skill:takeEffectAt(skill.caster.position)
    end
    if ed.run_with_scene then
      ed.scene:startCameraShakeAnimationY(5, 0.3, 5)
    end
  elseif attack_counter == 0 then
    if skill.info["Target Type"] == "random" or skill.target == nil or not skill.target:isAlive() then
      skill:selectTarget(nil)
    end
    caster.oldposition_Baltor = {}
    caster.oldposition_Baltor[1] = caster.position[1]
    caster.oldposition_Baltor[2] = caster.position[2]
    if skill.target then
      caster.position[1] = skill.target.position[1]
      caster.position[2] = skill.target.position[2]
    end
    skill.attack_counter = skill.attack_counter + 1
  else
    caster.position = caster.oldposition_Baltor
    skill.attack_counter = skill.attack_counter + 1
  end
end

function Baltor.skillawake_takeEffectOn(basefunc, skill, target, source)
  local awakeposition = target and target.position or nil
  basefunc(skill, target, source)
  local skillawake = skill.caster.skills.Baltor_awake
  if awakeposition then
    skillawake:takeEffectAt(awakeposition, source)
  end
  local skillsawake = skill.caster.skills.Baltor_sawake
  if skillsawake then
    skillsawake:takeEffectOn(target)
  end
end

function Baltor.skill_takeEffectOn(basefunc, skill, target, source)
  local is_hit = basefunc(skill, target, source)
  local skillsawake = skill.caster.skills.Baltor_sawake
  if skillsawake and is_hit then
    skillsawake:takeEffectOn(target)
  end
end

function Baltor.skillsawake_takeEffectOn(basefunc, skill, target, source)
  basefunc(skill, target, source)
  local caster = skill.caster
  if ed.protoSuperAwake(caster.proto, 89) then
    local skillsawake = skill.caster.skills.Baltor_sawake
    if skillsawake then
      local rand = ed.rand() * 100
      if rand < 20 and 0 < rand then
        local binfo = ed.lookupDataTable("Buff", nil, Baltor.sawake_bid1)
        local buff = ed.BuffCreate(binfo, target, caster)
        buff:setAttribute("HPR", -0.8 * skillsawake.info["Script Arg2"])
        target:addBuff(buff, caster)
      elseif rand < 80 and 20 <= rand then
        local binfo = ed.lookupDataTable("Buff", nil, Baltor.sawake_bid2)
        local buff = ed.BuffCreate(binfo, target, caster)
        buff:setAttribute("HPR", -0.9 * skillsawake.info["Script Arg2"])
        target:addBuff(buff, caster)
      elseif rand < 100 and 80 <= rand then
        local binfo = ed.lookupDataTable("Buff", nil, Baltor.sawake_bid3)
        local buff = ed.BuffCreate(binfo, target, caster)
        buff:setAttribute("HPR", -1 * skillsawake.info["Script Arg2"])
        target:addBuff(buff, caster)
      end
    end
  end
end

function Baltor.init_hero(hero)
  local skillatk = hero.skills.Baltor_atk
  if skillatk then
    skillatk.start = override(skillatk.start, Baltor.skillatk_start)
    skillatk.onPhaseFinished = override(skillatk.onPhaseFinished, Baltor.skillatk_onPhaseFinished)
  end
  local skillatk2 = hero.skills.Baltor_atk2
  if skillatk2 then
    skillatk2.createProjectile = override(skillatk2.createProjectile, Baltor.skillatk2_createProjectile)
  end
  local skillatk3 = hero.skills.Baltor_atk3
  if skillatk3 then
    skillatk3.createProjectile = override(skillatk3.createProjectile, Baltor.skillatk3_createProjectile)
  end
  local skillult = hero.skills.Baltor_ult
  if skillult then
    skillult.onAttackFrame = override(skillult.onAttackFrame, Baltor.skillult_onAttackFrame)
    skillult.start = override(skillult.start, Baltor.skillult_start)
    skillult.finish = override(skillult.finish, Baltor.skillult_finish)
  end
  local skillawake = hero.skills.Baltor_awake
  if skillawake then
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, Baltor.skillawake_takeEffectOn)
    skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, Baltor.skillawake_takeEffectOn)
  end
  local skillsawake = hero.skills.Baltor_sawake
  local skillatk4 = hero.skills.Baltor_atk4
  if skillsawake then
    skillsawake.takeEffectOn = override(skillsawake.takeEffectOn, Baltor.skillsawake_takeEffectOn)
    skillatk.takeEffectOn = override(skillatk.takeEffectOn, Baltor.skill_takeEffectOn)
    skillatk4.takeEffectOn = override(skillatk4.takeEffectOn, Baltor.skill_takeEffectOn)
    skillatk.info = ed.wraptable(skillatk.info, {
      ["Tile Art"] = "eff_tile_Baltor_atk_sawake.cha"
    })
    skillatk2.info = ed.wraptable(skillatk2.info, {
      ["Tile Art"] = "eff_tile_Baltor_atk3_sawake.cha"
    })
    skillatk3.info = ed.wraptable(skillatk3.info, {
      ["Tile Art"] = "eff_tile_Baltor_atk4_sawake.cha"
    })
  end
  return hero
end

return Baltor.init_hero
