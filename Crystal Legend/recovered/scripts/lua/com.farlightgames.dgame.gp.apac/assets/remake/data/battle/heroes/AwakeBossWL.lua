module("ed.battlehero", package.seeall)
local ed = ed
AwakeBossWL = {}
AwakeBossWL.interval = 1
AwakeBossWL.infernal_atk3_buff = 10037905
AwakeBossWL.infernal_Evobuff = 10037907
AwakeBossWL.infernalAttribs = 10037908
AwakeBossWL.targetpos = 0
AwakeBossWL.atk2embuff = 10037903

function AwakeBossWL.skillult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local buffInfo = buff.info
  local owner = buff.owner
  local caster = buff.caster
  local attribName = buffInfo.Tenacity
  local TEN_final = ed.Buff.getTenValue(buffInfo, owner, caster)
  return buff
end

function AwakeBossWL.skillult_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  local v = 900
  local caster = skill.caster
  local target = projectile.skill.target
  if not target then
    return
  end
  projectile:enableTrack(target)
  projectile.height = 300
  projectile.position = {
    caster.position[1],
    caster.position[2]
  }
  local targetposx = target.position[1] - 60 * caster.direction
  if 800 <= targetposx then
    targetposx = 750
  elseif targetposx <= 0 then
    targetposx = 50
  end
  skill.targetpos = {
    targetposx,
    target.position[2]
  }
  local targetxyV = ed.edpSub(skill.targetpos, projectile.position)
  local targetzV = -projectile.height
  local u = (targetxyV[1] * targetxyV[1] + targetxyV[2] * targetxyV[2] + targetzV * targetzV) ^ (-0.5)
  local targetV = {
    u * targetxyV[1],
    u * targetxyV[2],
    u * targetzV
  }
  projectile.velocity[1] = targetV[1] * v
  projectile.velocity[2] = targetV[2] * v
  projectile.zSpeed = targetV[3] * v
  return projectile
end

function AwakeBossWL.infernal_atk3_buff_update(basefunc, buff, dt)
  local timer = buff.attack_timer - dt
  while timer <= 0 do
    timer = timer + AwakeBossWL.interval
    local skill = buff.owner.skills.AwakeBossInfernal_atk3
    skill:takeEffectAt()
  end
  buff.attack_timer = timer
end

function AwakeBossWL.skillult_takeEffectAt(basefunc, skill, location, source)
  local caster = skill.caster
  local infernal_skill2_lv = caster.skills.AwakeBossWL_atk3 and caster.skills.AwakeBossWL_atk3.level or 0
  local infernal_skill3_lv = caster.skills.AwakeBossWL_atk4 and caster.skills.AwakeBossWL_atk4.level or 0
  local infernal1 = caster.infernal1
  local infernal2 = caster.infernal2
  local infernal3 = caster.infernal3
  if infernal1 and infernal1:isAlive() then
    infernal1:die()
  end
  if infernal2 and infernal2:isAlive() then
    infernal2:die()
  end
  if infernal3 and infernal3:isAlive() then
    infernal3:die()
  end
  if caster and caster:isAlive() then
    local proto = {
      _tid = 380,
      _level = skill.level or 1,
      _stars = caster.stars,
      _skill_levels = {
        [3] = infernal_skill2_lv,
        [4] = infernal_skill3_lv
      }
    }
    local config = {
      is_monster = true,
      estimate_rank = true,
      hp_mod = 1,
      summoner = caster
    }
    local infernal1 = ed.UnitCreate(proto, caster.camp, config)
    infernal1.direction = caster.direction
    local position = {
      skill.targetpos[1] + 40,
      skill.targetpos[2]
    }
    ed.engine:summonUnit(infernal1, position, caster)
    caster.infernal1 = infernal1
    local infernal2 = ed.UnitCreate(proto, caster.camp, config)
    infernal2.direction = caster.direction
    local position = {
      skill.targetpos[1],
      skill.targetpos[2]
    }
    ed.engine:summonUnit(infernal2, position, caster)
    caster.infernal2 = infernal2
    local infernal3 = ed.UnitCreate(proto, caster.camp, config)
    infernal3.direction = caster.direction
    local position = {
      skill.targetpos[1] - 40,
      skill.targetpos[2]
    }
    ed.engine:summonUnit(infernal3, position, caster)
    caster.infernal3 = infernal3
    local AttriBinfo = ed.lookupDataTable("Buff", nil, AwakeBossWL.infernalAttribs)
    AwakeBossWL.changeBuffInfo(AttriBinfo, skill.info["Script Arg3"] / 100, infernal1)
    local buff1 = infernal1:addBuff(AttriBinfo, caster)
    infernal1:takeHeal(infernal1.attribs.HP, "hp")
    AwakeBossWL.changeBuffInfo(AttriBinfo, skill.info["Script Arg3"] / 100, infernal2)
    local buff2 = infernal2:addBuff(AttriBinfo, caster)
    infernal2:takeHeal(infernal2.attribs.HP, "hp")
    AwakeBossWL.changeBuffInfo(AttriBinfo, skill.info["Script Arg3"] / 100, infernal3)
    local buff3 = infernal3:addBuff(AttriBinfo, caster)
    infernal3:takeHeal(infernal3.attribs.HP, "hp")
    local infernal_atk3 = infernal1.skills.AwakeBossInfernal_atk3
    local skillatk4 = caster.skills.AwakeBossWL_atk4
    if infernal_atk3 then
      local bid = AwakeBossWL.infernal_atk3_buff
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff1 = infernal1:addBuff(binfo, caster)
      buff1.attack_timer = AwakeBossWL.interval
      buff1.update = override(buff1.update, AwakeBossWL.infernal_atk3_buff_update)
      local buff2 = infernal2:addBuff(binfo, caster)
      buff2.attack_timer = AwakeBossWL.interval
      buff2.update = override(buff2.update, AwakeBossWL.infernal_atk3_buff_update)
      local buff3 = infernal3:addBuff(binfo, caster)
      buff3.attack_timer = AwakeBossWL.interval
      buff3.update = override(buff3.update, AwakeBossWL.infernal_atk3_buff_update)
    end
  end
  basefunc(skill, location, source)
