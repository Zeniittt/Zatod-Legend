module("ed.battlehero", package.seeall)
local ed = ed
Mor = {}
Mor.MorMSPDRatio = 0
Mor.MorHASTRatio = 0.06
Mor.MorARMRatio = 0.4
Mor.MorHPRRatio = 0.3
Mor.MorSwitchTime = 2
Mor.SkillCastTimes = 0
Mor.beardmg_last = 0
Mor.SawakeBuffOn = false
Mor.SawakeBuff = nil
Mor.SawakeScale = 1
Mor.SawakeAgiState = 0
Mor.skillFashionId = 871

function Mor.MorSwitch_buff_OnRemoved(basefunc, buff)
  basefunc(buff)
  local hero = buff.owner
  local MorStageSTR = buff.info.STR
  if not hero:isAlive() then
    hero:setHP(0)
  end
  if MorStageSTR <= 0 and hero:isAlive() then
    buff:setAttribute("AGI", 0)
    buff:setAttribute("STR", 0)
    hero:rebuild()
    hero:setHP(hero.hp - MorStageSTR * 18 * hero.config.hp_mod)
  elseif 0 < MorStageSTR and hero:isAlive() then
    buff:setAttribute("AGI", 0)
    buff:setAttribute("STR", 0)
    hero:setHP(hero.hp - MorStageSTR * 18 * hero.config.hp_mod)
    if 0 >= hero.hp then
      hero.hp = 1
    end
    hero:rebuild()
  end
  local panel = hero.heroPanel
  if panel then
    if hero.name == "Mor" then
      if Mor.skillFashionId and Mor.skillFashionId == hero.fashion_id then
        panel:setPortrait("UI/DOTA-HERO/Mor_Genie.png")
      elseif ed.protoSuperAwake(hero.proto) then
        panel:setPortrait("UI/DOTA-HERO/NewSwitchMor.png")
      elseif ed.protoAwake(hero.proto) then
        panel:setPortrait("UI/DOTA-HERO/SwitchMor.png")
      else
        panel:setPortrait("UI/DOTA-HERO/Mor.png")
      end
    end
    hero.MorInitialSwitch = false
  end
  if ed.run_with_scene then
    local effect_name = "eff_impact_Lion_atk3.cha"
    local origin = hero.position
    local effect_z = 1
    ed.scene:playEffectOnScene(effect_name, origin, {
      hero.direction,
      1
    }, nil, effect_z)
  end
end

function Mor.skillatk2s_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.onRemoved = override(buff.onRemoved, Mor.MorSwitch_buff_OnRemoved)
  return buff
end

function Mor.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.SkillCastTimes = 0
  hero.beardmg_last = 0
  hero.SawakeBuffOn = false
  hero.SawakeBuff = nil
  hero.SawakeScale = 1
  hero.SawakeAgiState = 0
  hero.ghostScepter = false
  local skillatk2 = hero.skills.Mor_atk2
  local skillatk2s = hero.skills.Mor_atk2s
  if skillatk2 and hero:isAlive() then
    hero.MorInitialAGI = hero.attribs.AGI
    hero.MorInitialSTR = hero.attribs.STR
    hero.MorSwitchAGI = 0
    hero.MorSwitchSTR = 0
    hero.MorInitialSwitch = true
    hero.MorInitialFront = false
    hero.MorBegin = true
    hero.MorBuffSTR = 0
    hero.MorTimer = 0
    hero.SwitchTimes = 0
    if hero.camp == ed.emCampEnemy and ed.engine.guildInstance_mode then
      local skillatk2 = hero.skills.Mor_atk2
      local originfo = skillatk2.info
      skillatk2.info = ed.wraptable(originfo, {
        ["Basic Num"] = 0.001
      })
    end
    hero.MorInitialMaxSwitchValue = hero.MorInitialAGI * skillatk2.info["Basic Num"]
    hero:addBuff(skillatk2s:createBuff(hero))
    if hero.name == "Mor" then
      local self = hero
      for unit in ed.engine:foreachAliveUnit(self.camp) do
        if self.position[1] < 400 and unit.position[1] > self.position[1] then
          hero.MorInitialFront = true
        elseif self.position[1] > 400 and unit.position[1] < self.position[1] then
          hero.MorInitialFront = true
        end
      end
      if hero.MorInitialFront == true then
        hero.MorSwitchAGI = 1
        hero.MorSwitchSTR = 0
      elseif hero.MorInitialFront == false then
        hero.MorSwitchAGI = 0
        hero.MorSwitchSTR = 1
      end
      if hero.MorSwitchAGI == 1 and hero.MorSwitchSTR == 0 then
        if Mor.skillFashionId and Mor.skillFashionId == hero.fashion_id then
          hero:enterActionStageFromOneStage(21, 87)
        elseif ed.protoSuperAwake(hero.proto, 87) then
          hero:enterActionStageFromOneStage(15, 87)
        elseif ed.protoAwake(hero.proto, 87) then
          hero:enterActionStageFromOneStage(9, 87)
        else
          hero:enterActionStageFromOneStage(3, 87)
        end
        for i, buff in ipairs(hero.buff_list) do
          if buff.info.ID == 347 then
            buff:setAttribute("AGI", hero.MorInitialMaxSwitchValue)
            buff:setAttribute("STR", -hero.MorInitialMaxSwitchValue)
            buff:setAttribute("MSPD", buff.info.AGI * Mor.MorMSPDRatio)
            buff:setAttribute("HAST", buff.info.AGI * Mor.MorHASTRatio)
            if Mor.skillFashionId and Mor.skillFashionId == hero.fashion_id then
              buff:setAttribute("Shader", "MorNewSwitchShader_G")
            elseif ed.protoSuperAwake(hero.proto, 87) then
              buff:setAttribute("Shader", "MorNewSwitchShader_G")
            elseif ed.protoAwake(hero.proto, 87) then
              buff:setAttribute("Shader", "MorSwitchShader_G")
            else
              buff:setAttribute("Shader", "MorShader_G")
            end
          end
        end
        hero:setHP(hero.hp - hero.MorInitialMaxSwitchValue * 18 * hero.config.hp_mod)
        hero:rebuild()
      end
      if hero.MorSwitchAGI == 0 and hero.MorSwitchSTR == 1 then
        if Mor.skillFashionId and Mor.skillFashionId == hero.fashion_id then
          hero:enterActionStageFromOneStage(20, 87)
        elseif ed.protoSuperAwake(hero.proto, 87) then
          hero:enterActionStageFromOneStage(14, 87)
        elseif ed.protoAwake(hero.proto, 87) then
          hero:enterActionStageFromOneStage(8, 87)
        else
          hero:enterActionStageFromOneStage(2, 87)
        end
        for i, buff in ipairs(hero.buff_list) do
          if buff.info.ID == 347 then
            buff:setAttribute("AGI", -hero.MorInitialMaxSwitchValue)
            buff:setAttribute("STR", hero.MorInitialMaxSwitchValue)
            buff:setAttribute("HPR", buff.info.STR * Mor.MorHPRRatio)
            buff:setAttribute("ARM", buff.info.STR * Mor.MorARMRatio)
            if Mor.skillFashionId and Mor.skillFashionId == hero.fashion_id then
              buff:setAttribute("Shader", "MorFashionShader_R")
            elseif ed.protoSuperAwake(hero.proto, 87) then
              buff:setAttribute("Shader", "MorNewSwitchShader_R")
            elseif ed.protoAwake(hero.proto, 87) then
              buff:setAttribute("Shader", "MorSwitchShader_R")
            else
              buff:setAttribute("Shader", "MorShader_R")
            end
          end
        end
        hero:rebuild()
        hero:setHP(hero.hp + hero.MorInitialMaxSwitchValue * 18 * hero.config.hp_mod)
      end
    end
  end
