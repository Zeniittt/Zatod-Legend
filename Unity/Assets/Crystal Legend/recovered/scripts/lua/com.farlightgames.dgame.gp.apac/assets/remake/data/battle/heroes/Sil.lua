module("ed.battlehero", package.seeall)
local ed = ed
Sil = {}
Sil.INT = 10002603
Sil.shard = 10002604
Sil.fashion_id_1 = 261

function Sil.skillatk3_takeEffectOn(basefunc, skill, target)
  local succ, dmg = basefunc(skill, target)
  local caster = skill.caster
  if succ then
    local power = skill.info["Script Arg2"]
    if skill.evo_rank and skill.evo_rank >= 3 then
      power = power + skill.evo_rank3["Script Arg1"]
    end
    target:takeDamage(power, "Holy", "mp", caster)
    local shard = caster.proto._shard
    if shard and shard._id == 1000261 and caster.shardSkillRank and 3 <= caster.shardSkillRank then
      caster:takeHeal(power * caster.shardSkill[3]["Script Arg1"] / 100, "mp", caster)
    end
  end
  return succ, dmg
end

function Sil.skillult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local buffInfo = buff.info
  local owner = buff.owner
  local caster = buff.caster
  local attribName = buffInfo.Tenacity
  local bufftime = buffInfo.Time
  local timer = buff.timer
  local TEN_final = ed.Buff.getTenValue(buffInfo, owner, caster)
  if skill.evo_rank and skill.evo_rank >= 1 then
    buff.timer = timer + skill.evo_rank1["Script Arg1"] * math.max(0.01, 1 - TEN_final / 100)
  end
  if skill.evo_rank and skill.evo_rank >= 2 then
    buff.timer = timer + (skill.evo_rank1["Script Arg1"] + skill.evo_rank2["Script Arg1"]) * math.max(0.01, 1 - TEN_final / 100)
  end
  if skill.evo_rank and skill.evo_rank >= 3 then
    buff.timer = timer + (skill.evo_rank1["Script Arg1"] + skill.evo_rank2["Script Arg1"] + skill.evo_rank3["Script Arg1"]) * math.max(0.01, 1 - TEN_final / 100)
  end
  return buff
end

function Sil.skillatk2_createBuff(basefunc, skill, target)
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

function Sil.skillatk2_takeEffectOn(basefunc, skill, target)
  local succ, dmg = basefunc(skill, target)
  local caster = skill.caster
  if succ then
    local shard = caster.proto._shard
    if shard and shard._id == 1000261 and caster.shardSkillRank and caster.shardSkillRank >= 1 then
      local bid = Sil.shard
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, target, caster)
      target:addBuff(buff, caster)
    end
  end
  return succ, dmg
end

function Sil.skillatk4_takeEffectOn(basefunc, skill, target)
  local isHit, dmg = basefunc(skill, target)
  if isHit then
    local caster = skill.caster
    local trans_int = skill.evo_rank3["Script Arg1"]
    local bid = Sil.INT
    local orin_info = ed.lookupDataTable("Buff", nil, bid)
    local binfo = ed.wraptable(orin_info, {INT = trans_int})
    caster:addBuff(binfo, caster)
    if target then
      if target.attribs.INT - trans_int >= 0 then
        local binfo = ed.wraptable(orin_info, {
          INT = -trans_int
        })
        target:addBuff(binfo, caster)
      else
        local binfo = ed.wraptable(orin_info, {
          INT = -target.attribs.INT
        })
        target:addBuff(binfo, caster)
      end
    end
  end
  return isHit, dmg
end

function Sil.init_hero(hero)
  local skillatk = hero.skills.Sil_atk
  local skillatk2 = hero.skills.Sil_atk2
  local skillatk3 = hero.skills.Sil_atk3
  local skillatk4 = hero.skills.Sil_atk4
  local skillult = hero.skills.Sil_ult
  local shard = hero.proto._shard
  if skillult then
    skillult.createBuff = override(skillult.createBuff, Sil.skillult_createBuff)
    if Sil.fashion_id_1 and Sil.fashion_id_1 == hero.fashion_id then
      skillult.info = ed.wraptable(skillult.info, {
        ["Point Effect"] = "eff_point_Sil_ult2_fashion_1.cha"
      })
    end
  end
  if skillatk and Sil.fashion_id_1 and Sil.fashion_id_1 == hero.fashion_id then
    skillatk.info = ed.wraptable(skillatk.info, {
      ["Tile Art"] = "eff_tile_Sil_atk_fashion_1.cha"
    })
  end
  if skillatk2 then
    if skillatk2.evo_rank and skillatk2.evo_rank >= 1 then
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
      skillatk2.createBuff = override(skillatk2.createBuff, Sil.skillatk2_createBuff)
    end
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, Sil.skillatk2_takeEffectOn)
    if shard and shard._id == 1000261 and hero.shardSkillRank and 2 <= hero.shardSkillRank then
      skillatk2.info = ed.wraptable(skillatk2.info, {
        ["AOE Origin"] = "target",
        ["AOE Shape"] = "circle",
        ["Shape Arg1"] = 80
      })
    end
    if Sil.fashion_id_1 and Sil.fashion_id_1 == hero.fashion_id then
      skillatk2.info = ed.wraptable(skillatk2.info, {
        ["Impact Effect"] = "eff_impact_Sil_atk2_fashion_1.cha"
      })
    end
  end
  if skillatk3 then
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
    skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, Sil.skillatk3_takeEffectOn)
    if Sil.fashion_id_1 and Sil.fashion_id_1 == hero.fashion_id then
      skillatk3.info = ed.wraptable(skillatk3.info, {
        ["Point Effect"] = "eff_point_Sil_atk3_fashion_1.cha"
      })
    end
  end
  if skillatk4 then
    hero.basic_skill = skillatk4
    if skillatk4.evo_rank and skillatk4.evo_rank >= 1 then
      skillatk4.info = ed.wraptable(skillatk4.info, {
        ["Plus Ratio"] = skillatk4.evo_rank1["Script Arg1"]
      })
    end
    if skillatk4.evo_rank and skillatk4.evo_rank >= 2 then
      skillatk4.info = ed.wraptable(skillatk4.info, {
        ["Plus Ratio"] = skillatk4.evo_rank2["Script Arg1"]
      })
    end
    if skillatk4.evo_rank and skillatk4.evo_rank >= 3 then
      skillatk4.takeEffectOn = override(skillatk4.takeEffectOn, Sil.skillatk4_takeEffectOn)
    end
  end
  return hero
end

return Sil.init_hero
