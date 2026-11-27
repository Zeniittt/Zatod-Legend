module("ed.battlehero", package.seeall)
local ed = ed
TitanLoong = {}

function TitanLoong.hero_reset(basefunc, hero)
  hero.TitanLoong_atk4_success = false
  basefunc(hero)
end

function TitanLoong.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  local skillatk4 = hero.skills.TitanLoong_atk4
  if skillatk4 and hero.TitanLoong_hasArcana and hero.TitanLoong_hasArcana > 2 and skillatk4.cd_remaining <= 0.2 and (hero.buff_effects.stun or hero.buff_effects.stunbyself or hero.buff_effects.doom or hero.buff_effects.enchanted or hero.buff_effects.enchantedbyself or hero.buff_effects.frozen or hero.buff_effects.icefrozen) then
    if ed.run_with_scene then
      local effect_name = "eff_point_TitanLoong_atk4.cha"
      local effect = ed.scene:playEffectOnScene(effect_name, hero.position, {
        hero.direction * 1,
        1
      }, nil, 1)
    end
    for _, buff in ipairs(hero.buff_list) do
      if buff.caster and not buff.caster.buff_effects.invulnerable and buff.caster.camp ~= hero.camp then
        buff.timer = -1
        hero.TitanLoong_atk4_success = true
      end
    end
    skillatk4:takeEffectOn(hero, hero)
    skillatk4.cd_remaining = skillatk4.info.CD
  end
end

function TitanLoong.skillatk_takeEffectOn(basefunc, skill, target, source)
  basefunc(skill, target, source)
  local caster = skill.caster
  local skillatk3 = caster.skills.TitanLoong_atk3
  if skillatk3 then
    if target.TitanLoong_skillatk3_count then
      target.TitanLoong_skillatk3_count = target.TitanLoong_skillatk3_count + 1
    else
      target.TitanLoong_skillatk3_count = 0
    end
    if target.TitanLoong_skillatk3_count == 4 then
      skillatk3:takeEffectOn(target, caster)
      target.TitanLoong_skillatk3_count = 0
    end
  end
  if caster.TitanLoong_hasArcana and caster.TitanLoong_hasArcana > 3 then
    local mppower = 50
    target:takeDamage(mppower, "Holy", "mp", caster)
  end
end

function TitanLoong.skillatk2_onAttackFrame(basufunc, skill)
  local caster = skill.caster
  local skillatk2s = caster.skills.TitanLoong_atk2s
  local attack_counter = skill.attack_counter
  if skillatk2s and attack_counter then
    skillatk2s:takeEffectAt({
      caster.position[1] + 80 * caster.direction + 80 * attack_counter * caster.direction,
      caster.position[2]
    }, caster)
    if ed.run_with_scene then
      local effect_name = "eff_point_TitanLoong_atk2.cha"
      local effect = ed.scene:playEffectOnScene(effect_name, {
        caster.position[1] + 80 * caster.direction + 80 * attack_counter * caster.direction,
        caster.position[2]
      }, {
        caster.direction * 1,
        1
      }, nil, 1)
    end
    basufunc(skill)
  end
end

function TitanLoong.skillatk2_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local bid = 4770
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  caster:addBuff(binfo, caster)
end

