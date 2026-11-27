module("ed.battlehero", package.seeall)
local ed = ed
QOP = {}
QOP.atk3buff = 10000701
QOP.atk3Evobuff = 10000703
QOP.atk3shardbuff = 10000704
QOP.enchbuff = 10000705
QOP.fashion_id_1 = 71
QOP.fashion_id_2 = 72

function QOP.skillatk2_createProjectile(basefunc, skill)
  local caster = skill.caster
  local shard = caster.proto._shard
  local origTarget = skill.target
  local counter = 0
  local maxcounter = caster.shardSkill[1]["Script Arg1"]
  local projectile = basefunc(skill, origTarget)
  projectile.dmgModifier = 1
  projectile:enableTrack(origTarget)
  ed.engine:addProjectile(projectile)
  for unit in ed.engine:foreachAliveUnit(skill:affectedCamp()) do
    if counter >= maxcounter then
      break
    end
    if unit.buff_effects.untargetable then
    elseif unit.buffManager.invisible and unit.camp ~= skill.caster.camp then
    elseif unit == origTarget then
    else
      counter = counter + 1
      skill.target = unit
      local projectile = basefunc(skill, unit)
      projectile:enableTrack(unit)
      ed.engine:addProjectile(projectile)
    end
  end
end

function QOP.skillatk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local hpr = buff.info.HPR
  if skill.evo_rank and skill.evo_rank >= 2 then
    buff:setAttribute("HPR", hpr - skill.evo_rank2["Script Arg1"])
  end
  if skill.evo_rank and skill.evo_rank >= 3 then
    buff.update = override(buff.update, QOP.skillatk2_buffUpdate)
  end
  return buff
end

function QOP.skillatk2_buffUpdate(basefunc, buff, dt)
  basefunc(buff, dt)
  local caster = buff.caster
  local skillatk2 = caster.skills.QOP_atk2
  local QOP_hpr = (buff.info.HPR + buff.info["HPR.a"] * caster.attribs.AP) * dt
  if QOP_hpr < 0 then
    local QOP_damage = math.min(-QOP_hpr, buff.owner.hp)
    QOP_damage = QOP_damage * buff.owner.dPSStatisticsRatio
    buff.caster.notPopupBattleInfo = true
    buff.caster:takeHeal(math.abs(skillatk2.evo_rank3["Script Arg1"] / 100 * QOP_damage), "hp", caster)
    buff.caster.notPopupBattleInfo = false
  end
end

function QOP.skillatk3_start(basefunc, skill, target)
  basefunc(skill, target)
  local bid = QOP.atk3buff
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local caster = skill.caster
  caster:addBuff(binfo, caster)
  caster.oriposition = caster.position
end

function QOP.skillatk3_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == QOP.atk3buff then
      local buff = tbuff
      buff.timer = -1
    end
  end
  local shard = caster.proto._shard
  if shard and shard._id == 1000071 and caster.shardSkillRank and caster.shardSkillRank >= 2 then
    local bid = QOP.atk3shardbuff
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local caster = skill.caster
    caster:addBuff(binfo, caster)
  end
end

function QOP.skillatk3_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  local hero = skill.caster
  local target = skill.target
  if attack_counter == 0 then
    local DOPPosition = QOP.DOP_in_battlefield(hero, 130, hero.foecamp)
    hero.position = DOPPosition
    skill.attack_counter = skill.attack_counter + 1
  elseif attack_counter == 1 then
    basefunc(skill)
  elseif attack_counter == 2 then
    hero.position = hero.oriposition
    skill.attack_counter = skill.attack_counter + 1
  end
end

function QOP.DOP_in_battlefield(caster, radius, camp)
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

function QOP.skillatk3_takeEffectOn(basefunc, skill, target, source, shift)
  local ishit, damage = basefunc(skill, target, source, shift)
  local caster = skill.caster
  if ishit and skill.evo_rank and skill.evo_rank >= 3 then
    local bid = QOP.atk3Evobuff
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, target, caster)
    target:addBuff(buff, caster)
  end
  return ishit, damage
end

