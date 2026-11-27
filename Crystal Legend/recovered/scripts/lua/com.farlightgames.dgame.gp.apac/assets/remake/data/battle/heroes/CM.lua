module("ed.battlehero", package.seeall)
local ed = ed
CM = {}
CM.slow_trigger = 2
CM.frozen_trigger = 4
CM.slow_bid = 1069
CM.skillFashionId = 121
CM.awake_fashionBuffId = 4073
CM.skillFashionIdLOA = 421
CM.ultEvobuff = 10001203
CM.fashion_id_2 = 122
CM.shard = 10001204

function CM.skillult_takeEffectOn(basefunc, skill, target, source)
  local ishit, damage = basefunc(skill, target, source)
  if ishit and skill.evo_rank and skill.evo_rank >= 1 and skill.attack_counter == 3 then
    local caster = skill.caster
    local bid = CM.ultEvobuff
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, target, caster)
    if CM.fashion_id_2 and CM.fashion_id_2 == caster.fashion_id then
      buff:setAttribute("Effect", "eff_buff_CM_atk2_fashion_2.cha")
    end
    target:addBuff(buff, caster)
  end
  return ishit, damage
end

function CM.skillatk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local buffInfo = buff.info
  local owner = buff.owner
  local caster = buff.caster
  local attribName = buffInfo.Tenacity
  local TEN_final = ed.Buff.getTenValue(buffInfo, owner, caster)
  if CM.fashion_id_2 and CM.fashion_id_2 == caster.fashion_id then
    buff:setAttribute("Effect", "eff_buff_CM_atk2_fashion_2.cha")
  end
  if skill.evo_rank and skill.evo_rank >= 3 then
    buff.timer = skill.evo_rank3["Script Arg1"] * math.max(0.01, 1 - TEN_final / 100)
  end
  return buff
end

function CM.skillatk2_finish(basefunc, skill)
  basefunc(skill)
  local hero = skill.caster
  local shard = hero.proto._shard
  if shard and shard._id == 1000121 and hero.shardSkillRank and hero.shardSkillRank >= 3 then
    for unit in ed.engine:foreachAliveUnit(hero.camp) do
      if unit.info["Unit Type"] == "Hero" and unit ~= hero then
        unit:takeHeal(hero.shardSkill[3]["Script Arg1"], "mp", hero)
      end
    end
  end
end

function CM.skillatk3_finish(basefunc, skill)
  basefunc(skill)
  local hero = skill.caster
  local shard = hero.proto._shard
  if shard and shard._id == 1000121 and hero.shardSkillRank and hero.shardSkillRank >= 3 then
    for unit in ed.engine:foreachAliveUnit(hero.camp) do
      if unit.info["Unit Type"] == "Hero" and unit ~= hero then
        unit:takeHeal(hero.shardSkill[3]["Script Arg1"], "mp", hero)
      end
    end
  end
end

function CM.update(basefunc, hero, dt)
  basefunc(hero, dt)
end

function CM.setHP(basefunc, unit, hp, reason)
  local hero = unit
  local hpchange = basefunc(unit, hp, reason)
  local shard = hero.proto._shard
  if hpchange < 0 and 0 < unit.hp and shard and shard._id == 1000121 and hero.shardSkillRank and hero.shardSkillRank >= 2 and not unit.manual_skill.casting then
    local hpp = hero.shardSkill[2]["Script Arg1"] / 100
    local hpnow = hero.hp / hero.attribs.HP
    if hpp >= hpnow and hero.shard2count == 0 then
      hero.shard2count = 1
      local bid = CM.shard
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, hero, hero)
      hero:addBuff(buff, hero)
    end
  end
end

function CM.reset(basefunc, unit)
  basefunc(unit)
  unit.shard2count = 0
end

function CM.skillult_start(basefunc, skill, target)
  local caster = skill.caster
  basefunc(skill, target)
end

