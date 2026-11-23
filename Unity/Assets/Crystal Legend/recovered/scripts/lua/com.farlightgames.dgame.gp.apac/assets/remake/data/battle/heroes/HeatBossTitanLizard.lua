module("ed.battlehero", package.seeall)
local ed = ed
HeatBossTitanLizard = {}

function HeatBossTitanLizard.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local bid = 12000801
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
  if ed.run_with_scene then
    ed.scene:onSceneFreezeBegin()
    for entity in ed.engine:foreachEntity() do
      if entity.actor then
        entity.actor:tint(0.4, 0.4, 0.4)
      end
    end
    if caster.actor then
      caster.actor:tint(2.5, 2.5, 2.5)
    end
    ed.scene:playZoomOnScene(caster.position, 20, "eff_UI_TitanLizard_ult", "Start", 2.375, {
      -caster.direction,
      1
    })
  end
end

function HeatBossTitanLizard.skillult_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 12000801 then
      tbuff.timer = -1
    end
  end
end

function HeatBossTitanLizard.skillult_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  local caster = skill.caster
  local target = skill.target
  basefunc(skill)
  local effect_name1 = "eff_UI_TitanLizard_field.cha"
  local effect_name2 = "eff_UI_TitanLizard_field2.cha"
  if ed.run_with_scene then
    ed.scene:playEffectOnScene(effect_name1, {400, 0}, {1, 1}, nil, 1)
    ed.scene:playEffectOnScene(effect_name2, {400, 0}, {1, 1}, nil, -1)
  end
  if ed.run_with_scene then
    ed.scene:onSceneFreezeEnd()
    for entity in ed.engine:foreachEntity() do
      if entity.actor then
        entity.actor:tint(2.5, 2.5, 2.5)
      end
    end
  end
  local apratio = 0
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 20050171 then
      apratio = 0.1
    end
    if tbuff.info.ID == 20050172 then
      apratio = 0.2
    end
    if tbuff.info.ID == 20050173 then
      apratio = 0.3
    end
    if tbuff.info.ID == 20050174 then
      apratio = 0.4
    end
  end
  local binfo = ed.lookupDataTable("Buff", nil, 12000806)
  local buff = ed.BuffCreate(binfo, caster, caster)
  if 0 < apratio then
    buff:setAttribute("AP", math.max(caster.attribs.AP * apratio, 0))
  end
  buff.onRemoved = override(buff.onRemoved, HeatBossTitanLizard.skillult_buffonRemoved)
  caster:addBuff(buff, caster)
  caster.HeatBossTitanLizard_ult_period = true
  if 0 < apratio then
    local binfo2 = ed.lookupDataTable("Buff", nil, 12000807)
    local buff2 = ed.BuffCreate(binfo2, caster, caster)
    caster:addBuff(buff2, caster)
  end
  if ed.run_with_scene then
    ed.scene:startCameraShakeAnimationY(10, 0.3, 10)
  end
end

function HeatBossTitanLizard.skillult_buffonRemoved(basefunc, buff)
  local owner = buff.owner
  owner.HeatBossTitanLizard_ult_period = false
  basefunc(buff)
end

function HeatBossTitanLizard.getRuntimeScale(basefunc, self)
  if self.isScaleActionRunning then
    local dt = self.dt_action
    self.scaleActionRunningTime = self.scaleActionRunningTime + dt
    if self.scaleActionRunningTime > self.scaleActionDuration then
      local scale = self.scaleActionScaleValue
      return self.direction * scale, scale
    else
      local scale = self.scaleActionRunningTime / self.scaleActionDuration * (self.scaleActionScaleValue - 1) + 1
      return self.direction * scale, scale
    end
  end
  if not self.isScaleActionRunning then
    local m = self.manually_casting
    return self.direction * (m and 1 or 1), m and 1 or 1
  end
end

function HeatBossTitanLizard.skillult_canCastWithTarget(basefunc, skill, target)
  if skill.caster.HeatBossTitanLizard_ult_period then
    return false, "ult_buff"
  end
  return basefunc(skill, target)
end

function HeatBossTitanLizard.skillatk2_start(basefunc, skill, target)
  local caster = skill.caster
  local originfo = skill.info
  if caster.HeatBossTitanLizard_ult_period then
    skill.info = ed.wraptable(originfo, {
      ["AOE Shape"] = "quartercircle",
      ["Shape Arg1"] = 600
    })
    skill:startPhase(2)
  else
    skill.info = ed.wraptable(originfo, {
      ["AOE Shape"] = "quartercircle",
      ["Shape Arg1"] = 360
    })
    skill:startPhase(1)
  end
  basefunc(skill, target)
end

function HeatBossTitanLizard.skillatk2_onAttackFrame(basefunc, skill)
  local attackCounter = skill.attack_counter
  local caster = skill.caster
  if ed.run_with_scene and attackCounter == 0 then
    local effect_name = "eff_point_TitanLizard_atk2.cha"
    if ed.run_with_scene then
      if caster.HeatBossTitanLizard_ult_period then
        ed.scene:playEffectOnScene(effect_name, {
          caster.position[1] + caster.direction * 112.5,
          caster.position[2] + 40.5
        }, {
          caster.direction * 2.1,
          2.1
        }, nil, 1)
      else
        ed.scene:playEffectOnScene(effect_name, {
          caster.position[1] + caster.direction * 112.5,
          caster.position[2] + 40.5
        }, {
          caster.direction * 1.05,
          1.05
        }, nil, 1)
      end
    end
  end
  basefunc(skill)
end

function HeatBossTitanLizard.skillatk2_onPhaseFinished(basefunc, self)
  self:finish()
end

