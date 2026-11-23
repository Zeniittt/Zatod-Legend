module("ed.battlehero", package.seeall)
local ed = ed
RogueTitanLizard = {}

function RogueTitanLizard.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local bid = 12005101
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
  end
end

function RogueTitanLizard.skillult_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 12005101 then
      tbuff.timer = -1
    end
  end
end

function RogueTitanLizard.skillult_onAttackFrame(basefunc, skill)
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
  local binfo = ed.lookupDataTable("Buff", nil, 12005106)
  local buff = ed.BuffCreate(binfo, caster, caster)
  buff.onRemoved = override(buff.onRemoved, RogueTitanLizard.skillult_buffonRemoved)
  caster:addBuff(buff, caster)
  caster.RogueTitanLizard_ult_period = true
  if ed.run_with_scene then
    ed.scene:startCameraShakeAnimationY(10, 0.3, 10)
  end
end

function RogueTitanLizard.skillult_buffonRemoved(basefunc, buff)
  local owner = buff.owner
  owner.RogueTitanLizard_ult_period = false
  basefunc(buff)
end

function RogueTitanLizard.skillult_canCastWithTarget(basefunc, skill, target)
  if skill.caster.RogueTitanLizard_ult_period then
    return false, "ult_buff"
  end
  return basefunc(skill, target)
end

function RogueTitanLizard.skillatk2_start(basefunc, skill, target)
  local caster = skill.caster
  local originfo = skill.info
  if caster.RogueTitanLizard_ult_period then
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

function RogueTitanLizard.skillatk2_onAttackFrame(basefunc, skill)
  local attackCounter = skill.attack_counter
  local caster = skill.caster
  if ed.run_with_scene and attackCounter == 0 then
    local effect_name = "eff_point_TitanLizard_atk2.cha"
    if ed.run_with_scene then
      if caster.RogueTitanLizard_ult_period then
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

function RogueTitanLizard.skillatk2_onPhaseFinished(basefunc, self)
  self:finish()
end

function RogueTitanLizard.skillatk2_power(basefunc, skill, source, target, damage_type)
  local power = basefunc(skill, source, target, damage_type)
  local caster = skill.caster
  local powerratio = 1
  power = power * powerratio
  return power
end

function RogueTitanLizard.skillatk3_start(basefunc, skill, target)
  skill.info["No Dodge"] = true
  basefunc(skill, target)
end

function RogueTitanLizard.skillatk4_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = buff.caster
  if buff.shield then
    buff.shield = caster.attribs.HP * 0.05
  end
  buff.onDamaged = override(buff.onDamaged, RogueTitanLizard.skillatk4_BuffonDamaged)
  buff.onRemoved = override(buff.onRemoved, RogueTitanLizard.skillatk4_BuffonRemoved)
  return buff
end

function RogueTitanLizard.skillatk4_BuffonDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local caster = buff.caster
  if bCrit then
    local dmg = basefunc(buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
    return dmg
  else
    local damage = 0
    local dmg = basefunc(buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
    return dmg
  end
end

function RogueTitanLizard.skillatk4_BuffonRemoved(basefunc, buff)
  basefunc(buff)
  local caster = buff.caster
  local bid = 12005108
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = ed.BuffCreate(binfo, caster, caster)
  buff.onDamaged = override(buff.onDamaged, RogueTitanLizard.skillatk4_Buff2onDamaged)
  buff.onRemoved = override(buff.onRemoved, RogueTitanLizard.skillatk4_Buff2onRemoved)
  if not ed.engine.beingEnd then
    caster:addBuff(buff, caster)
  end
end

function RogueTitanLizard.skillatk4_Buff2onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local caster = buff.caster
  if bCrit then
    local dmg = basefunc(buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
    return dmg
  else
    local damage = damage * 1.3
    local dmg = basefunc(buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
    return dmg
  end
end

function RogueTitanLizard.skillatk4_Buff2onRemoved(basefunc, buff)
  basefunc(buff)
  local caster = buff.caster
  local skillatk4 = caster.skills.RogueTitanLizard_atk4
  local buff = skillatk4:createBuff(caster)
  if not ed.engine.beingEnd then
    caster:addBuff(buff, caster)
  end
end

function RogueTitanLizard.hero_reset(basefunc, hero)
  hero.RogueTitanLizard_ult_period = false
  basefunc(hero)
  local skillatk4 = hero.skills.RogueTitanLizard_atk4
  if skillatk4 then
    local buff = skillatk4:createBuff(hero)
    hero:addBuff(buff, hero)
  end
end

function RogueTitanLizard.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
end

function RogueTitanLizard.init_hero(hero)
  local skillult = hero.skills.RogueTitanLizard_ult
  local skillatk = hero.skills.RogueTitanLizard_atk
  local skillatk2 = hero.skills.RogueTitanLizard_atk2
  local skillatk3 = hero.skills.RogueTitanLizard_atk3
  local skillatk4 = hero.skills.RogueTitanLizard_atk4
  if skillult then
    skillult.canCastWithTarget = override(skillult.canCastWithTarget, RogueTitanLizard.skillult_canCastWithTarget)
    skillult.onAttackFrame = override(skillult.onAttackFrame, RogueTitanLizard.skillult_onAttackFrame)
    skillult.start = override(skillult.start, RogueTitanLizard.skillult_start)
    skillult.finish = override(skillult.finish, RogueTitanLizard.skillult_finish)
  end
  if skillatk2 then
    skillatk2.start = override(skillatk2.start, RogueTitanLizard.skillatk2_start)
    skillatk2.onPhaseFinished = override(skillatk2.onPhaseFinished, RogueTitanLizard.skillatk2_onPhaseFinished)
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, RogueTitanLizard.skillatk2_onAttackFrame)
    skillatk2.power = override(skillatk2.power, RogueTitanLizard.skillatk2_power)
  end
  if skillatk3 then
    skillatk3.start = override(skillatk3.start, RogueTitanLizard.skillatk3_start)
  end
  if skillatk4 then
    skillatk4.createBuff = override(skillatk4.createBuff, RogueTitanLizard.skillatk4_createBuff)
  end
  hero.reset = override(hero.reset, RogueTitanLizard.hero_reset)
  hero.update = override(hero.update, RogueTitanLizard.hero_update)
  return hero
end

return RogueTitanLizard.init_hero
