module("ed.battlehero", package.seeall)
local ed = ed
Troll = {}
Troll.skillatk3_attack_range = 0

function Troll.walkTo(basefunc, ai, dest)
  local owner = ai.owner
  local old_range = owner.attack_range
  if dest.what == "Unit" and dest.info["Position Type"] ~= T("\229\137\141\230\142\146") then
    owner.attack_range = Troll.skillatk3_attack_range
  end
  basefunc(ai, dest)
  owner.attack_range = old_range
end

function Troll.skillatk3_canCastWithTarget(basefunc, skill, target)
  local result, reson = basefunc(skill, target)
  local caster = skill.caster
  local skillatk = caster.skills.Troll_atk
  if result then
    caster.basic_skill = skill
    return result
  elseif reson == "cd" then
    local distanceSQ = ed.edpDistanceSQ(target.position, caster.position)
    if distanceSQ >= skill.min_range_sq and distanceSQ <= skill.max_range_sq then
      caster.basic_skill = skill
      skillatk:pause()
    end
  elseif reson == "doom" then
    local distanceSQ = ed.edpDistanceSQ(target.position, caster.position)
    if distanceSQ >= skill.min_range_sq and distanceSQ <= skill.max_range_sq then
      caster.basic_skill = skill
      skillatk:pause()
    end
  else
    caster.basic_skill = skillatk
    skillatk:resume()
  end
end

function Troll.onDying(basefunc, hero, killer)
  local skillult = hero.skills.Troll_ult
  if skillult then
    if skillult.evo_rank and skillult.evo_rank >= 3 and hero.ultEvobuff and hero.ultEvocount then
      hero.hp = 1
    else
      basefunc(hero, killer)
    end
  end
end

function Troll.skillult_buff_onRemoved(basefunc, buff)
  basefunc(buff)
  local hero = buff.caster
  if buff.owner == hero then
    hero.ultEvobuff = false
    hero.ultEvocount = false
  end
end

function Troll.reset(basefunc, hero)
  basefunc(hero)
  hero.ultEvobuff = false
  hero.ultEvocount = true
  local skillatk2 = hero.skills.Troll_atk2
  if skillatk2 then
    local originfo2 = skillatk2.info
    if hero.fashion_id and (hero.fashion_id == 411 or hero.fashion_id == 412) then
      skillatk2.info = ed.wraptable(originfo2, {
        ["Point Effect"] = "eff_tile_Troll_atk3_1.cha"
      })
    end
  end
  local skillatk = hero.skills.Troll_atk
  if skillatk then
    local originfo1 = skillatk.info
    if hero.fashion_id and (hero.fashion_id == 411 or hero.fashion_id == 412) then
      skillatk.info = ed.wraptable(originfo1, {
        ["Tile Art"] = "eff_tile_Troll_atk_1.cha"
      })
    end
  end
end

function Troll.skillult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local buffInfo = buff.info
  local owner = buff.owner
  local caster = buff.caster
  if skill.evo_rank and skill.evo_rank >= 1 then
    buff.timer = skill.evo_rank1["Script Arg1"]
  end
  local hast = buff.info.HAST
  local mspd = buff.info.MSPD
  if skill.evo_rank and skill.evo_rank >= 2 then
    buff:setAttribute("HAST", hast + skill.evo_rank2["Script Arg1"])
    buff:setAttribute("MSPD", mspd + skill.evo_rank2["Script Arg1"])
  end
  if skill.evo_rank and skill.evo_rank >= 3 and buff then
    caster.ultEvobuff = true
    buff.onRemoved = override(buff.onRemoved, Troll.skillult_buff_onRemoved)
  end
  return buff
end

function Troll.init_hero(hero)
  hero.reset = override(hero.reset, Troll.reset)
  local skillult = hero.skills.Troll_ult
  local skillatk = hero.skills.Troll_atk
  local skillatk2 = hero.skills.Troll_atk2
  local skillatk3 = hero.skills.Troll_atk3
  local skillpasv = hero.passive_skill_list[1]
  if skillult then
    skillult.createBuff = override(skillult.createBuff, Troll.skillult_createBuff)
    if skillult.evo_rank and skillult.evo_rank >= 3 then
      hero.onDying = override(hero.onDying, Troll.onDying)
    end
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
    if skillatk2.evo_rank and skillatk2.evo_rank >= 3 then
      skillatk2.info = ed.wraptable(skillatk2.info, {
        ["Plus Ratio"] = skillatk2.evo_rank3["Script Arg1"]
      })
    end
  end
  if skillatk3 and hero.name == "Troll" then
    if skillatk then
      skillatk.info = ed.wraptable(skillatk.info, {
        ["Plus Ratio"] = 1.3
      })
    end
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
      skillatk3.info = ed.wraptable(skillatk3.info, {
        ["Plus Ratio"] = skillatk3.evo_rank3["Script Arg1"]
      })
    end
    Troll.skillatk3_attack_range = skillatk3.info["Max Range"]
    hero.ai.walkTo = override(hero.ai.walkTo, Troll.walkTo)
    skillatk3.canCastWithTarget = override(skillatk3.canCastWithTarget, Troll.skillatk3_canCastWithTarget)
  end
  if skillpasv then
    local aname = skillpasv["Passive Attr"]
    skillatk.info = ed.wraptable(skillatk.info, {
      CD = 3 - skillpasv["Script Arg2"],
      ["Global CD"] = 3 - skillpasv["Script Arg2"]
    })
    skillatk3.info = ed.wraptable(skillatk3.info, {
      CD = 2.5 - skillpasv["Script Arg3"],
      ["Global CD"] = 2.5 - skillpasv["Script Arg3"]
    })
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

return Troll.init_hero
