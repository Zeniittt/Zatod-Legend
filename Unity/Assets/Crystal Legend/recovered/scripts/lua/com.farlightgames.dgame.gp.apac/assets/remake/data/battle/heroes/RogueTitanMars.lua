module("ed.battlehero", package.seeall)
local ed = ed
RogueTitanMars = {}

function RogueTitanMars.skillatk_start(basefunc, self, target)
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

function RogueTitanMars.skillatk_onPhaseFinished(basefunc, self)
  self:finish()
end

function RogueTitanMars.getLostHPAfterImmunity(basefunc, hero, damage, immunity, damage_type, source)
  local lost = basefunc(hero, damage, immunity, damage_type, source)
  if damage_type == "AD" then
    local skillatk3 = hero.skills.RogueTitanMars_atk3
    if skillatk3 and lost and 0 < lost and source and 0 > hero.direction * (hero.position[1] - source.position[1]) then
      local resist_value = skillatk3.info["Script Arg2"] / 100
      if skillatk3.evo_rank and 1 <= skillatk3.evo_rank then
        resist_value = resist_value + skillatk3.evo_rank1["Script Arg1"] / 100
      end
      if skillatk3.evo_rank and skillatk3.evo_rank >= 2 then
        resist_value = resist_value + skillatk3.evo_rank2["Script Arg1"] / 100
      end
      if ed.run_with_scene then
        local effect = "eff_impact_TitanMars_atk3.cha"
        local origin = hero.position
        ed.scene:playEffectOnScene(effect, origin, {
          hero.direction * -1,
          0.85
        }, nil, 0)
      end
      local parry = lost * resist_value
      lost = lost - parry
      if skillatk3.evo_rank and skillatk3.evo_rank >= 3 then
        if hero.atk3_parry_value and 0 < hero.atk3_parry_value then
          hero.atk3_parry_value = hero.atk3_parry_value + parry
          if hero.atk3_parry_value >= hero.attribs.HP * (skillatk3.evo_rank3["Script Arg1"] / 100) then
            local skillatk2 = hero.skills.RogueTitanMars_atk2
            skillatk2.cd_remaining = 0
            hero.global_cd = 0
            hero.atk3_parry_value = 0
          end
        else
          hero.atk3_parry_value = parry
        end
      end
    end
  end
  return lost
end

function RogueTitanMars.hero_reset(basefunc, hero)
  basefunc(hero)
  local skillatk3 = hero.skills.RogueTitanMars_atk3
  if skillatk3 and skillatk3.evo_rank and skillatk3.evo_rank >= 3 then
    hero.atk3_parry_value = 0
  end
  local skillults = hero.skills.RogueTitanMars_ults
  if skillults and ed.engine.stage_info["Stage ID"] == -2 then
    skillults.info = ed.wraptable(skillults.info, {
      ["AOE Shape"] = "halfcircle",
      ["Shape Arg1"] = 600,
      ["Damage Type"] = "AP"
    })
    local bid = 4766
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = hero:addBuff(binfo, hero)
  end
end

function RogueTitanMars.skillatk4_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local skillatk4 = caster.skills.RogueTitanMars_atk4
  local ad = skillatk4.info["Script Arg2"]
  local arm = skillatk4.info["Script Arg3"]
  local mr = skillatk4.info["Script Arg4"]
  local bid = 11011005
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = ed.BuffCreate(binfo, caster, caster)
  if skillatk4.evo_rank and skillatk4.evo_rank >= 2 then
    ad = ad + skillatk4.evo_rank2["Script Arg1"]
  end
  buff:setAttribute("AD", ad)
  buff:setAttribute("ARM", arm)
  buff:setAttribute("MR", mr)
  caster:addBuff(buff, caster)
  basefunc(skill)
  if ed.run_with_scene then
    local effect_name = "eff_impact_TitanMars_atk4.cha"
    local direction = caster:getInitDir()
    ed.scene:playEffectOnScene(effect_name, caster.position, {direction, 1}, nil, 0)
  end
end

function RogueTitanMars.skillult_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  local target = skill.target
  projectile:enableTrack(target)
  projectile.update = override(projectile.update, RogueTitanMars.projectile_update)
  projectile.hit = override(projectile.hit, RogueTitanMars.projectile_hit)
  projectile.terminate = override(projectile.terminate, RogueTitanMars.projectile_Terminate)
  return projectile
