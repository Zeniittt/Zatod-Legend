module("ed.battlehero", package.seeall)
local ed = ed
BossTitanFrog = {}

function BossTitanFrog.skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.onRemoved = override(buff.onRemoved, BossTitanFrog.skillatk3_buffonRemoved)
  return buff
end

function BossTitanFrog.skillatk3_buffonRemoved(basefunc, buff)
  local caster = buff.caster
  local skillatk3 = caster.skills.BossTitanFrog_atk3
  local skillatk3s = caster.skills.BossTitanFrog_atk3s
  if buff.owner and skillatk3s and skillatk3 and caster then
    if ed.run_with_scene then
      local effect_name = "eff_point_TitanFrog_atk3.cha"
      local effect = ed.scene:playEffectOnScene(effect_name, caster.position, nil, nil, 1)
    end
    if caster then
      skillatk3s:takeEffectAt(caster.position)
    end
  end
  basefunc(buff)
end

function BossTitanFrog.skillatk4_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local bid = 12000604
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
end

function BossTitanFrog.skillatk4_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 12000604 then
      tbuff.timer = 0
    end
  end
end

function BossTitanFrog.setUnitHeight(unit, height)
  unit.height = height
  if unit.actor then
    unit.actor.height = height
  end
end

function BossTitanFrog.skillatk4_takeEffectOn(basefunc, skill, target, source, shift)
  local result = basefunc(skill, target, source, shift)
  if result and target:isAlive() then
    target:hurt()
  end
end

function BossTitanFrog.skillatk4_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.update = override(buff.update, BossTitanFrog.skillatk4_buffUpdate)
  buff.onRemoved = override(buff.onRemoved, BossTitanFrog.skillatk4_buffOnRemoved)
  return buff
end

function BossTitanFrog.skillatk4_buffUpdate(basefunc, buff, dt)
  basefunc(buff, dt)
  if not buff.exsit_time then
    buff.exsit_time = 0
  else
    buff.exsit_time = buff.exsit_time + dt
  end
  if buff.exsit_time >= 14 then
    buff.timer = 0
  end
  if not buff.time_index then
    buff.time_index = 0
  else
    buff.time_index = buff.time_index + 1
  end
  local owner = buff.owner
  if buff.time_index <= 16 then
    BossTitanFrog.setUnitHeight(owner, owner.height + 5 + (1 + 2 * ed.rand()))
  else
    BossTitanFrog.setUnitHeight(owner, owner.height + 1 - 2 * ed.rand())
  end
end

function BossTitanFrog.skillatk4_buffOnRemoved(basefunc, buff)
  local caster = buff.caster
  local skillatk4s = caster.skills.BossTitanFrog_atk4s
  local owner = buff.owner
  if ed.run_with_scene then
    local effect_name = "eff_point_TitanFrog_atk3.cha"
    local effect = ed.scene:playEffectOnScene(effect_name, owner.position, nil, nil, 1)
  end
  owner.height = 0
  if owner.actor then
    owner.actor.height = 0
  end
  if skillatk4s and owner and owner:isAlive() and not owner.name == "Phoenix" then
    skillatk4s:takeEffectAt(owner.position)
  end
  basefunc(buff)
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 12000602 then
      tbuff.timer = 0
    end
  end
end

function BossTitanFrog.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local target = skill.target
  local bid = 12000605
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  caster:addBuff(binfo, caster)
end

function BossTitanFrog.skillult_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local target = skill.target
  if caster then
    for i, tbuff in ipairs(caster.buff_list) do
      if tbuff.info.ID == 12000605 then
        tbuff.timer = 0
      end
    end
  end
  if target then
    for i, tbuff in ipairs(target.buff_list) do
      if tbuff.info.ID == 12000603 then
        tbuff.timer = 0
      end
    end
  end
end

