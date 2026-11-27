module("ed.battlehero", package.seeall)
local ed = ed
GuildMountOK = {}

function GuildMountOK.skillult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = buff.caster
  local owner = buff.owner
  local Shield = buff.info["Shield Value"]
  local ShieldIncrease = 0
  local ShieldWeak = 0
  if owner.attribs.ShieldIncrease then
    ShieldIncrease = owner.attribs.ShieldIncrease
  end
  if owner.attribs.ShieldWeak then
    ShieldWeak = owner.attribs.ShieldWeak
  end
  local shieldratio = math.max(0.01, 1 + (ShieldIncrease - ShieldWeak) / 100)
  if skill.evo_rank and 1 <= skill.evo_rank then
    buff.shield = buff.shield + skill.evo_rank1["Script Arg1"] * (caster.config.hp_mod or 1) * shieldratio
  end
  if skill.evo_rank and skill.evo_rank >= 2 then
    buff.shield = buff.shield + skill.evo_rank2["Script Arg1"] * (caster.config.hp_mod or 1) * shieldratio
  end
  if skill.evo_rank and skill.evo_rank >= 3 then
    buff.shield = buff.shield + skill.evo_rank3["Script Arg1"] * (caster.config.hp_mod or 1) * shieldratio
  end
  return buff
end

function GuildMountOK.skillatk2_takeEffectOn(basefunc, skill, target, source, shift)
  local isHit, dmg = basefunc(skill, target, source, shift)
  local power = skill:power(source, target)
  local ratio = skill.evo_rank3["Script Arg1"] / 100
  local skillevo = skill.caster.skills.GuildMountOK_evo
  if skillevo then
    skillevo.originfo = skillevo.info
    skillevo.info = ed.wraptable(skillevo.originfo, {
      ["Basic Num"] = power * ratio
    })
    if isHit then
      skillevo:takeEffectAt(skill.target.position)
    end
    skillevo.info = skillevo.originfo
  end
  return isHit, dmg
end

function GuildMountOK.skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = buff.caster
  local owner = buff.owner
  local Shield = buff.info["Shield Value"]
  if skill.evo_rank and skill.evo_rank >= 1 then
    local owner = buff.owner
    local list = owner.buff_list
    local debuff_list = {}
    local my_camp = owner.camp
    for i = 1, #list do
      local buff = list[i]
      if buff and (not buff.caster or buff.caster.camp ~= my_camp) and buff.info.Dispel == "YES" then
        debuff_list[#debuff_list + 1] = buff
      end
    end
    for i = 1, #debuff_list do
      owner:removeBuff(debuff_list[i])
    end
  end
  local ShieldIncrease = 0
  local ShieldWeak = 0
  if owner.attribs.ShieldIncrease then
    ShieldIncrease = owner.attribs.ShieldIncrease
  end
  if owner.attribs.ShieldWeak then
    ShieldWeak = owner.attribs.ShieldWeak
  end
  local shieldratio = math.max(0.01, 1 + (ShieldIncrease - ShieldWeak) / 100)
  if skill.evo_rank and skill.evo_rank >= 2 then
    buff.shield = buff.shield + skill.evo_rank2["Script Arg1"] * (caster.config.hp_mod or 1)
  end
  if skill.evo_rank and skill.evo_rank >= 3 then
    buff.shield = buff.shield + skill.evo_rank3["Script Arg1"] * (caster.config.hp_mod or 1)
  end
  buff.shield = buff.shield * shieldratio
  return buff
end

function GuildMountOK.getLostHPAfterImmunity(basefunc, self, damage, immunity, damage_type, source, skill, field)
  local lost = basefunc(self, damage, immunity, damage_type)
  if 0 < lost and damage_type == "AD" and source then
    source:takeDamage(lost * 0.1, "Holy", "hp", self)
  end
  return lost
end

function GuildMountOK.init_hero(hero)
  local skillatk = hero.skills.GuildMountOK_atk
  local skillatk2 = hero.skills.GuildMountOK_atk2
  local skillatk3 = hero.skills.GuildMountOK_atk3
  local skillult = hero.skills.GuildMountOK_ult
  local skillaura = hero.aura_skill_list[1]
  if skillult then
    skillult.createBuff = override(skillult.createBuff, GuildMountOK.skillult_createBuff)
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
      skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, GuildMountOK.skillatk2_takeEffectOn)
    end
  end
  if skillatk3 then
    skillatk3.createBuff = override(skillatk3.createBuff, GuildMountOK.skillatk3_createBuff)
  end
  if skillaura then
    hero.getLostHPAfterImmunity = override(hero.getLostHPAfterImmunity, GuildMountOK.getLostHPAfterImmunity)
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

return GuildMountOK.init_hero
