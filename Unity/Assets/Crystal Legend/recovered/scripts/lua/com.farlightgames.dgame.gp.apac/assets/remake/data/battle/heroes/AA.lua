module("ed.battlehero", package.seeall)
local ed = ed
AA = {}
AA.name = "AA"
AA.auraID = "AA3_aura"
AA.atk4_defenceBuffId = 10006204
AA.atk2_removeBuffDistance = 80

function AA.cheer(basefunc, actor)
  local puppet = actor.puppet
  local cheerActionName = "Cheer2"
  puppet:setNextAction(cheerActionName)
  puppet:setLoop(true)
  actor.velocity = {0, 0}
  actor.node:setScaleX(actor.model.direction)
  actor.node:setScaleY(1)
  actor.offline = true
end

function AA.reset(basefunc, unit)
  basefunc(unit)
end

function AA.ult_launchPoint(basefunc, skill)
  local position, height = basefunc(skill)
  local caster = skill.caster
  local direction = caster.direction
  position = {
    caster.position[1],
    caster.position[2]
  }
  position[1] = position[1] + 15 * direction
  if position[1] < 0 or position[1] > 800 then
    position[1] = 400 - 400 * direction
  end
  height = 0
  return position, height
end

function AA.DOP_in_battlefield(caster, radius, camp)
  local position = {400, 0}
  local count = 0
  local maxcount = 0
  local distance = 0
  local mindistance = 999
  for x = 0, 800, 25 do
    for y = -100, 100, 25 do
      for unit in ed.engine:foreachAliveUnit(camp) do
        local unitdistance = ed.edpDistanceSQ({x, y}, unit.position)
        if unit.buff_effects.untargetable then
        elseif unit.buffManager.invisible and unit.camp ~= caster.camp then
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
  end
  if maxcount <= 0 then
  end
end

function AA.ult_createProjectile(basefunc, skill)
  local caster = skill.caster
  local projectile = basefunc(skill)
  local d = {0, 0}
  for unit in ed.engine:foreachAliveUnit(-caster.camp) do
    if unit.AA_ult_dmg then
      unit.AA_ult_dmg = false
    end
  end
  if projectile then
    projectile.AA_targetPosition = AA.DOP_in_battlefield(caster, 140, caster.foecamp)
    projectile.position, projectile.height = skill:launchPoint()
    if projectile.AA_targetPosition then
      d = {
        projectile.AA_targetPosition[1] - projectile.position[1],
        projectile.AA_targetPosition[2] - projectile.position[2]
      }
      projectile.zSpeed = 0
      projectile.velocity = ed.edpMult(ed.edpNormalize(d), skill.info["Tile XY Speed"])
      projectile.max_distance = math.abs(projectile.position[1] - projectile.AA_targetPosition[1])
      projectile.terminate = override(projectile.terminate, AA.ult_PTerminate)
      projectile.camp = caster.camp
      projectile.can_be_influenced = false
      ed.engine:addProjectile(projectile)
    end
    return nil
  end
end

function AA.ult_PTerminate(basefunc, self)
  local caster = self.caster
  local ult_explode = caster.skills.AA_ult_explode
  if self.AA_targetPosition then
    if ed.run_with_scene then
      ed.scene:playEffectOnScene("eff_point_AA_HailExplode.cha", {
        self.AA_targetPosition[1],
        self.AA_targetPosition[2]
      }, {
        caster.direction * 0.8,
        0.8
      }, nil, -1)
    end
    ult_explode.info["No Dodge"] = true
    ult_explode:takeEffectAt(self.AA_targetPosition, caster)
  end
  basefunc(self)
end