end

function Mor.skillatk_onAttackFrame(basefunc, skill)
  local hero = skill.caster
  local skillatk2 = hero.skills.Mor_atk2
  local skillult = hero.skills.Mor_ult
  if skillatk2 then
    if hero.MorBegin == true or hero.currentActionStage == 2 or hero.currentActionStage == 3 or hero.currentActionStage == 8 or hero.currentActionStage == 9 or hero.currentActionStage == 14 or hero.currentActionStage == 15 or hero.currentActionStage == 20 or hero.currentActionStage == 21 then
      if hero.MorSwitchAGI == 0 and hero.MorSwitchSTR == 1 then
        if Mor.skillFashionId and Mor.skillFashionId == hero.fashion_id then
          hero:enterActionStageFromOneStage(23, 87)
        elseif ed.protoSuperAwake(hero.proto, 87) then
          hero:enterActionStageFromOneStage(17, 87)
        elseif ed.protoAwake(hero.proto, 87) then
          hero:enterActionStageFromOneStage(11, 87)
        else
          hero:enterActionStageFromOneStage(5, 87)
        end
      elseif hero.MorSwitchAGI == 1 and hero.MorSwitchSTR == 0 then
        if Mor.skillFashionId and Mor.skillFashionId == hero.fashion_id then
          hero:enterActionStageFromOneStage(24, 87)
        elseif ed.protoSuperAwake(hero.proto, 87) then
          hero:enterActionStageFromOneStage(18, 87)
        elseif ed.protoAwake(hero.proto, 87) then
          hero:enterActionStageFromOneStage(12, 87)
        else
          hero:enterActionStageFromOneStage(6, 87)
        end
      end
      hero.MorBegin = false
    else
      basefunc(skill)
    end
  elseif hero.currentActionStage == 1 or hero.currentActionStage == 7 or hero.currentActionStage == 13 or hero.currentActionStage == 19 then
    if Mor.skillFashionId and Mor.skillFashionId == hero.fashion_id then
      hero:enterActionStageFromOneStage(22, 87)
    elseif ed.protoSuperAwake(hero.proto, 87) then
      hero:enterActionStageFromOneStage(16, 87)
    elseif ed.protoAwake(hero.proto, 87) then
      hero:enterActionStageFromOneStage(10, 87)
    else
      hero:enterActionStageFromOneStage(4, 87)
    end
  else
    basefunc(skill)
  end
  if hero.currentActionStage == 5 or hero.currentActionStage == 11 or hero.currentActionStage == 17 or hero.currentActionStage == 23 then
    local originfo = skill.info
    if Mor.skillFashionId and Mor.skillFashionId == hero.fashion_id then
      skill.info = ed.wraptable(originfo, {
        ["Tile Art"] = "eff_tile_Mor_atk_R.cha",
        ["Impact Effect"] = "eff_impact_Mor_atk_R.cha"
      })
    elseif ed.protoSuperAwake(hero.proto, 87) then
      skill.info = ed.wraptable(originfo, {
        ["Tile Art"] = "eff_tile_Mor_atk_R.cha",
        ["Impact Effect"] = "eff_impact_Mor_atk_R.cha"
      })
    elseif ed.protoAwake(hero.proto, 87) then
      skill.info = ed.wraptable(originfo, {
        ["Tile Art"] = "eff_tile_Mor_atk_R.cha",
        ["Impact Effect"] = "eff_impact_Mor_atk_R.cha"
      })
    else
      skill.info = ed.wraptable(originfo, {
        ["Tile Art"] = "eff_tile_Mor_atk_R1.cha",
        ["Impact Effect"] = "eff_impact_Mor_atk_R1.cha"
      })
    end
  elseif hero.currentActionStage == 6 or hero.currentActionStage == 12 or hero.currentActionStage == 18 or hero.currentActionStage == 24 then
    local originfo = skill.info
    if Mor.skillFashionId and Mor.skillFashionId == hero.fashion_id then
      skill.info = ed.wraptable(originfo, {
        ["Tile Art"] = "eff_tile_Mor_atk_G.cha",
        ["Impact Effect"] = "eff_impact_Mor_atk_G.cha"
      })
    elseif ed.protoSuperAwake(hero.proto, 87) then
      skill.info = ed.wraptable(originfo, {
        ["Tile Art"] = "eff_tile_Mor_atk_G.cha",
        ["Impact Effect"] = "eff_impact_Mor_atk_G.cha"
      })
    elseif ed.protoAwake(hero.proto, 87) then
      skill.info = ed.wraptable(originfo, {
        ["Tile Art"] = "eff_tile_Mor_atk_G.cha",
        ["Impact Effect"] = "eff_impact_Mor_atk_G.cha"
      })
    else
      skill.info = ed.wraptable(originfo, {
        ["Tile Art"] = "eff_tile_Mor_atk_G1.cha",
        ["Impact Effect"] = "eff_impact_Mor_atk_G1.cha"
      })
    end
  end
  if skillatk2 and hero.ai.will_cast_manual_skill then
    local self = hero
    local Lowhp
    if self.hp / self.attribs.HP < 0.3 then
      Lowhp = true
    elseif self.hp / self.attribs.HP > 0.7 then
      Lowhp = false
    end
    for unit in ed.engine:foreachAliveUnit(self.camp) do
      if unit.position[1] * self.direction > self.position[1] * self.direction then
        hero.MorInitialFront = true
      end
    end
    if hero.MorSwitchAGI == 0 and hero.MorSwitchSTR == 1 and hero.MorInitialFront == true and Lowhp == false and hero.current_skill ~= skillatk2 and hero.current_skill ~= skillult and (hero.currentActionStage == 5 or hero.currentActionStage == 11 or hero.currentActionStage == 17 or hero.currentActionStage == 23) then
      local MorAttribs = 348
      local binfo = ed.lookupDataTable("Buff", nil, MorAttribs)
      local buff = ed.BuffCreate(binfo, hero, hero)
      hero:addBuff(buff, hero)
      hero:castSkill(skillatk2, nil)
    elseif hero.MorSwitchAGI == 1 and hero.MorSwitchSTR == 0 and (hero.MorInitialFront ~= true or Lowhp == true) and hero.current_skill ~= skillatk2 and hero.current_skill ~= skillult and (hero.currentActionStage == 6 or hero.currentActionStage == 12 or hero.currentActionStage == 18 or hero.currentActionStage == 24) then
      local MorAttribs = 348
      local binfo = ed.lookupDataTable("Buff", nil, MorAttribs)
      local buff = ed.BuffCreate(binfo, hero, hero)
      hero:addBuff(buff, hero)
      hero:castSkill(skillatk2, nil)
    end
    hero.MorInitialFront = nil
  end
