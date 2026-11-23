module("ed.battlehero", package.seeall)
local ed = ed
WD = {}
WD.percents = {
  1,
  1,
  1,
  1,
  1
}

function WD.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local bid = 10005503
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = ed.BuffCreate(binfo, caster, caster)
  caster:addBuff(buff, caster)
  local shard = caster.proto._shard
  if shard and shard._id == 1000551 and caster.shardSkillRank and caster.shardSkillRank >= 2 then
    local bid = 10005504
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, caster, caster)
    caster:addBuff(buff, caster)
  end
end

function WD.skillult_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 10005503 or tbuff.info.ID == 10005504 then
      tbuff.timer = -1
    end
  end
end

function WD.skillult_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  local caster = skill.caster
  local shard = caster.proto._shard
  if shard and shard._id == 1000551 and caster.shardSkillRank and caster.shardSkillRank >= 3 then
    projectile:enableJump(caster.shardSkill[3]["Script Arg1"] + 1)
  end
  projectile:enableTrack(skill.target)
  return projectile
end

function WD.skillatk3_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  projectile:enableJump(5)
  projectile:enableTrack(skill.target)
  
  function projectile:findNextTaeget()
    local min = math.huge
    local ret
    for unit in ed.engine:foreachAliveUnit(self.skill:targetCamp()) do
      if unit == self.source then
      elseif unit.buff_effects.untargetable then
      elseif unit.buffManager.invisible and unit.camp ~= skill.caster.camp then
      else
        local distanceSQ = ed.edpDistanceSQ(unit.position, self.source.position)
        if min < distanceSQ then
        elseif distanceSQ > self.skill.min_range_sq and distanceSQ < self.skill.max_range_sq then
          ret = unit
          min = distanceSQ
        end
      end
    end
    return ret
  end
  
  return projectile
end

function WD.skillatk3_getDamage(basefunc, self, target, power, damage_type, field, source, crit_mod)
  if target.config.is_summoned then
    power = power * 2
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

function WD.skillatk3_createBuff(basefunc, self, target)
  if target.config.is_summoned then
    local bid = 10005505
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    return ed.BuffCreate(binfo, target, self.caster)
  else
    return ed.BuffCreate(self.info.buff_info, target, self.caster)
  end
end

function WD.skillatk4_selectTarget(basefunc, self, default)
  local target_type = self.info["Target Type"]
  local selector = self:target_selector()
  if target_type == "target" then
    if default then
      self.target = default
    else
      local t, distanceSQ = self.caster.ai:searchTarget()
      if distanceSQ <= self.max_range_sq then
        self.target = t
      else
        self.target = nil
      end
    end
  elseif target_type == "self" then
    self.target = self.caster
  elseif selector then
    local max = -math.huge
    local chosen
    local caster = self.caster
    local caster_position = caster.position
    local enchanted = caster.buff_effects.enchanted
    for unit in ed.engine:foreachAliveUnit(self:targetCamp()) do
      if unit.buff_effects.untargetable then
      elseif unit.buffManager.invisible and unit.camp ~= caster.camp then
      elseif enchanted and unit == caster then
      else
        local distanceSQ = (unit.position[1] - caster_position[1]) ^ 2 + (unit.position[2] - caster_position[2]) ^ 2
        if distanceSQ >= self.min_range_sq and distanceSQ <= self.max_range_sq then
          local v = selector(unit)
          if not unit.config.is_summoned and chosen and chosen.config.is_summoned then
            max = v
            chosen = unit
          elseif v > max then
            max = v
            chosen = unit
          end
        end
      end
    end
    self.target = chosen
  else
    EDDebug("Unkonwn target type: " .. target_type)
  end
  return self.target
end

function WD.skillatk4_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local hpr = buff.info.HPR
  local pimu = buff.info.PIMU
  local mimu = buff.info.MIMU
  if skill.evo_rank and skill.evo_rank >= 1 then
    buff:setAttribute("HPR", hpr - skill.evo_rank1["Script Arg1"])
  end
  if skill.evo_rank and skill.evo_rank >= 2 then
    buff:setAttribute("HPR", hpr - skill.evo_rank1["Script Arg1"] - skill.evo_rank2["Script Arg1"])
  end
  if skill.evo_rank and skill.evo_rank >= 3 then
    buff:setAttribute("PIMU", pimu - skill.evo_rank3["Script Arg1"])
    buff:setAttribute("MIMU", mimu - skill.evo_rank3["Script Arg1"])
  end
  return buff
