module("ed.battlehero", package.seeall)
local ed = ed
CocoSP = {}
CocoSP.atk3Evobuff = 10038103
CocoSP.ultEvobuff = 10038104

function CocoSP.skillatk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local buffInfo = buff.info
  local owner = buff.owner
  local caster = buff.caster
  local attribName = buffInfo.Tenacity
  local TEN_final = ed.Buff.getTenValue(buffInfo, owner, caster)
  if skill.evo_rank and skill.evo_rank >= 2 then
    buff.timer = skill.evo_rank2["Script Arg1"] * math.max(0.01, 1 - TEN_final / 100)
  end
  return buff
end

function CocoSP.skillatk3_takeEffectOn(basefunc, skill, target, source)
  local ishit, damage = basefunc(skill, target, source)
  local caster = skill.caster
  if ishit and skill.evo_rank and skill.evo_rank >= 1 then
    local bid = CocoSP.atk3Evobuff
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, target, caster)
    target:addBuff(buff, caster)
  end
  return ishit, damage
end

function CocoSP.launchPoint(basefunc, skill)
  local position, height = basefunc(skill)
  local direction = skill.caster.direction
  position[1] = position[1] - 400 * direction
  if position[1] < 0 or position[1] > 800 then
    position[1] = 400 - 400 * direction
  end
  position[2] = 0
  height = 10
  return position, height
end

function CocoSP.skillult_createBuff(basefunc, skill, target)
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

function CocoSP.skillult_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  basefunc(skill)
  if skill.evo_rank and skill.evo_rank >= 1 then
    local bid = CocoSP.ultEvobuff
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    for unit in ed.engine:foreachAliveUnit(caster.camp) do
      local buff = ed.BuffCreate(binfo, unit, caster)
      unit:addBuff(buff, caster)
    end
  end
end

function CocoSP.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  if not hero.start then
    hero.start = true
  end
end

function CocoSP.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.start = false
end

function CocoSP.init_hero(hero)
  local skillult = hero.skills.CocoSP_ult
  local skillatk2 = hero.skills.CocoSP_atk3
  local skillatk3 = hero.skills.CocoSP_atk2
  local skillpasv = hero.passive_skill_list[1]
  hero.update = override(hero.update, CocoSP.hero_update)
  hero.reset = override(hero.reset, CocoSP.hero_reset)
  if skillult then
    skillult.launchPoint = override(skillult.launchPoint, CocoSP.launchPoint)
    skillult.onAttackFrame = override(skillult.onAttackFrame, CocoSP.skillult_onAttackFrame)
    skillult.createBuff = override(skillult.createBuff, CocoSP.skillult_createBuff)
    if skillult.evo_rank and skillult.evo_rank >= 2 then
      skillult.info = ed.wraptable(skillult.info, {
        ["Plus Ratio"] = skillult.evo_rank2["Script Arg1"]
      })
    end
  end
  if skillatk2 then
    skillatk2.createBuff = override(skillatk2.createBuff, CocoSP.skillatk2_createBuff)
    if skillatk2.evo_rank and 1 <= skillatk2.evo_rank then
      skillatk2.info = ed.wraptable(skillatk2.info, {
        ["Plus Ratio"] = skillatk2.evo_rank1["Script Arg1"]
      })
    end
    if skillatk2.evo_rank and skillatk2.evo_rank >= 3 then
      skillatk2.info = ed.wraptable(skillatk2.info, {
        ["Plus Ratio"] = skillatk2.evo_rank3["Script Arg1"]
      })
    end
  end
  if skillatk3 then
    skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, CocoSP.skillatk3_takeEffectOn)
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
  end
  if skillpasv then
    local aname = skillpasv["Passive Attr"]
    local num = skillpasv["Basic Num"]
    local oriattribs = hero.attribs[aname]
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

return CocoSP.init_hero
