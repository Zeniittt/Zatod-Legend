module("ed.battlehero", package.seeall)
local ed = ed
WR = {}
WR.fashion_id_1 = 111
WR.hast = 200

function WR.getValue(arrow, target0, target1)
  local Sub = ed.edpSub
  local Dot = ed.edpDot
  local Normalize = ed.edpNormalize
  local LengthSQ = ed.edpLengthSQ
  local pos0 = target0.position
  local pos1 = target1.position
  local vector01 = Sub(pos1, pos0)
  local vdir = Normalize(arrow.velocity)
  local lengthSQ_vector01 = LengthSQ(vector01)
  local dot_vector01_vdir = Dot(vector01, vdir)
  local cos = dot_vector01_vdir / lengthSQ_vector01 ^ 0.5
  if cos < 0.994 then
    return -1
  end
  local factor = 10
  local value = factor * lengthSQ_vector01 - (factor - 1) * dot_vector01_vdir ^ 2
  return value
end

function WR.skillatk2_takeEffectOn(basefunc, skill, target, source)
  local caster = skill.caster
  local min = 9999999999
  local target1
  for unit in ed.engine:foreachAliveUnit(skill:targetCamp()) do
    if unit.buff_effects.untargetable then
    elseif unit.buffManager.invisible and unit.camp ~= caster.camp then
    elseif unit == target then
    else
      local value = WR.getValue(source, target, unit)
      if value < 0 or ed.edpDistanceSQ(target.position, unit.position) > 48400 then
      elseif min > value then
        min = value
        target1 = unit
      end
    end
  end
  if target1 then
    skill.double = true
    basefunc(skill, target, source)
    basefunc(skill, target1, source)
    local tempSkill = ed.wraptable(skill, {
      caster = target,
      target = target1,
      takeEffectOn = function()
      end,
      launchPoint = function()
        return target.position, 48
      end,
      ["Chain Jumps"] = 0
    })
    ed.ChainCreate(tempSkill)
  else
    skill.double = false
    basefunc(skill, target, source)
  end
end

function WR.skillatk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local buffInfo = buff.info
  local owner = buff.owner
  local caster = buff.caster
  local attribName = buffInfo.Tenacity
  local TEN_final = ed.Buff.getTenValue(buffInfo, owner, caster)
  if WR.fashion_id_1 and WR.fashion_id_1 == caster.fashion_id then
    buff:setAttribute("Effect", "eff_buff_WR_atk2_fashion_1.cha")
  end
  if not skill.double then
    if skill.evo_rank and skill.evo_rank >= 1 then
      buff.timer = skill.evo_rank1["Script Arg1"] * math.max(0.01, 1 - TEN_final / 100)
    else
      buff.timer = 0.6 * math.max(0.01, 1 - TEN_final / 100)
    end
  elseif skill.evo_rank and skill.evo_rank >= 3 then
    buff.timer = skill.evo_rank3["Script Arg1"] * math.max(0.01, 1 - TEN_final / 100)
  end
  return buff
end

function WR.skillatk3_createProjectile(basefunc, skill)
  local caster = skill.caster
  local shard = caster.proto._shard
  local origTarget = skill.target
  local counter = 0
  local maxcounter = caster.shardSkill[2]["Script Arg1"] + 1
  local projectile = basefunc(skill)
  projectile.dmgModifier = 1
  projectile:enableTrack(origTarget)
  ed.engine:addProjectile(projectile)
  local max = -math.huge
  local nexttarget
  for unit in ed.engine:foreachAliveUnit(skill:affectedCamp()) do
    if unit.buff_effects.untargetable then
    elseif unit.buffManager.invisible and unit.camp ~= skill.caster.camp then
    elseif unit == origTarget then
    else
      local v = ed.rand()
      if max < v then
        max = v
        nexttarget = unit
      end
    end
  end
  if nexttarget then
    local projectile = basefunc(skill)
    projectile:enableTrack(nexttarget)
    ed.engine:addProjectile(projectile)
  end
end

function WR.skillatk3_power(basefunc, skill, source, target, damage_type)
  local power, i = basefunc(skill, source, target, damage_type)
  local caster = skill.caster
  local info = skill.info
  if skill.evo_rank and skill.evo_rank >= 1 then
    local ap_multiplier = skill.evo_rank1["Script Arg1"]
    local ap_attrib = caster.attribs.AP or 0
    power = power + ap_multiplier * ap_attrib
  end
  return power, i
end

function WR.hero_reset(basefunc, hero)
  local skillatk2 = hero.skills.WR_atk2
  local skillatk = hero.skills.WR_atk
  local skillult = hero.skills.WR_ult
  if WR.fashion_id_1 and WR.fashion_id_1 == hero.fashion_id and skillatk then
    local originfo1 = skillatk.info
    skillatk.info = ed.wraptable(originfo1, {
      ["Tile Art"] = "eff_tile_WR_atk_fashion_1.cha"
    })
  end
  basefunc(hero)
