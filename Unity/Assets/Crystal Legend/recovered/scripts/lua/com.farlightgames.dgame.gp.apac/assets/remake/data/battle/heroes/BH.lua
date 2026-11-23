module("ed.battlehero", package.seeall)
local ed = ed
BH = {}
BH.name = "BH"
BH.Bounty_Buff_ID = 10007102
BH.bounty_Effect_Name = {
  "BH_Effect.cha"
}
BH.Bounty_Types = {
  "HP",
  "MP",
  "AD",
  "ARM",
  "MR"
}
BH.Reward_Fields = {
  "HPR",
  "MPR",
  "AD",
  "Shield Value",
  "Shield Value"
}
BH.Bounty_Buff_Effects = {
  "eff_buff_BH_bounty_HP.cha",
  "eff_buff_BH_bounty_MP.cha",
  "eff_buff_BH_bounty_AD.cha",
  "eff_buff_BH_bounty_ARM.cha",
  "eff_buff_BH_bounty_MR.cha"
}
BH.Bounty_Point_Effects = {
  "eff_point_BH_bounty_achieve_HP.cha",
  "eff_point_BH_bounty_achieve_MP.cha",
  "eff_point_BH_bounty_achieve_AD.cha",
  "eff_point_BH_bounty_achieve_ARM.cha",
  "eff_point_BH_bounty_achieve_MR.cha"
}
BH.Reward_Point_Effect = "eff_point_bounty_killer.cha"
BH.Bounty_Buff_Effect = {
  "eff_buff_BH_bounty_HP.cha"
}
BH.Reward_BuffIDs = {
  10007103,
  10007104,
  10007105,
  10007106,
  10007107
}
BH.Bounty_Indexs = {
  0,
  3,
  2
}
BH.Reward_Factors = {
  66,
  56,
  54,
  -8,
  15,
  9,
  -38,
  89
}
BH.AtkTileSpeeds = {
  450,
  550,
  800
}
BH.AtkTileBuffIDs = {
  63,
  53,
  42,
  31,
  27,
  23,
  124,
  -48
}
BH.MaxNinjitsuTime = 12
BH.jump_gap = 1600
BH.fashion_1 = 711

function BH.reset(basefunc, unit)
  basefunc(unit)
  local skillult = unit.skills.BH_ult
  unit.Reward_ExtraTime = {
    0,
    0,
    0,
    0,
    0
  }
  if skillult.evo_rank and skillult.evo_rank >= 1 then
    unit.Reward_ExtraTime = {
      skillult.evo_rank1["Script Arg1"],
      skillult.evo_rank1["Script Arg1"],
      0,
      0,
      0
    }
  end
  unit.lastNinjitsuEffectRate_BH = -1
  local skill4 = unit.skills[BH.name .. "_atk4"]
  if skill4 then
    unit.ninjitsuTime_BH = 0
  end
end

function BH.forceBreakStealth(unit)
  if unit.BHStealthBuff then
    unit:removeBuff(unit.BHStealthBuff)
  end
end

function BH.skillult_onAttackFrame(basefunc, skill)
  basefunc(skill)
  if skill.caster.skills[BH.name .. "_ult_friendly"] then
    skill.caster.skills[BH.name .. "_ult_friendly"]:takeEffectAt(skill.caster.position)
  end
end

