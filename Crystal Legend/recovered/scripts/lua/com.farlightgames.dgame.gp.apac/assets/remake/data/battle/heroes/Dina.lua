module("ed.battlehero", package.seeall)
local ed = ed
Dina = {}
Dina.tornado_v = 40
Dina.tornado_live_time = 15
Dina.tornado_r = 65
Dina.first_v = 2.5
Dina.mirror_time = 15
Dina.fashion_id_1 = 991

function Dina.tornado_update(basefunc, hero, dt)
  local Dina_tornado_v = Dina.tornado_v
  if hero.first_count >= 0 and hero.first_count <= 8 then
    Dina_tornado_v = Dina.tornado_v * Dina.first_v
  end
  if not hero.walk_count then
    hero.walk_count = 1
  end
  hero.walk_count = hero.walk_count + 1
  if hero.walk_count >= 1 then
    local angle = hero.last_angle + (ed.rand() * 10 - 5)
    if hero.position[1] >= 670 then
      if 0 <= angle then
        angle = angle + 15
      else
        angle = angle - 15
      end
    elseif hero.position[1] <= 130 then
      if 0 <= angle then
        angle = angle - 15
      else
        angle = angle + 15
      end
    elseif hero.position[2] >= 50 then
      if angle <= 90 then
        angle = angle - 15
      else
        angle = angle + 15
      end
    elseif hero.position[2] <= -50 then
      if angle <= -90 then
        angle = angle - 15
      else
        angle = angle + 15
      end
    end
    local vx = Dina_tornado_v * math.cos(math.rad(angle))
    local vy = Dina_tornado_v * math.sin(math.rad(angle))
    hero.walk_v = {vx, vy}
    hero.walk_count = 0
    hero.last_angle = angle
  end
  hero.first_count = hero.first_count + 1
  basefunc(hero, dt)
  hero.live_time = hero.live_time - dt
  if 0 >= hero.live_time then
    hero:die()
  end
  if hero:isAlive() then
    local skillult2 = hero.skills.tornado_atk2
    for unit in ed.engine:foreachAliveUnit(hero.foecamp) do
      local unitdistance = ed.edpDistanceSQ(unit.position, hero.position)
      if unitdistance <= Dina.tornado_r * Dina.tornado_r then
        local havebuff
        for i, tbuff in ipairs(unit.buff_list) do
          if tbuff.info.ID == 10009903 then
            havebuff = true
          end
        end
        if not havebuff then
          skillult2:takeEffectOn(unit, hero)
          if unit.height >= 200 then
            local bid = 10009903
            local binfo = ed.lookupDataTable("Buff", nil, bid)
            local buff = unit:addBuff(binfo, hero)
          end
        end
      end
    end
  end
end

function Dina.skillult_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local skillult = caster.skills.Dina_ult
  local dir = caster:getInitDir()
  local summonlocation = {
    caster.position[1] + dir * 50,
    caster.position[2]
  }
  local caster = skill.caster
  local dir = caster:getInitDir()
  local skillevel = {
    skillult.level,
    skillult.level,
    skillult.level
  }
  local proto = {
    _tid = 224,
    _level = skillult.level or 1,
    _skill_levels = skillevel,
    _stars = caster.stars,
    _rank = caster.rank
  }
  local config = {
    is_monster = true,
    estimate_rank = true,
    hp_mod = caster.camp == ed.emCampEnemy and ed.engine.guildInstance_mode and 2 or caster.config.hp_mod,
    dps_mod = caster.config.dps_mod or 1,
    summoner = caster
  }
  local Dina_tornado = ed.UnitCreate(proto, caster.camp, config)
  Dina_tornado.direction = caster.direction
  Dina_tornado.walk_count = 0
  Dina_tornado.first_count = 0
  Dina_tornado.last_angle = 90 - Dina_tornado.direction * 90
  Dina_tornado.live_time = Dina.tornado_live_time
  Dina_tornado.update = override(Dina_tornado.update, Dina.tornado_update)
  local bid1 = 10009901
  local binfo1 = ed.lookupDataTable("Buff", nil, bid1)
  local buff1 = ed.BuffCreate(binfo1, Dina_tornado, Dina_tornado)
  buff1:setAttribute("AP", caster.attribs.AP)
  buff1:setAttribute("APDP", caster.attribs.APDP)
  buff1:setAttribute("MCRIT", caster.attribs.MCRIT)
  buff1:setAttribute("MRI", caster.attribs.MRI)
  Dina_tornado:addBuff(buff1, Dina_tornado)
  local fashionId = caster.fashion_id
  if fashionId and fashionId == Dina.fashion_id_1 then
    Dina_tornado:pushPuppet("Dinatornado_fashion_1.cha")
  end
  ed.engine:summonUnit(Dina_tornado, summonlocation, caster)
  caster.Dina_tornado = Dina_tornado
