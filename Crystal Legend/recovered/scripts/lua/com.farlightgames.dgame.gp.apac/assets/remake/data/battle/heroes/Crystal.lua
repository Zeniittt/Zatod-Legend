module("ed.battlehero", package.seeall)
local ed = ed
Crystal = {}
Crystal.ult_HPloss_index = 0.5
Crystal.ult_selfrecover_index = 0.07
Crystal.ult_enemyrecover_index = 0.035
Crystal.atk2_transfer_percent = 0.33
Crystal.Boss_PVEloss_Percent = 250
Crystal.Boss_MU_Percent = 0.2
Crystal.ult_hprecover_bid = 4091
Crystal.ult_self = 4098
Crystal.atk4_self = 4097
Crystal.atk3_bid = 4092
Crystal.atk4_bid_enemy = 4093
Crystal.atk4_bid_self = 4099
Crystal.awake_self = 4100
Crystal.ult_self_invulnerable = 4124

function Crystal.reset(basefunc, hero)
  basefunc(hero)
  hero.if_awake_effect = false
  hero.skillawake_hploss = 0
  hero.self_is_death = false
  if ed.protoAwake(hero.proto, 10072) then
    local binfo = ed.lookupDataTable("Buff", nil, Crystal.awake_self)
    local buff = ed.BuffCreate(binfo, hero, hero)
    hero:addBuff(buff, hero)
  end
end

function Crystal.update(basefunc, hero, dt)
  basefunc(hero, dt)
  if hero.if_awake_effect == true then
    local skillawake = hero.skills.Crystal_awake
    for unit in ed.engine:foreachAliveUnit(hero.camp) do
      if math.abs(unit.position[1] - hero.position[1]) < 200 and unit ~= hero then
        unit:takeHeal(0.01 * skillawake.info["Script Arg2"] * hero.skillawake_hploss, "hp", hero)
        if ed.run_with_scene then
          ed.scene:playEffectOnScene("eff_point_Crystal_awake_other.cha", unit.position, {1, 1}, nil, 1)
        end
      end
    end
    hero.if_awake_effect = false
  end
end

function Crystal.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local binfo = ed.lookupDataTable("Buff", nil, Crystal.ult_self)
  caster.Crystal_ult_buff_self = ed.BuffCreate(binfo, caster, caster)
  caster:addBuff(caster.Crystal_ult_buff_self, caster)
  local caster = skill.caster
  if caster.hp > 1 then
    caster:takeDamage((45 - skill.info["Script Arg2"]) * 0.01 * caster.hp, "Holy", "hp", caster)
  end
  local binfo = ed.lookupDataTable("Buff", nil, Crystal.ult_self_invulnerable)
  caster.Crystal_ult_self_invulnerable_buff = ed.BuffCreate(binfo, caster, caster)
  caster:addBuff(caster.Crystal_ult_self_invulnerable_buff, caster)
end

function Crystal.skillult_takeEffectAt(basefunc, skill, location, source)
  if skill.attack_counter == 1 then
    if ed.run_with_scene then
      ed.scene:playEffectOnScene("eff_point_Crystal_ult.cha", {400, -30}, {1, 1}, nil, 0)
    end
  else
    local caster = skill.caster
    for unit in ed.engine:foreachAliveUnit(ed.emCampBoth) do
      skill.target = unit
      basefunc(skill, location, source)
    end
  end
end

function Crystal.skillult_takeEffectOn(basefunc, skill, target, source, shift)
  local caster = skill.caster
  local target_hploss = Crystal.ult_HPloss_index * target.hp
  if (ed.engine.guildInstance_mode or ed.engine.babelMode or ed.engine.stage_type == "dreamland" or ed.engine.multiarena_mode or ed.engine.chaos_tower_mode or ed.engine.multistage_mode or ed.engine.multistageTeamwork_mode or ed.engine.cupArena_mode or ed.engine.myth_mode or ed.engine.mythBossMode or ed.engine.campBossMode or ed.engine.guildMountBossMode or target.info.ID == 10006 or target.info.ID == 10010 or target.info.ID == 10124 or ed.engine.stage_info["Stage Group"] == 20003 or ed.engine.stage_info["Stage Group"] == 20004 or ed.engine.stage_info["Stage Group"] == 20005) and target_hploss > Crystal.Boss_PVEloss_Percent * skill.level then
    target_hploss = Crystal.Boss_PVEloss_Percent * skill.level
  end
  if target ~= caster then
    target:takeDamage(target_hploss, "Holy", "hp", caster)
  end
  local binfo = ed.lookupDataTable("Buff", nil, Crystal.ult_hprecover_bid)
  local buff = ed.BuffCreate(binfo, target, caster)
  if target.camp == caster.camp then
    buff:setAttribute("HPR", Crystal.ult_selfrecover_index * target_hploss)
  else
    buff:setAttribute("HPR", Crystal.ult_enemyrecover_index * target_hploss)
  end
  target:addBuff(buff, caster)