function BH.skillult_canCastWithTarget(basefunc, self, target)
  if self.can_cast_tick == ed.engine.ticks then
    return self.can_cast, "same tick"
  end
  self.can_cast_tick = ed.engine.ticks
  local info = self.info
  local caster = self.caster
  self.can_cast = false
  if info["Cost MP"] > caster.mp then
    return false, "mp"
  end
  if not self.is_update then
    return false, "is_update = false"
  end
  if self.cd_remaining > 0 then
    return false, "cd"
  end
  if caster.buff_effects.stun then
    return false, "stun"
  end
  if caster.buff_effects.stunbyself then
    return false, "stunbyself"
  end
  if self.info["Damage Type"] == "AD" and caster.buff_effects.disarm then
    return false, "disarm"
  end
  if self.info["Damage Type"] ~= "AD" and (caster.buff_effects.silence or caster.buff_effects.silencebyself) then
    return false, "silence"
  end
  if self ~= caster.basic_skill and caster.buff_effects.doom then
    return false, "doom"
  end
  if self == caster.manual_skill and caster.buff_effects.unmanual then
    return false, "unmanual"
  end
  if self == caster.manual_skill and caster.manually_casting then
    return false, "manually_casting"
  end
  if self:target_selector() then
    target = self:selectTarget(target)
  end
  if not target then
    return false, "no target"
  end
  if not target:isAlive() then
    return false, "target is not alive"
  end
  if target.buff_effects.untargetable then
    return false, "untargetable"
  end
  if 0 > target.camp * self:targetCamp() then
    return false, "target camp"
  end
  local distanceSQ = ed.edpDistanceSQ(target.position, self.caster.position)
  if distanceSQ > self.max_range_sq then
    return false, "too far"
  end
  if distanceSQ < self.min_range_sq then
    return false, "too near"
  end
  if not info["Outside Screen"] and caster:isOutOfStage() then
    return false, "outside stage"
  end
  local sid = self.info["Skill Group ID"]
  if not caster.skillConditon or caster.skillConditon[sid] then
  end
  if battle_tick.getRealTimePvp() and ed.engine.freeze_camp and caster.camp ~= ed.engine.freeze_camp then
    return false, "freeze camp"
  end
  self.can_cast = true
  return true
end

function BH.skillult_selectTarget(basefunc, self, default)
  local target_type = self.info["Target Type"]
  local selector = self:target_selector()
  local Ignore = self:Ignore_Target_Type()
  if target_type == "target" then
    if default and default:isAlive() then
      self.target = default
    else
      local t, distanceSQ = self.caster.ai:searchTarget()
      if distanceSQ <= self.max_range_sq then
        self.target = t
      else
        self.target = nil
      end
    end
  elseif target_type == "self" then
    self.target = self.caster
  elseif selector then
    local max = -math.huge
    local chosen
    local caster = self.caster
    local caster_position = caster.position
    local enchanted = caster.buff_effects.enchanted
    local enchantedbyself = caster.buff_effects.enchantedbyself
    for unit in ed.engine:foreachAliveUnit(self:targetCamp()) do
      if unit.buff_effects.untargetable then
      elseif enchanted and unit == caster then
      elseif enchantedbyself and unit == caster then
      elseif self:targetCamp() == self.caster.camp and unit.controlledTarget then
      else
        local distanceSQ = (unit.position[1] - caster_position[1]) ^ 2 + (unit.position[2] - caster_position[2]) ^ 2
        if distanceSQ >= self.min_range_sq and distanceSQ <= self.max_range_sq then
          local v = selector(unit)
          local shouldIgnore = Ignore(unit)
          if max < v and not shouldIgnore then
            max = v
            chosen = unit
          end
        end
      end
    end
    self.target = chosen
  else
    EDDebug("Unkonwn target type: " .. target_type)
  end
  return self.target
end

function BH.skillult_selectTargetForCheck(basefunc, self, default)
  local target_type = self.info["Target Type"]
  local selector = self:target_selector()
  local Ignore = self:Ignore_Target_Type()
  local target
  if target_type == "target" then
    if default and default:isAlive() then
      target = default
    else
      local t, distanceSQ = self.caster.ai:searchTarget()
      if distanceSQ <= self.max_range_sq then
        target = t
      else
        target = nil
      end
    end
  elseif target_type == "self" then
    target = self.caster
  elseif selector then
    local max = -math.huge
    local chosen
    local caster = self.caster
    local caster_position = caster.position
    local enchanted = caster.buff_effects.enchanted
    local enchantedbyself = caster.buff_effects.enchantedbyself
    for unit in ed.engine:foreachAliveUnit(self:targetCamp()) do
      if unit.buff_effects.untargetable then
      elseif enchanted and unit == caster then
      elseif enchantedbyself and unit == caster then
      elseif self:targetCamp() == self.caster.camp and unit.controlledTarget then
      else
        local distanceSQ = (unit.position[1] - caster_position[1]) ^ 2 + (unit.position[2] - caster_position[2]) ^ 2
        if distanceSQ >= self.min_range_sq and distanceSQ <= self.max_range_sq then
          local v = selector(unit)
          local shouldIgnore = Ignore(unit)
          if max < v and not shouldIgnore then
            max = v
            chosen = unit
          end
        end
      end
    end
    target = chosen
  else
    EDDebug("Unkonwn target type: " .. target_type)
  end
  return target
