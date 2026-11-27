module("ed.battlehero", package.seeall)
local ed = ed
SF = {}
SF.ultEvobuff = 10002503
SF.fashion_id_2 = 252

function SF.update(basefunc, self, dt)
  local attackUnitCount = 0
  local skillemaura = self.effect_enemy_aura_skill_list[1]
  self.attack_list = {}
  if skillemaura then
    local Evo_MP = skillemaura.evo_rank3["Script Arg1"]
    if skillemaura and skillemaura.evo_rank and skillemaura.evo_rank >= 3 then
      for unit in ed.engine:foreachAliveUnit(self.foecamp) do
        self.attack_list[attackUnitCount] = unit
        attackUnitCount = attackUnitCount + 1
        if attackUnitCount > skillemaura.evo_rank3["Script Arg2"] then
          attackUnitCount = skillemaura.evo_rank3["Script Arg2"]
        end
      end
    end
    self.notPopupBattleInfo = true
    self:takeHeal(Evo_MP * attackUnitCount * dt, "mp", self)
    self.notPopupBattleInfo = false
  end
  if self.state == ed.emUnitState_Dying then
    if not self.dyingTimer_SF then
      self.dyingTimer_SF = 0.8
    end
    self.dyingTimer_SF = self.dyingTimer_SF - dt
    if 0 >= self.dyingTimer_SF and not self.CHEN_ult1time then
      self.dyingTimer_SF = 99999
      local skill = self.skills.SF_ult
      if skill then
        skill:takeEffectAt(self.position)
      end
    end
  else
    self.dyingTimer_SF = nil
  end
  basefunc(self, dt)
end

function SF.reset(basefunc, unit)
  basefunc(unit)
  unit.dyingTimer_SF = nil
  unit.herosoul = 0
  local skillatk2 = unit.skills.SF_atk2
  if skillatk2 then
    skillatk2.currentNum = 0
  end
end

function SF.hero_handleUnitDieEvent(basefunc, self, unit, killer_unit)
  basefunc(self, unit, killer_unit)
  local skillatk3 = self.skills.SF_atk3
  local skillatk3s = self.skills.SF_atk3s
  if skillatk3 and not unit.config.is_summoned then
    skillatk3:takeEffectOn(self, self)
    self.herosoul = self.herosoul + 1 or 1
  end
  if skillatk3 and unit.camp ~= self.camp and unit.config.is_summoned and unit.proto._tid ~= 194 and unit.proto._tid ~= 205 and unit.proto._tid ~= 212 and unit.proto._tid ~= 206 then
    skillatk3s:takeEffectOn(self, self)
  end
end

function SF.skillatk_takeEffectOn(basefunc, skill, target)
  local isHit, dmg = basefunc(skill, target)
  local caster = skill.caster
  local shard = caster.proto._shard
  if caster.herosoul then
    local p = (caster.shardSkill[1]["Script Arg1"] * caster.herosoul + caster.shardSkill[1]["Script Arg2"]) / 100
    if isHit and p > ed.rand() and not target.buff_effects.uncontrollable and not target.buff_effects.invulnerable then
      local bid = SF.ultEvobuff
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      binfo.fearrange = 5
      local buff = ed.BuffCreate(binfo, target, caster)
      local buffInfo = buff.info
      local attribName = buffInfo.Tenacity
      local timer = 1
      local TEN_final = ed.Buff.getTenValue(buffInfo, target, caster)
      buff.timer = timer * math.max(0.01, 1 - TEN_final / 100)
      target:addBuff(buff, caster)
    end
  end
  return isHit, dmg
end

function SF.skillatk_getDamage(basefunc, self, target, power, damage_type, field, source, crit_mod)
  local caster = self.caster
  if self.shardatk then
    local shard = caster.proto._shard
    if shard and shard._id == 1000251 and caster.shardSkillRank and caster.shardSkillRank >= 3 then
      power = power * caster.shardSkill[3]["Script Arg2"] / 100
    end
  end
  local dmg = target:takeDamage({
    amount = power,
    damage_type = damage_type,
    field = field,
    source = source,
    crit_mod = crit_mod,
    skill = self
  })
  return dmg
end

