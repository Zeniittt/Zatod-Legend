module("ed.battlehero", package.seeall)
local ed = ed
Magician = {}
Magician.heroName = "Magician"
Magician.battleEndBuffID = 594
Magician.ultTargetInviBuff = 1034
Magician.magicBoxInviBuffID = 1038
Magician.ultTargetSmallStun = 1040
Magician.magicShaderID = 1035
Magician.ultHPBuffID = 4280
Magician.magicTargetIDs = {
  {
    0.1,
    0.4,
    1
  },
  {
    125,
    111,
    112
  }
}
Magician.mirror_time_box = 5
Magician.MagicBoxPosition = {
  {150, -10},
  {200, 0},
  {300, 10},
  {400, 0},
  {500, -20},
  {600, 0},
  {650, 20}
}
Magician.protect_index = 0.3

function Magician.skillawake_buffOnDamaged(basefunc, buff, damage, damage_type, source)
  local shield = basefunc(buff, damage, damage_type, source)
  if shield == 0 then
    local owner = buff.owner
    owner:removeBuff(buff)
    if owner.actor then
      owner.actor:addEffect("eff_buff_Magician_atk5_impact.cha", 1)
    end
  end
  return 0
end

function Magician.skillawake_buffOnRemoved(basefunc, buff)
  local caster = buff.caster
  local owner = buff.owner
  if buff.timer > 0 and not ed.engine.beingEnd then
    local skill = caster.skills.Magician_atk2_2
    skill.atk2BuffTwice = true
    skill:takeEffectOn(owner, caster)
    skill.atk2BuffTwice = nil
  end
  return basefunc(buff)
end

function Magician.skillawake_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.onRemoved = override(buff.onRemoved, Magician.skillawake_buffOnRemoved)
  buff.onDamaged = override(buff.onDamaged, Magician.skillawake_buffOnDamaged)
  return buff
end

function Magician.skillatk4_power(basefunc, skill, source, target)
  local power, i = basefunc(skill, source, target)
  local attack_counter = skill.attack_counter
  if attack_counter == 3 then
    power = power * 1.3
  end
  return power, i
end

function Magician.battleEnd_onRemoved(basefunc, buff)
  basefunc(buff)
  local hero = buff.owner
  hero.config.is_summoned = true
  hero.config.is_monster = true
  if not hero:isAlive() then
    return
  end
  if do_battle_log then
    btlog("%s died.", hero:display())
  end
  if hero.name == "SuicideGoblinjr" then
    hero.magicFather.position = {
      hero.position[1],
      hero.position[2]
    }
    if hero.magicFather.actor then
      hero.magicFather.actor.position = {
        hero.position[1],
        hero.position[2]
      }
    end
    hero.magicFather:onDying()
    return
  end
  hero.state = ed.emUnitState_Dying
  if hero.current_skill then
    hero.current_skill:interrupt()
  end
  if hero.manually_casting then
    hero.manually_casting = false
    ed.engine:unfreeze()
  end
  local summoner = hero.config.summoner
  local hpPercent = hero.hp / hero.attribs.HP
  local maxhp = hero.magicFather.attribs.HP
  local damage = (hero.startHPPercent - hpPercent) * maxhp
  hero.magicFather.notPopupBattleInfo = true
  hero.magicFather:takeDamage(damage / summoner.attribs.PDM, "Holy", "hp", summoner, 1, 0)
  hero.magicFather.notPopupBattleInfo = nil
  hero.can_cast_manual = false
  hero.walk_v = {0, 0}
  hero.hp = 0
  hero.mp = 0
  if not hero.isDeathWithEffect then
    hero:setAction("Death", false, true)
  else
    hero.action_name = nil
    hero.action_loop = false
    hero.action_duration = 0
    hero.action_elapsed = 0
    local origin = {
      hero.position[1],
      hero.position[2]
    }
    if ed.run_with_scene then
      local effect_name = "eff_point_mirror_die.cha"
      if effect_name then
        ed.scene:playEffectOnScene(effect_name, origin, {
          hero.direction * 0.85,
          0.85
        }, nil, 1)
      end
    end
  end
  local sureKMPR = ed.rand() < hero.attribs.KMPR / 100
  ed.engine:onUnitDie(hero, hero.killer, sureKMPR)
  hero:applyAuraSkill()
  if hero.actor then
    hero.actor:onUnitDeath()
  end
