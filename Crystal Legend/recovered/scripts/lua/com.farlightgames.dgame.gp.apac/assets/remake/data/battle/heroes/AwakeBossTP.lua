module("ed.battlehero", package.seeall)
local ed = ed
AwakeBossTP = {}
AwakeBossTP.fashionId_1 = 601
AwakeBossTP.fashionId_2 = 602

function AwakeBossTP.skillult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  if (AwakeBossTP.fashionId_1 or AwakeBossTP.fashionId_2) and (AwakeBossTP.fashionId_1 == caster.fashion_id or AwakeBossTP.fashionId_2 == caster.fashion_id) and buff.info.ID == 12004501 then
    buff:setAttribute("Effect", "eff_buff_TP_atk3_fashion.cha")
  end
  return buff
end

function AwakeBossTP.skillatk2_selectTarget(basefunc, skill, default)
  local max = -math.huge
  local caster = skill.caster
  local chosen = caster
  local caster_position = caster.position
  local enchanted = caster.buff_effects.enchanted
  local enchantedbyself = caster.buff_effects.enchantedbyself
  for unit in ed.engine:foreachAliveUnit(skill.caster.camp) do
    if unit.buff_effects.untargetable then
    elseif unit.buffManager.invisible and unit.camp ~= caster.camp then
    elseif enchanted and unit == caster then
    elseif enchantedbyself and unit == caster then
    elseif unit.config.is_summoned then
    elseif unit.buff_effects.building then
    elseif unit.position[1] < 0 or unit.position[1] > 800 then
    else
      local initdir = caster:getInitDir()
      local v = unit.position[1]
      if initdir == 1 then
        if max < v then
          max = v
          chosen = unit
        end
      elseif initdir == -1 and max < -v then
        max = -v
        chosen = unit
      end
    end
  end
  skill.target = chosen
  return chosen
end

function AwakeBossTP.skillatk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  local caster = skill.caster
  if (AwakeBossTP.fashionId_1 or AwakeBossTP.fashionId_2) and (AwakeBossTP.fashionId_1 == caster.fashion_id or AwakeBossTP.fashionId_2 == caster.fashion_id) and buff.info.ID == 12004502 then
    buff:setAttribute("Effect", "eff_buff_TP_atk2_fashion.cha")
  end
  local adratio = skill.info["Script Arg3"]
  local baseshield = skill.info["Script Arg2"]
  if skill.evo_rank and skill.evo_rank >= 1 then
    baseshield = baseshield + skill.evo_rank1["Script Arg1"]
  end
  if skill.evo_rank and skill.evo_rank >= 2 then
    adratio = skill.evo_rank2["Script Arg1"]
  end
  local shield = baseshield + adratio * caster.attribs.HP
  buff.shield = shield * (owner.config.hp_mod or 1)
  if skill.evo_rank and skill.evo_rank >= 3 then
    buff.evoratio = skill.evo_rank3["Script Arg1"] / 100
    buff.onDamaged = override(buff.onDamaged, AwakeBossTP.skillatk2_buffonDamaged)
  end
  return buff
end

function AwakeBossTP.skillatk2_buffonDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local caster = buff.owner
  if source and source:isAlive() and damage_type == "AD" and source.info["Unit Type"] ~= "Pet" then
    source:takeDamage(damage * buff.evoratio, "Holy", "hp", caster, 1, 1, true)
  end
  local dmg = basefunc(buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  return dmg
end

function AwakeBossTP.skillatk_takeEffectOn(basefunc, skill, target, source)
  local ret, dmg = basefunc(skill, target, source)
  local unit = skill.caster
  local skillatk3 = unit.skills.AwakeBossTP_atk3
  if skillatk3 then
    local Rate = skillatk3.info["Script Arg2"] / 100
    local healrate = skillatk3.info["Script Arg3"] / 100
    if skillatk3.evo_rank and skillatk3.evo_rank >= 1 then
      Rate = Rate + skillatk3.evo_rank1["Script Arg1"] / 100
    end
    if skillatk3.evo_rank and skillatk3.evo_rank >= 3 then
      healrate = skillatk3.evo_rank3["Script Arg1"] / 100
    end
    if skillatk3 and target and Rate >= ed.rand() then
      skillatk3:takeEffectOn(target, source)
      unit:takeHeal(healrate * unit.attribs.HP, "hp", unit)
    end
  end
  return ret, dmg
end

function AwakeBossTP.skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  if (AwakeBossTP.fashionId_1 or AwakeBossTP.fashionId_2) and (AwakeBossTP.fashionId_1 == caster.fashion_id or AwakeBossTP.fashionId_2 == caster.fashion_id) and buff.info.ID == 12004503 then
    buff:setAttribute("Effect", "eff_buff_TP_atk3_fashion.cha")
  end
  return buff
end

function AwakeBossTP.hero_reset(basefunc, hero)
  basefunc(hero)
end

function AwakeBossTP.init_hero(hero)
  hero.reset = override(hero.reset, AwakeBossTP.hero_reset)
  local skillult = hero.skills.AwakeBossTP_ult
  local skillatk = hero.skills.AwakeBossTP_atk
  local skillatk2 = hero.skills.AwakeBossTP_atk2
  local skillatk3 = hero.skills.AwakeBossTP_atk3
  local skillaura = hero.aura_skill_list[1]
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
    skillult.createBuff = override(skillult.createBuff, AwakeBossTP.skillult_createBuff)
  end
  if skillatk2 then
    skillatk2.selectTarget = override(skillatk2.selectTarget, AwakeBossTP.skillatk2_selectTarget)
    skillatk2.createBuff = override(skillatk2.createBuff, AwakeBossTP.skillatk2_createBuff)
  end
  if skillatk and skillatk3 then
    if skillatk3.evo_rank and skillatk3.evo_rank >= 2 then
      skillatk3.info = ed.wraptable(skillatk3.info, {
        ["Plus Ratio"] = skillatk3.evo_rank2["Script Arg1"]
      })
    end
    skillatk.takeEffectOn = override(skillatk.takeEffectOn, AwakeBossTP.skillatk_takeEffectOn)
    skillatk3.createBuff = override(skillatk3.createBuff, AwakeBossTP.skillatk3_createBuff)
  end
  if skillaura then
    local aname = skillaura["Passive Attr"]
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

return AwakeBossTP.init_hero
