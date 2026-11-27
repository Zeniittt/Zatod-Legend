module("ed.battlehero", package.seeall)
local ed = ed
Crusher = {}
Crusher.Crusher_atk3_buffid3 = 425
Crusher.Crusher_skillatk4_deadtime = 1.5

function Crusher.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  caster.Crusher_origin_pos = {}
  caster.Crusher_origin_pos[1] = caster.position[1]
  caster.Crusher_origin_pos[2] = caster.position[2]
end

function Crusher.skillult_onAttackFrame(basefunc, skill)
  if skill.caster.manually_casting then
    ed.engine:unfreeze()
    skill.caster.manually_casting = false
  end
  skill.attack_counter = skill.attack_counter + 1
  local attack_counter = skill.attack_counter
  if attack_counter == 1 and (skill.info["Target Type"] == "random" or skill.target == nil or not skill.target:isAlive()) then
    skill:selectTarget(nil)
  end
  if not skill.target then
    return
  end
  local info = skill.info
  local caster = skill.caster
  local target = skill.target
  if attack_counter == 1 then
    caster.position = {
      target.position[1] - caster.direction * 70,
      target.position[2]
    }
  elseif 1 < attack_counter and attack_counter <= 3 then
    skill:takeEffectAt(target.position)
  elseif 3 < attack_counter and attack_counter <= 7 then
    skill:takeEffectAt(target.position)
    if ed.run_with_scene then
      ed.scene:startCameraShakeAnimationY(5, 0.1, 5)
    end
  elseif attack_counter == 8 then
    local origin_info = skill.info
    skill.info = ed.wraptable(origin_info, {
      ["Knock Up"] = 0.5,
      ["Knock Back"] = 60
    })
    skill:takeEffectAt(target.position)
    skill.info = origin_info
    if ed.run_with_scene then
      ed.scene:startCameraShakeAnimationY(7, 0.1, 5)
    end
  elseif 8 < attack_counter then
    caster.position = {
      caster.Crusher_origin_pos[1],
      caster.Crusher_origin_pos[2]
    }
  end
  caster:setMP(caster.mp + info["Gain MP"] * ed.engine.mp_bonus)
  if info["Move Forward"] ~= 0 then
    caster.position[1] = caster.position[1] + info["Move Forward"] * caster.direction
  end
end

function Crusher.skillult_takeEffectOn(basefunc, skill, target, source)
  local originfo = skill.info
  skill.info = ed.wraptable(originfo, {
    ["No Dodge"] = true
  })
  local isHit = basefunc(skill, target, source)
  skill.info = originfo
  if isHit then
    local caster = skill.caster
    local dps_mod = caster.config.dps_mod
    local amount = skill.info["Script Arg6"]
    target:takeDamage(amount / dps_mod, "Holy", "mp", caster)
  end
end

function Crusher.power(basefunc, skill, source, target, damage_type)
  local ret, i = basefunc(skill, source, target, damage_type)
  local caster = skill.caster
  local skillawake = caster.skills.Crusher_awake
  if skillawake and damage_type == "AP" then
    ret = ret + skillawake.info["Script Arg2"]
  end
  return ret, i
end

function Crusher.skillatk2_takeEffectOn(basefunc, skill, target, source)
  local isHit = basefunc(skill, target, source)
  if isHit then
    local caster = skill.caster
    local dps_mod = caster.config.dps_mod
    local amount = skill.info["Script Arg6"]
    target:takeDamage(amount / dps_mod, "Holy", "mp", caster)
  end
end

function Crusher.skillatk2_selectTarget(basefunc, skill, default)
  local caster = skill.caster
  local target
  local num = math.huge
  local camp = caster.camp
  for foes in ed.engine:foreachAliveUnit(skill:targetCamp()) do
    if foes.buff_effects.untargetable then
    elseif num >= foes.position[1] * camp then
      num = foes.position[1] * camp
      target = foes
    end
  end
  return target
end

function Crusher.hero_takeDamage(basefunc, hero, amount, damage_type, field, source, coefficient, crit_mod, transferred)
  for _, mybuff in ipairs(hero.buff_list) do
    if mybuff.name == "Crusher_atk3" then
      local damageSource = type(amount) == "table" and amount.source or source
      local damageField = type(amount) == "table" and amount.field or field
      local dps_mod = hero.config.dps_mod
      local skillatk3 = hero.skills.Crusher_atk3
      local mpAmount = skillatk3.info["Script Arg6"]
      if damageSource and damageField == "hp" then
        damageSource:takeDamage(mpAmount / dps_mod, "Holy", "mp", hero)
        local binfo = ed.lookupDataTable("Buff", nil, Crusher.Crusher_atk3_buffid3)
        damageSource:addBuff(binfo, hero)
        if ed.run_with_scene then
          ed.scene:playEffectOnScene("eff_impact_Crusher_atk3.cha", {
            damageSource.position[1],
            damageSource.position[2] - 1
          }, {
            damageSource.direction,
            1
          }, nil, 1)
        end
      end
    end
  end
  return basefunc(hero, amount, damage_type, field, source, coefficient, crit_mod, transferred)