end

function RogueTitanMars.projectile_update(basefunc, projectile, dt)
  basefunc(projectile, dt)
  if ed.run_with_scene and projectile.actor then
    projectile.actor.ownScaleX = 0.66
    projectile.actor.ownScaleY = 0.66
  end
  projectile.zSpeed = projectile.zSpeed - projectile.skill.info["Tile Gravity"] * dt
  local dv = 600 * dt
  local target = projectile.skill.target
  if not target then
    return
  end
  target = target.position
  local xySpeed = projectile.velocity
  local zSpeed = projectile.zSpeed
  local v = {
    xySpeed[1],
    xySpeed[2],
    zSpeed
  }
  local targetxyV = ed.edpSub(target, projectile.position)
  local targetzV = -projectile.height
  local u = (targetxyV[1] * targetxyV[1] + targetxyV[2] * targetxyV[2] + targetzV * targetzV) ^ (-0.5)
  local targetV = {
    u * targetxyV[1],
    u * targetxyV[2],
    u * targetzV
  }
  if zSpeed and dv < zSpeed then
    projectile.zSpeed = projectile.zSpeed - dv
    dv = 0
  elseif zSpeed and 0 < zSpeed then
    dv = dv - zSpeed
    projectile.zSpeed = 0
  end
  projectile.velocity[1] = projectile.velocity[1] + targetV[1] * dv * 8
  projectile.velocity[2] = projectile.velocity[2] + targetV[2] * dv * 8
  projectile.zSpeed = projectile.zSpeed + targetV[3] * dv * 8
end

function RogueTitanMars.projectile_hit(basefunc, projectile, target)
  local skill = projectile.skill
  local caster = skill.caster
  local skillults = caster.skills.RogueTitanMars_ults
  local skillults_target
  local maxPriority = 999
  basefunc(projectile, target)
  if target then
    caster.RogueTitanMars_ult_target = target
    for unit in ed.engine:foreachAliveUnit(skill:affectedCamp()) do
      if unit.buff_effects.untargetable then
      elseif unit.buff_effects.enchanted then
      elseif math.abs(target.position[1] - unit.position[1]) > 120 then
      elseif caster.direction * (unit.position[1] - target.position[1]) < 0 then
      elseif unit == target then
      elseif math.abs(target.position[2] - unit.position[2]) > 100 then
      else
        local priority = math.abs(target.position[1] - unit.position[1])
        if maxPriority > priority then
          maxPriority = priority
          skillults_target = unit
        end
      end
    end
  end
  if skillults_target and skillults then
    if ed.engine.stage_info["Stage ID"] == -2 then
      skillults:takeEffectAt(target.position, caster)
    else
      skillults:takeEffectOn(skillults_target, caster)
    end
  end
  if not projectile.terminated then
    projectile:terminate()
  end
end

function RogueTitanMars.projectile_Terminate(basefunc, self)
  local caster = self.caster
  local skillults2 = caster.skills.RogueTitanMars_ults2
  local RogueTitanMars_region
  if caster.name == "RogueTitanMars" and caster.RogueTitanMars_ult_target then
    skillults2.target = caster.RogueTitanMars_ult_target
    RogueTitanMars_region = skillults2:createRegion()
    RogueTitanMars_region.terminate = override(RogueTitanMars_region.terminate, RogueTitanMars.RogueTitanMars_region_terminate)
    caster.RogueTitanMars_region = RogueTitanMars_region
    ed.engine:addRegion(RogueTitanMars_region)
    caster.RogueTitanMars_ult_target = nil
    if RogueTitanMars_region.position and ed.run_with_scene then
      local effect_name = "eff_buff_TitanMars_ult.cha"
      local effect = ed.scene:playEffectOnScene(effect_name, RogueTitanMars_region.position, {
        caster.direction,
        1
      }, nil, 0)
      ed.scene:startCameraShakeAnimationY(5, 0.2, 5)
      caster.ult_region_effect = effect
      if ed.engine.stage_info["Stage ID"] == -2 then
        local effect_name_s = "eff_point_TitanDragon_atk2_a.cha"
        ed.scene:playEffectOnScene(effect_name_s, RogueTitanMars_region.position, {
          caster.direction,
          1
        }, nil, 1)
      end
    end
  end
  basefunc(self)
