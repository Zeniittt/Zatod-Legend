module("ed.battlehero", package.seeall)
local ed = ed
LichTitan = {}
LichTitan.ultIce_JumpNum = 7
LichTitan.atk4_FrozenBid = 4753
LichTitan.atk3_slowBid = 4752
LichTitan.ultFrozenID = 4749
LichTitan.LichTitan_fashionID = 101651

function LichTitan.skillatk2_power(basefunc, skill, source, target, damage_type)
  local power, i = basefunc(skill, target, source, target, damage_type)
  if target and target:isAlive() and power and target.buff_effects.icefrozen then
    power = power * 2
  end
  return power, i
end

function LichTitan.skillatk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local owner = skill.owner
  if owner and owner:isAlive() and owner.buff_effects.icefrozen then
    local HAST = buff.info.HAST
    local MSPD = buff.info.MSPD
    buff:setAttribute("HAST", 2 * HAST)
    buff:setAttribute("MSPD", 2 * MSPD)
  end
  return buff
end

function LichTitan.skillatk12_takeEffectOn(basefunc, skill, target, source, shift)
  local isHit, dmg = basefunc(skill, target, source, shift)
  local caster = skill.caster
  if caster and isHit then
    local skillatk4s = caster.skills.LichTitan_atk4s
    if target and skillatk4s and not target.buff_effects.invulnerable and not target.buff_effects.uncontrollable then
      local ratio = ed.rand()
      local FrozenRatio = skillatk4s.info["Script Arg3"] / 100
      local MPR_Down = skillatk4s.info["Script Arg2"]
      local FrozenTime = skillatk4s.info["Script Arg4"]
      if ratio >= FrozenRatio then
        local bid = LichTitan.atk4_FrozenBid
        local binfo = ed.lookupDataTable("Buff", nil, bid)
        local buff = ed.BuffCreate(binfo, target, caster)
        buff:setAttribute("MPR", MPR_Down)
        local con_temp = 0
        if caster.attribs.CON then
          con_temp = caster.attribs.CON
        end
        buff.timer = math.floor((1 + con_temp) / 100) * FrozenTime + 3
        target:addBuff(buff, caster)
      end
    end
  end
  return isHit, dmg
end

function LichTitan.skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = buff.caster
  if skill and buff then
    local PIMU = skill.info["Script Arg2"]
    local MIMU = skill.info["Script Arg2"]
    buff:setAttribute("PIMU", PIMU)
    buff:setAttribute("MIMU", MIMU)
    buff.onDamaged = override(buff.onDamaged, LichTitan.atk3buff_onDamaged)
    if LichTitan.LichTitan_fashionID and caster.fashion_id == LichTitan.LichTitan_fashionID then
      buff:setAttribute("Effect", "eff_buff_LichTitan_skin_atk3.cha")
    end
  end
  return buff
end

function LichTitan.atk3buff_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred)
  local damage = basefunc(buff, damage, damage_type, source, skill, transferred)
  local caster = buff.caster
  local skillatk3 = caster.skills.LichTitan_atk3
  local HAST = skillatk3.info["Script Arg3"]
  local MSPD = skillatk3.info["Script Arg3"]
  if skill and 0 < damage then
    local caster = buff.caster
    local owner = buff.owner
    if owner and owner:isAlive() and source then
      local bid = LichTitan.atk3_slowBid
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, source, caster)
      buff:setAttribute("HAST", HAST)
      buff:setAttribute("MSPD", MSPD)
      source:addBuff(binfo, caster)
    end
  end
  return damage
end

function LichTitan.skillult_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  projectile:enableJump(8)
  projectile.can_be_influenced = false
  projectile.jumps = LichTitan.ultIce_JumpNum
  projectile.hit = override(projectile.hit, LichTitan.ult_projectile_hit)
  projectile:enableTrack(skill.target)
  
  function projectile:findNextTaeget()
    local min = math.huge
    local ret
    for unit in ed.engine:foreachAliveUnit(self.skill:targetCamp()) do
      if unit == self.source then
      elseif unit.buff_effects.untargetable then
      elseif unit.buffManager.invisible and unit.camp ~= skill.caster.camp then
      else
        local distanceSQ = ed.edpDistanceSQ(unit.position, self.source.position)
        if min < distanceSQ then
        elseif distanceSQ > self.skill.min_range_sq and distanceSQ < self.skill.max_range_sq then
          ret = unit
          min = distanceSQ
        end
      end
    end
    return ret
  end
  
  return projectile
end

function LichTitan.ult_projectile_hit(basefunc, tile, target)
  local skillult = tile.skill
  local origin_info = skillult.info
  local caster = tile.caster
  local jumpSum = LichTitan.ultIce_JumpNum - tile.jumps
  local addNum = skillult.info["Basic Num"] * 1.1 ^ jumpSum
  local basicNum = skillult.info["Basic Num"]
  skillult.info = ed.wraptable(skillult.info, {
    ["Basic Num"] = basicNum + addNum
  })
  basefunc(tile, target)
  skillult.info = origin_info
end

function LichTitan.skillult_power(basefunc, skill, source, target, damage_type)
  local power, i = basefunc(skill, target, source, target, damage_type)
  if target and target:isAlive() and power and target.buff_effects.icefrozen then
    power = power * 2
  end
  return power, i
end

