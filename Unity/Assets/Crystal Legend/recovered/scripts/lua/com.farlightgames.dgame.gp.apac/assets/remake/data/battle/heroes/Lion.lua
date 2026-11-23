module("ed.battlehero", package.seeall)
local ed = ed
Lion = {}

function Lion.skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local timer = buff.timer
  local buffInfo = buff.info
  local owner = buff.owner
  local caster = buff.caster
  local attribName = buffInfo.Tenacity
  local TEN_final = ed.Buff.getTenValue(buffInfo, owner, caster)
  if skill.evo_rank and skill.evo_rank >= 1 then
    buff.timer = timer + skill.evo_rank1["Script Arg1"] * math.max(0.01, 1 - TEN_final / 100)
  end
  if skill.evo_rank and skill.evo_rank >= 2 then
    buff.timer = timer + (skill.evo_rank1["Script Arg1"] + skill.evo_rank2["Script Arg1"]) * math.max(0.01, 1 - TEN_final / 100)
    target:takeDamage(skill.evo_rank2["Script Arg2"], "Holy", "mp", caster)
    caster:takeHeal(skill.evo_rank2["Script Arg2"], "mp", caster)
  end
  if skill.evo_rank and skill.evo_rank >= 3 then
    buff:setAttribute("MIMU", -skill.evo_rank3["Script Arg1"])
    buff:setAttribute("PIMU", -skill.evo_rank3["Script Arg1"])
  end
  return buff
end

function Lion.skillatk2_getDamage(basefunc, self, target, power, damage_type, field, source, crit_mod)
  if target.config.is_summoned then
    power = power * self.caster.shardSkill[1]["Script Arg1"]
  end
  local dmg = target:takeDamage({
    amount = power,
    damage_type = damage_type,
    field = field,
    source = source,
    crit_mod = crit_mod,
    skill = self
  })
  return dmg
end

function Lion.skillatk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local buffInfo = buff.info
  local owner = buff.owner
  local caster = buff.caster
  local attribName = buffInfo.Tenacity
  local TEN_final = ed.Buff.getTenValue(buffInfo, owner, caster)
  if skill.evo_rank and skill.evo_rank >= 2 then
    buff.timer = skill.evo_rank2["Script Arg1"] * math.max(0.01, 1 - TEN_final / 100)
  end
  if skill.evo_rank and skill.evo_rank >= 3 then
    buff.timer = skill.evo_rank3["Script Arg1"] * math.max(0.01, 1 - TEN_final / 100)
  end
  return buff
end

function Lion.init_hero(hero)
  local skillult = hero.skills.Lion_ult
  local skillatk2 = hero.skills.Lion_atk2
  local skillatk3 = hero.skills.Lion_atk3
  local skillpasv = hero.passive_skill_list[1]
  local shard = hero.proto._shard
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
    if skillult.evo_rank and skillult.evo_rank >= 3 then
      skillult.info = ed.wraptable(skillult.info, {
        ["Plus Ratio"] = skillult.evo_rank3["Script Arg1"]
      })
    end
    if shard and shard._id == 1000061 and hero.shardSkillRank and 2 <= hero.shardSkillRank then
      skillult.info = ed.wraptable(skillult.info, {
        ["Chain Jumps"] = hero.shardSkill[2]["Script Arg1"] + 1
      })
    end
  end
  if skillatk2 then
    hero:preloadEffect("eff_launch_spike.cha")
    if shard and shard._id == 1000061 and hero.shardSkillRank and 1 <= hero.shardSkillRank then
      skillatk2.getDamage = override(skillatk2.getDamage, Lion.skillatk2_getDamage)
    end
    skillatk2.createBuff = override(skillatk2.createBuff, Lion.skillatk2_createBuff)
    if skillatk2.evo_rank and 1 <= skillatk2.evo_rank then
      skillatk2.info = ed.wraptable(skillatk2.info, {
        ["Plus Ratio"] = skillatk2.evo_rank1["Script Arg1"]
      })
    end
  end
  if skillatk3 then
    skillatk3.createBuff = override(skillatk3.createBuff, Lion.skillatk3_createBuff)
    if shard and shard._id == 1000061 and hero.shardSkillRank and 3 <= hero.shardSkillRank then
      skillatk3.info = ed.wraptable(skillatk3.info, {
        ["AOE Origin"] = "target",
        ["AOE Shape"] = "circle",
        ["Shape Arg1"] = hero.shardSkill[3]["Script Arg1"]
      })
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
    if skillpasv.evo_rank and skillpasv.evo_rank >= 3 then
      skillpasv["Basic Num"] = skillpasv["Basic Num"] + skillpasv.evo_rank3["Script Arg1"]
    end
    hero:rebuild()
  end
  return hero
end

return Lion.init_hero