end

function Crystal.skillult_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  if caster.Crystal_ult_buff_self then
    caster.Crystal_ult_buff_self.timer = 0
  end
  if caster.Crystal_ult_self_invulnerable_buff then
    caster.Crystal_ult_self_invulnerable_buff.timer = 0
  end
end

function Crystal.skillatk2_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  caster:takeDamage((45 - skill.info["Script Arg2"]) * 0.01 * caster.hp, "Holy", "hp", caster)
end

function Crystal.skillatk2_takeEffectOn(basefunc, skill, target, source, shift)
  local caster = skill.caster
  local hp_most_Unit
  local most_hp = 0
  for unit in ed.engine:foreachAliveUnit(caster.foecamp) do
    if not unit.config.is_summoned then
      local hp = unit.hp
      if most_hp < hp then
        hp_most_Unit = unit
        most_hp = hp
      end
    end
  end
  local target_hploss = Crystal.atk2_transfer_percent * target.hp
  if hp_most_Unit then
    target_hploss = Crystal.atk2_transfer_percent * hp_most_Unit.hp
    if (ed.engine.guildInstance_mode or ed.engine.babelMode or ed.engine.stage_type == "dreamland" or ed.engine.multiarena_mode or ed.engine.chaos_tower_mode or ed.engine.multistage_mode or ed.engine.multistageTeamwork_mode or ed.engine.cupArena_mode or ed.engine.myth_mode or ed.engine.mythBossMode or ed.engine.campBossMode or ed.engine.guildMountBossMode or target.info.ID == 10006 or target.info.ID == 10010 or target.info.ID == 10124 or ed.engine.stage_info["Stage Group"] == 20003 or ed.engine.stage_info["Stage Group"] == 20004 or ed.engine.stage_info["Stage Group"] == 20005) and target_hploss > Crystal.Boss_PVEloss_Percent * skill.level then
      target_hploss = Crystal.Boss_PVEloss_Percent * skill.level
    end
    hp_most_Unit:takeDamage(target_hploss, "Holy", "hp", caster)
    if ed.run_with_scene then
      ed.scene:playEffectOnScene("eff_point_Crystal_atk2_enemy.cha", hp_most_Unit.position, {1, 1}, nil, 1)
    end
  end
  local num = 0
  for unit in ed.engine:foreachAliveUnit(caster.camp) do
    if unit.info["Unit Type"] == "Hero" and unit ~= caster then
      num = num + 1
    end
  end
  local hp_least_Unit
  local least_hp = 9999999
  for unit in ed.engine:foreachAliveUnit(caster.camp) do
    if not unit.config.is_summoned and unit ~= caster then
      local hp = unit.hp
      if least_hp > hp then
        hp_least_Unit = unit
        least_hp = hp
      end
    end
  end
  if hp_least_Unit then
    hp_least_Unit:takeHeal(target_hploss, "hp", caster)
    if ed.run_with_scene then
      ed.scene:playEffectOnScene("eff_point_Crystal_atk2_self.cha", hp_least_Unit.position, {1, 1}, nil, 1)
    end
  end
  caster:takeHeal(target_hploss, "hp", caster)
  if ed.run_with_scene then
    ed.scene:playEffectOnScene("eff_point_Crystal_atk2_self.cha", caster.position, {1, 1}, nil, 1)
  end
end

function Crystal.skillatk3_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  caster:takeDamage((45 - skill.info["Script Arg2"]) * 0.01 * caster.hp, "Holy", "hp", caster)
end

function Crystal.skillatk3_takeEffectOn(basefunc, skill, target, source, shift)
  basefunc(skill, target, source, shift)
  local caster = skill.caster
  local hp_most_Unit
  local most_hp = 0
  for unit in ed.engine:foreachAliveUnit(caster.foecamp) do
    if not unit.config.is_summoned then
      local hp = unit.hp
      if most_hp < hp then
        hp_most_Unit = unit
        most_hp = hp
      end
    end
  end
  if hp_most_Unit and hp_most_Unit.info.ID ~= 151 and hp_most_Unit.info.ID ~= 272 then
    local binfo = ed.lookupDataTable("Buff", nil, Crystal.atk3_bid)
    local buff = ed.BuffCreate(binfo, hp_most_Unit, caster)
    hp_most_Unit:addBuff(buff, caster)
  end
