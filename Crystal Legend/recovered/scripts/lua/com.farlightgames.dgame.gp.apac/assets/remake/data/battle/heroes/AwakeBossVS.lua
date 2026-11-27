module("ed.battlehero", package.seeall)
local ed = ed
AwakeBossVS = {}
AwakeBossVS.ult = 12005401
AwakeBossVS.ultEvobuff = 12005402

function AwakeBossVS.skillult_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  if skill.evo_rank and skill.evo_rank >= 2 then
    local bid = AwakeBossVS.ultEvobuff
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, caster, caster)
    caster:addBuff(buff, caster)
  end
  local bid = 12005406
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = ed.BuffCreate(binfo, caster, caster)
  caster:addBuff(buff, caster)
end

function AwakeBossVS.skillult_takeEffectOn(basefunc, skill, target)
  basefunc(skill, target)
  if skill.evo_rank and skill.evo_rank >= 1 and skill.info["Cost MP"] == skill.evo_rank1["Script Arg1"] then
    skill.info = ed.wraptable(skill.info, {
      ["Cost MP"] = 1000
    })
  end
  local targetp = {
    target.position[1],
    target.position[2]
  }
  local casterp = {
    skill.caster.position[1],
    skill.caster.position[2]
  }
  local caster = skill.caster
  if not target.buff_effects.stable then
    local bid = AwakeBossVS.ult
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, target, caster)
    buff:setAttribute("HAST", -skill.info["Script Arg2"])
    buff:setAttribute("MSPD", -skill.info["Script Arg2"])
    buff:setAttribute("PIMU", -skill.info["Script Arg3"])
    target:addBuff(buff, skill.caster)
    skill.caster.position = targetp
    target.position = casterp
    target:hurt()
    local skillatk2 = skill.caster.skills.AwakeBossVS_atk2
    if skill.evo_rank and skill.evo_rank >= 3 and skillatk2 then
      skillatk2.target = target
      local projectile = skillatk2:createProjectile()
      projectile:enableTrack(target)
      ed.engine:addProjectile(projectile)
    end
  else
    local color = target.camp == ed.emCampEnemy and "red" or "blue"
    if target.actor then
      ed.PopupCreate("miss", color, target.actor, nil, "text")
    end
  end
end

function AwakeBossVS.skillult_onAttackFrame(basefunc, skill)
  if skill.target and skill.target.buff_effects.untargetable then
    skill:selectTarget(nil)
  end
  basefunc(skill)
end

function AwakeBossVS.skillatk2_createBuff(basefunc, skill, target)
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

function AwakeBossVS.skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local arm = buff.info.ARM
  if skill.evo_rank and skill.evo_rank >= 3 then
    buff:setAttribute("ARM", arm - skill.evo_rank3["Script Arg1"])
  end
  return buff
end

function AwakeBossVS.hero_handleUnitDieEvent(basefunc, self, unit, killer_unit)
  basefunc(self, unit, killer_unit)
  local skillaura = self.aura_skill_list[1]
  if skillaura and skillaura.evo_rank and skillaura.evo_rank >= 3 and unit and self:isAlive() and killer_unit and not unit.config.is_summoned and unit.camp == self.camp and killer_unit.camp ~= self.camp and not killer_unit.buff_effects.invulnerable then
    local bid = 12005405
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, killer_unit, self)
    buff:setAttribute("AD", math.min(0, -(skillaura.evo_rank3["Script Arg1"] / 100) * killer_unit.attribs.AD))
    killer_unit:addBuff(buff, self)
  end
end

function AwakeBossVS.onDying(basefunc, self, killer)
  local skillaura = self.aura_skill_list[1]
  if killer and killer.camp ~= self.camp and skillaura and skillaura.evo_rank and skillaura.evo_rank >= 3 and not killer.buff_effects.invulnerable then
    local bid = 12005405
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, killer, self)
    buff:setAttribute("AD", math.min(0, -(skillaura.evo_rank3["Script Arg1"] / 100) * killer.attribs.AD))
    killer:addBuff(buff, self)
  end
  basefunc(self, killer)
end

function AwakeBossVS.reset(basefunc, unit)
  basefunc(unit)
  local skillult = unit.skills.AwakeBossVS_ult
  if skillult.evo_rank and skillult.evo_rank >= 1 then
    skillult.info = ed.wraptable(skillult.info, {
      ["Cost MP"] = skillult.evo_rank1["Script Arg1"]
    })
  end
end

function AwakeBossVS.init_hero(hero)
  local skillult = hero.skills.AwakeBossVS_ult
  local skillatk = hero.skills.AwakeBossVS_atk
  local skillatk2 = hero.skills.AwakeBossVS_atk2
  local skillatk3 = hero.skills.AwakeBossVS_atk3
  local skillaura = hero.aura_skill_list[1]
  hero.reset = override(hero.reset, AwakeBossVS.reset)
  if skillult then
    skillult.takeEffectOn = override(skillult.takeEffectOn, AwakeBossVS.skillult_takeEffectOn)
    skillult.onAttackFrame = override(skillult.onAttackFrame, AwakeBossVS.skillult_onAttackFrame)
    skillult.finish = override(skillult.finish, AwakeBossVS.skillult_finish)
    if skillult.evo_rank and 1 <= skillult.evo_rank then
      skillult.info = ed.wraptable(skillult.info, {
        ["Cost MP"] = skillult.evo_rank1["Script Arg1"]
      })
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
        ["No Dodge"] = true
      })
    end
    if skillatk2.evo_rank and skillatk2.evo_rank >= 3 then
      skillatk2.createBuff = override(skillatk2.createBuff, AwakeBossVS.skillatk2_createBuff)
    end
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
    if skillatk3.evo_rank and skillatk3.evo_rank >= 3 then
      skillatk3.createBuff = override(skillatk3.createBuff, AwakeBossVS.skillatk3_createBuff)
    end
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
      hero.handleUnitDieEventToAll = override(hero.handleUnitDieEventToAll, AwakeBossVS.hero_handleUnitDieEvent)
      hero.onDying = override(hero.onDying, AwakeBossVS.onDying)
    end
  end
  return hero
end

return AwakeBossVS.init_hero
