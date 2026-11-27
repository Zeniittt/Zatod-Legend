module("ed.battlehero", package.seeall)
local ed = ed
Naga = {}
Naga.mirror_time = 15
Naga.atk2Evobuff = 10001303
Naga.NagaMirror = 10001304
Naga.mirrorAttribs = 10001305

function Naga.skillult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local buffInfo = buff.info
  local owner = buff.owner
  local caster = buff.caster
  local attribName = buffInfo.Tenacity
  local timer = buff.timer
  local TEN_final = ed.Buff.getTenValue(buffInfo, owner, caster)
  if skill.evo_rank and skill.evo_rank >= 1 then
    buff.timer = timer + skill.evo_rank1["Script Arg1"] * math.max(0.01, 1 - TEN_final / 100)
  end
  if skill.evo_rank and skill.evo_rank >= 2 then
    buff.timer = timer + (skill.evo_rank1["Script Arg1"] + skill.evo_rank2["Script Arg1"]) * math.max(0.01, 1 - TEN_final / 100)
  end
  if skill.evo_rank and skill.evo_rank >= 3 then
    buff.timer = timer + (skill.evo_rank1["Script Arg1"] + skill.evo_rank2["Script Arg1"] + skill.evo_rank3["Script Arg1"]) * math.max(0.01, 1 - TEN_final / 100)
  end
  return buff
end

function Naga.skillatk2_takeEffectOn(basefunc, skill, target, source)
  local ishit, damage = basefunc(skill, target, source)
  if ishit and skill.evo_rank and skill.evo_rank >= 1 then
    local caster = skill.caster
    local bid = Naga.atk2Evobuff
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, target, caster)
    target:addBuff(buff, caster)
  end
  return ishit, damage
end

function Naga.skillatk3_createBuff(basefunc, skill, target)
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

function Naga.NagaMirror_update(basefunc, unit, dt)
  unit.mDuration_Naga = unit.mDuration_Naga - dt
  if unit.mDuration_Naga <= 0 then
    unit:die()
  else
    basefunc(unit, dt)
  end
end

function Naga.mirrorSkillAtk2_takeEffectOn(basefunc, skill, target, source)
  local ishit, damage = basefunc(skill, target, source)
  if ishit then
    local caster = skill.caster
    local bid = Naga.atk2Evobuff
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, target, caster)
    target:addBuff(buff, caster)
  end
  return ishit, damage
end

