module("ed.battlehero", package.seeall)
local ed = ed
Alch = {}

function Alch.skillatk_takeEffectOn(basefunc, skill, target)
  local isHit, dmg = basefunc(skill, target)
  local caster = skill.caster
  local skillatk4 = caster.skills.Alch_atk4
  if skillatk4 and target and isHit and dmg and 0 < dmg then
    local buff = skillatk4:createBuff(target)
    target:addBuff(buff)
  end
  return isHit, dmg
end

function Alch.skillatk2d_takeEffectOn(basefunc, skill, target)
  local isHit, dmg = basefunc(skill, target)
  local caster = skill.caster
  local skillatk4 = caster.skills.Alch_atk4
  if skillatk4 and target and isHit and dmg and 0 < dmg then
    local buff = skillatk4:createBuff(target)
    target:addBuff(buff)
  end
  return isHit, dmg
end

function Alch.skillatk2_createRegion(basefunc, skill)
  local Alch_atk2Region = basefunc(skill)
  local caster = skill.caster
  local skillatk2 = caster.skills.Alch_atk2
  Alch_atk2Region.target = caster
  Alch_atk2Region.position = {
    caster.position[1] + caster.direction * 180,
    caster.position[2]
  }
  caster.AlchAtk2Region = Alch_atk2Region
  Alch_atk2Region.update = override(Alch_atk2Region.update, Alch.atk2Region_update)
  Alch_atk2Region.terminate = override(Alch_atk2Region.terminate, Alch.atk2Region_terminate)
  Alch_atk2Region.Active_Time = 1
  if skillatk2 and skillatk2.evo_rank and 2 <= skillatk2.evo_rank then
    Alch_atk2Region.timer = Alch_atk2Region.timer + skillatk2.evo_rank2["Script Arg1"]
  end
  return Alch_atk2Region
end

function Alch.atk2Region_update(basefunc, region, dt)
  basefunc(region, dt)
  local caster = region.caster
  local skillatk2 = caster.skills.Alch_atk2
  local skillatk2d = caster.skills.Alch_atk2d
  if skillatk2 or skillatk2d then
    if region.Active_Time then
      region.Active_Time = region.Active_Time + dt
    end
    if region.Active_Time and region.Active_Time >= 1 then
      region.Active_Time = 0
      skillatk2d:takeEffectAt(region.position, caster)
    end
  end
end

function Alch.atk2Region_terminate(basefunc, region)
  if region.Active_Time then
    region.Active_Time = 0
  end
  basefunc(region)
end

function Alch.skillatk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = buff.caster
  local skillatk2 = caster.skills.Alch_atk2
  if skillatk2 and skillatk2.evo_rank and skillatk2.evo_rank >= 3 then
    local MRdown_ARM = buff.info.ARM
    buff:setAttribute("MR", MRdown_ARM)
  end
  return buff
end

function Alch.skillatk3_createProjectile(basefunc, skill)
  local caster = skill.caster
  local target = skill.target
  local projectile = basefunc(skill)
  local d = {0, 0}
  if projectile then
    local Y_fixDirection = 1
    if caster.position[2] <= target.position[2] then
      Y_fixDirection = -1
    end
    projectile.targetPosition = {
      target.position[1],
      target.position[2] + 3 * Y_fixDirection
    }
    projectile.position, projectile.height = skill:launchPoint()
    if projectile.targetPosition then
      d = {
        projectile.targetPosition[1] - projectile.position[1],
        projectile.targetPosition[2] - projectile.position[2]
      }
      projectile.velocity = ed.edpMult(ed.edpNormalize(d), skill.info["Tile XY Speed"])
      projectile.camp = caster.camp
      ed.engine:addProjectile(projectile)
    end
    return nil
  end
end

function Alch.skillatk3_takeEffectOn(basefunc, skill, target)
  local isHit, dmg = basefunc(skill, target)
  local caster = skill.caster
  local skillatk4 = caster.skills.Alch_atk4
  if skillatk4 and target and isHit and dmg and 0 < dmg then
    local buff = skillatk4:createBuff(target)
    target:addBuff(buff)
  end
  return isHit, dmg
end