function HeatBossTitanLizard.skillatk2_power(basefunc, skill, source, target, damage_type)
  local power = basefunc(skill, source, target, damage_type)
  local caster = skill.caster
  local powerratio = 1
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 20050181 then
      powerratio = 1.15
    end
    if tbuff.info.ID == 20050182 then
      powerratio = 1.3
    end
    if tbuff.info.ID == 20050183 then
      powerratio = 1.45
    end
    if tbuff.info.ID == 20050184 then
      powerratio = 1.6
    end
  end
  power = power * powerratio
  return power
end

function HeatBossTitanLizard.skillatk3_start(basefunc, skill, target)
  skill.info["No Dodge"] = true
  basefunc(skill, target)
end

function HeatBossTitanLizard.skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local buffInfo = buff.info
  local owner = buff.owner
  local caster = buff.caster
  local attribName = buffInfo.Tenacity
  local TEN_final = ed.Buff.getTenValue(buffInfo, owner, caster)
  local timer = 1
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 20050191 then
      timer = 2
    end
    if tbuff.info.ID == 20050192 then
      timer = 3
    end
    if tbuff.info.ID == 20050193 then
      timer = 4
    end
    if tbuff.info.ID == 20050194 then
      timer = 5
    end
  end
  buff.timer = timer * math.max(0.01, 1 - TEN_final / 100)
  return buff
end

function HeatBossTitanLizard.hero_reset(basefunc, hero)
  hero.HeatBossTitanLizard_ult_period = false
  basefunc(hero)
  local skillatk4 = hero.skills.HeatBossTitanLizard_atk4
  if skillatk4 then
    local bid = 12000808
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, hero, hero)
    hero:addBuff(buff, hero)
  end
end

function HeatBossTitanLizard.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  hero.dt = hero.dt and hero.dt + dt or dt
  if hero.dt == dt then
    local hpheal = 100
    for i, tbuff in ipairs(hero.buff_list) do
      if tbuff.info.ID == 20050201 then
        hpheal = 300
      end
      if tbuff.info.ID == 20050202 then
        hpheal = 500
      end
      if tbuff.info.ID == 20050203 then
        hpheal = 700
      end
      if tbuff.info.ID == 20050204 then
        hpheal = 900
      end
    end
    if 0 < hpheal then
      local bid = 12000804
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, hero, hero)
      hero:addBuff(buff, hero)
      buff.skillatk4hpheal = hpheal
      buff.attack_timer = 1
      buff.update = override(buff.update, HeatBossTitanLizard.skillatk4_buffUpdate)
    end
  end
end

function HeatBossTitanLizard.skillatk4_buffUpdate(basefunc, buff, dt)
  basefunc(buff, dt)
  local owner = buff.owner
  local timer = buff.attack_timer - dt
  while timer <= 0 do
    timer = timer + 1
    owner:takeHeal(buff.skillatk4hpheal / owner.attribs.PDM, "hp", owner)
  end
  buff.attack_timer = timer
end

function HeatBossTitanLizard.getLostHPAfterImmunity(basefunc, hero, damage, immunity, damage_type, source, skill, field)
  local lost = basefunc(hero, damage, immunity, damage_type, source, skill, field)
  local skillatk4 = hero.skills.HeatBossTitanLizard_atk4
  if lost and 0 < lost and skillatk4 and damage_type == "Holy" and field == "hp" then
    lost = lost * 1.8
    for i, tbuff in ipairs(hero.buff_list) do
      if tbuff.info.ID == 20030051 then
        lost = lost + 400
      end
      if tbuff.info.ID == 20030052 then
        lost = lost + 800
      end
    end
  end
  return lost
end

function HeatBossTitanLizard.init_hero(hero)
  local skillult = hero.skills.HeatBossTitanLizard_ult
  local skillatk = hero.skills.HeatBossTitanLizard_atk
  local skillatk2 = hero.skills.HeatBossTitanLizard_atk2
  local skillatk3 = hero.skills.HeatBossTitanLizard_atk3
  local skillatk4 = hero.skills.HeatBossTitanLizard_atk4
  hero:preloadEffect("eff_UI_TitanLizard_ult.cha")
  if skillult then
    skillult.canCastWithTarget = override(skillult.canCastWithTarget, HeatBossTitanLizard.skillult_canCastWithTarget)
    skillult.onAttackFrame = override(skillult.onAttackFrame, HeatBossTitanLizard.skillult_onAttackFrame)
    skillult.start = override(skillult.start, HeatBossTitanLizard.skillult_start)
    skillult.finish = override(skillult.finish, HeatBossTitanLizard.skillult_finish)
    hero.getRuntimeScale = override(hero.getRuntimeScale, HeatBossTitanLizard.getRuntimeScale)
  end
  if skillatk2 then
    skillatk2.start = override(skillatk2.start, HeatBossTitanLizard.skillatk2_start)
    skillatk2.onPhaseFinished = override(skillatk2.onPhaseFinished, HeatBossTitanLizard.skillatk2_onPhaseFinished)
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, HeatBossTitanLizard.skillatk2_onAttackFrame)
    skillatk2.power = override(skillatk2.power, HeatBossTitanLizard.skillatk2_power)
  end
  if skillatk3 then
    skillatk3.start = override(skillatk3.start, HeatBossTitanLizard.skillatk3_start)
    skillatk3.createBuff = override(skillatk3.createBuff, HeatBossTitanLizard.skillatk3_createBuff)
  end
  if skillatk4 then
    hero.getLostHPAfterImmunity = override(hero.getLostHPAfterImmunity, HeatBossTitanLizard.getLostHPAfterImmunity)
  end
  hero.reset = override(hero.reset, HeatBossTitanLizard.hero_reset)
  hero.update = override(hero.update, HeatBossTitanLizard.hero_update)
  return hero
end

return HeatBossTitanLizard.init_hero
