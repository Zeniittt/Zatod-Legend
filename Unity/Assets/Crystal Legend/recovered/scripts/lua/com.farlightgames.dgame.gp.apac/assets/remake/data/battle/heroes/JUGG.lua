module("ed.battlehero", package.seeall)
local ed = ed
JUGG = {}
JUGG.ult = 10002701
JUGG.atk2 = 10002702
JUGG.Evobuff = 10002704
JUGG.fashion_id_2 = 272
JUGG.fashion_id_4 = 274

function JUGG.skillult_start(basefunc, skill, target)
  local caster = skill.caster
  local bid = JUGG.ult
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
  caster.JUGGUltPosition = {
    caster.position[1],
    caster.position[2],
    0
  }
  basefunc(skill, target)
end

function JUGG.skillult_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  if skill.attack_counter == 6 and caster.JUGGUltPosition then
    caster.position = {
      caster.JUGGUltPosition[1],
      caster.JUGGUltPosition[2],
      0
    }
  end
end

function JUGG.skillult_takeEffectOn(basefunc, skill, target)
  local caster = skill.caster
  local target = target
  caster.position = {
    target.position[1],
    target.position[2] - 1
  }
  local isHit, dmg = basefunc(skill, target)
  local skillatk = caster.skills.JUGG_atk
  if isHit and skill.evo_rank and skill.evo_rank >= 3 then
    local rand = skill.evo_rank3["Script Arg1"] / 100
    if rand > ed.rand() then
      skillatk:takeEffectOn(target)
    end
  end
  return isHit, dmg
end

function JUGG.skillult_finish(basefunc, skill)
  basefunc(skill)
  for i, tbuff in ipairs(skill.caster.buff_list) do
    if tbuff.info.ID == JUGG.ult then
      local buff = tbuff
      buff.timer = -1
    end
  end
end

function JUGG.skillatk2_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local target = skill.target
  local v = 180
  local bid = JUGG.atk2
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
  if target.position[1] - caster.position[1] <= 0 then
    caster.direction = -1
  else
    caster.direction = 1
  end
  caster.walk_v = {
    caster.direction * v,
    0
  }
end

function JUGG.skillatk2_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local skill = skill
  local caster = skill.caster
  if skill.attack_counter and skill.attack_counter == 4 then
    local v = -caster.walk_v[1]
    caster.walk_v = {v, 0}
  elseif skill.attack_counter and skill.attack_counter == 8 then
    caster.walk_v = {0, 0}
  end
end

function JUGG.skillatk2_finish(basefunc, skill)
  local caster = skill.caster
  caster.walk_v = {0, 0}
  caster.direction = skill.caster.direction * -1
  basefunc(skill)
  local shard = caster.proto._shard
  for i, tbuff in ipairs(skill.caster.buff_list) do
    if tbuff.info.ID == JUGG.atk2 then
      local buff = tbuff
      if shard and shard._id == 1000271 then
        if caster.shardSkillRank and caster.shardSkillRank >= 1 then
          buff.timer = caster.shardSkill[1]["Script Arg2"]
        else
          buff.timer = -1
        end
      else
        buff.timer = -1
      end
    end
  end
end

function JUGG.skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local owner = target
  local hpr = buff.info.HPR
  if skill.evo_rank and skill.evo_rank >= 1 then
    hpr = hpr + skill.evo_rank1["Script Arg1"] * (1 + caster.attribs.HEAL / 100)
  end
  if skill.evo_rank and skill.evo_rank >= 2 then
    hpr = hpr + skill.evo_rank2["Script Arg1"] * (1 + caster.attribs.HEAL / 100)
  end
  if skill.evo_rank and skill.evo_rank >= 3 then
    hpr = hpr + skill.evo_rank3["Script Arg1"] * (1 + caster.attribs.HEAL / 100)
  end
  local shard = caster.proto._shard
  if shard and shard._id == 1000271 and caster.shardSkillRank and 2 <= caster.shardSkillRank then
    hpr = hpr + caster.shardSkill[2]["Script Arg1"] / 100 * owner.attribs.HP * (1 + caster.attribs.HEAL / 100)
  end
  buff:setAttribute("HPR", hpr)
  return buff
end

function JUGG.init_hero(hero)
  local skillult = hero.skills.JUGG_ult
  local skillatk2 = hero.skills.JUGG_atk2
  local skillatk3 = hero.skills.JUGG_atk3
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
    skillult.onAttackFrame = override(skillult.onAttackFrame, JUGG.skillult_onAttackFrame)
    skillult.start = override(skillult.start, JUGG.skillult_start)
    skillult.finish = override(skillult.finish, JUGG.skillult_finish)
    skillult.takeEffectOn = override(skillult.takeEffectOn, JUGG.skillult_takeEffectOn)
    if shard and shard._id == 1000271 and hero.shardSkillRank and hero.shardSkillRank >= 3 then
      skillult.info = ed.wraptable(skillult.info, {
        ["AOE Origin"] = "target",
        ["AOE Shape"] = "circle",
        ["Shape Arg1"] = 80
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
        CD = skillatk2.evo_rank3["Script Arg1"]
      })
    end
    skillatk2.start = override(skillatk2.start, JUGG.skillatk2_start)
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, JUGG.skillatk2_onAttackFrame)
    skillatk2.finish = override(skillatk2.finish, JUGG.skillatk2_finish)
  end
  if skillatk3 then
    skillatk3.createBuff = override(skillatk3.createBuff, JUGG.skillatk3_createBuff)
    if JUGG.fashion_id_2 and JUGG.fashion_id_2 == hero.fashion_id then
      skillatk3.info = ed.wraptable(skillatk3.info, {
        ["Point Effect"] = "eff_point_JUGG_atk3_fashion_1.cha"
      })
    end
    if JUGG.fashion_id_4 and JUGG.fashion_id_4 == hero.fashion_id then
      skillatk3.info = ed.wraptable(skillatk3.info, {
        ["Point Effect"] = "eff_point_JUGG_fashion_4_atk3.cha"
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
    if shard and shard._id == 1000271 and hero.shardSkillRank and 1 <= hero.shardSkillRank then
      skillpasv["Basic Num"] = skillpasv["Basic Num"] + hero.shardSkill[1]["Script Arg1"] / 100 * hero.attribs.AGI
    end
    hero:rebuild()
  end
  return hero
end

return JUGG.init_hero
