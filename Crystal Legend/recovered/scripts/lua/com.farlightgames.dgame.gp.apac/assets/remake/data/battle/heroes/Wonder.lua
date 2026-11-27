module("ed.battlehero", package.seeall)
local ed = ed
Wonder = {}
Wonder.ult_self = 4102
Wonder.atk2_self = 4102
Wonder.atk4_first_mark = 4105
Wonder.atk4_enduring_mark = 4103
Wonder.atk4_Lasso = 4106
Wonder.awake_self = 4104
Wonder.atk4_self_mark = 4107
Wonder.reflection_range = 180
Wonder.atk2_hpprotect_index = 0.3

function Wonder.getFixDir(basefunc, self)
  local dir = self.direction
  return dir
end

function Wonder.setAction(basefunc, hero, action_name, loop, interrupt)
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

function Wonder.reset(basefunc, hero)
  basefunc(hero)
  hero.index = 0
  if ed.protoAwake(hero.proto, 10069) then
    local binfo = ed.lookupDataTable("Buff", nil, Wonder.awake_self)
    local buff = ed.BuffCreate(binfo, hero, hero)
    buff.update = override(buff.update, Wonder.awakebuff_update)
    hero:addBuff(buff, hero)
  end
end

function Wonder.atk4_self_mark_update(basefunc, buff, dt)
  basefunc(buff, dt)
  if buff.Wonder_atk4_if_takeHeal_CD_going == true then
    buff.Wonder_atk4_takeHeal_CD = buff.Wonder_atk4_takeHeal_CD + dt
  end
end

function Wonder.awakebuff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local caster = buff.owner
  local skillawake = caster.skills.Wonder_awake
  for _, projectile in ipairs(ed.engine.projectile_list) do
    if projectile.skill.info["Damage Type"] ~= "AD" then
    elseif projectile.camp == caster.camp then
    elseif projectile.skill.target ~= caster then
    elseif not projectile.can_be_influenced then
    elseif projectile.is_region or projectile.is_chain then
    else
      local xy = ed.edpSub(caster.position, projectile.position)
      local l = (xy[1] * xy[1] + xy[2] * xy[2]) ^ 0.5
      if l <= Wonder.reflection_range then
        local rand = skillawake.info["Script Arg2"]
        local reflect_rand = ed.rand() * 100
        if rand > reflect_rand then
          caster.Wonder_awake_projectile_rev_target = projectile.caster
          caster.Wonder_awake_projectile_rev_skill = projectile.skill
          caster.Wonder_awake_projectile_rev = ed.ProjectileCreate(skillawake)
          caster.Wonder_awake_projectile_rev.position = projectile.position
          caster.Wonder_awake_projectile_rev.height = projectile.height
          local originfo = skillawake.info
          skillawake.info = ed.wraptable(originfo, {
            ["Damage Type"] = projectile.skill.info["Damage Type"],
            ["Impact Effect"] = projectile.skill.info["Impact Effect"],
            ["Tile Art"] = projectile.skill.info["Tile Art"],
            ["Tile XY Speed"] = 500,
            ["Tile Z Speed"] = -100,
            ["Aim Target"] = "YES"
          })
          ed.engine:addProjectile(caster.Wonder_awake_projectile_rev)
          skillawake.info = originfo
          if ed.run_with_scene then
            if projectile.position[1] >= caster.position[1] then
              ed.scene:playEffectOnScene("eff_point_Wonder_awake.cha", caster.position, {1, 1}, nil, 0)
            else
              ed.scene:playEffectOnScene("eff_point_Wonder_awake2.cha", caster.position, {1, 1}, nil, 0)
            end
          end
          projectile:terminate()
        else
          if ed.run_with_scene then
            if projectile.position[1] >= caster.position[1] then
              ed.scene:playEffectOnScene("eff_point_Wonder_awake.cha", caster.position, {1, 1}, nil, 0)
            else
              ed.scene:playEffectOnScene("eff_point_Wonder_awake2.cha", caster.position, {1, 1}, nil, 0)
            end
          end
          projectile:terminate()
        end
      end
    end
    if caster.Wonder_awake_projectile_rev_target and caster.Wonder_awake_projectile_rev and caster.Wonder_awake_projectile_rev.position[1] >= caster.Wonder_awake_projectile_rev_target.position[1] - 30 then
      caster.Wonder_awake_projectile_rev.skill = skillawake
      local originfo = skillawake.info
      skillawake.info = ed.wraptable(originfo, {
        ["Damage Type"] = caster.Wonder_awake_projectile_rev_skill.info["Damage Type"],
        ["Impact Effect"] = caster.Wonder_awake_projectile_rev_skill.info["Impact Effect"]
      })
      caster.Wonder_awake_projectile_rev:hit(caster.Wonder_awake_projectile_rev_target)
      skillawake.info = originfo
      caster.Wonder_awake_projectile_rev:terminate()
      caster.Wonder_awake_projectile_rev = nil
    end
  end
