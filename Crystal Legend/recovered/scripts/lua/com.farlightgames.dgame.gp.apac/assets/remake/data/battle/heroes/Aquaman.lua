module("ed.battlehero", package.seeall)
local ed = ed
Aquaman = {}

function Aquaman.getFixDir(basefunc, self)
  local dir = self.direction
  return dir
end

function Aquaman.setAction(basefunc, hero, action_name, loop, interrupt)
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

function Aquaman.skillult_takeEffectOn(basefunc, skill, target, source, shift)
  if skill.attack_counter == 1 and ed.run_with_scene then
    if skill.caster.direction == 1 then
      ed.scene:playEffectOnScene("eff_point_Aquaman_ult2.cha", {350, -100}, {1, 1}, nil, 1)
      ed.scene:playEffectOnScene("eff_point_Aquaman_ult3.cha", {350, -100}, {1, 1}, nil, 1)
    elseif skill.caster.direction == -1 then
      ed.scene:playEffectOnScene("eff_point_Aquaman_ult2.cha", {480, -100}, {-1, 1}, nil, 1)
      ed.scene:playEffectOnScene("eff_point_Aquaman_ult3.cha", {480, -100}, {-1, 1}, nil, 1)
    end
  end
  basefunc(skill, target, source, shift)
end

function Aquaman.skillult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.update = override(buff.update, Aquaman.skillult_buffUpdate)
  return buff
end

function Aquaman.skillult_buffUpdate(basefunc, buff, dt)
  basefunc(buff, dt)
  local owner = buff.owner
  local caster = buff.caster
  if owner.state == ed.emUnitState_Attack and owner.current_skill and owner.current_skill.info["Cost MP"] < 1000 then
    owner.current_skill:interrupt()
    if ed.run_with_scene then
      ed.scene:playEffectOnScene("eff_point_Aquaman_ult4.cha", owner.position, {1, 1}, nil, 1)
    end
    local binfo = ed.lookupDataTable("Buff", nil, 4016)
    local buff = ed.BuffCreate(binfo, owner, caster)
    owner:addBuff(buff, caster)
  end
end

function Aquaman.skillatk2_takeEffectOn(basefunc, skill, target, source, shift)
  basefunc(skill, target, source, shift)
  if ed.run_with_scene then
    ed.scene:playEffectOnScene("eff_point_Aquaman_atk2.cha", target.position, {1, 1}, nil, 1)
  end
end

function Aquaman.skillatk3_start(basefunc, skill, target)
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

function Aquaman.skillatk3_onAttackFrame(basefunc, skill)
  local target = skill.target
  if skill.attack_counter == 0 then
    if ed.run_with_scene then
      if skill.caster.direction == 1 then
        ed.scene:playEffectOnScene("eff_point_Aquaman_atk3.cha", target.position, {1, 1}, nil, 1)
      elseif skill.caster.direction == -1 then
        ed.scene:playEffectOnScene("eff_point_Aquaman_atk3.cha", target.position, {-1, 1}, nil, 1)
      end
    end
    basefunc(skill)
  elseif skill.attack_counter == 1 and target then
    target:knockup(0.5, ed.edpMult({
      target.direction,
      0
    }, 100), false)
    basefunc(skill)
  end
end

function Aquaman.skillatk3_onPhaseFinished(basefunc, skill)
  local caster = skill.caster
  if skill.current_phase_idx == 1 then
    local initial_direction = caster.direction
    caster.direction = -caster.direction
    if initial_direction == 1 then
      caster.position[1] = caster.position[1] + 150
    else
      caster.position[1] = caster.position[1] - 150
    end
    basefunc(skill)
  else
    skill:finish()
  end
end

function Aquaman.skillatk4_start(basefunc, skill, target)
  local caster = skill.caster
  caster.direction = caster:getInitDir()
  caster.position[1] = ed.engine.stage_rect.maxX / 2 - 120 * caster:getInitDir()
  if ed.run_with_scene then
    if caster.direction == 1 then
      ed.scene:playEffectOnScene("eff_point_Aquaman_atk4.cha", {
        caster.position[1],
        caster.position[2] - 120
      }, {1, 1}, nil, 1)
    elseif caster.direction == -1 then
      ed.scene:playEffectOnScene("eff_point_Aquaman_atk4.cha", {
        caster.position[1],
        caster.position[2] - 120
      }, {-1, 1}, nil, 1)
    end
  end
  basefunc(skill, target)