end

function Mor.skillatk3_onAttackFrame(basefunc, skill)
  local hero = skill.caster
  if hero.currentActionStage == 5 or hero.currentActionStage == 11 or hero.currentActionStage == 17 or hero.currentActionStage == 23 then
    local originfo = skill.info
    if Mor.skillFashionId and Mor.skillFashionId == hero.fashion_id then
      skill.info = ed.wraptable(originfo, {
        ["Tile Art"] = "eff_tile_Mor_atk3_R.cha",
        ["Impact Effect"] = "eff_impact_Mor_ult_R.cha"
      })
    elseif ed.protoSuperAwake(hero.proto, 87) then
      skill.info = ed.wraptable(originfo, {
        ["Tile Art"] = "eff_tile_Mor_atk3_R.cha",
        ["Impact Effect"] = "eff_impact_Mor_ult_R.cha"
      })
    elseif ed.protoAwake(hero.proto, 87) then
      skill.info = ed.wraptable(originfo, {
        ["Tile Art"] = "eff_tile_Mor_atk3_R.cha",
        ["Impact Effect"] = "eff_impact_Mor_ult_R.cha"
      })
    else
      skill.info = ed.wraptable(originfo, {
        ["Tile Art"] = "eff_tile_Mor_atk3_R1.cha",
        ["Impact Effect"] = "eff_impact_Mor_ult_R1.cha"
      })
    end
  elseif hero.currentActionStage == 6 or hero.currentActionStage == 12 or hero.currentActionStage == 18 or hero.currentActionStage == 24 then
    local originfo = skill.info
    if Mor.skillFashionId and Mor.skillFashionId == hero.fashion_id then
      skill.info = ed.wraptable(originfo, {
        ["Tile Art"] = "eff_tile_Mor_atk3_G.cha",
        ["Impact Effect"] = "eff_impact_Mor_ult_G.cha"
      })
    elseif ed.protoSuperAwake(hero.proto, 87) then
      skill.info = ed.wraptable(originfo, {
        ["Tile Art"] = "eff_tile_Mor_atk3_G.cha",
        ["Impact Effect"] = "eff_impact_Mor_ult_G.cha"
      })
    elseif ed.protoAwake(hero.proto, 87) then
      skill.info = ed.wraptable(originfo, {
        ["Tile Art"] = "eff_tile_Mor_atk3_G.cha",
        ["Impact Effect"] = "eff_impact_Mor_ult_G.cha"
      })
    else
      skill.info = ed.wraptable(originfo, {
        ["Tile Art"] = "eff_tile_Mor_atk3_G1.cha",
        ["Impact Effect"] = "eff_impact_Mor_ult_G1.cha"
      })
    end
  end
  basefunc(skill)
end

function Mor.skillatk3_power(basefunc, skill, source, target, damage_type)
  local power = basefunc(skill, source, target, damage_type)
  local hero = skill.caster
  local ratio = hero.attribs.AGI / hero.attribs.STR
  if 3 <= ratio then
    ratio = 3
  end
  power = power * ratio
  return power
end

function Mor.skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local hero = skill.caster
  local ratio = hero.attribs.AGI / hero.attribs.STR
  buff.timer = buff.timer / ratio
  if buff.timer >= 5 then
    buff.timer = 5
  end
  return buff
end

function Mor.skillult_start(basefunc, skill, target)
  local hero = skill.caster
  local bid = 390
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  hero:addBuff(binfo, hero)
  basefunc(skill, target)
