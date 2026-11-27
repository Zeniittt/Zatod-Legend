module("ed.battlehero", package.seeall)
local ed = ed
DG = {}
DG.name = "DG"
DG.uncontrollableBuffID = 648
DG.emptyBuffID = 233
DG.ultBuffID = 646
DG.ultBuffID2 = 653
DG.atk2Buff = 647
DG.atk2BuffID2 = 652

function DG.ultbuff_onDamaged(basefunc, buff, damage, damage_type, source)
  local dmg = basefunc(buff, damage, damage_type, source)
  local caster = buff.owner
  local ratio = caster.skills[DG.name .. "_ult"].info["Script Arg1"]
  local skill = caster.skills.DG_sawake
  if skill then
    local skilllevel = skill.level
    ratio = ratio + (skilllevel - 70) / 200
  end
  caster.DG_ultResilientDamage = true
  if source and not source.DG_ultResilientDamage and source:isAlive() and (damage_type == "AD" or damage_type == "AP") and source.info["Unit Type"] ~= "Pet" then
    if source.DGultToAWultUnit then
      if not source.DGultToAWultUnit.DG_ultResilientDamage then
        source.DGultToAWultUnit.DG_ultResilientDamage = true
        if not source.buff_effects.invulnerable then
          source.DGultToAWultUnit:takeDamage(damage * ratio, "Holy", "hp", caster)
        end
        source.DGultToAWultUnit.DG_ultResilientDamage = nil
        local name = "eff_impact_DG_ult_attacker.cha"
        if source.DGultToAWultUnit.actor then
          source.DGultToAWultUnit.actor:addEffect(name, 1)
        end
      end
    else
      source.DG_ultResilientDamage = true
      source:takeDamage(damage * ratio, "Holy", "hp", caster)
      source.DG_ultResilientDamage = nil
      local name = "eff_impact_DG_ult_attacker.cha"
      if source.actor then
        source.actor:addEffect(name, 1)
      end
    end
  end
  caster.DG_ultResilientDamage = nil
  return dmg
end

function DG.ultbuff_onRemoved(basefunc, buff)
  basefunc(buff)
  local owner = buff.owner
  local cd1, cd2, cd3
  if owner.skills[DG.name .. "_atk"] then
    cd1 = owner.skills[DG.name .. "_atk"].cd_remaining
  end
  if owner.skills[DG.name .. "_atk2"] then
    cd2 = owner.skills[DG.name .. "_atk2"].cd_remaining
  end
  if owner.skills[DG.name .. "_atk3"] then
    cd3 = owner.skills[DG.name .. "_atk3"].cd_remaining
  end
  if ed.protoSuperAwake(owner.proto, 10030) then
    owner:enterActionStageFromOneStage(7, 10030)
  elseif ed.protoAwake(owner.proto, 10030) then
    owner:enterActionStageFromOneStage(4, 10030)
  else
    owner:enterActionStageFromOneStage(1, 10030)
  end
  if cd1 then
    owner.skills[DG.name .. "_atk"].cd_remaining = cd1
  end
  if cd2 then
    owner.skills[DG.name .. "_atk2"].cd_remaining = 1
  end
  if cd3 then
    owner.skills[DG.name .. "_atk3"].cd_remaining = cd3
  end
  owner.skills[DG.name .. "_ult"].cd_remaining = 0
  if ed.run_with_scene then
    ed.scene:playEffectOnScene("eff_point_Tyre_ult.cha", {
      owner.position[1],
      owner.position[2] - 1
    }, {
      owner.direction,
      1
    }, nil, 0)
  end
  if ed.run_with_scene then
    local panel = owner.heroPanel
    if panel and owner.name == "DG" then
      local pic = "UI/DOTA-HERO/"
      if ed.protoSuperAwake(owner.proto, 10030) then
        pic = pic .. "NewSwitch"
        pic = pic .. "DG.jpg"
        panel:setPortrait(pic)
      elseif ed.protoAwake(owner.proto, 10030) then
        pic = pic .. "Switch"
        pic = pic .. "DG.jpg"
        panel:setPortrait(pic)
      end
      panel.mp_bar.star:setVisible(false)
      panel.mp_bar.foreground:setDisplayFrame(ed.getSpriteFrame("UI/alpha/1080P/common/mp_rage.png"))
    end
  end
  for i, tbuff in ipairs(owner.buff_list) do
    if tbuff.info.ID == DG.ultBuffID2 then
      tbuff.timer = 0
    end
  end