end

function Magician.newHero_update(basefunc, unit, dt)
  if unit.is_superawake == 0 then
    unit.mDuration_Magician = unit.mDuration_Magician - dt
    if 0 >= unit.mDuration_Magician and unit:isAlive() then
      if unit.current_skill and unit.current_skill.info["Skill Name"] == "SuicideGoblinjr_atk" then
        basefunc(unit, dt)
        unit.magicFather.position = {
          unit.position[1],
          unit.position[2]
        }
        if unit.magicFather.actor then
          unit.magicFather.actor.position = {
            unit.position[1],
            unit.position[2]
          }
        end
        unit:onDying()
        return
      end
      local summoner = unit.config.summoner
      local hpPercent = unit.hp / unit.attribs.HP
      local maxhp = unit.magicFather.attribs.HP
      local damage = (unit.startHPPercent - hpPercent) * maxhp
      unit.magicFather.notPopupBattleInfo = true
      unit.magicFather:takeDamage(damage / summoner.attribs.PDM, "Holy", "hp", summoner, 1, 0)
      unit.magicFather.notPopupBattleInfo = nil
      unit.timeOverDie = true
      unit:die()
      unit.timeOverDie = nil
      unit.mDuration_Magician = 9999
    else
      basefunc(unit, dt)
    end
  else
    local summoner = unit.config.summoner
    unit.hpPercent_2 = unit.hp / unit.attribs.HP
    local maxhp = unit.magicFather.attribs.HP
    local damage = (unit.startHPPercent - unit.hpPercent_2) * maxhp
    local monster = unit
    for unit in ed.engine:foreachAliveUnit(monster.foecamp) do
      if unit.name == "Magician" then
        if monster.hpPercent_1 > monster.hpPercent_2 then
          unit.general_percent = monster.hpPercent_1 - monster.hpPercent_2
        end
        break
      end
    end
    unit.hpPercent_1 = unit.hpPercent_2
    unit.mDuration_Magician = unit.mDuration_Magician - dt
    if 0 >= unit.mDuration_Magician and unit:isAlive() then
      if unit.current_skill and unit.current_skill.info["Skill Name"] == "SuicideGoblinjr_atk" then
        basefunc(unit, dt)
        unit.magicFather.position = {
          unit.position[1],
          unit.position[2]
        }
        if unit.magicFather.actor then
          unit.magicFather.actor.position = {
            unit.position[1],
            unit.position[2]
          }
        end
        unit:onDying()
        return
      end
      unit.magicFather.notPopupBattleInfo = true
      unit.magicFather:takeDamage(damage / summoner.attribs.PDM, "Holy", "hp", summoner, 1, 0)
      unit.magicFather.notPopupBattleInfo = nil
      unit.timeOverDie = true
      unit:die()
      unit.timeOverDie = nil
      unit.mDuration_Magician = 9999
      unit.general_percent = 0
    else
      basefunc(unit, dt)
    end
  end
end

function Magician.newHero_die(basefunc, unit, killer)
  unit.general_percent = 0
  unit.config.is_summoned = false
  unit.config.is_monster = false
  basefunc(unit, killer)
  if unit.name == "SuicideGoblinjr" then
    unit.magicFather.position = {
      unit.position[1],
      unit.position[2]
    }
    if unit.magicFather.actor then
      unit.magicFather.actor.position = {
        unit.position[1],
        unit.position[2]
      }
    end
    unit.magicFather:onDying()
    return
  end
  unit.magicFather.position = {
    unit.position[1],
    unit.position[2]
  }
  if unit.magicFather.actor then
    unit.magicFather.actor.position = {
      unit.position[1],
      unit.position[2]
    }
  end
  if not unit.timeOverDie then
    unit.mDuration_Magician = 9999
    local summoner = unit.config.summoner
    for i, buff in ipairs(unit.magicFather.buff_list) do
      if buff.info.ID == Magician.ultTargetInviBuff then
        buff.timer = 0
      end
    end
  end