end

function RogueTitanMars.RogueTitanMars_region_terminate(basefunc, region)
  basefunc(region)
  local caster = region.caster
  if caster.RogueTitanMars_region then
    caster.RogueTitanMars_region = nil
  end
  if caster.ult_region_effect then
    local z = 0
    ed.scene:removeEffect(caster.ult_region_effect, z)
  end
end

function RogueTitanMars.getRuntimeScale(basefunc, self)
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
    return self.direction * (m and 1.05 or 1), m and 1.05 or 1
  end
end

function RogueTitanMars.skillatk2_takeEffectOn(basefunc, skill, target, source)
  local originfo = skill.info
  local caster = skill.caster
  if skill.evo_rank and skill.evo_rank >= 3 then
    skill.info = ed.wraptable(originfo, {
      ["No Dodge"] = true
    })
  end
  local ret, dmg = basefunc(skill, target, source)
  return ret, dmg
end

function RogueTitanMars.skillatk4_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local buffInfo = buff.info
  local owner = buff.owner
  local caster = buff.caster
  local attribName = buffInfo.Tenacity
  local TEN_final = ed.Buff.getTenValue(buffInfo, owner, caster)
  if skill.evo_rank and skill.evo_rank >= 1 then
    buff.timer = (buff.timer + skill.evo_rank1["Script Arg1"]) * math.max(0.01, 1 - TEN_final / 100)
  end
  return buff
end

function RogueTitanMars.skillatk4_start(basefunc, skill, target)
  basefunc(skill, target)
  local hero = skill.caster
  local bid = 11011009
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  hero:addBuff(binfo, hero)
end

function RogueTitanMars.init_hero(hero)
  local skillult = hero.skills.RogueTitanMars_ult
  local skillatk = hero.skills.RogueTitanMars_atk
  local skillatk2 = hero.skills.RogueTitanMars_atk2
  local skillatk3 = hero.skills.RogueTitanMars_atk3
  local skillatk4 = hero.skills.RogueTitanMars_atk4
  local skillults = hero.skills.RogueTitanMars_ults
  hero.reset = override(hero.reset, RogueTitanMars.hero_reset)
  if skillatk then
    skillatk.start = override(skillatk.start, RogueTitanMars.skillatk_start)
    skillatk.onPhaseFinished = override(skillatk.onPhaseFinished, RogueTitanMars.skillatk_onPhaseFinished)
  end
  if skillatk2 then
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
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, RogueTitanMars.skillatk2_takeEffectOn)
  end
  if skillatk3 then
    hero.getLostHPAfterImmunity = override(hero.getLostHPAfterImmunity, RogueTitanMars.getLostHPAfterImmunity)
  end
  if skillatk4 then
    skillatk4.onAttackFrame = override(skillatk4.onAttackFrame, RogueTitanMars.skillatk4_onAttackFrame)
    skillatk4.createBuff = override(skillatk4.createBuff, RogueTitanMars.skillatk4_createBuff)
    if skillatk4.evo_rank and skillatk4.evo_rank >= 3 then
      skillatk4.start = override(skillult.start, RogueTitanMars.skillatk4_start)
    end
  end
  if skillult then
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
    if skillults then
      if skillult.evo_rank and skillult.evo_rank >= 1 then
        skillults.info = ed.wraptable(skillults.info, {
          ["Plus Ratio"] = skillult.evo_rank1["Script Arg1"]
        })
      end
      if skillult.evo_rank and skillult.evo_rank >= 2 then
        skillults.info = ed.wraptable(skillults.info, {
          ["Plus Ratio"] = skillult.evo_rank2["Script Arg1"]
        })
      end
      if skillult.evo_rank and skillult.evo_rank >= 3 then
        skillults.info = ed.wraptable(skillults.info, {
          ["Plus Ratio"] = skillult.evo_rank3["Script Arg1"]
        })
      end
    end
    skillult.createProjectile = override(skillult.createProjectile, RogueTitanMars.skillult_createProjectile)
    hero.getRuntimeScale = override(hero.getRuntimeScale, RogueTitanMars.getRuntimeScale)
  end
  return hero
end

return RogueTitanMars.init_hero
