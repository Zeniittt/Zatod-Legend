module("ed.battlehero", package.seeall)
local ed = ed
GreenLantern = {}
GreenLantern.atk4_ratio_index_max = 1.5
GreenLantern.awake_period = 10
GreenLantern.awake_buff_ID = 4121
GreenLantern.atk4_buff_ID = 4122
GreenLantern.atk4_max = 10000

function GreenLantern.reset(basefunc, unit)
  basefunc(unit)
  unit.GreenLantern_update_index = 0
  unit.GreenLantern_awake_frame_hp = 0
  unit.cheer_action_reset = nil
end

function GreenLantern.getFixDir(basefunc, self)
  local dir = self.direction
  return dir
end

function GreenLantern.setAction(basefunc, hero, action_name, loop, interrupt)
  local movable = not hero.buff_effects.immoblilize
  local pos = hero.position
  local v1 = movable and hero.walk_v or ed.edpZero
  if hero.buff_effects.fix then
    hero.direction = hero:getFixDir()
  else
    local direction = 0
    if movable and v1[1] ~= 0 then
      direction = v1[1]
    elseif hero.current_skill and hero.current_skill.target and not hero.current_skill.casterDirectionLocked then
      direction = hero.current_skill.target.position[1] - pos[1]
    end
    if direction * hero.direction < 0 then
      hero.direction = hero.direction * -1
    end
  end
  if action_name then
    local puppetName = hero.puppet_stack[#hero.puppet_stack]
    puppetName = ed.lookupDataTable("Puppet", "Resource", puppetName) .. ".cha"
    if hero.direction == -1 or hero:getInitDir() == -1 and action_name == "Move2" then
      local action_r = ed.lookupDataTable("AnimDuration", "Duration", puppetName, action_name .. "_r")
      if action_r then
        action_name = action_name .. "_r"
      end
    end
    hero.action_loop = loop or false
    if loop and action_name == hero.action_name then
      return
    end
    hero.action_name = action_name
    hero.action_elapsed = interrupt and 0 or math.max(0, hero.action_elapsed - hero.action_duration)
    if not loop and action_name ~= nil then
      hero.action_duration = ed.lookupDataTable("AnimDuration", "Duration", puppetName, action_name)
      if not hero.action_duration then
        print("nil action duration in table AnimDuration puppetName -> " .. puppetName)
        print("nil action duration in table AnimDuration action_name -> " .. action_name)
        hero.action_name = "Idle"
        hero.action_duration = 1.375
      end
    else
      hero.action_duration = 0
    end
    if hero.actor then
      hero.actor:onStartNewAction()
    end
  end
end

function GreenLantern.skillatk3_start(basefunc, skill, target)
  local caster = skill.caster
  local FarestTarget
  local min = 0
  if target then
    for unit in ed.engine:foreachAliveUnit(caster.foecamp) do
      if not unit.buff_effects.untargetable and not unit.buffManager.invisible and not unit.config.is_summoned and unit.position[1] < 800 and 0 < unit.position[1] then
        local distanceSQ = (unit.position[1] - caster.position[1]) ^ 2 + (unit.position[2] - caster.position[2]) ^ 2
        if min <= distanceSQ then
          min = distanceSQ
          FarestTarget = unit
        end
      end
    end
    if FarestTarget then
      target = FarestTarget
    end
  end
  basefunc(skill, target)
end

function GreenLantern.skillatk4_start(basefunc, skill, target)
  local caster = skill.caster
  caster.direction = caster:getInitDir()
  caster.position[1] = ed.engine.stage_rect.maxX / 2 - 120 * caster:getInitDir()
  local binfo = ed.lookupDataTable("Buff", nil, GreenLantern.atk4_buff_ID)
  local buff = ed.BuffCreate(binfo, caster, caster)
  buff.onDamaged = override(buff.onDamaged, GreenLantern.atk4buff_onDamaged)
  caster:addBuff(buff, caster)
  basefunc(skill, target)
end

function GreenLantern.atk4buff_onDamaged(basefunc, buff, damage, damage_type, source)
  local dmg = basefunc(buff, damage, damage_type, source)
  local caster = buff.owner
  local skillatk4 = caster.skills.GreenLantern_atk4
  local ratio = skillatk4.info["Script Arg2"] / 100
  if source and source.GreenLantern_atk4_anti_infinite == nil and damage_type ~= "Holy" then
    source.GreenLantern_atk4_anti_infinite = 1
    if dmg * ratio >= GreenLantern.atk4_max then
      source:takeDamage(GreenLantern.atk4_max, "Holy", "hp", caster)
    else
      source:takeDamage(dmg * ratio, "Holy", "hp", caster)
    end
    if ed.run_with_scene then
      ed.scene:playEffectOnScene("eff_buff_GreenLantern_atk4.cha", caster.position, {1, 1}, nil, 1)
    end
  end
  source.GreenLantern_atk4_anti_infinite = nil
  if damage_type ~= "Holy" then
    dmg = dmg * (1 - ratio)
  end
  return dmg
end

function GreenLantern.update(basefunc, self, dt)
  basefunc(self, dt)
  local skillawake = self.skills.GreenLantern_awake
  if skillawake then
    self.GreenLantern_update_index = self.GreenLantern_update_index + dt
    if self.GreenLantern_update_index % 10 == 0 then
      local binfo = ed.lookupDataTable("Buff", nil, GreenLantern.awake_buff_ID)
      local buff = ed.BuffCreate(binfo, self, self)
      self:addBuff(buff, self)
      local nearestUnit
      local nearestDistance = math.huge
      for unit in ed.engine:foreachAliveUnit(self.camp) do
        if not unit.buff_effects.untargetable and unit.info["Unit Type"] == "Hero" then
          local d = ed.edpDistanceSQ(unit.position, self.position)
          if nearestDistance > d and unit ~= self then
            nearestUnit = unit
            nearestDistance = d
          end
        end
      end
      if nearestUnit then
        local binfo = ed.lookupDataTable("Buff", nil, GreenLantern.awake_buff_ID)
        local buff = ed.BuffCreate(binfo, nearestUnit, self)
        nearestUnit:addBuff(buff, self)
      end
      local the_frame_hp = self.GreenLantern_awake_frame_hp
      self.GreenLantern_awake_frame_hp = self.hp
      if the_frame_hp > self.GreenLantern_awake_frame_hp then
        local skillawake = self.skills.GreenLantern_awake
        if skillawake then
          local def = the_frame_hp - self.GreenLantern_awake_frame_hp
          self:takeHeal(skillawake.info["Script Arg2"] * def / 100, "hp", self)
        end
      end
    end
  end
  if ed.run_with_scene and not self.cheer_action_reset and self.actor then
    self.cheer_action_reset = true
    self.actor.cheer = override(self.actor.cheer, GreenLantern.cheer)
  end
end

function GreenLantern.cheer(basefunc, actor)
  local puppet = actor.puppet
  local cheerActionName = actor.model.direction == 1 and "Cheer" or "Cheer_r"
  puppet:setNextAction(cheerActionName)
  puppet:setLoop(true)
  actor.velocity = {0, 0}
  actor.node:setScaleX(actor.model.direction)
  actor.node:setScaleY(1)
  actor.offline = true
end

function GreenLantern.init_hero(hero)
  local skillatk3 = hero.skills.GreenLantern_atk3
  local skillatk4 = hero.skills.GreenLantern_atk4
  hero.setAction = override(hero.setAction, GreenLantern.setAction)
  hero.getFixDir = override(hero.getFixDir, GreenLantern.getFixDir)
  hero.update = override(hero.update, GreenLantern.update)
  hero.reset = override(hero.reset, GreenLantern.reset)
  if skillatk3 then
    skillatk3.start = override(skillatk3.start, GreenLantern.skillatk3_start)
  end
  if skillatk4 then
    skillatk4.info = ed.wraptable(skillatk4.info, {
      ["Init CD"] = 0
    })
    skillatk4.start = override(skillatk4.start, GreenLantern.skillatk4_start)
  end
  return hero
end

return GreenLantern.init_hero
