module("ed.battlehero", package.seeall)
local ed = ed
MS = {}
MS.atk3range = 100
MS.atk3interval = 50
MS.skillFashionId = 901
MS.buffIndex = {
  1,
  3,
  2,
  4
}

function MS.skillatk2_takeEffectAt(basefunc, skill, location, source)
  local caster = skill.caster
  local originfo = skill.info
  local attack_counter = skill.attack_counter
  skill.info = ed.wraptable(originfo, {
    ["X Shift"] = (attack_counter - 1) * MS.atk3range + MS.atk3interval
  })
  basefunc(skill, location, source)
  if ed.run_with_scene then
    ed.scene:playEffectOnScene("eff_point_MS_atk2.cha", {
      caster.position[1] + skill.info["X Shift"] * caster.direction,
      caster.position[2] - 10
    }, {
      skill.caster.direction,
      1
    }, nil, 0)
  end
  skill.info = originfo
end

function MS.skillult_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  caster.ultSuccess_MS = true
  if ed.run_with_scene then
    local panel = caster.heroPanel
    if panel and caster.name == "MS" then
      if caster.currentActionStage == 1 then
        panel:setPortrait("UI/DOTA-HERO/MS2.png")
      elseif caster.currentActionStage == 2 then
        panel:setPortrait("UI/DOTA-HERO/MS.png")
      elseif caster.currentActionStage == 3 then
        panel:setPortrait("UI/DOTA-HERO/SwitchMS_2.png")
      elseif caster.currentActionStage == 4 then
        panel:setPortrait("UI/DOTA-HERO/SwitchMS.png")
      elseif caster.currentActionStage == 5 then
        panel:setPortrait("UI/DOTA-HERO/MS2_Trueman.jpg")
      elseif caster.currentActionStage == 6 then
        panel:setPortrait("UI/DOTA-HERO/MS_Gentleman.jpg")
      end
    end
  end
  local skill_fashion_Gentleman = caster.skills.MS_fashion_Gentleman
  if MS.skillFashionId and MS.skillFashionId == caster.fashion_id and skill_fashion_Gentleman and 1 > caster.fashion_buff_index then
    for unit in ed.engine:foreachAliveUnit(caster.camp) do
      if unit.info["Unit Type"] == "Hero" then
        local binfo = ed.lookupDataTable("Buff", nil, 4055)
        local buff = ed.BuffCreate(binfo, unit, caster)
        buff:setAttribute("AD", 3 * skill.level)
        buff:setAttribute("AP", 3 * skill.level)
        unit:addBuff(buff, caster)
        local binfo = ed.lookupDataTable("Buff", nil, 4056)
        local buff = ed.BuffCreate(binfo, unit, caster)
        unit:addBuff(buff, caster)
        if unit.info.Gender == "\229\165\179" then
          local binfo = ed.lookupDataTable("Buff", nil, 4057)
          local buff = ed.BuffCreate(binfo, unit, caster)
          unit:addBuff(buff, caster)
        end
      end
    end
    caster.fashion_buff_index = caster.fashion_buff_index + 1
  end
end

function MS.skillult_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  if caster.ultSuccess_MS then
    if caster.currentActionStage == 1 or caster.currentActionStage == 3 or caster.currentActionStage == 5 or caster.currentActionStage == 7 then
      caster:enterActionStageFromOneStage(caster:MSGetUltPeriod(), 90)
      caster.info["Walk Speed"] = caster.info["Walk Speed"] * 2
    else
      caster:enterActionStageFromOneStage(caster:MSGetNormalPeriod(), 90)
      caster.info["Walk Speed"] = caster.info["Walk Speed"] / 2
      if caster.skills.MS_atk2 then
        caster.skills.MS_atk2.cd_remaining = 1
      end
      if caster.skills.MS_atk3 then
        caster.skills.MS_atk3.cd_remaining = 4
      end
    end
    caster.ultSuccess_MS = nil
  end
  local skillsawake = caster.skills.MS_sawake
  if skillsawake then
    local bid = 1655
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buffsawake = ed.BuffCreate(binfo, caster, caster)
    local addmri = skillsawake.info["Script Arg2"]
    buffsawake:setAttribute("MRI", addmri)
    buffsawake:setAttribute("time", math.min(3 + caster.sawake_buff_level, 10))
    caster:addBuff(buffsawake, caster)
    caster.sawake_buff_level = caster.sawake_buff_level + 1
  end
end

function MS.skillult_createBuff(basefunc, skill, target)
  local originfo = skill.info.buff_info
  skill.info.buff_info = ed.wraptable(originfo, {
    Effect = "eff_buff_MS_ult_" .. MS.buffIndex[skill.buffLevel % 4 + 1] .. ".cha"
  })
  local buff = basefunc(skill, target)
  skill.info.buff_info = originfo
  skill.buffLevel = skill.buffLevel + 1
  return buff
end

function MS.skillatk3_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  projectile.height = 1
  return projectile
end

function MS.skillatk4_power(basefunc, skill, source, target, damage_type)
  local power, i = basefunc(skill, source, target, damage_type)
  local ratio = 1
  if skill.attack_counter == 5 then
    ratio = 2
  end
  return power * ratio, i
end