end

function WD.init_hero(hero)
  local skillult = hero.skills.WD_ult
  local skillatk2 = hero.skills.WD_atk2
  local skillatk3 = hero.skills.WD_atk3
  local skillatk4 = hero.skills.WD_atk4
  local shard = hero.proto._shard
  if skillult then
    skillult.start = override(skillult.start, WD.skillult_start)
    skillult.finish = override(skillult.finish, WD.skillult_finish)
    if skillult.evo_rank and skillult.evo_rank >= 1 then
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
    if shard and shard._id == 1000551 and hero.shardSkillRank and 3 <= hero.shardSkillRank then
      skillult.info = ed.wraptable(skillult.info, {
        ["Damage Type"] = "Holy"
      })
      skillult.createProjectile = override(skillult.createProjectile, WD.skillult_createProjectile)
    end
  end
  if skillatk2 then
    local plusratio = skillatk2.info["Plus Ratio"]
    local cd = skillatk2.info.CD
    local intcd = skillatk2.info["Init CD"]
    if skillatk2.evo_rank and skillatk2.evo_rank >= 1 then
      plusratio = skillatk2.evo_rank1["Script Arg1"]
    end
    if skillatk2.evo_rank and skillatk2.evo_rank >= 2 then
      plusratio = skillatk2.evo_rank2["Script Arg1"]
    end
    if skillatk2.evo_rank and skillatk2.evo_rank >= 3 then
      plusratio = skillatk2.evo_rank3["Script Arg1"]
    end
    if shard and shard._id == 1000551 and hero.shardSkillRank and 1 <= hero.shardSkillRank then
      cd = cd - hero.shardSkill[1]["Script Arg1"]
      intcd = intcd - hero.shardSkill[1]["Script Arg1"]
    end
    skillatk2.info = ed.wraptable(skillatk2.info, {
      ["Plus Ratio"] = plusratio,
      CD = cd,
      ["Init CD"] = intcd
    })
  end
  if skillatk3 then
    local plusratio = skillatk3.info["Plus Ratio"]
    local cd = skillatk3.info.CD
    if skillatk3.evo_rank and skillatk3.evo_rank >= 1 then
      plusratio = skillatk3.evo_rank1["Script Arg1"]
    end
    if skillatk3.evo_rank and skillatk3.evo_rank >= 2 then
      plusratio = skillatk3.evo_rank2["Script Arg1"]
    end
    if skillatk3.evo_rank and skillatk3.evo_rank >= 3 then
      plusratio = skillatk3.evo_rank3["Script Arg1"]
    end
    if shard and shard._id == 1000551 and hero.shardSkillRank and 1 <= hero.shardSkillRank then
      cd = cd - hero.shardSkill[1]["Script Arg1"]
    end
    skillatk3.info = ed.wraptable(skillatk3.info, {
      ["Plus Ratio"] = plusratio,
      CD = cd
    })
    skillatk3.createProjectile = override(skillatk3.createProjectile, WD.skillatk3_createProjectile)
    skillatk3.getDamage = override(skillatk3.getDamage, WD.skillatk3_getDamage)
    skillatk3.createBuff = override(skillatk3.createBuff, WD.skillatk3_createBuff)
  end
  if skillatk4 then
    if shard and shard._id == 1000551 and hero.shardSkillRank and 1 <= hero.shardSkillRank then
      local cd = skillatk4.info.CD
      cd = cd - hero.shardSkill[1]["Script Arg1"]
      skillatk4.info = ed.wraptable(skillatk4.info, {CD = cd})
    end
    skillatk4.selectTarget = override(skillatk4.selectTarget, WD.skillatk4_selectTarget)
    skillatk4.createBuff = override(skillatk4.createBuff, WD.skillatk4_createBuff)
  end
  return hero
end

return WD.init_hero