end

function DG.skillult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local unit = skill.caster
  buff.onDamaged = override(buff.onDamaged, DG.ultbuff_onDamaged)
  buff.onRemoved = override(buff.onRemoved, DG.ultbuff_onRemoved)
  local binfo = ed.lookupDataTable("Buff", nil, DG.ultBuffID2)
  local buff2 = unit:addBuff(binfo, unit)
  return buff
end

function DG.skillult_finish(basefunc, skill)
  basefunc(skill)
  local unit = skill.caster
  if ed.protoSuperAwake(unit.proto, 10030) then
    local nextPeriodID = ed.protoSuperAwake(unit.proto, 10030) and 8 or 2
    unit:enterActionStageFromOneStage(nextPeriodID, 10030)
  elseif ed.protoAwake(unit.proto, 10030) then
    local nextPeriodID = ed.protoAwake(unit.proto, 10030) and 5 or 2
    unit:enterActionStageFromOneStage(nextPeriodID, 10030)
  else
    local nextPeriodID = 2
    unit:enterActionStageFromOneStage(nextPeriodID, 10030)
  end
  local cd1, cd2, cd3
  if unit.skills[DG.name .. "_atk"] then
    cd1 = unit.skills[DG.name .. "_atk"].cd_remaining
  end
  if unit.skills[DG.name .. "_atk2"] then
    cd2 = unit.skills[DG.name .. "_atk2"].cd_remaining
  end
  if unit.skills[DG.name .. "_atk3"] then
    cd3 = unit.skills[DG.name .. "_atk3"].cd_remaining
  end
  if cd2 then
    unit.skills[DG.name .. "_atk2"].cd_remaining = 1
  end
  if cd3 then
    unit.skills[DG.name .. "_atk3"].cd_remaining = cd3
  end
  local buff_uncon = unit["Ult Uncontrollable Buff"]
  if buff_uncon then
    unit:removeBuff(buff_uncon)
    unit["Ult Uncontrollable Buff"] = nil
  end
  if ed.run_with_scene and unit.name == "DG" then
    local panel = unit.heroPanel
    if panel then
      local pic = "UI/DOTA-HERO/"
      if ed.protoSuperAwake(unit.proto, 10030) then
        pic = pic .. "NewSwitch"
        pic = pic .. "DG.jpg"
        panel:setPortrait(pic)
      elseif ed.protoAwake(unit.proto, 10030) then
        pic = pic .. "Switch"
        pic = pic .. "DG.jpg"
        panel:setPortrait(pic)
      end
      panel.mp_bar.star:setVisible(true)
      panel.mp_bar.foreground:setDisplayFrame(ed.getSpriteFrame("UI/alpha/1080P/common/mp_rage_2.png"))
    end
  end
  if unit.name == "DG" then
    unit:addBuff(skill:createBuff(unit))
  end
end

function DG.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local unit = skill.caster
  for i, tbuff in ipairs(unit.buff_list) do
    if tbuff.info.ID == DG.atk2BuffID2 then
      tbuff.timer = 0
    end
  end
  for i, tbuff in ipairs(unit.buff_list) do
    if tbuff.info.ID == DG.atk2Buff then
      unit.DG_ultRemoveAtk2Buff = true
      unit:removeBuff(tbuff)
      unit.DG_ultRemoveAtk2Buff = nil
    end
  end
  if not unit["Ult Uncontrollable Buff"] then
    local binfo = ed.lookupDataTable("Buff", nil, DG.uncontrollableBuffID)
    local buff = unit:addBuff(binfo, unit)
    unit["Ult Uncontrollable Buff"] = buff
  end
