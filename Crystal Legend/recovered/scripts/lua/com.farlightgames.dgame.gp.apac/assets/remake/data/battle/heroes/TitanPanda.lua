module("ed.battlehero", package.seeall)
local ed = ed
TitanPanda = {}
TitanPanda.weakBid = 1582
TitanPanda.selfBid = 1583
TitanPanda.stunBid = 1584
TitanPanda.ult_stun_bid = 1585

function TitanPanda.skillatk2_Start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  if not caster.atk2_originfo then
    caster.atk2_originfo = skill.info
  else
    skill.info = caster.atk2_originfo
  end
  skill.origTarget = target
  skill.plus_count = 0
end

function TitanPanda.skillatk2_onAttackFrame(basefunc, skill)
  local origTarget = skill.origTarget
  local originfo = skill.info
  local caster = skill.caster
  local Plus_Ratio = skill.info["Plus Ratio"]
  local Plus_max = 1
  if caster:isAlive() then
    local minunit
    local mindis = 9999
    for unit in ed.engine:foreachAliveUnit(caster.foecamp) do
      if not unit.buff_effects.untargetable then
        local unitDistance = ed.edpDistanceSQ(unit.position, caster.position) ^ 0.5
        if mindis > unitDistance then
          mindis = unitDistance
          minunit = unit
          skill.target = minunit
        end
      end
    end
  end
  local newTarget = skill.target
  if newTarget == nil then
    caster.current_skill:interrupt()
    skill.info = originfo
    return
  end
  if caster:isAlive() and origTarget ~= newTarget then
    skill.origTarget = newTarget
    skill.plus_count = skill.plus_count + 0.05
    skill.info = ed.wraptable(originfo, {
      ["Plus Ratio"] = math.min(Plus_Ratio + skill.plus_count, Plus_max)
    })
  end
  basefunc(skill)
  if skill.attack_counter == 9 then
    skill.info = originfo
  end
end

function TitanPanda.skillatk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local des = ed.edpDistanceSQ(target.position, caster.position) ^ 0.5
  local minDes = 150
  local maxDes = 800
  local maxRatio = 5
  local ratio = 1
  if des <= minDes then
    ratio = maxRatio
  elseif des >= maxDes then
    ratio = 1
  else
    ratio = 1 + (maxRatio - 1) * (1 - (des - minDes) / (maxDes - minDes))
  end
  buff:setAttribute("MSPD", -30 * ratio)
  buff:setAttribute("HAST", -30 * ratio)
  return buff
end

function TitanPanda.skillatk3_Start(basefunc, skill, target)
  local caster = skill.caster
  basefunc(skill, target)
  if not caster.atk3_originfo then
    caster.atk3_originfo = skill.info
  else
    skill.info = caster.atk3_originfo
  end
end

function TitanPanda.skillatk3_createProjectile(basefunc, skill, target)
  local projectile = basefunc(skill, target)
  local caster = skill.caster
  if skill.target then
    target = skill.target
    projectile.position, projectile.height = skill:launchPoint()
    local distance = {
      target.position[1] - projectile.position[1],
      target.position[2] - projectile.position[2]
    }
    projectile.zSpeed = (target.position[2] - projectile.height + 50) / math.abs((target.position[1] - projectile.position[1]) / skill.info["Tile XY Speed"])
    projectile.velocity = ed.edpMult(ed.edpNormalize(distance), skill.info["Tile XY Speed"])
    projectile.max_distance = math.abs(projectile.position[1] - target.position[1])
    projectile.hit = override(projectile.hit, TitanPanda.skillatk3_tilehit)
    projectile.terminate = override(projectile.terminate, TitanPanda.skillatk3_tileterminate)
    ed.engine:addProjectile(projectile)
    return nil
  end
  projectile.terminate = override(projectile.terminate, TitanPanda.skillatk3_tileterminate)
  projectile.hit = override(projectile.hit, TitanPanda.skillatk3_tilehit)
  return projectile
end

function TitanPanda.skillatk3_tilehit(basefunc, tile, target)
  local skill = tile.skill
  local caster = skill.caster
  local originfo = caster.atk3_originfo
  local target_position = skill.target.position
  local Basic_Num = skill.info["Basic Num"]
  local Range = skill.info["Shape Arg1"]
  local Plus_Ratio = skill.info["Plus Ratio"]
  local Plus_max = 2
  if target ~= skill.target then
    return
  else
    if tile.actor and tile.actor.node then
      tile.actor.node:setVisible(false)
    end
    if caster:isAlive() and target_position then
      local Rocket_distance = ed.edpDistanceSQ(caster.position, target_position) ^ 0.5
      local Rocket_Ratio = math.floor(Rocket_distance) / 1000
      skill.info = ed.wraptable(originfo, {
        ["Basic Num"] = Basic_Num + math.floor(caster.attribs.INT * 0.5) + Rocket_distance * 10,
        ["Shape Arg1"] = Range + math.floor(Rocket_distance / 3)
      })
    end
    basefunc(tile, target)
    skill.info = originfo
    tile:terminate()
  end