function QOP.hero_takeDamage(basefunc, self, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
  self.Gender = nil
  if type(struct_table) == "table" then
    if struct_table.source and struct_table.source.info.Gender == T("\231\148\183") then
      self.Gender = T("\231\148\183")
      local shard = self.proto._shard
      if shard and shard._id == 1000071 and self.shardSkillRank and self.shardSkillRank >= 3 and ed.rand() < self.shardSkill[3]["Script Arg1"] / 100 and not struct_table.source.buff_effects.uncontrollable and not struct_table.source.buff_effects.invulnerable then
        local bid = QOP.enchbuff
        local binfo = ed.lookupDataTable("Buff", nil, bid)
        local buff = ed.BuffCreate(binfo, struct_table.source, self)
        struct_table.source:addBuff(buff, self)
      end
    end
  elseif source and source.info.Gender == T("\231\148\183") then
    self.Gender = T("\231\148\183")
    local shard = self.proto._shard
    if shard and shard._id == 1000071 and self.shardSkillRank and self.shardSkillRank >= 3 and ed.rand() < self.shardSkill[3]["Script Arg1"] / 100 and not source.buff_effects.uncontrollable and not source.buff_effects.invulnerable then
      local bid = QOP.enchbuff
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, source, self)
      source:addBuff(buff, self)
    end
  end
  return basefunc(self, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
end

function QOP.skill_getLostHPAfterImmunity(basefunc, self, damage, immunity)
  if self.Gender == T("\231\148\183") then
    local skillpasv = self.passive_skill_list[1]
    local reduce = skillpasv.evo_rank3["Script Arg1"] * 0.01
    damage = damage * (1 - reduce)
  end
  return basefunc(self, damage, immunity)
end

function QOP.init_hero(hero)
  local skillatk = hero.skills.QOP_atk
  local skillatk2 = hero.skills.QOP_atk2
  local skillatk3 = hero.skills.QOP_atk3
  local skillult = hero.skills.QOP_ult
  local skillpasv = hero.passive_skill_list[1]
  local shard = hero.proto._shard
  hero.takeDamage = override(hero.takeDamage, QOP.hero_takeDamage)
  if skillatk then
    if QOP.fashion_id_1 and QOP.fashion_id_1 == hero.fashion_id then
      local originfo1 = skillatk.info
      skillatk.info = ed.wraptable(originfo1, {
        ["Tile Art"] = "eff_tile_QOP_fashion_1_atk.cha"
      })
    end
    if QOP.fashion_id_2 and QOP.fashion_id_2 == hero.fashion_id then
      local originfo2 = skillatk.info
      skillatk.info = ed.wraptable(originfo2, {
        ["Tile Art"] = "eff_tile_QOP_fashion_2_atk.cha"
      })
    end
  end
  if skillult then
    if QOP.fashion_id_2 and QOP.fashion_id_2 == hero.fashion_id then
      local plusratio = skillult.info["Plus Ratio"]
      local konckback = skillult.info["Konck Back"]
      local konckup = skillult.info["Konck Up"]
      skillult.info = ed.wraptable(skillult.info, {
        ["Point Effect"] = "eff_point_QOP_fashion_2_ult.cha",
        ["Impact Effect"] = "eff_impact_QOP_fashion_2_sonic.cha",
        ["Plus Ratio"] = plusratio,
        ["Knock Back"] = konckback,
        ["Knock Up"] = konckup
      })
    end
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
        ["Knock Back"] = 100,
        ["Knock Up"] = 0.1
      })
    end
  end
  if skillatk2 then
    if QOP.fashion_id_1 and QOP.fashion_id_1 == hero.fashion_id then
      local plusratio = skillatk2.info["Plus Ratio"]
      skillatk2.info = ed.wraptable(skillatk2.info, {
        ["Tile Art"] = "eff_tile_QOP_fashion_1_atk2.cha",
        ["Plus Ratio"] = plusratio
      })
    end
    if QOP.fashion_id_2 and QOP.fashion_id_2 == hero.fashion_id then
      local plusratio = skillatk2.info["Plus Ratio"]
      skillatk2.info = ed.wraptable(skillatk2.info, {
        ["Tile Art"] = "eff_tile_QOP_fashion_2_atk2.cha",
        ["Plus Ratio"] = plusratio
      })
    end
    if shard and shard._id == 1000071 and hero.shardSkillRank and 1 <= hero.shardSkillRank then
      skillatk2.createProjectile = override(skillatk2.createProjectile, QOP.skillatk2_createProjectile)
    end
    skillatk2.createBuff = override(skillatk2.createBuff, QOP.skillatk2_createBuff)
    if skillatk2.evo_rank and 1 <= skillatk2.evo_rank then
      skillatk2.info = ed.wraptable(skillatk2.info, {
        ["Plus Ratio"] = skillatk2.evo_rank1["Script Arg1"]
      })
    end
  end
  if skillatk3 then
    skillatk3.start = override(skillatk3.start, QOP.skillatk3_start)
    skillatk3.finish = override(skillatk3.finish, QOP.skillatk3_finish)
    skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, QOP.skillatk3_onAttackFrame)
    if QOP.fashion_id_2 and QOP.fashion_id_2 == hero.fashion_id then
      local plusratio = skillatk3.info["Plus Ratio"]
      skillatk3.info = ed.wraptable(skillatk3.info, {
        ["Point Effect"] = "eff_point_QOP_fashion_2_atk3.cha",
        ["Impact Effect"] = "eff_impact_QOP_fashion_2_sonic.cha",
        ["Plus Ratio"] = plusratio
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
      skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, QOP.skillatk3_takeEffectOn)
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
      hero.getLostHPAfterImmunity = override(hero.getLostHPAfterImmunity, QOP.skill_getLostHPAfterImmunity)
    end
    hero:rebuild()
  end
  return hero
end

return QOP.init_hero
