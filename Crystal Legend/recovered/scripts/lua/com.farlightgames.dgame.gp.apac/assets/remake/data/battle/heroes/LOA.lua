module("ed.battlehero", package.seeall)
local ed = ed
LOA = {}
LOA.skillFashionId = 421
LOA.skillFashionIdCM = 121

function LOA.skillult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local shield = buff.info["Shield Value"]
  buff.onDamaged = override(buff.onDamaged, LOA.ultbuff_onDamaged)
  buff.onRemoved = override(buff.onRemoved, LOA.ultbuff_onRemoved)
  local ShieldIncrease = 0
  local ShieldWeak = 0
  if caster.attribs.ShieldIncrease then
    ShieldIncrease = caster.attribs.ShieldIncrease
  end
  if caster.attribs.ShieldWeak then
    ShieldWeak = caster.attribs.ShieldWeak
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
  local shard = caster.proto._shard
  if shard and shard._id == 1000421 and caster.shardSkillRank and 1 <= caster.shardSkillRank then
    buff.shield = buff.shield + caster.attribs.HP * caster.shardSkill[1]["Script Arg1"] * (caster.config.hp_mod or 1) * shieldratio
  end
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 10004201 then
      caster.LOA_ult_buff = tbuff
    end
  end
  if caster.LOA_ult_buff then
    caster.LOA_ult_buff.orishiled = buff.shield
    caster.LOA_ult_buff.shield = caster.LOA_ult_buff.shield + buff.shield
    caster.LOA_ult_buff.timer = 10
  else
    return buff
  end
end

function LOA.ultbuff_onDamaged(basefunc, buff, damage, damage_type, source, skill)
  local caster = buff.owner
  local remaindamage = basefunc(buff, damage, damage_type, source, skill)
  local power = damage - remaindamage
  if 0 < power then
    caster:setHP(caster.hp + power)
    if caster.actor then
      caster.actor:addEffect("eff_impact_heal.cha", 0)
    end
  end
  return remaindamage
end

function LOA.ultbuff_onRemoved(basefunc, buff)
  basefunc(buff)
  local owner = buff.owner
  owner.LOA_ult_buff = nil
end

function LOA.setHP(basefunc, unit, hp, reason)
  local hero = unit
  local hpchange = basefunc(unit, hp, reason)
  local shard = hero.proto._shard
  if hpchange < 0 and 0 < unit.hp and shard and shard._id == 1000421 and hero.shardSkillRank and hero.shardSkillRank >= 3 then
    local hpp = hero.shardSkill[3]["Script Arg1"] / 100
    local hpnow = hero.hp / hero.attribs.HP
    if hpp >= hpnow and hero.shard3count == 0 then
      hero.shard3count = 1
      hero:setMP(hero.mp - hero.shardSkill[3]["Script Arg3"])
      local skillult = hero.skills.LOA_ult
      local shardbuff = skillult:createBuff(hero)
      if hero.LOA_ult_buff then
        hero.LOA_ult_buff.shield = hero.LOA_ult_buff.shield + hero.LOA_ult_buff.orishiled * hero.shardSkill[3]["Script Arg2"] / 100
        hero.LOA_ult_buff.timer = 10
      else
        shardbuff.shield = shardbuff.shield * hero.shardSkill[3]["Script Arg2"] / 100
        hero:addBuff(shardbuff, hero)
      end
    end
  end
end

function LOA.update(basefunc, hero, dt)
  basefunc(hero, dt)
  hero.LOA_ult_buff = nil
  for i, tbuff in ipairs(hero.buff_list) do
    if tbuff.info.ID == 10004201 then
      hero.LOA_ult_buff = tbuff
    end
  end
  if not hero.buff_effects.noHPR and hero.LOA_ult_buff then
    local hp_regen = hero.attribs.HPR
    if hp_regen < 0 then
      local dotres
      if hero.attribs.DOTRES then
        dotres = hero.attribs.DOTRES
      else
        dotres = 0
      end
      local ulthprheal = -hp_regen * (1 - math.min(dotres / 100, 0.99)) * dt
      if hero.LOA_ult_buff.shield and ulthprheal <= hero.LOA_ult_buff.shield then
        if not hero.buff_effects.unheal then
          hero:setHP(hero.hp + ulthprheal * 2)
          if hero.LOA_ult_buff.shield then
            hero.LOA_ult_buff.shield = hero.LOA_ult_buff.shield - ulthprheal
          end
          if 0 >= hero.LOA_ult_buff.shield then
            hero.LOA_ult_buff.timer = -1
          end
        end
      elseif hero.LOA_ult_buff.shield and ulthprheal > hero.LOA_ult_buff.shield then
        ulthprheal = hero.LOA_ult_buff.shield
        if not hero.buff_effects.unheal then
          hero:setHP(hero.hp + ulthprheal * 2)
          if hero.LOA_ult_buff.shield then
            hero.LOA_ult_buff.shield = hero.LOA_ult_buff.shield - ulthprheal
          end
          if 0 >= hero.LOA_ult_buff.shield then
            hero.LOA_ult_buff.timer = -1
          end
        end
      end
    end
  end
