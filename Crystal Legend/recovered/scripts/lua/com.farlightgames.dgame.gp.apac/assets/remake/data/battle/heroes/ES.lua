module("ed.battlehero", package.seeall)
local ed = ed
ES = {}
ES.SkillEvoPointEffect = "eff_point_ES_awake.cha"
ES.shardbuff = 10003004

function ES.skill_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local skillevo = skill.caster.skills.ES_evo
  local self = skill.caster
  local target = skill.target
  local enemyCount = 0
  local info = skillevo.info
  local direction = skill.caster.direction
  local location = skill.caster.position
  local origin = {
    location[1],
    location[2]
  }
  local shape = "circle"
  local arg1 = info["Shape Arg1"]
  local arg2 = info["Shape Arg2"]
  for unit in ed.engine:foreachAliveUnit(skillevo:affectedCamp()) do
    local p2 = ed.edpSub(unit.position, origin)
    p2[1] = p2[1] * direction
    if skillevo.testPointInShape(p2, shape, arg1, arg2) then
      enemyCount = enemyCount + 1
      if ed.run_with_scene then
        local effect_name = ES.SkillEvoPointEffect
        local effect_z = info["Point Zorder"] or 0
        ed.scene:playEffectOnScene(effect_name, unit.position, {direction, 1}, nil, effect_z)
      end
    end
  end
  skillevo.enemyCount = enemyCount
  skillevo:takeEffectAt(skill.caster.position)
  local shard = self.proto._shard
  if shard and shard._id == 1000301 and self.shardSkillRank and self.shardSkillRank >= 3 then
    local bid = ES.shardbuff
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    self:addBuff(binfo, self)
  end
end

function ES.skillevo_power(basefunc, skill, source, target, damage_type)
  local power, coefficient = basefunc(skill, source, target, damage_type)
  return power * skill.enemyCount, coefficient
end

function ES.init_hero(hero)
  local skillult = hero.skills.ES_ult
  local skillatk2 = hero.skills.ES_atk2
  local skillatk3 = hero.skills.ES_atk3
  local skillpasv = hero.passive_skill_list[1]
  local skillevo = hero.skills.ES_evo
  local shard = hero.proto._shard
  if skillevo then
    local skillnames = {
      "_ult",
      "_atk2",
      "_atk3"
    }
    for i = 1, #skillnames do
      local skill = hero.skills["ES" .. skillnames[i]]
      if skill and skill.evo_rank and skill.evo_rank >= 3 then
        skill.onAttackFrame = override(skill.onAttackFrame, ES.skill_onAttackFrame)
      end
    end
    skillevo.power = override(skillevo.power, ES.skillevo_power)
    if shard and shard._id == 1000301 then
      if hero.shardSkillRank and 1 <= hero.shardSkillRank then
        skillevo.info = ed.wraptable(skillevo.info, {
          ["Plus Ratio"] = hero.shardSkill[1]["Script Arg1"]
        })
      end
      if hero.shardSkillRank and 3 <= hero.shardSkillRank then
        skillevo.info = ed.wraptable(skillevo.info, {
          ["Shape Arg1"] = hero.shardSkill[3]["Script Arg1"]
        })
      end
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
    if shard and shard._id == 1000301 and hero.shardSkillRank and hero.shardSkillRank >= 2 then
      skillpasv["Basic Num"] = skillpasv["Basic Num"] + hero.shardSkill[2]["Script Arg1"] / 100 * hero.attribs.STR
    end
    hero:rebuild()
  end
  return hero
end

return ES.init_hero