function SF.skillatk2_finish(basefunc, skill)
  local caster = skill.caster
  local shard = caster.proto._shard
  if shard and shard._id == 1000251 and caster.shardSkillRank and caster.shardSkillRank >= 3 then
    skill.cd_remaining = caster.shardSkill[3]["Script Arg1"]
  else
    skill.currentNum = skill.currentNum + 1
    if 3 <= skill.currentNum then
      skill.currentNum = 0
      skill.cd_remaining = 15
    else
      skill.caster:castSkill(skill)
    end
  end
  basefunc(skill)
end

function SF.skillatk2_takeEffectAt(basefunc, skill, location, source)
  local caster = skill.caster
  local shard = caster.proto._shard
  if shard and shard._id == 1000251 and caster.shardSkillRank and caster.shardSkillRank >= 3 then
    local DOPPosition = SF.DOP_in_battlefield(caster, 120, caster.foecamp)
    basefunc(skill, DOPPosition, source)
  else
    local originfo = skill.info
    skill.info = ed.wraptable(originfo, {
      ["X Shift"] = originfo["X Shift"] + skill.currentNum * 100
    })
    basefunc(skill, location, source)
    skill.info = originfo
  end
end

function SF.DOP_in_battlefield(caster, radius, camp)
  local position = {400, 0}
  local count = 0
  local maxcount = 0
  local distance = 0
  local mindistance = 9999
  for x = 0, 800, 25 do
    for y = -100, 100, 25 do
      for unit in ed.engine:foreachAliveUnit(camp) do
        local unitdistance = ed.edpDistanceSQ({x, y}, unit.position)
        if (unit.buffManager.invisible or unit.buff_effects.untargetable or unit.buff_effects.invulnerable) and unit.camp ~= caster.camp then
        elseif unitdistance <= radius * radius then
          count = count + 1
          distance = distance + unitdistance
        end
      end
      if maxcount < count then
        maxcount = count
        mindistance = distance
        position = {x, y}
      end
      if count == maxcount and distance < mindistance then
        mindistance = distance
        position = {x, y}
      end
      count = 0
      distance = 0
    end
  end
  if 0 < maxcount then
    return position
  else
    position = {400, 0}
    return position
  end
end

function SF.skillatk2_takeEffectOn(basefunc, skill, target)
  local isHit, dmg = basefunc(skill, target)
  local caster = skill.caster
  local skillatk = caster.skills.SF_atk
  if isHit then
    skillatk.shardatk = true
    skillatk:takeEffectOn(target)
    skillatk.shardatk = false
  end
  return isHit, dmg
end

function SF.skillult_getDamage(basefunc, self, target, power, damage_type, field, source, crit_mod)
  local hero = self.caster
  local distance = ((target.position[1] - hero.position[1]) ^ 2 + (target.position[2] - hero.position[2]) ^ 2) ^ 0.5
  local distanceMAX = 400
  local SFultRatio = distanceMAX / distance
  local MaxRatio = 2
  if self.evo_rank and self.evo_rank >= 3 then
    MaxRatio = self.evo_rank3["Script Arg1"]
  end
  if SFultRatio > MaxRatio then
    SFultRatio = MaxRatio
  elseif SFultRatio < 1 then
    SFultRatio = 1
  end
  local power = power * SFultRatio
  if hero.dyingTimer_SF then
    power = power * 0.8
  end
  local dmg = target:takeDamage({
    amount = power,
    damage_type = damage_type,
    field = field,
    source = source,
    crit_mod = crit_mod,
    skill = self
  })
  return dmg
end

function SF.skillult_takeEffectOn(basefunc, skill, target)
  local isHit, dmg = basefunc(skill, target)
  local caster = skill.caster
  if isHit and skill.evo_rank and skill.evo_rank >= 2 and not caster.dyingTimer_SF then
    local bid = SF.ultEvobuff
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    binfo.fearrange = 5
    local buff = ed.BuffCreate(binfo, target, caster)
    target:addBuff(buff, caster)
  end
  return isHit, dmg
end

function SF.skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local ad = buff.info.AD
  local caster = buff.caster
  if skill.evo_rank and skill.evo_rank >= 1 then
    buff:setAttribute("AD", ad + skill.evo_rank1["Script Arg1"])
  end
  if skill.evo_rank and skill.evo_rank >= 2 then
    buff:setAttribute("AD", ad + skill.evo_rank1["Script Arg1"] + skill.evo_rank2["Script Arg1"])
  end
  if skill.evo_rank and skill.evo_rank >= 3 then
    buff:setAttribute("AD", ad + skill.evo_rank1["Script Arg1"] + skill.evo_rank2["Script Arg1"] + skill.evo_rank3["Script Arg1"])
  end
  return buff