end

function LOA.reset(basefunc, unit)
  basefunc(unit)
  unit.LOA_ult_buff = nil
  unit.shard3count = 0
end

function LOA.skillatk2_takeEffectOn(basefunc, skill, target, source)
  local originfo = skill.info
  local caster = skill.caster
  local emratio = 2
  if skill.evo_rank and skill.evo_rank >= 3 then
    emratio = 3
  end
  if target.camp ~= skill.caster.camp then
    skill.info = ed.wraptable(originfo, {
      ["Damage Type"] = "AP",
      ["Basic Num"] = originfo["Basic Num"] * emratio,
      ["Plus Ratio"] = originfo["Plus Ratio"] * emratio
    })
  end
  basefunc(skill, target, source)
  skill.info = originfo
end

function LOA.skillatk3_buff_OnRemoved(basefunc, buff)
  if buff.timer >= 0 and 0 < buff.shield then
    return basefunc(buff)
  end
  local skill = buff.caster.skills.LOA_atk3
  local originfo = skill.info
  local caster = buff.caster
  local owner = buff.owner
  skill.info = ed.wraptable(originfo, {
    ["Affected Camp"] = -1,
    ["AOE Origin"] = "target",
    ["AOE Shape"] = "circle",
    ["Shape Arg1"] = 200,
    ["Damage Type"] = "AP",
    ["Buff ID"] = 0,
    ["Point Effect"] = "eff_point_DR_atk3.cha",
    ["Impact Effect"] = "eff_impact_LOA_atk2.cha"
  })
  skill:takeEffectAt(buff.owner.position)
  skill.info = originfo
  return basefunc(buff)
end

function LOA.skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = buff.caster
  local owner = buff.owner
  local fashionId = caster.fashion_id
  local skillLV = caster.skills.LOA_atk3.level
  local shield = buff.shield
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
    local list = owner.buff_list
    local debuff_list = {}
    local my_camp = owner.camp
    for i = 1, #list do
      local buff = list[i]
      if buff and (not buff.caster or buff.caster.camp ~= my_camp) and buff.info.Dispel == "YES" then
        debuff_list[#debuff_list + 1] = buff
      end
    end
    for i = 1, #debuff_list do
      owner:removeBuff(debuff_list[i])
    end
  end
  buff.onRemoved = override(buff.onRemoved, LOA.skillatk3_buff_OnRemoved)
  return buff
end

function LOA.init_hero(hero)
  local skillult = hero.skills.LOA_ult
  local skillatk2 = hero.skills.LOA_atk2
  local skillatk3 = hero.skills.LOA_atk3
  local skillaura = hero.aura_skill_list[1]
  local skillshard = hero.effect_enemy_aura_skill_list[1]
  if skillult then
    skillult.createBuff = override(skillult.createBuff, LOA.skillult_createBuff)
    hero.update = override(hero.update, LOA.update)
    hero.setHP = override(hero.setHP, LOA.setHP)
    hero.reset = override(hero.reset, LOA.reset)
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
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, LOA.skillatk2_takeEffectOn)
  end
  if skillatk3 then
    skillatk3.createBuff = override(skillatk3.createBuff, LOA.skillatk3_createBuff)
  end
  if skillaura then
    local aname = skillaura["Passive Attr"]
    local num = skillaura["Basic Num"]
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
  if skillshard then
    local num = skillaura["Basic Num"]
    local shard = hero.proto._shard
    if shard and shard._id == 1000421 and hero.shardSkillRank and 2 <= hero.shardSkillRank then
      skillshard["Basic Num"] = skillshard["Basic Num"] - hero.shardSkill[2]["Script Arg1"]
    end
  end
  return hero
end

return LOA.init_hero
