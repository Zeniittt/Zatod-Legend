module("ed.battlehero", package.seeall)
local ed = ed
Duckboy = {}
Duckboy.ult_velocity = 250
Duckboy.ult_bid = 1436
Duckboy.ult_bubble_bid = 1437
Duckboy.ult_BubbleEffect_lifetime = 1
Duckboy.bubbleup_time = 0.5
Duckboy.bubbleup_damageratio = {
  0.05,
  0.15,
  0.2
}
Duckboy.bubbleup_scale = {
  1.1,
  1.2,
  1.3,
  1.4
}
Duckboy.bubble_power = {
  1.1,
  1.2,
  1.3,
  1.4
}
Duckboy.Duck_WalkSpeed = 30
Duckboy.ZoneXRange = 2
Duckboy.bubble_zSpeed = 10
Duckboy.bubble_xSpeed = 20
Duckboy.atk2_cd_decrease = 0.5
Duckboy.atk3_stun_bid = 1443
Duckboy.uncontrol_bid = 1338
Duckboy.atk4_recover_ratio = 0.3
Duckboy.atk4_invul_bid = 1441
Duckboy.atk4_duck_bid = 1440
Duckboy.awake_LFS_ratio = 0.2
Duckboy.fashion_recover_ratio = 0.5
Duckboy.atk4_flamingo_bid = 1545
Duckboy.Duckboy_fashion_ID = 100661

function Duckboy.True_damage(hero, damage, damage_type)
  local temp_damage = damage
  for _, buff in ipairs(hero.buff_list) do
    local info = buff.info
    if buff.shield then
      local stype = info["Shield Type"]
      if stype == damage_type or stype == "all" then
        local temp_shield = buff.shield
        temp_shield = temp_shield - temp_damage
        if temp_shield < 0 then
          temp_damage = -temp_shield
        else
        end
      end
    end
  end
  local immunity
  if damage_type == "AD" then
    immunity = hero.attribs.PIMU or 0
  elseif damage_type == "AP" then
    immunity = hero.attribs.MIMU or 0
  elseif damage_type == "Holy" then
    immunity = 0
  else
    EDDebug("Unknown Damage Type '" .. damage_type .. "'")
  end
  immunity = immunity + hero.attribs.ALLIMU
  temp_damage = hero:getLostHPAfterImmunity(temp_damage, immunity, damage_type)
  return temp_damage
end

function Duckboy.skill_effect(hero, skill)
  local info = skill.info
  local direction = hero.direction
  local location = hero.position
  local origin = {
    location[1] + info["X Shift"] * direction,
    location[2]
  }
  local shape = info["AOE Shape"]
  local arg1 = info["Shape Arg1"]
  local arg2 = info["Shape Arg2"]
  for unit in ed.engine:foreachAliveUnit(skill:affectedCamp()) do
    local skillult_affected_units_Duckboy = hero.skillult_affected_units_Duckboy
    if not skillult_affected_units_Duckboy[unit] then
      local p2 = ed.edpSub(unit.position, origin)
      p2[1] = p2[1] * direction
      if skill.testPointInShape(p2, shape, arg1, arg2) then
        skillult_affected_units_Duckboy[unit] = true
        skill:takeEffectOn(unit, hero)
      end
    end
  end
end

