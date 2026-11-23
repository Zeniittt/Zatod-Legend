module("ed.battlehero", package.seeall)
local ed = ed
Razor = {}
Razor.atk3selfbuff = 10000502
Razor.ult_shard = 10000504

function Razor.skillult_takeEffectOn(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local info = skill.info
  local bid = Razor.ult_shard
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = ed.BuffCreate(binfo, target, caster)
  target:addBuff(buff, caster)
end

function Razor.skillatk3_takeEffectOn(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local info = skill.info
  local bid = Razor.atk3selfbuff
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = ed.BuffCreate(binfo, caster, caster)
  local AD = -info.buff_info.AD
  if skill.evo_rank and skill.evo_rank >= 1 then
    buff:setAttribute("HAST", skill.evo_rank1["Script Arg1"])
  end
  if skill.evo_rank and skill.evo_rank >= 2 then
    AD = AD + skill.evo_rank2["Script Arg1"]
  end
  if skill.evo_rank and skill.evo_rank >= 3 then
    AD = AD + skill.evo_rank3["Script Arg1"]
  end
  local shard = caster.proto._shard
  if shard and shard._id == 1000051 and caster.shardSkillRank and 2 <= caster.shardSkillRank then
    AD = AD + (skill.razor_atk3_shardAD and skill.razor_atk3_shardAD or 0)
  end
  buff:setAttribute("AD", AD)
  local skillatk = caster.skills.Razor_atk
  skillatk:takeEffectOn(target)
  caster:addBuff(buff, caster)
end

function Razor.skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local AD = buff.info.AD
  if skill.evo_rank and skill.evo_rank >= 1 then
    buff:setAttribute("HAST", -skill.evo_rank1["Script Arg1"])
  end
  if skill.evo_rank and skill.evo_rank >= 2 then
    AD = AD - skill.evo_rank2["Script Arg1"]
  end
  if skill.evo_rank and skill.evo_rank >= 3 then
    AD = AD - skill.evo_rank3["Script Arg1"]
  end
  local shard = caster.proto._shard
  if shard and shard._id == 1000051 and caster.shardSkillRank and 2 <= caster.shardSkillRank then
    if target.attribs.AD >= 0 then
      skill.razor_atk3_shardAD = math.min(caster.shardSkill[2]["Script Arg1"] / 100 * target.attribs.AD, caster.shardSkill[2]["Script Arg2"] / 100 * caster.attribs.AD)
    else
      skill.razor_atk3_shardAD = 0
    end
    AD = AD - (skill.razor_atk3_shardAD and skill.razor_atk3_shardAD or 0)
  end
  buff:setAttribute("AD", AD)
  return buff
end

function Razor.hero_takeDamage(basefunc, self, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
  local lost = basefunc(self, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
  local dt = damage_type or struct_table.damage_type
  local s = source or struct_table.source
  local skillshard3 = self.skills.Razor_shard3
  local skillpasv = self.passive_skill_list[1]
  local shard = self.proto._shard
  if lost then
    if skillpasv and skillpasv.evo_rank and 1 <= skillpasv.evo_rank and dt == "AP" and 0 < lost and s and s:isAlive() then
      local skillpasv = self.passive_skill_list[1]
      if skillpasv.evo_rank and 1 <= skillpasv.evo_rank then
        s:takeDamage(skillpasv.evo_rank1["Script Arg1"], "Holy", "mp", self, 1, 1, true)
      end
    end
    if shard and shard._id == 1000051 and self.shardSkillRank and self.shardSkillRank >= 3 then
      local p = self.shardSkill[3]["Script Arg1"] / 100
      if 0 < lost and p >= ed.rand() and s then
        if skillshard3 and s.config.is_summoned and s.buff_effects.invulnerable then
          if s.config.summoner then
            skillshard3:takeEffectOn(s.config.summoner, self)
          end
        elseif s.buff_effects.invulnerable and s.DGultToAWultUnit and s.DGultToAWultUnit:isAlive() then
          skillshard3:takeEffectOn(s.DGultToAWultUnit, self)
        else
          skillshard3:takeEffectOn(s, self)
        end
      end
    end
  end
  return lost
end

function Razor.init_hero(hero)
  local skillult = hero.skills.Razor_ult
  local skillatk2 = hero.skills.Razor_atk2
  local skillatk3 = hero.skills.Razor_atk3
  local skillpasv = hero.passive_skill_list[1]
  local skillshard3 = hero.skills.Razor_shard3
  local shard = hero.proto._shard
  if skillshard3 then
    skillshard3.info = ed.wraptable(skillshard3.info, {
      ["No Dodge"] = true
    })
  end
  hero.takeDamage = override(hero.takeDamage, Razor.hero_takeDamage)
  if skillpasv then
    local aname = skillpasv["Passive Attr"]
    if skillpasv.evo_rank and skillpasv.evo_rank >= 2 then
      skillpasv["Basic Num"] = skillpasv["Basic Num"] + skillpasv.evo_rank2["Script Arg1"]
    end
    if skillpasv.evo_rank and skillpasv.evo_rank >= 3 then
      skillpasv["Basic Num"] = skillpasv["Basic Num"] + skillpasv.evo_rank3["Script Arg1"]
    end
    hero:rebuild()
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
      skillult.info = ed.wraptable(skillult.info, {
        ["Plus Ratio"] = skillult.evo_rank3["Script Arg1"]
      })
    end
    if shard and shard._id == 1000051 and hero.shardSkillRank and 1 <= hero.shardSkillRank then
      skillult.info = ed.wraptable(skillult.info, {
        ["No Dodge"] = true
      })
      skillult.takeEffectOn = override(skillult.takeEffectOn, Razor.skillult_takeEffectOn)
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
  if skillatk3 then
    skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, Razor.skillatk3_takeEffectOn)
    skillatk3.createBuff = override(skillatk3.createBuff, Razor.skillatk3_createBuff)
  end
  return hero
end

return Razor.init_hero
