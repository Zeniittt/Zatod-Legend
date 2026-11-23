module("ed.battlehero", package.seeall)
local ed = ed
AM = {}
AM.skillminSQ = 14400
AM.Evobuff = 10004601
AM.atk2 = 10004602
AM.Fashion_ID_1 = 461

function AM.skillatk2_start(basefunc, skill, target)
  local info = skill.info
  skill.target = target
  skill:selectTarget(target)
  skill.cd_remaining = info.CD
  skill.casting = true
  skill.attack_counter = 0
  local caster = skill.caster
  local distanceSQ
  if skill.target then
    distanceSQ = (skill.target.position[1] - caster.position[1]) ^ 2 + (skill.target.position[2] - skill.target.position[2]) ^ 2
  end
  if distanceSQ and distanceSQ > AM.skillminSQ then
    skill:startPhase(1)
    local bid = AM.atk2
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local caster = skill.caster
    caster:addBuff(binfo, caster)
  else
    skill:startPhase(2)
  end
  caster.global_cd = info["Global CD"]
  if ed.run_with_scene then
    local effect_name = info["Launch Effect"]
    if effect_name then
      caster.actor:addEffect(effect_name, -1)
    end
  end
end

function AM.skillatk2_finish(basefunc, skill)
  basefunc(skill)
end

function AM.skillatk2_takeEffectAt(basefunc, skill, location, source)
  local caster = skill.caster
  if skill.current_phase_idx == 1 then
    skill.caster.position = {
      skill.target.position[1] - skill.caster.direction * 70,
      skill.target.position[2]
    }
  else
    basefunc(skill, location, source)
    local skillevo = caster.skills.AM_evo
    if skillevo and skill.evo_rank and 2 <= skill.evo_rank then
      for i, buff in ipairs(caster.buff_list) do
        if buff.info.ID == AM.Evobuff then
          buff.timer = 0
        end
      end
      skillevo:takeEffectOn(caster, caster)
    end
  end
end

function AM.skillatk2_onPhaseFinished(basefunc, skill)
  local caster = skill.caster
  local current_phase_idx = skill.current_phase_idx
  if current_phase_idx == 1 then
    for i, tbuff in ipairs(skill.caster.buff_list) do
      if tbuff.info.ID == AM.atk2 then
        local buff = tbuff
        buff.timer = -1
      end
    end
  end
  basefunc(skill)
end

function AM.skillatk2_takeEffectOn(basefunc, skill, target, source)
  local mppower = skill.info["Script Arg2"]
  local ret, dmg = basefunc(skill, target, source)
  local caster = skill.caster
  local shard = caster.proto._shard
  if skill.evo_rank and skill.evo_rank >= 3 then
    mppower = mppower + skill.evo_rank3["Script Arg2"]
  end
  if ret then
    target:takeDamage(mppower, "Holy", "mp", skill.caster)
    if shard and shard._id == 1000461 and caster.shardSkillRank and 3 <= caster.shardSkillRank and not target.buff_effects.invulnerable and not target.buff_effects.uncontrollable then
      local bid = 10004604
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, target, caster)
      target:addBuff(buff, caster)
    end
  end
  return ret, dmg
end

function AM.skillevo_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local skillatk2 = caster.skills.AM_atk2
  local ShieldIncrease = 0
  local ShieldWeak = 0
  if caster.attribs.ShieldIncrease then
    ShieldIncrease = caster.attribs.ShieldIncrease
  end
  if caster.attribs.ShieldWeak then
    ShieldWeak = caster.attribs.ShieldWeak
  end
  local shieldratio = math.max(0.01, 1 + (ShieldIncrease - ShieldWeak) / 100)
  buff.shield = (skillatk2.evo_rank2["Script Arg1"] + skillatk2.evo_rank2["Script Arg2"] * caster.attribs.AD) * (caster.config.hp_mod or 1) * shieldratio
  return buff
end

function AM.skillult_takeEffectAt(basefunc, skill, location, source)
  local caster = skill.caster
  if skill.attack_counter == 1 then
    if skill.target then
      local position1 = skill.target.position[1] + caster.direction * 70
      if skill.target.buff_effects.stable or 799 < position1 or position1 < 1 then
        position1 = position1 - caster.direction * 140
      end
      caster:setPosition({
        position1,
        skill.target.position[2]
      })
    end
  else
    basefunc(skill, location, source)
  end
end

function AM.skillult_takeEffectOn(basefunc, skill, target, source)
  local ret, dmg = basefunc(skill, target, source)
  local caster = skill.caster
  if ret then
    local bid = 10004603
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, target, caster)
    target:addBuff(buff, caster)
  end
  return ret, dmg
end