end

function Crusher.buffatk4_onDamaged(basefunc, buff, damage, damage_type)
  local owner = buff.owner
  local caster = buff.caster
  local skillatk4 = caster.skills.Crusher_atk4
  local amount = skillatk4.info["Script Arg6"]
  owner:takeHeal(amount, "mp")
  return basefunc(buff, damage, damage_type)
end

function Crusher.skillatk4_createBuff(basefunc, skill, target)
  local buffatk4 = basefunc(skill, target)
  buffatk4.onDamaged = override(buffatk4.onDamaged, Crusher.buffatk4_onDamaged)
  return buffatk4
end

function Crusher.hero_update(basefunc, hero, dt)
  if hero.state == ed.emUnitState_Dying then
    local skillatk4 = hero.skills.Crusher_atk4
    if skillatk4 then
      if not hero.crusher_remainingTime then
        hero.crusher_remainingTime = Crusher.Crusher_skillatk4_deadtime
      end
      hero.crusher_remainingTime = hero.crusher_remainingTime - dt
      if hero.crusher_remainingTime <= 0 then
        hero.crusher_remainingTime = 999
        local target = skillatk4:selectTarget()
        if target then
          skillatk4:takeEffectOn(target)
        end
      end
    end
  end
  basefunc(hero, dt)
end

function Crusher.MagicStone_update(basefunc, self, dt)
  basefunc(self, dt)
  local bid = 1243
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = ed.BuffCreate(binfo, self, self)
  local buffresult = self:addBuff(buff, self)
  local skill = self.skills.MagicStone_atk
  local casterCrusher = self.owner
  if casterCrusher and skill.caster.camp == 1 then
    Crusher.second_alliance_index = Crusher.second_alliance_index + dt
    if Crusher.second_alliance_index >= 5 then
      for unit in ed.engine:foreachAliveUnit(self.foecamp) do
        if unit.info["Unit Type"] == "Hero" then
          local isHit
          isHit = unit:takeDamage(skill.info["Script Arg6"] / self.config.dps_mod, "Holy", "mp", self)
          if isHit then
            casterCrusher.Crusher_MS_alliance_projectile = skill:createProjectile(unit)
          end
          break
        end
      end
      Crusher.second_alliance_index = 0
    end
    if casterCrusher.Crusher_MS_alliance_projectile then
      local gap_distance = ed.edpSub(casterCrusher.Crusher_MS_alliance_projectile.position, skill.caster.position)
      if math.abs(gap_distance[1]) < 50 then
        casterCrusher.Crusher_MS_alliance_projectile:terminate()
      end
    end
  else
    Crusher.second_enemy_index = Crusher.second_enemy_index + dt
    if 5 <= Crusher.second_enemy_index then
      for unit in ed.engine:foreachAliveUnit(self.foecamp) do
        if unit.info["Unit Type"] == "Hero" then
          local isHit
          isHit = unit:takeDamage(skill.info["Script Arg6"] / self.config.dps_mod, "Holy", "mp", self)
          if isHit then
            casterCrusher.Crusher_MS_enemy_projectile = skill:createProjectile(unit)
          end
          break
        end
      end
      Crusher.second_enemy_index = 0
    end
    if casterCrusher and casterCrusher.Crusher_MS_enemy_projectile then
      local gap_distance = ed.edpSub(casterCrusher.Crusher_MS_enemy_projectile.position, skill.caster.position)
      if math.abs(gap_distance[1]) < 50 then
        casterCrusher.Crusher_MS_enemy_projectile:terminate()
      end
    end
  end
  if self.firstin == nil then
    self:setAllBuffVisible(false)
    self:setHpVisible(false)
    self.firstin = true
  end
  local Crusher_camp_number = 0
  for unit in ed.engine:foreachAliveUnit(self.camp) do
    if unit:isHero() then
      Crusher_camp_number = Crusher_camp_number + 1
    end
  end
  if Crusher_camp_number == 0 then
    self:die()
  end
end

function Crusher.tile_collideCheck(basefunc, tile, unit)
  local caster = tile.caster
  if caster == unit then
    return 0.5
  else
    return false
  end
  return false
end

function Crusher.MagicStone_atk_createProjectile(basefunc, skill, foeunit)
  local projectile = basefunc(skill)
  local caster = skill.caster
  local target_position = foeunit.position
  local distance = ed.edpSub(caster.position, target_position)
  local dx = distance[1] / 10
  projectile.position = {
    target_position[1] + dx,
    target_position[2] + 30
  }
  projectile.velocity = ed.edpMult(distance, 1)
  ed.engine:addProjectile(projectile)
  projectile.collideCheck = override(projectile.collideCheck, Crusher.tile_collideCheck)
  return projectile