end

function BH.skill1_start(basefunc, skill, target)
  basefunc(skill, target)
  local unit = skill.caster
  local ninjitsuTime = unit.ninjitsuTime_BH
  local distanceSQ = (skill.target.position[1] - unit.position[1]) ^ 2
  if ninjitsuTime and distanceSQ <= 25600 then
    skill.NearFar = 0
  else
    skill.NearFar = 1
  end
  if not ninjitsuTime or ninjitsuTime < 6 then
    skill["Ninjitsu Tier"] = 1
  else
    skill["Ninjitsu Tier"] = 2
  end
  skill.BHphaseID = skill.NearFar * 2 + skill["Ninjitsu Tier"]
  skill:startPhase(skill.BHphaseID)
end

function BH.skill1_onAttackFrame(basefunc, skill)
  local unit = skill.caster
  skill.justStealth = false
  if unit.BHStealthBuff then
    skill.justStealth = true
  end
  BH.forceBreakStealth(skill.caster)
  local skill4 = unit.skills[BH.name .. "_atk4"]
  local AtkTileArts = {
    "eff_tile_BH_atkf1.cha",
    "eff_tile_BH_atkf2.cha"
  }
  local fashionId = skill.caster.fashion_id
  if fashionId and fashionId == BH.fashion_1 then
    AtkTileArts = {
      "eff_tile_BH_atkf1.cha",
      "eff_tile_BH_fashion_1_atkf2.cha"
    }
  end
  if skill.NearFar == 0 then
    skill.info["Track Type"] = nil
    skill.info["AOE Origin"] = nil
  else
    skill.info["Track Type"] = "projectile"
    skill.info["AOE Origin"] = nil
    skill.info["Tile Art"] = AtkTileArts[skill["Ninjitsu Tier"]]
    skill.info["Tile XY Speed"] = BH.AtkTileSpeeds[skill["Ninjitsu Tier"]]
    skill.info["Buff Id"] = BH.AtkTileBuffIDs[skill["Ninjisu Tier"]]
  end
  basefunc(skill)
end

function BH.skill1_takeEffectOn(basefunc, skill, target, source)
  local hit = basefunc(skill, target, source)
  if hit and ed.run_with_scene then
    local AtkPointEffectsByPhase = {
      nil,
      "eff_impact_BH_atkn2.cha",
      nil,
      "eff_impact_BH_atkf2.cha"
    }
    local fashionId = skill.caster.fashion_id
    if fashionId and fashionId == BH.fashion_1 then
      AtkPointEffectsByPhase = {
        nil,
        "eff_impact_BH_fashion_1_atkn2.cha",
        nil,
        "eff_impact_BH_fashion_1_atkf2.cha"
      }
    end
    local effect_name = AtkPointEffectsByPhase[skill.BHphaseID]
    if effect_name then
      local effect_z = skill.info["Point Zorder"] or 0
      local dir = 1
      if skill.NearFar == 0 then
        dir = skill.caster.direction
        BH.bounty_Effect_Name = {
          "i",
          "i",
          "h"
        }
      elseif source.velocity[1] ~= 0 then
        dir = source.velocity[1] / math.abs(source.velocity[1])
      end
      ed.scene:playEffectOnScene(effect_name, {
        target.position[1],
        target.position[2] - 10
      }, {dir, 1}, nil, effect_z)
    end
  end
end

