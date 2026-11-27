module("ed.battlehero", package.seeall)
local ed = ed
AwakeBossZeus = {}

function AwakeBossZeus.allskills_takeEffectOn(basefunc, skill, target, source, shift)
  local isHit, dmg = basefunc(skill, target, source, shift)
  local caster = skill.caster
  local skillpasv = caster.passive_skill_list[1]
  if isHit and target:isAlive() and not target.buff_effects.invulnerable and skillpasv then
    local damageMod = skillpasv.evo_rank1["Script Arg1"] / 100
    local damageUpLimit = skill.caster.attribs.AP * skillpasv.evo_rank1["Script Arg2"]
    local amount = target.hp * damageMod
    amount = damageUpLimit <= amount and damageUpLimit or amount
    local extraDamage = target:takeDamage(amount, "Holy", "hp", skill.caster, 1, 1)
    return true, extraDamage + dmg
  end
  return false
end

function AwakeBossZeus.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  for unit in ed.engine:foreachAliveUnit(skill:affectedCamp()) do
    local binfo = ed.lookupDataTable("Buff", nil, 12005302)
    local buff = ed.BuffCreate(binfo, unit, caster)
    unit:addBuff(buff, caster)
  end
end

function AwakeBossZeus.skillatk3_createBuff(basefunc, skill, target)
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

function AwakeBossZeus.init_hero(hero)
  local skillult = hero.skills.AwakeBossZeus_ult
  local skillatk2 = hero.skills.AwakeBossZeus_atk2
  local skillatk3 = hero.skills.AwakeBossZeus_atk3
  local skillpasv = hero.passive_skill_list[1]
  if skillpasv then
    local aname = skillpasv["Passive Attr"]
    if skillpasv.evo_rank and 1 <= skillpasv.evo_rank then
      if skillult then
        skillult.takeEffectOn = override(skillult.takeEffectOn, AwakeBossZeus.allskills_takeEffectOn)
      end
      if skillatk2 then
        skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, AwakeBossZeus.allskills_takeEffectOn)
      end
      if skillatk3 then
        skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, AwakeBossZeus.allskills_takeEffectOn)
      end
    end
    if skillpasv.evo_rank and skillpasv.evo_rank >= 2 then
      skillpasv["Basic Num"] = skillpasv["Basic Num"] + skillpasv.evo_rank2["Script Arg1"]
    end
    if skillpasv.evo_rank and skillpasv.evo_rank >= 3 then
      skillpasv["Basic Num"] = skillpasv["Basic Num"] + skillpasv.evo_rank3["Script Arg1"]
    end
  end
  if skillult then
    skillult.start = override(skillult.start, AwakeBossZeus.skillult_start)
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
  end
  if skillatk2 then
    if skillatk2.evo_rank and 1 <= skillatk2.evo_rank then
      skillatk2.info = ed.wraptable(skillatk2.info, {
        ["Chain Jumps"] = skillatk2.evo_rank1["Script Arg1"] + 1
      })
    end
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
      skillatk3.createBuff = override(skillatk3.createBuff, AwakeBossZeus.skillatk3_createBuff)
    end
    hero:rebuild()
  end
  return hero
end

return AwakeBossZeus.init_hero