end

function Magician.skillult_onAttackFrame(basefunc, self)
  if self.caster.manually_casting and self.attack_counter == 1 then
    ed.engine:unfreeze()
    self.caster.manually_casting = false
  end
  self.attack_counter = self.attack_counter + 1
  if self.target == nil or not self.target:isAlive() then
    self:selectTarget(nil)
  end
  if not self.target then
    return
  end
  if not self.position1 then
    self.position1 = {
      self.target.position[1],
      self.target.position[2]
    }
  end
  local info = self.info
  local caster = self.caster
  local ttype = info["Track Type"]
  if ttype == "projectile" then
    local projectile = self:createProjectile()
    ed.engine:addProjectile(projectile)
  elseif ttype == "chain" then
    local chain = self:createChain()
    ed.engine:addChain(chain)
  elseif ttype == nil then
    self:takeEffectAt(self.position1)
  else
    EDDebug("Unkonwn Track Type: '" .. ttype .. "'")
  end
  caster:setMP(caster.mp + info["Gain MP"] * ed.engine.mp_bonus)
  if info["Move Forward"] ~= 0 then
    caster.position[1] = caster.position[1] + info["Move Forward"] * caster.direction
  end
end

function Magician.skillult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.onRemoved = override(buff.onRemoved, Magician.skillultbuff_onRemoved)
  return buff
end

function Magician.skillultbuff_onRemoved(basefunc, buff)
  basefunc(buff)
  local caster = buff.caster
  local owner = buff.owner
  if owner and owner:isAlive() and caster and caster:isAlive() then
    owner:takeDamage(math.min(owner.attribs.HP, caster.attribs.HP) * 2, "Holy", "hp", caster)
  end
end

