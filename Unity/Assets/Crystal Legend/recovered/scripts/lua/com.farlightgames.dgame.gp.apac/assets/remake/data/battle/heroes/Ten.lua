module("ed.battlehero", package.seeall)
local ed = ed
Ten = {}
Ten.dispelRange = 240
Ten.Ten_sawake_bid = 1258
Ten.nil_bid = 1259

function Ten.skillatk_onAttackFrame(basefunc, self)
  local target = self.target
  local caster = self.caster
  if self.caster.manually_casting then
    ed.engine:unfreeze()
    self.caster.manually_casting = false
  end
  self.attack_counter = self.attack_counter + 1
  if self.info["Target Type"] == "random" or self.target == nil or not self.target:isAlive() then
    self:selectTarget(nil)
  end
  if self.attack_counter == 1 then
    if ed.run_with_scene then
      ed.scene:playEffectOnScene("eff_impact_Ten_atk.cha", target.position, {
        caster.direction,
        1
      }, nil, 1)
    end
  else
    basefunc(self)
  end
end

function Ten.skillatk_takeEffectOn(basefunc, skill, target, source)
  basefunc(skill, target, source)
  local caster = skill.caster
  local originfo = skill.info
  skill.info = ed.wraptable(originfo, {
    ["Target Camp"] = 1,
    ["Affected Camp"] = 1
  })
  local projectile = skill:createProjectile()
  ed.engine:addProjectile(projectile)
  projectile.direction = -projectile.direction
  projectile.position = {
    target.position[1],
    target.position[2]
  }
  skill.info = originfo
  local skillatk2 = caster.skills.Ten_atk2
  if skillatk2 then
    skillatk2.cd_remaining = 3
  end
end

function Ten:projectile_hit(target)
  if ed.run_with_scene then
    ed.scene:playEffectOnScene("eff_impact_Ten_atks.cha", {
      target.position[1],
      target.position[2] - 1
    }, {
      target.direction,
      1
    }, nil, 1)
  end
end

function Ten.projectile_update(basefunc, projectile, dt)
  if projectile.birthtick == ed.engine.ticks then
    return
  end
  local target = projectile.track_target
  projectile.previous_position = {
    projectile.position[1],
    projectile.position[2]
  }
  ed.Entity.update(projectile, dt)
  local info = projectile.skill.info
  projectile.height = projectile.height + projectile.zSpeed * dt
  projectile.zSpeed = projectile.zSpeed + info["Tile Gravity"] * dt
  projectile.distance = projectile.distance + info["Tile XY Speed"] * dt
  local collide = projectile:collideCheck(projectile.caster)
  if collide then
    projectile:hit(projectile.caster)
    projectile:terminate()
  end
  if not projectile.terminated and (projectile:isOutOfStage() or projectile.height < 0 or projectile.distance > projectile.max_distance) then
    projectile:terminate()
  end
  if not projectile.terminated and not projectile.skill.caster:isAlive() then
    projectile:terminate()
  end
  local v = 300
  local target = projectile.skill.caster
  if not target then
    return
  end
  local targetpos = target.position
  local targetxyV = ed.edpSub(targetpos, projectile.position)
  local targetzV = -projectile.height + 40
  local u = (targetxyV[1] * targetxyV[1] + targetxyV[2] * targetxyV[2] + targetzV * targetzV) ^ (-0.5)
  local targetV = {
    targetxyV[1] * u,
    targetxyV[2] * u,
    targetzV * u
  }
  projectile.velocity[1] = targetV[1] * v
  projectile.velocity[2] = targetV[2] * v
  projectile.zSpeed = targetV[3] * v
end

function Ten.skillatk_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  local target = skill.caster
  if not target then
    return
  end
  projectile:enableTrack(target)
  projectile.hit = override(projectile.hit, Ten.projectile_hit)
  projectile.update = override(projectile.update, Ten.projectile_update)
  return projectile
end

function Ten.skillatk2_createProjectile(basefunc, skill)
  local target = skill.target
  local projectile = basefunc(skill, target)
  projectile:enableTrack(target)
  ed.engine:addProjectile(projectile)
end