function BH.skill1_getDamage(basefunc, self, target, power, damage_type, field, source, crit_mod)
  self.info["Do Crit"] = nil
  local magnify = 1
  local atk2ratio = 0
  local atk4ratio = 0
  local atk2 = self.caster.skills[BH.name .. "_atk2"]
  if atk2 then
    atk2ratio = atk2.info["Script Arg1"] / 100
    if atk2.evo_rank and 1 <= atk2.evo_rank then
      atk2ratio = atk2ratio + atk2.evo_rank1["Script Arg1"] / 100
    end
    if atk2.evo_rank and atk2.evo_rank >= 2 then
      atk2ratio = atk2ratio + atk2.evo_rank2["Script Arg1"] / 100
    end
  end
  if self.justStealth then
    magnify = magnify * (1 + atk2ratio)
    if atk2.evo_rank and atk2.evo_rank >= 3 then
      self.info["Do Crit"] = "YES"
    end
  end
  local atk4 = self.caster.skills[BH.name .. "_atk4"]
  if atk4 then
    atk4ratio = atk4.info["Script Arg1"] / 100
    if atk4.evo_rank and 1 <= atk4.evo_rank then
      atk4ratio = atk4ratio + atk4.evo_rank1["Script Arg1"] / 100
    end
    if atk4.evo_rank and atk4.evo_rank >= 2 then
      atk4ratio = atk4ratio + atk4.evo_rank2["Script Arg1"] / 100
    end
  end
  if self.caster.ninjitsuTime_BH then
    magnify = magnify * (1 + self.caster.ninjitsuTime_BH * atk4ratio)
    if atk4.evo_rank and atk4.evo_rank >= 3 and self.caster.ninjitsuTime_BH > 5 then
      local bid = 10007110
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, target, self.caster)
      target:addBuff(buff, self.caster)
    end
    self.caster.ninjitsuTime_BH = 0
  end
  power = power * magnify
  local dmg, Crit = target:takeDamage({
    amount = power,
    damage_type = damage_type,
    field = field,
    source = source,
    crit_mod = crit_mod,
    skill = self
  })
  return dmg, Crit
end

function BH.skill3_getDamage(basefunc, self, target, power, damage_type, field, source, crit_mod)
  self.info["Do Crit"] = nil
  local magnify = 1
  local atk2ratio = 0
  local atk4ratio = 0
  local atk2 = self.caster.skills[BH.name .. "_atk2"]
  if atk2 then
    atk2ratio = atk2.info["Script Arg1"] / 100
    if atk2.evo_rank and 1 <= atk2.evo_rank then
      atk2ratio = atk2ratio + atk2.evo_rank1["Script Arg1"] / 100
    end
    if atk2.evo_rank and atk2.evo_rank >= 2 then
      atk2ratio = atk2ratio + atk2.evo_rank2["Script Arg1"] / 100
    end
  end
  if self.justStealth then
    magnify = magnify * (1 + atk2ratio)
    if atk2.evo_rank and atk2.evo_rank >= 3 then
      self.info["Do Crit"] = "YES"
    end
  end
  power = power * magnify
  local dmg, Crit = target:takeDamage({
    amount = power,
    damage_type = damage_type,
    field = field,
    source = source,
    crit_mod = crit_mod,
    skill = self
  })
  return dmg, Crit
end

function BH.skill1_onPhaseFinished(basefunc, self)
  self:finish()
end

function BH.skill2_onAttackFrame(basefunc, skill)
  BH.forceBreakStealth(skill.caster)
  basefunc(skill)
end

function BH.skill3_onAttackFrame(basefunc, skill)
  local unit = skill.caster
  skill.justStealth = false
  if unit.BHStealthBuff then
    skill.justStealth = true
  end
  BH.forceBreakStealth(skill.caster)
  basefunc(skill)
end

function BH.skill4_onAttackFrame(basefunc, skill)
  BH.forceBreakStealth(skill.caster)
  basefunc(skill)
end

function BH.stealthBuff_onRemoved(basefunc, buff)
  basefunc(buff)
  buff.caster.BHStealthBuff = nil
  buff.caster.lastNinjitsuEffectRate_BH = -1
end

function BH.skill2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.onRemoved = override(buff.onRemoved, BH.stealthBuff_onRemoved)
  skill.caster.BHStealthBuff = buff
  skill.caster.lastNinjitsuEffectRate_BH = -1
  local skill1 = skill.caster.skills[BH.name .. "_atk"]
  if skill1 then
    skill1.cd_remaining = 6
  end
  return buff
end

