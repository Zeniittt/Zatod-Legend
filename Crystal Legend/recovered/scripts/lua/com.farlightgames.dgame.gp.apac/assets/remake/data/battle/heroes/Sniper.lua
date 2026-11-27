module("ed.battlehero", package.seeall)
local ed = ed
Sniper = {}
Sniper.fashion_id_1 = 101
Sniper.ult_stun_buff_id = 10001003
Sniper.ult_target_buff = 10001004
Sniper.crit_shard = 10001005
Sniper.ult_extra_damage_coef = 1.5
Sniper.ult_point_effect = "eff_point_Sniper_ult.cha"

function Sniper.skillatk2_onPhaseFinished(basefunc, skill)
  skill:finish()
end

function Sniper.hero_castManualSkill(basefunc, hero)
  basefunc(hero)
  if ed.run_with_scene then
    local currentSkill = hero.current_skill
    if currentSkill == hero.manual_skill and currentSkill.target and not currentSkill.Sniper_ultEffect then
      currentSkill.Sniper_ultEffect = true
      local effect_name = Sniper.ult_point_effect
      local target = currentSkill.target
      local position = target.position
      local height = target.height
      ed.scene:playEffectOnScene(effect_name, position, nil, height, 1)
    end
  end
end

function Sniper.skillult_takeEffectOn(basefunc, skill, target, source)
  local caster = skill.caster
  local originfo = skill.info
  skill.info = ed.wraptable(originfo, {
    ["No Dodge"] = true
  })
  local ret, dmg, Crit = basefunc(skill, target, source)
  skill.info = originfo
  if ret and not target:isAlive() and not target.config.is_summoned and target.killer and target.killer == caster then
    local mp = 150
    if skill.evo_rank and skill.evo_rank >= 3 then
      mp = skill.evo_rank3["Script Arg1"]
    end
    caster:takeHeal(mp, "mp", caster)
  end
  local stun
  local shard = caster.proto._shard
  if Crit and shard and shard._id == 1000101 and caster.shardSkillRank and caster.shardSkillRank >= 1 then
    local bid = Sniper.crit_shard
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, caster, caster)
    caster:addBuff(buff, caster)
  end
  return ret, dmg, Crit
end

function Sniper.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  skill.Sniper_ultEffect = false
  local caster = skill.caster
  if skill.target then
    local bid = Sniper.ult_target_buff
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, skill.target, caster)
    local addbuff = skill.target:addBuff(buff, caster)
  end
end

function Sniper.skillatk3_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  local h = projectile.height
  local v = projectile.zSpeed
  local a = skill.info["Tile Gravity"]
  local A = 0.5 * a
  local B = v
  local C = h
  local delta = B ^ 2 - 4 * A * C
  local t = (-B - delta ^ 0.5) / (2 * A)
  local target_position = skill.target.position
  local distance = ed.edpSub(target_position, skill.caster.position)
  projectile.velocity = ed.edpMult(distance, 1 / t)
  return projectile
end

function Sniper.skillatk3_buffUpdate(basefunc, buff, dt)
  basefunc(buff, dt)
  if buff.timer > 0 then
    local owner = buff.owner
    local MSPD_t1 = buff.info.MSPD
    local MSPD_t2 = MSPD_t1 * ((buff.timer - dt) / buff.timer)
    buff:setAttribute("MSPD", MSPD_t2)
    local owner = buff.owner
    local HAST_t1 = buff.info.HAST
    local HAST_t2 = HAST_t1 * ((buff.timer - dt) / buff.timer)
    buff:setAttribute("HAST", HAST_t2)
    owner:resetBuffApply(buff)
  end
end