function MS.skillatk4_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  if skill.attack_counter == 5 then
    projectile.MStag = 5
  end
  return projectile
end

function MS.skillatk4_takeEffectOn(basefunc, skill, target, source)
  local originfo = skill.info
  if source and source.MStag == 5 then
    skill.info = ed.wraptable(originfo, {
      ["Impact Effect"] = "eff_impact_MS2_atk2.cha",
      ["AOE Origin"] = "target",
      ["AOE Shape"] = "circle",
      ["Shape Arg1"] = "50"
    })
  end
  basefunc(skill, target, source)
  skill.info = originfo
end

function MS.skillatk4_onAttackFrame(basefunc, skill)
  local originfo = skill.info
  if skill.attack_counter == 4 then
    skill.info = ed.wraptable(originfo, {
      ["Tile Art"] = "eff_tile_MS2_atk2.cha"
    })
  end
  basefunc(skill)
  skill.info = originfo
end

function MS.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.ultSuccess_MS = nil
  if MS.skillFashionId and MS.skillFashionId == hero.fashion_id then
    if hero.currentActionStage == 6 then
      hero.info["Walk Speed"] = hero.info["Walk Speed"] / 2
    end
    hero:enterActionStageFromOneStage(hero:MSGetNormalPeriod(), 90)
  end
  if hero.currentActionStage == 2 or hero.currentActionStage == 4 then
    hero:enterActionStageFromOneStage(hero:MSGetNormalPeriod(), 90)
    hero.info["Walk Speed"] = hero.info["Walk Speed"] / 2
  end
  local skillult = hero.skills.MS_ult
  if skillult then
    skillult.buffLevel = 0
  end
  hero.fashion_buff_index = 0
  hero.sawake_buff_level = 0
end

function MS.onDying(basefunc, hero, killer)
  local skillawake = hero.skills.MS_awake
  local skillult = hero.skills.MS_ult
  local healHP = skillawake.info["Script Arg1"]
  if skillawake and skillult.buffLevel and skillult.buffLevel >= 1 then
    for i, buff in ipairs(hero.buff_list) do
      if buff.info.Effect == "eff_buff_MS_ult_" .. MS.buffIndex[(skillult.buffLevel - 1) % 4 + 1] .. ".cha" then
        buff.timer = 0
      end
    end
    skillult.buffLevel = skillult.buffLevel - 1
    if ed.run_with_scene then
      local effect = "eff_point_MS_awake.cha"
      local position = hero.position
      ed.scene:playEffectOnScene(effect, position, {
        hero.direction,
        1
      }, nil, 0)
    end
    hero:takeHeal(healHP, "hp", hero)
    if 0 >= hero.hp then
      hero:setHP(1)
    end
  else
    basefunc(hero, killer)
  end
end

function MS.init_hero(hero)
  hero:setActionStageChangeByManual(true)
  hero.reset = override(hero.reset, MS.hero_reset)
  local skillult = hero.skills.MS_ult
  if skillult then
    skillult.onAttackFrame = override(skillult.onAttackFrame, MS.skillult_onAttackFrame)
    skillult.finish = override(skillult.finish, MS.skillult_finish)
    skillult.createBuff = override(skillult.createBuff, MS.skillult_createBuff)
    skillult.buffLevel = 0
  end
  local skillatk2 = hero.skills.MS_atk2
  if skillatk2 then
    skillatk2.takeEffectAt = override(skillatk2.takeEffectAt, MS.skillatk2_takeEffectAt)
  end
  local skillatk3 = hero.skills.MS_atk3
  if skillatk3 then
    skillatk3.createProjectile = override(skillatk3.createProjectile, MS.skillatk3_createProjectile)
  end
  local skillatk4 = hero.skills.MS_atk4
  if skillatk4 then
    skillatk4.power = override(skillatk4.power, MS.skillatk4_power)
    skillatk4.takeEffectOn = override(skillatk4.takeEffectOn, MS.skillatk4_takeEffectOn)
    skillatk4.onAttackFrame = override(skillatk4.onAttackFrame, MS.skillatk4_onAttackFrame)
    skillatk4.createProjectile = override(skillatk4.createProjectile, MS.skillatk4_createProjectile)
  end
  
  function hero.MSGetNormalPeriod(unit)
    if MS.skillFashionId and MS.skillFashionId == unit.fashion_id then
      return 5
    else
      return ed.protoSuperAwake(unit.proto, 90) and 7 or ed.protoAwake(unit.proto, 90) and 3 or 1
    end
  end
  
  function hero.MSGetUltPeriod(unit)
    if MS.skillFashionId and MS.skillFashionId == unit.fashion_id then
      return 6
    else
      return ed.protoSuperAwake(unit.proto, 90) and 8 or ed.protoAwake(unit.proto, 90) and 4 or 2
    end
  end
  
  local skillawake = hero.skills.MS_awake
  if skillawake then
    hero.onDying = override(hero.onDying, MS.onDying)
  end
  if ed.protoAwake(hero.proto, 90) or ed.protoSuperAwake(hero.proto, 90) then
    hero:enterActionStageFromOneStage(hero:MSGetNormalPeriod(), 90)
  end
  return hero
end

return MS.init_hero