function AA.ult_buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local caster = buff.caster
  local owner = buff.owner
  if not owner:isAlive() or owner.buff_effects.invulnerable or owner.manually_casting and buff.caster.camp ~= owner.camp then
    return false
  end
  local skillult = caster.skills[AA.name .. "_ult"]
  local low_hp_pct = 0.08
  if skillult.evo_rank and skillult.evo_rank >= 3 then
    low_hp_pct = skillult.evo_rank3["Script Arg1"] * 0.01
  end
  if owner.hp < owner.attribs.HP * low_hp_pct and not owner.AA_ult_dmg then
    local max_damage = skillult.info["Script Arg3"]
    local holyDamage = owner.attribs.HP * 0.16
    holyDamage = math.min(max_damage, holyDamage)
    owner:takeDamage(holyDamage, "Holy", "hp", caster)
    owner.AA_ult_dmg = true
    buff.timer = 0
    if ed.run_with_scene then
      local name = skillult.info["Impact Effect"]
      if name and owner.actor then
        local effect_z = skillult.info["Impact Zorder"]
        owner.actor:addEffect(name, effect_z)
      end
    end
  end
end

function AA.ult_addBuff_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.update = override(buff.update, AA.ult_buff_update)
  return buff
end

function AA.ult_explode_takeEffectOn(basefunc, skill, target, source)
  basefunc(skill, target, source)
  local skillult_addbuff = skill.caster.skills[AA.name .. "_ult_addbuff"]
  skillult_addbuff:takeEffectOn(target, skill.caster)
end

function AA.update(basefunc, unit, dt)
  basefunc(unit, dt)
  local actor = unit.actor
  if actor and not actor["Reset on Stage Begin"] and unit.name == "AA" then
    actor["Reset on Stage Begin"] = true
    actor.cheer = override(actor.cheer, AA.cheer)
  end
end

function AA.atk3_buff_onRemoved(basefunc, buff)
  buff.owner[AA.auraID] = nil
  basefunc(buff)
end

function AA.skill3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  if skill.evo_rank and skill.evo_rank >= 3 then
    local MPRatio = skill.evo_rank3["Script Arg1"]
    buff:setAttribute("MPRatio", -MPRatio)
  end
  buff.onRemoved = override(buff.onRemoved, AA.atk3_buff_onRemoved)
  target[AA.auraID] = buff
  return buff
end

local testPointInShape = ed.Skill.testPointInShape

function AA.vortex_update(basefunc, projectile, dt)
  if projectile.birthtick == ed.engine.ticks then
    return
  end
  projectile.previous_position = {
    projectile.position[1],
    projectile.position[2]
  }
  ed.Entity.update(projectile, dt)
  if not projectile.terminated then
    projectile.timer = projectile.timer - dt
    if projectile.timer < 0 then
      projectile:terminate()
    else
      local skill = projectile.skill
      local direction = skill.caster.direction
      local info = skill.info
      local location = projectile.position
      local origin = {
        location[1] + info["X Shift"] * direction,
        location[2]
      }
      local shape = info["AOE Shape"]
      local arg1 = 100
      local arg2 = info["Shape Arg2"]
      for unit in ed.engine:foreachAliveUnit(skill:affectedCamp()) do
        local p2 = ed.edpSub(unit.position, origin)
        p2[1] = p2[1] * direction
        if testPointInShape(p2, shape, arg1, arg2) then
          if unit[AA.auraID] then
            unit[AA.auraID].timer = 0.5
          else
            unit:addBuff(skill:createBuff(unit))
          end
        end
      end
    end
  end
end

function AA.skill3_onAttackFrame(basefunc, skill)
  skill.attack_counter = skill.attack_counter + 1
  if skill.info["Target Type"] == "random" or skill.target == nil or not skill.target:isAlive() then
    skill:selectTarget(nil)
  end
  if not skill.target then
    return
  end
  local info = skill.info
  local caster = skill.caster
  local projectile = skill:createProjectile()
  projectile.position = {
    skill.target.position[1],
    -20
  }
  local skill3_timer = skill.info["Script Arg1"]
  if skill.evo_rank and 1 <= skill.evo_rank then
    skill3_timer = skill.evo_rank1["Script Arg1"]
  end
  if skill.evo_rank and skill.evo_rank >= 2 then
    skill3_timer = skill.evo_rank2["Script Arg1"]
  end
  projectile.timer = skill3_timer
  projectile.update = override(projectile.update, AA.vortex_update)
  ed.engine:addProjectile(projectile)
  if projectile.actor then
    projectile.actor.ownZOrder = -999
  end
  caster:setMP(caster.mp + info["Gain MP"] * ed.engine.mp_bonus)