function Sniper.skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.update = override(buff.update, Sniper.skillatk3_buffUpdate)
  local caster = skill.caster
  local agi_ratio = 9999
  if target.attribs.AGI > 0 then
    agi_ratio = caster.attribs.AGI / target.attribs.AGI
  end
  local coef = 1
  if 1 < agi_ratio then
    local maxcoef = 2.5
    if skill.evo_rank and 1 <= skill.evo_rank then
      maxcoef = skill.evo_rank1["Script Arg1"]
    end
    coef = math.min(agi_ratio * 1.1, maxcoef)
  end
  local HAST_0 = buff.info.HAST
  buff:setAttribute("HAST", HAST_0 * coef)
  local MSPD_0 = buff.info.MSPD
  buff:setAttribute("MSPD", MSPD_0 * coef)
  return buff
end

function Sniper.skillatk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local buffInfo = buff.info
  local owner = buff.owner
  local caster = buff.caster
  local attribName = buffInfo.Tenacity
  local TEN_final = ed.Buff.getTenValue(buffInfo, owner, caster)
  if skill.evo_rank and skill.evo_rank >= 1 then
    buff.timer = skill.evo_rank1["Script Arg1"] * math.max(0.01, 1 - TEN_final / 100)
  end
  return buff
end

function Sniper.skillatk_takeEffectOn(basefunc, skill, target, source)
  local caster = skill.caster
  local ret, dmg, Crit = basefunc(skill, target, source)
  local shard = caster.proto._shard
  if Crit and shard and shard._id == 1000101 and caster.shardSkillRank and caster.shardSkillRank >= 1 then
    local bid = Sniper.crit_shard
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, caster, caster)
    caster:addBuff(buff, caster)
  end
  return ret, dmg, Crit
end

function Sniper.skillatk2_takeEffectOn(basefunc, skill, target, source)
  local caster = skill.caster
  local shard = caster.proto._shard
  local originfo = skill.info
  if shard and shard._id == 1000101 and caster.shardSkillRank and caster.shardSkillRank >= 2 and ed.rand() > caster.shardSkill[2]["Script Arg1"] / 100 then
    skill.info = ed.wraptable(originfo, {
      ["Do Crit"] = "YES"
    })
  end
  local ret, dmg, Crit = basefunc(skill, target, source)
  skill.info = originfo
  if Crit and shard and shard._id == 1000101 and caster.shardSkillRank and caster.shardSkillRank >= 1 then
    local bid = Sniper.crit_shard
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, caster, caster)
    caster:addBuff(buff, caster)
  end
  return ret, dmg, Crit
end

function Sniper.skillatk3_takeEffectOn(basefunc, skill, target, source)
  local caster = skill.caster
  local ret, dmg, Crit = basefunc(skill, target, source)
  local shard = caster.proto._shard
  if Crit and shard and shard._id == 1000101 and caster.shardSkillRank and caster.shardSkillRank >= 1 then
    local bid = Sniper.crit_shard
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, caster, caster)
    caster:addBuff(buff, caster)
  end
  return ret, dmg, Crit
end

function Sniper.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.skillshardhvaecast = false
end

function Sniper.hero_update(basefunc, unit, dt)
  basefunc(unit, dt)
  local skillshard = unit.skills.Sniper_shard
  if skillshard and not unit.skillshardhvaecast then
    local max = -math.huge
    local caster = unit
    local chosen
    local caster_position = caster.position
    local enchanted = caster.buff_effects.enchanted
    local enchantedbyself = caster.buff_effects.enchantedbyself
    for u in ed.engine:foreachAliveUnit(-caster.camp) do
      if u.buff_effects.untargetable or u.buff_effects.invulnerable then
      elseif u.buffManager.invisible and u.camp ~= caster.camp then
      elseif enchanted and u == caster then
      elseif enchantedbyself and u == caster then
      elseif u.config.is_summoned then
      elseif u.buff_effects.building then
      else
        local distanceSQ = (u.position[1] - caster_position[1]) ^ 2 + (u.position[2] - caster_position[2]) ^ 2
        if distanceSQ >= skillshard.min_range_sq and distanceSQ <= skillshard.max_range_sq then
          local v = -distanceSQ
          if max < v then
            max = v
            chosen = u
          end
        end
      end
    end
    if chosen then
      skillshard.cd_remaining = 0
      unit.skillshardhvaecast = true
    end
  end
