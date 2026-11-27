module("ed.battlehero", package.seeall)
local ed = ed
MythBOSSTitanKOTL = {}
MythBOSSTitanKOTL.bossID = 6

function MythBOSSTitanKOTL.hero_reset(basefunc, hero)
  basefunc(hero)
  hero:setPosition({650, 0})
  local skillatk3 = hero.skills.MythBOSSTitanKOTL_atk3
  if skillatk3 then
    hero.MythBOSSTitanKOTL_atk3_count = 0
    hero.MythBOSSTitanKOTL_atk3_timer = 0
  end
  MythBOSSTitanKOTL.skillult_position = nil
  local info = ed.getDataTable("MythBossReward")
  hero.BossStageList = {}
  hero.BossTotalHp = hero.attribs.HP
  hero.Boss_nstage = 0
  hero.Boss_stageBuff = nil
  hero.mp = 1000
  for _, group in ipairs(info) do
    repeat
      if not group[MythBOSSTitanKOTL.bossID] then
      else
        if group[MythBOSSTitanKOTL.bossID]["Boss RewardLine ID"] == MythBOSSTitanKOTL.bossID then
          table.insert(hero.BossStageList, group)
        else
        end
        break -- pseudo-goto
      end
    until true
  end
end

function MythBOSSTitanKOTL.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  local skillatk3s = hero.skills.MythBOSSTitanKOTL_atk3s
  if hero.MythBOSSTitanKOTL_atk3_timer then
    hero.MythBOSSTitanKOTL_atk3_timer = hero.MythBOSSTitanKOTL_atk3_timer + dt
  else
    hero.MythBOSSTitanKOTL_atk3_timer = 0
  end
  if skillatk3s and 0 < hero.MythBOSSTitanKOTL_atk3_count and hero.MythBOSSTitanKOTL_atk3_timer >= 0.75 then
    hero.MythBOSSTitanKOTL_atk3_timer = 0
    hero.MythBOSSTitanKOTL_atk3_count = hero.MythBOSSTitanKOTL_atk3_count - 1
    local target = skillatk3s:selectTarget()
    if target and target:isAlive() then
      if ed.run_with_scene then
        local effect_name = "eff_impact_TitanHypnos_atk.cha"
        local effect = ed.scene:playEffectOnScene(effect_name, target.position, {
          target.direction * 1,
          1
        }, nil, 1)
      end
      target:hurt()
      skillatk3s:takeEffectOn(target, hero)
    end
  end
  local lostHp = hero.BossTotalHp - hero.hp
  local stagechange
  for i, Hpstage in ipairs(hero.BossStageList) do
    if lostHp >= Hpstage[MythBOSSTitanKOTL.bossID]["Damage Value"] and i > hero.Boss_nstage then
      hero.Boss_nstage = i
      stagechange = true
    end
  end
  if stagechange then
    if hero.Boss_stageBuff then
      hero.Boss_stageBuff.timer = -1
    end
    local binfo = ed.lookupDataTable("Buff", nil, hero.BossStageList[hero.Boss_nstage][MythBOSSTitanKOTL.bossID]["Buff ID"])
    local buff = ed.BuffCreate(binfo, hero, hero)
    hero.Boss_stageBuff = hero:addBuff(buff, hero)
  end
end

function MythBOSSTitanKOTL.skillatk2_onAttackFrame(basufunc, skill)
  basufunc(skill)
  local caster = skill.caster
  local skillatk4 = caster.skills.MythBOSSTitanKOTL_atk4
  if skillatk4 then
    if ed.run_with_scene then
      local effect_name = "eff_point_OK_Fashion1.cha"
      local effect = ed.scene:playEffectOnScene(effect_name, caster.position, {
        caster.direction * 1,
        1
      }, nil, 1)
    end
    skillatk4:takeEffectAt(caster.position, caster)
  end
end

function MythBOSSTitanKOTL.skillatk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.update = override(buff.update, MythBOSSTitanKOTL.skillatk2_buff_update)
  return buff
end