end

function Wonder.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local binfo = ed.lookupDataTable("Buff", nil, Wonder.ult_self)
  caster.Wonder_ult_buff_self = ed.BuffCreate(binfo, caster, caster)
  caster:addBuff(caster.Wonder_ult_buff_self, caster)
end

function Wonder.skillult_takeEffectAt(basefunc, skill, location, source)
  local caster = skill.caster
  local foenum = 0
  if caster.direction == 1 then
    for unit in ed.engine:foreachAliveUnit(caster.foecamp) do
      if unit.position[1] >= caster.position[1] then
        foenum = foenum + 1
      end
    end
    for unit in ed.engine:foreachAliveUnit(caster.foecamp) do
      if unit.position[1] >= caster.position[1] then
        skill:takeEffectOn(unit, caster, nil, caster.direction, foenum)
      end
    end
  elseif caster.direction == -1 then
    for unit in ed.engine:foreachAliveUnit(caster.foecamp) do
      if unit.position[1] <= caster.position[1] then
        foenum = foenum + 1
      end
    end
    for unit in ed.engine:foreachAliveUnit(caster.foecamp) do
      if unit.position[1] <= caster.position[1] then
        skill:takeEffectOn(unit, caster, nil, caster.direction, foenum)
      end
    end
  end
end

function Wonder.skillult_takeEffectOn(basefunc, skill, target, source, shift, Caster_direction, Foenum)
  if not target.config.is_boss or not ed.engine.guildInstance_mode then
    if Caster_direction == 1 then
      if 1 < Foenum then
        target.distance = 1.7 * ((800 - target.position[1]) / Foenum)
      else
        target.distance = 800 - target.position[1] - 100
      end
      target:knockup(0.3, {
        0.8 * target.distance,
        0
      }, true)
    elseif Caster_direction == -1 then
      if 1 < Foenum then
        target.distance = 1.7 * (target.position[1] / Foenum)
      else
        target.distance = target.position[1] - 100
      end
      target:knockup(0.3, {
        -0.8 * target.distance,
        0
      }, true)
    end
  end
  target:takeDamage(skill.level * 320, "AD", "hp", skill.caster)
  local binfo = ed.lookupDataTable("Buff", nil, 4016)
  local buff = ed.BuffCreate(binfo, target, skill.caster)
  target:addBuff(buff, skill.caster)
  if ed.run_with_scene then
    ed.scene:startCameraShakeAnimationY(90, 0.5, 10)
  end
end

function Wonder.skillult_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  if caster.Wonder_ult_buff_self then
    caster.Wonder_ult_buff_self.timer = 0
  end
end

function Wonder.skillatk2_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local binfo = ed.lookupDataTable("Buff", nil, Wonder.atk2_self)
  caster.atk2_self_buff = ed.BuffCreate(binfo, caster, caster)
  caster:addBuff(caster.atk2_self_buff, caster)
  local skillult = caster.skills.Wonder_ult
  caster.skillult_original_CD = skillult.cd_remaining
  skillult.cd_remainging = 999
end