end

function Crusher.skillawake_projectile_update(basefunc, projectile, dt)
  basefunc(projectile, dt)
  local caster = projectile.skill.caster
  caster.direction = caster:getInitDir()
  if not projectile.totalTime then
    projectile.totalTime = dt
  else
    projectile.totalTime = projectile.totalTime + dt
  end
  if projectile.height < 40 and projectile.zSpeed < 0 then
    local MagicStone_position = {
      projectile.position[1],
      0
    }
    projectile:terminate()
    local skillawake = caster.skills.Crusher_awake
    local proto = {
      _tid = 256,
      _level = skillawake.level or 1,
      _stars = caster.stars,
      _rank = caster.rank,
      _fashion = {
        _current_fashion = caster.fashion_id
      },
      _skill_levels = {
        [1] = skillawake.level or 1,
        [2] = skillawake.level or 1
      }
    }
    local config = {
      is_monster = true,
      estimate_rank = true,
      hp_mod = 1,
      dps_mod = caster.config.dps_mod or 1
    }
    local MagicStone = ed.UnitCreate(proto, caster.camp, config)
    MagicStone.notPopupBattleInfo = true
    local bid = 1244
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, MagicStone, MagicStone)
    local buffresult = MagicStone:addBuff(buff, MagicStone)
    local bid = 606
    local bid = 606
    local binfo606 = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo606, MagicStone, MagicStone)
    local buffresult = MagicStone:addBuff(buff, MagicStone)
    MagicStone.direction = caster:getInitDir()
    MagicStone.live_time = 100
    MagicStone.owner = caster
    MagicStone.update = override(MagicStone.update, Crusher.MagicStone_update)
    local MagicStone_atk = MagicStone.skills.MagicStone_atk
    MagicStone_atk.createProjectile = override(MagicStone_atk.createProjectile, Crusher.MagicStone_atk_createProjectile)
    local location = MagicStone_position
    ed.engine:summonUnit(MagicStone, location, caster, "Birth")
  end
end

function Crusher.skillawake_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  local dir = skill.caster:getInitDir()
  local caster = skill.caster
  caster.direction = caster:getInitDir()
  local h = projectile.height
  local v = projectile.zSpeed
  local a = skill.info["Tile Gravity"]
  local A = 0.5 * a
  local B = v
  local C = h
  local delta = B ^ 2 - 4 * A * C
  local t = (-B - delta ^ 0.5) / (2 * A)
  local x = 400 + caster.direction * 200
  local r = 0
  local target_position = {x, 0}
  local launchposition = caster.position
  local distance = ed.edpSub(target_position, launchposition)
  projectile.velocity = ed.edpMult(distance, 1 / t)
  projectile.update = override(projectile.update, Crusher.skillawake_projectile_update)
  ed.engine:addProjectile(projectile)
  return nil
end

function Crusher.reset(basefunc, hero)
  basefunc(hero)
  Crusher.second_alliance_index = 0
  Crusher.second_enemy_index = 0
  hero.Crusher_MS_alliance_projectile = nil
  hero.Crusher_MS_enemy_projectile = nil
end

function Crusher.init_hero(hero)
  local skillult = hero.skills.Crusher_ult
  if skillult then
    skillult.onAttackFrame = override(skillult.onAttackFrame, Crusher.skillult_onAttackFrame)
    skillult.start = override(skillult.start, Crusher.skillult_start)
    skillult.takeEffectOn = override(skillult.takeEffectOn, Crusher.skillult_takeEffectOn)
    if ed.protoAwake(hero.proto, 108) then
      skillult.power = override(skillult.power, Crusher.power)
    end
  end
  local skillatk2 = hero.skills.Crusher_atk2
  if skillatk2 then
    skillatk2.selectTarget = override(skillatk2.selectTarget, Crusher.skillatk2_selectTarget)
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, Crusher.skillatk2_takeEffectOn)
    if ed.protoAwake(hero.proto, 108) then
      skillatk2.power = override(skillatk2.power, Crusher.power)
    end
  end
  local skillatk3 = hero.skills.Crusher_atk3
  if skillatk3 then
    hero.takeDamage = override(hero.takeDamage, Crusher.hero_takeDamage)
  end
  local skillatk4 = hero.skills.Crusher_atk4
  if skillatk4 then
    skillatk4.createBuff = override(skillatk4.createBuff, Crusher.skillatk4_createBuff)
    if hero.name == "Crusher" then
      hero.update = override(hero.update, Crusher.hero_update)
    end
  end
  local skillawake = hero.skills.Crusher_awake
  if skillawake then
    skillawake.createProjectile = override(skillawake.createProjectile, Crusher.skillawake_createProjectile)
    hero.reset = override(hero.reset, Crusher.reset)
  end
  return hero
end

return Crusher.init_hero
