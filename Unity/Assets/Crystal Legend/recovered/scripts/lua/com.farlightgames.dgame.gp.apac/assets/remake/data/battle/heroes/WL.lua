module("ed.battlehero", package.seeall)
local ed = ed
WL = {}
WL.interval = 1
WL.infernal_atk3_buff = 10004305
WL.infernal_Evobuff = 10004307
WL.infernalAttribs = 10004308
WL.targetpos = 0
WL.atk2embuff = 10004303

function WL.skillult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local buffInfo = buff.info
  local owner = buff.owner
  local caster = buff.caster
  local attribName = buffInfo.Tenacity
  local TEN_final = ed.Buff.getTenValue(buffInfo, owner, caster)
  if skill.evo_rank and skill.evo_rank >= 3 then
    buff.timer = skill.evo_rank3["Script Arg1"] * math.max(0.01, 1 - TEN_final / 100)
  end
  return buff
end

function WL.skillult_createProjectile(basefunc, skill)
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

function WL.infernal_atk3_buff_update(basefunc, buff, dt)
  local timer = buff.attack_timer - dt
  while timer <= 0 do
    timer = timer + WL.interval
    local skill = buff.owner.skills.Infernal_atk3
    skill:takeEffectAt()
  end
  buff.attack_timer = timer
end

function WL.infernal_atk3_buffhpr_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local hpr = buff.info.HPR
  local infernal = skill.caster
  local hero = infernal.config.summoner
  local skillatk4 = hero.skills.WL_atk4
  if skillatk4 then
    if skill.evo_rank and skill.evo_rank >= 1 then
      buff:setAttribute("HPR", hpr - skill.evo_rank1["Script Arg1"])
    end
    if skill.evo_rank and skill.evo_rank >= 2 then
      buff:setAttribute("HPR", hpr - skill.evo_rank1["Script Arg1"] - skill.evo_rank2["Script Arg1"])
    end
    if skill.evo_rank and skill.evo_rank >= 3 then
      buff:setAttribute("HPR", hpr - skill.evo_rank1["Script Arg1"] - skill.evo_rank2["Script Arg1"] - skill.evo_rank3["Script Arg1"])
    end
  end
  return buff
end

function WL.skillult_takeEffectAt(basefunc, skill, location, source)
  local caster = skill.caster
  local infernal_skill2_lv = caster.skills.WL_atk3 and caster.skills.WL_atk3.level or 0
  local infernal_skill3_lv = caster.skills.WL_atk4 and caster.skills.WL_atk4.level or 0
  local infernal = caster.infernal
  if infernal and infernal:isAlive() then
    infernal:die()
  end
  if caster and caster:isAlive() then
    local proto = {
      _tid = 128,
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
      hp_mod = caster.camp == ed.emCampEnemy and ed.engine.guildInstance_mode and 2 or caster.config.hp_mod,
      summoner = caster
    }
    local infernal = ed.UnitCreate(proto, caster.camp, config)
    infernal.direction = caster.direction
    ed.engine:summonUnit(infernal, skill.targetpos, caster)
    caster.infernal = infernal
    local AttriBinfo = ed.lookupDataTable("Buff", nil, WL.infernalAttribs)
    WL.changeBuffInfo(AttriBinfo, skill.info["Script Arg3"] / 100, infernal)
    local buff = infernal:addBuff(AttriBinfo, caster)
    infernal:takeHeal(infernal.attribs.HP, "hp")
    local infernal_atk2 = infernal.skills.Infernal_atk2
    local skillatk3 = caster.skills.WL_atk3
    if skillatk3 and infernal_atk2 then
      if skillatk3.evo_rank and 1 <= skillatk3.evo_rank then
        infernal_atk2.info = ed.wraptable(infernal_atk2.info, {
          ["Plus Ratio"] = skillatk3.evo_rank1["Script Arg1"]
        })
      end
      if skillatk3.evo_rank and 2 <= skillatk3.evo_rank then
        infernal_atk2.info = ed.wraptable(infernal_atk2.info, {
          ["Plus Ratio"] = skillatk3.evo_rank2["Script Arg1"]
        })
      end
      if skillatk3.evo_rank and 3 <= skillatk3.evo_rank then
        infernal_atk2.info = ed.wraptable(infernal_atk2.info, {
          ["Plus Ratio"] = skillatk3.evo_rank3["Script Arg1"]
        })
      end
    end
    local infernal_atk3 = infernal.skills.Infernal_atk3
    local skillatk4 = caster.skills.WL_atk4
    if infernal_atk3 then
      local bid = WL.infernal_atk3_buff
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = infernal:addBuff(binfo, caster)
      buff.attack_timer = WL.interval
      buff.update = override(buff.update, WL.infernal_atk3_buff_update)
      if skillatk4 then
        infernal_atk3.createBuff = override(infernal_atk3.createBuff, WL.infernal_atk3_buffhpr_createBuff)
      end
    end
    if skill.evo_rank and 2 <= skill.evo_rank then
      local bid = WL.infernal_Evobuff
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = infernal:addBuff(binfo, caster)
    end
  end
  basefunc(skill, location, source)