function Naga.NagaonHitMiss(basefunc, self, skill)
  basefunc(self, skill)
  local skillpasv = self.passive_skill_list[1]
  local Nagalevel = skillpasv.level
  local caster = self
  local skillevel = {
    Nagalevel,
    Nagalevel,
    Nagalevel
  }
  if self.mobcd_Naga <= 0 then
    local proto = {
      _tid = 145,
      _level = Nagalevel or 1,
      _stars = self.stars,
      _rank = self.rank,
      _skill_levels = skillevel,
      _fashion = self.fashion_id
    }
    local config = {
      is_monster = true,
      estimate_rank = true,
      hp_mod = self.config.hp_mod or 1,
      dps_mod = self.config.dps_mod or 1
    }
    local NagaMirror = ed.UnitCreate(proto, self.camp, config)
    local shard = self.proto._shard
    if shard and shard._id == 1000131 and self.shardSkillRank and self.shardSkillRank >= 3 then
      local mirrorSkillAtk2 = NagaMirror.skills.NagaMirror_atk2
      local skillatk2 = self.skills.Naga_atk2
      if mirrorSkillAtk2 then
        mirrorSkillAtk2.cd_remaining = 0
      end
      if skillatk2 then
        if skillatk2.evo_rank and 1 <= skillatk2.evo_rank then
          mirrorSkillAtk2.takeEffectOn = override(mirrorSkillAtk2.takeEffectOn, Naga.mirrorSkillAtk2_takeEffectOn)
        end
        if skillatk2.evo_rank and skillatk2.evo_rank >= 2 then
          mirrorSkillAtk2.info = ed.wraptable(mirrorSkillAtk2.info, {
            ["Plus Ratio"] = skillatk2.evo_rank2["Script Arg1"]
          })
        end
        if skillatk2.evo_rank and 3 <= skillatk2.evo_rank then
          mirrorSkillAtk2.info = ed.wraptable(mirrorSkillAtk2.info, {
            ["Plus Ratio"] = skillatk2.evo_rank3["Script Arg1"]
          })
        end
      end
    end
    local bid = Naga.NagaMirror
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = NagaMirror:addBuff(binfo, caster)
    NagaMirror.mDuration_Naga = Naga.mirror_time
    NagaMirror.update = override(NagaMirror.update, Naga.NagaMirror_update)
    NagaMirror:setDeathWithEffectOrNot(true)
    NagaMirror.direction = self.direction
    local locationtb
    local rand = ed.rand()
    if rand <= 1 and 0.75 < rand then
      locationtb = {
        self.position[1] + NagaMirror.direction * 60,
        self.position[2] + NagaMirror.direction * 30
      }
    end
    if rand <= 0.75 and 0.5 < rand then
      locationtb = {
        self.position[1] + NagaMirror.direction * 60,
        self.position[2] - NagaMirror.direction * 30
      }
    end
    if rand <= 0.5 and 0.25 < rand then
      locationtb = {
        self.position[1] - NagaMirror.direction * 60,
        self.position[2] - NagaMirror.direction * 30
      }
    end
    if rand <= 0.25 then
      locationtb = {
        self.position[1] + NagaMirror.direction * 60,
        self.position[2]
      }
    end
    ed.engine:summonUnit(NagaMirror, locationtb, caster, "Birth")
    if self.nagalist == nil then
      self.nagalist = {}
    end
    table.insert(self.nagalist, NagaMirror)
    self.mobcd_Naga = self.shardSkill[1]["Script Arg1"]
    local AttriBinfo = ed.lookupDataTable("Buff", nil, Naga.mirrorAttribs)
    Naga.changeBuffInfo(AttriBinfo, self.shardSkill[1]["Script Arg2"] / 100, NagaMirror)
    NagaMirror:addBuff(AttriBinfo, caster)
    NagaMirror:takeHeal(NagaMirror.attribs.HP, "hp")
  end
end

function Naga.changeBuffInfo(buffInfo, enhance, target)
  local attrib_temp = {}
  local summoner = target.config.summoner
  for _, name in ipairs(ed.attrib_names) do
    local value = buffInfo[name] or 0
    local ele = buffInfo[name .. ".x"]
    if value ~= 0 or ele then
      attrib_temp[name] = true
    end
  end
  for name, _ in pairs(attrib_temp) do
    local x = buffInfo[name .. ".x"]
    if x then
      buffInfo[name .. ".a"] = enhance
      if name == "HP" and ed.engine.rogue_mode and target.camp == ed.emCampEnemy and (summoner.config.is_monster or summoner.config.is_boss) then
        buffInfo[name .. ".a"] = buffInfo[name .. ".a"] / target.config.hp_mod
      end
    end
  end
end