function TitanLoong.skillatk2_finish(basefunc, skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 4770 then
      tbuff.timer = -1
    end
  end
  basefunc(skill)
end

function TitanLoong.skillatk2s_takeEffectOn(basefunc, skill, target, source)
  basefunc(skill, target, source)
  local caster = skill.caster
  local skillatk3 = caster.skills.TitanLoong_atk3
  if skillatk3 then
    if target.TitanLoong_skillatk3_count then
      target.TitanLoong_skillatk3_count = target.TitanLoong_skillatk3_count + 1
    else
      target.TitanLoong_skillatk3_count = 0
    end
    if target.TitanLoong_skillatk3_count == 4 then
      skillatk3:takeEffectOn(target, caster)
      target.TitanLoong_skillatk3_count = 0
    end
  end
  if target and target:isAlive() then
    target:hurt()
  end
  if caster.TitanLoong_hasArcana and caster.TitanLoong_hasArcana > 3 then
    local mppower = 50
    target:takeDamage(mppower, "Holy", "mp", caster)
  end
end

function TitanLoong.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local bid = 4767
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
end

function TitanLoong.DOP_in_battlefield(caster, radius, camp)
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

function TitanLoong.skillult_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 4767 then
      tbuff.timer = 0
    end
  end
end

function TitanLoong.skillult_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local attack_counter = skill.attack_counter
  local region_position = TitanLoong.DOP_in_battlefield(caster, 160, caster.foecamp)
  skill.target = caster
  local region = skill:createRegion()
  region.position = region_position
  region.EffectZorder = 1
  region.update = override(region.update, TitanLoong.skillult_region_update)
  caster.skillult_region_position = region_position
  caster.skillult_region_timer = 1.25
  ed.engine:addRegion(region)
end

function TitanLoong.skillult_region_update(basefunc, region, dt)
  basefunc(region, dt)
  local caster = region.caster
  if caster.skillult_region_timer then
    caster.skillult_region_timer = caster.skillult_region_timer - dt
  end
  if caster.skillult_region_timer and caster.skillult_region_timer <= 0 and caster.skillult_region_position then
    local skillults = caster.skills.TitanLoong_ults
    skillults:takeEffectAt(region.position, caster)
    caster.skillult_region_timer = 1.25
  end
end

function TitanLoong.skillults_takeEffectOn(basefunc, skill, target, source)
  basefunc(skill, target, source)
  local caster = skill.caster
  local skillatk3 = caster.skills.TitanLoong_atk3
  if skillatk3 then
    if target.TitanLoong_skillatk3_count then
      target.TitanLoong_skillatk3_count = target.TitanLoong_skillatk3_count + 1
    else
      target.TitanLoong_skillatk3_count = 0
    end
    if target.TitanLoong_skillatk3_count == 4 then
      skillatk3:takeEffectOn(target, caster)
      target.TitanLoong_skillatk3_count = 0
    end
  end
  if target and target:isAlive() then
    target:hurt()
  end
  if caster.TitanLoong_hasArcana and caster.TitanLoong_hasArcana > 3 then
    local mppower = 50
    target:takeDamage(mppower, "Holy", "mp", caster)
  end
end

function TitanLoong.skillatk4_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local bid = 4767
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
  if ed.run_with_scene then
    local effect_name = "eff_point_TitanLoong_atk4.cha"
    local effect = ed.scene:playEffectOnScene(effect_name, caster.position, {
      caster.direction * 1,
      1
    }, nil, 1)
  end
end

function TitanLoong.skillatk4_finish(basefunc, skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 4767 then
      tbuff.timer = -1
    end
  end
  basefunc(skill)
end

function TitanLoong.skillatk4_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  for _, buff in ipairs(caster.buff_list) do
    if buff.caster and not buff.caster.buff_effects.invulnerable and buff.caster.camp ~= caster.camp then
      buff.timer = -1
      caster.TitanLoong_atk4_success = true
    end
  end
  basefunc(skill)
end

function TitanLoong.skillatk4_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = buff.caster
  if caster.TitanLoong_atk4_success then
    local AD = buff.info.AD
    local ARM = buff.info.ARM
    local MR = buff.info.MR
    local HIT = buff.info.HIT
    buff:setAttribute("AD", AD * 2)
    buff:setAttribute("ARM", ARM * 2)
    buff:setAttribute("MR", MR * 2)
    buff:setAttribute("HIT", HIT * 2)
    caster.TitanLoong_atk4_success = false
  end
  return buff
end

function TitanLoong.getRuntimeScale(basefunc, self)
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

function TitanLoong.init_hero(hero)
  local skillult = hero.skills.TitanLoong_ult
  local skillatk = hero.skills.TitanLoong_atk
  local skillatk2 = hero.skills.TitanLoong_atk2
  local skillatk3 = hero.skills.TitanLoong_atk3
  local skillatk4 = hero.skills.TitanLoong_atk4
  local skillatk2s = hero.skills.TitanLoong_atk2s
  local skillults = hero.skills.TitanLoong_ults
  hero.TitanLoong_hasArcana = ed.getProtoArcanaLevel(hero.proto)
  if skillatk then
    skillatk.takeEffectOn = override(skillatk.takeEffectOn, TitanLoong.skillatk_takeEffectOn)
  end
  if skillatk2 then
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, TitanLoong.skillatk2_onAttackFrame)
    if hero.TitanLoong_hasArcana and hero.TitanLoong_hasArcana > 1 then
      skillatk2.start = override(skillatk2.start, TitanLoong.skillatk2_start)
      skillatk2.finish = override(skillatk2.finish, TitanLoong.skillatk2_finish)
    end
  end
  if skillatk2s then
    skillatk2s.takeEffectOn = override(skillatk2s.takeEffectOn, TitanLoong.skillatk2s_takeEffectOn)
  end
  if skillatk3 then
    skillatk3.info["No Dodge"] = true
  end
  if skillatk4 then
    skillatk4.start = override(skillatk4.start, TitanLoong.skillatk4_start)
    skillatk4.finish = override(skillatk4.finish, TitanLoong.skillatk4_finish)
    skillatk4.onAttackFrame = override(skillatk4.onAttackFrame, TitanLoong.skillatk4_onAttackFrame)
    skillatk4.createBuff = override(skillatk4.createBuff, TitanLoong.skillatk4_createBuff)
  end
  if skillult then
    skillult.onAttackFrame = override(skillult.onAttackFrame, TitanLoong.skillult_onAttackFrame)
    skillult.start = override(skillult.start, TitanLoong.skillult_start)
    skillult.finish = override(skillult.finish, TitanLoong.skillult_finish)
    hero.getRuntimeScale = override(hero.getRuntimeScale, TitanLoong.getRuntimeScale)
  end
  if skillults then
    skillults.info["No Dodge"] = true
    skillults.takeEffectOn = override(skillults.takeEffectOn, TitanLoong.skillults_takeEffectOn)
  end
  hero.update = override(hero.update, TitanLoong.hero_update)
  hero.reset = override(hero.reset, TitanLoong.hero_reset)
  return hero
end

return TitanLoong.init_hero