end

function Dina.skillatk3_createBuff(basefunc, skill, target)
  local caster = skill.caster
  if Dina.fashion_id_1 and Dina.fashion_id_1 == caster.fashion_id then
    skill.info.buff_info["Impact Effect"] = "eff_impact_Dina_fashion_1_atk2.cha"
  end
  local buff = basefunc(skill, target)
  buff.onDamaged = override(buff.onDamaged, Dina.skillatk3_buffonDamaged)
  local maxhp = 0
  for unit in ed.engine:foreachAliveUnit(caster.camp) do
    if unit ~= target and not unit.config.is_summoned and maxhp <= unit.hp then
      buff.maxhpunit = unit
      maxhp = unit.hp
    end
  end
  if Dina.fashion_id_1 and Dina.fashion_id_1 == caster.fashion_id then
    buff:setAttribute("Effect", "eff_buff_Dina_fashion_1_atk2_1.cha")
    buff.info["Impact Effect"] = "eff_impact_Dina_fashion_1_atk2.cha"
  end
  if buff.maxhpunit then
    local bid = 10009906
    local binfo1 = ed.lookupDataTable("Buff", nil, bid)
    local buff1 = ed.BuffCreate(binfo1, buff.maxhpunit, caster)
    buff1.onRemoved = override(buff1.onRemoved, Dina.atk3buff1_onRemoved)
    if Dina.fashion_id_1 and Dina.fashion_id_1 == caster.fashion_id then
      buff1:setAttribute("Effect", "eff_buff_Dina_fashion_1_atk2_2.cha")
    end
    buff.maxhpunit:addBuff(buff1, caster)
  end
  return buff
end

function Dina.skillatk3_canCastWithTarget(basefunc, skill, target)
  local enemycount = 0
  local caster = skill.caster
  for unit in ed.engine:foreachAliveUnit(caster.camp) do
    if unit and not unit.config.is_summoned then
      enemycount = enemycount + 1
    end
  end
  if enemycount <= 1 then
    return false
  else
    return basefunc(skill, target)
  end
end

function Dina.skillatk3_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  for unit in ed.engine:foreachAliveUnit(caster.camp) do
    for i, tbuff in ipairs(unit.buff_list) do
      if tbuff.info.ID == 10009905 or tbuff.info.ID == 10009906 then
        tbuff.timer = -1
      end
    end
  end
end

function Dina.atk3buff1_onRemoved(basefunc, buff)
  basefunc(buff)
  local owner = buff.owner
  for unit in ed.engine:foreachAliveUnit(owner.camp) do
    for _, tbuff in ipairs(unit.buff_list) do
      if tbuff.info.ID == 10009905 then
        tbuff.timer = -1
      end
    end
  end
end

function Dina.skillatk3_buffonDamaged(basefunc, buff, damage, damage_type, source, skill, transferred)
  local owner = buff.owner
  local caster = buff.caster
  local atk3 = caster.skills.Dina_atk3
  local reduceratio = atk3.info["Script Arg2"] / 100
  if atk3.evo_rank and atk3.evo_rank >= 1 then
    reduceratio = reduceratio + atk3.evo_rank1["Script Arg1"] / 100
  end
  if atk3.evo_rank and atk3.evo_rank >= 2 then
    reduceratio = reduceratio + atk3.evo_rank2["Script Arg1"] / 100
  end
  if source and buff.maxhpunit and buff.maxhpunit:isAlive() and not transferred then
    source.dinareducedmg = damage * reduceratio
    damage = damage - source.dinareducedmg
    if atk3.evo_rank and atk3.evo_rank >= 3 then
      source.dinareducedmg = source.dinareducedmg * atk3.evo_rank3["Script Arg1"] / 100
    end
    buff.maxhpunit:takeDamage(source.dinareducedmg / source.attribs.PDM, "Holy", "hp", source, 1, 1, true)
    if ed.run_with_scene then
      local effect_name = "eff_impact_Dina_atk2.cha"
      if Dina.fashion_id_1 and Dina.fashion_id_1 == caster.fashion_id then
        effect_name = "eff_impact_Dina_fashion_1_atk2.cha"
      end
      if effect_name then
        ed.scene:playEffectOnScene(effect_name, buff.maxhpunit.position, nil, nil, 1)
      end
    end
  end
  return damage
end

function Dina.skillatk4_buffonDamaged(basefunc, buff, damage, damage_type, source)
  local owner = buff.owner
  local caster = buff.caster
  local atk4 = caster.skills.Dina_atk4
  local maximmune = math.min(owner.attribs.HP * buff.hp_percent, caster.attribs.HP)
  if buff.shield and damage_type == "AD" then
    if damage <= maximmune then
      if owner.actor then
        local color = owner.camp == ed.emCampPlayer and "blue" or "red"
        ed.PopupCreate("immune", color, owner.actor, nil, "text")
      end
      return 0
    else
      buff.timer = 0
      return 0
    end
  end
  return damage
