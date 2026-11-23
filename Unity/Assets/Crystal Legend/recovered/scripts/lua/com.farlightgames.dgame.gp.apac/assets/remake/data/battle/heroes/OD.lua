module("ed.battlehero", package.seeall)
local ed = ed
OD = {}
OD.INT = 10002102

function OD.skillult_takeEffectOn(basefunc, skill, target)
  if target.info["Main Attrib"] == "INT" and skill.evo_rank and skill.evo_rank < 3 then
    if ed.run_with_scene then
      local color = target.camp == ed.emCampEnemy and "red" or "blue"
      local str = "immune"
      ed.PopupCreate(str, color, target.actor, nil, "text")
    end
    return false
  else
    return basefunc(skill, target)
  end
end

function OD.skillatk2_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local skillpasv = caster.passive_skill_list[1]
  if skillpasv and skillpasv.evo_rank and skillpasv.evo_rank >= 3 then
    local p = skillpasv.evo_rank3["Script Arg1"] / 100
    local mp = skillpasv.evo_rank3["Script Arg2"]
    if p >= ed.rand() then
      caster:takeHeal(mp, "mp", caster)
    end
  end
end

function OD.skillatk3_canCastWithTarget(basefunc, skill, target)
  local enemycount = 0
  local caster = skill.caster
  for unit in ed.engine:foreachAliveUnit(caster.foecamp) do
    if unit then
      enemycount = enemycount + 1
    end
  end
  if enemycount <= 1 then
    enemycount = 0
    return false
  else
    enemycount = 0
    return basefunc(skill, target)
  end
end

function OD.skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local trans_int = skill.info["Script Arg2"]
  if skill.evo_rank and skill.evo_rank >= 1 then
    trans_int = trans_int + skill.evo_rank1["Script Arg1"]
  end
  if skill.evo_rank and skill.evo_rank >= 2 then
    trans_int = trans_int + skill.evo_rank2["Script Arg1"]
  end
  local caster = skill.caster
  local bid = OD.INT
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
  if skill.evo_rank and skill.evo_rank >= 3 then
    target:takeDamage(skill.evo_rank3["Script Arg1"] * caster.attribs.AP, "AP", "hp", caster)
    target:takeDamage(skill.evo_rank3["Script Arg2"], "Holy", "mp", caster)
    caster:takeHeal(skill.evo_rank3["Script Arg2"], "mp", caster)
  end
  return buff
end

function OD.init_hero(hero)
  local skillult = hero.skills.OD_ult
  local skillatk2 = hero.skills.OD_atk2
  local skillatk3 = hero.skills.OD_atk3
  local skillpasv = hero.passive_skill_list[1]
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
    skillult.takeEffectOn = override(skillult.takeEffectOn, OD.skillult_takeEffectOn)
  end
  if skillatk2 then
    hero.basic_skill = skillatk2
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
        ["Plus Ratio"] = skillatk2.evo_rank3["Script Arg1"]
      })
    end
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, OD.skillatk2_onAttackFrame)
  end
  if skillatk3 then
    skillatk3.createBuff = override(skillatk3.createBuff, OD.skillatk3_createBuff)
    skillatk3.canCastWithTarget = override(skillatk3.canCastWithTarget, OD.skillatk3_canCastWithTarget)
  end
  if skillpasv then
    local aname = skillpasv["Passive Attr"]
    if skillpasv.evo_rank and 1 <= skillpasv.evo_rank then
      skillpasv["Basic Num"] = skillpasv["Basic Num"] + skillpasv.evo_rank1["Script Arg1"]
    end
    if skillpasv.evo_rank and skillpasv.evo_rank >= 2 then
      skillpasv["Basic Num"] = skillpasv["Basic Num"] + skillpasv.evo_rank2["Script Arg1"]
    end
    hero:rebuild()
  end
  return hero
end

return OD.init_hero