end

function Mor.skillult_onAttackFrame(basefunc, skill)
  local hero = skill.caster
  if hero.currentActionStage == 5 or hero.currentActionStage == 11 or hero.currentActionStage == 17 or hero.currentActionStage == 23 then
    local originfo = skill.info
    if Mor.skillFashionId and Mor.skillFashionId == hero.fashion_id then
      skill.info = ed.wraptable(originfo, {
        ["Impact Effect"] = "eff_impact_Mor_ult_R.cha"
      })
    elseif ed.protoSuperAwake(hero.proto, 87) then
      skill.info = ed.wraptable(originfo, {
        ["Impact Effect"] = "eff_impact_Mor_ult_R.cha"
      })
    elseif ed.protoAwake(hero.proto, 87) then
      skill.info = ed.wraptable(originfo, {
        ["Impact Effect"] = "eff_impact_Mor_ult_R.cha"
      })
    else
      skill.info = ed.wraptable(originfo, {
        ["Impact Effect"] = "eff_impact_Mor_ult_R1.cha"
      })
    end
  elseif hero.currentActionStage == 6 or hero.currentActionStage == 12 or hero.currentActionStage == 18 or hero.currentActionStage == 24 then
    local originfo = skill.info
    if Mor.skillFashionId and Mor.skillFashionId == hero.fashion_id then
      skill.info = ed.wraptable(originfo, {
        ["Impact Effect"] = "eff_impact_Mor_ult_G.cha"
      })
    elseif ed.protoSuperAwake(hero.proto, 87) then
      skill.info = ed.wraptable(originfo, {
        ["Impact Effect"] = "eff_impact_Mor_ult_G.cha"
      })
    elseif ed.protoAwake(hero.proto, 87) then
      skill.info = ed.wraptable(originfo, {
        ["Impact Effect"] = "eff_impact_Mor_ult_G.cha"
      })
    else
      skill.info = ed.wraptable(originfo, {
        ["Impact Effect"] = "eff_impact_Mor_ult_G.cha"
      })
    end
  end
  basefunc(skill)
end

function Mor.skillult_power(basefunc, skill, source, target, damage_type)
  local power = basefunc(skill, source, target, damage_type)
  local hero = skill.caster
  local ratio = hero.attribs.AGI / hero.attribs.STR
  if 3 <= ratio then
    ratio = 3
  end
  power = power * ratio
  return power
end

function Mor.skillult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local originfo = buff.info
  local hero = skill.caster
  local ratio = hero.attribs.AGI / hero.attribs.STR
  local BuffInitialARM = buff.info.ARM
  buff:setAttribute("ARM", BuffInitialARM / ratio)
  if hero.currentActionStage == 4 then
    buff:setAttribute("Effect", "eff_buff_Mor_ult_B.cha")
  elseif hero.currentActionStage == 5 then
    buff:setAttribute("Effect", "eff_buff_Mor_ult_R1.cha")
  elseif hero.currentActionStage == 6 then
    buff:setAttribute("Effect", "eff_buff_Mor_ult_G1.cha")
  elseif hero.currentActionStage == 10 then
    buff:setAttribute("Effect", "eff_buff_Mor_ult_R.cha")
  elseif hero.currentActionStage == 11 then
    buff:setAttribute("Effect", "eff_buff_Mor_ult_R.cha")
  elseif hero.currentActionStage == 12 then
    buff:setAttribute("Effect", "eff_buff_Mor_ult_G.cha")
  elseif hero.currentActionStage == 16 then
    buff:setAttribute("Effect", "eff_buff_Mor_ult_B.cha")
  elseif hero.currentActionStage == 17 then
    buff:setAttribute("Effect", "eff_buff_Mor_ult_R.cha")
  elseif hero.currentActionStage == 18 then
    buff:setAttribute("Effect", "eff_buff_Mor_ult_G.cha")
  elseif hero.currentActionStage == 22 then
    buff:setAttribute("Effect", "eff_buff_Mor_ult_B.cha")
  elseif hero.currentActionStage == 23 then
    buff:setAttribute("Effect", "eff_buff_Mor_ult_R.cha")
  elseif hero.currentActionStage == 24 then
    buff:setAttribute("Effect", "eff_buff_Mor_ult_G.cha")
  end
  return buff
end

function Mor.skillult_finish(basefunc, skill)
  basefunc(skill)
  for i, buff in ipairs(skill.caster.buff_list) do
    if buff.info.ID == 390 then
      buff.owner:removeBuff(buff)
    end
  end
end

function Mor.newHero_update(basefunc, unit, dt)
  unit.mDuration = unit.mDuration - dt
  if unit.mDuration <= 0 then
    unit:die()
  else
    basefunc(unit, dt)
  end
end