end

function AA.atk2_buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local owner = buff.owner
  local caster = buff.caster
  local distanceSQ = ed.edpDistanceSQ(owner.position, buff.AAatk2PositionStart)
  if distanceSQ >= AA.atk2_removeBuffDistance * AA.atk2_removeBuffDistance then
    owner:removeBuff(buff)
  end
  if buff.timer <= 0 and not ed.engine.beingEnd and not owner:isHasUncontrolBufEffect() then
    local bid = 10006205
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buffs = ed.BuffCreate(binfo, owner, caster)
    local skill2 = caster.skills[AA.name .. "_atk2"]
    if skill2 and skill2.evo_rank and skill2.evo_rank >= 2 then
      buffs.timer = 4
    end
    if not owner.buff_effects.invulnerable then
      owner:addBuff(buffs, caster)
    end
  end
end

function AA.skillatk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.skill = skill
  buff.update = override(buff.update, AA.atk2_buff_update)
  buff.AAatk2PositionStart = {
    target.position[1],
    target.position[2]
  }
  local hpr = buff.info.HPR
  if skill.evo_rank and 1 <= skill.evo_rank then
    buff:setAttribute("HPR", hpr - skill.evo_rank1["Script Arg1"])
  end
  if skill.evo_rank and skill.evo_rank >= 3 then
    buff:setAttribute("HPR", hpr - skill.evo_rank1["Script Arg1"] - skill.evo_rank3["Script Arg1"])
  end
  return buff
end

function AA.atk_start(basefunc, self, target)
  local info = self.info
  if do_battle_log then
    btlog("%s began to cast %s --> %s", self.caster:display(), self:display(), target and target:display() or "nil")
  end
  self.target = target
  self:selectTarget(target)
  self.cd_remaining = info.CD
  self.casting = true
  self.attack_counter = 0
  self.nextPhaseId = self.nextPhaseId and self.nextPhaseId % 2 + 1 or 1
  self:startPhase(self.nextPhaseId)
  self.is_update = true
  local caster = self.caster
  caster.global_cd = info["Global CD"]
  caster:setMP(caster.mp - info["Cost MP"] * (1 - caster.attribs.CDR / 100))
  if caster.actor then
    local effect_name = info["Launch Effect"]
    if effect_name then
      caster.actor:addEffect(effect_name, -1)
    end
  end
end

function AA.atk_onAttackFrame(basefunc, skill)
  local skill4 = skill.caster.skills[AA.name .. "_atk4"]
  skill.atk4_sum = 0
  if skill4 then
    local sum = 0
    for unit in ed.engine:foreachAliveUnit(skill:affectedCamp()) do
      if unit[AA.auraID] and not unit.config.is_summoned then
        sum = sum + 1
      end
    end
    if sum == 0 then
      if skill.AA_atk_Art4Tag then
        skill.info = ed.wraptable(skill.originInfo, {
          ["Tile Art"] = skill.tileArt1
        })
        skill.AA_atk_Art4Tag = nil
      end
    else
      skill.info = ed.wraptable(skill.originInfo, {
        ["Tile Art"] = skill.tileArt4
      })
      skill.AA_atk_Art4Tag = true
    end
    skill.atk4_sum = sum
  end
  basefunc(skill)
end

