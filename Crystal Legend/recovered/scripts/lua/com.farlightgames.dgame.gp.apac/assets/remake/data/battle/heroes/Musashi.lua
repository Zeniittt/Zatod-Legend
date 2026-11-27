module("ed.battlehero", package.seeall)
local ed = ed
Musashi = {}
Musashi.uncontrol_bid = 11000405
Musashi.enemy_hprecover_bid = 11000401
Musashi.self_hprecover_bid = 11000401
Musashi.hp_recover_time = 12
Musashi.reflection_bid = 11000403
Musashi.reflection_range = 180
Musashi.skillatk3_projectile_height = 20
Musashi.nil_bid = 11000406
Musashi.skillatk4_bid = 11000404

function Musashi.reflectionbuff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local caster = buff.caster
  for _, projectile in ipairs(ed.engine.projectile_list) do
    if projectile.camp == caster.camp then
    elseif not projectile.can_be_influenced then
    elseif projectile.is_region or projectile.is_chain then
    else
      local xy = ed.edpSub(caster.position, projectile.position)
      local l = (xy[1] * xy[1] + xy[2] * xy[2]) ^ 0.5
      if l <= Musashi.reflection_range then
        projectile:terminate()
      end
    end
  end
end

function Musashi.reflection_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.update = override(buff.update, Musashi.reflectionbuff_update)
  return buff
end

function Musashi.skillult_start(basefunc, skill, target)
  local caster = skill.caster
  local bid = Musashi.uncontrol_bid
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  caster:addBuff(binfo, caster)
  basefunc(skill, target)
end

function Musashi.skillult_takeEffectOn(basefunc, skill, target, source, shift)
  local caster = skill.caster
  local attack_counter = skill.attack_counter
  if attack_counter <= 4 then
    basefunc(skill, target, source, shift)
  else
  end
  if attack_counter == 4 and skill.evo_rank and skill.evo_rank >= 3 and target then
    local bid = 11000407
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    target:addBuff(binfo, caster)
  end
end

function Musashi.skillult_onAttackFrame(basefunc, skill)
  local originfo = skill.info
  local attack_counter = skill.attack_counter
  if attack_counter == 3 then
    if skill.evo_rank and 3 <= skill.evo_rank then
      skill.info = ed.wraptable(originfo, {
        ["Knock Up"] = 0.9,
        ["Knock Back"] = 20,
        ["No Dodge"] = true
      })
    else
      skill.info = ed.wraptable(originfo, {
        ["Knock Up"] = 0.9,
        ["Knock Back"] = 20
      })
    end
    basefunc(skill)
    skill.info = originfo
  else
    basefunc(skill)
  end
  if attack_counter ~= 4 then
    local caster = skill.caster
    local skillatk3 = caster.skills.Musashi_atk3
    if skillatk3 then
      caster:takeHeal(caster.skillatk3_heal, "hp", caster)
    end
    local skillultb = caster.skills.Musashi_ultb
    if skillultb then
      local isbuff
      for i, buff in ipairs(caster.buff_list) do
        if buff.info.ID == Musashi.reflection_bid then
          buff.timer = 0
          break
        end
      end
      skillultb:takeEffectOn(caster)
    end
  end
end

function Musashi.skillult_finish(basefunc, skill, reason)
  basefunc(skill, reason)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == Musashi.uncontrol_bid then
      caster:removeBuff(tbuff)
    end
  end
end

function Musashi.skillatk2_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  caster.Musashi_atk1_list = {}
end

function Musashi.skillatk2_takeEffectAt(basefunc, skill, location, source)
  basefunc(skill, location, source)
  local caster = skill.caster
  local maxHP = 0
  local maxHPUnit
  if caster.Musashi_atk1_list then
    for i, unit in ipairs(caster.Musashi_atk1_list) do
      if maxHP < unit.hp then
        maxHP = unit.hp
        maxHPUnit = unit
      end
    end
  end
  if maxHPUnit then
    local losthp_ratio = 0.25
    if skill.evo_rank and skill.evo_rank >= 2 then
      losthp_ratio = 0.35
    end
    local losthp = maxHP * losthp_ratio
    if maxHP <= losthp then
      losthp = maxHP - 1
    end
    if losthp > caster.attribs.HP then
      losthp = caster.attribs.HP
    end
    if maxHPUnit:isAlive() then
      maxHPUnit:setHP(maxHP - losthp)
      if skill.evo_rank and skill.evo_rank >= 3 then
        losthp = losthp * 0.5
      end
      local bid = Musashi.enemy_hprecover_bid
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local hp_recover_buff = ed.BuffCreate(binfo, maxHPUnit, caster)
      hp_recover_buff:setAttribute("HPR", losthp / Musashi.hp_recover_time)
      hp_recover_buff.timer = Musashi.hp_recover_time
      maxHPUnit:addBuff(hp_recover_buff, caster)
    end
  end