function Mor.skillatk4_takeEffectAt(basefunc, skill, location, source)
  local newHero = skill.caster.newHero
  local hero = skill.caster
  local target = skill.target
  if target.info["Can Copy"] == true then
    if newHero and newHero:isAlive() then
      newHero:die()
    end
    local summonlocation
    basefunc(skill, location, source)
    local caster = skill.caster
    local tid = target.info.ID
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
    local arousal = target.proto._arousal
    local proto = {
      _tid = tid,
      _level = level,
      _stars = stars,
      _skill_levels = skillevel,
      _arousal = arousal,
      _rank = rank
    }
    local config = {
      is_summoned = true,
      hp_mod = caster.camp == ed.emCampEnemy and ed.engine.guildInstance_mode and 2 or caster.config.hp_mod * skill.info["Script Arg1"] / 100,
      dps_mod = caster.camp == caster.config.dps_mod * skill.info["Script Arg1"] / 100,
      size_mod = target.config.size_mod * (skill.info["Script Arg1"] / 100 + 0.2)
    }
    local newHero = ed.UnitCreate(proto, caster.camp, config)
    newHero.mDuration = 8
    newHero.update = override(newHero.update, Mor.newHero_update)
    newHero:setDeathWithEffectOrNot(true)
    summonlocation = {
      target.position[1] - target.direction * 80,
      target.position[2]
    }
    if ed.run_with_scene then
      if hero.currentActionStage == 5 or hero.currentActionStage == 11 or hero.currentActionStage == 17 or hero.currentActionStage == 23 then
        if Mor.skillFashionId and Mor.skillFashionId == hero.fashion_id then
          ed.scene:playEffectOnScene("eff_point_Mor_atk4_R.cha", {
            summonlocation[1],
            summonlocation[2]
          }, {
            caster.direction,
            1
          }, nil, 1)
        elseif ed.protoSuperAwake(hero.proto, 87) then
          ed.scene:playEffectOnScene("eff_point_Mor_atk4_R.cha", {
            summonlocation[1],
            summonlocation[2]
          }, {
            caster.direction,
            1
          }, nil, 1)
        elseif ed.protoAwake(hero.proto, 87) then
          ed.scene:playEffectOnScene("eff_point_Mor_atk4_R.cha", {
            summonlocation[1],
            summonlocation[2]
          }, {
            caster.direction,
            1
          }, nil, 1)
        else
          ed.scene:playEffectOnScene("eff_point_Mor_atk4_R1.cha", {
            summonlocation[1],
            summonlocation[2]
          }, {
            caster.direction,
            1
          }, nil, 1)
        end
      elseif hero.currentActionStage == 6 or hero.currentActionStage == 12 or hero.currentActionStage == 18 or hero.currentActionStage == 24 then
        if Mor.skillFashionId and Mor.skillFashionId == hero.fashion_id then
          ed.scene:playEffectOnScene("eff_point_Mor_atk4_G.cha", {
            summonlocation[1],
            summonlocation[2]
          }, {
            caster.direction,
            1
          }, nil, 1)
        elseif ed.protoSuperAwake(hero.proto, 87) then
          ed.scene:playEffectOnScene("eff_point_Mor_atk4_G.cha", {
            summonlocation[1],
            summonlocation[2]
          }, {
            caster.direction,
            1
          }, nil, 1)
        elseif ed.protoAwake(hero.proto, 87) then
          ed.scene:playEffectOnScene("eff_point_Mor_atk4_G.cha", {
            summonlocation[1],
            summonlocation[2]
          }, {
            caster.direction,
            1
          }, nil, 1)
        else
          ed.scene:playEffectOnScene("eff_point_Mor_atk4_G1.cha", {
            summonlocation[1],
            summonlocation[2]
          }, {
            caster.direction,
            1
          }, nil, 1)
        end
      end
    end
    newHero.direction = target.direction
    ed.engine:summonUnit(newHero, summonlocation, caster, "Idle")
    newHero:reset()
    newHero.attribs.HP = target.attribs.HP / target.config.hp_mod * newHero.config.hp_mod
    for i, attrib in pairs(target.attribs) do
      newHero.attribs[i] = attrib * skill.info["Script Arg1"] / 100
    end
    newHero.attribs.AD = target.attribs.AD
    newHero.attribs.AP = target.attribs.AP
    newHero.attribs.MP = target.attribs.MP
    newHero:setHP(target.hp * skill.info["Script Arg1"] / 100)
    newHero.mp = target.mp
    for i, skill in pairs(newHero.skill_list) do
      if skill.info["Init CD"] <= 60 then
        skill.cd_remaining = 0
      end
    end
    local bid1 = 391
    local binfo1 = ed.lookupDataTable("Buff", nil, bid1)
    local bid2 = 351
    local binfo2 = ed.lookupDataTable("Buff", nil, bid2)
    newHero:addBuff(binfo1, caster)
    newHero:addBuff(binfo2, caster)
    if newHero.name == "NA" or newHero.name == "POM" or newHero.name == "Flood" then
      local bid3 = 492
      local binfo3 = ed.lookupDataTable("Buff", nil, bid3)
      newHero:addBuff(binfo3, caster)
    end
    caster.newHero = newHero
  end
end

function Mor.hero_die(basefunc, hero, killer)
  if hero.newHero and hero.newHero:isAlive() then
    hero.newHero:die()
  end
  basefunc(hero, killer)
end

function Mor.Skillsawake_buff_OnRemoved(basefunc, buff)
  basefunc(buff)
  local caster = buff.caster
  local actor = caster.actor
  caster.SkillCastTimes = 0
  caster.SawakeBuffOn = false
  caster.SawakeScale = 1
  if actor then
    buff.scale_id = actor:useScale({
      caster.SawakeScale,
      caster.SawakeScale
    })
  end
end

function Mor.Skillsawake_buff_Update(basefunc, buff, dt)
  local owner = buff.owner
  local actor = owner.actor
  local skillsawake = owner.skills.Mor_sawake
  local skilllevel = skillsawake.level
  if actor and owner.SawakeScale < 1.2 then
    owner.SawakeScale = owner.SawakeScale + 0.05
    buff.scale_id = actor:useScale({
      owner.SawakeScale,
      owner.SawakeScale
    })
  end
  if owner.MorSwitchAGI == 1 and owner.MorSwitchSTR == 0 and owner.SawakeAgiState == -1 then
    owner.SawakeBuff:setAttribute("HPR", 0)
    owner.SawakeBuff:setAttribute("AD", skillsawake.info["Script Arg3"])
    owner:rebuild()
    owner.SawakeAgiState = 1
  elseif owner.MorSwitchAGI == 0 and owner.MorSwitchSTR == 1 and owner.SawakeAgiState == 1 then
    owner.SawakeBuff:setAttribute("AD", 0)
    owner.SawakeBuff:setAttribute("HPR", skillsawake.info["Script Arg4"])
    owner:rebuild()
    owner.SawakeAgiState = -1
  end
  basefunc(buff, dt)
end