end

function Aquaman.collectHPchange(basefunc, self, config)
  local skillatk4 = self.skills.Aquaman_atk4
  local percent = skillatk4.info["Script Arg2"]
  for _, buff in ipairs(config.unit.buff_list) do
    if config.unit.camp ~= self.camp then
      break
    end
    if buff.info.HPR < 0 and not buff.if_has_changed then
      buff:setAttribute("HPR", (1 - 0.01 * percent) * buff.info.HPR)
      config.unit:rebuild()
      buff.if_has_changed = true
    end
  end
end

function Aquaman.skillawake_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.onDamaged = override(buff.onDamaged, Aquaman.awakebuff_onDamaged)
  return buff
end

function Aquaman.awakebuff_onDamaged(basefunc, buff, damage, damage_type, source)
  local dmg = basefunc(buff, damage, damage_type, source)
  local caster = buff.caster
  local target = buff.owner
  local skillawake = caster.skills.Aquaman_awake
  if target.hp > 1 and target.name ~= "WhiteSnake" and target.name ~= "BS" and target.camp == caster.camp then
    local binfo = ed.lookupDataTable("Buff", nil, 4116)
    local buff = ed.BuffCreate(binfo, target, caster)
    local percent = skillawake.info["Script Arg2"]
    local hpr = (1 - 0.01 * percent) * dmg / buff.info.Time
    buff:setAttribute("HPR", -1 * hpr)
    target:addBuff(buff, caster)
    dmg = 0
  end
  return dmg
end

function Aquaman.cheer(basefunc, actor)
  local puppet = actor.puppet
  local cheerActionName = actor.model.direction == 1 and "Cheer" or "Cheer_r"
  puppet:setNextAction(cheerActionName)
  puppet:setLoop(true)
  actor.velocity = {0, 0}
  actor.node:setScaleX(actor.model.direction)
  actor.node:setScaleY(1)
  actor.offline = true
end

function Aquaman.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  if ed.run_with_scene and not hero.cheer_action_reset and hero.actor then
    hero.cheer_action_reset = true
    hero.actor.cheer = override(hero.actor.cheer, Aquaman.cheer)
  end
end

function Aquaman.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.cheer_action_reset = nil
end

function Aquaman.init_hero(hero)
  local skillult = hero.skills.Aquaman_ult
  local skillatk2 = hero.skills.Aquaman_atk2
  local skillatk3 = hero.skills.Aquaman_atk3
  local skillatk4 = hero.skills.Aquaman_atk4
  local skillawake = hero.skills.Aquaman_awake
  hero.setAction = override(hero.setAction, Aquaman.setAction)
  hero.getFixDir = override(hero.getFixDir, Aquaman.getFixDir)
  hero.update = override(hero.update, Aquaman.hero_update)
  hero.reset = override(hero.reset, Aquaman.hero_reset)
  if skillult then
    skillult.takeEffectOn = override(skillult.takeEffectOn, Aquaman.skillult_takeEffectOn)
    skillult.createBuff = override(skillult.createBuff, Aquaman.skillult_createBuff)
  end
  if skillatk2 then
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, Aquaman.skillatk2_takeEffectOn)
  end
  if skillatk3 then
    skillatk3.start = override(skillatk3.start, Aquaman.skillatk3_start)
    skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, Aquaman.skillatk3_onAttackFrame)
    skillatk3.onPhaseFinished = override(skillatk3.onPhaseFinished, Aquaman.skillatk3_onPhaseFinished)
  end
  if skillatk4 then
    skillatk4.info = ed.wraptable(skillatk4.info, {
      ["Init CD"] = 0
    })
    skillatk4.start = override(skillatk4.start, Aquaman.skillatk4_start)
    hero.collectHPchange = override(hero.collectHPchange, Aquaman.collectHPchange)
  end
  if skillawake then
    skillawake.createBuff = override(skillawake.createBuff, Aquaman.skillawake_createBuff)
  end
  return hero
end

return Aquaman.init_hero