end

function Musashi.skillatk2_takeEffectOn(basefunc, self, target, source, shift)
  local result, dmg, Crit, lfs_amount = basefunc(self, target, source, shift)
  local caster = self.caster
  if caster.Musashi_atk1_list then
    table.insert(caster.Musashi_atk1_list, target)
  end
  return result, dmg, Crit, lfs_amount
end

function Musashi.onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local skillatk3 = caster.skills.Musashi_atk3
  if skillatk3 then
    caster:takeHeal(caster.skillatk3_heal, "hp", caster)
  end
  if skill.info["Skill Name"] == "Musashi_atk4" and ed.run_with_scene then
    local effect_name = "eff_point_Musashi_atk3"
    if skill.target then
      ed.scene:playEffectOnScene(effect_name, skill.target.position, {1, 1}, nil, 1)
    end
  end
end

function Musashi.skillatk3_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  local caster = skill.caster
  projectile.position = {
    caster.Musashi_maxHPUnit.position[1],
    caster.Musashi_maxHPUnit.position[2]
  }
  projectile.height = Musashi.skillatk3_projectile_height
  local info = skill.info
  local v = {
    info["Tile XY Speed"],
    info["Tile Z Speed"]
  }
  local d = ed.edpSub(caster.position, projectile.position)
  if info["Aim Target"] then
    if d[1] == 0 and d[2] == 0 then
      projectile.velocity = {
        -caster.direction,
        0
      }
    else
      projectile.velocity = ed.edpMult(ed.edpNormalize(d), v[1])
    end
  else
    d[2] = 0
    if d[1] == 0 and d[2] == 0 then
      projectile.velocity = {
        -caster.direction,
        0
      }
    else
      projectile.velocity = ed.edpMult(ed.edpNormalize(d), v[1])
    end
  end
  projectile.zSpeed = v[2]
  return projectile
end

function Musashi.skillatk4_selectTarget(basefunc, self, default)
  local target = basefunc(self, default)
  local caster = self.caster
  local maxDebuffCounts = 0
  local maxDebuffCountsUnit = target
  for unit in ed.engine:foreachAliveUnit(self:targetCamp()) do
    if unit.buff_effects.untargetable then
    else
      local debuffcounts = 0
      local my_camp = caster.camp
      for i, buff in ipairs(unit.buff_list) do
        if buff and (not buff.caster or buff.caster.camp ~= my_camp) and buff.info.Dispel == "YES" then
          debuffcounts = debuffcounts + 1
        end
      end
      if maxDebuffCounts < debuffcounts then
        maxDebuffCounts = debuffcounts
        maxDebuffCountsUnit = unit
      end
    end
  end
  self.target = maxDebuffCountsUnit
  return self.target
end

