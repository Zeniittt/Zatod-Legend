module("ed.battlehero", package.seeall)
local ed = ed
AwakeBossCM = {}
AwakeBossCM.slow_trigger = 2
AwakeBossCM.frozen_trigger = 4
AwakeBossCM.skillFashionId = 121
AwakeBossCM.skillFashionIdLOA = 421
AwakeBossCM.ultEvobuff = 12005803
AwakeBossCM.fashion_id_2 = 122

function AwakeBossCM.skillult_takeEffectOn(basefunc, skill, target, source)
  local ishit, damage = basefunc(skill, target, source)
  if ishit and skill.attack_counter == 3 then
    local caster = skill.caster
    local bid = AwakeBossCM.ultEvobuff
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, target, caster)
    if AwakeBossCM.fashion_id_2 and AwakeBossCM.fashion_id_2 == caster.fashion_id then
      buff:setAttribute("Effect", "eff_buff_CM_atk2_fashion_2.cha")
    end
    target:addBuff(buff, caster)
  end
  return ishit, damage
end

function AwakeBossCM.skillatk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local buffInfo = buff.info
  local owner = buff.owner
  local caster = buff.caster
  local attribName = buffInfo.Tenacity
  local TEN_final = ed.Buff.getTenValue(buffInfo, owner, caster)
  if AwakeBossCM.fashion_id_2 and AwakeBossCM.fashion_id_2 == caster.fashion_id then
    buff:setAttribute("Effect", "eff_buff_CM_atk2_fashion_2.cha")
  end
  if skill.evo_rank and skill.evo_rank >= 3 then
    buff.timer = skill.evo_rank3["Script Arg1"] * math.max(0.01, 1 - TEN_final / 100)
  end
  return buff
end

function AwakeBossCM.skillatk2_finish(basefunc, skill)
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

function AwakeBossCM.skillatk3_finish(basefunc, skill)
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

function AwakeBossCM.skillult_start(basefunc, skill, target)
  local caster = skill.caster
  basefunc(skill, target)
end

function AwakeBossCM.getLostHPAfterImmunity(basefunc, self, damage, immunity, damage_type, source, skill, field)
  local lost = basefunc(self, damage, immunity, damage_type)
  if 0 < lost and damage_type == "AD" and source then
    local prob = ed.rand()
    if prob < 0.3 then
      local bid = 12005805
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, source, self)
      source:addBuff(buff, self)
      self:setMP(self.mp + 50)
    end
  end
  return lost
end

function AwakeBossCM.init_hero(hero)
  local skillult = hero.skills.AwakeBossCM_ult
  local skillatk = hero.skills.AwakeBossCM_atk
  local skillatk2 = hero.skills.AwakeBossCM_atk2
  local skillatk3 = hero.skills.AwakeBossCM_atk3
  local skillaura = hero.aura_skill_list[1]
  if skillatk and AwakeBossCM.fashion_id_2 and AwakeBossCM.fashion_id_2 == hero.fashion_id then
    skillatk.info = ed.wraptable(skillatk.info, {
      ["Tile Art"] = "eff_tile_CM_atk_fashion_2.cha",
      ["Impact Effect"] = "eff_impact_CM_atk_fashion_2.cha"
    })
  end
  if skillult then
    skillult.start = override(skillult.start, AwakeBossCM.skillult_start)
    skillult.takeEffectOn = override(skillult.takeEffectOn, AwakeBossCM.skillult_takeEffectOn)
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
    if AwakeBossCM.fashion_id_2 and AwakeBossCM.fashion_id_2 == hero.fashion_id then
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
    if skillatk2.evo_rank and skillatk2.evo_rank >= 2 then
      skillatk2.info = ed.wraptable(skillatk2.info, {
        ["Plus Ratio"] = skillatk2.evo_rank2["Script Arg1"]
      })
    end
    if shard and shard._id == 1000121 and hero.shardSkillRank and 1 <= hero.shardSkillRank then
      skillatk2.info = ed.wraptable(skillatk2.info, {
        CD = hero.shardSkill[1]["Script Arg1"]
      })
    end
    skillatk2.createBuff = override(skillatk2.createBuff, AwakeBossCM.skillatk2_createBuff)
    skillatk2.finish = override(skillatk2.finish, AwakeBossCM.skillatk2_finish)
  end
  if skillatk3 then
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
    if AwakeBossCM.fashion_id_2 and AwakeBossCM.fashion_id_2 == hero.fashion_id then
      skillatk3.info = ed.wraptable(skillatk3.info, {
        ["Point Effect"] = "eff_point_CM_atk3_fashion_2.cha"
      })
    end
    skillatk3.finish = override(skillatk3.finish, AwakeBossCM.skillatk3_finish)
  end
  if skillaura then
    local aname = skillaura["Passive Attr"]
    local num = skillaura["Basic Num"]
    hero.getLostHPAfterImmunity = override(hero.getLostHPAfterImmunity, AwakeBossCM.getLostHPAfterImmunity)
    if skillaura.evo_rank and 1 <= skillaura.evo_rank then
      skillaura["Basic Num"] = skillaura["Basic Num"] + skillaura.evo_rank1["Script Arg1"]
    end
    if skillaura.evo_rank and skillaura.evo_rank >= 2 then
      skillaura["Basic Num"] = skillaura["Basic Num"] + skillaura.evo_rank2["Script Arg1"]
    end
    if skillaura.evo_rank and skillaura.evo_rank >= 3 then
      skillaura["Basic Num"] = skillaura["Basic Num"] + skillaura.evo_rank3["Script Arg1"]
    end
  end
  return hero
end

return AwakeBossCM.init_hero