function Wonder.skillatk2_startPhase(basefunc, skill, idx)
  basefunc(skill, idx)
  local current_phase_idx = skill.current_phase_idx
  if current_phase_idx == 2 then
    local caster = skill.caster
    local right_position = 0
    local right_unit
    for unit in ed.engine:foreachAliveUnit(caster.foecamp) do
      if right_position <= unit.position[1] then
        right_position = unit.position[1]
        right_unit = unit
      end
    end
    local left_position = 0
    local left_unit
    for unit in ed.engine:foreachAliveUnit(caster.foecamp) do
      if left_position >= unit.position[1] then
        left_position = unit.position[1]
        left_unit = unit
      end
    end
    if caster.direction == 1 then
      if right_unit then
        caster.position[1] = right_unit.position[1] + 50
        caster.position[2] = right_unit.position[2]
        if caster.position[1] > 800 then
          caster.position[1] = 780
        end
      end
    elseif caster.direction == -1 and left_unit then
      caster.position[1] = left_unit.position[1] - 50
      caster.position[2] = left_unit.position[2]
      if 0 > caster.position[1] then
        caster.position[1] = 20
      end
    end
  end
end

function Wonder.skillatk2_onPhaseFinished(basefunc, skill)
  local current_phase_idx = skill.current_phase_idx
  local caster = skill.caster
  if current_phase_idx == 1 then
    if ed.run_with_scene then
      if caster.direction == 1 then
        ed.scene:playEffectOnScene("eff_point_Wonder_atk2.cha", {
          800 - 0.5 * (730 - caster.position[1]),
          caster.position[2]
        }, {1, 1}, nil, 1)
      elseif caster.direction == -1 then
        ed.scene:playEffectOnScene("eff_point_Wonder_atk2.cha", {
          0.5 * (caster.position[1] - 30),
          caster.position[2]
        }, {1, 1}, nil, 1)
      end
    end
    skill:startPhase(current_phase_idx + 1)
  elseif current_phase_idx == 2 then
    if caster.atk2_self_buff then
      caster.atk2_self_buff.timer = 0
    end
    caster.direction = -1 * caster.direction
    local skillult = caster.skills.Wonder_ult
    skillult.cd_remainging = caster.skillult_original_CD
    skill:finish()
  end
end

function Wonder.skillatk3_start(basefunc, skill, target)
  basefunc(skill, target)
end

function Wonder.skillatk3_takeEffectAt(basefunc, skill, location, source)
  if skill.attack_counter == 1 then
    basefunc(skill, location, source)
  elseif skill.attack_counter == 2 then
    local atk_position = skill:launchPoint()
    local caster = skill.caster
    caster.atk3_final_pos_x = atk_position[1]
  end
end

function Wonder.skillatk3_onPhaseFinished(basefunc, skill)
  local caster = skill.caster
  if caster.atk3_final_pos_x then
    caster.position[1] = caster.atk3_final_pos_x
  else
    caster.position[1] = caster.position[1] + caster.direction * 110
  end
  skill:finish()
end

function Wonder.skillatk4_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  caster.position[1] = ed.engine.stage_rect.maxX / 2 - 120 * caster:getInitDir()
end

function Wonder.skillatk4_takeEffectAt(basefunc, skill)
  local caster = skill.caster
  for unit in ed.engine:foreachAliveUnit(caster.foecamp) do
    local binfo = ed.lookupDataTable("Buff", nil, Wonder.atk4_first_mark)
    local buff_first = ed.BuffCreate(binfo, unit, caster)
    unit:addBuff(buff_first, caster)
  end
end

function Wonder.update(basefunc, hero, dt)
  basefunc(hero, dt)
  hero.index = hero.index + dt
  if hero.index == 1 then
    local skillatk4 = hero.skills.Wonder_atk4
    if skillatk4 then
      for unit in ed.engine:foreachAliveUnit(hero.camp) do
        local binfo = ed.lookupDataTable("Buff", nil, Wonder.atk4_self_mark)
        local buff = ed.BuffCreate(binfo, unit, hero)
        buff.update = override(buff.update, Wonder.atk4_self_mark_update)
        buff.Wonder_atk4_takeHeal_CD = 0
        buff.Wonder_atk4_if_takeHeal_CD_going = false
        buff.Wonder_atk4_takeHeal_not_first = true
        unit.Wonder_akt4_buff_for_CD = unit:addBuff(buff, hero)
      end
    end
  end
