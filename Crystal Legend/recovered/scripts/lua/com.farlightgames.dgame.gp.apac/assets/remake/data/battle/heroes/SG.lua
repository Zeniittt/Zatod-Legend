module("ed.battlehero", package.seeall)
local ed = ed
SG = {}
SG.skillFashionId = 141
SG.fashion_bid1 = 4088
SG.fashion_bid2 = 4089
SG.fashion_bid3 = 4090
SG.skillatk3buff = 10001402

function SG.skillatk_power(basefunc, skill, source, target, damage_type)
  local power = basefunc(skill, source, target, damage_type)
  local caster = skill.caster
  local skillatk3 = caster.skills.SG_atk3
  if skillatk3 then
    for i, tbuff in ipairs(target.buff_list) do
      if tbuff.info.ID == SG.skillatk3buff then
        power = power * skillatk3.evo_rank1["Script Arg1"]
        break
      end
    end
  end
  return power, 1
end

function SG.skillult_createBuff(basefunc, skill, target)
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

function SG.skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local ARM = buff.info.ARM
  local caster = skill.caster
  local skillatk2 = caster.skills.SG_atk2
  local skillult = caster.skills.SG_ult
  local skillatk = caster.skills.SG_atk
  if skill.evo_rank and skill.evo_rank >= 2 then
    buff:setAttribute("ARM", ARM - skill.evo_rank2["Script Arg1"])
  end
  if skill.evo_rank and skill.evo_rank >= 3 then
    local targetarm = target.attribs.ARM
    local evo3ArmDown = 0
    if 0 < targetarm then
      evo3ArmDown = targetarm * skill.evo_rank3["Script Arg1"] / 100
    end
    buff:setAttribute("ARM", ARM - skill.evo_rank2["Script Arg1"] - evo3ArmDown)
  end
  return buff
end

function SG.init_hero(hero)
  local skillatk2 = hero.skills.SG_atk2
  local skillult = hero.skills.SG_ult
  local skillatk = hero.skills.SG_atk
  local skillatk3 = hero.skills.SG_atk3
  local skillpasv = hero.passive_skill_list[1]
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
        ["Plus Ratio"] = skillatk2.evo_rank3["Script Arg1"]
      })
    end
  end
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
      skillult.createBuff = override(skillult.createBuff, SG.skillult_createBuff)
    end
  end
  if skillatk3 then
    skillatk3.createBuff = override(skillatk3.createBuff, SG.skillatk3_createBuff)
    if skillatk3.evo_rank and 1 <= skillatk3.evo_rank then
      skillatk2.power = override(skillatk2.power, SG.skillatk_power)
      skillult.power = override(skillult.power, SG.skillatk_power)
      skillatk.power = override(skillatk.power, SG.skillatk_power)
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
    hero:rebuild()
  end
  return hero
end

return SG.init_hero