function Alch.skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = buff.caster
  local skillatk3 = caster.skills.Alch_atk3
  if skillatk3.evo_rank and skillatk3.evo_rank >= 3 then
    buff.timer = buff.timer + skillatk3.evo_rank3["Script Arg1"]
  end
  return buff
end

function Alch.skillult_canCastWithTarget(basefunc, skill, target)
  local hero = skill.caster
  local result, reason = basefunc(skill, target)
  if not result or hero.ultBuff_Alch or hero.current_skill == hero.manual_skill then
    return false
  end
  return true
end

function Alch.skillult_buffOnRemoved(basefunc, buff)
  local owner = buff.owner
  basefunc(buff)
  if owner then
    owner.global_cd = 0
  end
  if owner and owner.current_skill then
    owner:hurt()
  end
  if ed.run_with_scene then
    local panel = buff.caster.heroPanel
    if panel and buff.owner.name == "Alch" then
      panel:setPortrait("UI/DOTA-HERO/Alch.jpg")
    end
  end
  if owner.changePeriod_Alch then
    if not ed.engine.beingEnd or owner:isAlive() then
      owner:enterActionStageFromOneStage(owner:AlchGetNormalPeriod(), 10103)
    end
    owner.changePeriod_Alch = nil
    owner.ultBuff_Alch = nil
  end
  local effect_name = "eff_buff_Alch_ult.cha"
  if ed.run_with_scene and effect_name and owner and owner.actor then
    owner.actor:addEffect(effect_name, 1)
  end
end

function Alch.skillult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local skillult = caster.skills.Alch_ult
  buff.onRemoved = override(buff.onRemoved, Alch.skillult_buffOnRemoved)
  caster.ultBuff_Alch = true
  if ed.run_with_scene then
    local panel = caster.heroPanel
    if panel and caster.name == "Alch" then
      panel:setPortrait("UI/DOTA-HERO/AlchUlt.jpg")
    end
  end
  if skillult.evo_rank and skillult.evo_rank >= 1 then
    local AD = buff.info.AD
    buff:setAttribute("AD", AD + skillult.evo_rank1["Script Arg1"])
  end
  if skillult.evo_rank and skillult.evo_rank >= 2 then
    local HAST = buff.info.HAST
    local MSPD = buff.info.MSPD
    buff:setAttribute("HAST", HAST + skillult.evo_rank2["Script Arg1"])
    buff:setAttribute("MSPD", MSPD + skillult.evo_rank2["Script Arg1"])
  end
  return buff
end

function Alch.skillult_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local skillult = caster.skills.Alch_ult
  caster.changePeriod_Alch = true
  if skill.attack_counter == 1 and skillult.evo_rank and skillult.evo_rank >= 3 then
    local HPHeal = caster.attribs.HP * skillult.evo_rank3["Script Arg1"] / 100
    caster:takeHeal(HPHeal, "hp", caster)
  end
end

function Alch.skillult_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  if caster and caster.changePeriod_Alch then
    caster:enterActionStageFromOneStage(caster:AlchGetUltPeriod(), 10103)
  end
  if caster then
    caster.global_cd = 0
  end
end

function Alch.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.changePeriod_Alch = nil
  hero.ultBuff_Alch = nil
  hero.AlchAtk2Region = nil
end

function Alch.hero_die(basefunc, hero, killer)
  basefunc(hero, killer)
  if hero.AlchAtk2Region then
    hero.AlchAtk2Region:terminate()
  end
end