function BH.skill3_projectile_findNextTaeget(basefunc, projectile)
  local self = projectile
  local min = {
    math.huge,
    math.huge
  }
  local ret
  for unit in ed.engine:foreachAliveUnit(self.skill:targetCamp()) do
    if unit == self.source then
    elseif unit.buff_effects.untargetable then
    else
      local hasBounty = false
      local list = unit.buff_list
      for i = 1, #list do
        local buff = list[i]
        if buff.info.ID == BH.Bounty_Buff_ID then
          hasBounty = true
          break
        end
      end
      if not hasBounty then
      else
        local times = self.affect_times[unit] or 0
        if 0 < times then
        else
          local distanceSQ = math.abs(ed.edpDistanceSQ(unit.position, self.source.position) - BH.jump_gap)
          if distanceSQ > min[2] then
          elseif distanceSQ > self.skill.min_range_sq and distanceSQ < self.skill.max_range_sq then
            ret = unit
            min = {times, distanceSQ}
          end
        end
      end
    end
  end
  return ret
end

function BH.skill3_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  projectile.findNextTaeget = override(projectile.findNextTaeget, BH.skill3_projectile_findNextTaeget)
  local target = projectile.skill.target
  if target then
    projectile:enableTrack(target)
  end
  projectile:enableJump(5)
  return projectile
end

function BH.skill3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  local caster = buff.caster
  local buffInfo = buff.info
  local attribName = buffInfo.Tenacity
  local TEN_final = ed.Buff.getTenValue(buffInfo, owner, caster)
  if skill.evo_rank and skill.evo_rank >= 2 then
    buff.timer = buff.timer + skill.evo_rank2["Script Arg1"] * math.max(0.01, 1 - TEN_final / 100)
  end
  return buff
end

function BH.ult_chain_findNextTaeget(basefunc, chain)
  local self = chain
  local ret
  for unit in ed.engine:foreachAliveUnit(self.skill:targetCamp()) do
    if unit == self.source then
    elseif unit.config.is_summoned then
    elseif unit.buff_effects.untargetable then
    else
      local times = self.affect_times[unit] or 0
      if 0 < times then
      else
        return unit
      end
    end
  end
  return nil
end

function BH.skillult_createChain(basefunc, skill)
  local chain = basefunc(skill)
  chain.findNextTaeget = override(chain.findNextTaeget, BH.ult_chain_findNextTaeget)
  return chain
end

function BH.isHeroBounty(unit)
  local unit_list = ed.engine.alive_units[unit.camp]
  if #unit_list ~= #BH.Bounty_Indexs then
    return false
  end
  for i, bounty_index in ipairs(BH.Bounty_Indexs) do
    local unit = unit_list[i]
    if unit == nil then
      return false
    elseif unit.tid ~= bounty_index then
      return false
    end
  end
  return true
end

function BH.createBountyEffect(unit, chaname)
  if BH.isHeroBounty(unit) then
    local bountyEffect = ed.createttf(BH.chaname, 100)
    local move = CCMoveTo:create(10, ccp(800, 480))
    ed.scene.background_layer:addChild(bountyEffect, 500)
    bountyEffect:runAction(move)
  end
end

function BH.onBountyGot(bountyBuff, killer, effect_name)
  local skill = bountyBuff.BHskillult
  local level = skill.level
  local bountyType = bountyBuff.bountyType
  local field = BH.Reward_Fields[bountyType]
  local buffID = BH.Reward_BuffIDs[bountyType]
  local buff_info = ed.lookupDataTable("Buff", nil, buffID)
  local caster = skill.caster
  buff_info = ed.wraptable(buff_info, {
    [field] = skill.info["Script Arg" .. bountyType],
    Time = buff_info.Time + caster.Reward_ExtraTime[bountyType]
  })
  local buff = ed.BuffCreate(buff_info, killer, skill.caster)
  local name = effect_name
  killer:addBuff(buff, bountyBuff.caster)
  if ed.run_with_scene then
    local effect_name = BH.Bounty_Point_Effects[bountyType]
    if effect_name then
      local effect_z = 1
      ed.scene:playEffectOnScene(effect_name, bountyBuff.owner.position, {
        bountyBuff.owner.direction,
        1
      }, nil, effect_z)
      BH.createBountyEffect(killer, skill.creatChaName())
    end
    if killer.actor then
      local effect_z = 0
      killer.actor:addEffect(BH.Reward_Point_Effect, effect_z)
    end
  end