end

function DG.skillult_canCastWithTarget(basefunc, skill, target)
  local hero = skill.caster
  local ultLowestMPRequirement = 900
  ultLowestMPRequirement = ultLowestMPRequirement - hero.uglyindex * 90
  if not basefunc(skill, target) or hero.manually_casting or hero.currentActionStage == 2 or hero.currentActionStage == 5 or hero.currentActionStage == 8 or ultLowestMPRequirement > hero.mp and hero.name == "DG" then
    return false
  end
  return true
end

function DG.skillult_onAttackFrame(basefunc, self)
  self.attack_counter = self.attack_counter + 1
  if self.info["Target Type"] == "random" or self.target == nil or not self.target:isAlive() then
    self:selectTarget(nil)
  end
  if not self.target then
    return
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
  elseif ttype == "region" then
    local region = self:createRegion()
    ed.engine:addRegion(region)
  elseif ttype == nil then
    self:takeEffectAt(self.target.position)
  else
    EDDebug("Unkonwn Track Type: '" .. ttype .. "'")
  end
  caster:setMP(caster.mp + info["Gain MP"] * ed.engine.mp_bonus)
  if info["Move Forward"] ~= 0 then
    caster.position[1] = caster.position[1] + info["Move Forward"] * caster.direction
  end
end

function DG.skillult_takeEffectOn(basefunc, skill, target, source, shift)
  if skill.attack_counter == 3 then
    for unit in ed.engine:foreachAliveUnit(-skill:affectedCamp()) do
      local name = "eff_impact_DG_ult.cha"
      if unit and unit.actor and not unit.config.is_summoned and not unit.buff_effects.untargetable then
        local effect_z = 1
        unit.actor:addEffect(name, effect_z)
      end
    end
  end
end

function DG.listener_buff_onRemoved(basefunc, buff)
  basefunc(buff)
  if ed.engine.wave_id < ed.engine.stage_info.Waves then
    local caster = buff.caster
    if caster.changePeriod_DK then
      if ed.protoSuperAwake(caster.proto, 10030) then
        caster:enterActionStageFromOneStage(7, 10030)
      elseif ed.protoAwake(caster.proto, 10030) then
        caster:enterActionStageFromOneStage(4, 10030)
      else
        caster:enterActionStageFromOneStage(1, 10030)
      end
      caster.changePeriod_DK = nil
      if ed.run_with_scene then
        local unit = caster
        local panel = unit.heroPanel
        if panel and caster.name == "DG" then
          local pic = "UI/DOTA-HERO/"
          if ed.protoSuperAwake(unit.proto, 10030) then
            pic = pic .. "NewSwitch"
            pic = pic .. "DG.jpg"
            panel:setPortrait(pic)
          elseif ed.protoAwake(unit.proto, 10030) then
            pic = pic .. "Switch"
            pic = pic .. "DG.jpg"
            panel:setPortrait(pic)
          end
        end
      end
    end
  end
end

function DG.reset(basefunc, unit)
  basefunc(unit)
  unit.uglyindex = 0
  unit.judge = 0
  if ed.protoAwake(unit.proto, 10030) then
    unit:enterActionStageFromOneStage(4, 10030)
  end
  if ed.protoSuperAwake(unit.proto, 10030) then
    unit:enterActionStageFromOneStage(7, 10030)
  end
  local binfo = ed.lookupDataTable("Buff", nil, DG.emptyBuffID)
  local buff = unit:addBuff(binfo, unit)
  if buff then
    buff.onRemoved = override(buff.onRemoved, DG.listener_buff_onRemoved)
  end
end