end

function Dina.skillatk4_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local originfo = buff.info
  local caster = buff.caster
  buff.cantreduce = true
  buff.hp_percent = skill.info["Script Arg2"] / 100
  if Dina.fashion_id_1 and Dina.fashion_id_1 == caster.fashion_id then
    buff:setAttribute("Effect", "eff_buff_Dina_fashion_1_atk4.cha")
  end
  if skill.evo_rank and skill.evo_rank >= 1 then
    buff.hp_percent = buff.hp_percent + skill.evo_rank1["Script Arg1"] / 100
  end
  if skill.evo_rank and skill.evo_rank >= 2 then
    buff.hp_percent = buff.hp_percent + skill.evo_rank2["Script Arg1"] / 100
  end
  buff.onDamaged = override(buff.onDamaged, Dina.skillatk4_buffonDamaged)
  if skill.evo_rank and skill.evo_rank >= 3 then
    buff.timer = buff.timer + skill.evo_rank3["Script Arg1"]
  end
  return buff
end

function Dina.skillatk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  owner.dinaatk2lfs = true
  buff.onRemoved = override(buff.onRemoved, Dina.skillatk2_buffonRemoved)
  if skill.evo_rank and skill.evo_rank >= 1 then
    buff:setAttribute("AP.a", skill.evo_rank1["Script Arg1"])
  end
  if skill.evo_rank and skill.evo_rank >= 3 then
    buff:setAttribute("ARM", skill.evo_rank3["Script Arg1"])
  end
  return buff
end

function Dina.skillatk2_buffonRemoved(basefunc, buff)
  basefunc(buff)
  local owner = buff.owner
  owner.dinaatk2lfs = false
end

function Dina.atk2_collectSkillHit(basefunc, self, caster, skill, target)
  local atk2 = self.skills.Dina_atk2
  local lfsratio = atk2.info["Script Arg2"]
  if atk2.evo_rank and atk2.evo_rank >= 2 then
    lfsratio = atk2.evo_rank2["Script Arg1"]
  end
  if caster.dinaatk2lfs == true then
    if skill.info["Damage Type"] == "AP" and target.camp == -caster.camp then
      caster:takeHeal(lfsratio * self.attribs.AP, "hp", caster)
    end
  elseif caster.config.is_summoned == true and caster.config.summoner and caster.config.summoner:isAlive() and caster.config.summoner.dinaatk2lfs == true and skill.info["Damage Type"] == "AP" and target.camp == -caster.camp then
    caster.config.summoner:takeHeal(lfsratio * self.attribs.AP, "hp", caster.config.summoner)
  end
end

function Dina.hero_die(basefunc, hero, killer)
  basefunc(hero, killer)
  for unit in ed.engine:foreachAliveUnit(hero.camp) do
    if unit.info.ID == 224 and unit.config.summoner == hero then
      unit:die()
    end
  end
end

function Dina.init_hero(hero)
  local skillult = hero.skills.Dina_ult
  local skillatk = hero.skills.Dina_atk
  local skillatk2 = hero.skills.Dina_atk2
  local skillatk3 = hero.skills.Dina_atk3
  local skillatk4 = hero.skills.Dina_atk4
  if skillatk and Dina.fashion_id_1 and Dina.fashion_id_1 == hero.fashion_id then
    local originfo1 = skillatk.info
    skillatk.info = ed.wraptable(originfo1, {
      ["Tile Art"] = "eff_tile_Dina_fashion_1_atk.cha"
    })
  end
  if skillatk2 then
    skillatk2.createBuff = override(skillatk2.createBuff, Dina.skillatk2_createBuff)
    hero.collectSkillHit = override(hero.collectSkillHit, Dina.atk2_collectSkillHit)
  end
  if skillult then
    skillult.onAttackFrame = override(skillult.onAttackFrame, Dina.skillult_onAttackFrame)
  end
  if skillatk3 then
    skillatk3.createBuff = override(skillatk3.createBuff, Dina.skillatk3_createBuff)
    skillatk3.canCastWithTarget = override(skillatk3.canCastWithTarget, Dina.skillatk3_canCastWithTarget)
    skillatk3.start = override(skillatk3.start, Dina.skillatk3_start)
  end
  if skillatk4 then
    skillatk4.createBuff = override(skillatk4.createBuff, Dina.skillatk4_createBuff)
  end
  hero.die = override(hero.die, Dina.hero_die)
  return hero
end

return Dina.init_hero