function Duckboy.update(basefunc, hero, dt)
  basefunc(hero, dt)
  local atk4a = hero.skills.Duckboy_atk4a
  if atk4a and not hero.Duckboy_atk4_alreadyCreateRegion then
    hero.Duckboy_atk4_times = 0
    hero.Duckboy_atk4_alreadyCreateRegion = true
    atk4a.target = hero
    local atk4a_region = atk4a:createRegion()
    atk4a_region.position[1] = atk4a_region.position[1] + 3
    hero.Duckboy_atk4_region = atk4a_region
    ed.engine:addRegion(atk4a_region)
  end
  local skillult = hero.skills.Duckboy_ult
  if hero.Duckboy_ult_direction then
    local info = skillult.info
    local direction = -hero.direction
    local location = hero.position
    local origin = {
      location[1] + info["X Shift"] * direction,
      location[2]
    }
    local shape = info["AOE Shape"]
    local arg1 = info["Shape Arg1"]
    local arg2 = info["Shape Arg2"]
    for unit in ed.engine:foreachAliveUnit(skillult:affectedCamp()) do
      local skillult_affected_units_Duckboy = hero.skillult_affected_units_Duckboy
      if not skillult_affected_units_Duckboy[unit] then
        local p2 = ed.edpSub(unit.position, origin)
        p2[1] = p2[1] * direction
        if skillult.testPointInShape(p2, shape, arg1, arg2) then
          skillult_affected_units_Duckboy[unit] = true
          skillult:takeEffectOn(unit, hero)
        end
      end
    end
    if not hero.Duckboy_crossing and (hero.position[1] > 799 + info["X Shift"] - Duckboy.ult_velocity / 8 and hero.Duckboy_ult_direction == 1 or hero.position[1] < 1 - info["X Shift"] + Duckboy.ult_velocity / 8 and hero.Duckboy_ult_direction == -1) then
      hero.Duckboy_crossing = true
      hero.Duckboy_ultreturn_tick = 0.5
    end
    if hero.Duckboy_ultreturn_tick then
      hero.Duckboy_ultreturn_tick = hero.Duckboy_ultreturn_tick - dt
      if 0 >= hero.Duckboy_ultreturn_tick then
        if hero.Duckboy_ult_location then
          hero.position = {
            hero.Duckboy_ult_location[1],
            hero.Duckboy_ult_location[2]
          }
        end
        skillult:startPhase(3)
        hero.manual_moving = nil
        hero.walk_v = {0, 0}
        hero.Duckboy_ultreturn_tick = nil
      end
    end
  end
end

function Duckboy.die(basefunc, hero, killer)
  basefunc(hero, killer)
  if hero.Duckboy_atk4_region then
    hero.Duckboy_atk4_region:finish()
    hero.Duckboy_atk4_region = nil
  end
end

function Duckboy.skillulta_buff_onRemoved(basefunc, buff)
  local caster = buff.caster
  local owner = buff.owner
  if ed.run_with_scene then
    ed.scene:playEffectOnScene("eff_point_Duckboy_bubble_break.cha", owner.position, {
      owner.direction,
      1
    }, owner.height, 0)
  end
  local skillultb = caster.skills.Duckboy_ultb
  local originfo = skillultb.info
  local power_ratio = Duckboy.bubble_power[buff.Duckboy_bubble_level or 1]
  skillultb.info = ed.wraptable(originfo, {
    ["Basic Num"] = originfo["Basic Num"] * power_ratio,
    ["Plus Ratio"] = originfo["Plus Ratio"] * power_ratio
  })
  skillultb:takeEffectAt(owner.position)
  skillultb.info = originfo
  owner.zSpeed = 0
  if owner.actor then
    owner.actor.zSpeed = owner.zSpeed
  end
  basefunc(buff)
end

function Duckboy.skillulta_buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  if buff.Duckboy_bubbleup_time and buff.Duckboy_bubbleup_time < Duckboy.bubbleup_time then
    buff.Duckboy_bubbleup_time = buff.Duckboy_bubbleup_time + dt
  else
    local owner = buff.owner
    owner.height = owner.height + Duckboy.bubble_zSpeed * dt
    local time = buff.Duckboy_bubbleup_time - Duckboy.bubbleup_time
    owner.position[1] = buff.Duckboy_bubble_ori_positionX + Duckboy.bubble_xSpeed * math.sin(math.rad(180 * time)) * buff.bubble_swing_direction
    if owner.actor then
      owner.actor.height = owner.height
    end
  end
end

function Duckboy.skillulta_buff_onDamaged(basefunc, self, damage, damage_type, source, skill, transferred)
  local damage = basefunc(self, damage, damage_type, source, skill, transferred)
  local owner = self.owner
  local true_damage = Duckboy.True_damage(owner, damage, damage_type)
  self.Duckboy_bubble_DamageBeared = self.Duckboy_bubble_DamageBeared + true_damage
  local levelup_ratio = Duckboy.bubbleup_damageratio[self.Duckboy_bubble_level]
  if levelup_ratio and levelup_ratio < self.Duckboy_bubble_DamageBeared / owner.attribs.HP then
    self.Duckboy_bubble_level = self.Duckboy_bubble_level + 1
    local actor = owner.actor
    if actor then
      if self.scale_id then
        actor:removeScale(self.scale_id)
      end
      local scale = Duckboy.bubbleup_scale[self.Duckboy_bubble_level or 1]
      self.scale_id = actor:useScale({scale, scale})
    end
  end
  return damage
end

