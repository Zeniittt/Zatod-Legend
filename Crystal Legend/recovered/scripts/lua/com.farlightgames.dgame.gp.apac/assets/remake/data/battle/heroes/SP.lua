module("ed.battlehero", package.seeall)
local ed = ed
SP = {}

function SP.skillult_selectTarget(basefunc, skill, default)
  local max = -math.huge
  local caster = skill.caster
  local chosen = caster
  local caster_position = caster.position
  local enchanted = caster.buff_effects.enchanted
  local enchantedbyself = caster.buff_effects.enchantedbyself
  for unit in ed.engine:foreachAliveUnit(skill:targetCamp()) do
    if unit.buff_effects.untargetable then
    elseif unit.buffManager.invisible and unit.camp ~= caster.camp then
    elseif enchanted and unit == caster then
    elseif enchantedbyself and unit == caster then
    elseif skill:targetCamp() == skill.caster.camp and unit.controlledTarget then
    elseif unit.config.is_summoned then
    elseif unit.buff_effects.building then
    else
      local distanceSQ = (unit.position[1] - caster_position[1]) ^ 2 + (unit.position[2] - caster_position[2]) ^ 2
      if distanceSQ >= skill.min_range_sq and distanceSQ <= skill.max_range_sq then
        local v = -unit.hp
        if max < v then
          max = v
          chosen = unit
        end
      end
    end
  end
  skill.target = chosen
  return chosen
end

function SP.skillult_createChain(basefunc, skill)
  local caster = skill.caster
  local chain = basefunc(skill)
  chain.findNextTaeget = override(chain.findNextTaeget, SP.skillult_chain_findNextTaeget)
  return chain
end

function SP.skillult_chain_findNextTaeget(basefunc, self)
  local min = math.huge
  local max = -math.huge
  local ret
  for unit in ed.engine:foreachAliveUnit(self.skill:targetCamp()) do
    if unit == self.source then
    elseif unit.buff_effects.untargetable then
    elseif unit.buffManager.invisible and unit.camp ~= self.skill.caster.camp then
    elseif unit.config.is_summoned then
    elseif unit.buff_effects.building then
    else
      local times = self.affect_times[unit] or 0
      if 0 < times then
      else
        local distanceSQ = math.abs(ed.edpDistanceSQ(unit.position, self.source.position) - 6400)
        local v = -unit.hp
        if distanceSQ > self.skill.min_range_sq and distanceSQ < self.skill.max_range_sq and max < v then
          max = v
          ret = unit
          min = times
        end
      end
    end
  end
  return ret
end

function SP.skillatk3_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local maxdmg = buff.owner.hp - 1
  local owner = buff.owner
  local pimu = owner.attribs.PIMU
  local mimu = owner.attribs.MIMU
  local immunity
  if damage_type == "AD" then
    immunity = pimu or 0
  elseif damage_type == "AP" then
    immunity = mimu or 0
  elseif damage_type == "Holy" then
    immunity = 0
  end
  local turedamage
  if immunity then
    turedamage = math.max(0, damage * (100 - immunity) / 100)
  end
  if field == "mp" then
    return damage
  elseif damage <= maxdmg then
    if turedamage then
      if maxdmg < turedamage then
        return maxdmg / ((100 - immunity) / 100)
      else
        return damage
      end
    else
      return damage
    end
  elseif maxdmg < turedamage then
    local absorption = damage - maxdmg
    if absorption < buff.shield then
      buff.shield = buff.shield - absorption
      if owner.actor then
        local color = owner.camp == ed.emCampPlayer and "blue" or "red"
        ed.PopupCreate("funeral", color, owner.actor, nil, "text")
      end
    else
      absorption = buff.shield
      buff.shield = 0
      buff.owner:removeBuff(buff)
    end
    if immunity then
      return maxdmg / ((100 - immunity) / 100)
    else
      return maxdmg
    end
  else
    return damage
  end
end

function SP.skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local buffInfo = buff.info
  local owner = buff.owner
  local caster = buff.caster
  if skill.evo_rank and skill.evo_rank >= 1 then
    buff.timer = skill.evo_rank1["Script Arg1"]
  end
  if skill.evo_rank and skill.evo_rank >= 2 then
    buff.timer = skill.evo_rank2["Script Arg1"]
  end
  if skill.evo_rank and skill.evo_rank >= 3 then
    buff.timer = skill.evo_rank3["Script Arg1"]
  end
  buff.onDamaged = override(buff.onDamaged, SP.skillatk3_onDamaged)
  return buff
end

function SP.skillatk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local hpr = buff.info.HPR
  if skill.evo_rank and skill.evo_rank >= 2 then
    buff:setAttribute("HPR", hpr - skill.evo_rank2["Script Arg1"])
  end
  return buff
end

function SP.init_hero(hero)
  local skillult = hero.skills.SP_ult
  local skillatk2 = hero.skills.SP_atk2
  local skillatk3 = hero.skills.SP_atk3
  local skillaura = hero.aura_skill_list[1]
  if skillult then
    skillult.selectTarget = override(skillult.selectTarget, SP.skillult_selectTarget)
    skillult.createChain = override(skillult.createChain, SP.skillult_createChain)
    if skillult.evo_rank and 1 <= skillult.evo_rank then
      skillult.info = ed.wraptable(skillult.info, {
        ["Plus Ratio"] = skillult.evo_rank1["Script Arg1"]
      })
    end
    if skillult.evo_rank and skillult.evo_rank >= 2 then
      skillult.info = ed.wraptable(skillult.info, {
        ["Plus Ratio"] = skillult.evo_rank2["Script Arg1"]
      })
    end
    if skillult.evo_rank and skillult.evo_rank >= 3 then
      skillult.info = ed.wraptable(skillult.info, {
        ["Chain Jumps"] = skillult.evo_rank3["Script Arg1"] + 1
      })
    end
  end
  if skillatk2 then
    if skillatk2.evo_rank and 1 <= skillatk2.evo_rank then
      skillatk2.info = ed.wraptable(skillatk2.info, {
        ["Plus Ratio"] = skillatk2.evo_rank1["Script Arg1"]
      })
    end
    if skillatk2.evo_rank and skillatk2.evo_rank >= 2 then
      skillatk2.createBuff = override(skillatk2.createBuff, SP.skillatk2_createBuff)
    end
    if skillatk2.evo_rank and skillatk2.evo_rank >= 3 then
      skillatk2.info = ed.wraptable(skillatk2.info, {
        ["Plus Ratio"] = skillatk2.evo_rank3["Script Arg1"]
      })
    end
  end
  if skillatk3 then
    skillatk3.createBuff = override(skillatk3.createBuff, SP.skillatk3_createBuff)
  end
  if skillaura then
    local aname = skillaura["Passive Attr"]
    local num = skillaura["Basic Num"]
    if skillaura.evo_rank and 1 <= skillaura.evo_rank then
      skillaura["Basic Num"] = skillaura["Basic Num"] + skillaura.evo_rank1["Script Arg1"]
    end
    if skillaura.evo_rank and skillaura.evo_rank >= 2 then
      skillaura["Basic Num"] = skillaura["Basic Num"] + skillaura.evo_rank2["Script Arg1"]
    end
    if skillaura.evo_rank and skillaura.evo_rank >= 3 then
      skillaura["Basic Num"] = skillaura["Basic Num"] + skillaura.evo_rank3["Script Arg1"]
    end
  end
  return hero
end

return SP.init_hero