function CM.init_hero(hero)
  local skillult = hero.skills.CM_ult
  local skillatk = hero.skills.CM_atk
  local skillatk2 = hero.skills.CM_atk2
  local skillatk3 = hero.skills.CM_atk3
  local skillaura = hero.aura_skill_list[1]
  local shard = hero.proto._shard
  if shard and shard._id == 1000121 and hero.shardSkillRank and hero.shardSkillRank >= 2 then
    hero.update = override(hero.update, CM.update)
    hero.setHP = override(hero.setHP, CM.setHP)
    hero.reset = override(hero.reset, CM.reset)
  end
  if skillatk and CM.fashion_id_2 and CM.fashion_id_2 == hero.fashion_id then
    skillatk.info = ed.wraptable(skillatk.info, {
      ["Tile Art"] = "eff_tile_CM_atk_fashion_2.cha",
      ["Impact Effect"] = "eff_impact_CM_atk_fashion_2.cha"
    })
  end
  if skillult then
    skillult.start = override(skillult.start, CM.skillult_start)
    skillult.takeEffectOn = override(skillult.takeEffectOn, CM.skillult_takeEffectOn)
    if skillult.evo_rank and 2 <= skillult.evo_rank then
      skillult.info = ed.wraptable(skillult.info, {
        ["Plus Ratio"] = skillult.evo_rank2["Script Arg1"]
      })
    end
    if skillult.evo_rank and skillult.evo_rank >= 3 then
      skillult.info = ed.wraptable(skillult.info, {
        ["Plus Ratio"] = skillult.evo_rank3["Script Arg1"]
      })
    end
    if CM.fashion_id_2 and CM.fashion_id_2 == hero.fashion_id then
      skillult.info = ed.wraptable(skillult.info, {
        ["Point Effect"] = "eff_point_CM_ult_fashion_2.cha"
      })
    end
  end
  if skillatk2 then
    if skillatk2.evo_rank and 1 <= skillatk2.evo_rank then
      skillatk2.info = ed.wraptable(skillatk2.info, {
        ["Plus Ratio"] = skillatk2.evo_rank1["Script Arg1"]
      })
    end
    if skillatk2.evo_rank and 2 <= skillatk2.evo_rank then
      skillatk2.info = ed.wraptable(skillatk2.info, {
        ["Plus Ratio"] = skillatk2.evo_rank2["Script Arg1"]
      })
    end
    if shard and shard._id == 1000121 and hero.shardSkillRank and 1 <= hero.shardSkillRank then
      skillatk2.info = ed.wraptable(skillatk2.info, {
        CD = hero.shardSkill[1]["Script Arg1"]
      })
    end
    skillatk2.createBuff = override(skillatk2.createBuff, CM.skillatk2_createBuff)
    skillatk2.finish = override(skillatk2.finish, CM.skillatk2_finish)
  end
  if skillatk3 then
    if skillatk3.evo_rank and 1 <= skillatk3.evo_rank then
      skillatk3.info = ed.wraptable(skillatk3.info, {
        ["Plus Ratio"] = skillatk3.evo_rank1["Script Arg1"]
      })
    end
    if skillatk3.evo_rank and 2 <= skillatk3.evo_rank then
      skillatk3.info = ed.wraptable(skillatk3.info, {
        ["Plus Ratio"] = skillatk3.evo_rank2["Script Arg1"]
      })
    end
    if skillatk3.evo_rank and skillatk3.evo_rank >= 3 then
      skillatk3.info = ed.wraptable(skillatk3.info, {
        ["Plus Ratio"] = skillatk3.evo_rank3["Script Arg1"]
      })
    end
    if CM.fashion_id_2 and CM.fashion_id_2 == hero.fashion_id then
      skillatk3.info = ed.wraptable(skillatk3.info, {
        ["Point Effect"] = "eff_point_CM_atk3_fashion_2.cha"
      })
    end
    skillatk3.finish = override(skillatk3.finish, CM.skillatk3_finish)
  end
  if skillaura then
    local aname = skillaura["Passive Attr"]
    local num = skillaura["Basic Num"]
    if skillaura.evo_rank and 1 <= skillaura.evo_rank then
      skillaura["Basic Num"] = skillaura["Basic Num"] + skillaura.evo_rank1["Script Arg1"]
    end
    if skillaura.evo_rank and 2 <= skillaura.evo_rank then
      skillaura["Basic Num"] = skillaura["Basic Num"] + skillaura.evo_rank2["Script Arg1"]
    end
    if skillaura.evo_rank and skillaura.evo_rank >= 3 then
      skillaura["Basic Num"] = skillaura["Basic Num"] + skillaura.evo_rank3["Script Arg1"]
    end
  end
  return hero
end

return CM.init_hero