function Duckboy.skillulta_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.onRemoved = override(buff.onRemoved, Duckboy.skillulta_buff_onRemoved)
  buff.update = override(buff.update, Duckboy.skillulta_buff_update)
  buff.onDamaged = override(buff.onDamaged, Duckboy.skillulta_buff_onDamaged)
  local rand = ed.rand()
  if 0.5 < rand then
    buff.bubble_swing_direction = 1
  else
    buff.bubble_swing_direction = -1
  end
  buff.Duckboy_bubbleup_time = 0
  buff.Duckboy_bubble_level = 1
  buff.Duckboy_bubble_DamageBeared = 0
  buff.Duckboy_bubble_ori_positionX = buff.owner.position[1]
  return buff
end

function Duckboy.skillultb_takeEffectOn(basefunc, self, target, source, shift)
  if target and target.hp ~= 0 then
    return basefunc(self, target, source, shift)
  else
    return false
  end
end

function Duckboy.skillultc_projectile_update(basefunc, projectile, dt)
  projectile.totalTime = projectile.totalTime + dt
  if projectile.totalTime > Duckboy.ult_BubbleEffect_lifetime then
    projectile:terminate()
  end
  basefunc(projectile, dt)
end

function Duckboy.skillultc_createProjectile(basefunc, self)
  local projectile = basefunc(self)
  projectile.totalTime = 0
  projectile.update = override(projectile.update, Duckboy.skillultc_projectile_update)
  return projectile
end

function Duckboy.skillult_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  if skill.attack_counter == 0 then
    caster.manual_moving = true
    caster.walk_v = {
      caster.Duckboy_ult_direction * Duckboy.ult_velocity,
      0
    }
  end
  if skill.current_phase_idx ~= 3 then
    local skillultc = caster.skills.Duckboy_ultc
    if skillultc then
      local projectile = skillultc:createProjectile()
      projectile.position, projectile.height = skill:launchPoint()
      projectile.velocity[1] = projectile.velocity[1] * caster.Duckboy_ult_direction
      ed.engine:addProjectile(projectile)
    end
    basefunc(skill)
  end
end

function Duckboy.skillult_buff_onRemoved(basefunc, buff)
  basefunc(buff)
  local owner = buff.owner
  for i, tbuff in ipairs(owner.buff_list) do
    if tbuff.info.ID == Duckboy.ult_bubble_bid then
      tbuff.timer = 0.125
    end
  end
end

function Duckboy.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local bid = Duckboy.uncontrol_bid
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
  caster.skillult_affected_units_Duckboy = {}
  caster.Duckboy_ult_location = {
    caster.position[1],
    caster.position[2]
  }
  caster.Duckboy_ult_direction = caster.direction
end

function Duckboy.skillult_finish(basefunc, skill, reason)
  basefunc(skill, reason)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == Duckboy.uncontrol_bid then
      caster:removeBuff(tbuff)
    end
  end
  caster.skillult_affected_units_Duckboy = {}
  caster.Duckboy_crossing = nil
  caster.Duckboy_ult_location = nil
  caster.Duckboy_ult_direction = nil
end

function Duckboy.skillult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.onRemoved = override(buff.onRemoved, Duckboy.skillult_buff_onRemoved)
  local skillawake = skill.caster.skills.Duckboy_awake
  if skillawake then
    buff.onDamaged = override(buff.onDamaged, Duckboy.skillawake_buff_onDamaged)
    buff:setAttribute("Puppet", "DuckSwitch.cha")
    buff:setAttribute("MR", skillawake.info["Script Arg2"])
  end
  return buff
end

function Duckboy.skillult_takeEffectOn(basefunc, self, target, source, shift)
  local ret, dmg, Crit, lfs_amount = basefunc(self, target, source, shift)
  for i, tbuff in ipairs(target.buff_list) do
    if tbuff.info.ID == Duckboy.ult_bid then
      local caster = self.caster
      local skillulta = caster.skills.Duckboy_ulta
      skillulta:takeEffectOn(target)
    end
  end
  return ret, dmg, Crit, lfs_amount
end

function Duckboy.skillult_takeEffectAt(basefunc, self, location, source)
  self.caster.direction = -self.caster.direction
  basefunc(self, location, source)
  self.caster.direction = -self.caster.direction
end