function Mor.skillsawake_createBuff(basefunc, skill, target)
  local caster = skill.caster
  caster.SawakeBuff = basefunc(skill, target)
  caster.SawakeBuff.update = override(caster.SawakeBuff.update, Mor.Skillsawake_buff_Update)
  caster.SawakeBuff.onRemoved = override(caster.SawakeBuff.onRemoved, Mor.Skillsawake_buff_OnRemoved)
  local skillsawake = caster.skills.Mor_sawake
  if caster.MorSwitchAGI == 1 and caster.MorSwitchSTR == 0 then
    caster.SawakeBuff:setAttribute("AD", skillsawake.info["Script Arg3"])
    caster.SawakeAgiState = 1
  elseif caster.MorSwitchAGI == 0 and caster.MorSwitchSTR == 1 then
    caster.SawakeBuff:setAttribute("HPR", skillsawake.info["Script Arg4"])
    caster.SawakeAgiState = -1
  end
  return caster.SawakeBuff
end

function Mor.hero_update(basefunc, hero, dt)
  local skillsawake = hero.skills.Mor_sawake
  if skillsawake and not hero.SawakeBuffOn and hero.SkillCastTimes > 3 then
    hero:addBuff(skillsawake:createBuff(hero))
    hero.beardmg_last = hero.battledata.beardmg
    hero.SawakeBuffOn = true
    hero.SkillCastTimes = 0
  end
  basefunc(hero, dt)
  local skillatk2 = hero.skills.Mor_atk2
  local skillult = hero.skills.Mor_ult
  if skillatk2 then
    hero.can_cast_manual = hero.can_cast_manual or skillatk2 and skillatk2:canCastWithTarget(hero.ai.target)
    if hero.MorSwitchAGI == 1 and hero.MorSwitchSTR == 0 and hero.MorInitialSwitch == true and ed.run_with_scene then
      local panel = hero.heroPanel
      if panel then
        if hero.name == "Mor" then
          if Mor.skillFashionId and Mor.skillFashionId == hero.fashion_id then
            panel:setPortrait("UI/DOTA-HERO/Mor_GenieG.png")
          elseif ed.protoSuperAwake(hero.proto) then
            panel:setPortrait("UI/DOTA-HERO/NewSwitchMorG.png")
          elseif ed.protoAwake(hero.proto) then
            panel:setPortrait("UI/DOTA-HERO/SwitchMorG.png")
          else
            panel:setPortrait("UI/DOTA-HERO/MorG.png")
          end
        end
        hero.MorInitialSwitch = false
      end
    end
    if hero.MorSwitchAGI == 0 and hero.MorSwitchSTR == 1 and hero.MorInitialSwitch == true and ed.run_with_scene then
      local panel = hero.heroPanel
      if panel then
        if hero.name == "Mor" then
          if Mor.skillFashionId and Mor.skillFashionId == hero.fashion_id then
            panel:setPortrait("UI/DOTA-HERO/Mor_GenieR.png")
          elseif ed.protoSuperAwake(hero.proto) then
            panel:setPortrait("UI/DOTA-HERO/NewSwitchMorR.png")
          elseif ed.protoAwake(hero.proto) then
            panel:setPortrait("UI/DOTA-HERO/SwitchMorR.png")
          else
            panel:setPortrait("UI/DOTA-HERO/MorR.png")
          end
        end
        hero.MorInitialSwitch = false
      end
    end
    local MaxSwitchValue = hero.MorInitialMaxSwitchValue * 2
    if hero.MorSwitchAGI == 1 and hero.MorSwitchSTR == -1 then
      if ed.run_with_scene then
        local panel = hero.heroPanel
        if panel then
          if hero.name == "Mor" then
            if Mor.skillFashionId and Mor.skillFashionId == hero.fashion_id then
              panel:setPortrait("UI/DOTA-HERO/Mor_GenieG.png")
            elseif ed.protoSuperAwake(hero.proto) then
              panel:setPortrait("UI/DOTA-HERO/NewSwitchMorG.png")
            elseif ed.protoAwake(hero.proto) then
              panel:setPortrait("UI/DOTA-HERO/SwitchMorG.png")
            else
              panel:setPortrait("UI/DOTA-HERO/MorG.png")
            end
          end
          hero.MorInitialSwitch = false
        end
      end
      hero.MorTimer = hero.MorTimer + dt
      if hero.SwitchTimes == 0 and 1 <= hero.MorTimer then
        hero.SwitchTimes = hero.SwitchTimes + 1
        hero.MorTimer = hero.MorTimer - 1
      end
      for i, buff in ipairs(hero.buff_list) do
        if buff.info.ID == 347 and hero.SwitchTimes == 1 then
          buff:setAttribute("AGI", buff.info.AGI + MaxSwitchValue / Mor.MorSwitchTime)
          buff:setAttribute("STR", buff.info.STR - MaxSwitchValue / Mor.MorSwitchTime)
          if 0 < buff.info.AGI then
            buff:setAttribute("MSPD", buff.info.AGI * Mor.MorMSPDRatio)
            buff:setAttribute("HAST", buff.info.AGI * Mor.MorHASTRatio)
          elseif 0 > buff.info.AGI then
            buff:setAttribute("MSPD", 0)
            buff:setAttribute("HAST", 0)
          end
          if 0 < buff.info.STR then
            buff:setAttribute("HPR", buff.info.STR * Mor.MorHPRRatio)
            buff:setAttribute("ARM", buff.info.STR * Mor.MorARMRatio)
          elseif 0 > buff.info.STR then
            buff:setAttribute("HPR", 0)
            buff:setAttribute("ARM", 0)
          end
          hero:setHP(hero.hp - MaxSwitchValue / Mor.MorSwitchTime * 18 * hero.config.hp_mod)
          hero:rebuild()
          hero.SwitchTimes = 0
          if math.abs(buff.info.AGI - buff.info.STR) >= MaxSwitchValue * 0.9 then
            hero.MorSwitchAGI = 1
            hero.MorSwitchSTR = 0
            hero:castSkill(hero.skills.Mor_atk, hero)
          end
          if Mor.skillFashionId and Mor.skillFashionId == hero.fashion_id then
            buff:setAttribute("Shader", "MorNewSwitchShader_G")
          elseif ed.protoSuperAwake(hero.proto, 87) then
            buff:setAttribute("Shader", "MorNewSwitchShader_G")
          elseif ed.protoAwake(hero.proto, 87) then
            buff:setAttribute("Shader", "MorSwitchShader_G")
          else
            buff:setAttribute("Shader", "MorShader_G")
          end
        end
      end
    end
    if hero.MorSwitchAGI == -1 and hero.MorSwitchSTR == 1 then
      if ed.run_with_scene then
        local panel = hero.heroPanel
        if panel then
          if hero.name == "Mor" then
            if Mor.skillFashionId and Mor.skillFashionId == hero.fashion_id then
              panel:setPortrait("UI/DOTA-HERO/Mor_GenieR.png")
            elseif ed.protoSuperAwake(hero.proto) then
              panel:setPortrait("UI/DOTA-HERO/NewSwitchMorR.png")
            elseif ed.protoAwake(hero.proto) then
              panel:setPortrait("UI/DOTA-HERO/SwitchMorR.png")
            else
              panel:setPortrait("UI/DOTA-HERO/MorR.png")
            end
          end
          hero.MorInitialSwitch = false
        end
      end
      hero.MorTimer = hero.MorTimer + dt
      if hero.SwitchTimes == 0 and 1 <= hero.MorTimer then
        hero.SwitchTimes = hero.SwitchTimes + 1
        hero.MorTimer = hero.MorTimer - 1
      end
      for i, buff in ipairs(hero.buff_list) do
        if buff.info.ID == 347 and hero.SwitchTimes == 1 then
          buff:setAttribute("AGI", buff.info.AGI - MaxSwitchValue / Mor.MorSwitchTime)
          buff:setAttribute("STR", buff.info.STR + MaxSwitchValue / Mor.MorSwitchTime)
          if 0 < buff.info.AGI then
            buff:setAttribute("MSPD", buff.info.AGI * Mor.MorMSPDRatio)
            buff:setAttribute("HAST", buff.info.AGI * Mor.MorHASTRatio)
          elseif 0 > buff.info.AGI then
            buff:setAttribute("MSPD", 0)
            buff:setAttribute("HAST", 0)
          end
          if 0 < buff.info.STR then
            buff:setAttribute("HPR", buff.info.STR * Mor.MorHPRRatio)
            buff:setAttribute("ARM", buff.info.STR * Mor.MorARMRatio)
          elseif 0 > buff.info.STR then
            buff:setAttribute("HPR", 0)
            buff:setAttribute("ARM", 0)
          end
          hero:rebuild()
          hero:setHP(hero.hp + MaxSwitchValue / Mor.MorSwitchTime * 18 * hero.config.hp_mod)
          hero.SwitchTimes = 0
          if math.abs(buff.info.AGI - buff.info.STR) >= MaxSwitchValue * 0.9 then
            hero.MorSwitchAGI = 0
            hero.MorSwitchSTR = 1
            hero.MorTimer = 0
            hero:castSkill(hero.skills.Mor_atk, hero)
            if Mor.skillFashionId and Mor.skillFashionId == hero.fashion_id then
              buff:setAttribute("Shader", "MorFashionShader_R")
            elseif ed.protoSuperAwake(hero.proto, 87) then
              buff:setAttribute("Shader", "MorNewSwitchShader_R")
            elseif ed.protoAwake(hero.proto, 87) then
              buff:setAttribute("Shader", "MorSwitchShader_R")
            else
              buff:setAttribute("Shader", "MorShader_R")
            end
          end
        end
      end
    end
    hero.can_cast_manual = hero.can_cast_manual or hero.mp < 1000 and hero.MorSwitchAGI == 1 and hero.MorSwitchSTR == 0 and hero.current_skill ~= skillult and hero.current_skill ~= skillatk2 and hero:isAlive() and (hero.currentActionStage == 6 or hero.currentActionStage == 12 or hero.currentActionStage == 18 or hero.currentActionStage == 24) or hero.mp < 1000 and hero.MorSwitchAGI == 0 and hero.MorSwitchSTR == 1 and hero.current_skill ~= skillult and hero.current_skill ~= skillatk2 and hero:isAlive() and (hero.currentActionStage == 5 or hero.currentActionStage == 11 or hero.currentActionStage == 17 or hero.currentActionStage == 23)
  end