end

function WL.skillatk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local HPR = buff.info.HPR
  if caster.camp == target.camp then
    if skill.evo_rank and skill.evo_rank >= 2 then
      buff:setAttribute("HPR", HPR + skill.evo_rank2["Script Arg1"] * (1 + caster.attribs.HEAL / 100))
    end
    return buff
  else
    local hpr = -skill.info["Script Arg2"]
    if skill.evo_rank and skill.evo_rank >= 1 then
      hpr = -skill.info["Script Arg2"] - skill.evo_rank1["Script Arg1"]
    end
    local healratio = skill.info["Script Arg3"]
    if skill.evo_rank and skill.evo_rank >= 3 then
      healratio = skill.info["Script Arg3"] - skill.evo_rank3["Script Arg1"]
    end
    local bid = WL.atk2embuff
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, target, skill.caster)
    buff:setAttribute("HPR", hpr)
    buff:setAttribute("HealRatio", healratio)
    return buff
  end
end

function WL.changeBuffInfo(buffInfo, enhance, target)
  local attrib_temp = {}
  local summoner = target.config.summoner
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
      if name == "HP" and ed.engine.rogue_mode and target.camp == ed.emCampEnemy and (summoner.config.is_monster or summoner.config.is_boss) then
        buffInfo[name .. ".a"] = buffInfo[name .. ".a"] / target.config.hp_mod
      end
    end
  end
end

function WL.hero_die(basefunc, hero, killer)
  if hero.infernal and hero.infernal:isAlive() then
    hero.infernal:die()
  end
  basefunc(hero, killer)
end

function WL.init_hero(hero)
  local skillult = hero.skills.WL_ult
  local skillatk2 = hero.skills.WL_atk2
  local skillatk3 = hero.skills.WL_atk3
  local skillatk4 = hero.skills.WL_atk4
  hero.die = override(hero.die, WL.hero_die)
  if skillult then
    if skillult.evo_rank and skillult.evo_rank >= 1 then
      skillult.info = ed.wraptable(skillult.info, {
        ["Plus Ratio"] = skillult.evo_rank1["Script Arg1"]
      })
    end
    if skillult.evo_rank and skillult.evo_rank >= 3 then
      skillult.createBuff = override(skillult.createBuff, WL.skillult_createBuff)
    end
    skillult.createProjectile = override(skillult.createProjectile, WL.skillult_createProjectile)
    skillult.takeEffectAt = override(skillult.takeEffectAt, WL.skillult_takeEffectAt)
  end
  if skillatk2 then
    skillatk2.createBuff = override(skillatk2.createBuff, WL.skillatk2_createBuff)
  end
  ed.PreloadPuppetRcs("Infernal")
  return hero
end

return WL.init_hero