end

function SF.init_hero(hero)
  if hero.name == "SF" then
    hero.update = override(hero.update, SF.update)
    hero.reset = override(hero.reset, SF.reset)
  end
  hero.handleUnitDieEventToAll = override(hero.handleUnitDieEventToAll, SF.hero_handleUnitDieEvent)
  local shard = hero.proto._shard
  local skillult = hero.skills.SF_ult
  local skillatk = hero.skills.SF_atk
  local skillatk2 = hero.skills.SF_atk2
  local skillatk3 = hero.skills.SF_atk3
  local skillemaura = hero.effect_enemy_aura_skill_list[1]
  if skillatk then
    skillatk.getDamage = override(skillatk.getDamage, SF.skillatk_getDamage)
    if shard and shard._id == 1000251 and hero.shardSkillRank and 1 <= hero.shardSkillRank then
      skillatk.takeEffectOn = override(skillatk.takeEffectOn, SF.skillatk_takeEffectOn)
    end
    if SF.fashion_id_2 and SF.fashion_id_2 == hero.fashion_id then
      local originfo = skillatk.info
      skillatk.info = ed.wraptable(originfo, {
        ["Tile Art"] = "eff_tile_SF_fashion_2_atk.cha"
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
        ["Plus Ratio"] = skillatk2.evo_rank2["Script Arg1"]
      })
    end
    if skillatk2.evo_rank and skillatk2.evo_rank >= 3 then
      skillatk2.info = ed.wraptable(skillatk2.info, {
        ["Plus Ratio"] = skillatk2.evo_rank3["Script Arg1"]
      })
    end
    if shard and shard._id == 1000251 and hero.shardSkillRank and hero.shardSkillRank >= 3 then
      skillatk2.info = ed.wraptable(skillatk2.info, {
        ["AOE Origin"] = "target",
        ["X Shift"] = 0
      })
      skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, SF.skillatk2_takeEffectOn)
    end
    if SF.fashion_id_2 and SF.fashion_id_2 == hero.fashion_id then
      local originfo = skillatk2.info
      skillatk2.info = ed.wraptable(originfo, {
        ["Point Effect"] = "eff_point_SF_fashion_2_atk2.cha"
      })
    end
    skillatk2.takeEffectAt = override(skillatk2.takeEffectAt, SF.skillatk2_takeEffectAt)
    skillatk2.finish = override(skillatk2.finish, SF.skillatk2_finish)
    skillatk2.currentNum = 0
  end
  if skillatk3 then
    skillatk3.createBuff = override(skillatk3.createBuff, SF.skillatk3_createBuff)
    if SF.fashion_id_2 and SF.fashion_id_2 == hero.fashion_id then
      local originfo = skillatk3.info
      skillatk3.info = ed.wraptable(originfo, {
        ["Impact Effect"] = "eff_buff_SF_fashion_2_atk3.cha"
      })
    end
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
    if SF.fashion_id_2 and SF.fashion_id_2 == hero.fashion_id then
      local originfo = skillult.info
      skillult.info = ed.wraptable(originfo, {
        ["Point Effect"] = "eff_point_SF_fashion_2_ult.cha"
      })
    end
    skillult.getDamage = override(skillult.getDamage, SF.skillult_getDamage)
    skillult.takeEffectOn = override(skillult.takeEffectOn, SF.skillult_takeEffectOn)
  end
  if skillemaura then
    local aname = skillemaura["Passive Attr"]
    local num = skillemaura["Basic Num"]
    if skillemaura.evo_rank and 1 <= skillemaura.evo_rank then
      skillemaura["Basic Num"] = skillemaura["Basic Num"] - skillemaura.evo_rank1["Script Arg1"]
    end
    if skillemaura.evo_rank and skillemaura.evo_rank >= 2 then
      skillemaura["Basic Num"] = skillemaura["Basic Num"] - skillemaura.evo_rank2["Script Arg1"]
    end
    if shard and shard._id == 1000251 and hero.shardSkillRank and hero.shardSkillRank >= 2 then
      skillemaura["Basic Num"] = skillemaura["Basic Num"] - hero.shardSkill[2]["Script Arg1"] * hero.attribs.AGI
    end
  end
  return hero
end

return SF.init_hero