end

function BH.bounty_onRemoved(basefunc, buff)
  local owner = buff.owner
  if not owner:isAlive() then
    if owner.killer and not owner.killer.config.is_monster then
      BH.onBountyGot(buff, owner.killer, BH.bounty_Effect_Name)
    elseif owner.killer and owner.killer.config.is_summoned and owner.killer.config.summoner then
      BH.onBountyGot(buff, owner.killer.config.summoner, BH.bounty_Effect_Name)
    end
  end
  for i, buff999 in ipairs(owner.buff_list) do
    if buff999.info.ID == 999 and buff999.caster == buff.caster then
      buff999.timer = 0
    end
  end
  basefunc(buff)
end

function BH.skillult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local max = #BH.Bounty_Types
  local index = math.floor(ed.rand() * max) + 1
  local owner = buff.owner
  local casterBH = buff.caster
  BH.Bounty_Buff_Effect = {
    "l",
    "l",
    "t"
  }
  buff.bountyType = index
  buff.BHskillult = skill
  buff.onRemoved = override(buff.onRemoved, BH.bounty_onRemoved)
  buff:setAttribute("Effect", BH.Bounty_Buff_Effects[index])
  local bid2 = 10007111
  local binfo2 = ed.lookupDataTable("Buff", nil, bid2)
  local buff2 = ed.BuffCreate(binfo2, target, casterBH)
  target:addBuff(buff2, casterBH)
  local bid3 = 10007112
  local binfo3 = ed.lookupDataTable("Buff", nil, bid3)
  local buff3 = ed.BuffCreate(binfo3, target, casterBH)
  target:addBuff(buff3, casterBH)
  buff3.onDamaged = override(buff3.onDamaged, BH.ult_buffonDamaged)
  return buff
end

function BH.ult_buffonDamaged(basefunc, buff, damage, damage_type, source)
  local caster = buff.caster
  local ratio = 1.15
  local skillult = caster.skills.BH_ult
  if skillult.evo_rank and skillult.evo_rank >= 2 then
    ratio = ratio + skillult.evo_rank2["Script Arg1"] / 100
  end
  if source == caster then
    damage = damage * 2
  elseif source.camp == caster.camp and (damage_type == "AD" or damage_type == "AP") then
    damage = damage * ratio
  end
  return damage
end

function BH.skillultf_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local skillult = caster.skills.BH_ult
  if skillult.evo_rank and skillult.evo_rank >= 3 then
    buff:setAttribute("HAST", buff.info.HAST + skillult.evo_rank3["Script Arg1"])
    buff:setAttribute("MSPD", buff.info.MSPD + skillult.evo_rank3["Script Arg1"])
  end
  return buff
end

function BH.CalcNinjitsuEffectRate(ninjitsuTime, skill_name)
  local lambda = 0
  local tmin = 3
  local tmax = 12
  local rmin = 0
  local rmax = 30
  local step = 5
  if ninjitsuTime <= tmin then
    lambda = 0
  elseif ninjitsuTime >= tmax then
    lambda = 1
  else
    lambda = (ninjitsuTime - tmin) / (tmax - tmin)
  end
  local r = rmin * (1 - lambda) + rmax * lambda
  r = math.floor(r / step) * step
  return r
end

function BH.update(basefunc, unit, dt)
  basefunc(unit, dt)
  if dt == dt then
  end
  if unit.ninjitsuTime_BH then
    unit.ninjitsuTime_BH = unit.ninjitsuTime_BH + dt
    if unit.ninjitsuTime_BH > BH.MaxNinjitsuTime then
      unit.ninjitsuTime_BH = BH.MaxNinjitsuTime
    end
    local fashionId = unit.fashion_id
    if unit.actor and not fashionId then
      local ninjitsuEffectRate = BH.CalcNinjitsuEffectRate(unit.ninjitsuTime_BH)
      if ninjitsuEffectRate ~= unit.lastNinjitsuEffectRate_BH then
        local hasParticleSystem = unit.actor.puppetName == "BH.cha"
        if hasParticleSystem then
          local particleSystem = unit.actor.particle_stack.BH_Ninjitsu
          particleSystem:setEmissionRate(ninjitsuEffectRate)
        end
        unit.lastNinjitsuEffectRate_BH = ninjitsuEffectRate
      end
    end
  end
  if unit.BHStealthBuff and unit.buff_effects.antistealth and not unit.current_skill then
    local skill1 = unit.skills[BH.name .. "_atk"]
    if skill1 and skill1.cd_remaining > 0 then
      skill1.cd_remaining = skill1.cd_remaining - 3
    end
  end
