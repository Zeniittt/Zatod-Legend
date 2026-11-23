module("ed.battlehero", package.seeall)
local ed = ed
AV = {}
AV.skillFashionId = 361
AV.atk3buff = 10003604

function AV.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local position = {
    caster.position[1],
    caster.position[2]
  }
  if skill.target then
    position = {
      skill.target.position[1],
      skill.target.position[2]
    }
  end
  skill.caster.origin_AV = {
    position[1],
    position[2]
  }
  skill:selectTarget(target)
  if ed.run_with_scene then
    local effect_name = "eff_launch_AV_ult.cha"
    if not effect_name then
      return
    end
    ed.scene:playEffectOnScene(effect_name, skill.caster.origin_AV, nil, nil, -1)
  end
end

function AV.skillult_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  if skill.attack_counter and skill.attack_counter == 0 then
    basefunc(skill)
  elseif skill.attack_counter and skill.attack_counter == 1 then
    skill.attack_counter = skill.attack_counter + 1
  end
end

function AV.skillult_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  projectile.height = 300
  projectile.position = skill.caster.origin_AV
  return projectile
end

function AV.skillult_willCast(basefunc, skill)
  local flag = true
  if skill.caster.skills.AV_atk3 ~= nil and skill.caster.current_skill == skill.caster.skills.AV_atk3 then
    flag = false
  end
  return basefunc(skill) and flag
end

function AV.skillult_takeEffectOn(basefunc, self, target, source, shift)
  local isHit, dmg, Crit, lfs_amount = basefunc(self, target, source, shift)
  local caster = self.caster
  local skill_fashion_FlyTiger = caster.skills.AV_fashion_FlyTiger
  local skillevo1 = caster.skills.AV_evo1
  local skillevo2 = caster.skills.AV_evo2
  if isHit and AV.skillFashionId and AV.skillFashionId == caster.fashion_id and skill_fashion_FlyTiger then
    skill_fashion_FlyTiger:takeEffectOn(target, source, shift)
  end
  if isHit and self.evo_rank and self.evo_rank >= 3 then
    if skillevo1 then
      skillevo1:takeEffectOn(target, source, shift)
    end
    if skillevo2 then
      skillevo2:takeEffectOn(target, source, shift)
    end
  end
  return isHit, dmg, Crit, lfs_amount
end

function AV.skillatk3_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local dis = caster.direction == 1 and ed.engine.stage_rect.maxX - caster.position[1] or caster.position[1]
  local t = 2.3
  local v = dis / t
  if skill.attack_counter and skill.attack_counter == 0 then
    caster.walk_v = {
      caster.direction * v,
      0
    }
    caster.AVultposition = {
      caster.position[1],
      caster.position[2]
    }
    local bid = AV.atk3buff
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    caster:addBuff(binfo, caster)
    basefunc(skill)
  elseif skill.attack_counter and skill.attack_counter == 11 then
    caster.walk_v = {0, 0}
    caster.position = {
      caster.AVultposition[1],
      caster.AVultposition[2]
    }
  else
    basefunc(skill)
  end
end

function AV.skillatk2_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  local v = 1200
  local target = projectile.skill.target
  if not target then
    return
  end
  projectile:enableTrack(target)
  local targetpos = target.position
  local targetxyV = ed.edpSub(targetpos, projectile.position)
  local targetzV = -projectile.height
  local u = (targetxyV[1] * targetxyV[1] + targetxyV[2] * targetxyV[2] + targetzV * targetzV) ^ (-0.5)
  local targetV = {
    u * targetxyV[1],
    u * targetxyV[2],
    u * targetzV
  }
  projectile.velocity[1] = projectile.velocity[1] + targetV[1] * v
  projectile.velocity[2] = projectile.velocity[2] + targetV[2] * v
  projectile.zSpeed = projectile.zSpeed + targetV[3] * v
  return projectile
end

function AV.skillatk2_createBuff(basefunc, skill, target)
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

function AV.init_hero(hero)
  local skillult = hero.skills.AV_ult
  local skillatk2 = hero.skills.AV_atk2
  local skillatk3 = hero.skills.AV_atk3
  local skillpasv = hero.passive_skill_list[1]
  local skillsawake = hero.skills.AV_sawake1
  if skillult then
    if skillult.evo_rank and 1 <= skillult.evo_rank then
      skillult.info = ed.wraptable(skillult.info, {
        ["Plus Ratio"] = skillult.evo_rank1["Script Arg1"]
      })
    end
    if skillult.evo_rank and skillult.evo_rank >= 2 then
      skillult.info = ed.wraptable(skillult.info, {
        ["Plus Ratio"] = skillult.evo_rank2["Script Arg1"]
      })
    end
    hero:preloadEffect("eff_launch_AV_ult.cha")
    skillult.start = override(skillult.start, AV.skillult_start)
    skillult.createProjectile = override(skillult.createProjectile, AV.skillult_createProjectile)
    skillult.willCast = override(skillult.willCast, AV.skillult_willCast)
    skillult.takeEffectOn = override(skillult.takeEffectOn, AV.skillult_takeEffectOn)
    skillult.onAttackFrame = override(skillult.onAttackFrame, AV.skillult_onAttackFrame)
  end
  if skillatk2 then
    if skillatk2.evo_rank and 1 <= skillatk2.evo_rank then
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
      skillatk2.createBuff = override(skillatk2.createBuff, AV.skillatk2_createBuff)
    end
    skillatk2.createProjectile = override(skillatk2.createProjectile, AV.skillatk2_createProjectile)
  end
  if skillatk3 then
    if skillatk3.evo_rank and 1 <= skillatk3.evo_rank then
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
    skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, AV.skillatk3_onAttackFrame)
  end
  if skillpasv then
    local aname = skillpasv["Passive Attr"]
    if skillpasv.evo_rank and 1 <= skillpasv.evo_rank then
      skillpasv["Basic Num"] = skillpasv["Basic Num"] + skillpasv.evo_rank1["Script Arg1"]
    end
    if skillpasv.evo_rank and skillpasv.evo_rank >= 2 then
      skillpasv["Basic Num"] = skillpasv["Basic Num"] + skillpasv.evo_rank2["Script Arg1"]
    end
    if skillpasv.evo_rank and skillpasv.evo_rank >= 3 then
      skillpasv["Basic Num"] = skillpasv["Basic Num"] + skillpasv.evo_rank3["Script Arg1"]
    end
    hero:rebuild()
  end
  return hero
end

return AV.init_hero