end

function Mor.hero_castManualSkill(basefunc, hero)
  local skillatk2 = hero.skills.Mor_atk2
  local skillult = hero.skills.Mor_ult
  if skillatk2 then
    if hero.mp < 1000 and hero.MorSwitchAGI == 1 and hero.MorSwitchSTR == 0 and hero.current_skill ~= skillatk2 and hero.current_skill ~= skillult then
      if hero.current_skill then
        hero.current_skill:interrupt()
      end
      local MorAttribs = 348
      local binfo = ed.lookupDataTable("Buff", nil, MorAttribs)
      local buff = ed.BuffCreate(binfo, hero, hero)
      hero:addBuff(buff, hero)
      hero:castSkill(skillatk2, nil)
    elseif hero.mp < 1000 and hero.MorSwitchAGI == 0 and hero.MorSwitchSTR == 1 and hero.current_skill ~= skillatk2 and hero.current_skill ~= skillult then
      if hero.current_skill then
        hero.current_skill:interrupt()
      end
      local MorAttribs = 348
      local binfo = ed.lookupDataTable("Buff", nil, MorAttribs)
      local buff = ed.BuffCreate(binfo, hero, hero)
      hero:addBuff(buff, hero)
      hero:castSkill(skillatk2, nil)
    else
      basefunc(hero)
    end
  end
end

