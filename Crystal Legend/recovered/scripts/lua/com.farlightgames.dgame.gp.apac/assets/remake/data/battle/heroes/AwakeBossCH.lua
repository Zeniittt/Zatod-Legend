module("ed.battlehero", package.seeall)
local ed = ed
AwakeBossCH = {}

function AwakeBossCH.skillatk2_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  local originfo = skill.info
  if attack_counter == 1 then
    skill.info = ed.wraptable(originfo, {
      ["Tile Art"] = "eff_tile_CH_atk2.cha"
    })
  end
  basefunc(skill)
  skill.info = originfo
  if skill.evo_rank and skill.evo_rank >= 3 then
    if skill.attack_counter == 3 then
      skill.info["Do Crit"] = "YES"
    else
      skill.info["Do Crit"] = nil
    end
  end
end

function AwakeBossCH.pasv2_power(basefunc, self, source, target, damage_type)
  local skill = self
  local skillcaster = skill.caster
  local caster = skill.target2
  local num = 0
  local power
  local skillult = skillcaster.skills.AwakeBossCH_ult
  local burst_power = skillult.info["Script Arg2"] / 100
  if target and target == skill.target2 then
    for unit in ed.engine:foreachAliveUnit(skill:affectedCamp()) do
      local p2 = ed.edpSub(unit.position, caster.position)
      if unit ~= caster and not unit.buff_effects.untargetable and not unit.buffManager.invisible and ed.Skill.testPointInShape(p2, "circle", 222, 0) then
        num = num + 1
      end
    end
    if 5 <= num then
      power = basefunc(self, source, target, damage_type) * 5 * burst_power
    else
      power = basefunc(self, source, target, damage_type) * num * burst_power
    end
    return power, 1
  else
    return basefunc(self, source, target, damage_type), 1
  end
end

function AwakeBossCH.buff_onRemoved(basefunc, buff)
  local owner = buff.owner
  local caster = buff.caster
  basefunc(buff)
  if buff.burst and buff.info.ID == 10008402 then
    local skill = caster.skills.AwakeBossCH_pasv2
    skill.target2 = owner
    for unit in ed.engine:foreachAliveUnit(skill:affectedCamp()) do
      local p2 = ed.edpSub(unit.position, owner.position)
      if unit ~= owner and ed.Skill.testPointInShape(p2, "circle", 220, 0) and not unit.buff_effects.invulnerable then
        local projectile = skill:createProjectile()
        projectile.position = {
          owner.position[1],
          owner.position[2]
        }
        projectile.height = 40
        projectile:enableTrack(unit)
        ed.engine:addProjectile(projectile)
      end
    end
    skill:takeEffectOn(owner)
  end
end

function AwakeBossCH.buff_update(basefunc, self, dt)
  local hpr = self.info.HPR * dt
  if hpr < 0 then
    local damage = min(-hpr, self.owner.hp)
    damage = damage * self.owner.dPSStatisticsRatio
    if self.owner ~= self.caster then
      self.caster.battledata:addDamage(damage, "HPR")
      self.owner.battledata:addBearDamage(damage)
    end
  end
  if 0 < hpr then
    self.owner.battledata:addHeal(hpr)
  end
  if self.timer then
    self.timer = self.timer - dt
    if 0 > self.timer then
      self.burst = true
      self.owner:removeBuff(self)
    end
  end
end

function AwakeBossCH.skillult_takeEffectOn(basefunc, skill, target, source)
  local caster = skill.caster
  local skillsawake = caster.skills.AwakeBossCH_sawake
  local originfo = skill.info
  local bid = 10008402
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = ed.BuffCreate(binfo, target, skill.caster)
  buff.onRemoved = override(buff.onRemoved, AwakeBossCH.buff_onRemoved)
  buff.update = override(buff.update, AwakeBossCH.buff_update)
  target:addBuff(buff, skill.caster)
  local Tr, dmg = basefunc(skill, target, source)
  skill.info = originfo
  local shild_id = 0
  if ed.run_with_scene then
    local effect_name = "eff_buff_burst.cha"
    local effect_name1 = "eff_impact_CH_ult2.cha"
    if target.actor and target:isAlive() then
      if effect_name then
        target.actor:addEffect(effect_name, 1)
      end
    elseif effect_name1 then
      target.actor:addEffect(effect_name1, 1)
    end
  end
  return Tr, dmg
end

function AwakeBossCH.skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local ARM = buff.info.ARM
  if skill.evo_rank and skill.evo_rank >= 2 then
    buff:setAttribute("ARM", ARM - skill.evo_rank2["Script Arg1"])
  end
  return buff
end

function AwakeBossCH.init_hero(hero)
  local skillpasv2 = hero.skills.AwakeBossCH_pasv2
  local skillult = hero.skills.AwakeBossCH_ult
  local skillatk = hero.skills.AwakeBossCH_atk
  local skillatk2 = hero.skills.AwakeBossCH_atk2
  local skillatk3 = hero.skills.AwakeBossCH_atk3
  local skillpasv = hero.passive_skill_list[1]
  if skillpasv2 then
    skillpasv2.power = override(skillpasv2.power, AwakeBossCH.pasv2_power)
    skillpasv2.info = ed.wraptable(skillpasv2.info, {
      ["No Dodge"] = true
    })
  end
  if skillult then
    skillult.takeEffectOn = override(skillult.takeEffectOn, AwakeBossCH.skillult_takeEffectOn)
    if skillult.evo_rank and 1 <= skillult.evo_rank then
      skillult.info = ed.wraptable(skillult.info, {
        ["Plus Ratio"] = skillult.evo_rank1["Script Arg1"]
      })
    end
    if skillult.evo_rank and skillult.evo_rank >= 2 then
      skillult.info = ed.wraptable(skillult.info, {
        ["Plus Ratio"] = skillult.evo_rank1["Script Arg1"],
        ["Script Arg2"] = skillult.evo_rank2["Script Arg1"]
      })
    end
    if skillult.evo_rank and skillult.evo_rank >= 3 then
      skillult.info = ed.wraptable(skillult.info, {
        ["Plus Ratio"] = skillult.evo_rank3["Script Arg1"],
        ["Script Arg2"] = skillult.evo_rank2["Script Arg1"]
      })
    end
  end
  if skillatk2 then
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, AwakeBossCH.skillatk2_onAttackFrame)
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
  end
  if skillatk3 then
    skillatk3.createBuff = override(skillatk3.createBuff, AwakeBossCH.skillatk3_createBuff)
    if skillatk3.evo_rank and 1 <= skillatk3.evo_rank then
      skillatk3.info = ed.wraptable(skillatk3.info, {
        ["Plus Ratio"] = skillatk3.evo_rank1["Script Arg1"]
      })
    end
    if skillatk3.evo_rank and skillatk3.evo_rank >= 3 then
      skillatk3.info = ed.wraptable(skillatk3.info, {
        ["Plus Ratio"] = skillatk3.evo_rank3["Script Arg1"]
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

return AwakeBossCH.init_hero
