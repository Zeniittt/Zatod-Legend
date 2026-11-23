module("ed.battlehero", package.seeall)
local ed = ed
Lina = {}
Lina.atk2Evobuff = 10000301
Lina.shard_1_shield = 10000303
Lina.shard_2 = 10000304

function Lina.skillult_takeEffectOn(basefunc, skill, target, source)
  local ishit, damage = basefunc(skill, target, source)
  local caster = skill.caster
  local shard = caster.proto._shard
  if ishit and 0 < damage and shard and shard._id == 1000031 and caster.shardSkillRank and caster.shardSkillRank >= 1 then
    local ShieldIncrease = 0
    local ShieldWeak = 0
    if caster.attribs.ShieldIncrease then
      ShieldIncrease = caster.attribs.ShieldIncrease
    end
    if caster.attribs.ShieldWeak then
      ShieldWeak = caster.attribs.ShieldWeak
    end
    local shieldratio = math.max(0.01, 1 + (ShieldIncrease - ShieldWeak) / 100)
    local shieldnum = caster.shardSkill[1]["Script Arg1"] / 100 * damage * shieldratio * (caster.config.hp_mod or 1)
    local shard_1_shield = false
    for i, tbuff in ipairs(caster.buff_list) do
      if tbuff.info.ID == Lina.shard_1_shield then
        tbuff.shield = tbuff.shield + shieldnum
        shard_1_shield = true
      end
    end
    if not shard_1_shield then
      local buffid = Lina.shard_1_shield
      local buffinfo = ed.lookupDataTable("Buff", nil, buffid)
      local buff = ed.BuffCreate(buffinfo, caster, caster)
      buff.shield = shieldnum
      caster:addBuff(buff, caster)
    end
  end
  return ishit, damage
end

function Lina.skillatk2_takeEffectOn(basefunc, skill, target, source)
  local ishit, damage = basefunc(skill, target, source)
  local caster = skill.caster
  if ishit and skill.evo_rank and skill.evo_rank >= 2 then
    local bid = Lina.atk2Evobuff
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, target, caster)
    target:addBuff(buff, caster)
  end
  local shard = caster.proto._shard
  if ishit and 0 < damage and shard and shard._id == 1000031 and caster.shardSkillRank and caster.shardSkillRank >= 1 then
    local ShieldIncrease = 0
    local ShieldWeak = 0
    if caster.attribs.ShieldIncrease then
      ShieldIncrease = caster.attribs.ShieldIncrease
    end
    if caster.attribs.ShieldWeak then
      ShieldWeak = caster.attribs.ShieldWeak
    end
    local shieldratio = math.max(0.01, 1 + (ShieldIncrease - ShieldWeak) / 100)
    local shieldnum = caster.shardSkill[1]["Script Arg1"] / 100 * damage * shieldratio * (caster.config.hp_mod or 1)
    local shard_1_shield = false
    for i, tbuff in ipairs(caster.buff_list) do
      if tbuff.info.ID == Lina.shard_1_shield then
        tbuff.shield = tbuff.shield + shieldnum
        shard_1_shield = true
      end
    end
    if not shard_1_shield then
      local buffid = Lina.shard_1_shield
      local buffinfo = ed.lookupDataTable("Buff", nil, buffid)
      local buff = ed.BuffCreate(buffinfo, caster, caster)
      buff.shield = shieldnum
      caster:addBuff(buff, caster)
    end
  end
  return ishit, damage
end

function Lina.skillatk3_createBuff(basefunc, skill, target)
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

function Lina.skillatk3_takeEffectOn(basefunc, skill, target, source)
  local ishit, damage = basefunc(skill, target, source)
  local caster = skill.caster
  local shard = caster.proto._shard
  if ishit and 0 < damage and shard and shard._id == 1000031 and caster.shardSkillRank and caster.shardSkillRank >= 1 then
    local ShieldIncrease = 0
    local ShieldWeak = 0
    if caster.attribs.ShieldIncrease then
      ShieldIncrease = caster.attribs.ShieldIncrease
    end
    if caster.attribs.ShieldWeak then
      ShieldWeak = caster.attribs.ShieldWeak
    end
    local shieldratio = math.max(0.01, 1 + (ShieldIncrease - ShieldWeak) / 100)
    local shieldnum = caster.shardSkill[1]["Script Arg1"] / 100 * damage * shieldratio * (caster.config.hp_mod or 1)
    local shard_1_shield = false
    for i, tbuff in ipairs(caster.buff_list) do
      if tbuff.info.ID == Lina.shard_1_shield then
        tbuff.shield = tbuff.shield + shieldnum
        shard_1_shield = true
      end
    end
    if not shard_1_shield then
      local buffid = Lina.shard_1_shield
      local buffinfo = ed.lookupDataTable("Buff", nil, buffid)
      local buff = ed.BuffCreate(buffinfo, caster, caster)
      buff.shield = shieldnum
      caster:addBuff(buff, caster)
    end
  end
  return ishit, damage