function MythBOSSTitanKOTL.skillatk2_buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local caster = buff.caster
  local owner = buff.owner
  local skillatk2s = caster.skills.MythBOSSTitanKOTL_atk2s
  local skillatk2 = caster.skills.MythBOSSTitanKOTL_atk2
  if buff.time_count then
    buff.time_count = buff.time_count - dt
  else
    buff.time_count = 1.1
  end
  if buff.time_count <= 0 and skillatk2s and owner:isAlive() then
    if ed.run_with_scene then
      ed.scene:playEffectOnScene("eff_point_Ten_atk3.cha", owner.position, {0.6, 0.6}, nil, 1)
    end
    skillatk2s:takeEffectOn(owner, caster)
    owner:takeDamage(skillatk2.info["Script Arg3"], "Holy", "mp", caster)
    buff.time_count = 1.1
  end
end

function MythBOSSTitanKOTL.skillatk3_onAttackFrame(basufunc, skill)
  basufunc(skill)
  local caster = skill.caster
  caster.MythBOSSTitanKOTL_atk3_count = caster.MythBOSSTitanKOTL_hasArcana and caster.MythBOSSTitanKOTL_hasArcana > 1 and 4 or 3
  caster.MythBOSSTitanKOTL_atk3_timer = 0.5
  local skillatk4 = caster.skills.MythBOSSTitanKOTL_atk4
  if skillatk4 then
    if ed.run_with_scene then
      local effect_name = "eff_point_OK_Fashion1.cha"
      local effect = ed.scene:playEffectOnScene(effect_name, caster.position, {
        caster.direction * 1,
        1
      }, nil, 1)
    end
    skillatk4:takeEffectAt(caster.position, caster)
  end
end

function MythBOSSTitanKOTL.skillatk3_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local bid = 4526
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  caster:addBuff(binfo, caster)
end

function MythBOSSTitanKOTL.skillatk3_finish(basefunc, skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 4526 then
      tbuff.timer = -1
    end
  end
  basefunc(skill)
end

function MythBOSSTitanKOTL.skillatk4_power(basefunc, skill, source, target, damage_type)
  local power, i = basefunc(skill, source, target, damage_type)
  local ratio = 1
  if target and target:isAlive() and target:isHero() and target.info.Union and target.info.Union == "Holy" then
    ratio = 1.5
  end
  return power * ratio, i
end

function MythBOSSTitanKOTL.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local bid = 4526
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
end

function MythBOSSTitanKOTL.DOP_in_battlefield(caster, radius, camp)
  local position = {400, 0}
  local count = 0
  local maxcount = 0
  local distance = 0
  local mindistance = 9999
  for x = 0, 800, 25 do
    for y = -100, 100, 25 do
      for unit in ed.engine:foreachAliveUnit(camp) do
        local unitdistance = ed.edpDistanceSQ({x, y}, unit.position)
        if unit.buffManager.invisible and unit.camp ~= caster.camp then
        elseif unitdistance <= radius * radius then
          count = count + 1
          distance = distance + unitdistance
        end
      end
      if maxcount < count then
        maxcount = count
        mindistance = distance
        position = {
          x,
          y - 75
        }
      end
      if count == maxcount and distance < mindistance then
        mindistance = distance
        position = {
          x,
          y - 75
        }
      end
      count = 0
      distance = 0
    end
  end
  if 0 < maxcount then
    return position
  else
    return caster.position
  end
end

function MythBOSSTitanKOTL.skillult_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 4526 then
      tbuff.timer = 0
    end
  end
  if MythBOSSTitanKOTL.skillult_position then
    MythBOSSTitanKOTL.skillult_position = nil
  end
end

function MythBOSSTitanKOTL.skillult_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local skillults = caster.skills.MythBOSSTitanKOTL_ults
  local attack_counter = skill.attack_counter
  if attack_counter == 0 then
    MythBOSSTitanKOTL.skillult_position = MythBOSSTitanKOTL.DOP_in_battlefield(caster, 195, caster.foecamp)
    if ed.run_with_scene and MythBOSSTitanKOTL.skillult_position then
      ed.scene:playEffectOnScene("eff_point_TitanKOTL_ult.cha", MythBOSSTitanKOTL.skillult_position, {
        caster.direction * 1,
        1
      }, nil, 1)
    end
    skill.attack_counter = skill.attack_counter + 1
  elseif attack_counter == 1 then
    basefunc(skill)
    if skillults and MythBOSSTitanKOTL.skillult_position then
      skillults:takeEffectAt(MythBOSSTitanKOTL.skillult_position, caster)
    end
    local skillatk4 = caster.skills.MythBOSSTitanKOTL_atk4
    if skillatk4 then
      if ed.run_with_scene then
        ed.scene:playEffectOnScene("eff_point_OK_Fashion1.cha", caster.position, {
          caster.direction * 1,
          1
        }, nil, 1)
      end
      skillatk4:takeEffectAt(caster.position, caster)
    end
  end
end

function MythBOSSTitanKOTL.skillults_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = buff.caster
  local owner = buff.owner
  local bid = 4529
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  owner:addBuff(binfo, caster)
  buff.onDamaged = override(buff.onDamaged, MythBOSSTitanKOTL.skillults_buff_onDamaged)
  return buff
end

function MythBOSSTitanKOTL.skillults_buff_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field)
  local lost = basefunc(buff, damage, damage_type, source, skill, transferred, field)
  local caster = buff.caster
  local owner = buff.owner
  local skillult = caster.skills.MythBOSSTitanKOTL_ult
  local extra_damage = skillult.info["Script Arg2"] + caster.attribs.AP * 1.5
  if source.camp ~= owner.camp and not transferred and damage_type ~= "Holy" then
    lost = lost + extra_damage
  end
  return lost
