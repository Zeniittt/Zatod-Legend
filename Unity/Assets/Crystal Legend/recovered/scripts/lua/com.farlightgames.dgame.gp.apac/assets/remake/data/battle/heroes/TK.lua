module("ed.battlehero", package.seeall)
local ed = ed
TK = {}
TK.TKPasvRefreshRate = 0.3
TK.ultEvobuff = 10000901
TK.atk3Evobuff = 10000903

function TK.skillult_onAttackFrame(basefunc, skill)
  if skill.caster.manually_casting then
    ed.engine:unfreeze()
    skill.caster.manually_casting = false
  end
  if skill.info["Target Type"] == "random" then
    skill:selectTarget(skill.target)
  end
  if not skill.target then
    return
  end
  local info = skill.info
  local caster = skill.caster
  skill.attack_counter = skill.attack_counter + 1
  local counter = skill.attack_counter
  local ttype = info["Track Type"]
  if counter % 3 ~= 2 then
    skill.info["Tile Art"] = "eff_tile_TK_atk2.cha"
    skill.info["Tile OTT Height"] = 0
    skill.info["Tile XY Speed"] = skill.info["Script Arg2"]
    skill.info["Tile Z Speed"] = 0
  else
    skill.info["Tile Art"] = "eff_tile_TK_atk3.cha"
    skill.info["Tile OTT Height"] = skill.info["Script Arg4"]
    skill.info["Tile XY Speed"] = skill.info["Script Arg5"]
    skill.info["Tile Z Speed"] = skill.info["Script Arg3"]
  end
  if ttype == "projectile" then
    local projectile = skill:createProjectile()
    ed.engine:addProjectile(projectile)
  elseif ttype == "chain" then
    local chain = skill:createChain()
    ed.engine:addChain(chain)
  elseif ttype == nil then
    skill:takeEffectAt(skill.target.position)
  else
    EDDebug("Unkonwn Track Type: '" .. type .. "'")
  end
  caster:setMP(caster.mp + info["Gain MP"] * ed.engine.mp_bonus)
  if 0 < info["Move Forward"] then
    caster.position[1] = caster.position[1] + info["Move Forward"] * caster.direction
  end
end

function TK.projectile_update(basefunc, projectile, dt)
  basefunc(projectile, dt)
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

function TK.skill_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  projectile.update = override(projectile.update, TK.projectile_update)
  return projectile
end

function TK.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  for _, skillinfo in ipairs(hero.aura_skill_list) do
    if skillinfo["Skill Name"] == "TK_pasv" then
      local skillatk2 = hero.skills.TK_atk2
      if skillatk2 then
        local HAST = hero.attribs.HAST
        local dt_cd = dt * (0 < HAST and (100 + HAST) / 100 or 100 / (100 - HAST))
        if hero.TK_atk2_realCDRemaining then
          hero.TK_atk2_realCDRemaining = hero.TK_atk2_realCDRemaining - dt_cd
        end
      end
      local skillatk3 = hero.skills.TK_atk3
      if skillatk3 then
        local HAST = hero.attribs.HAST
        local dt_cd = dt * (0 < HAST and (100 + HAST) / 100 or 100 / (100 - HAST))
        if hero.TK_atk3_realCDRemaining then
          hero.TK_atk3_realCDRemaining = hero.TK_atk3_realCDRemaining - dt_cd
        end
      end
    end
  end
end

function TK.hero_reset(basefunc, hero)
  basefunc(hero)
  for _, skillinfo in ipairs(hero.aura_skill_list) do
    if skillinfo["Skill Name"] == "TK_pasv" then
      if hero.TK_atk2_refresh then
        hero.TK_atk2_refresh = nil
      end
      if hero.TK_atk2s_refresh then
        hero.TK_atk2s_refresh = nil
      end
      if hero.TK_atk3_refresh then
        hero.TK_atk3_refresh = nil
      end
      if hero.TK_atk2_realCDRemaining then
        hero.TK_atk2_realCDRemaining = nil
      end
      if hero.TK_atk3_realCDRemaining then
        hero.TK_atk3_realCDRemaining = nil
      end
    end
  end
end