function LichTitan.skillult_takeEffectOn(basefunc, skill, target, source, shift)
  local isHit, dmg = basefunc(skill, target, source, shift)
  local caster = skill.caster
  local skillatk4s = caster.skills.LichTitan_atk4s
  if isHit and target:isAlive() then
    if skillatk4s and caster and target and not target.buff_effects.invulnerable and not target.buff_effects.uncontrollable then
      local ratio = ed.rand()
      local FrozenRatio = skillatk4s.info["Script Arg3"] / 100
      local MPR_Down = skillatk4s.info["Script Arg2"]
      local FrozenTime = skillatk4s.info["Script Arg4"]
      if ratio >= FrozenRatio then
        local bid = LichTitan.atk4_FrozenBid
        local binfo = ed.lookupDataTable("Buff", nil, bid)
        local buff = ed.BuffCreate(binfo, target, caster)
        if MPR_Down then
          buff:setAttribute("MPR", MPR_Down)
        end
        local con_temp = 0
        if caster.attribs.CON then
          con_temp = caster.attribs.CON
        end
        buff.timer = math.floor((1 + con_temp) / 100) * FrozenTime + 3
        target:addBuff(buff, caster)
      end
    end
    if not target.has_hit then
      target.has_hit = 0
    else
      target.has_hit = target.has_hit + 1
    end
    if target.has_hit == 3 then
      for i, tbuff in ipairs(caster.buff_list) do
        if tbuff.info.ID == LichTitan.atk4FrozenID then
          tbuff.timer = -1
        end
      end
      local bid = LichTitan.ultFrozenID
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, target, caster)
      local ultFrozenTime = skill.info["Script Arg2"]
      if skillatk4s then
        local MPR_Down = skillatk4s.info["Script Arg2"]
        if MPR_Down then
          buff:setAttribute("MPR", MPR_Down)
        end
      end
      local con_temp = 0
      if caster.attribs.CON then
        con_temp = caster.attribs.CON
      end
      buff.timer = math.floor((1 + con_temp) / 100) * ultFrozenTime
      target:addBuff(buff, caster)
    end
  end
  return isHit, dmg
end

function LichTitan.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  local skillatk3 = hero.skills.LichTitan_atk3
  if skillatk3 then
    if not hero.getLichTitan_Atk3Arm then
      skillatk3:takeEffectOn(hero)
      hero.getLichTitan_Atk3Arm = true
    end
    if LichTitan.LichTitan_fashionID and hero.fashion_id == LichTitan.LichTitan_fashionID then
      for unit in ed.engine:foreachAliveUnit(hero.camp) do
        if not unit.getLichTitan_Atk3Arm then
          skillatk3:takeEffectOn(unit)
          unit.getLichTitan_Atk3Arm = true
        end
      end
    end
  end
end

function LichTitan.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.getLichTitan_Atk3Arm = false
end

function LichTitan.init_hero(hero)
  local skillult = hero.skills.LichTitan_ult
  local skillatk = hero.skills.LichTitan_atk
  local skillatk2 = hero.skills.LichTitan_atk2
  local skillatk3 = hero.skills.LichTitan_atk3
  local skillatk4 = hero.skills.LichTitan_atk4
  local skillatk4s = hero.skills.LichTitan_atk4s
  hero.update = override(hero.update, LichTitan.hero_update)
  hero.reset = override(hero.reset, LichTitan.hero_reset)
  if skillult then
    skillult.createProjectile = override(skillult.createProjectile, LichTitan.skillult_createProjectile)
    skillult.power = override(skillult.power, LichTitan.skillult_power)
    skillult.takeEffectOn = override(skillult.takeEffectOn, LichTitan.skillult_takeEffectOn)
    if LichTitan.LichTitan_fashionID and hero.fashion_id == LichTitan.LichTitan_fashionID then
      local originfo = skillult.info
      skillult.info = ed.wraptable(originfo, {
        ["Tile Art"] = "eff_tile_LichTitan_skin_ult.cha",
        ["Point Effect"] = "eff_point_LichTitan_skin_ult.cha"
      })
    end
  end
  if skillatk then
    if LichTitan.LichTitan_fashionID and hero.fashion_id == LichTitan.LichTitan_fashionID then
      local originfo = skillatk.info
      skillatk.info = ed.wraptable(originfo, {
        ["Tile Art"] = "eff_tile_LichTitan_skin_atk.cha"
      })
    end
    if skillatk4s then
      skillatk.takeEffectOn = override(skillatk.takeEffectOn, LichTitan.skillatk12_takeEffectOn)
    end
  end
  if skillatk2 then
    skillatk2.createBuff = override(skillatk2.createBuff, LichTitan.skillatk2_createBuff)
    skillatk2.power = override(skillatk2.power, LichTitan.skillatk2_power)
    if skillatk4s then
      skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, LichTitan.skillatk12_takeEffectOn)
    end
    if LichTitan.LichTitan_fashionID and hero.fashion_id == LichTitan.LichTitan_fashionID then
      local originfo = skillatk2.info
      skillatk2.info = ed.wraptable(originfo, {
        ["Point Effect"] = "eff_point_LichTitan_skin_atk2.cha"
      })
    end
  end
  if skillatk3 then
    skillatk3.createBuff = override(skillatk3.createBuff, LichTitan.skillatk3_createBuff)
  end
  return hero
end

return LichTitan.init_hero