function Duckboy.skillatk_createProjectile(basefunc, skill)
  local hero = skill.caster
  if ed.protoAwake(hero.proto, 10065) then
    local originfo = skill.info
    skill.info = ed.wraptable(originfo, {
      ["Tile Art"] = "eff_tile_Duckboy_atkswitch.cha",
      ["Impact Effect"] = "eff_impact_Duckboy_atkswitch.cha"
    })
  end
  local projectile = basefunc(skill)
  local h = projectile.height
  local v = projectile.zSpeed
  local a = skill.info["Tile Gravity"]
  local A = 0.5 * a
  local B = v
  local C = h
  local delta = B ^ 2 - 4 * A * C
  local t = (-B - delta ^ 0.5) / (2 * A)
  local target_position = skill.target.position
  local distance = ed.edpSub(target_position, projectile.position)
  projectile.velocity = ed.edpMult(distance, 1 / t)
  return projectile
end

function Duckboy.collectBuff(basefunc, self, config)
  if config then
    local buff = config.buff
    for i, effect in ipairs(buff.info["Control Effects"]) do
      if effect == "polymorph" then
        local skillatk2 = self.skills.Duckboy_atk2
        skillatk2.cd_remaining = skillatk2.cd_remaining - Duckboy.atk2_cd_decrease
      end
    end
  end
end

function Duckboy.skillatk2_buff_update(basefunc, buff, dt)
  local caster = buff.caster
  local owner = buff.owner
  local skill2 = caster.skills.Duckboy_atk2
  buff.hurtcounts = buff.hurtcounts + 1
  if buff.hurtcounts % 2 == 1 then
    local damage = skill2.info["Basic Num"] + skill2.info["Plus Ratio"] * caster.attribs[skill2.info["Plus Attr"]] or 0
    if not owner.buff_effects.invulnerable then
      local dmg = owner:takeDamage(damage, "AP", "hp", caster, 1)
      if not owner:isHasUncontrolBufEffect() and dmg and 0 < dmg then
        owner:hurt()
      end
    end
  end
  basefunc(buff, dt)
end

function Duckboy.skillatk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.total_dmg = 0
  buff.total_times = 0
  buff.update = override(buff.update, Duckboy.skillatk2_buff_update)
  local caster = skill.caster
  caster.skill2target_Duckboy = target
  caster.skill2buff_Duckboy = buff
  buff.hurtcounts = 0
  return buff
end

function Duckboy.skillatk2_chain_jump(basefunc, self)
  self.jumps_remaining = self.jumps_remaining - 1
  self.jump_timer = self.jump_timer + self.skill.info["Chain Gap"]
  self.affect_times[self.target] = (self.affect_times[self.target] or 0) + 1
  self.skill:takeEffectOn(self.target)
  if ed.run_with_scene and self.skill.info["Chain Effect"] then
    local effect = ed.ChainEffectCreate(self)
    local effectid = ed.scene:addEffect(effect, 0)
    self.skill.caster.atk2chainEffect_Duckboy = effect
  end
end

function Duckboy.skillatk2_createChain(basefunc, skill)
  local info = skill.info
  local self = ed.Entity.create()
  local class = {
    mt = {}
  }
  local caster = skill.caster
  self.skill = skill
  self.source = skill.caster
  self.target = skill.target
  self.jumps_remaining = info["Chain Jumps"]
  self.jump_timer = 0
  self.affect_times = {}
  setmetatable(self, ed.Chain.mt)
  self.jump = override(self.jump, Duckboy.skillatk2_chain_jump)
  self:jump()
  return self
end

function Duckboy.skill_atk2_launchPoint(basefunc, skill)
  local position, height = basefunc(skill)
  local direction = skill.caster.direction
  position[1] = position[1] + 21 * direction
  if position[1] < 0 or position[1] > 800 then
    position[1] = 400 - 400 * direction
  end
  position[2] = position[2] + 48
  height = 10
  return position, height
end

function Duckboy.skillatk2_onAttackFrame(basefunc, self)
  local attack_counter = self.attack_counter
  local caster = self.caster
  if attack_counter == 0 then
    basefunc(self)
  else
    if caster.skill2target_Duckboy and caster.skill2target_Duckboy:isAlive() and caster.skill2buff_Duckboy then
      caster.skill2target_Duckboy:removeBuff(caster.skill2buff_Duckboy)
    end
    caster.atk2chainEffect_Duckboy = nil
  end
end