end

function MythBOSSTitanKOTL.skillatk4_takeEffectOn(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  if target and target:isAlive() then
    target:takeHeal(50, "mp", caster)
  end
end

function MythBOSSTitanKOTL.init_hero(hero)
  local skillult = hero.skills.MythBOSSTitanKOTL_ult
  local skillatk2 = hero.skills.MythBOSSTitanKOTL_atk2
  local skillatk3 = hero.skills.MythBOSSTitanKOTL_atk3
  local skillatk4 = hero.skills.MythBOSSTitanKOTL_atk4
  local skillults = hero.skills.MythBOSSTitanKOTL_ults
  hero.MythBOSSTitanKOTL_hasArcana = ed.getProtoArcanaLevel(hero.proto)
  if skillatk2 then
    skillatk2.createBuff = override(skillatk2.createBuff, MythBOSSTitanKOTL.skillatk2_createBuff)
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, MythBOSSTitanKOTL.skillatk2_onAttackFrame)
  end
  if skillatk3 then
    skillatk3.start = override(skillatk3.start, MythBOSSTitanKOTL.skillatk3_start)
    skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, MythBOSSTitanKOTL.skillatk3_onAttackFrame)
    skillatk3.finish = override(skillatk3.finish, MythBOSSTitanKOTL.skillatk3_finish)
  end
  if skillatk4 then
    skillatk4.power = override(skillatk4.power, MythBOSSTitanKOTL.skillatk4_power)
    if hero.MythBOSSTitanKOTL_hasArcana and hero.MythBOSSTitanKOTL_hasArcana > 2 then
      skillatk4.takeEffectOn = override(skillatk4.takeEffectOn, MythBOSSTitanKOTL.skillatk4_takeEffectOn)
    end
  end
  if skillult then
    skillult.onAttackFrame = override(skillult.onAttackFrame, MythBOSSTitanKOTL.skillult_onAttackFrame)
    skillult.start = override(skillult.start, MythBOSSTitanKOTL.skillult_start)
    skillult.finish = override(skillult.finish, MythBOSSTitanKOTL.skillult_finish)
  end
  if skillults then
    skillults.createBuff = override(skillults.createBuff, MythBOSSTitanKOTL.skillults_createBuff)
  end
  hero.update = override(hero.update, MythBOSSTitanKOTL.hero_update)
  hero.reset = override(hero.reset, MythBOSSTitanKOTL.hero_reset)
  return hero
end

return MythBOSSTitanKOTL.init_hero
