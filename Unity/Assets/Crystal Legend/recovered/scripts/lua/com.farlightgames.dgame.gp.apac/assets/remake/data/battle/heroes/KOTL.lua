module("ed.battlehero", package.seeall)
local ed = ed
KOTL = {}

function KOTL.launchPoint(basefunc, skill)
  local position, height = basefunc(skill)
  local caster = skill.caster
  local direction = skill.caster.direction
  position[1] = caster.position[1]
  position[2] = 0
  height = 50
  return position, height
end

function KOTL.skillult_canTrigger(basefunc, skill)
  return skill == skill.caster.current_skill and skill.attack_counter == 1
end

function KOTL.skillult_onAttackFrame(basefunc, skill)
  if skill.attack_counter == 0 then
    if skill.caster.manually_casting then
      ed.engine:unfreeze()
    end
    skill.caster.manually_casting = false
    skill.ultbegin = skill.current_phase_elapsed
    skill.attack_counter = 1
  elseif skill.attack_counter == 1 then
    skill.ultcharge = skill.current_phase_elapsed - skill.ultbegin
    skill.ultcharge = math.min(5, skill.ultcharge) / 5
    basefunc(skill)
  end
end

function KOTL.skillult_trigger(basefunc, skill)
  skill:onAttackFrame()
  skill:gotoEventIdx(2)
end

function KOTL.skillult_interrupt(basefunc, skill)
  skill:onAttackFrame()
  basefunc(skill)
end

function KOTL.skillult_power(basefunc, skill, source, target, damage_type)
  return basefunc(skill, source, target, damage_type) * skill.ultcharge, 1
end

function KOTL.skillatk2_takeEffectOn(basefunc, skill, target, source)
  local caster = skill.caster
  local addHp = skill.evo_rank3["Script Arg1"] + skill.evo_rank3["Script Arg2"] * caster.attribs.AP
  if 0 < addHp then
    target:takeHeal(addHp, "hp", caster)
  end
  basefunc(skill, target, source)
end

function KOTL.skillatk3_createBuff(basefunc, skill, target)
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

function KOTL.init_hero(hero)
  local skillult = hero.skills.KOTL_ult
  local skillatk2 = hero.skills.KOTL_atk2
  local skillatk3 = hero.skills.KOTL_atk3
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
    skillult.info["No Speeder"] = true
    skillult.onAttackFrame = override(skillult.onAttackFrame, KOTL.skillult_onAttackFrame)
    skillult.canTrigger = override(skillult.canTrigger, KOTL.skillult_canTrigger)
    skillult.trigger = override(skillult.trigger, KOTL.skillult_trigger)
    skillult.interrupt = override(skillult.interrupt, KOTL.skillult_interrupt)
    skillult.power = override(skillult.power, KOTL.skillult_power)
    skillult.launchPoint = override(skillult.launchPoint, KOTL.launchPoint)
  end
  if skillatk2 then
    local num = skillatk2.info["Basic Num"]
    if skillatk2.evo_rank and 1 <= skillatk2.evo_rank then
      skillatk2.info = ed.wraptable(skillatk2.info, {
        ["Basic Num"] = num + skillatk2.evo_rank1["Script Arg1"]
      })
    end
    if skillatk2.evo_rank and skillatk2.evo_rank >= 2 then
      skillatk2.info = ed.wraptable(skillatk2.info, {
        ["Basic Num"] = num + skillatk2.evo_rank1["Script Arg1"] + skillatk2.evo_rank2["Script Arg1"]
      })
    end
    if skillatk2.evo_rank and skillatk2.evo_rank >= 3 then
      skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, KOTL.skillatk2_takeEffectOn)
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
      skillatk3.createBuff = override(skillatk3.createBuff, KOTL.skillatk3_createBuff)
    end
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
  return hero
end

return KOTL.init_hero