function Duckboy.skillatk2_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  if caster.skill2target_Duckboy then
    for i, tbuff in ipairs(caster.skill2target_Duckboy.buff_list) do
      if tbuff.info.ID == 160 then
        caster.skill2target_Duckboy:removeBuff(tbuff)
      end
    end
  end
  if caster.atk2chainEffect_Duckboy and ed.run_with_scene then
    ed.scene:removeEffect(caster.atk2chainEffect_Duckboy, Duckboy.atk2chainEffectzOrder)
  end
  caster.skill2target_Duckboy = nil
  caster.skill2buff_Duckboy = nil
  caster.atk2chainEffect_Duckboy = nil
end

function Duckboy.hero_handleUnitDieEvent(basefunc, self, unit, killer_unit)
  basefunc(self, unit, killer_unit)
  local skillatk2 = self.skills.Duckboy_atk2
  if self.current_skill and skillatk2 and self.skill2target_Duckboy and self.current_skill == skillatk2 and self.skill2target_Duckboy == unit and ed.run_with_scene and self.atk2chainEffect_Duckboy then
    ed.scene:removeEffect(self.atk2chainEffect_Duckboy, Duckboy.atk2chainEffectzOrder)
    self.atk2chainEffect_Duckboy = nil
  end
end

function Duckboy.skillatk3_start(basefunc, skill, target)
  basefunc(skill, target)
  if ed.run_with_scene then
    ed.setMusicVolume(0.25)
  end
end

function Duckboy.skillatk3_finish(basefunc, skill, reason)
  basefunc(skill, reason)
  if ed.run_with_scene then
    ed.resetMusicVolume()
  end
end

function Duckboy.clamp(n, min, max)
  if n < min then
    return min
  end
  if max < n then
    return max
  end
  return n
end

function Duckboy.locate_pool_position(skill)
  local n = 10
  local step = 800 / (n + 1)
  local values = {}
  for i = 1, n do
    values[i] = 0
  end
  local DoneRadius = skill.info["Shape Arg1"]
  for unit in ed.engine:foreachAliveUnit(skill:targetCamp()) do
    if unit.config.is_summoned then
    else
      local modifiedRadius = (DoneRadius ^ 2 - math.abs(unit.position[2] - -20) ^ 2) ^ 0.5
      local min = math.max(1, math.ceil((unit.position[1] - modifiedRadius) / step))
      local max = math.min(n, math.floor((unit.position[1] + modifiedRadius) / step))
      for i = min, max do
        values[i] = values[i] + 1
      end
    end
  end
  local max = 0
  local maxi = math.floor(n / 2)
  local start = 1
  local finish = n
  local searchDir = 1
  if 0 < skill.caster:getInitDir() then
    maxi = n - math.floor(n / 2)
    start = n
    finish = 1
    searchDir = -searchDir
  end
  for i = start, finish, searchDir do
    if max < values[i] then
      maxi = i
      max = values[i]
    end
  end
  local range = Duckboy.ZoneXRange
  maxi = Duckboy.clamp(maxi, range, n + 1 - range)
  local position = {
    maxi * step,
    -20
  }
  return position
end

function Duckboy.skillatk3_takeRegionEffectOn(basefunc, self, unit)
  if self.skill.what == "magic" then
    return
  end
  if unit:isHasUncontrolBufEffect() then
    return
  end
  unit.region_list[self.uniquenessID] = self
  local buff = self.skill:createBuff(unit)
  
  local function onRemoved(basefunc, buff)
    basefunc(buff)
    unit.region_list[self.uniquenessID] = nil
  end
  
  buff.onRemoved = ed.override(buff.onRemoved, onRemoved)
  unit[self.uniquenessID] = buff
  unit:addBuff(buff)
end

function Duckboy.skillatk3_createRegion(basefunc, self)
  local region = basefunc(self)
  local position = Duckboy.locate_pool_position(self)
  region.position = position
  region.takeRegionEffectOn = override(region.takeRegionEffectOn, Duckboy.skillatk3_takeRegionEffectOn)
  return region
end

function Duckboy.skillatk3_buff_onRemoved(basefunc, buff)
  basefunc(buff)
  local owner = buff.owner
  owner.walk_v = {0, 0}
  if ed.run_with_scene then
    ed.scene:playEffectOnScene("eff_impact_Lion_atk3.cha", owner.position, {
      owner.direction,
      1
    }, owner.height, 0)
  end
end