function AA.atk_takeEffectOn(basefunc, skill, target, source, shift)
  local isHit, dmg = basefunc(skill, target, source, shift)
  local caster = skill.caster
  local skill4 = caster.skills[AA.name .. "_atk4"]
  if skill4 and isHit and target and target:isAlive() and skill.atk4_sum and skill.atk4_sum > 0 then
    local ratio = skill4.info["Plus Ratio"]
    if skill4.evo_rank and skill4.evo_rank >= 1 then
      ratio = skill4.evo_rank1["Script Arg1"]
    end
    if skill4.evo_rank and skill4.evo_rank >= 2 then
      ratio = skill4.evo_rank2["Script Arg1"]
    end
    if skill4.evo_rank and skill4.evo_rank >= 3 then
      ratio = skill4.evo_rank3["Script Arg1"]
    end
    target:takeDamage((skill4.info["Script Arg1"] + ratio * caster.attribs.AP) * skill.atk4_sum, "AP", "hp", caster)
  end
  return isHit, dmg
end

function AA.atk_onPhaseFinished(basefunc, self)
  self:finish()
end

function AA.init_hero(hero)
  local skillult = hero.skills[AA.name .. "_ult"]
  if skillult then
    skillult.launchPoint = override(skillult.launchPoint, AA.ult_launchPoint)
    skillult.createProjectile = override(skillult.createProjectile, AA.ult_createProjectile)
    skillult.createBuff = override(skillult.createBuff, AA.ult_addBuff_createBuff)
  end
  local skillult_addbuff = hero.skills[AA.name .. "_ult_addbuff"]
  if skillult_addbuff then
    skillult_addbuff.origininfo = skillult_addbuff.info
    skillult_addbuff.createBuff = override(skillult_addbuff.createBuff, AA.ult_addBuff_createBuff)
  end
  local skillult_explode = hero.skills[AA.name .. "_ult_explode"]
  if skillult_explode then
    skillult_explode.takeEffectOn = override(skillult_explode.takeEffectOn, AA.ult_explode_takeEffectOn)
    if skillult.evo_rank and skillult.evo_rank >= 1 then
      skillult_explode.info = ed.wraptable(skillult_explode.info, {
        ["Plus Ratio"] = skillult.evo_rank1["Script Arg1"]
      })
    end
    if skillult.evo_rank and skillult.evo_rank >= 2 then
      skillult_explode.info = ed.wraptable(skillult_explode.info, {
        ["Plus Ratio"] = skillult.evo_rank2["Script Arg1"]
      })
    end
  end
  hero.reset = override(hero.reset, AA.reset)
  hero.update = override(hero.update, AA.update)
  local skill2 = hero.skills[AA.name .. "_atk2"]
  if skill2 then
    skill2.createBuff = override(skill2.createBuff, AA.skillatk2_createBuff)
  end
  local skill3 = hero.skills[AA.name .. "_atk3"]
  if skill3 then
    skill3.onAttackFrame = override(skill3.onAttackFrame, AA.skill3_onAttackFrame)
    skill3.createBuff = override(skill3.createBuff, AA.skill3_createBuff)
  end
  local skillatk = hero.skills[AA.name .. "_atk"]
  local skill4 = hero.skills[AA.name .. "_atk4"]
  if skillatk then
    skillatk.start = override(skillatk.start, AA.atk_start)
    skillatk.onAttackFrame = override(skillatk.onAttackFrame, AA.atk_onAttackFrame)
    skillatk.takeEffectOn = override(skillatk.takeEffectOn, AA.atk_takeEffectOn)
    skillatk.onPhaseFinished = override(skillatk.onPhaseFinished, AA.atk_onPhaseFinished)
    if skill4 then
      skillatk.originInfo = skillatk.info
      skillatk.tileArt1 = skillatk.info["Tile Art"]
      skillatk.tileArt4 = skill4.info["Tile Art"]
    end
  end
  return hero
end

return AA.init_hero