function Alch.hero_true_init(hero)
  hero.reset = override(hero.reset, Alch.hero_reset)
  hero.die = override(hero.die, Alch.hero_die)
  hero:setActionStageChangeByManual(true)
  local skillult = hero.skills.Alch_ult
  local skillatk = hero.skills.Alch_atk
  local skillatks = hero.skills.Alch_atks
  local skillatk2 = hero.skills.Alch_atk2
  local skillatk2s = hero.skills.Alch_atk2s
  local skillatk2d = hero.skills.Alch_atk2d
  local skillatk3 = hero.skills.Alch_atk3
  local skillatk3s = hero.skills.Alch_atk3s
  local skillatk4 = hero.skills.Alch_atk4
  if skillult then
    skillult.canCastWithTarget = override(skillult.canCastWithTarget, Alch.skillult_canCastWithTarget)
    skillult.createBuff = override(skillult.createBuff, Alch.skillult_createBuff)
    skillult.onAttackFrame = override(skillult.onAttackFrame, Alch.skillult_onAttackFrame)
    skillult.finish = override(skillult.finish, Alch.skillult_finish)
  end
  if skillatk and skillatks then
    skillatk.takeEffectOn = override(skillatk.takeEffectOn, Alch.skillatk_takeEffectOn)
    skillatks.takeEffectOn = override(skillatks.takeEffectOn, Alch.skillatk_takeEffectOn)
  end
  if skillatk2 and skillatk2s and skillatk2d then
    skillatk2.createRegion = override(skillatk2.createRegion, Alch.skillatk2_createRegion)
    skillatk2s.createRegion = override(skillatk2s.createRegion, Alch.skillatk2_createRegion)
    skillatk2.createBuff = override(skillatk2.createBuff, Alch.skillatk2_createBuff)
    skillatk2s.createBuff = override(skillatk2s.createBuff, Alch.skillatk2_createBuff)
    skillatk2d.takeEffectOn = override(skillatk2d.takeEffectOn, Alch.skillatk2d_takeEffectOn)
    if skillatk2.evo_rank and skillatk2.evo_rank >= 1 then
      skillatk2d.info = ed.wraptable(skillatk2d.info, {
        ["Plus Ratio"] = skillatk2.evo_rank1["Script Arg1"]
      })
    end
  end
  if skillatk3 and skillatk3s then
    skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, Alch.skillatk3_takeEffectOn)
    skillatk3s.takeEffectOn = override(skillatk3s.takeEffectOn, Alch.skillatk3_takeEffectOn)
    skillatk3.createBuff = override(skillatk3.createBuff, Alch.skillatk3_createBuff)
    skillatk3s.createBuff = override(skillatk3s.createBuff, Alch.skillatk3_createBuff)
    skillatk3.createProjectile = override(skillatk3.createProjectile, Alch.skillatk3_createProjectile)
    skillatk3s.createProjectile = override(skillatk3s.createProjectile, Alch.skillatk3_createProjectile)
    if skillatk3.evo_rank and skillatk3.evo_rank >= 1 then
      skillatk3.info = ed.wraptable(skillatk3.info, {
        ["Plus Ratio"] = skillatk3.evo_rank1["Script Arg1"]
      })
      skillatk3s.info = ed.wraptable(skillatk3s.info, {
        ["Plus Ratio"] = skillatk3.evo_rank1["Script Arg1"]
      })
    end
    if skillatk3.evo_rank and skillatk3.evo_rank >= 2 then
      skillatk3.info = ed.wraptable(skillatk3.info, {
        ["Plus Ratio"] = skillatk3.evo_rank2["Script Arg1"]
      })
      skillatk3s.info = ed.wraptable(skillatk3s.info, {
        ["Plus Ratio"] = skillatk3.evo_rank2["Script Arg1"]
      })
    end
  end
  if skillatk4 then
    local binfo = skillatk4.info.buff_info
    if skillatk4.evo_rank and skillatk4.evo_rank >= 1 then
      binfo.Time = binfo.Time + skillatk4.evo_rank1["Script Arg1"]
    end
    if skillatk4.evo_rank and skillatk4.evo_rank >= 2 then
      local HAST = binfo.HAST
      local MSPD = binfo.MSPD
      binfo.HAST = HAST - skillatk4.evo_rank2["Script Arg1"]
      binfo.MSPD = MSPD - skillatk4.evo_rank2["Script Arg1"]
    end
    if skillatk4.evo_rank and skillatk4.evo_rank >= 3 then
      local APdown_AD = binfo.AD
      binfo.AP = APdown_AD
    end
  end
  
  function hero.AlchGetNormalPeriod(unit)
    return 1
  end
  
  function hero.AlchGetUltPeriod(unit)
    return 2
  end
  
  return hero
end

function Alch.init_hero(hero)
  Alch.hero_true_init(hero)
  return hero
end

return Alch.init_hero