function Duckboy.skillatk3_buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local owner = buff.owner
  local caster = buff.caster
  if owner:isAlive() and owner.height == 0 then
    owner:setAction("Move")
    owner.walk_v[1] = buff.owner.direction * Duckboy.Duck_WalkSpeed
  end
  if not buff.Duckboy_effect_trigger then
    buff.Duckboy_effect_trigger = true
    if ed.run_with_scene then
      ed.scene:playEffectOnScene("eff_impact_Lion_atk3.cha", owner.position, {
        owner.direction,
        1
      }, owner.height, 0)
    end
    local bid = Duckboy.atk3_stun_bid
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = owner:addBuff(binfo, caster)
  end
end

function Duckboy.skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.onRemoved = override(buff.onRemoved, Duckboy.skillatk3_buff_onRemoved)
  buff.update = override(buff.update, Duckboy.skillatk3_buff_update)
  local skillawake = skill.caster.skills.Duckboy_awake
  if skillawake then
    buff.onDamaged = override(buff.onDamaged, Duckboy.skillawake_buff_onDamaged)
    buff:setAttribute("Puppet", "DuckSwitch.cha")
    buff:setAttribute("MR", skillawake.info["Script Arg2"])
  end
  return buff
end

function Duckboy.skillatk4_finish(basefunc, skill, reason)
  basefunc(skill, reason)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == Duckboy.uncontrol_bid then
      caster:removeBuff(tbuff)
    end
  end
end

function Duckboy.skillatk4a_buff_trigger(caster, target)
  if not target:isHasUncontrolBufEffect() then
    local bid
    if Duckboy.Duckboy_fashion_ID and Duckboy.Duckboy_fashion_ID == caster.fashion_id then
      bid = Duckboy.atk4_flamingo_bid
    else
      bid = Duckboy.atk4_duck_bid
    end
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local duck_buff = ed.BuffCreate(binfo, target, caster)
    local skillatk4 = caster.skills.Duckboy_atk4
    duck_buff:setAttribute("ARM", skillatk4.info["Script Arg2"])
    duck_buff:setAttribute("MR", skillatk4.info["Script Arg3"])
    target:hurt()
    target:addBuff(duck_buff, caster)
    target:setAction("Birth")
    if Duckboy.Duckboy_fashion_ID and Duckboy.Duckboy_fashion_ID == caster.fashion_id then
      duck_buff.onRemoved = override(duck_buff.onRemoved, Duckboy.fashion_onRemoved)
    end
  end
  local recoverhp = target.attribs.HP * Duckboy.atk4_recover_ratio
  if Duckboy.Duckboy_fashion_ID and Duckboy.Duckboy_fashion_ID == caster.fashion_id then
    recoverhp = target.attribs.HP * Duckboy.fashion_recover_ratio
  end
  target:takeHeal(recoverhp, "hp", caster)
end

function Duckboy.skillatk4a_buff_onDamaged(basefunc, self, damage, damage_type, source, skill, transferred)
  local temp_damage = basefunc(self, damage, damage_type, source, skill, transferred)
  local caster = self.caster
  local owner = self.owner
  local manualskill = caster.skills.Duckboy_ult
  local skillatk4 = caster.skills.Duckboy_atk4
  if caster.current_skill ~= manualskill and not caster.buff_effects.doom and not owner.Duckboy_atk4_trigger and caster.Duckboy_atk4_times < 2 and not caster.config.is_summoned and not owner.config.is_summoned and owner ~= caster and skillatk4 and caster.name == "Duckboy" and not caster.buff_effects.polymorph then
    local final_damage = Duckboy.True_damage(owner, temp_damage, damage_type)
    local maxDamage = owner.hp - 1
    if final_damage > maxDamage then
      for _, tbuff in ipairs(caster.buff_list) do
        local willBeRemove = tbuff:isCrlEftConflictWithUncontrollable() or ed.isElementInTable("derangedOwner", tbuff.info["Control Effects"])
        if willBeRemove then
          tbuff.timer = -1
        end
      end
      local owner = self.owner
      local skillatk4 = caster.skills.Duckboy_atk4
      caster.Duckboy_atk4_times = caster.Duckboy_atk4_times + 1
      if caster.current_skill then
        caster.current_skill:interrupt()
      end
      local bid = Duckboy.uncontrol_bid
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = caster:addBuff(binfo, caster)
      skillatk4.cd_remaining = 0
      caster:castSkill(skillatk4, caster)
      Duckboy.skillatk4a_buff_trigger(caster, owner)
      owner.Duckboy_atk4_trigger = true
      return 0
    end
    return final_damage
  end
  return temp_damage
