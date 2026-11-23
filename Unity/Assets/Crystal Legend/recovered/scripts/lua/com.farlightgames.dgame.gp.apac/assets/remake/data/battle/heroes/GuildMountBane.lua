module("ed.battlehero", package.seeall)
local ed = ed
GuildMountBane = {}

function GuildMountBane.GuildMountBaneult_basefunc(basefunc, skill)
  skill.attack_counter = skill.attack_counter + 1
  if (skill.info["Target Type"] == "random" or skill.target == nil or not skill.target:isAlive()) and skill.attack_counter == 1 then
    skill:selectTarget(nil)
  end
  if not skill.target then
    return
  end
  local info = skill.info
  local caster = skill.caster
  local ttype = info["Track Type"]
  local MPGR = caster.attribs.MPGainRatio or 0
  if ttype == "projectile" then
    local projectile = skill:createProjectile()
    ed.engine:addProjectile(projectile)
  elseif ttype == "chain" then
    local chain = skill:createChain()
    ed.engine:addChain(chain)
  elseif ttype == nil then
    skill:takeEffectAt(skill.target.position)
  else
    EDDebug("Unkonwn Track Type: '" .. ttype .. "'")
  end
  if MPGR then
    caster:setMP(caster.mp + info["Gain MP"] * ed.engine.mp_bonus * (1 + MPGR / 100))
  end
  if info["Move Forward"] ~= 0 then
    caster.position[1] = caster.position[1] + info["Move Forward"] * caster.direction
  end
end

function GuildMountBane.skillult_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local target = skill.target
  local attack_counter = skill.attack_counter
  if attack_counter == 0 then
    GuildMountBane.GuildMountBaneult_basefunc(basefunc, skill)
    local bid = 12004104
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = caster:addBuff(binfo, caster)
  else
    if skill.caster.manually_casting and skill.attack_counter == 1 then
      ed.engine:unfreeze()
      skill.caster.manually_casting = false
    end
    skill.attack_counter = skill.attack_counter + 1
    if target and target:isAlive() then
      local havebuff = false
      for i, tbuff in ipairs(target.buff_list) do
        if tbuff.info.ID == 12004101 and tbuff.caster == caster then
          havebuff = true
        end
      end
      if havebuff then
        local skillult2 = caster.skills.GuildMountBane_ult2
        if skillult2 and target then
          skillult2:takeEffectOn(target)
        end
      else
        skill:finish()
      end
    else
      skill:finish()
    end
  end
end

function GuildMountBane.skillult_finish(basefunc, skill)
  basefunc(skill)
  if skill.target then
    for i, tbuff in ipairs(skill.target.buff_list) do
      if tbuff.info.ID == 12004101 and tbuff.caster == skill.caster then
        tbuff.timer = -1
        break
      end
    end
  end
  for i, tbuff in ipairs(skill.caster.buff_list) do
    if tbuff.info.ID == 12004104 then
      tbuff.timer = -1
    end
  end
end

function GuildMountBane.skillult2_takeEffectOn(basefunc, skill, target, source)
  local buff = false
  for i, tbuff in ipairs(target.buff_list) do
    if tbuff.info.ID == 12004101 and tbuff.caster == skill.caster then
      buff = true
      break
    end
  end
  if not buff and skill.caster.current_skill and skill.caster.current_skill.info["Skill Name"] == "GuildMountBane_ult" then
    skill.caster:hurt()
    return false
  end
  basefunc(skill, target, source)
end

function GuildMountBane.GuildMountBaneult_castManualSkill(basefunc, hero)
  basefunc(hero)
  local target = hero.skills.GuildMountBane_ult.target
  if target and hero.name ~= "Rubick" then
    target:unfreezeActor()
  end
end

function GuildMountBane.skillatk2_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local bid = 12004105
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
end

function GuildMountBane.skillatk2_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  if attack_counter == 0 then
    basefunc(skill)
  end
end

