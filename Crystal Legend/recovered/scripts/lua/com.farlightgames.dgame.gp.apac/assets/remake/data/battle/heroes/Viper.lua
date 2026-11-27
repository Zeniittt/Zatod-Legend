module("ed.battlehero", package.seeall)
local ed = ed
Viper = {}
Viper.pasvEvobuff = 10003703
Viper.shardbuff = 10003704
Viper.shardultbuff = 10003705

function Viper.skillult_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  if not skill.target then
    return
  end
  projectile:enableTrack(skill.target)
  return projectile
end

function Viper.skillatk_takeEffectOn(basefunc, skill, target)
  local caster = skill.caster
  local skillpasv2 = caster.skills.Viper_pasv2
  if skillpasv2 then
    local HPloss = 1 - target.hp / target.attribs.HP
    local LowPower = skillpasv2.info["Basic Num"]
    local Powermax = skillpasv2.info["Script Arg2"]
    if skill.evo_rank and 1 <= skill.evo_rank then
      LowPower = LowPower + skill.evo_rank1["Script Arg1"]
    end
    if skill.evo_rank and skill.evo_rank >= 2 then
      Powermax = Powermax + skill.evo_rank2["Script Arg1"]
    end
    local Power = HPloss * Powermax
    if LowPower > Power then
      Power = LowPower
    end
    skill.info = ed.wraptable(skill.info, {
      ["Basic Num"] = Power
    })
    basefunc(skill, target)
  end
  if not skillpasv2 then
    basefunc(skill, target)
  end
end

function Viper.skillult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  local caster = buff.caster
  if skill.evo_rank and skill.evo_rank >= 3 then
    buff:setAttribute("HPR", buff.info.HPR - skill.evo_rank3["Script Arg1"])
  end
  local shard = caster.proto._shard
  if shard and shard._id == 1000371 and caster.shardSkillRank and caster.shardSkillRank >= 2 then
    local bid = Viper.shardultbuff
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, owner, caster)
    owner:addBuff(buff, caster)
  end
  return buff
end

function Viper.skillatk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local buffInfo = buff.info
  local owner = buff.owner
  local caster = buff.caster
  local casterap = caster.attribs.AP
  local hpr = buff.info.HPR
  if skill.evo_rank and skill.evo_rank >= 3 then
    buff:setAttribute("HPR", hpr - skill.evo_rank3["Script Arg1"] * casterap)
  end
  return buff
end

function Viper.skillatk2_takeEffectOn(basefunc, skill, target)
  local caster = skill.caster
  local skillpasv2 = caster.skills.Viper_pasv2
  local oribn = skill.info["Basic Num"]
  if skillpasv2 then
    local HPloss = 1 - target.hp / target.attribs.HP
    local LowPower = skillpasv2.info["Basic Num"]
    local Powermax = skillpasv2.info["Script Arg2"]
    if skill.evo_rank and 1 <= skill.evo_rank then
      LowPower = LowPower + skill.evo_rank1["Script Arg1"]
    end
    if skill.evo_rank and skill.evo_rank >= 2 then
      Powermax = Powermax + skill.evo_rank2["Script Arg1"]
    end
    local Power = HPloss * Powermax
    if LowPower > Power then
      Power = LowPower
    end
    local oriinfo = skill.info
    skill.info = ed.wraptable(oriinfo, {
      ["Basic Num"] = Power + oribn
    })
    basefunc(skill, target)
    skill.info = oriinfo
  end
  if not skillpasv2 then
    basefunc(skill, target)
  end
end

function Viper.hero_takeDamage(basefunc, self, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
  local lost = basefunc(self, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
  local dt = damage_type or struct_table.damage_type
  local s = source or struct_table.source
  local skillpasv = self.passive_skill_list[1]
  local shard = self.proto._shard
  if lost and dt == "AD" and 0 < lost and s and s:isAlive() and not s.buff_effects.invulnerable then
    if skillpasv and skillpasv.evo_rank and skillpasv.evo_rank >= 3 then
      local bid = Viper.pasvEvobuff
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, s, self)
      s:addBuff(buff, self)
    end
    if shard and shard._id == 1000371 and self.shardSkillRank and 1 <= self.shardSkillRank then
      local Distance = 200
      local DSQ = ed.edpDistanceSQ(s.position, self.position)
      if DSQ < Distance ^ 2 and self:isAlive() then
        local bid = Viper.shardbuff
        local binfo = ed.lookupDataTable("Buff", nil, bid)
        local buff = ed.BuffCreate(binfo, s, self)
        if 0 < s.attribs.AD then
          buff:setAttribute("AD", self.shardSkill[1]["Script Arg1"] / 100 * s.attribs.AD)
        end
        if 0 < s.attribs.ARM then
          buff:setAttribute("ARM", self.shardSkill[1]["Script Arg2"] / 100 * s.attribs.ARM)
        end
        s:addBuff(buff, self)
      end
    end
  end
  return lost
end

function Viper.init_hero(hero)
  local skillult = hero.skills.Viper_ult
  local skillatk = hero.skills.Viper_atk
  local skillatk2 = hero.skills.Viper_atk2
  local skillpasv = hero.passive_skill_list[1]
  local skillpasv2 = hero.skills.Viper_pasv2
  local shard = hero.proto._shard
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
    skillult.createBuff = override(skillult.createBuff, Viper.skillult_createBuff)
    skillult.createProjectile = override(skillult.createProjectile, Viper.skillult_createProjectile)
  end
  if skillatk then
    skillatk.takeEffectOn = override(skillatk.takeEffectOn, Viper.skillatk_takeEffectOn)
    if skillpasv2 and skillpasv2.evo_rank and skillpasv2.evo_rank >= 3 then
      skillatk.info = ed.wraptable(skillatk.info, {
        ["Gain MP"] = 150
      })
    end
    if shard and shard._id == 1000371 and hero.shardSkillRank and 3 <= hero.shardSkillRank then
      skillatk.info = ed.wraptable(skillatk.info, {
        CD = 999,
        ["Global CD"] = 999,
        ["Init CD"] = 999
      })
      skillatk.cd_remaining = 999
    end
  end
  if skillatk2 then
    skillatk2.createBuff = override(skillatk2.createBuff, Viper.skillatk2_createBuff)
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
    if shard and shard._id == 1000371 and hero.shardSkillRank and 3 <= hero.shardSkillRank then
      hero.basic_skill = skillatk2
      skillatk2.info = ed.wraptable(skillatk2.info, {
        CD = 3,
        ["Global CD"] = 3,
        ["Init CD"] = 0
      })
      skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, Viper.skillatk2_takeEffectOn)
      if skillpasv2 and skillpasv2.evo_rank and skillpasv2.evo_rank >= 3 then
        skillatk2.info = ed.wraptable(skillatk2.info, {
          ["Gain MP"] = 150
        })
      end
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
    hero:rebuild()
  end
  hero.takeDamage = override(hero.takeDamage, Viper.hero_takeDamage)
  return hero
end

return Viper.init_hero
