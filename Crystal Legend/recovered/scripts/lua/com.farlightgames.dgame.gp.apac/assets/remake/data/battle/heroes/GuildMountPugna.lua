module("ed.battlehero", package.seeall)
local ed = ed
GuildMountPugna = {}
GuildMountPugna.ult = 12003001
GuildMountPugna.ult_evo = 12003003

function GuildMountPugna.skillult_takeEffectOn(basefunc, skill, target, source)
  local isHit, dmg = basefunc(skill, target)
  local caster = skill.caster
  local healpre = skill.info["Script Arg2"] / 100
  if skill.evo_rank and skill.evo_rank >= 3 then
    healpre = healpre + skill.evo_rank3["Script Arg1"] / 100
  end
  if dmg then
    caster:takeHeal(dmg * healpre, "hp", caster)
  end
  return isHit, dmg
end

function GuildMountPugna.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local bid = GuildMountPugna.ult_evo
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  caster:addBuff(binfo, caster)
end

function GuildMountPugna.skillult_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == GuildMountPugna.ult_evo then
      tbuff.timer = -1
    end
  end
end

function GuildMountPugna.skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local MIMU = buff.info.MIMU
  if skill.evo_rank and skill.evo_rank >= 1 then
    buff:setAttribute("MIMU", MIMU - skill.evo_rank1["Script Arg1"])
  end
  if skill.evo_rank and skill.evo_rank >= 2 then
    buff:setAttribute("MIMU", MIMU - skill.evo_rank1["Script Arg1"] - skill.evo_rank2["Script Arg1"])
  end
  buff.onDamaged = override(buff.onDamaged, GuildMountPugna.skillatk3_buff_onDamaged)
  return buff
end

function GuildMountPugna.skillatk3_buff_onDamaged(basefunc, self, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local final_damage = basefunc(self, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local caster = self.caster
  if damage_type ~= "AD" and damage_type ~= "Holy" then
    if not caster.Pugna_Evo_count then
      caster.Pugna_Evo_count = 1
    else
      caster.Pugna_Evo_count = caster.Pugna_Evo_count + 1
    end
  end
  return final_damage
end

function GuildMountPugna.skillatk2_power(basefunc, self, source, target, damage_type)
  local power, i = basefunc(self, source, target, damage_type)
  local caster = self.caster
  local skillatk3 = caster.skills.GuildMountPugna_atk3
  if caster.Pugna_Evo_count and skillatk3.evo_rank and skillatk3.evo_rank >= 3 then
    local times = math.min(skillatk3.evo_rank3["Script Arg2"], caster.Pugna_Evo_count)
    local atk3evoratio = skillatk3.evo_rank3["Script Arg1"] / 100
    power = power * (1 + atk3evoratio * times)
    caster.Pugna_Evo_count = 0
  end
  return power, i
end

function GuildMountPugna.init_hero(hero)
  local skillatk2 = hero.skills.GuildMountPugna_atk2
  local skillatk3 = hero.skills.GuildMountPugna_atk3
  local skillult = hero.skills.GuildMountPugna_ult
  local skillaura = hero.aura_skill_list[1]
  if skillult then
    skillult.takeEffectOn = override(skillult.takeEffectOn, GuildMountPugna.skillult_takeEffectOn)
    if skillult.evo_rank and 1 <= skillult.evo_rank then
      skillult.info = ed.wraptable(skillult.info, {
        ["Plus Ratio"] = skillult.evo_rank1["Script Arg1"]
      })
    end
    if skillult.evo_rank and skillult.evo_rank >= 2 then
      skillult.info = ed.wraptable(skillult.info, {
        ["Plus Ratio"] = skillult.evo_rank2["Script Arg1"]
      })
      skillult.start = override(skillult.start, GuildMountPugna.skillult_start)
      skillult.finish = override(skillult.finish, GuildMountPugna.skillult_finish)
    end
  end
  if skillatk2 then
    skillatk2.power = override(skillatk2.power, GuildMountPugna.skillatk2_power)
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
  if skillatk3 then
    skillatk3.createBuff = override(skillatk3.createBuff, GuildMountPugna.skillatk3_createBuff)
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

return GuildMountPugna.init_hero