function GuildMountBane.skillatk2_finish(basefunc, skill)
  basefunc(skill)
  for i, tbuff in ipairs(skill.caster.buff_list) do
    if tbuff.info.ID == 12004105 then
      tbuff.timer = -1
    end
  end
end

function GuildMountBane.skillatk3_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local bid = 12004106
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = ed.BuffCreate(binfo, caster, caster)
  caster:addBuff(buff, caster)
end

function GuildMountBane.skillatk2_takeEffectOn(basefunc, skill, target, source, shift)
  local isHit, dmg = basefunc(skill, target, source, shift)
  local caster = skill.caster
  if target and ed.run_with_scene then
    local effect_name = "eff_impact_Bane_atk2.cha"
    local effect_z = 1
    ed.scene:playEffectOnScene(effect_name, target.position, {
      target.direction,
      1
    }, nil, effect_z)
  end
  return isHit, dmg
end

function GuildMountBane.skillatk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local Buff_AD = buff.info.AD
  if skill.evo_rank and skill.evo_rank >= 1 then
    buff:setAttribute("AD", Buff_AD - skill.evo_rank1["Script Arg1"])
  end
  if skill.evo_rank and skill.evo_rank >= 2 then
    buff:setAttribute("HAST", -skill.evo_rank2["Script Arg1"])
    buff:setAttribute("MSPD", -skill.evo_rank2["Script Arg1"])
  end
  if skill.evo_rank and skill.evo_rank >= 3 then
    buff.timer = buff.timer + 1
  end
  return buff
end

function GuildMountBane.skillatk3_takeEffectOn(basefunc, skill, target)
  local isHit, dmg = basefunc(skill, target)
  local caster = skill.caster
  local info = skill.info
  local multiplier = info["Plus Ratio"]
  local base_attrib = info["Plus Attr"] and caster.attribs[info["Plus Attr"]] or 0
  local power = multiplier * base_attrib + info["Basic Num"]
  if isHit and dmg and 0 < dmg then
    caster:takeHeal(power, "hp", caster)
  end
  return isHit, dmg
end

function GuildMountBane.skillatk4_buff_onRemoved(basefunc, buff)
  local owner = buff.owner
  local caster = buff.caster
  local skillatk4 = caster.skills.GuildMountBane_atk4
  local nearestUnit
  local nearestDistance = math.huge
  for unit in ed.engine:foreachAliveUnit(skillatk4:affectedCamp()) do
    if not unit.buff_effects.untargetable then
      local d = ed.edpDistanceSQ(unit.position, owner.position)
      if nearestDistance > d and unit ~= owner then
        nearestUnit = unit
        nearestDistance = d
      end
    end
  end
  if not buff.GuildMountBane_affecttime then
    buff.GuildMountBane_affecttime = 0
  end
  if nearestUnit and owner.GuildMountBane_dream ~= "break" and buff.GuildMountBane_affecttime <= 3 and not ed.engine.beingEnd then
    local newbuff = nearestUnit:addBuff(skillatk4:createBuff(nearestUnit))
    if skillatk4.evo_rank and 3 <= skillatk4.evo_rank then
      caster:takeHeal(skillatk4.evo_rank3["Script Arg1"], "mp", caster)
    end
    owner.GuildMountBane_dream = 0
    if newbuff then
      newbuff.GuildMountBane_affecttime = buff.GuildMountBane_affecttime + 1
    end
  end
  basefunc(buff)
end

function GuildMountBane.skillatk4_buff_onDamaged(basefunc, buff, damage, damage_type)
  local owner = buff.owner
  local remaindamage = basefunc(buff, damage, damage_type)
  buff.timer = 0
  owner.GuildMountBane_dream = "break"
  return remaindamage
end

