module("ed.battlehero", package.seeall)
local ed = ed
CW = {}
CW.cwBuffAwakeID = 414
CW.skillFashionId = 501

function CW.skillatk3_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  caster.position[1] = 400 - 450 * caster:getInitDir()
  caster.walk_v = {
    250 * caster:getInitDir(),
    0
  }
end

function CW.skillatk3_onAttackFrame(basefunc, skill)
  skill.caster.walk_v = {0, 0}
  skill.attack_counter = skill.attack_counter + 1
  if skill.attack_counter == 2 then
    basefunc(skill)
  end
end

function CW.skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local owner = buff.owner
  local fashionId = caster.fashion_id
  local shard = caster.proto._shard
  local ShieldIncrease = 0
  local ShieldWeak = 0
  if owner.attribs.ShieldIncrease then
    ShieldIncrease = owner.attribs.ShieldIncrease
  end
  if owner.attribs.ShieldWeak then
    ShieldWeak = owner.attribs.ShieldWeak
  end
  local shieldratio = math.max(0.01, 1 + (ShieldIncrease - ShieldWeak) / 100)
  if skill.evo_rank and 1 <= skill.evo_rank then
    buff.shield = buff.shield + skill.evo_rank1["Script Arg1"] * (caster.config.hp_mod or 1) * shieldratio
  end
  if skill.evo_rank and skill.evo_rank >= 2 then
    buff.shield = buff.shield + skill.evo_rank2["Script Arg1"] * (caster.config.hp_mod or 1) * shieldratio
  end
  if skill.evo_rank and skill.evo_rank >= 3 then
    buff.shield = buff.shield + skill.evo_rank3["Script Arg1"] * (caster.config.hp_mod or 1) * shieldratio
  end
  if shard and shard._id == 1000501 then
    if caster.shardSkillRank and 1 <= caster.shardSkillRank then
      buff.timer = caster.shardSkill[1]["Script Arg1"]
    end
    if caster.shardSkillRank and 2 <= caster.shardSkillRank then
      buff.shield = buff.shield + caster.shardSkill[2]["Script Arg1"] / 100 * caster.attribs.HP * (caster.config.hp_mod or 1) * shieldratio
    end
  end
  if fashionId and fashionId == CW.skillFashionId then
    buff.impactEffect = "eff_buff_CW_atk3_impact_skin.cha"
    buff:setAttribute("Effect", "eff_buff_CW_atk3_skin.cha")
  end
  return buff
end

function CW.skillult_power(basefunc, skill, source, target, damage_type)
  local power, i = basefunc(skill, source, target, damage_type)
  local caster = skill.caster
  local cwmaxhp = caster.attribs.HP
  if target and target:isAlive() and power then
    local dmgratio = cwmaxhp * (skill.evo_rank3["Script Arg1"] / 100)
    power = power + math.min(dmgratio, skill.evo_rank3["Script Arg2"])
  end
  return power, i
end

function CW.skillatk2_createBuff(basefunc, skill, target)
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

function CW.hero_takeDamage(basefunc, self, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
  local lost, bCrit = basefunc(self, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
  local dt = damage_type or struct_table.damage_type
  local s = source or struct_table.source
  local skill
  if type(struct_table) == "table" then
    skill = struct_table.skill
  end
  if lost and 0 < lost and s and s:isAlive() and skill and skill == s.basic_skill then
    s:takeDamage(self.shardSkill[3]["Script Arg2"] * self.attribs.STR, "AD", "hp", self, 1, 1, true)
  end
  return lost, bCrit
end

function CW.init_hero(hero)
  local skillult = hero.skills.CW_ult
  local skillatk2 = hero.skills.CW_atk2
  local skillatk3 = hero.skills.CW_atk3
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
      skillult.power = override(skillult.power, CW.skillult_power)
    end
  end
  if skillatk2 then
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
    skillatk2.createBuff = override(skillatk2.createBuff, CW.skillatk2_createBuff)
  end
  if skillatk3 then
    skillatk3.start = override(skillatk3.start, CW.skillatk3_start)
    skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, CW.skillatk3_onAttackFrame)
    skillatk3.createBuff = override(skillatk3.createBuff, CW.skillatk3_createBuff)
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
    if shard and shard._id == 1000501 and hero.shardSkillRank and 3 <= hero.shardSkillRank then
      skillpasv["Basic Num"] = skillpasv["Basic Num"] + hero.shardSkill[3]["Script Arg1"] / 100 * hero.attribs.STR
      hero.takeDamage = override(hero.takeDamage, CW.hero_takeDamage)
    end
    hero:rebuild()
  end
  return hero
end

return CW.init_hero
