module("ed.battlehero", package.seeall)
local ed = ed
OM = {}
OM.multicast_table = {
  OM_ult = {
    40,
    30,
    20,
    10
  },
  OM_atk2 = {
    40,
    30,
    20,
    10
  },
  OM_atk3 = {
    40,
    30,
    20,
    10
  }
}
OM.multicast_Evo_table = {
  OM_ult = {
    40,
    20,
    20,
    20
  },
  OM_atk2 = {
    40,
    20,
    20,
    20
  },
  OM_atk3 = {
    40,
    20,
    20,
    20
  }
}
OM.shard2_buff = 10002404
OM.shard3_buff = 10002405

function OM.OM_rand(skill)
  local prob_table = OM.multicast_table[skill.info["Skill Name"]]
  if skill.evo_rank and skill.evo_rank >= 3 then
    prob_table = OM.multicast_Evo_table[skill.info["Skill Name"]]
  end
  local rand = ed.rand() * 100
  local times = #prob_table
  for i, v in ipairs(prob_table) do
    rand = rand - v
    if rand < 0 then
      times = i
      break
    end
  end
  if ed.run_with_scene and 1 < times then
    local str
    local color = skill.caster.camp == OM.emCampPlayer and "red" or "blue"
    if times == 2 then
      str = "multicast_x2"
    elseif times == 3 then
      str = "multicast_x3"
    elseif times == 4 then
      str = "multicast_x4"
    end
    ed.PopupCreate(str, color, skill.caster.actor, nil, "text")
  end
  return times
end

function OM.OM_select_targets(skill)
  local times = OM.OM_rand(skill)
  local list = {}
  for unit in ed.engine:foreachAliveUnit(skill:affectedCamp()) do
    if skill.info["Skill Name"] == "OM_atk3" then
      if unit.config.is_summoned ~= true then
        table.insert(list, {
          unit,
          ed.rand()
        })
      end
    elseif not unit.buff_effects.untargetable and not unit.buffManager.invisible then
      table.insert(list, {
        unit,
        ed.rand()
      })
    end
  end
  table.sort(list, function(a, b)
    return a[2] > b[2]
  end)
  local count = math.min(times, #list)
  local ret = {}
  for i = 1, count do
    ret[i] = list[i][1]
  end
  return ret
end

function OM.skillult_takeEffectOn(basefunc, skill, target)
  local times = OM.OM_rand(skill)
  local enhance = false
  local originfo = skill.info
  for i = 1, times do
    basefunc(skill, target)
  end
  skill.info = originfo
end

function OM.skillult_finish(basefunc, skill)
  local caster = skill.caster
  local shard = caster.proto._shard
  if shard and shard._id == 1000241 and caster.shardSkillRank and caster.shardSkillRank >= 1 then
    local p = caster.shardSkill[1]["Script Arg1"] / 100
    if p > ed.rand() then
      caster:takeHeal(caster.shardSkill[1]["Script Arg2"], "mp", caster)
    end
  end
  basefunc(skill)
end

function OM.skillatk2_createProjectile(basefunc, skill)
  local targets = OM.OM_select_targets(skill)
  for i, unit in ipairs(targets) do
    local projectile = basefunc(skill)
    local h = projectile.height
    local v = projectile.zSpeed
    local a = skill.info["Tile Gravity"]
    local A = 0.5 * a
    local B = v
    local C = h
    local delta = B ^ 2 - 4 * A * C
    local t = (-B - delta ^ 0.5) / (2 * A)
    local target_position = unit.position
    local distance = ed.edpSub(target_position, projectile.position)
    projectile.velocity = ed.edpMult(distance, 1 / t)
    ed.engine:addProjectile(projectile)
  end
  return nil
end

function OM.skillatk3_takeEffectOn(basefunc, skill, target)
  local targets = OM.OM_select_targets(skill)
  for i, unit in ipairs(targets) do
    basefunc(skill, unit)
  end
end

function OM.skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local hast = buff.info.HAST
  if skill.evo_rank and skill.evo_rank >= 1 then
    buff:setAttribute("HAST", hast + skill.evo_rank1["Script Arg1"])
  end
  if skill.evo_rank and skill.evo_rank >= 2 then
    buff:setAttribute("HAST", hast + skill.evo_rank1["Script Arg1"] + skill.evo_rank2["Script Arg1"])
  end
  return buff
end

function OM.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.dt = nil
  hero.Shard2Count = 0
end

function OM.update(basefunc, self, dt)
  local shard = self.proto._shard
  self.dt = self.dt and self.dt + dt or dt
  if self.dt == 1 then
    if shard and shard._id == 1000241 and self.shardSkillRank and self.shardSkillRank >= 2 then
      local bid = OM.shard2_buff
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, self, self)
      self:addBuff(buff, self)
      self.Shard2Count = 0
    end
    if shard and shard._id == 1000241 and self.shardSkillRank and self.shardSkillRank >= 3 then
      local str = self.attribs.STR
      local bid = OM.shard3_buff
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, self, self)
      buff:setAttribute("AP", str)
      self:addBuff(buff, self)
    end
  end
  basefunc(self, dt)