end

function WR.hero_getLostHPAfterImmunity(basefunc, hero, damage, immunity)
  local shard = hero.proto._shard
  if shard and shard._id == 1000111 and hero.shardSkillRank and hero.shardSkillRank >= 3 then
    local p = hero.shardSkill[3]["Script Arg1"] / 100
    if p > ed.rand() then
      damage = 0
      if ed.run_with_scene then
        local effect_name = "eff_point_WR_shard.cha"
        local effect = ed.scene:playEffectOnScene(effect_name, hero.position, {
          hero.direction * 1,
          1
        }, nil, 1)
      end
    end
  end
  return basefunc(hero, damage, immunity)
end

function WR.init_hero(hero)
  local skillult = hero.skills.WR_ult
  local skillatk2 = hero.skills.WR_atk2
  local skillatk3 = hero.skills.WR_atk3
  local skillpasv = hero.passive_skill_list[1]
  local shard = hero.proto._shard
  if shard and shard._id == 1000111 and hero.shardSkillRank and hero.shardSkillRank >= 3 then
    hero.getLostHPAfterImmunity = override(hero.getLostHPAfterImmunity, WR.hero_getLostHPAfterImmunity)
  end
  if skillult then
    if WR.fashion_id_1 and WR.fashion_id_1 == hero.fashion_id then
      local plusratio = skillult.info["Plus Ratio"]
      skillult.info = ed.wraptable(skillult.info, {
        ["Plus Ratio"] = plusratio,
        ["Tile Art"] = "eff_tile_WR_ult_fashion_1.cha"
      })
    end
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
    if skillult.evo_rank and 3 <= skillult.evo_rank then
      skillult.info = ed.wraptable(skillult.info, {
        ["Plus Ratio"] = skillult.evo_rank3["Script Arg1"]
      })
    end
  end
  if skillatk2 then
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, WR.skillatk2_takeEffectOn)
    skillatk2.createBuff = override(skillatk2.createBuff, WR.skillatk2_createBuff)
    if WR.fashion_id_1 and WR.fashion_id_1 == hero.fashion_id then
      local plusratio = skillatk2.info["Plus Ratio"]
      skillatk2.info = ed.wraptable(skillatk2.info, {
        ["Plus Ratio"] = plusratio,
        ["Chain Effect"] = "eff_chain_WR_atk2_fashion_1.cha"
      })
    end
    if skillatk2.evo_rank and skillatk2.evo_rank >= 2 then
      skillatk2.info = ed.wraptable(skillatk2.info, {
        ["Plus Ratio"] = skillatk2.evo_rank2["Script Arg1"]
      })
    end
  end
  if skillatk3 then
    if WR.fashion_id_1 and WR.fashion_id_1 == hero.fashion_id then
      local plusratio = skillatk3.info["Plus Ratio"]
      skillatk3.info = ed.wraptable(skillatk3.info, {
        ["Plus Ratio"] = plusratio,
        ["Tile Art"] = "eff_tile_WR_atk_fashion_1.cha"
      })
    end
    if skillatk3.evo_rank and 1 <= skillatk3.evo_rank then
      skillatk3.power = override(skillatk3.power, WR.skillatk3_power)
    end
    if skillatk3.evo_rank and skillatk3.evo_rank >= 2 then
      skillatk3.info = ed.wraptable(skillatk3.info, {
        ["Plus Ratio"] = skillatk3.evo_rank2["Script Arg1"]
      })
    end
    if skillatk3.evo_rank and 3 <= skillatk3.evo_rank then
      skillatk3.info = ed.wraptable(skillatk3.info, {
        ["Plus Ratio"] = skillatk3.evo_rank3["Script Arg1"]
      })
    end
    if shard and shard._id == 1000111 and hero.shardSkillRank and 1 <= hero.shardSkillRank then
      skillatk3.info = ed.wraptable(skillatk3.info, {
        ["Damage Type"] = "AP"
      })
    end
    if shard and shard._id == 1000111 and hero.shardSkillRank and hero.shardSkillRank >= 2 then
      skillatk3.createProjectile = override(skillatk3.createProjectile, WR.skillatk3_createProjectile)
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
    if skillpasv.evo_rank and 3 <= skillpasv.evo_rank then
      skillpasv["Basic Num"] = skillpasv["Basic Num"] + skillpasv.evo_rank3["Script Arg1"]
    end
    hero:rebuild()
  end
  hero.reset = override(hero.reset, WR.hero_reset)
  return hero
end

return WR.init_hero