function Ten.skillatk2_takeEffectOn(basefunc, skill, target, source, shift)
  local result = basefunc(skill, target, source, shift)
  if result then
    local skillawake = skill.caster.skills.Ten_awake
    if skillawake then
      skillawake:takeEffectOn(target, skill.caster)
    end
  end
end

function Ten.dispelCheckLevel(skillLevel, targetLevel)
  if ed.rand() < 0.3 then
    return true
  end
  local dice = 20
  if skillLevel < 30 then
    skillLevel = 10 + skillLevel / 30 * 20
  end
  dice = dice * ed.rand()
  local pass = targetLevel <= skillLevel + dice
  return pass
end

function Ten.dispelBuff_onRemoved(basefunc, buff)
  local caster = buff.caster
  local skill = buff.originSkill
  local owner = buff.owner
  if ed.run_with_scene then
    local effect_name = "eff_point_Ten_atk3.cha"
    ed.scene:playEffectOnScene(effect_name, owner.position, {
      owner.direction,
      1
    }, nil, 1)
  end
  for unit in ed.engine:foreachAliveUnit(ed.emCampBoth) do
    if unit.buff_effects.untargetable then
    else
      local p2 = ed.edpSub(unit.position, owner.position)
      p2[1] = p2[1] * owner.direction
      if skill.testPointInShape(p2, "circle", Ten.dispelRange, Ten.dispelRange) and Ten.dispelCheckLevel(skill.level, unit.level) then
        local dispelledBuffList = {}
        local list = unit.buff_list
        for i = 1, #list do
          local unitBuff = list[i]
          if unitBuff and (not unitBuff.caster or unitBuff.caster.camp ~= caster.camp) and unitBuff.info.Dispel then
            table.insert(dispelledBuffList, unitBuff)
          end
        end
        if 0 < #dispelledBuffList then
          local randID = math.ceil(ed.rand() * #dispelledBuffList)
          local dispelledBuff = dispelledBuffList[randID]
          if dispelledBuff then
            dispelledBuff.timer = 0
          end
        end
      end
    end
  end
  basefunc(buff)
end

function Ten.skillatk3_createBuff(basefunc, skill, target)
  local dispelBuff = basefunc(skill, target)
  dispelBuff.originSkill = skill
  dispelBuff.onRemoved = override(dispelBuff.onRemoved, Ten.dispelBuff_onRemoved)
  return dispelBuff
end

function Ten.skillatk4_createBuff(basefunc, skill, target)
  local caster = skill.caster
  local maxDebuffCounts = 0
  local maxDebuffCountsUnit = target
  for unit in ed.engine:foreachAliveUnit(ed.emCampBoth) do
    if unit.buff_effects.untargetable then
    else
      local debuffcounts = 0
      local my_camp = caster.camp
      for i, buff in ipairs(unit.buff_list) do
        if caster.camp == target.camp then
          if buff and (not buff.caster or buff.caster.camp ~= my_camp) and buff.info.Dispel == "YES" then
            debuffcounts = debuffcounts + 1
          end
        elseif buff and (not buff.caster or buff.caster.camp ~= my_camp) and buff.info.Dispel == "YES" then
          debuffcounts = debuffcounts + 1
        end
      end
      if maxDebuffCounts < debuffcounts then
        maxDebuffCounts = debuffcounts
        maxDebuffCountsUnit = unit
      end
    end
  end
  skill.target = maxDebuffCountsUnit
  target = maxDebuffCountsUnit
  if caster.camp == target.camp then
    local list = target.buff_list
    local debuff_list = {}
    local my_camp = caster.camp
    for i = 1, #list do
      local buff = list[i]
      if buff and (not buff.caster or buff.caster.camp ~= my_camp) and buff.info.Dispel == "YES" then
        debuff_list[#debuff_list + 1] = buff
      end
    end
    for i = 1, #debuff_list do
      target:removeBuff(debuff_list[i])
      if ed.run_with_scene then
        local effect_name = "eff_impact_Ten_atk4.cha"
        ed.scene:playEffectOnScene(effect_name, target.position, {
          skill.caster.direction,
          1
        }, nil, 1)
      end
    end
    return ed.BuffCreate(skill.info.buff_info, target, skill.caster)
  else
    local bid = skill.info["Script Arg2"]
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    binfo.HealRatio = -skill.info["Script Arg1"]
    local list = target.buff_list
    local debuff_list = {}
    local my_camp = caster.camp
    for i = 1, #list do
      local buff = list[i]
      if buff and (not buff.caster or buff.caster.camp ~= my_camp) and buff.info.Dispel == "YES" then
        debuff_list[#debuff_list + 1] = buff
      end
    end
    for i = 1, #debuff_list do
      target:removeBuff(debuff_list[i])
      if ed.run_with_scene then
        local effect_name = "eff_impact_Ten_atk4s.cha"
        ed.scene:playEffectOnScene(effect_name, target.position, {
          skill.caster.direction,
          1
        }, nil, 1)
      end
    end
    return ed.BuffCreate(binfo, target, skill.caster)
  end
end

function Ten.skillult_takeEffectOn(basefunc, skill, target)
  local caster = skill.caster
  local originfo = skill.info
  if caster.camp == target.camp or caster.camp == target.camp and caster.buff_effects.fury then
    local skillsawake = caster.skills.Ten_sawake
    if skillsawake and skill.attack_counter == 1 then
      local list = target.buff_list
      local debuff_list = {}
      local my_camp = caster.camp
      for i = 1, #list do
        local buff = list[i]
        if buff and (not buff.caster or buff.caster.camp ~= my_camp) and buff.info.Dispel == "YES" then
          debuff_list[#debuff_list + 1] = buff
        end
      end
      for i = 1, #debuff_list do
        target:removeBuff(debuff_list[i])
      end
    end
    skill.info = ed.wraptable(originfo, {
      ["Buff ID"] = 0
    })
  end
  local r, dmg = basefunc(skill, target)
  if r and caster.camp == target.camp then
    local skillawake = caster.skills.Ten_awake
    if skillawake then
      skillawake:takeEffectOn(target, caster)
    end
  end
  skill.info = originfo
end

function Ten.skillults_takeEffectOn(basefunc, skill, target)
  local caster = skill.caster
  local originfo = skill.info
  local r, dmg = basefunc(skill, target)
  local owner = target
  if owner and not owner:isHasUncontrolBufEffect() and dmg and 0 < dmg then
    owner:hurt()
  end
  skill.info = originfo
end

function Ten.skillult_onAttackFrame(basefunc, self)
  local attack_counter = self.attack_counter
  if self.caster.manually_casting and self.attack_counter == 8 then
    local caster = self.caster
    ed.engine:unfreeze()
    self.caster.manually_casting = false
    self.attack_counter = self.attack_counter + 1
  else
    if attack_counter == 0 and ed.run_with_scene then
      local effect_sun = "eff_point_Ten_ult.cha"
      local origin = {
        ed.engine.stage_rect.maxX / 2,
        0
      }
      ed.scene:playEffectOnScene(effect_sun, origin, nil, nil, -1)
    end
    self.attack_counter = self.attack_counter + 1
    if self.info["Target Type"] == "random" or self.target == nil or not self.target:isAlive() then
      self:selectTarget(nil)
    end
    if not self.target then
      return
    end
    local info = self.info
    local caster = self.caster
    local ttype = info["Track Type"]
    if ttype == "projectile" then
      local projectile = self:createProjectile()
      ed.engine:addProjectile(projectile)
    elseif ttype == "chain" then
      local chain = self:createChain()
      ed.engine:addChain(chain)
    elseif ttype == nil then
      self:takeEffectAt(self.target.position)
      local skillults = caster.skills.Ten_ults
      skillults:takeEffectAt(self.target.position)
    else
      EDDebug("Unkonwn Track Type: '" .. ttype .. "'")
    end
    caster:setMP(caster.mp + info["Gain MP"] * ed.engine.mp_bonus)
    if info["Move Forward"] ~= 0 then
      caster.position[1] = caster.position[1] + info["Move Forward"] * caster.direction
    end
  end
end

function Ten.skillult_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local skillsawake = caster.skills.Ten_sawake
  skillsawake.target = caster
  skillsawake:takeEffectAt(caster.position)
  caster.Ten_sawake_duration = true
end

function Ten.reset(basefunc, hero)
  basefunc(hero)
  hero.TEN_sawake_temp_buff_list = {}
end

function Ten.collectBuff(basefunc, self, config)
  if self.Ten_sawake_duration then
    local buff = config.buff
    local owner = buff.owner
    if buff.owner:isAlive() and not buff.Ten_trigger then
      for i, tbuff in ipairs(owner.buff_list) do
        if tbuff.info.ID == Ten.Ten_sawake_bid and tbuff.owner.camp ~= buff.caster.camp and buff.info.Dispel == "YES" then
          table.insert(self.TEN_sawake_temp_buff_list, buff)
          local bid = Ten.nil_bid
          local binfo = ed.lookupDataTable("Buff", nil, bid)
          config.buff = ed.BuffCreate(binfo, owner, buff.caster)
          config.buff.Ten_trigger = true
          break
        end
      end
    end
  end
end

function Ten.skillsawake_buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local caster = buff.caster
  for i = #caster.TEN_sawake_temp_buff_list, 1, -1 do
    local tbuff = caster.TEN_sawake_temp_buff_list[i]
    if tbuff.owner == buff.owner then
      tbuff.timer = tbuff.timer - dt
      if tbuff.timer <= 0 then
        table.remove(caster.TEN_sawake_temp_buff_list, i)
      end
    end
  end
end

function Ten.skillsawake_buff_onRemoved(basefunc, buff)
  basefunc(buff)
  local caster = buff.caster
  buff.caster.Ten_sawake_duration = nil
  for i = #caster.TEN_sawake_temp_buff_list, 1, -1 do
    local tbuff = caster.TEN_sawake_temp_buff_list[i]
    if tbuff == nil then
      break
    end
    local owner = tbuff.owner
    local caster = tbuff.caster
    if owner:isAlive() then
      owner:addBuff(tbuff, caster)
    end
  end
  caster.TEN_sawake_temp_buff_list = {}
end

function Ten.skillsawake_createBuff(basefunc, skill, target)
  basefunc(skill, target)
  local buff = basefunc(skill, target)
  buff.update = override(buff.update, Ten.skillsawake_buff_update)
  buff.onRemoved = override(buff.onRemoved, Ten.skillsawake_buff_onRemoved)
  buff.timer = skill.info["Script Arg1"]
  return buff
end

function Ten.init_hero(hero)
  local skillatk = hero.skills.Ten_atk
  if skillatk then
    skillatk.onAttackFrame = override(skillatk.onAttackFrame, Ten.skillatk_onAttackFrame)
    skillatk.createProjectile = override(skillatk.createProjectile, Ten.skillatk_createProjectile)
    skillatk.takeEffectOn = override(skillatk.takeEffectOn, Ten.skillatk_takeEffectOn)
  end
  local skillatk2 = hero.skills.Ten_atk2
  if skillatk2 then
    skillatk2.createProjectile = override(skillatk2.createProjectile, Ten.skillatk2_createProjectile)
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, Ten.skillatk2_takeEffectOn)
  end
  local skillatk3 = hero.skills.Ten_atk3
  if skillatk3 then
    skillatk3.createBuff = override(skillatk3.createBuff, Ten.skillatk3_createBuff)
  end
  local skillatk4 = hero.skills.Ten_atk4
  if skillatk4 then
    skillatk4.createBuff = override(skillatk4.createBuff, Ten.skillatk4_createBuff)
  end
  local skillult = hero.skills.Ten_ult
  local skillults = hero.skills.Ten_ults
  if skillult then
    skillult.onAttackFrame = override(skillult.onAttackFrame, Ten.skillult_onAttackFrame)
    skillult.takeEffectOn = override(skillult.takeEffectOn, Ten.skillult_takeEffectOn)
    skillults.takeEffectOn = override(skillults.takeEffectOn, Ten.skillults_takeEffectOn)
  end
  local skillsawake = hero.skills.Ten_sawake
  if skillsawake then
    skillsawake.createBuff = override(skillsawake.createBuff, Ten.skillsawake_createBuff)
    hero.collectBuff = override(hero.collectBuff, Ten.collectBuff)
    hero.reset = override(hero.reset, Ten.reset)
    skillult.finish = override(skillult.finish, Ten.skillult_finish)
  end
  return hero
end

return Ten.init_hero
