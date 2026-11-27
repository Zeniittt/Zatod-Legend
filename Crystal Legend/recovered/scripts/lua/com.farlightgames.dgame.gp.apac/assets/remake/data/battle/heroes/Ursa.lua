module("ed.battlehero", package.seeall)
local ed = ed
Ursa = {}

function Ursa.skillult_power(basefunc, skill, source, target, damage_type)
  local ratio = skill.evo_rank1["Script Arg1"] / 100
  local noAF = 0
  for _, phase in ipairs(skill.phase_list) do
    noAF = noAF + #phase.event_list
  end
  if skill.attack_counter == 1 then
    skill.UrsaHp = source.hp
  end
  if not skill.UrsaHp then
    return basefunc(skill, source, target, damage_type), 1
  else
    local dmgratio = math.min(math.floor(skill.UrsaHp * ratio), skill.evo_rank1["Script Arg2"])
    return basefunc(skill, source) + dmgratio, 1
  end
end

function Ursa.init_hero(hero)
  local skillult = hero.skills.Ursa_ult
  local skillatk2 = hero.skills.Ursa_atk2
  local skillatk = hero.skills.Ursa_atk
  local count1, count2
  for i, skillinfo in ipairs(hero.passive_skill_list) do
    if skillinfo["Skill Name"] == "Ursa_pasv" then
      count1 = i
    end
  end
  for i, skillinfo in ipairs(hero.passive_skill_list) do
    if skillinfo["Skill Name"] == "Ursa_pasv2" then
      count2 = i
    end
  end
  local skillpasv = hero.passive_skill_list[count1]
  local skillpasv2 = hero.passive_skill_list[count2]
  if skillult then
    if skillult.evo_rank and skillult.evo_rank >= 1 then
      skillult.power = override(skillult.power, Ursa.skillult_power)
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
      skillatk2.info = ed.wraptable(skillatk2.info, {
        ["Plus Ratio"] = skillatk2.evo_rank3["Script Arg1"]
      })
    end
  end
  if skillpasv then
    local aname = skillpasv["Passive Attr"]
    if skillpasv.evo_rank and skillpasv.evo_rank >= 1 then
      skillpasv["Basic Num"] = skillpasv["Basic Num"] + skillpasv.evo_rank1["Script Arg1"]
    end
    if skillpasv.evo_rank and skillpasv.evo_rank >= 2 then
      skillpasv["Basic Num"] = skillpasv["Basic Num"] + skillpasv.evo_rank2["Script Arg1"]
    end
    if skillpasv.evo_rank and skillpasv.evo_rank >= 3 and skillatk then
      skillatk.info = ed.wraptable(skillatk.info, {
        CD = 1.8,
        ["Global CD"] = 1.5
      })
    end
    hero:rebuild()
  end
  if skillpasv2 then
    local aname = skillpasv2["Passive Attr"]
    if skillpasv2.evo_rank and skillpasv2.evo_rank >= 1 then
      skillpasv2["Basic Num"] = skillpasv2["Basic Num"] + skillpasv2.evo_rank1["Script Arg1"]
    end
    if skillpasv2.evo_rank and skillpasv2.evo_rank >= 2 then
      skillpasv2["Basic Num"] = skillpasv2["Basic Num"] + skillpasv2.evo_rank2["Script Arg1"]
    end
    if skillpasv2.evo_rank and skillpasv2.evo_rank >= 3 then
      skillpasv2["Basic Num"] = skillpasv2["Basic Num"] + skillpasv2.evo_rank3["Script Arg1"]
    end
    hero:rebuild()
  end
  return hero
end

return Ursa.init_hero