end

function Wonder.listerRemoveBuff(basefunc, self, config)
  local skillatk4 = self.skills.Wonder_atk4
  if skillatk4 and not ed.engine.beingEnd then
    local buff = config.buff
    local owner = buff.owner
    local caster = buff.caster
    local heal_hp_amount = skillatk4.info["Script Arg2"]
    local heal_mp_amount = skillatk4.info["Script Arg3"]
    if caster then
      local Caster_Wonder_atk4_buff = caster.Wonder_akt4_buff_for_CD
      if owner.camp ~= self.camp and buff.timer < 0 and buff:isCrlEftConflictWithUncontrollable() and buff.info.ID ~= 593 and buff.info.ID ~= Wonder.atk4_Lasso then
        if Caster_Wonder_atk4_buff then
          if Caster_Wonder_atk4_buff.Wonder_atk4_takeHeal_not_first == true then
            caster:takeHeal(heal_hp_amount, "hp", self)
            caster:takeHeal(heal_mp_amount, "mp", self)
            Caster_Wonder_atk4_buff.Wonder_atk4_if_takeHeal_CD_going = true
            Caster_Wonder_atk4_buff.Wonder_atk4_takeHeal_not_first = false
          elseif Caster_Wonder_atk4_buff.Wonder_atk4_takeHeal_CD >= 4 then
            caster:takeHeal(heal_hp_amount, "hp", self)
            caster:takeHeal(heal_mp_amount, "mp", self)
            Caster_Wonder_atk4_buff.Wonder_atk4_takeHeal_CD = 0
          end
        end
        local binfo = ed.lookupDataTable("Buff", nil, Wonder.atk4_Lasso)
        local buff_Lasso = ed.BuffCreate(binfo, owner, self)
        owner:addBuff(buff_Lasso, self)
      end
    end
  end
end

function Wonder.init_hero(hero)
  local skillult = hero.skills.Wonder_ult
  local skillatk2 = hero.skills.Wonder_atk2
  local skillatk3 = hero.skills.Wonder_atk3
  local skillatk4 = hero.skills.Wonder_atk4
  local skillawake = hero.skills.Wonder_awake
  hero.setAction = override(hero.setAction, Wonder.setAction)
  hero.getFixDir = override(hero.getFixDir, Wonder.getFixDir)
  hero.update = override(hero.update, Wonder.update)
  hero.reset = override(hero.reset, Wonder.reset)
  if skillult then
    skillult.start = override(skillult.start, Wonder.skillult_start)
    skillult.takeEffectAt = override(skillult.takeEffectAt, Wonder.skillult_takeEffectAt)
    skillult.takeEffectOn = override(skillult.takeEffectOn, Wonder.skillult_takeEffectOn)
    skillult.finish = override(skillult.finish, Wonder.skillult_finish)
  end
  if skillatk2 then
    skillatk2.start = override(skillatk2.start, Wonder.skillatk2_start)
    skillatk2.startPhase = override(skillatk2.startPhase, Wonder.skillatk2_startPhase)
    skillatk2.onPhaseFinished = override(skillatk2.onPhaseFinished, Wonder.skillatk2_onPhaseFinished)
  end
  if skillatk3 then
    skillatk3.start = override(skillatk3.start, Wonder.skillatk3_start)
    skillatk3.takeEffectAt = override(skillatk3.takeEffectAt, Wonder.skillatk3_takeEffectAt)
    skillatk3.onPhaseFinished = override(skillatk3.onPhaseFinished, Wonder.skillatk3_onPhaseFinished)
  end
  if skillatk4 then
    skillatk4.info = ed.wraptable(skillatk4.info, {
      ["Init CD"] = 0
    })
    skillatk4.start = override(skillatk4.start, Wonder.skillatk4_start)
    skillatk4.takeEffectAt = override(skillatk4.takeEffectAt, Wonder.skillatk4_takeEffectAt)
    hero.listerRemoveBuff = override(hero.listerRemoveBuff, Wonder.listerRemoveBuff)
  end
  return hero
end

return Wonder.init_hero