function BossTitanFrog.skillult_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  local caster = skill.caster
  local skillult = caster.skills.BossTitanFrog_ult
  local skillults = caster.skills.BossTitanFrog_ults
  local target = skill.target
  if skillult and target then
    if attack_counter == 0 then
      basefunc(skill)
      if ed.run_with_scene then
        local effect_name = "eff_buff_TitanFrog_ult.cha"
        local effect = ed.scene:playEffectOnScene(effect_name, {
          target.position[1],
          target.position[2] - 1
        }, nil, nil, 1)
      end
    elseif attack_counter == 1 then
      local mp_damage = target.mp
      skillults:takeEffectAt(target.position)
      target:takeDamage(mp_damage, "Holy", "mp", caster, 1, 1, true)
      if ed.run_with_scene then
        local effect_name = "eff_point_TitanFrog_ult.cha"
        local effect = ed.scene:playEffectOnScene(effect_name, target.position, nil, nil, 1)
      end
      skill.attack_counter = skill.attack_counter + 1
    end
  end
end

function BossTitanFrog.skillatk5_start(basefunc, skill, target)
  local caster = skill.caster
  local bid = 56
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
  basefunc(skill)
end

function BossTitanFrog.skillatk5_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local isRet, duration = skill:getDurationFromAttackFrameToEnd(skill.current_phase, skill.next_event)
  caster:startScalingAction(1.2, 1)
end

function BossTitanFrog.skillatk5_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  if caster then
    caster:enterActionStageFromOneStage(2, 200006)
    if ed.run_with_scene then
      local effect_name = "eff_buff_DruidBear_transform.cha"
      ed.scene:playEffectOnScene(effect_name, caster.position, {
        caster.direction * 1,
        1
      }, 0, 0)
    end
  end
  caster.config.dps_mod = caster.config.dps_mod and caster.config.dps_mod * 2
  caster:endScalingAction()
end

function BossTitanFrog.init_hero(hero)
  local skillatk2 = hero.skills.BossTitanFrog_atk2
  local skillatk3 = hero.skills.BossTitanFrog_atk3
  local skillatk4 = hero.skills.BossTitanFrog_atk4
  local skillatk3s = hero.skills.BossTitanFrog_atk3s
  local skillatk4s = hero.skills.BossTitanFrog_atk4s
  local skillult = hero.skills.BossTitanFrog_ult
  local skillults = hero.skills.BossTitanFrog_ults
  local skillatk5 = hero.skills.BossTitanFrog_atk5
  hero.BossTitanFrog_hasArcana = ed.getProtoArcanaLevel(hero.proto)
  if skillatk5 then
    skillatk5.start = override(skillatk5.start, BossTitanFrog.skillatk5_start)
    skillatk5.finish = override(skillatk5.finish, BossTitanFrog.skillatk5_finish)
    skillatk5.onAttackFrame = override(skillatk5.onAttackFrame, BossTitanFrog.skillatk5_onAttackFrame)
  end
  if skillatk3 then
    skillatk3.createBuff = override(skillatk3.createBuff, BossTitanFrog.skillatk3_createBuff)
  end
  if skillatk4 then
    skillatk4.start = override(skillatk4.start, BossTitanFrog.skillatk4_start)
    skillatk4.finish = override(skillatk4.finish, BossTitanFrog.skillatk4_finish)
    skillatk4.createBuff = override(skillatk4.createBuff, BossTitanFrog.skillatk4_createBuff)
    skillatk4.takeEffectOn = override(skillatk4.takeEffectOn, BossTitanFrog.skillatk4_takeEffectOn)
  end
  if skillult and skillults then
    skillult.start = override(skillult.start, BossTitanFrog.skillult_start)
    skillult.finish = override(skillult.finish, BossTitanFrog.skillult_finish)
    skillult.onAttackFrame = override(skillult.onAttackFrame, BossTitanFrog.skillult_onAttackFrame)
  end
  return hero
end

return BossTitanFrog.init_hero
