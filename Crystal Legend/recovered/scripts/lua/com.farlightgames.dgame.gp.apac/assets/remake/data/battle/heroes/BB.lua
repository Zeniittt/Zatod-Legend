module("ed.battlehero", package.seeall)
local ed = ed
BB = {}
BB.damagePercentCast = 0.2

function BB.skillatk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local buffInfo = buff.info
  local owner = buff.owner
  local caster = buff.caster
  local attribName = buffInfo.Tenacity
  local TEN_final = ed.Buff.getTenValue(buffInfo, owner, caster)
  local ARM = buffInfo.ARM
  if skill.evo_rank and skill.evo_rank >= 1 then
    buff:setAttribute("ARM", ARM - skill.evo_rank1["Script Arg1"])
  end
  if skill.evo_rank and skill.evo_rank >= 2 then
    buff:setAttribute("ARM", ARM - skill.evo_rank1["Script Arg1"] - skill.evo_rank2["Script Arg1"])
  end
  if skill.evo_rank and skill.evo_rank >= 3 then
    buff.timer = skill.evo_rank3["Script Arg1"] * math.max(0.01, 1 - TEN_final / 100)
  end
  return buff
end

function BB.skillult_canCastWithTarget(basefunc, skill, target)
  if skill.caster.ultBuff_BB then
    return false, "ult"
  end
  return basefunc(skill, target)
end

function BB.skillult_buffOnRemoved(basefunc, buff)
  local caster = buff.caster
  if caster.changePeriod_BB then
    caster:enterActionStageFromOneStage(caster:BBGetNormalPeriod(), 49)
    caster.changePeriod_BB = nil
    caster.ultBuff_BB = false
  end
  basefunc(buff)
end

function BB.skillult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = buff.caster
  buff.onRemoved = override(buff.onRemoved, BB.skillult_buffOnRemoved)
  local ultpimumimu = buff.info.PIMU
  if skill.evo_rank and skill.evo_rank >= 1 then
    ultpimumimu = ultpimumimu + skill.evo_rank1["Script Arg1"]
    buff:setAttribute("PIMU", ultpimumimu)
    buff:setAttribute("MIMU", ultpimumimu)
  end
  if skill.evo_rank and skill.evo_rank >= 2 then
    ultpimumimu = ultpimumimu + skill.evo_rank2["Script Arg1"]
    buff:setAttribute("PIMU", ultpimumimu)
    buff:setAttribute("MIMU", ultpimumimu)
  end
  skill.caster.ultBuff_BB = ultpimumimu
  if skill.evo_rank and skill.evo_rank >= 3 then
    buff:setAttribute("HPR", (skill.evo_rank3["Script Arg1"] + skill.evo_rank3["Script Arg2"] / 100 * caster.attribs.HP) * (1 + caster.attribs.HEAL / 100))
  end
  return buff
end

function BB.skillult_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  caster.changePeriod_BB = true
end

function BB.skillult_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  if caster.changePeriod_BB then
    caster:enterActionStageFromOneStage(caster:BBGetUltPeriod(), 49)
  end
end

function BB.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  local skillatk3 = hero.skills.BB_atk3
  local damagepercent = BB.damagePercentCast
  if skillatk3 and skillatk3.evo_rank and skillatk3.evo_rank >= 3 then
    damagepercent = skillatk3.evo_rank3["Script Arg1"] / 100
  end
  if skillatk3 and hero.totalDamage_BB and hero.totalDamage_BB >= hero.attribs.HP * damagepercent and hero:isAlive() then
    skillatk3:takeEffectAt(hero.position, hero)
    hero:setMP(hero.mp + skillatk3.info["Gain MP"] * ed.engine.mp_bonus)
    hero.totalDamage_BB = hero.totalDamage_BB - hero.attribs.HP * damagepercent
    ed.engine:collectSkill(skillatk3.caster, skillatk3, 1)
  end
end

function BB.getLostHPAfterImmunity(basefunc, hero, damage, immunity)
  local skillatk3 = hero.skills.BB_atk3
  if skillatk3 then
    hero.totalDamage_BB = hero.totalDamage_BB and hero.totalDamage_BB + damage or damage
  end
  return basefunc(hero, damage, immunity)
end

function BB.hero_takeDamage(basefunc, self, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
  if self.ultBuff_BB then
    local direct = type(struct_table) == "table" and struct_table.source.direction or source.direction
    if direct == self.direction then
      local temp = self.attribs.PIMU
      local temp2 = self.attribs.MIMU
      self.attribs.PIMU = self.attribs.PIMU - self.ultBuff_BB
      self.attribs.MIMU = self.attribs.MIMU - self.ultBuff_BB
      local dmg = basefunc(self, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
      self.attribs.PIMU = temp
      self.attribs.MIMU = temp
      return dmg
    end
  end
  return basefunc(self, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
end

function BB.init_hero(hero)
  local skillult = hero.skills.BB_ult
  local skillatk2 = hero.skills.BB_atk2
  local skillatk3 = hero.skills.BB_atk3
  local skillpasv = hero.passive_skill_list[1]
  if hero.name == "BB" then
    hero.takeDamage = override(hero.takeDamage, BB.hero_takeDamage)
    hero.getLostHPAfterImmunity = override(hero.getLostHPAfterImmunity, BB.getLostHPAfterImmunity)
    hero.update = override(hero.update, BB.hero_update)
  end
  hero:setActionStageChangeByManual(true)
  if skillult then
    skillult.createBuff = override(skillult.createBuff, BB.skillult_createBuff)
    skillult.onAttackFrame = override(skillult.onAttackFrame, BB.skillult_onAttackFrame)
    skillult.finish = override(skillult.finish, BB.skillult_finish)
    skillult.canCastWithTarget = override(skillult.canCastWithTarget, BB.skillult_canCastWithTarget)
  end
  if skillatk2 then
    skillatk2.createBuff = override(skillatk2.createBuff, BB.skillatk2_createBuff)
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
  
  function hero.BBGetNormalPeriod(unit)
    return 1
  end
  
  function hero.BBGetUltPeriod(unit)
    return 2
  end
  
  return hero
end

return BB.init_hero
