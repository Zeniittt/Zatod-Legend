module("ed.battlehero", package.seeall)
local ed = ed
BossSM = {}

function BossSM.skill6_start(basefunc, skill, target)
  local caster = skill.caster
  local bid = 56
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
  basefunc(skill)
end

function BossSM.skill6_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local isRet, duration = skill:getDurationFromAttackFrameToEnd(skill.current_phase, skill.next_event)
  caster:startScalingAction(1.2, 1)
end

function BossSM.skill6_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  if caster then
    caster:enterActionStageFromOneStage(2, 348)
  end
  local skill2 = caster.skills.BossSM_atk2
  skill2.originfo = skill2.info
  skill2.info = ed.wraptable(skill2.originfo, {CD = 2})
  caster.config.dps_mod = caster.config.dps_mod and caster.config.dps_mod * 2
  caster:endScalingAction()
end

function BossSM.skillatk3_takeEffectAt(basefunc, skill, location, source)
  if skill.attack_counter == 1 then
    if skill.target then
      skill.magnetorigin = {
        skill.target.position[1],
        -30
      }
    else
      skill.magnetorigin = {
        skill.caster.position[1] + skill.info["X Shift"] * skill.caster.direction,
        0
      }
    end
    if ed.run_with_scene then
      local effect_name = "eff_point_SM_atk31.cha"
      ed.scene:playEffectOnScene(effect_name, skill.magnetorigin, {
        skill.caster.direction,
        1
      }, nil, 1)
    end
  else
    if skill.magnetorigin == nil then
      return
    end
    basefunc(skill, skill.magnetorigin, source)
    if ed.run_with_scene then
      local effect_name = "eff_point_SM_atk32.cha"
      ed.scene:playEffectOnScene(effect_name, skill.magnetorigin, {
        skill.caster.direction,
        1
      }, nil, 1)
    end
  end
end

function BossSM.skillult_finish(basefunc, skill)
  basefunc(skill)
  skill.position1 = nil
end

function BossSM.skillult_onAttackFrame(basefunc, self)
  if self.caster.manually_casting and self.attack_counter == 4 then
    ed.engine:unfreeze()
    self.caster.manually_casting = false
  end
  self.attack_counter = self.attack_counter + 1
  if self.attack_counter == 5 then
    return
  end
  if self.info["Target Type"] == "random" or self.target == nil or not self.target:isAlive() then
    self:selectTarget(nil)
  end
  if not self.target then
    return
  end
  if not self.position1 then
    self.position1 = {
      self.target.position[1],
      self.target.position[2]
    }
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
    self:takeEffectAt(self.position1)
  else
    EDDebug("Unkonwn Track Type: '" .. ttype .. "'")
  end
  caster:setMP(caster.mp + info["Gain MP"] * ed.engine.mp_bonus)
  if info["Move Forward"] ~= 0 then
    caster.position[1] = caster.position[1] + info["Move Forward"] * caster.direction
  end
end

function BossSM.skillult_takeEffectOn(basefunc, skill, target, source, shift)
  local caster = skill.caster
  local result, dmg, Crit = basefunc(skill, target, source, shift)
  local skillatk2 = skill.caster.skills.BossSM_atk2
  local skillatk2evo = skill.caster.skills.BossSM_atk2evo
  if skillatk2 and Crit and skillatk2.evo_rank and skillatk2.evo_rank >= 3 then
    local rand = ed.rand() < skillatk2.evo3rand
    if rand then
      skillatk2:selectTarget(nil)
      if skillatk2.target and skillatk2evo then
        skillatk2evo.target = target
        local projectile = skillatk2evo:createProjectile()
        ed.engine:addProjectile(projectile)
      end
    end
  end
end

function BossSM.skillatk2_takeEffectOn(basefunc, skill, target)
  local result, dmg, Crit = basefunc(skill, target)
  skill:selectTarget(nil)
  local skillatk2evo = skill.caster.skills.BossSM_atk2evo
  if skill.target and skill.evo_rank and skill.evo_rank >= 3 then
    local rand = ed.rand() < skill.evo3rand
    if Crit and rand and skillatk2evo then
      skillatk2evo.target = target
      local projectile = skillatk2evo:createProjectile()
      ed.engine:addProjectile(projectile)
    end
  end
end

function BossSM.skillatk3_takeEffectOn(basefunc, skill, target)
  local result, dmg, Crit = basefunc(skill, target)
  local skillatk2 = skill.caster.skills.BossSM_atk2
  local skillatk2evo = skill.caster.skills.BossSM_atk2evo
  if skillatk2 and skillatk2.evo_rank and skillatk2.evo_rank >= 3 then
    skillatk2:selectTarget(nil)
    local rand = ed.rand() < skillatk2.evo3rand
    if Crit and rand and skill.target and skillatk2evo then
      skillatk2evo.target = target
      local projectile = skillatk2evo:createProjectile()
      ed.engine:addProjectile(projectile)
    end
  end
