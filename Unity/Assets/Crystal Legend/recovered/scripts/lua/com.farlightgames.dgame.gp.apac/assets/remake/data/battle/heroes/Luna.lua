module("ed.battlehero", package.seeall)
local ed = ed
Luna = {}
Luna.buff_shard = 10003102
Luna.buff_shard_effect = 10003103
Luna.shardbuff_interval = 1
Luna.percents = {
  0.614,
  0.7225,
  0.85,
  1
}
Luna.shardpercents = {
  0.444,
  0.522,
  0.614,
  0.7225,
  0.85,
  1
}
Luna.fashionID3 = 313

function Luna.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  if ed.run_with_scene then
    local effect_night = "eff_point_Luna_night.cha"
    local effect_moon = "eff_point_Luna_moon.cha"
    local origin = {
      ed.engine.stage_rect.maxX / 2,
      0
    }
    local casterorigin = skill.caster.position
    if skill.caster.fashion_id == 311 then
      effect_moon = "eff_point_Luna_moon_bloodmoon"
    end
    if Luna.fashionID3 and Luna.fashionID3 == skill.caster.fashion_id then
      effect_moon = "eff_point_Luna_fashion_3_moon"
    end
    ed.scene:playEffectOnScene(effect_moon, casterorigin, {
      skill.caster.direction,
      1
    }, nil, 2)
    ed.scene:playEffectOnScene(effect_night, origin, nil, nil, 0)
  end
end

function Luna.skillult_finish(basefunc, skill)
  local caster = skill.caster
  local shard = caster.proto._shard
  if shard and shard._id == 1000311 and caster.shardSkillRank and caster.shardSkillRank >= 3 then
    local haveshardbuff = false
    for i, tbuff in ipairs(caster.buff_list) do
      if tbuff.info.ID == Luna.buff_shard then
        tbuff.timer = 3
        haveshardbuff = true
      end
      if tbuff.info.ID == Luna.buff_shard_effect then
        tbuff.timer = 3
      end
    end
    if not haveshardbuff then
      local bid = Luna.buff_shard
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, caster, caster)
      if Luna.fashionID3 and Luna.fashionID3 == caster.fashion_id then
        buff:setAttribute("Effect", "eff_buff_Luna_fashion_3_Shard_a.cha")
      end
      buff:setAttribute("PIMU", caster.shardSkill[3]["Script Arg1"])
      buff:setAttribute("MIMU", caster.shardSkill[3]["Script Arg1"])
      caster:addBuff(buff, caster)
      buff.update = override(buff.update, Luna.shardbuff_update)
      buff.refresh_timer = Luna.shardbuff_interval
      local bid2 = Luna.buff_shard_effect
      local binfo2 = ed.lookupDataTable("Buff", nil, bid2)
      local buff2 = ed.BuffCreate(binfo2, caster, caster)
      if Luna.fashionID3 and Luna.fashionID3 == caster.fashion_id then
        buff2:setAttribute("Effect", "eff_buff_Luna_fashion_3_Shard_b.cha")
      end
      caster:addBuff(buff2, caster)
    end
  end
  basefunc(skill)
end

function Luna.shardbuff_update(basefunc, buff, dt)
  local caster = buff.caster
  local skill = caster.skills.Luna_shard
  local timer = buff.refresh_timer - dt
  while timer < 0 do
    timer = timer + Luna.shardbuff_interval
    skill:takeEffectAt(caster.position, caster)
  end
  buff.refresh_timer = timer
  basefunc(buff, dt)
end

function Luna.skillatk2_finish(basefunc, skill)
  local caster = skill.caster
  local shard = caster.proto._shard
  if shard and shard._id == 1000311 and caster.shardSkillRank and caster.shardSkillRank >= 3 then
    local haveshardbuff = false
    for i, tbuff in ipairs(caster.buff_list) do
      if tbuff.info.ID == Luna.buff_shard then
        tbuff.timer = 3
        haveshardbuff = true
      end
      if tbuff.info.ID == Luna.buff_shard_effect then
        tbuff.timer = 3
      end
    end
    if not haveshardbuff then
      local bid = Luna.buff_shard
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, caster, caster)
      if Luna.fashionID3 and Luna.fashionID3 == caster.fashion_id then
        buff:setAttribute("Effect", "eff_buff_Luna_fashion_3_Shard_a.cha")
      end
      buff:setAttribute("PIMU", caster.shardSkill[3]["Script Arg1"])
      buff:setAttribute("MIMU", caster.shardSkill[3]["Script Arg1"])
      caster:addBuff(buff, caster)
      buff.update = override(buff.update, Luna.shardbuff_update)
      buff.refresh_timer = Luna.shardbuff_interval
      local bid2 = Luna.buff_shard_effect
      local binfo2 = ed.lookupDataTable("Buff", nil, bid2)
      local buff2 = ed.BuffCreate(binfo2, caster, caster)
      if Luna.fashionID3 and Luna.fashionID3 == caster.fashion_id then
        buff2:setAttribute("Effect", "eff_buff_Luna_fashion_3_Shard_b.cha")
      end
      caster:addBuff(buff2, caster)
    end
  end
  basefunc(skill)