function Naga.update(basefunc, self, dt)
  basefunc(self, dt)
  if self.mobcd_Naga then
    self.mobcd_Naga = self.mobcd_Naga - dt
  end
  if self.mobcd_Naga_update then
    self.mobcd_Naga_update = self.mobcd_Naga_update - dt
  end
  self.dt = self.dt and self.dt + dt or dt
  local shard = self.proto._shard
  if shard and shard._id == 1000131 and self:isAlive() and self.shardSkillRank and self.shardSkillRank >= 2 and (self.mobcd_Naga_update and self.mobcd_Naga_update <= 0 or self.dt == 1) then
    local skillpasv = self.passive_skill_list[1]
    local Nagalevel = skillpasv.level
    local caster = self
    local skillevel = {
      Nagalevel,
      Nagalevel,
      Nagalevel
    }
    local proto = {
      _tid = 145,
      _level = Nagalevel or 1,
      _stars = self.stars,
      _rank = self.rank,
      _skill_levels = skillevel,
      _fashion = self.fashion_id
    }
    local config = {
      is_monster = true,
      estimate_rank = true,
      hp_mod = self.config.hp_mod or 1,
      dps_mod = self.config.dps_mod or 1
    }
    local NagaMirror = ed.UnitCreate(proto, self.camp, config)
    if self.shardSkillRank and self.shardSkillRank >= 3 then
      local mirrorSkillAtk2 = NagaMirror.skills.NagaMirror_atk2
      local skillatk2 = self.skills.Naga_atk2
      if mirrorSkillAtk2 then
        mirrorSkillAtk2.cd_remaining = 0
      end
      if skillatk2 then
        if skillatk2.evo_rank and 1 <= skillatk2.evo_rank then
          mirrorSkillAtk2.takeEffectOn = override(mirrorSkillAtk2.takeEffectOn, Naga.mirrorSkillAtk2_takeEffectOn)
        end
        if skillatk2.evo_rank and 2 <= skillatk2.evo_rank then
          mirrorSkillAtk2.info = ed.wraptable(mirrorSkillAtk2.info, {
            ["Plus Ratio"] = skillatk2.evo_rank2["Script Arg1"]
          })
        end
        if skillatk2.evo_rank and 3 <= skillatk2.evo_rank then
          mirrorSkillAtk2.info = ed.wraptable(mirrorSkillAtk2.info, {
            ["Plus Ratio"] = skillatk2.evo_rank3["Script Arg1"]
          })
        end
      end
    end
    local bid = Naga.NagaMirror
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = NagaMirror:addBuff(binfo, caster)
    NagaMirror.mDuration_Naga = Naga.mirror_time
    NagaMirror.update = override(NagaMirror.update, Naga.NagaMirror_update)
    NagaMirror:setDeathWithEffectOrNot(true)
    NagaMirror.direction = self.direction
    local locationtb
    local rand = ed.rand()
    if rand <= 1 and 0.75 < rand then
      locationtb = {
        self.position[1] + NagaMirror.direction * 100,
        self.position[2] + NagaMirror.direction * 50
      }
    end
    if rand <= 0.75 and 0.5 < rand then
      locationtb = {
        self.position[1] + NagaMirror.direction * 100,
        self.position[2] - NagaMirror.direction * 50
      }
    end
    if rand <= 0.5 and 0.25 < rand then
      locationtb = {
        self.position[1] - NagaMirror.direction * 100,
        self.position[2] - NagaMirror.direction * 50
      }
    end
    if rand <= 0.25 then
      locationtb = {
        self.position[1] + NagaMirror.direction * 100,
        self.position[2]
      }
    end
    ed.engine:summonUnit(NagaMirror, locationtb, caster, "Birth")
    if self.nagalist == nil then
      self.nagalist = {}
    end
    table.insert(self.nagalist, NagaMirror)
    local AttriBinfo = ed.lookupDataTable("Buff", nil, Naga.mirrorAttribs)
    Naga.changeBuffInfo(AttriBinfo, self.shardSkill[2]["Script Arg2"] / 100, NagaMirror)
    NagaMirror:addBuff(AttriBinfo, caster)
    NagaMirror:takeHeal(NagaMirror.attribs.HP, "hp")
    local NagaMirror2 = ed.UnitCreate(proto, self.camp, config)
    if self.shardSkillRank and self.shardSkillRank >= 3 then
      local mirrorSkillAtk2 = NagaMirror.skills.NagaMirror_atk2
      local skillatk2 = self.skills.Naga_atk2
      if mirrorSkillAtk2 then
        mirrorSkillAtk2.cd_remaining = 0
      end
      if skillatk2 then
        if skillatk2.evo_rank and 1 <= skillatk2.evo_rank then
          mirrorSkillAtk2.takeEffectOn = override(mirrorSkillAtk2.takeEffectOn, Naga.mirrorSkillAtk2_takeEffectOn)
        end
        if skillatk2.evo_rank and 2 <= skillatk2.evo_rank then
          mirrorSkillAtk2.info = ed.wraptable(mirrorSkillAtk2.info, {
            ["Plus Ratio"] = skillatk2.evo_rank2["Script Arg1"]
          })
        end
        if skillatk2.evo_rank and 3 <= skillatk2.evo_rank then
          mirrorSkillAtk2.info = ed.wraptable(mirrorSkillAtk2.info, {
            ["Plus Ratio"] = skillatk2.evo_rank3["Script Arg1"]
          })
        end
      end
    end
    local bid = Naga.NagaMirror
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = NagaMirror2:addBuff(binfo, caster)
    NagaMirror2.mDuration_Naga = Naga.mirror_time
    NagaMirror2.update = override(NagaMirror2.update, Naga.NagaMirror_update)
    NagaMirror2:setDeathWithEffectOrNot(true)
    NagaMirror2.direction = self.direction
    local locationtb
    local rand = ed.rand()
    if rand <= 1 and 0.75 < rand then
      locationtb = {
        self.position[1] + NagaMirror2.direction * 100,
        self.position[2] + NagaMirror2.direction * 50
      }
    end
    if rand <= 0.75 and 0.5 < rand then
      locationtb = {
        self.position[1] + NagaMirror2.direction * 100,
        self.position[2] - NagaMirror2.direction * 50
      }
    end
    if rand <= 0.5 and 0.25 < rand then
      locationtb = {
        self.position[1] - NagaMirror2.direction * 100,
        self.position[2] - NagaMirror2.direction * 50
      }
    end
    if rand <= 0.25 then
      locationtb = {
        self.position[1] + NagaMirror2.direction * 100,
        self.position[2]
      }
    end
    ed.engine:summonUnit(NagaMirror2, locationtb, caster, "Birth")
    if self.nagalist == nil then
      self.nagalist = {}
    end
    table.insert(self.nagalist, NagaMirror2)
    local AttriBinfo = ed.lookupDataTable("Buff", nil, Naga.mirrorAttribs)
    Naga.changeBuffInfo(AttriBinfo, self.shardSkill[2]["Script Arg2"] / 100, NagaMirror2)
    NagaMirror2:addBuff(AttriBinfo, caster)
    NagaMirror2:takeHeal(NagaMirror2.attribs.HP, "hp")
    self.mobcd_Naga_update = self.shardSkill[2]["Script Arg1"]
  end