end

function BossSM.skillatk4_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local mr = skill.info["Script Arg2"]
  local mrratio = skill.info["Script Arg3"]
  local int = skill.caster.attribs.INT
  local skillatk4mr = mr - mrratio * int
  local skillatk4mimu
  if skill.evo_rank and skill.evo_rank >= 1 then
    skillatk4mr = skillatk4mr - skill.evo_rank1["Script Arg1"]
  end
  if skill.evo_rank and skill.evo_rank >= 2 then
    skillatk4mr = skillatk4mr - skill.evo_rank2["Script Arg1"]
  end
  if skill.evo_rank and skill.evo_rank >= 3 then
    skillatk4mimu = -skill.evo_rank3["Script Arg1"]
  end
  buff:setAttribute("MR", skillatk4mr)
  if skill.evo_rank and skill.evo_rank >= 3 then
    buff:setAttribute("MIMU", skillatk4mimu)
  end
  return buff
end

function BossSM.hero_reset(basefunc, hero)
  basefunc(hero)
  if hero.skills.BossSM_ult then
    hero.skills.BossSM_ult.position1 = nil
  end
end

function BossSM.init_hero(hero)
  hero.reset = override(hero.reset, BossSM.hero_reset)
  local skillult = hero.skills.BossSM_ult
  local skillatk2 = hero.skills.BossSM_atk2
  local skillatk3 = hero.skills.BossSM_atk3
  local skillatk4 = hero.skills.BossSM_atk4
  local skillatk6 = hero.skills.BossSM_atk6
  local skillatk2evo = hero.skills.BossSM_atk2evo
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
    skillult.onAttackFrame = override(skillult.onAttackFrame, BossSM.skillult_onAttackFrame)
    skillult.finish = override(skillult.finish, BossSM.skillult_finish)
    skillult.takeEffectOn = override(skillult.takeEffectOn, BossSM.skillult_takeEffectOn)
  end
  if skillatk2 then
    if skillatk2.evo_rank and skillatk2.evo_rank >= 1 then
      skillatk2.info = ed.wraptable(skillatk2.info, {
        ["Plus Ratio"] = skillatk2.evo_rank1["Script Arg1"]
      })
      if skillatk2evo then
        skillatk2evo.info = ed.wraptable(skillatk2evo.info, {
          ["Plus Ratio"] = skillatk2.evo_rank1["Script Arg1"]
        })
      end
    end
    if skillatk2.evo_rank and skillatk2.evo_rank >= 2 then
      skillatk2.info = ed.wraptable(skillatk2.info, {
        ["Plus Ratio"] = skillatk2.evo_rank2["Script Arg1"]
      })
      if skillatk2evo then
        skillatk2evo.info = ed.wraptable(skillatk2evo.info, {
          ["Plus Ratio"] = skillatk2.evo_rank2["Script Arg1"]
        })
      end
    end
    if skillatk2.evo_rank and skillatk2.evo_rank >= 3 then
      skillatk2.evo3rand = skillatk2.evo_rank3["Script Arg1"] / 100
      skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, BossSM.skillatk2_takeEffectOn)
    end
  end
  if skillatk3 then
    if skillatk3.evo_rank and skillatk3.evo_rank >= 1 then
      skillatk3.info = ed.wraptable(skillatk3.info, {
        ["Plus Ratio"] = skillatk3.evo_rank1["Script Arg1"]
      })
    end
    if skillatk3.evo_rank and skillatk3.evo_rank >= 2 then
      skillatk3.info = ed.wraptable(skillatk3.info, {
        ["Plus Ratio"] = skillatk3.evo_rank2["Script Arg1"]
      })
    end
    if skillatk3.evo_rank and skillatk3.evo_rank >= 3 then
      skillatk3.info = ed.wraptable(skillatk3.info, {
        ["Plus Ratio"] = skillatk3.evo_rank3["Script Arg1"]
      })
    end
    skillatk3.takeEffectAt = override(skillatk3.takeEffectAt, BossSM.skillatk3_takeEffectAt)
    if skillatk2 then
      skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, BossSM.skillatk3_takeEffectOn)
    end
  end
  if skillatk4 then
    skillatk4.createBuff = override(skillatk4.createBuff, BossSM.skillatk4_createBuff)
  end
  if skillatk6 then
    skillatk6.start = override(skillatk6.start, BossSM.skill6_start)
    skillatk6.finish = override(skillatk6.finish, BossSM.skill6_finish)
    skillatk6.onAttackFrame = override(skillatk6.onAttackFrame, BossSM.skill6_onAttackFrame)
  end
  return hero
end

return BossSM.init_hero