function GuildMountBane.skillatk4_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  owner.GuildMountBane_dream = 0
  buff.onRemoved = override(buff.onRemoved, GuildMountBane.skillatk4_buff_onRemoved)
  buff.onDamaged = override(buff.onDamaged, GuildMountBane.skillatk4_buff_onDamaged)
  if skill.evo_rank and skill.evo_rank >= 1 then
    buff:setAttribute("MPR", -skill.evo_rank1["Script Arg1"])
  end
  if skill.evo_rank and skill.evo_rank >= 2 then
    local HPR = buff.info.HPR
    local HPR_Ratio = skill.evo_rank2["Script Arg1"] / 100
    buff:setAttribute("HPR", (HPR_Ratio + 1) * HPR)
  end
  return buff
end

function GuildMountBane.reset(basefunc, unit)
  basefunc(unit)
  unit.GuildMountBane_dream = 0
  unit.GuildMountBane_affecttime = 0
end

function GuildMountBane.init_hero(hero)
  local skillult = hero.skills.GuildMountBane_ult
  local skillatk2 = hero.skills.GuildMountBane_atk2
  local skillatk3 = hero.skills.GuildMountBane_atk3
  local skillatk4 = hero.skills.GuildMountBane_atk4
  local skillult2 = hero.skills.GuildMountBane_ult2
  hero.reset = override(hero.reset, GuildMountBane.reset)
  if skillatk2 then
    skillatk2.start = override(skillatk2.start, GuildMountBane.skillatk2_start)
    skillatk2.finish = override(skillatk2.finish, GuildMountBane.skillatk2_finish)
    skillatk2.createBuff = override(skillatk2.createBuff, GuildMountBane.skillatk2_createBuff)
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, GuildMountBane.skillatk2_takeEffectOn)
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, GuildMountBane.skillatk2_onAttackFrame)
  end
  if skillatk3 then
    skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, GuildMountBane.skillatk3_takeEffectOn)
    skillatk3.finish = override(skillatk3.finish, GuildMountBane.skillatk3_finish)
    if skillatk3.evo_rank and skillatk3.evo_rank >= 1 then
      skillatk3.info = ed.wraptable(skillatk3.info, {
        ["Plus Ratio"] = skillatk3.evo_rank1["Script Arg1"]
      })
    end
    if skillatk3.evo_rank and skillatk3.evo_rank >= 2 then
      skillatk3.info = ed.wraptable(skillatk3.info, {
        ["Plus Ratio"] = skillatk3.evo_rank2["Script Arg1"]
      })
    end
    if skillatk3.evo_rank and skillatk3.evo_rank >= 3 then
      skillatk3.info = ed.wraptable(skillatk3.info, {
        ["Plus Ratio"] = skillatk3.evo_rank3["Script Arg1"]
      })
    end
  end
  if skillatk4 then
    skillatk4.createBuff = override(skillatk4.createBuff, GuildMountBane.skillatk4_createBuff)
  end
  if skillult then
    skillult.onAttackFrame = override(skillult.onAttackFrame, GuildMountBane.skillult_onAttackFrame)
    skillult.finish = override(skillult.finish, GuildMountBane.skillult_finish)
    hero.castManualSkill = override(hero.castManualSkill, GuildMountBane.GuildMountBaneult_castManualSkill)
    if skillult.evo_rank and skillult.evo_rank >= 1 and skillult2 and skillult2 then
      skillult2.info = ed.wraptable(skillult2.info, {
        ["Plus Ratio"] = skillult.evo_rank1["Script Arg1"]
      })
    end
    if skillult.evo_rank and skillult.evo_rank >= 2 and skillult2 and skillult2 then
      skillult2.info = ed.wraptable(skillult2.info, {
        ["Plus Ratio"] = skillult.evo_rank2["Script Arg1"]
      })
    end
    if skillult.evo_rank and skillult.evo_rank >= 3 and skillult2 and skillult2 then
      skillult2.info = ed.wraptable(skillult2.info, {
        ["Plus Ratio"] = skillult.evo_rank3["Script Arg1"]
      })
    end
  end
  if skillult2 then
    skillult2.takeEffectOn = override(skillult2.takeEffectOn, GuildMountBane.skillult2_takeEffectOn)
  end
  return hero
end

return GuildMountBane.init_hero