end

function OM.hero_getLostHPAfterImmunity(basefunc, hero, damage, immunity)
  local haveshardbuff = false
  local shard = hero.proto._shard
  local shardbuff
  for i, tbuff in ipairs(hero.buff_list) do
    if tbuff.info.ID == OM.shard2_buff then
      shardbuff = tbuff
      haveshardbuff = true
    end
  end
  if haveshardbuff and hero.Shard2Count and hero.Shard2Count < 3 then
    if shard and shard._id == 1000241 and hero.shardSkillRank and hero.shardSkillRank >= 2 then
      local reduce = hero.shardSkill[2]["Script Arg2"] / 100
      damage = damage * (1 - reduce)
      hero.Shard2Count = hero.Shard2Count + 1
    end
    if hero.Shard2Count == 3 then
      shardbuff.timer = -1
    end
  end
  return basefunc(hero, damage, immunity)
end

function OM.init_hero(hero)
  local skillult = hero.skills.OM_ult
  local skillatk2 = hero.skills.OM_atk2
  local skillatk3 = hero.skills.OM_atk3
  local skillpasv = hero.passive_skill_list[1]
  local shard = hero.proto._shard
  hero.reset = override(hero.reset, OM.hero_reset)
  hero.update = override(hero.update, OM.update)
  if shard and shard._id == 1000241 and hero.shardSkillRank and hero.shardSkillRank >= 2 then
    hero.getLostHPAfterImmunity = override(hero.getLostHPAfterImmunity, OM.hero_getLostHPAfterImmunity)
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
    skillult.takeEffectOn = override(skillult.takeEffectOn, OM.skillult_takeEffectOn)
    skillult.finish = override(skillult.finish, OM.skillult_finish)
  end
  if skillatk2 then
    if skillatk2.evo_rank and 1 <= skillatk2.evo_rank then
      skillatk2.info = ed.wraptable(skillatk2.info, {
        ["Plus Ratio"] = skillatk2.evo_rank1["Script Arg1"]
      })
    end
    if skillatk2.evo_rank and 2 <= skillatk2.evo_rank then
      skillatk2.info = ed.wraptable(skillatk2.info, {
        ["Plus Ratio"] = skillatk2.evo_rank2["Script Arg1"]
      })
    end
    skillatk2.createProjectile = override(skillatk2.createProjectile, OM.skillatk2_createProjectile)
  end
  if skillatk3 then
    skillatk3.createBuff = override(skillatk3.createBuff, OM.skillatk3_createBuff)
    skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, OM.skillatk3_takeEffectOn)
  end
  if skillpasv then
    local aname = skillpasv["Passive Attr"]
    if skillpasv.evo_rank and 1 <= skillpasv.evo_rank then
      skillpasv["Basic Num"] = skillpasv["Basic Num"] + skillpasv.evo_rank1["Script Arg1"]
    end
    if skillpasv.evo_rank and 2 <= skillpasv.evo_rank then
      skillpasv["Basic Num"] = skillpasv["Basic Num"] + skillpasv.evo_rank2["Script Arg1"]
    end
    if skillpasv.evo_rank and skillpasv.evo_rank >= 3 then
      skillpasv["Basic Num"] = skillpasv["Basic Num"] + skillpasv.evo_rank3["Script Arg1"]
    end
    hero:rebuild()
  end
  return hero
end

return OM.init_hero