function DG.update(basefunc, unit, dt)
  basefunc(unit, dt)
  if unit.name == "DG" and (unit.currentActionStage == 2 or unit.currentActionStage == 5 or unit.currentActionStage == 8) and unit.mp == 0 then
    for i, tbuff in ipairs(unit.buff_list) do
      if tbuff.info.ID == DG.ultBuffID then
        tbuff.timer = 0
      end
    end
  end
  local hero = unit
  local skillawake = hero.skills.DG_sawake
  if hero:isAlive() and skillawake and hero.judge == 0 then
    local searchTagList = {
      "Alien",
      "Blade",
      "Beast",
      "wild",
      "demon",
      "Giant",
      "Bug",
      "Undead"
    }
    for unit in ed.engine:foreachAliveUnit(-hero.camp) do
      if unit.info["Unit Type"] == "Hero" and type(unit.info["Hero Tags"]) == "table" then
        for _, tag in pairs(unit.info["Hero Tags"]) do
          local is
          for _, searchTag in ipairs(searchTagList) do
            if tag == searchTag then
              is = true
              break
            end
          end
          if is then
            hero.uglyindex = hero.uglyindex + 1
            break
          end
        end
      end
    end
    hero.judge = 1
  end
end

function DG.atk2buff_onRemoved(basefunc, buff)
  basefunc(buff)
  local hero = buff.owner
  local skill3 = hero.skills[DG.name .. "_atk3"]
  local cd3
  if skill3 then
    cd3 = skill3.cd_remaining
  end
  local skill2 = hero.skills[DG.name .. "_atk2"]
  local cd2 = skill2.cd_remaining
  local skill22 = hero.skills[DG.name .. "_atk22"]
  local nextPeriodID = ed.protoSuperAwake(hero.proto, 10030) and 7 or ed.protoAwake(hero.proto, 10030) and 4 or 1
  if not hero.DG_ultRemoveAtk2Buff and not ed.engine.beingEnd then
    hero:enterActionStageFromOneStage(nextPeriodID, 10030)
  end
  if hero.DG_atk2DamageTimes and hero.DG_atk2DamageTimes >= skill2.info["Script Arg1"] then
    if hero.current_skill and hero.current_skill == skill2 then
      hero.current_skill:interrupt()
    end
    skill22.cd_remaining = 0
    hero.global_cd = 0
    local binfo = ed.lookupDataTable("Buff", nil, DG.uncontrollableBuffID)
    local buff = hero:addBuff(binfo, hero)
  end
  if cd3 then
    skill3.cd_remaining = cd3
  end
  skill2.cd_remaining = cd2
  if hero.skills[DG.name .. "_ult"] then
    hero.skills[DG.name .. "_ult"].cd_remaining = 0
  end
  for i, tbuff in ipairs(hero.buff_list) do
    if tbuff.info.ID == DG.atk2BuffID2 then
      tbuff.timer = 0
    end
  end
  hero.DG_atk2DamageTimes = nil
end

function DG.atk2buff_onDamaged(basefunc, buff, damage, damage_type, source)
  local dmg = basefunc(buff, damage, damage_type, source)
  local hero = buff.owner
  local skill = hero.skills[DG.name .. "_atk2"]
  if not hero.DG_atk2DamageTimes then
    hero.DG_atk2DamageTimes = 1
  else
    hero.DG_atk2DamageTimes = hero.DG_atk2DamageTimes + 1
    if hero.DG_atk2DamageTimes >= skill.info["Script Arg1"] then
      buff.timer = 0
    end
  end
  return dmg
end