end

function TitanPanda.skillatk3_tileterminate(basefunc, tile)
  basefunc(tile)
  local skill = tile.skill
  local caster = tile.caster
  local originfo = caster.atk3_originfo
  skill.info = originfo
end

function TitanPanda.skillatk3_takeEffectOn(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  if target and target:isAlive() then
    local bid = 1676
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    target:addBuff(binfo, caster)
  end
end

function TitanPanda.skillatk4_buff_onDamaged(basefunc, self, damage, damage_type, source, skill)
  local damage = basefunc(self, damage, damage_type, source, skill)
  local caster = self.caster
  local owner = self.owner
  local skillatk4 = caster.skills.TitanPanda_atk4
  local bid = TitanPanda.stunBid
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = ed.BuffCreate(binfo, owner, caster)
  if skillatk4 and source ~= owner and 8000 < damage and not owner.buff_effects.uncontrollable then
    owner:addBuff(buff, caster)
    caster.atk4_weakActive = true
    self.timer = 0
  end
  if not caster:isAlive() then
    self.timer = 0
  end
  return damage
end

function TitanPanda.skillatk4_buff_onRemoved(basefunc, buff)
  basefunc(buff)
  local caster = buff.caster
  local owner = buff.owner
  local bid = TitanPanda.selfBid
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = ed.BuffCreate(binfo, caster, caster)
  owner.showWeak = false
  if caster.atk4_weakActive == true then
    caster.TitanPanda_SelfBuff = caster:addBuff(buff, caster)
  end
end

function TitanPanda.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  local skillatk4 = hero.skills.TitanPanda_atk4
  local atk4_position = {400, 0}
  hero.TitanPanda_atk4Tick = hero.TitanPanda_atk4Tick and hero.TitanPanda_atk4Tick + dt or dt
  if skillatk4 and hero:isAlive() and not hero.config.is_summoned and hero.name == "TitanPanda" then
    local atk4_CD = math.max(15 - skillatk4.info["Script Arg3"], 5)
    local WeakPoint_Rate = skillatk4.info["Script Arg2"] / 100
    if hero.TitanPanda_hasArcana and hero.TitanPanda_hasArcana > 2 then
      WeakPoint_Rate = WeakPoint_Rate + 0.5
    end
    if atk4_CD < hero.TitanPanda_atk4Tick then
      hero.TitanPanda_atk4Tick2 = hero.TitanPanda_atk4Tick2 and hero.TitanPanda_atk4Tick2 + dt or dt
      if ed.run_with_scene and hero.atk4_effect_notPlay == true then
        ed.scene:playEffectOnScene("eff_point_TitanPanda_atk4.cha", atk4_position, {
          hero.direction * 0.75,
          0.75
        }, nil, -1)
        hero.atk4_effect_notPlay = false
      end
      if hero.TitanPanda_atk4Tick2 > 3 then
        for unit in ed.engine:foreachAliveUnit(hero.foecamp) do
          local ran = ed.rand()
          if WeakPoint_Rate > ran and unit.showWeak ~= true then
            local bid = TitanPanda.weakBid
            local binfo = ed.lookupDataTable("Buff", nil, bid)
            local buff = ed.BuffCreate(binfo, unit, hero)
            buff.onRemoved = override(buff.onRemoved, TitanPanda.skillatk4_buff_onRemoved)
            buff.onDamaged = override(buff.onDamaged, TitanPanda.skillatk4_buff_onDamaged)
            unit:addBuff(buff, hero)
            unit.showWeak = true
          end
        end
        hero.atk4_effect_notPlay = true
        hero.TitanPanda_atk4Tick = 0
        hero.TitanPanda_atk4Tick2 = 0
      end
    end
  end
end

function TitanPanda.DOP_in_battlefield(caster, radius, camp)
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
        position = {x, y}
      end
      if count == maxcount and distance < mindistance then
        mindistance = distance
        position = {x, y}
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

function TitanPanda.skillult_start(basefunc, self, target)
  local caster = self.caster
  local mp = caster.mp
  local originfo = self.info
  local OrigMp = originfo["Cost MP"]
  caster.origmp = OrigMp
  caster.ults_interruptRate = 1
  if caster:isAlive() then
    self.info = ed.wraptable(originfo, {
      ["Cost MP"] = mp
    })
    basefunc(self, target)
    TitanPanda.canCastUlt = false
    caster.ult_costMp = mp
    self.info = originfo
  end
end

function TitanPanda.skillult_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local skillult = caster.skills.TitanPanda_ult
  local skillults = caster.skills.TitanPanda_ults
  local target_position = TitanPanda.DOP_in_battlefield(caster, 200, caster.foecamp)
  if skillult and skillults and skill.attack_counter == 0 and ed.run_with_scene then
    ed.scene:playEffectOnScene("eff_impact_TitanPanda_ult.cha", target_position, {
      caster.direction * 0.75,
      0.75
    }, nil, -1)
  end
  if skillult and skillults and skill.attack_counter == 1 then
    skillults:takeEffectAt(target_position, caster)
    if ed.run_with_scene then
      ed.scene:playEffectOnScene("eff_impact_TitanPanda_ult2.cha", target_position, {
        caster.direction * 0.75,
        0.75
      }, nil, -1)
    end
  end
  basefunc(skill)
end

function TitanPanda.skillults_takeEffectAt(basefunc, skill, location, source)
  local caster = skill.caster
  local Cost_mp = caster.ult_costMp
  local originfo = skill.info
  local OrigMp = caster.origmp
  local MP_Ratio = originfo["Plus Ratio"]
  local Basic_Num = originfo["Basic Num"]
  if caster:isAlive() then
    skill.info = ed.wraptable(originfo, {
      ["Basic Num"] = Basic_Num + math.floor(caster.attribs.INT * 0.5),
      ["Plus Ratio"] = MP_Ratio * math.floor(Cost_mp / OrigMp)
    })
    basefunc(skill, location, source)
    skill.info = originfo
  end
end

function TitanPanda.skillult_CanCastWithTarget(basefunc, skill, target)
  local caster = skill.caster
  if caster:isAlive() and caster.mp < 500 then
    return false, "mp not enough"
  end
  if TitanPanda.canCastUlt == false then
    return false, "TitanPanda_Ult_Casting"
  end
  return basefunc(skill, target)
end

function TitanPanda.need_interrupt(skill)
  local current_phase_idx = skill and skill.current_phase_idx
  local max_phase_idx = skill and #skill.phase_list
  local max_event_idx = current_phase_idx and skill.current_phase and type(skill.current_phase.event_list) == "table" and #skill.current_phase.event_list
  local next_event_idx = current_phase_idx and skill.next_event_idx
  local need
  if skill and current_phase_idx and max_phase_idx and max_event_idx and next_event_idx then
    if current_phase_idx < max_phase_idx then
      need = true
    elseif current_phase_idx == max_phase_idx and max_event_idx >= next_event_idx then
      need = true
    end
  end
  return need
end

function TitanPanda.skillults_takeEffectOn(basefunc, skill, target)
  local caster = skill.caster
  local target_casting1 = target.current_skill and target.current_skill.info["Skill Group ID"]
  local target_need_interrupt = TitanPanda.need_interrupt(target.current_skill)
  local target_castingUlt = target.current_skill and target.current_skill.info["Skill Name"]
  local interruptRand = ed.rand()
  local isHit, dmg = basefunc(skill, target)
  if isHit then
    if target_castingUlt and target.name .. "_ult" and interruptRand < caster.ults_interruptRate then
      target:hurt()
      caster.ults_interruptRate = caster.ults_interruptRate - 0.5
    elseif not target_castingUlt and interruptRand < caster.ults_interruptRate and not target.buff_effects.uncontrollable and not target.buff_effects.invulnerable then
      local binfo = ed.lookupDataTable("Buff", nil, TitanPanda.ult_stun_bid)
      local buff = target:addBuff(binfo, skill.caster)
      caster.ults_interruptRate = caster.ults_interruptRate - 0.2
    end
  end
  local target_casting2 = target.current_skill and target.current_skill.info["Skill Group ID"]
  local interrupt = false
  if target_casting1 ~= nil and target_casting2 == nil and target_need_interrupt == true and target_casting1 ~= target.info["Basic Skill"] then
    interrupt = true
  end
  local skillult = caster.skills.TitanPanda_ult
  local skillults = caster.skills.TitanPanda_ults
  if skillult and skillults and isHit and interrupt == true and target:isAlive() and not target.buff_effects.invulnerable and not target.buff_effects.invisible then
    local amount = 0
    amount = skillult.info["Script Arg2"]
    local extraDamage = target:takeDamage(amount, "Holy", "hp", skill.caster, 1, 1)
    return isHit, extraDamage + dmg
  end
  return isHit, dmg
end

function TitanPanda.skillult_finish(basefunc, skill)
  basefunc(skill)
  TitanPanda.canCastUlt = true
end

function TitanPanda.skillult_willcast(basefunc, skill)
  local caster = skill.caster
  local skillatk2 = caster.skills.TitanPanda_atk2
  local skillatk3 = caster.skills.TitanPanda_atk3
  if caster.current_skill == skillatk2 or caster.current_skill == skillatk3 then
    return false
  elseif caster.hp > 0.75 * caster.attribs.HP and caster.mp < 900 then
    return false
  elseif caster.hp > 0.5 * caster.attribs.HP and caster.mp < 700 then
    return false
  end
  return true
end

function TitanPanda.hero_die(basefunc, hero)
  basefunc(hero)
  if hero.TitanPanda_SelfBuff then
    hero.TitanPanda_SelfBuff.timer = -1
  end
end

function TitanPanda.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.atk4_effect_notPlay = true
  TitanPanda.canCastUlt = true
  hero.TitanPanda_atk4Tick = 0
  hero.TitanPanda_atk4Tick2 = 0
end

function TitanPanda.TitanPanda_skillallPower(basefunc, self, target, power, damage_type, field, source, crit_mod)
  local hero = self.caster
  local power_Ratio = 0.1
  local power = power * power_Ratio
  local dmg = target:takeDamage({
    amount = power,
    damage_type = damage_type,
    field = field,
    source = source,
    crit_mod = crit_mod,
    skill = self
  })
  return dmg
end

function TitanPanda.init_hero(hero)
  local skillatk2 = hero.skills.TitanPanda_atk2
  local skillatk3 = hero.skills.TitanPanda_atk3
  local skillatk4 = hero.skills.TitanPanda_atk4
  local skillult = hero.skills.TitanPanda_ult
  local skillults = hero.skills.TitanPanda_ults
  hero.update = override(hero.update, TitanPanda.hero_update)
  hero.die = override(hero.die, TitanPanda.hero_die)
  hero.reset = override(hero.reset, TitanPanda.hero_reset)
  hero.TitanPanda_hasArcana = ed.getProtoArcanaLevel(hero.proto)
  if skillatk2 then
    skillatk2.start = override(skillatk2.start, TitanPanda.skillatk2_Start)
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, TitanPanda.skillatk2_onAttackFrame)
    if hero.TitanPanda_hasArcana and hero.TitanPanda_hasArcana > 1 then
      skillatk2.createBuff = override(skillatk2.createBuff, TitanPanda.skillatk2_createBuff)
    end
  end
  if skillatk3 then
    skillatk3.start = override(skillatk3.start, TitanPanda.skillatk3_Start)
    skillatk3.createProjectile = override(skillatk3.createProjectile, TitanPanda.skillatk3_createProjectile)
    if hero.TitanPanda_hasArcana and hero.TitanPanda_hasArcana > 3 then
      skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, TitanPanda.skillatk3_takeEffectOn)
    end
  end
  if skillult then
    skillult.onAttackFrame = override(skillult.onAttackFrame, TitanPanda.skillult_onAttackFrame)
    skillult.start = override(skillult.start, TitanPanda.skillult_start)
    skillult.canCastWithTarget = override(skillult.canCastWithTarget, TitanPanda.skillult_CanCastWithTarget)
    skillult.finish = override(skillult.finish, TitanPanda.skillult_finish)
    skillult.willCast = override(skillult.willCast, TitanPanda.skillult_willcast)
  end
  if skillults then
    skillults.takeEffectAt = override(skillults.takeEffectAt, TitanPanda.skillults_takeEffectAt)
    skillults.takeEffectOn = override(skillults.takeEffectOn, TitanPanda.skillults_takeEffectOn)
  end
  local skillnames = {
    "_ult",
    "_atk2",
    "_atk3",
    "_atk4",
    "_ults"
  }
  for i = 1, #skillnames do
    local skill = hero.skills["TitanPanda" .. skillnames[i]]
    if hero.name ~= "TitanPanda" or not hero.config.is_summoned then
    end
  end
  return hero
end

return TitanPanda.init_hero