function Musashi.skillatk4_takeEffectOn(basefunc, skill, target, source, shift)
  local my_camp = skill.caster.camp
  local list = target.buff_list
  local debuff_list = {}
  for i = 1, #list do
    local buff = list[i]
    if buff and (not buff.caster or buff.caster.camp ~= my_camp) and buff.info.Dispel == "YES" then
      debuff_list[#debuff_list + 1] = buff
    end
  end
  for i = 1, #debuff_list do
    target:removeBuff(debuff_list[i])
  end
  local bid = Musashi.skillatk4_bid
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = target:addBuff(binfo, skill.caster)
  if skill.evo_rank and skill.evo_rank >= 3 and buff then
    buff.timer = 4 + #debuff_list
  end
  basefunc(skill, target, source, shift)
end

function Musashi.collectBuff(basefunc, self, config)
  local buff = config.buff
  local owner = buff.owner
  if buff.owner:isAlive() and not buff.Musashi_trigger then
    for i, tbuff in ipairs(owner.buff_list) do
      if tbuff.info.ID == Musashi.skillatk4_bid and tbuff.owner and buff.caster and tbuff.owner.camp == buff.caster.camp and buff.info.Dispel == "YES" then
        owner:removeBuff(buff)
        local bid = Musashi.nil_bid
        local binfo = ed.lookupDataTable("Buff", nil, bid)
        config.buff = ed.BuffCreate(binfo, owner, buff.caster)
        config.buff.Musashi_trigger = true
        break
      end
    end
  end
end

function Musashi.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.skillatk3_heal = 0
  local skillatk3 = hero.skills.Musashi_atk3
  if skillatk3 then
    hero.skillatk3_heal = skillatk3.info["Script Arg2"] + hero.attribs.HP * 0.02
    if skillatk3.evo_rank and skillatk3.evo_rank >= 1 then
      hero.skillatk3_heal = hero.skillatk3_heal + skillatk3.evo_rank1["Script Arg1"]
    end
    if skillatk3.evo_rank and skillatk3.evo_rank >= 2 then
      hero.skillatk3_heal = hero.skillatk3_heal + skillatk3.evo_rank2["Script Arg1"]
    end
    if skillatk3.evo_rank and skillatk3.evo_rank >= 3 then
      hero.skillatk3_heal = hero.skillatk3_heal + skillatk3.evo_rank3["Script Arg1"]
    end
  end
end

function Musashi.init_hero(hero)
  hero.reset = override(hero.reset, Musashi.hero_reset)
  local skillult = hero.skills.Musashi_ult
  local skillultb = hero.skills.Musashi_ultb
  if skillult then
    if skillultb then
      skillultb.createBuff = override(skillultb.createBuff, Musashi.reflection_createBuff)
    end
    skillult.start = override(skillult.start, Musashi.skillult_start)
    skillult.onAttackFrame = override(skillult.onAttackFrame, Musashi.skillult_onAttackFrame)
    skillult.takeEffectOn = override(skillult.takeEffectOn, Musashi.skillult_takeEffectOn)
    skillult.finish = override(skillult.finish, Musashi.skillult_finish)
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
  end
  local skillatk = hero.skills.Musashi_atk
  if skillatk then
    skillatk.onAttackFrame = override(skillatk.onAttackFrame, Musashi.onAttackFrame)
  end
  local skillatk2 = hero.skills.Musashi_atk2
  if skillatk2 then
    skillatk2.start = override(skillatk2.start, Musashi.skillatk2_start)
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, Musashi.onAttackFrame)
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, Musashi.skillatk2_takeEffectOn)
    skillatk2.takeEffectAt = override(skillatk2.takeEffectAt, Musashi.skillatk2_takeEffectAt)
    if skillatk2.evo_rank and skillatk2.evo_rank >= 1 then
      skillatk2.info = ed.wraptable(skillatk2.info, {
        ["Plus Ratio"] = skillatk2.evo_rank1["Script Arg1"]
      })
    end
  end
  local skillatk3 = hero.skills.Musashi_atk3
  if skillatk3 then
    skillatk3.createProjectile = override(skillatk3.createProjectile, Musashi.skillatk3_createProjectile)
  end
  local skillatk4 = hero.skills.Musashi_atk4
  if skillatk4 then
    hero.collectBuff = override(hero.collectBuff, Musashi.collectBuff)
    skillatk4.onAttackFrame = override(skillatk4.onAttackFrame, Musashi.onAttackFrame)
    skillatk4.selectTarget = override(skillatk4.selectTarget, Musashi.skillatk4_selectTarget)
    skillatk4.takeEffectOn = override(skillatk4.takeEffectOn, Musashi.skillatk4_takeEffectOn)
    if skillatk4.evo_rank and skillatk4.evo_rank >= 1 then
      skillatk4.info = ed.wraptable(skillatk4.info, {
        ["Plus Ratio"] = skillatk4.evo_rank1["Script Arg1"]
      })
    end
    if skillatk4.evo_rank and skillatk4.evo_rank >= 2 then
      skillatk4.info = ed.wraptable(skillatk4.info, {
        ["Plus Ratio"] = skillatk4.evo_rank2["Script Arg1"]
      })
    end
  end
  return hero
end

return Musashi.init_hero