end

function Sniper.init_hero(hero)
  if hero.name == "Sniper" then
    hero.castManualSkill = override(hero.castManualSkill, Sniper.hero_castManualSkill)
  end
  local skillult = hero.skills.Sniper_ult
  local skillatk = hero.skills.Sniper_atk
  local skillatk2 = hero.skills.Sniper_atk2
  local skillatk3 = hero.skills.Sniper_atk3
  local skillshard = hero.skills.Sniper_shard
  local skillpasv = hero.passive_skill_list[1]
  local shard = hero.proto._shard
  if skillatk then
    skillatk.takeEffectOn = override(skillatk.takeEffectOn, Sniper.skillatk_takeEffectOn)
  end
  if skillult then
    skillult.start = override(skillult.start, Sniper.skillult_start)
    skillult.takeEffectOn = override(skillult.takeEffectOn, Sniper.skillult_takeEffectOn)
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
  end
  if skillatk2 then
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, Sniper.skillatk2_takeEffectOn)
    if skillatk2.evo_rank and 1 <= skillatk2.evo_rank then
      skillatk2.createBuff = override(skillatk2.createBuff, Sniper.skillatk2_createBuff)
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
  end
  if skillatk3 then
    skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, Sniper.skillatk3_takeEffectOn)
    skillatk3.createProjectile = override(skillatk3.createProjectile, Sniper.skillatk3_createProjectile)
    skillatk3.createBuff = override(skillatk3.createBuff, Sniper.skillatk3_createBuff)
    if Sniper.fashion_id_1 and Sniper.fashion_id_1 == hero.fashion_id then
      if skillatk3.evo_rank and skillatk3.evo_rank >= 3 then
        local originfo1 = skillatk3.info
        skillatk3.info = ed.wraptable(originfo1, {
          ["Plus Ratio"] = skillatk3.evo_rank3["Script Arg1"],
          ["Tile Art"] = "eff_tile_Sniper_atk3_fashion_1.cha"
        })
      elseif skillatk3.evo_rank and skillatk3.evo_rank >= 2 then
        local originfo1 = skillatk3.info
        skillatk3.info = ed.wraptable(originfo1, {
          ["Plus Ratio"] = skillatk3.evo_rank2["Script Arg1"],
          ["Tile Art"] = "eff_tile_Sniper_atk3_fashion_1.cha"
        })
      else
        local originfo1 = skillatk3.info
        skillatk3.info = ed.wraptable(originfo1, {
          ["Tile Art"] = "eff_tile_Sniper_atk3_fashion_1.cha"
        })
      end
    else
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
  end
  if skillpasv then
    local aname = skillpasv["Passive Attr"]
    if skillpasv.evo_rank and 1 <= skillpasv.evo_rank then
      skillpasv["Basic Num"] = skillpasv["Basic Num"] + skillpasv.evo_rank1["Script Arg1"]
    end
    if skillpasv.evo_rank and skillpasv.evo_rank >= 2 then
      skillpasv["Basic Num"] = skillpasv["Basic Num"] + skillpasv.evo_rank2["Script Arg1"]
    end
    if skillpasv.evo_rank and skillpasv.evo_rank >= 3 and skillatk then
      skillatk.info = ed.wraptable(skillatk.info, {
        CD = 1.5,
        ["Global CD"] = 1
      })
    end
    hero:rebuild()
  end
  if shard and shard._id == 1000101 and hero.shardSkillRank and 3 <= hero.shardSkillRank and skillshard then
    hero.update = override(hero.update, Sniper.hero_update)
    hero.reset = override(hero.reset, Sniper.hero_reset)
  end
  return hero
end

return Sniper.init_hero