function Magician.skillult_takeEffectOn(basefunc, skill, target, source, shift)
  local caster = skill.caster
  if skill.attack_counter == 2 then
    if target.config.is_boss then
      return
    end
    basefunc(skill, target, source, shift)
    local hasBuff = false
    for i, tbuff in ipairs(target.buff_list) do
      if tbuff.info.ID == Magician.ultTargetInviBuff and tbuff.caster == caster then
        hasBuff = true
      end
    end
    if not hasBuff then
      target = nil
      return
    end
    for i, tbuff in ipairs(target.buff_list) do
      if tbuff.info.ID == 382 or tbuff.info.ID == 383 then
        tbuff.timer = 0
      end
    end
    if target then
      local level = target.level
      local stars = target.stars
      local skillevel = {
        skill.level,
        skill.level,
        skill.level,
        skill.level,
        skill.level,
        skill.level,
        skill.level,
        skill.level,
        skill.level,
        skill.level,
        skill.level
      }
      local rank = target.rank
      local targetHPPercent = target.hp / target.attribs.HP
      local targetID = 111
      local randNum = ed.rand()
      for i = 1, #Magician.magicTargetIDs[1] do
        if randNum < Magician.magicTargetIDs[1][i] then
          targetID = Magician.magicTargetIDs[2][i]
          break
        end
      end
      if targetID == 125 and ed.engine.guildInstance_mode then
        targetID = 112
      end
      local proto = {
        _tid = targetID,
        _level = level,
        _stars = stars,
        _skill_levels = skillevel,
        _rank = rank
      }
      local config = {
        is_monster = false,
        estimate_rank = true,
        hp_mod = target.config.hp_mod * 1.5 or 1.5,
        dps_mod = target.config.dps_mod * 2 or 2
      }
      if proto._tid == 125 then
        caster.ult_camp = target.foecamp
      else
        caster.ult_camp = target.camp
      end
      local newHero = ed.UnitCreate(proto, caster.ult_camp, config)
      newHero.mDuration_Magician = skill.info["Script Arg2"]
      newHero.update = override(newHero.update, Magician.newHero_update)
      newHero:setDeathWithEffectOrNot(true)
      local summonlocation = {
        target.position[1],
        target.position[2]
      }
      newHero.direction = target.direction
      ed.engine:summonUnit(newHero, summonlocation, caster, "Idle")
      newHero:reset()
      newHero.magicFather = target
      newHero.die = override(newHero.die, Magician.newHero_die)
      local binfo = ed.lookupDataTable("Buff", nil, Magician.magicShaderID)
      local buff = newHero:addBuff(binfo, caster)
      if proto._tid == 125 then
        local binfo = ed.lookupDataTable("Buff", nil, Magician.magicBoxInviBuffID)
        local buff = newHero:addBuff(binfo, caster)
      else
        local bbinfo = ed.lookupDataTable("Buff", nil, Magician.ultHPBuffID)
        local bbuff = ed.BuffCreate(bbinfo, newHero, caster)
        bbuff:setAttribute("HP", math.max(0, target.attribs.HP * 0.8 - newHero.attribs.HP))
        newHero:addBuff(bbuff, caster)
      end
      newHero.hp = newHero.attribs.HP * targetHPPercent
      newHero.startHPPercent = targetHPPercent
      local binfo = ed.lookupDataTable("Buff", nil, Magician.ultTargetSmallStun)
      local buff = newHero:addBuff(binfo, caster)
      target.position[2] = target.position[2] + 1
      newHero.config.is_summoned = false
      newHero.NotStolenByRubick = true
      local bid2 = Magician.battleEndBuffID
      local binfo2 = ed.lookupDataTable("Buff", nil, bid2)
      local buff3 = newHero:addBuff(binfo2, caster)
      buff3.onRemoved = override(buff3.onRemoved, Magician.battleEnd_onRemoved)
      newHero.hpPercent_1 = 1
      newHero.hpPercent_2 = 1
      local skill_sawake = caster.skills.Magician_sawake
      if skill_sawake then
        local nearestUnit
        local nearestDistance = math.huge
        for unit in ed.engine:foreachAliveUnit(caster.camp) do
          if not unit.buff_effects.untargetable and unit.info["Unit Type"] == "Hero" then
            local d = ed.edpDistanceSQ(unit.position, caster.position)
            if nearestDistance > d and unit ~= caster then
              nearestUnit = unit
              nearestDistance = d
            end
          end
        end
        if nearestUnit then
          nearestUnit:addBuff(skill_sawake:createBuff(nearestUnit))
        end
      end
    end
  elseif skill.attack_counter == 1 then
    target:unfreezeActor()
    if ed.run_with_scene then
      ed.scene:playEffectOnScene("eff_impact_Magician_ult.cha", {
        target.position[1],
        target.position[2]
      }, {
        target.direction,
        1
      }, nil, 1)
    end
    if ed.run_with_scene then
      ed.scene:playEffectOnScene("eff_impact_Magician_ult2.cha", {
        target.position[1],
        target.position[2] + 1
      }, {
        target.direction,
        1
      }, nil, 0)
    end
  end
end

function Magician.skillsawake_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.update = override(buff.update, Magician.skillsawake_buff_update)
  return buff
end

function Magician.skillsawake_buff_update(basefunc, buff, dt)
  local mp_gain = buff.owner.attribs.MP * buff.caster.general_percent
  local skill = buff.caster.skills.Magician_sawake
  mp_gain = mp_gain * (skill.level / 100)
  if buff.caster.general_percent > 0 and buff.caster.general_percent ~= 1 then
    buff.owner:takeHeal(mp_gain, "mp", buff.owner)
    buff.caster.general_percent = 0
  end
  basefunc(buff, dt)
end