function DG.skillatk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local unit = skill.caster
  buff.onRemoved = override(buff.onRemoved, DG.atk2buff_onRemoved)
  buff.onDamaged = override(buff.onDamaged, DG.atk2buff_onDamaged)
  local binfo = ed.lookupDataTable("Buff", nil, DG.atk2BuffID2)
  local buff2 = unit:addBuff(binfo, unit)
  local unit = skill.caster
  local cd2 = skill.cd_remaining
  local cd3 = unit.skills[DG.name .. "_atk3"] and unit.skills[DG.name .. "_atk3"].cd_remaining or nil
  local nextPeriodID = ed.protoSuperAwake(unit.proto, 10030) and 9 or ed.protoAwake(unit.proto, 10030) and 6 or 3
  unit:enterActionStageFromOneStage(nextPeriodID, 10030)
  if unit.skills[DG.name .. "_atk"] then
    unit.skills[DG.name .. "_atk"].cd_remaining = 999
  end
  skill.cd_remaining = cd2
  if cd3 then
    unit.skills[DG.name .. "_atk3"].cd_remaining = cd3
  end
  return buff
end

function DG.skillatk22_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == DG.uncontrollableBuffID then
      tbuff.timer = 0
    end
  end
end

function DG.skillatk3_takeEffectOn(basefunc, skill, target, source)
  local attack_counter = skill.attack_counter
  local originfo = skill.info
  if attack_counter == 1 then
    skill.info = ed.wraptable(originfo, {
      ["No Dodge"] = true,
      ["Knock Up"] = 0.1,
      ["Knock Back"] = -50
    })
  else
    skill.info = ed.wraptable(originfo, {
      ["No Dodge"] = true
    })
  end
  local ret, dmg = basefunc(skill, target, source)
  skill.info = originfo
  return ret, dmg
end

function DG.skillatk_onAttackFrame(basefunc, skill)
  if skill.attack_counter == 0 then
    basefunc(skill)
  end
end

function DG.hero_removeAllBuffs(basefunc, hero)
  basefunc(hero)
  if ed.protoSuperAwake(hero.proto, 10030) then
    if hero.currentActionStage ~= 7 then
      hero:enterActionStageFromOneStage(7, 10030)
    end
  elseif ed.protoAwake(hero.proto, 10030) then
    if hero.currentActionStage ~= 4 then
      hero:enterActionStageFromOneStage(4, 10030)
    end
  elseif hero.currentActionStage ~= 1 then
    hero:enterActionStageFromOneStage(1, 10030)
  end
end

function DG.init_hero(hero)
  hero:setActionStageChangeByManual(true)
  hero.reset = override(hero.reset, DG.reset)
  if hero.name == "DG" then
    hero.removeAllBuffs = override(hero.removeAllBuffs, DG.hero_removeAllBuffs)
  end
  local skillult = hero.skills[DG.name .. "_ult"]
  if skillult then
    skillult.start = override(skillult.start, DG.skillult_start)
    skillult.createBuff = override(skillult.createBuff, DG.skillult_createBuff)
    skillult.takeEffectOn = override(skillult.takeEffectOn, DG.skillult_takeEffectOn)
    skillult.canCastWithTarget = override(skillult.canCastWithTarget, DG.skillult_canCastWithTarget)
    skillult.onAttackFrame = override(skillult.onAttackFrame, DG.skillult_onAttackFrame)
    skillult.finish = override(skillult.finish, DG.skillult_finish)
    hero.update = override(hero.update, DG.update)
  end
  local skillatk = hero.skills[DG.name .. "_atk"]
  if skillatk then
    skillatk.onAttackFrame = override(skillatk.onAttackFrame, DG.skillatk_onAttackFrame)
  end
  local skillatk2 = hero.skills[DG.name .. "_atk2"]
  if skillatk2 then
    skillatk2.createBuff = override(skillatk2.createBuff, DG.skillatk2_createBuff)
  end
  local skillatk22 = hero.skills[DG.name .. "_atk22"]
  if skillatk22 then
    skillatk22.finish = override(skillatk22.finish, DG.skillatk22_finish)
  end
  local skillatk3 = hero.skills[DG.name .. "_atk3"]
  if skillatk3 then
    skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, DG.skillatk3_takeEffectOn)
  end
  return hero
end

return DG.init_hero
