module("ed.battlehero", package.seeall)
local ed = ed
Coco = {}
Coco.atk3Evobuff = 10000103
Coco.ultEvobuff = 10000104
Coco.ultshardbuff = 10000105
Coco.atk3shardbuff = 10000106
Coco.skillFashionId = 11

function Coco.skillatk2_takeEffectOn(basefunc, skill, target, source)
  basefunc(skill, target, source)
  local caster = skill.caster
  local shard = caster.proto._shard
  if shard and shard._id == 1000011 and caster.shardSkillRank and caster.shardSkillRank >= 2 then
    local ret
    local selector = ed.rand
    local max = -math.huge
    local chosen
    local caster_position = caster.position
    for unit in ed.engine:foreachAliveUnit(skill:targetCamp()) do
      if unit.buff_effects.untargetable then
      elseif unit.buffManager.invisible and unit.camp ~= caster.camp then
      elseif unit == target then
      else
        local distanceSQ = (unit.position[1] - caster_position[1]) ^ 2 + (unit.position[2] - caster_position[2]) ^ 2
        if distanceSQ >= skill.min_range_sq and distanceSQ <= skill.max_range_sq then
          local v = selector(unit)
          if max < v then
            max = v
            chosen = unit
          end
        end
      end
    end
    ret = chosen
    local skillatk3s = caster.skills.Coco_atk3s
    if ret then
      skillatk3s.target = ret
      skillatk3s:takeEffectAt(ret.position, caster)
    end
  end
end

function Coco.skillatk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local buffInfo = buff.info
  local owner = buff.owner
  local caster = buff.caster
  local attribName = buffInfo.Tenacity
  local TEN_final = ed.Buff.getTenValue(buffInfo, owner, caster)
  if skill.evo_rank and skill.evo_rank >= 2 then
    buff.timer = skill.evo_rank2["Script Arg1"] * math.max(0.01, 1 - TEN_final / 100)
  end
  return buff
end

function Coco.skillatk3_takeEffectOn(basefunc, skill, target, source)
  local ishit, damage = basefunc(skill, target, source)
  local caster = skill.caster
  local shard = caster.proto._shard
  if ishit and skill.evo_rank and skill.evo_rank >= 1 then
    local bid = Coco.atk3Evobuff
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, target, caster)
    target:addBuff(buff, caster)
  end
  if ishit and shard and shard._id == 1000011 and caster.shardSkillRank and 1 <= caster.shardSkillRank then
    local bid = Coco.atk3shardbuff
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, target, caster)
    buff:setAttribute("ARM", -(caster.shardSkill[1]["Script Arg1"] + caster.shardSkill[1]["Script Arg2"] * caster.attribs.AD))
    target:addBuff(buff, caster)
  end
  return ishit, damage
end

function Coco.launchPoint(basefunc, skill)
  local position, height = basefunc(skill)
  local direction = skill.caster.direction
  position[1] = position[1] - 400 * direction
  if position[1] < 0 or position[1] > 800 then
    position[1] = 400 - 400 * direction
  end
  position[2] = 0
  height = 10
  return position, height
end

function Coco.skillult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local buffInfo = buff.info
  local owner = buff.owner
  local caster = buff.caster
  local attribName = buffInfo.Tenacity
  local TEN_final = ed.Buff.getTenValue(buffInfo, owner, caster)
  if skill.evo_rank and skill.evo_rank >= 3 then
    buff.timer = skill.evo_rank3["Script Arg1"] * math.max(0.01, 1 - TEN_final / 100)
  end
  buff.onRemoved = override(buff.onRemoved, Coco.skillultbuff_onRemoved)
  return buff
end

function Coco.skillultbuff_onRemoved(basefunc, buff)
  local caster = buff.caster
  local owner = buff.owner
  local shard = caster.proto._shard
  if shard and shard._id == 1000011 and caster.shardSkillRank and caster.shardSkillRank >= 3 and not owner.buff_effects.invulnerable then
    local bid = Coco.ultshardbuff
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, owner, caster)
    owner:addBuff(buff, caster)
  end
  basefunc(buff)
end

function Coco.skillult_createProjectile(basefunc, skill)
  local caster = skill.caster
  local projectile = basefunc(skill)
  projectile.terminate = override(projectile.terminate, Coco.skillult_PTerminate)
  return projectile
end

function Coco.skillult_PTerminate(basefunc, self)
  local caster = self.caster
  if ed.run_with_scene then
    local effect_name = "eff_impact_Coco_ult.cha"
    if not effect_name then
      return
    end
    ed.scene:playEffectOnScene(effect_name, self.position, {
      self.direction * 1,
      1
    }, nil, 1)
  end
  basefunc(self)
end

function Coco.skillult_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  basefunc(skill)
  if skill.evo_rank and skill.evo_rank >= 1 then
    local bid = Coco.ultEvobuff
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    for unit in ed.engine:foreachAliveUnit(caster.camp) do
      local buff = ed.BuffCreate(binfo, unit, caster)
      unit:addBuff(buff, caster)
    end
  end
end

function Coco.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  if not hero.start then
    hero.start = true
    if ed.run_with_scene then
    end
  end
end

function Coco.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.start = false
end

function Coco.init_hero(hero)
  local skillult = hero.skills.Coco_ult
  local skillatk2 = hero.skills.Coco_atk3
  local skillatk3 = hero.skills.Coco_atk2
  local skillpasv = hero.passive_skill_list[1]
  local skillFashionSenior = hero.skills.Coco_fashion_senior
  hero.update = override(hero.update, Coco.hero_update)
  hero.reset = override(hero.reset, Coco.hero_reset)
  local shard = hero.proto._shard
  if skillult then
    skillult.createProjectile = override(skillult.createProjectile, Coco.skillult_createProjectile)
    skillult.launchPoint = override(skillult.launchPoint, Coco.launchPoint)
    skillult.onAttackFrame = override(skillult.onAttackFrame, Coco.skillult_onAttackFrame)
    skillult.createBuff = override(skillult.createBuff, Coco.skillult_createBuff)
    if skillult.evo_rank and skillult.evo_rank >= 2 then
      skillult.info = ed.wraptable(skillult.info, {
        ["Plus Ratio"] = skillult.evo_rank2["Script Arg1"]
      })
    end
  end
  if skillatk2 then
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, Coco.skillatk2_takeEffectOn)
    skillatk2.createBuff = override(skillatk2.createBuff, Coco.skillatk2_createBuff)
    if skillatk2.evo_rank and 1 <= skillatk2.evo_rank then
      skillatk2.info = ed.wraptable(skillatk2.info, {
        ["Plus Ratio"] = skillatk2.evo_rank1["Script Arg1"]
      })
    end
    if skillatk2.evo_rank and skillatk2.evo_rank >= 3 then
      skillatk2.info = ed.wraptable(skillatk2.info, {
        ["Plus Ratio"] = skillatk2.evo_rank3["Script Arg1"]
      })
    end
  end
  if skillatk3 then
    skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, Coco.skillatk3_takeEffectOn)
    if skillatk3.evo_rank and skillatk3.evo_rank >= 2 then
      skillatk3.info = ed.wraptable(skillatk3.info, {
        ["Plus Ratio"] = skillatk3.evo_rank2["Script Arg1"]
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
    local num = skillpasv["Basic Num"]
    local oriattribs = hero.attribs[aname]
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

return Coco.init_hero
