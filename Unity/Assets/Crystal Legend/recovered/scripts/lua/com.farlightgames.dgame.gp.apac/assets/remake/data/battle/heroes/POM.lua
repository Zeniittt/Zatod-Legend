module("ed.battlehero", package.seeall)
local ed = ed
POM = {}
POM.skillFashionId = 331
POM.Fashion_Hit = 50

function POM.skillult_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  if skill.evo_rank and skill.evo_rank >= 3 then
    for unit in ed.engine:foreachAliveUnit(caster.camp) do
      if unit.info["Unit Type"] == "Hero" then
        unit:takeHeal(skill.evo_rank3["Script Arg1"], "mp", caster)
      end
    end
  end
end

function POM.skillatk2_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  caster.position[1] = 400 - 450 * caster:getInitDir()
  local distance = 240 * caster:getInitDir()
  local time = skill.current_phase.duration
  local v = distance / time
  caster.walk_v = {v, 0}
end

function POM.skillatk2_takeEffectOn(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local shard = caster.proto._shard
  if shard and shard._id == 1000331 and caster.shardSkillRank and caster.shardSkillRank >= 3 then
    target:takeHeal(caster.shardSkill[3]["Script Arg1"], "mp", caster)
  end
end

function POM.skillatk2_onAttackFrame(basefunc, skill)
  skill.caster.walk_v = {0, 0}
  basefunc(skill)
end

function POM.skillatk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local buffInfo = buff.info
  local owner = buff.owner
  local caster = buff.caster
  local ad = buffInfo.AD
  local ap = buffInfo.AP
  if skill.evo_rank and skill.evo_rank >= 1 then
    buff.timer = skill.evo_rank1["Script Arg1"]
  end
  if skill.evo_rank and skill.evo_rank >= 2 then
    buff:setAttribute("AD", ad + skill.evo_rank2["Script Arg1"])
    buff:setAttribute("AP", ap + skill.evo_rank2["Script Arg1"])
  end
  if skill.evo_rank and skill.evo_rank >= 3 then
    buff:setAttribute("MSPD", skill.evo_rank3["Script Arg1"])
    buff:setAttribute("HAST", skill.evo_rank3["Script Arg1"])
  end
  return buff
end

function POM.skillatk3_createBuff(basefunc, skill, target)
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

function POM.skillatk3_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  projectile.update = override(projectile.update, POM.skillatk3_projectile_update)
  projectile.collideCheck = override(projectile.collideCheck, POM.skillatk3_projectile_collideCheck)
  return projectile
end

function POM.skillatk3_projectile_update(basefunc, self, dt)
  if self.birthtick == ed.engine.ticks then
    return
  end
  local target = self.track_target
  if target then
    if not target:isAlive() then
      self.track_target = nil
    end
    if not self.skill.info["Tile Piercing"] then
      if target.buff_effects.untargetable then
        self.track_target = nil
      end
      if target.buffManager.invisible and target.camp ~= self.camp then
        self.track_target = nil
      end
    end
  end
  self.previous_position = {
    self.position[1],
    self.position[2]
  }
  ed.Entity.update(self, dt)
  local info = self.skill.info
  self.height = self.height + self.zSpeed * dt
  self.zSpeed = self.zSpeed + (self["No Gravity"] and 0 or info["Tile Gravity"]) * dt
  self.distance = self.distance + info["Tile XY Speed"] * dt
  local h = self.height
  local ott = info["Tile OTT Height"]
  local aoe = self.skill.info["AOE Origin"]
  
  local function checkCondition(unit)
    if self.skill.what == "magicSkill" then
      return true
    end
    return not self.caster.buff_effects.derangedOwner or unit ~= self.caster and unit.buff_effects.derangedTarget
  end
  
  local targetlist = {}
  if ott == 0 or h < ott then
    local firstTime = 1
    local firstUnit
    local piercing = info["Tile Piercing"]
    for unit in ed.engine:foreachAliveUnit(self.affect_camp) do
      if not checkCondition(unit) or piercing and self.affect_times[unit] then
      else
        local collide = self:collideCheck(unit)
        if collide then
          targetlist[#targetlist + 1] = unit
        end
        if not collide then
        else
        end
      end
    end
    local max = -math.huge
    for i = 1, #targetlist do
      local x = targetlist[i].position[1]
      local dir = targetlist[i]:getInitDir()
      if dir == 1 then
        if max < x then
          max = x
          firstUnit = targetlist[i]
        end
      elseif dir == -1 and max < -x then
        max = -x
        firstUnit = targetlist[i]
      end
    end
    if firstUnit then
      self:hit(firstUnit)
      self:terminate()
    end
  end
  if not self.terminated and h <= 0 and aoe then
    if not self.pre_select then
      self.skill:takeEffectAt(self.position)
    end
    self:terminate()
  end
  if not self.terminated and (self:isOutOfStage() or h < 0 or self.distance > self.max_distance) then
    self:terminate()
  end
end

function POM.skillatk3_projectile_collideCheck(basefunc, self, unit)
  if self.track_target and unit ~= self.track_target then
    return false
  end
  if not self.skill.info["Tile Piercing"] then
    if unit.buff_effects.untargetable then
      return false
    end
    if unit.buffManager.invisible and unit.camp ~= self.camp then
      return false
    end
  end
  local radius = 62.5
  local d = self.position[1]
  local d0 = self.previous_position[1]
  local ux = unit.position[1] - d
  local ux0 = unit.previous_position[1] - d0
  if 0 < ux and 0 < ux0 then
    ux = ux - radius
    ux0 = ux0 - radius
  elseif ux < 0 and ux0 < 0 then
    ux = ux + radius
    ux0 = ux0 + radius
  end
  local t = -ux0 / (ux - ux0)
  if t < 0 or 1 < t then
    return false
  end
  return t
end

function POM.skillatk3_takeEffectOn(basefunc, skill, target)
  local hit, dmg, Crit, lfs_amount = basefunc(skill, target)
  local caster = skill.caster
  local shard = caster.proto._shard
  if shard and shard._id == 1000331 and caster.shardSkillRank and caster.shardSkillRank >= 1 then
    local skillults = caster.skills.POM_ults
    skillults:takeEffectAt(target.position, caster)
  end
  return hit, dmg, Crit, lfs_amount
end

function POM.init_hero(hero)
  local skillult = hero.skills.POM_ult
  local skillatk2 = hero.skills.POM_atk2
  local skillatk3 = hero.skills.POM_atk3
  local count1 = 1
  local count2 = 2
  local count3 = 3
  for i, skillinfo in ipairs(hero.aura_skill_list) do
    if skillinfo["Skill Name"] == "POM_pasv" then
      count1 = i
    end
    if skillinfo["Skill Name"] == "POM_shard2_1" then
      count2 = i
    end
    if skillinfo["Skill Name"] == "POM_shard2_2" then
      count3 = i
    end
  end
  local skillaura = hero.aura_skill_list[count1]
  local skillshard2_1 = hero.aura_skill_list[count2]
  local skillshard2_2 = hero.aura_skill_list[count3]
  if skillshard2_1 and skillshard2_2 then
    local shard = hero.proto._shard
    if shard and shard._id == 1000331 and hero.shardSkillRank and 2 <= hero.shardSkillRank then
      skillshard2_1["Basic Num"] = hero.shardSkill[2]["Script Arg1"]
      skillshard2_2["Basic Num"] = hero.shardSkill[2]["Script Arg1"]
    end
  end
  if skillult then
    if skillult.evo_rank and 1 <= skillult.evo_rank then
      skillult.info = ed.wraptable(skillult.info, {
        ["Plus Ratio"] = skillult.evo_rank1["Script Arg1"]
      })
    end
    if skillult.evo_rank and 2 <= skillult.evo_rank then
      skillult.info = ed.wraptable(skillult.info, {
        ["Plus Ratio"] = skillult.evo_rank2["Script Arg1"]
      })
    end
    if skillult.evo_rank and 3 <= skillult.evo_rank then
      skillult.onAttackFrame = override(skillult.onAttackFrame, POM.skillult_onAttackFrame)
    end
  end
  if skillatk2 then
    skillatk2.start = override(skillatk2.start, POM.skillatk2_start)
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, POM.skillatk2_onAttackFrame)
    skillatk2.createBuff = override(skillatk2.createBuff, POM.skillatk2_createBuff)
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, POM.skillatk2_takeEffectOn)
  end
  if skillatk3 then
    skillatk3.createProjectile = override(skillatk3.createProjectile, POM.skillatk3_createProjectile)
    if skillatk3.evo_rank and 1 <= skillatk3.evo_rank then
      skillatk3.info = ed.wraptable(skillatk3.info, {
        ["Plus Ratio"] = skillatk3.evo_rank1["Script Arg1"]
      })
    end
    if skillatk3.evo_rank and 2 <= skillatk3.evo_rank then
      skillatk3.info = ed.wraptable(skillatk3.info, {
        ["Plus Ratio"] = skillatk3.evo_rank2["Script Arg1"]
      })
    end
    if skillatk3.evo_rank and 3 <= skillatk3.evo_rank then
      skillatk3.createBuff = override(skillatk3.createBuff, POM.skillatk3_createBuff)
    end
    skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, POM.skillatk3_takeEffectOn)
  end
  if skillaura then
    local aname = skillaura["Passive Attr"]
    local num = skillaura["Basic Num"]
    if skillaura.evo_rank and 1 <= skillaura.evo_rank then
      skillaura["Basic Num"] = skillaura["Basic Num"] + skillaura.evo_rank1["Script Arg1"]
    end
    if skillaura.evo_rank and 2 <= skillaura.evo_rank then
      skillaura["Basic Num"] = skillaura["Basic Num"] + skillaura.evo_rank2["Script Arg1"]
    end
    if skillaura.evo_rank and 3 <= skillaura.evo_rank then
      skillaura["Basic Num"] = skillaura["Basic Num"] + skillaura.evo_rank3["Script Arg1"]
    end
  end
  return hero
end

return POM.init_hero
