module("ed.battlehero", package.seeall)
local ed = ed
Huskar = {}
Huskar.ult = 10003403
Huskar.Evobuff = 10003404
Huskar.invbuff = 10003406
Huskar.timegap = 0.25
Huskar.collidedis = 30
Huskar.hastbuff_interval = 1

function Huskar.skillult_start(basefunc, skill, target)
  local owner = skill.caster
  local bid = Huskar.invbuff
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = owner:addBuff(binfo, owner)
  basefunc(skill, target)
end

function Huskar.skillult_finish(basefunc, skill)
  basefunc(skill)
  for i, tbuff in ipairs(skill.caster.buff_list) do
    if tbuff.info.ID == Huskar.invbuff then
      local buff = tbuff
      buff.owner:removeBuff(buff)
    end
  end
end

function Huskar.skillult_takeEffectOn(basefunc, skill, target, source)
  local caster = skill.caster
  if skill.attack_counter == 1 then
    local d = ed.edpSub(skill.target.position, caster.position)
    if d[1] == 0 and d[2] == 0 then
      caster.walk_v = {0, 0}
    else
      local d2 = ed.edpSub(d, ed.edpMult(ed.edpNormalize(d), Huskar.collidedis))
      caster.walk_v = {
        d2[1] / Huskar.timegap,
        d2[2] / Huskar.timegap
      }
    end
  else
    local AD = skill.info["Script Arg3"]
    local hast = skill.info["Script Arg4"]
    local bid = Huskar.ult
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, caster, caster)
    buff:setAttribute("HAST", hast)
    buff:setAttribute("MSPD", hast)
    buff:setAttribute("AD", AD)
    caster:addBuff(buff, caster)
    local perc = skill.info["Script Arg2"]
    caster:takeDamage(caster.hp * perc / 100, "Holy", "hp", caster)
    caster.walk_v = {0, 0}
    basefunc(skill, target, source)
  end
end

function Huskar.hast_buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local timer = buff.attack_timer - dt
  while timer <= 0 do
    timer = timer + Huskar.hastbuff_interval
    local unit = buff.owner
    local skillpasv = unit.passive_skill_list[1]
    local perc = 1 - unit.hp / unit.attribs.HP
    perc = math.floor(perc * 100) * 0.01
    if perc ~= buff.lastPerc then
      buff.lastPerc = perc
      local mimu = buff.mimuMax * perc
      buff:setAttribute("MIMU", mimu)
      if skillpasv.evo_rank and skillpasv.evo_rank >= 3 then
        local hast = buff.hastMax * perc
        buff:setAttribute("HAST", hast)
        buff:setAttribute("MSPD", hast)
      end
      unit:rebuild()
    end
  end
  buff.attack_timer = timer
end

function Huskar.reset(basefunc, unit)
  local skillpasv = unit.passive_skill_list[1]
  basefunc(unit)
  local bid = Huskar.Evobuff
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = ed.BuffCreate(binfo, unit, unit)
  buff.attack_timer = Huskar.hastbuff_interval
  buff.update = override(buff.update, Huskar.hast_buff_update)
  buff.mimuMax = skillpasv["Script Arg2"] * 100
  if skillpasv.evo_rank and skillpasv.evo_rank >= 3 then
    buff.hastMax = skillpasv.evo_rank3["Script Arg1"] * 100
  end
  buff.lastPerc = 0
  unit:addBuff(buff, unit)
end

function Huskar.skillatk2_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  caster:takeDamage(caster.hp * skill.info["Script Arg2"] / 100, "Holy", "hp", caster)
end

function Huskar.skillatk2_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  skill.info["No Dodge"] = true
  return projectile
end

function Huskar.skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local buffInfo = buff.info
  local owner = buff.owner
  local caster = buff.caster
  local attribName = buffInfo.Tenacity
  local TEN_final = ed.Buff.getTenValue(buffInfo, owner, caster)
  local hpr = buffInfo.HPR
  if skill.evo_rank and skill.evo_rank >= 1 then
    buff:setAttribute("HPR", hpr + skill.evo_rank1["Script Arg1"] * (1 + caster.attribs.HEAL / 100))
  end
  if skill.evo_rank and skill.evo_rank >= 2 then
    buff:setAttribute("HPR", hpr + skill.evo_rank1["Script Arg1"] * (1 + caster.attribs.HEAL / 100) + skill.evo_rank2["Script Arg1"] * (1 + caster.attribs.HEAL / 100))
  end
  if skill.evo_rank and skill.evo_rank >= 3 then
    buff:setAttribute("HPR", hpr + skill.evo_rank1["Script Arg1"] * (1 + caster.attribs.HEAL / 100) + skill.evo_rank2["Script Arg1"] * (1 + caster.attribs.HEAL / 100) + skill.evo_rank3["Script Arg1"] * (1 + caster.attribs.HEAL / 100))
  end
  return buff
end

function Huskar.init_hero(hero)
  local skillult = hero.skills.Huskar_ult
  local skillatk = hero.skills.Huskar_atk
  local skillatk2 = hero.skills.Huskar_atk2
  local skillatk3 = hero.skills.Huskar_atk3
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
    if skillult.evo_rank and skillult.evo_rank >= 3 then
      skillult.info = ed.wraptable(skillult.info, {
        ["Plus Ratio"] = skillult.evo_rank3["Script Arg1"]
      })
    end
    skillult.start = override(skillult.start, Huskar.skillult_start)
    skillult.finish = override(skillult.finish, Huskar.skillult_finish)
    skillult.takeEffectOn = override(skillult.takeEffectOn, Huskar.skillult_takeEffectOn)
  end
  if skillatk2 then
    hero.basic_skill = skillatk2
    skillatk2.start = override(skillatk2.start, Huskar.skillatk2_start)
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
      skillatk2.createProjectile = override(skillatk2.createProjectile, Huskar.skillatk2_createProjectile)
    end
  end
  if skillatk3 then
    skillatk3.createBuff = override(skillatk3.createBuff, Huskar.skillatk3_createBuff)
  end
  if skillpasv then
    local aname = skillpasv["Passive Attr"]
    if skillpasv.evo_rank and 1 <= skillpasv.evo_rank then
      skillpasv["Basic Num"] = skillpasv["Basic Num"] + skillpasv.evo_rank1["Script Arg1"]
    end
    if skillpasv.evo_rank and skillpasv.evo_rank >= 2 then
      skillpasv["Basic Num"] = skillpasv["Basic Num"] + skillpasv.evo_rank2["Script Arg1"]
    end
    hero.reset = override(hero.reset, Huskar.reset)
    hero:rebuild()
  end
  return hero
end

return Huskar.init_hero