end

function Luna.skillatk3_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  local caster = skill.caster
  local jumptimes = 4
  local shard = caster.proto._shard
  if shard and shard._id == 1000311 and caster.shardSkillRank and caster.shardSkillRank >= 1 then
    jumptimes = caster.shardSkill[1]["Script Arg1"] + 1
  end
  projectile:enableJump(jumptimes)
  projectile:enableTrack(skill.target)
  return projectile
end

function Luna.skillatk3_power(basefunc, skill, source, target, damage_type)
  local ret = basefunc(skill, source, target, damage_type)
  local caster = skill.caster
  local shard = caster.proto._shard
  if skill.evo_rank and skill.evo_rank >= 3 then
  elseif shard and shard._id == 1000311 and caster.shardSkillRank and caster.shardSkillRank >= 1 then
    if source.jumps and 1 <= source.jumps and source.jumps <= caster.shardSkill[1]["Script Arg1"] + 1 then
      ret = ret * Luna.shardpercents[source.jumps]
    end
  elseif source.jumps and 1 <= source.jumps and source.jumps <= 4 then
    ret = ret * Luna.percents[source.jumps]
  end
  return ret
end

function Luna.init_hero(hero)
  local skillult = hero.skills.Luna_ult
  local skillatk = hero.skills.Luna_atk
  local skillatk2 = hero.skills.Luna_atk2
  local skillatk3 = hero.skills.Luna_atk3
  local skillaura = hero.aura_skill_list[1]
  local skillatk = hero.skills.Luna_atk
  local shard = hero.proto._shard
  if skillult then
    hero:preloadEffect("eff_point_Luna_night.cha")
    hero:preloadEffect("eff_point_Luna_moon.cha")
    skillult.start = override(skillult.start, Luna.skillult_start)
    skillult.finish = override(skillult.finish, Luna.skillult_finish)
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
      skillult.info = ed.wraptable(skillult.info, {
        ["Plus Ratio"] = skillult.evo_rank3["Script Arg1"]
      })
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
        ["Plus Ratio"] = skillatk2.evo_rank3["Script Arg1"]
      })
    end
    skillatk2.finish = override(skillatk2.finish, Luna.skillatk2_finish)
  end
  if skillatk3 then
    hero.basic_skill = skillatk3
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
    skillatk3.createProjectile = override(skillatk3.createProjectile, Luna.skillatk3_createProjectile)
    skillatk3.power = override(skillatk3.power, Luna.skillatk3_power)
  end
  if hero.fashion_id == 311 then
    hero:preloadEffect("eff_point_Luna_moon_bloodmoon.cha")
    if skillatk then
      hero.skills.Luna_atk.info["Tile Art"] = "eff_tile_Luna_atk_bloodmoon.cha"
    end
    if skillatk3 then
      hero.skills.Luna_atk3.info["Tile Art"] = "eff_tile_Luna_atk_bloodmoon.cha"
    end
    if skillult then
      hero.skills.Luna_ult.info["Impact Effect"] = "eff_point_Luna_atk2_bloodmoon.cha"
    end
    if skillatk2 then
      hero.skills.Luna_atk2.info["Impact Effect"] = "eff_point_Luna_atk2_bloodmoon.cha"
    end
  elseif hero.fashion_id == 313 then
    if skillatk then
      hero.skills.Luna_atk.info["Tile Art"] = "eff_tile_Luna_fashion_3_atk.cha"
    end
    if skillatk3 then
      hero.skills.Luna_atk3.info["Tile Art"] = "eff_tile_Luna_fashion_3_atk.cha"
    end
    if skillult then
      hero.skills.Luna_ult.info["Impact Effect"] = "eff_point_Luna_fashion_3_atk2.cha"
    end
    if skillatk2 then
      hero.skills.Luna_atk2.info["Impact Effect"] = "eff_point_Luna_fashion_3_atk2.cha"
    end
  end
  if skillaura then
    local aname = skillaura["Passive Attr"]
    local num = skillaura["Basic Num"]
    if skillaura.evo_rank and 1 <= skillaura.evo_rank then
      skillaura["Basic Num"] = skillaura["Basic Num"] + skillaura.evo_rank1["Script Arg1"]
    end
    if skillaura.evo_rank and skillaura.evo_rank >= 2 then
      skillaura["Basic Num"] = skillaura["Basic Num"] + skillaura.evo_rank2["Script Arg1"]
    end
    if skillaura.evo_rank and skillaura.evo_rank >= 3 then
      skillaura["Basic Num"] = skillaura["Basic Num"] + skillaura.evo_rank3["Script Arg1"] / 100 * hero.attribs[aname]
    end
    if shard and shard._id == 1000311 and hero.shardSkillRank and 2 <= hero.shardSkillRank then
      skillaura["Basic Num"] = skillaura["Basic Num"] + hero.shardSkill[2]["Script Arg1"] / 100 * hero.attribs[aname]
    end
  end
  return hero
end

return Luna.init_hero