end

function Crystal.onDying(basefunc, hero, killer)
  local skillatk4 = hero.skills.Crystal_atk4
  local hp_least_Unit
  local least_hp = 9999999
  for unit in ed.engine:foreachAliveUnit(hero.camp) do
    if unit.info["Unit Type"] == "Hero" and unit ~= hero then
      local hp = unit.hp
      if least_hp > hp then
        hp_least_Unit = unit
        least_hp = hp
      end
    end
  end
  if hp_least_Unit then
    local binfo = ed.lookupDataTable("Buff", nil, Crystal.atk4_bid_self)
    local buff_self = ed.BuffCreate(binfo, hp_least_Unit, hero)
    hp_least_Unit:addBuff(buff_self, hero)
    hp_least_Unit.attribs.ALLIMU = skillatk4.info["Script Arg2"]
  end
  local hp_most_Unit
  local most_hp = 0
  for unit in ed.engine:foreachAliveUnit(hero.foecamp) do
    if unit.info["Unit Type"] == "Hero" then
      local hp = unit.hp
      if most_hp < hp then
        hp_most_Unit = unit
        most_hp = hp
      end
    end
  end
  if hp_most_Unit then
    local binfo = ed.lookupDataTable("Buff", nil, Crystal.atk4_bid_enemy)
    local buff_enemy = ed.BuffCreate(binfo, hp_most_Unit, hero)
    hp_most_Unit:addBuff(buff_enemy, hero)
    hp_most_Unit.attribs.ALLIMU = -1 * skillatk4.info["Script Arg3"]
    if ed.engine.guildInstance_mode or ed.engine.babelMode or ed.engine.stage_type == "dreamland" or ed.engine.multiarena_mode or ed.engine.chaos_tower_mode or ed.engine.multistage_mode or ed.engine.multistageTeamwork_mode or ed.engine.cupArena_mode or ed.engine.myth_mode or ed.engine.mythBossMode or ed.engine.campBossMode or ed.engine.guildMountBossMode or hp_most_Unit.info.ID == 10006 or hp_most_Unit.info.ID == 10010 or ed.engine.stage_info["Stage Group"] == 20003 or ed.engine.stage_info["Stage Group"] == 20004 or ed.engine.stage_info["Stage Group"] == 20005 then
      hp_most_Unit.attribs.ALLIMU = Crystal.Boss_MU_Percent * hp_most_Unit.attribs.ALLIMU
    end
  end
  basefunc(hero, killer)
end

function Crystal.collectHPchange(basefunc, self, config)
  local unit = config.unit
  local config_origin_hp = config.hp
  if ed.protoAwake(self.proto, 10072) and unit == self and config_origin_hp < self.hp then
    self.if_awake_effect = true
    self.skillawake_hploss = self.hp - config_origin_hp
  end
end

function Crystal.init_hero(hero)
  local skillult = hero.skills.Crystal_ult
  local skillatk2 = hero.skills.Crystal_atk2
  local skillatk3 = hero.skills.Crystal_atk3
  local skillatk4 = hero.skills.Crystal_atk4
  local skillawake = hero.skills.Crystal_awake
  if skillult then
    skillult.start = override(skillult.start, Crystal.skillult_start)
    skillult.takeEffectAt = override(skillult.takeEffectAt, Crystal.skillult_takeEffectAt)
    skillult.takeEffectOn = override(skillult.takeEffectOn, Crystal.skillult_takeEffectOn)
    skillult.finish = override(skillult.finish, Crystal.skillult_finish)
  end
  if skillatk2 then
    skillatk2.start = override(skillatk2.start, Crystal.skillatk2_start)
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, Crystal.skillatk2_takeEffectOn)
  end
  if skillatk3 then
    skillatk3.start = override(skillatk3.start, Crystal.skillatk3_start)
    skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, Crystal.skillatk3_takeEffectOn)
  end
  if skillatk4 then
    hero.onDying = override(hero.onDying, Crystal.onDying)
  end
  if skillawake then
    hero.reset = override(hero.reset, Crystal.reset)
    hero.update = override(hero.update, Crystal.update)
    hero.collectHPchange = override(hero.collectHPchange, Crystal.collectHPchange)
  end
  return hero
end

return Crystal.init_hero
