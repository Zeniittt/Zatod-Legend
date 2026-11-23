module("ed.battlehero", package.seeall)
local ed = ed
Bone = {}

function Bone.skillatk2_takeEffectOn(basefunc, self, target, source, shift)
  local ret, dmg, Crit, lfs_amount = basefunc(self, target, source, shift)
  if ret then
    if target.Bone_Evoatk2_count then
      target.Bone_Evoatk2_count = target.Bone_Evoatk2_count + 1
    else
      target.Bone_Evoatk2_count = 1
    end
  end
  return ret, dmg, Crit, lfs_amount
end

function Bone.skillatk2_power(basefunc, self, source, target, damage_type)
  local power, i = basefunc(self, source, target, damage_type)
  if target.Bone_Evoatk2_count then
    local caster = self.caster
    if self.evo_rank and self.evo_rank >= 1 and target.Bone_Evoatk2_count then
      local times = math.min(self.evo_rank1["Script Arg2"], target.Bone_Evoatk2_count)
      local evoatkratio = self.evo_rank1["Script Arg1"] / 100
      power = power * (1 + evoatkratio * times)
    end
  end
  return power, i
end

function Bone.skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local buffInfo = buff.info
  local owner = buff.owner
  local caster = buff.caster
  local hast = buffInfo.HAST
  if skill.evo_rank and skill.evo_rank >= 1 then
    buff:setAttribute("HAST", hast + skill.evo_rank1["Script Arg1"])
  end
  if skill.evo_rank and skill.evo_rank >= 2 then
    buff:setAttribute("HAST", hast + skill.evo_rank1["Script Arg1"] + skill.evo_rank2["Script Arg1"])
  end
  if skill.evo_rank and skill.evo_rank >= 3 then
    buff.timer = skill.evo_rank3["Script Arg1"]
  end
  return buff
end

function Bone.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  if skill.evo_rank and skill.evo_rank >= 3 then
    local bid = 10001703
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, caster, caster)
    local ShieldIncrease = 0
    local ShieldWeak = 0
    if caster.attribs.ShieldIncrease then
      ShieldIncrease = caster.attribs.ShieldIncrease
    end
    if caster.attribs.ShieldWeak then
      ShieldWeak = caster.attribs.ShieldWeak
    end
    local shieldratio = math.max(0.01, 1 + (ShieldIncrease - ShieldWeak) / 100)
    buff.shield = (skill.evo_rank3["Script Arg2"] + skill.evo_rank3["Script Arg3"] * caster.attribs.AP) * (caster.config.hp_mod or 1) * shieldratio
    caster:addBuff(buff, caster)
  end
end

function Bone.skillult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local AD = buff.info.AD
  if skill.evo_rank and skill.evo_rank >= 1 then
    buff:setAttribute("AD", AD + skill.evo_rank1["Script Arg1"])
  end
  if skill.evo_rank and skill.evo_rank >= 2 then
    buff:setAttribute("AD", AD + skill.evo_rank1["Script Arg1"] + skill.evo_rank2["Script Arg1"])
  end
  return buff
end

function Bone.init_hero(hero)
  local skillult = hero.skills.Bone_ult
  local skillatk2 = hero.skills.Bone_atk2
  local skillatk3 = hero.skills.Bone_atk3
  local skillpasv = hero.passive_skill_list[1]
  if skillatk2 then
    if skillatk2.evo_rank and 1 <= skillatk2.evo_rank then
      skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, Bone.skillatk2_takeEffectOn)
      skillatk2.power = override(skillatk2.power, Bone.skillatk2_power)
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
    skillatk3.createBuff = override(skillatk3.createBuff, Bone.skillatk3_createBuff)
  end
  if skillult then
    skillult.start = override(skillult.start, Bone.skillult_start)
    skillult.createBuff = override(skillult.createBuff, Bone.skillult_createBuff)
    if skillult.evo_rank and skillult.evo_rank >= 3 then
      skillult.info = ed.wraptable(skillult.info, {
        ["Plus Ratio"] = skillult.evo_rank3["Script Arg1"]
      })
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

return Bone.init_hero