function Magician.MagicBox_die(basefunc, self, killer)
  if self.MagicBox_Pigeon then
    basefunc(self, killer)
  else
    if not self:isAlive() then
      return
    end
    if do_battle_log then
      btlog("%s died.", self:display())
    end
    self.state = ed.emUnitState_Dying
    self.killer = killer
    if self.current_skill then
      self.current_skill:interrupt()
    end
    if self.manually_casting then
      self.manually_casting = false
      ed.engine:unfreeze()
    end
    self:removeSignedBuffer()
    self.can_cast_manual = false
    self.walk_v = {0, 0}
    self.hp = 0
    self.mp = 0
    if not self.isDeathWithEffect then
      self:setAction("atk2", false, true)
    else
      self.action_name = nil
      self.action_loop = false
      self.action_duration = 0
      self.action_elapsed = 0
      local origin = {
        self.position[1],
        self.position[2]
      }
      if ed.run_with_scene then
        local effect_name = "eff_point_mirror_die.cha"
        if effect_name then
          ed.scene:playEffectOnScene(effect_name, origin, {
            self.direction * 0.85,
            0.85
          }, nil, 1)
        end
      end
    end
    ed.engine:onUnitDie(self, killer)
    if 0 < #self.aura_skill_list then
      for unit in ed.engine:foreachAliveUnit(self.camp) do
        unit:rebuild()
      end
    end
    if 0 < #self.effect_enemy_aura_skill_list then
      for unit in ed.engine:foreachAliveUnit(-self.camp) do
        unit:rebuild()
      end
    end
    if self.actor then
      self.actor:onUnitDeath()
    end
  end
end

function Magician.skillatk22_takeEffectOn(basefunc, skill, target, source, shift)
  basefunc(skill, target, source, shift)
  if source and not skill.atk2BuffTwice then
    skill.atk2BuffTwice = true
    basefunc(skill, target, source, shift)
    skill.atk2BuffTwice = nil
  end
end

function Magician.magicBox_finish(basefunc, skill)
  basefunc(skill)
  skill.caster:die()
end

function Magician.magicBox_onAttackFrame(basefunc, skill)
  local hero = skill.caster
  local summoner = hero.config.summoner
  local skillatk2 = summoner.skills[Magician.heroName .. "_atk2_2"]
  local target = skillatk2:selectTarget(nil)
  if target then
    local projectile = skillatk2:createProjectile()
    projectile.position = {
      hero.position[1],
      hero.position[2]
    }
    projectile.height = 25
    projectile:enableTrack(target)
    ed.engine:addProjectile(projectile)
  end
end

function Magician.MagicBox_update(basefunc, self, dt)
  if not self.MagicBox_Pigeon then
    if self.state == ed.emUnitState_Dying then
      if not self.dyingTimer then
        self.dyingTimer = 0.3
      end
      self.dyingTimer = self.dyingTimer - dt
      if self.dyingTimer <= 0 then
        self.dyingTimer = 99999
        local skillatk = self.config.summoner.skills.Magician_atk2
        skillatk:takeEffectAt(self.position)
      end
    else
      self.mDuration_MagicBox = self.mDuration_MagicBox - dt
      if 0 >= self.mDuration_MagicBox then
        self.mDuration_MagicBox = 99999
        local binfo = ed.lookupDataTable("Buff", nil, Magician.magicBoxInviBuffID)
        local buff = self:addBuff(binfo, self)
        local skill = self.skills.MagicBox_atk
        skill.cd_remaining = 0
        skill.finish = override(skill.finish, Magician.magicBox_finish)
        skill.onAttackFrame = override(skill.onAttackFrame, Magician.magicBox_onAttackFrame)
        self.MagicBox_Pigeon = true
      end
      self.dyingTimer = nil
    end
  end
  basefunc(self, dt)
end

function Magician.MagicBox_addBuff(basefunc, unit, buff_Or_Binfo, caster)
  local buff = basefunc(unit, buff_Or_Binfo, caster)
  if buff then
    local effectId = buff.effect_id
    if effectId and unit.actor then
      local effect = unit.actor.puppet:getChildByTag(effectId)
      if effect then
        effect:setVisible(false)
      end
    end
  end
  return buff
end