function Mor.skillatk2_onAttackFrame(basefunc, skill)
  local hero = skill.caster
  local skillatk2 = hero.skills.Mor_atk2
  if hero.MorSwitchAGI == 1 and hero.MorSwitchSTR == 0 then
    hero.MorSwitchAGI = -1
    hero.MorSwitchSTR = 1
    if Mor.skillFashionId and Mor.skillFashionId == hero.fashion_id then
      hero:enterActionStageFromOneStage(20, 87)
    elseif ed.protoSuperAwake(hero.proto, 87) then
      hero:enterActionStageFromOneStage(14, 87)
    elseif ed.protoAwake(hero.proto, 87) then
      hero:enterActionStageFromOneStage(8, 87)
    else
      hero:enterActionStageFromOneStage(2, 87)
    end
    hero.can_cast_manual = false
    hero.skills.Mor_atk.cd_remaining = 999
    hero:castSkill(skillatk2, hero)
  elseif hero.MorSwitchAGI == 0 and hero.MorSwitchSTR == 1 then
    hero.MorSwitchAGI = 1
    hero.MorSwitchSTR = -1
    if Mor.skillFashionId and Mor.skillFashionId == hero.fashion_id then
      hero:enterActionStageFromOneStage(21, 87)
    elseif ed.protoSuperAwake(hero.proto, 87) then
      hero:enterActionStageFromOneStage(15, 87)
    elseif ed.protoAwake(hero.proto, 87) then
      hero:enterActionStageFromOneStage(9, 87)
    else
      hero:enterActionStageFromOneStage(3, 87)
    end
    hero.can_cast_manual = false
    hero.skills.Mor_atk.cd_remaining = 999
    hero:castSkill(skillatk2, hero)
  end
  basefunc(skill)
end

function Mor.skillatk2_finish(basefunc, skill)
  basefunc(skill)
  for i, buff in ipairs(skill.caster.buff_list) do
    if buff.info.ID == 348 then
      buff.owner:removeBuff(buff)
    end
  end
end

function Mor.skillstart(basefunc, self, target)
  local caster = self.caster
  caster.SkillCastTimes = caster.SkillCastTimes + 1
  basefunc(self, target)
end

function Mor.hero_takeDamage(basefunc, self, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
  self.DamageType = nil
  if type(struct_table) == "table" then
    self.DamageType = struct_table.damage_type
  end
  return basefunc(self, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
end

function Mor.skill_getLostHPAfterImmunity(basefunc, self, damage, immunity)
  for i, tbuff in ipairs(self.buff_list) do
    if tbuff.info.ID == 1362 then
      if self.DamageType == "AP" or self.DamageType == "Holy" then
        return 1
      elseif self.DamageType == "AD" then
        local color = self.camp == ed.emCampEnemy and "red" or "blue"
        if self.actor then
          ed.PopupCreate("physical_immune", color, self.actor, nil, "text")
        end
        return 0
      end
    end
  end
  return basefunc(self, damage, immunity)
end

function Mor.onDying(basefunc, hero, killer)
  if Mor.skillFashionId and Mor.skillFashionId == hero.fashion_id and not hero.ghostScepter and hero.name ~= "Rubick" then
    hero:setHP(2)
    local bid = 1362
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local Mor_ghostScepter_Buff = ed.BuffCreate(binfo, hero, hero)
    hero:addBuff(Mor_ghostScepter_Buff, hero)
    hero.SkillCastTimes = hero.SkillCastTimes + 1
    hero.ghostScepter = true
  else
    basefunc(hero, killer)
  end
end

function Mor.init_hero(hero)
  hero:setActionStageChangeByManual(true)
  hero.reset = override(hero.reset, Mor.hero_reset)
  hero.update = override(hero.update, Mor.hero_update)
  hero.die = override(hero.die, Mor.hero_die)
  hero.onDying = override(hero.onDying, Mor.onDying)
  hero.getLostHPAfterImmunity = override(hero.getLostHPAfterImmunity, Mor.skill_getLostHPAfterImmunity)
  hero.takeDamage = override(hero.takeDamage, Mor.hero_takeDamage)
  local skillatk = hero.skills.Mor_atk
  if skillatk then
    skillatk.onAttackFrame = override(skillatk.onAttackFrame, Mor.skillatk_onAttackFrame)
  end
  local skillatk2 = hero.skills.Mor_atk2
  local skillatk2s = hero.skills.Mor_atk2s
  if skillatk2 and skillatk2s then
    hero.castManualSkill = override(hero.castManualSkill, Mor.hero_castManualSkill)
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, Mor.skillatk2_onAttackFrame)
    skillatk2s.createBuff = override(skillatk2s.createBuff, Mor.skillatk2s_createBuff)
    skillatk2.finish = override(skillatk2.finish, Mor.skillatk2_finish)
  end
  local skillatk3 = hero.skills.Mor_atk3
  if skillatk3 then
    skillatk3.start = override(skillatk3.start, Mor.skillstart)
    skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, Mor.skillatk3_onAttackFrame)
    skillatk3.power = override(skillatk3.power, Mor.skillatk3_power)
    skillatk3.createBuff = override(skillatk3.createBuff, Mor.skillatk3_createBuff)
  end
  local skillult = hero.skills.Mor_ult
  if skillult then
    skillult.start = override(skillult.start, Mor.skillult_start)
    skillult.start = override(skillult.start, Mor.skillstart)
    skillult.onAttackFrame = override(skillult.onAttackFrame, Mor.skillult_onAttackFrame)
    skillult.power = override(skillult.power, Mor.skillult_power)
    skillult.createBuff = override(skillult.createBuff, Mor.skillult_createBuff)
    skillult.finish = override(skillult.finish, Mor.skillult_finish)
  end
  local skillatk4 = hero.skills.Mor_atk4
  if skillatk4 then
    skillatk4.start = override(skillatk4.start, Mor.skillstart)
    skillatk4.takeEffectAt = override(skillatk4.takeEffectAt, Mor.skillatk4_takeEffectAt)
  end
  local skillsawake = hero.skills.Mor_sawake
  if skillsawake then
    skillsawake.createBuff = override(skillsawake.createBuff, Mor.skillsawake_createBuff)
  end
  return hero
end

return Mor.init_hero