end

function Naga.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.nagalist = {}
  hero.mobcd_Naga = 0
  hero.mobcd_Naga_update = hero.shardSkill[2]["Script Arg1"]
end

function Naga.hero_die(basefunc, hero, killer)
  if hero.nagalist then
    for i, naga in ipairs(hero.nagalist) do
      if naga and naga:isAlive() then
        naga:die()
      end
    end
  end
  basefunc(hero, killer)
end

function Naga.init_hero(hero)
  local skillult = hero.skills.Naga_ult
  local skillatk2 = hero.skills.Naga_atk2
  local skillatk3 = hero.skills.Naga_atk3
  local skillpasv = hero.passive_skill_list[1]
  if skillult then
    skillult.createBuff = override(skillult.createBuff, Naga.skillult_createBuff)
  end
  if skillatk2 then
    if skillatk2.evo_rank and 1 <= skillatk2.evo_rank then
      skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, Naga.skillatk2_takeEffectOn)
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
      skillatk3.createBuff = override(skillatk3.createBuff, Naga.skillatk3_createBuff)
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
  local shard = hero.proto._shard
  if shard and shard._id == 1000131 and hero.shardSkillRank and 1 <= hero.shardSkillRank then
    hero.die = override(hero.die, Naga.hero_die)
    hero.onHitMiss = override(hero.onHitMiss, Naga.NagaonHitMiss)
    hero.update = override(hero.update, Naga.update)
    hero.reset = override(hero.reset, Naga.hero_reset)
  end
  return hero
end

return Naga.init_hero