end

function Lina.skillatk_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local skillatk4 = caster.skills.Lina_atk4
  if skillatk4 then
    local mp = skillatk4.info["Script Arg2"]
    if skillatk4.evo_rank and skillatk4.evo_rank >= 1 then
      mp = mp + skillatk4.evo_rank1["Script Arg1"]
    end
    if skillatk4.evo_rank and skillatk4.evo_rank >= 2 then
      mp = mp + skillatk4.evo_rank2["Script Arg1"]
    end
    if skillatk4.evo_rank and skillatk4.evo_rank >= 3 then
      mp = mp + skillatk4.evo_rank3["Script Arg1"]
    end
    caster:takeHeal(mp, "mp")
  end
end

function Lina.skill_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local shard = caster.proto._shard
  if shard and shard._id == 1000031 and caster.shardSkillRank and caster.shardSkillRank >= 3 then
    local skillatk = caster.skills.Lina_atk
    local skillult = caster.skills.Lina_ult
    local skillatk2 = caster.skills.Lina_atk2
    local skillatk3 = caster.skills.Lina_atk3
    skillatk2.info = ed.wraptable(skillatk2.info, {CD = 12})
    skillatk3.info = ed.wraptable(skillatk3.info, {CD = 12})
    local buffrank
    for i, tbuff in ipairs(caster.buff_list) do
      if tbuff.info.ID == Lina.shard_2 then
        buffrank = tbuff.rank
      end
    end
    if not buffrank or buffrank < 5 then
      local bid = Lina.shard_2
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, caster, caster)
      caster:addBuff(buff, caster)
      local shardrank = buffrank and buffrank + 1 or 1
      skillatk.info = ed.wraptable(skillatk.info, {
        CD = 2.5 - 0.5 * (shardrank or 1),
        ["Global CD"] = 2.5 - 0.5 * (shardrank or 1)
      })
      skillult.info = ed.wraptable(skillult.info, {
        ["Global CD"] = 2.5 - 0.5 * (shardrank or 1)
      })
      skillatk2.info = ed.wraptable(skillatk2.info, {
        ["Global CD"] = 2.5 - 0.5 * (shardrank or 1)
      })
      skillatk3.info = ed.wraptable(skillatk3.info, {
        ["Global CD"] = 2.5 - 0.5 * (shardrank or 1)
      })
    end
  end
end

function Lina.init_hero(hero)
  local skillatk = hero.skills.Lina_atk
  local skillult = hero.skills.Lina_ult
  local skillatk2 = hero.skills.Lina_atk2
  local skillatk3 = hero.skills.Lina_atk3
  local skillatk4 = hero.skills.Lina_atk4
  local shard = hero.proto._shard
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
    skillult.takeEffectOn = override(skillult.takeEffectOn, Lina.skillult_takeEffectOn)
    skillult.finish = override(skillult.finish, Lina.skill_finish)
  end
  if skillatk2 then
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, Lina.skillatk2_takeEffectOn)
    skillatk2.finish = override(skillatk2.finish, Lina.skill_finish)
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
    if shard and shard._id == 1000031 and hero.shardSkillRank and 3 <= hero.shardSkillRank then
      skillatk2.info = ed.wraptable(skillatk2.info, {CD = 12})
    end
  end
  if skillatk3 then
    skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, Lina.skillatk3_takeEffectOn)
    skillatk3.finish = override(skillatk3.finish, Lina.skill_finish)
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
      skillatk3.createBuff = override(skillatk3.createBuff, Lina.skillatk3_createBuff)
    end
    if shard and shard._id == 1000031 and hero.shardSkillRank and 3 <= hero.shardSkillRank then
      skillatk3.info = ed.wraptable(skillatk3.info, {CD = 12})
    end
  end
  if skillatk then
    skillatk.onAttackFrame = override(skillatk.onAttackFrame, Lina.skillatk_onAttackFrame)
    local shard = hero.proto._shard
    if shard and shard._id == 1000031 and hero.shardSkillRank and 2 <= hero.shardSkillRank then
      skillatk.info = ed.wraptable(skillatk.info, {
        ["Damage Type"] = "AP",
        ["Plus Attr"] = "AP",
        ["Plus Ratio"] = hero.shardSkill[2]["Script Arg1"]
      })
    end
  end
  return hero
end

return Lina.init_hero