end

function AwakeBossWL.skillatk2_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  for unit in ed.engine:foreachAliveUnit(caster.camp) do
    skill:takeEffectOn(unit)
  end
end

function AwakeBossWL.skillatk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local HPR = buff.info.HPR
  if caster.camp == target.camp then
    return buff
  else
    local hpr = -skill.info["Script Arg2"]
    local healratio = skill.info["Script Arg3"]
    local bid = AwakeBossWL.atk2embuff
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, target, skill.caster)
    buff:setAttribute("HPR", hpr)
    buff:setAttribute("HealRatio", healratio)
    return buff
  end
end

function AwakeBossWL.changeBuffInfo(buffInfo, enhance, target)
  local attrib_temp = {}
  for _, name in ipairs(ed.attrib_names) do
    local value = buffInfo[name] or 0
    local ele = buffInfo[name .. ".x"]
    if value ~= 0 or ele then
      attrib_temp[name] = true
    end
  end
  for name, _ in pairs(attrib_temp) do
    local x = buffInfo[name .. ".x"]
    if x then
      buffInfo[name .. ".a"] = enhance
    end
  end
end

function AwakeBossWL.hero_die(basefunc, hero, killer)
  if hero.infernal1 and hero.infernal1:isAlive() then
    hero.infernal1:die()
  end
  if hero.infernal2 and hero.infernal2:isAlive() then
    hero.infernal2:die()
  end
  if hero.infernal3 and hero.infernal3:isAlive() then
    hero.infernal3:die()
  end
  basefunc(hero, killer)
end

function AwakeBossWL.init_hero(hero)
  local skillult = hero.skills.AwakeBossWL_ult
  local skillatk2 = hero.skills.AwakeBossWL_atk2
  local skillatk3 = hero.skills.AwakeBossWL_atk3
  local skillatk4 = hero.skills.AwakeBossWL_atk4
  hero.die = override(hero.die, AwakeBossWL.hero_die)
  if skillult then
    skillult.createProjectile = override(skillult.createProjectile, AwakeBossWL.skillult_createProjectile)
    skillult.takeEffectAt = override(skillult.takeEffectAt, AwakeBossWL.skillult_takeEffectAt)
  end
  if skillatk2 then
    skillatk2.start = override(skillatk2.start, AwakeBossWL.skillatk2_start)
    skillatk2.createBuff = override(skillatk2.createBuff, AwakeBossWL.skillatk2_createBuff)
  end
  ed.PreloadPuppetRcs("Infernal")
  return hero
end

return AwakeBossWL.init_hero