function Magician.skillatk2_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local proto = {
    _tid = 234,
    _level = skill.level or 1,
    _stars = caster.stars,
    _rank = caster.rank,
    _fashion = {
      _current_fashion = caster.fashion_id
    },
    _skill_levels = {
      [1] = skill.level or 1
    }
  }
  local config = {
    is_monster = true,
    estimate_rank = true,
    hp_mod = caster.config.hp_mod * 0.2,
    dps_mod = caster.config.dps_mod or 1
  }
  local MagicBox = ed.UnitCreate(proto, caster.camp, config)
  MagicBox.direction = caster.direction
  MagicBox.mDuration_MagicBox = Magician.mirror_time_box
  local ran = ed.rand()
  local index = math.floor(ran * #Magician.MagicBoxPosition) + 1
  local location = {
    Magician.MagicBoxPosition[index][1] * ed.engine.stage_rect.maxX / 800,
    Magician.MagicBoxPosition[index][2]
  }
  local puppet = MagicBox.info["Puppet Switch"]
  if puppet and ed.protoSuperAwake(caster.proto, 10036) then
    MagicBox.puppet_stack = {puppet}
  end
  ed.engine:summonUnit(MagicBox, location, caster)
  table.insert(caster.Magician_box_list, MagicBox)
  MagicBox.update = override(MagicBox.update, Magician.MagicBox_update)
  MagicBox.die = override(MagicBox.die, Magician.MagicBox_die)
  if ed.run_with_scene then
    MagicBox.addBuff = override(MagicBox.addBuff, Magician.MagicBox_addBuff)
  end
  caster:setMP(caster.mp + skill.info["Gain MP"] * ed.engine.mp_bonus)
end

function Magician.hero_die(basefunc, hero, killer)
  for i, unit in ipairs(hero.Magician_box_list) do
    if unit and unit:isAlive() then
      unit:die()
    end
  end
  basefunc(hero, killer)
end

function Magician.skillatk6_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  caster.position[1] = ed.engine.stage_rect.maxX / 2 - (ed.engine.stage_rect.maxX / 2 - 100) * caster:getInitDir()
  caster.direction = caster:getInitDir()
end

function Magician.skillatk6_onAttackFrame(basefunc, skill)
  skill.caster.walk_v = {0, 0}
  basefunc(skill)
end

function Magician.reset(basefunc, hero)
  basefunc(hero)
  hero.general_percent = 0
  hero.temp_percent = 0
  hero.skillsawake_buff_index = 0
  hero.Min_distance = 0
  hero.temp_percent = 0
  if ed.protoSuperAwake(hero.proto, 10036) then
    hero.is_superawake = 1
  else
    hero.is_superawake = 0
  end
end

function Magician.init_hero(hero)
  hero.Magician_box_list = {}
  hero.die = override(hero.die, Magician.hero_die)
  hero.reset = override(hero.reset, Magician.reset)
  local skillult = hero.skills[Magician.heroName .. "_ult"]
  if skillult then
    skillult.takeEffectOn = override(skillult.takeEffectOn, Magician.skillult_takeEffectOn)
    skillult.onAttackFrame = override(skillult.onAttackFrame, Magician.skillult_onAttackFrame)
    skillult.createBuff = override(skillult.createBuff, Magician.skillult_createBuff)
  end
  local skillatk2 = hero.skills[Magician.heroName .. "_atk2"]
  local skillatk22 = hero.skills[Magician.heroName .. "_atk2_2"]
  if skillatk2 then
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, Magician.skillatk2_onAttackFrame)
    skillatk22.takeEffectOn = override(skillatk22.takeEffectOn, Magician.skillatk22_takeEffectOn)
  end
  local skillatk4 = hero.skills[Magician.heroName .. "_atk4"]
  if skillatk4 then
    skillatk4.power = override(skillatk4.power, Magician.skillatk4_power)
  end
  local skillatk6 = hero.skills[Magician.heroName .. "_atk6"]
  if skillatk6 then
    skillatk6.start = override(skillatk6.start, Magician.skillatk6_start)
    skillatk6.onAttackFrame = override(skillatk6.onAttackFrame, Magician.skillatk6_onAttackFrame)
  end
  local skillawake = hero.skills[Magician.heroName .. "_awake"]
  if skillawake then
    skillawake.createBuff = override(skillawake.createBuff, Magician.skillawake_createBuff)
  end
  local skillsawake = hero.skills[Magician.heroName .. "_sawake"]
  if skillsawake then
    skillsawake.createBuff = override(skillsawake.createBuff, Magician.skillsawake_createBuff)
  end
  return hero
end

return Magician.init_hero