function TK.skillatk2_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local skillaura = skill.caster.aura_skill_list[1]
  local rate = TK.TKPasvRefreshRate
  if not skill.caster.TK_atk2_refresh then
    if skillaura.evo_rank and skillaura.evo_rank >= 3 then
      rate = skillaura.evo_rank3["Script Arg1"] / 100
    end
    if rate > ed.rand() then
      skill.caster.TK_atk2_realCDRemaining = skill.cd_remaining
      skill.cd_remaining = 0
      skill.caster.global_cd = 0
      skill.caster.TK_atk2_refresh = true
    end
  else
    skill.caster.TK_atk2_refresh = false
  end
end

function TK.skillatk3_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local skillaura = skill.caster.aura_skill_list[1]
  local rate = TK.TKPasvRefreshRate
  if not skill.caster.TK_atk3_refresh then
    if skillaura.evo_rank and skillaura.evo_rank >= 3 then
      rate = skillaura.evo_rank3["Script Arg1"] / 100
    end
    if rate > ed.rand() then
      skill.caster.TK_atk3_realCDRemaining = skill.cd_remaining
      skill.cd_remaining = 0
      skill.caster.global_cd = 0
      skill.caster.TK_atk3_refresh = true
    end
  else
    skill.caster.TK_atk3_refresh = false
  end
end

function TK.skillatk2_finish(basefunc, skill)
  if skill.caster.TK_atk2_realCDRemaining and not skill.caster.TK_atk2_refresh then
    skill.cd_remaining = skill.caster.TK_atk2_realCDRemaining
  end
  skill.caster.TK_atk2_realCDRemaining = nil
  basefunc(skill)
end

function TK.skillatk3_finish(basefunc, skill)
  if skill.caster.TK_atk3_realCDRemaining and not skill.caster.TK_atk3_refresh then
    skill.cd_remaining = skill.caster.TK_atk3_realCDRemaining
  end
  skill.caster.TK_atk3_realCDRemaining = nil
  basefunc(skill)
end

function TK.skillult_finish(basefunc, skill)
  if skill.evo_rank and skill.evo_rank >= 3 then
    local caster = skill.caster
    local bid = TK.ultEvobuff
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, caster, caster)
    caster:addBuff(buff, caster)
  end
  basefunc(skill)
end

function TK.init_hero(hero)
  local skillult = hero.skills.TK_ult
  local skillatk3 = hero.skills.TK_atk3
  local skillatk = hero.skills.TK_atk
  local skillatk2 = hero.skills.TK_atk2
  local skillaura = hero.aura_skill_list[1]
  hero.reset = override(hero.reset, TK.hero_reset)
  hero.update = override(hero.update, TK.hero_update)
  if skillatk3 then
    skillatk3.createProjectile = override(skillatk3.createProjectile, TK.skill_createProjectile)
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
  end
  if skillult then
    skillult.createProjectile = override(skillult.createProjectile, TK.skill_createProjectile)
    skillult.onAttackFrame = override(skillult.onAttackFrame, TK.skillult_onAttackFrame)
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
    if skillult.evo_rank and skillult.evo_rank >= 3 then
      skillult.finish = override(skillult.finish, TK.skillult_finish)
    end
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
      skillatk2.info = ed.wraptable(skillatk2.info, {
        ["AOE Origin"] = "target",
        ["AOE Shape"] = "circle",
        ["Shape Arg1"] = 100
      })
    end
  end
  for _, skillinfo in ipairs(hero.aura_skill_list) do
    if skillinfo["Skill Name"] == "TK_pasv" then
      local skillatk2 = hero.skills.TK_atk2
      if skillatk2 then
        skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, TK.skillatk2_onAttackFrame)
        skillatk2.finish = override(skillatk2.finish, TK.skillatk2_finish)
      end
      local skillatk3 = hero.skills.TK_atk3
      if skillatk3 then
        skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, TK.skillatk3_onAttackFrame)
        skillatk3.finish = override(skillatk3.finish, TK.skillatk3_finish)
      end
    end
  end
  if skillaura then
    local aname = skillaura["Passive Attr"]
    if skillaura.evo_rank and 1 <= skillaura.evo_rank then
      skillaura["Basic Num"] = skillaura["Basic Num"] + skillaura.evo_rank1["Script Arg1"]
    end
    if skillaura.evo_rank and skillaura.evo_rank >= 2 then
      skillaura["Basic Num"] = skillaura["Basic Num"] + skillaura.evo_rank2["Script Arg1"]
    end
  end
  return hero
end

return TK.init_hero