function AM.skillult_power(basefunc, skill, source, target, damage_type)
  local power, coeff = basefunc(skill, source, target)
  local caster = skill.caster
  local info = skill.info
  local ultpowerratio = (target.attribs.MP - target.mp) / target.attribs.MP
  power = power * (1 + ultpowerratio)
  return power, coeff
end

function AM.init_hero(hero)
  local skillult = hero.skills.AM_ult
  local skillatk = hero.skills.AM_atk
  local skillatk2 = hero.skills.AM_atk2
  local skillevo = hero.skills.AM_evo
  local count1, count2, count3
  for i, skillinfo in ipairs(hero.passive_skill_list) do
    if skillinfo["Skill Name"] == "AM_pasv" then
      count1 = i
    end
  end
  for i, skillinfo in ipairs(hero.passive_skill_list) do
    if skillinfo["Skill Name"] == "AM_pasv2" then
      count2 = i
    end
  end
  for i, skillinfo in ipairs(hero.passive_skill_list) do
    if skillinfo["Skill Name"] == "AM_shard" then
      count3 = i
    end
  end
  local skillpasv = hero.passive_skill_list[count1]
  local skillpasv2 = hero.passive_skill_list[count2]
  local skillshard = hero.passive_skill_list[count3]
  local shard = hero.proto._shard
  if skillult then
    if skillult.evo_rank and skillult.evo_rank >= 1 then
      skillult.power = override(skillult.power, AM.skillult_power)
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
    if AM.Fashion_ID_1 and AM.Fashion_ID_1 == hero.fashion_id then
      skillult.info = ed.wraptable(skillult.info, {
        ["Impact Effect"] = "eff_impact_AM_fashion_1_ult.cha",
        ["Point Effect"] = "eff_point_AM_fashion_1_ult.cha"
      })
    end
    skillult.takeEffectAt = override(skillult.takeEffectAt, AM.skillult_takeEffectAt)
    if shard and shard._id == 1000461 and hero.shardSkillRank and 1 <= hero.shardSkillRank then
      skillult.takeEffectOn = override(skillult.takeEffectOn, AM.skillult_takeEffectOn)
    end
  end
  if skillatk2 then
    if skillatk2.evo_rank and skillatk2.evo_rank >= 1 then
      skillatk2.info = ed.wraptable(skillatk2.info, {
        ["Plus Ratio"] = skillatk2.evo_rank1["Script Arg1"]
      })
    end
    if skillatk2.evo_rank and skillatk2.evo_rank >= 3 then
      skillatk2.info = ed.wraptable(skillatk2.info, {
        ["Plus Ratio"] = skillatk2.evo_rank3["Script Arg1"]
      })
    end
    if AM.Fashion_ID_1 and AM.Fashion_ID_1 == hero.fashion_id then
      skillatk2.info = ed.wraptable(skillatk2.info, {
        ["Impact Effect"] = "eff_impact_AM_fashion_1_atk2.cha"
      })
    end
    skillatk2.start = override(skillatk2.start, AM.skillatk2_start)
    skillatk2.finish = override(skillatk2.finish, AM.skillatk2_finish)
    skillatk2.takeEffectAt = override(skillatk2.takeEffectAt, AM.skillatk2_takeEffectAt)
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, AM.skillatk2_takeEffectOn)
    skillatk2.onPhaseFinished = override(skillatk2.onPhaseFinished, AM.skillatk2_onPhaseFinished)
  end
  if skillevo then
    skillevo.createBuff = override(skillevo.createBuff, AM.skillevo_createBuff)
  end
  if skillpasv then
    local aname = skillpasv["Passive Attr"]
    if skillpasv.evo_rank and skillpasv.evo_rank >= 1 then
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
  if skillpasv2 then
    local aname = skillpasv2["Passive Attr"]
    if skillpasv2.evo_rank and skillpasv2.evo_rank >= 1 then
      skillpasv2["Basic Num"] = skillpasv2["Basic Num"] + skillpasv2.evo_rank1["Script Arg1"]
    end
    if skillpasv2.evo_rank and skillpasv2.evo_rank >= 2 then
      skillpasv2["Basic Num"] = skillpasv2["Basic Num"] + skillpasv2.evo_rank2["Script Arg1"]
    end
    if skillpasv2.evo_rank and skillpasv2.evo_rank >= 3 then
      skillpasv2["Basic Num"] = skillpasv2["Basic Num"] + skillpasv2.evo_rank3["Script Arg1"]
    end
    hero:rebuild()
  end
  if skillshard then
    local num = skillshard["Basic Num"]
    local shard = hero.proto._shard
    if shard and shard._id == 1000461 and hero.shardSkillRank and 2 <= hero.shardSkillRank then
      skillshard["Basic Num"] = skillshard["Basic Num"] + hero.shardSkill[2]["Script Arg1"]
    end
  end
  return hero
end

return AM.init_hero