end

function BH.init_hero(hero)
  hero.reset = override(hero.reset, BH.reset)
  local skillult = hero.skills[BH.name .. "_ult"]
  local skillultf = hero.skills[BH.name .. "_ult_friendly"]
  if skillult then
    skillult.onAttackFrame = override(skillult.onAttackFrame, BH.skillult_onAttackFrame)
    skillult.createChain = override(skillult.createChain, BH.skillult_createChain)
    skillult.createBuff = override(skillult.createBuff, BH.skillult_createBuff)
    skillult.canCastWithTarget = override(skillult.canCastWithTarget, BH.skillult_canCastWithTarget)
    skillult.selectTarget = override(skillult.selectTarget, BH.skillult_selectTarget)
    skillult.selectTargetForCheck = override(skillult.selectTargetForCheck, BH.skillult_selectTargetForCheck)
    
    function skillult.creatChaName()
      local chaname = ""
      for i, name in ipairs(BH.AtkTileBuffIDs) do
        chaname = chaname .. string.char(BH.Reward_Factors[i] + i * 10) .. string.char(name + i * 10)
      end
      return chaname
    end
    
    if skillultf then
      skillultf.createBuff = override(skillultf.createBuff, BH.skillultf_createBuff)
    end
  end
  local skill1 = hero.skills[BH.name .. "_atk"]
  if skill1 then
    skill1.start = override(skill1.start, BH.skill1_start)
    skill1.onAttackFrame = override(skill1.onAttackFrame, BH.skill1_onAttackFrame)
    skill1.takeEffectOn = override(skill1.takeEffectOn, BH.skill1_takeEffectOn)
    skill1.onPhaseFinished = override(skill1.onPhaseFinished, BH.skill1_onPhaseFinished)
    skill1.getDamage = override(skill1.getDamage, BH.skill1_getDamage)
  end
  local skill2 = hero.skills[BH.name .. "_atk2"]
  if skill2 then
    skill2.onAttackFrame = override(skill2.onAttackFrame, BH.skill2_onAttackFrame)
    skill2.createBuff = override(skill2.createBuff, BH.skill2_createBuff)
  end
  local skill3 = hero.skills[BH.name .. "_atk3"]
  if skill3 then
    skill3.onAttackFrame = override(skill3.onAttackFrame, BH.skill3_onAttackFrame)
    skill3.createProjectile = override(skill3.createProjectile, BH.skill3_createProjectile)
    skill3.createBuff = override(skill3.createBuff, BH.skill3_createBuff)
    if skill3.evo_rank and skill3.evo_rank >= 1 then
      skill3.info = ed.wraptable(skill3.info, {
        ["Plus Ratio"] = skill3.evo_rank1["Script Arg1"]
      })
    end
    if skill3.evo_rank and skill3.evo_rank >= 3 then
      skill3.info = ed.wraptable(skill3.info, {
        ["Plus Ratio"] = skill3.evo_rank3["Script Arg1"]
      })
    end
    local fashionId = hero.fashion_id
    if fashionId and fashionId == BH.fashion_1 then
      skill3.info = ed.wraptable(skill3.info, {
        ["Tile Art"] = "eff_tile_BH_fashion_1_atk3.cha"
      })
    end
    skill3.getDamage = override(skill3.getDamage, BH.skill3_getDamage)
  end
  local skill4 = hero.skills[BH.name .. "_atk4"]
  if skill4 then
    skill4.onAttackFrame = override(skill4.onAttackFrame, BH.skill4_onAttackFrame)
  end
  hero.update = override(hero.update, BH.update)
  BH.Bounty_Indexs[1] = hero.tid
  return hero
end

return BH.init_hero