end

function Duckboy.skillatk4a_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.onDamaged = override(buff.onDamaged, Duckboy.skillatk4a_buff_onDamaged)
  return buff
end

function Duckboy.fashion_onRemoved(basefunc, buff)
  basefunc(buff)
  local caster = buff.caster
  local owner = buff.owner
  if Duckboy.Duckboy_fashion_ID and Duckboy.Duckboy_fashion_ID == caster.fashion_id then
    local bid = 1546
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local fashion_shield_buff = owner:addBuff(binfo, caster)
  end
end

function Duckboy.skillawake_buff_onDamaged(basefunc, self, damage, damage_type, source, skill, transferred)
  local damage = basefunc(self, damage, damage_type, source, skill, transferred)
  local owner = self.owner
  local true_damage = Duckboy.True_damage(owner, damage, damage_type)
  if damage_type == "AP" and source then
    source:takeHeal(true_damage * Duckboy.awake_LFS_ratio, "hp")
  end
  return damage
end

function Duckboy.init_hero(hero)
  local skillult = hero.skills.Duckboy_ult
  if skillult then
    skillult.onAttackFrame = override(skillult.onAttackFrame, Duckboy.skillult_onAttackFrame)
    skillult.createBuff = override(skillult.createBuff, Duckboy.skillult_createBuff)
    skillult.takeEffectOn = override(skillult.takeEffectOn, Duckboy.skillult_takeEffectOn)
    skillult.start = override(skillult.start, Duckboy.skillult_start)
    skillult.finish = override(skillult.finish, Duckboy.skillult_finish)
    local skillulta = hero.skills.Duckboy_ulta
    if skillulta then
      skillulta.createBuff = override(skillulta.createBuff, Duckboy.skillulta_createBuff)
    end
    local skillultb = hero.skills.Duckboy_ultb
    if skillultb then
      skillultb.takeEffectOn = override(skillultb.takeEffectOn, Duckboy.skillultb_takeEffectOn)
    end
    local skillultc = hero.skills.Duckboy_ultc
    if skillultc then
      skillultc.createProjectile = override(skillultc.createProjectile, Duckboy.skillultc_createProjectile)
    end
  end
  local skillatk = hero.skills.Duckboy_atk
  if skillatk then
    skillatk.createProjectile = override(skillatk.createProjectile, Duckboy.skillatk_createProjectile)
  end
  local skillatk2 = hero.skills.Duckboy_atk2
  if skillatk2 then
    hero.collectBuff = override(hero.collectBuff, Duckboy.collectBuff)
    skillatk2.createBuff = override(skillatk2.createBuff, Duckboy.skillatk2_createBuff)
    skillatk2.createChain = override(skillatk2.createChain, Duckboy.skillatk2_createChain)
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, Duckboy.skillatk2_onAttackFrame)
    skillatk2.finish = override(skillatk2.finish, Duckboy.skillatk2_finish)
    hero.handleUnitDieEventToAll = override(hero.handleUnitDieEventToAll, Duckboy.hero_handleUnitDieEvent)
    if Duckboy.Duckboy_fashion_ID and Duckboy.Duckboy_fashion_ID == hero.fashion_id then
      skillatk2.launchPoint = override(skillatk2.launchPoint, Duckboy.skill_atk2_launchPoint)
    end
  end
  local skillatk3 = hero.skills.Duckboy_atk3
  if skillatk3 then
    skillatk3.start = override(skillatk3.start, Duckboy.skillatk3_start)
    skillatk3.finish = override(skillatk3.finish, Duckboy.skillatk3_finish)
    skillatk3.createRegion = override(skillatk3.createRegion, Duckboy.skillatk3_createRegion)
    skillatk3.createBuff = override(skillatk3.createBuff, Duckboy.skillatk3_createBuff)
  end
  local skillatk4 = hero.skills.Duckboy_atk4
  local skillatk4a = hero.skills.Duckboy_atk4a
  if skillatk4 then
    skillatk4.finish = override(skillatk4.finish, Duckboy.skillatk4_finish)
    if skillatk4a then
      skillatk4a.createBuff = override(skillatk4a.createBuff, Duckboy.skillatk4a_createBuff)
    end
  end
  hero.update = override(hero.update, Duckboy.update)
  hero.die = override(hero.die, Duckboy.die)
  return hero
end

return Duckboy.init_hero
