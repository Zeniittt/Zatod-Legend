module("ed.battlehero", package.seeall)
local ed = ed
WW = {}
WW.shape = "circle"
WW.arg1 = 220
WW.arg2 = 0
WW.fashion_id_1 = 921

function WW.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.wwatk2count = 0
end

function WW.skillatk2_takeEffectOn(basefunc, skill, target, source)
  local hero = skill.caster
  local skillatk2s = hero.skills.WW_atk2s
  basefunc(skill, target, source)
  for unit in ed.engine:foreachAliveUnit(skill:affectedCamp()) do
    local p2 = ed.edpSub(unit.position, target.position)
    if unit ~= target and ed.Skill.testPointInShape(p2, WW.shape, WW.arg1, WW.arg2) and not unit.buff_effects.untargetable then
      local projectile = skillatk2s:createProjectile()
      projectile.position = {
        target.position[1],
        target.position[2]
      }
      projectile.height = 40
      projectile:enableTrack(unit)
      ed.engine:addProjectile(projectile)
    end
  end
end

function WW.skillatk3Andawake_selectTarget(basefunc, self, default)
  local selector = self:target_selector()
  if selector then
    local max = -math.huge
    local chosen
    local caster = self.caster
    local caster_position = caster.position
    local enchanted = caster.buff_effects.enchanted
    for unit in ed.engine:foreachAliveUnit(self:targetCamp()) do
      if unit.current_skill and unit.current_skill.info.Manual == true then
      elseif unit.config.is_summoned then
      elseif unit.buff_effects.uncontrollable then
      elseif unit.buff_effects.untargetable then
      elseif unit.buffManager.invisible and unit.camp ~= caster.camp then
      elseif self:targetCamp() == self.caster.camp and unit.controlledTarget then
      elseif enchanted and unit == caster then
      else
        local distanceSQ = (unit.position[1] - caster_position[1]) ^ 2 + (unit.position[2] - caster_position[2]) ^ 2
        if distanceSQ >= self.min_range_sq and distanceSQ <= self.max_range_sq then
          local v = selector(unit)
          if max < v then
            max = v
            chosen = unit
          end
        end
      end
    end
    self.target = chosen
    return self.target
  end
end

function WW.skillatk3_canCastWithTarget(basefunc, skill, target)
  local Healcount = 0
  local caster = skill.caster
  for unit in ed.engine:foreachAliveUnit(caster.camp) do
    if not unit.config.is_summoned and unit.hp <= 0.5 * unit.attribs.HP then
      Healcount = Healcount + 1
    end
  end
  if Healcount == 0 then
    return false
  else
    return basefunc(skill, target)
  end
end

function WW.skillult_canCastWithTarget(basefunc, skill, target)
  local caster = skill.caster
  if target then
    for unit in ed.engine:foreachAliveUnit(target.camp) do
      for i, tbuff in ipairs(unit.buff_list) do
        if tbuff.info.ID == 10009204 then
          return false
        end
      end
    end
  end
  return basefunc(skill, target)
end

function WW.skillatk3_createBuff(basefunc, skill, target)
  local caster = skill.caster
  local buff = basefunc(skill, target)
  if WW.fashion_id_1 and WW.fashion_id_1 == caster.fashion_id then
    buff:setAttribute("Effect", "eff_buff_WW_fashion_1_atk3.cha")
  end
  if skill.evo_rank and skill.evo_rank >= 1 then
    local HPRA = skill.evo_rank1["Script Arg1"]
    buff:setAttribute("HPR.a", HPRA)
  end
  if skill.evo_rank and skill.evo_rank >= 2 then
    local MPR = skill.evo_rank2["Script Arg1"]
    buff:setAttribute("MPR", MPR)
  end
  if skill.evo_rank and skill.evo_rank >= 3 and target then
    target:takeHeal(skill.evo_rank3["Script Arg1"] * caster.attribs.AP, "hp", caster)
  end
  return buff
end

function WW.skillatk4_createBuff(basefunc, skill, target)
  local caster = skill.caster
  local buff = basefunc(skill, target)
  if WW.fashion_id_1 and WW.fashion_id_1 == caster.fashion_id then
    buff:setAttribute("Effect", "eff_buff_WW_fashion_1_atk4.cha")
  end
  local HPR = skill.info["Basic Num"] + skill.info["Script Arg2"] * caster.attribs.AP
  if skill.evo_rank and skill.evo_rank >= 3 then
    local extraHPR = math.min(skill.evo_rank3["Script Arg1"] * target.attribs.HP, 3 * caster.attribs.AP)
    HPR = HPR + extraHPR
  end
  buff:setAttribute("HPR", -HPR)
  return buff
end

function WW.atk4Projectile_hit(basefunc, projectile, target)
  if target ~= projectile.skill.target then
    return
  else
    basefunc(projectile, target)
    if not projectile.terminated then
      projectile:terminate()
    end
  end
end

function WW.skillult_selectTarget(basefunc, self, default)
  local selector = self:target_selector()
  if selector then
    local max = -math.huge
    local chosen
    local caster = self.caster
    local caster_position = caster.position
    local enchanted = caster.buff_effects.enchanted
    for unit in ed.engine:foreachAliveUnit(self:targetCamp()) do
      if unit.config.is_summoned then
      elseif unit.buff_effects.untargetable then
      elseif unit.buff_effects.uncontrollable then
      elseif unit.buffManager.invisible and unit.camp ~= caster.camp then
      elseif enchanted and unit == caster then
      else
        local distanceSQ = (unit.position[1] - caster_position[1]) ^ 2 + (unit.position[2] - caster_position[2]) ^ 2
        if distanceSQ >= self.min_range_sq and distanceSQ <= self.max_range_sq then
          local v = selector(unit)
          if max < v then
            max = v
            chosen = unit
          end
        end
      end
    end
    self.target = chosen
    return self.target
  end
end

function WW.skillult_takeEffectOn(basefunc, skill, target, source)
  local hero = skill.caster
  local skillults = hero.skills.WW_ults
  basefunc(skill, target, source)
  for i, buff in ipairs(target.buff_list) do
    if buff.info.ID == 10009204 and buff.caster == hero then
      hero.WWultTarget = target
      skillults:takeEffectAt(target.position)
    end
  end
end

function WW.skillults_takeEffectOn(basefunc, skill, target, source)
  local originfo = skill.info
  local hero = skill.caster
  local skillult = hero.skills.WW_ult
  if skillult.evo_rank and skillult.evo_rank >= 3 then
    if target == hero.WWultTarget or target.buff_effects.building then
      local buff_info = skill.info.buff_info
      skill.info = ed.wraptable(originfo, {
        buff_info = ed.wraptable(buff_info, {
          Time = buff_info.Time + skillult.evo_rank3["Script Arg1"]
        }),
        ["Buff ID"] = 0
      })
    elseif target ~= hero.WWultTarget and not target.buff_effects.building then
      local buff_info = skill.info.buff_info
      skill.info = ed.wraptable(originfo, {
        buff_info = ed.wraptable(buff_info, {
          Time = buff_info.Time + skillult.evo_rank3["Script Arg1"]
        }),
        ["Buff ID"] = 10009205
      })
    end
  elseif target == hero.WWultTarget or target.buff_effects.building then
    skill.info = ed.wraptable(originfo, {
      ["Buff ID"] = 0
    })
  elseif target ~= hero.WWultTarget and not target.buff_effects.building then
    skill.info = ed.wraptable(originfo, {
      ["Buff ID"] = 10009205
    })
  end
  basefunc(skill, target, source)
  skill.info = originfo
end

function WW.skillults_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local basicskill = target.basic_skill
  basicskill.cd_remaining = 0
  target.global_cd = 0
  local caster = skill.caster
  if WW.fashion_id_1 and WW.fashion_id_1 == caster.fashion_id then
    buff:setAttribute("Effect", "eff_buff_WW_fashion_1_ults.cha")
  end
  return buff
end

function WW.WWult_buff_OnRemoved(basefunc, buff)
  basefunc(buff)
  local owner = buff.owner
  for unit in ed.engine:foreachAliveUnit(owner.camp) do
    if unit.camp == owner.camp then
      for i, buff in ipairs(unit.buff_list) do
        if buff.info.ID == 10009205 then
          buff.owner:removeBuff(buff)
        end
      end
    end
  end
end

function WW.skillult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.onRemoved = override(buff.onRemoved, WW.WWult_buff_OnRemoved)
  local caster = skill.caster
  if WW.fashion_id_1 and WW.fashion_id_1 == caster.fashion_id then
    buff:setAttribute("Effect", "eff_buff_WW_fashion_1_ult.cha")
  end
  return buff
end

function WW.setHP(basefunc, unit, hp, reason)
  local hero = unit
  local skill = hero.skills.WW_atk3
  local hpchange = basefunc(unit, hp, reason)
  if hpchange < 0 and 0 < unit.hp and not unit.manual_skill.casting then
    local hpp = skill.info["Script Arg2"] / 100
    local hpnow = hero.hp / hero.attribs.HP
    if hpp >= hpnow and hero.wwatk2count == 0 then
      hero.wwatk2count = 1
      hero:addBuff(skill:createBuff(hero))
      skill.cd_remaining = skill.info.CD
    end
  end
end

function WW.skillatk4_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  projectile.hit = override(projectile.hit, WW.atk4Projectile_hit)
  return projectile
end

function WW.init_hero(hero)
  local skillatk = hero.skills.WW_atk
  local skillatk2 = hero.skills.WW_atk2
  local skillatk2s = hero.skills.WW_atk2s
  if skillatk2 then
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, WW.skillatk2_takeEffectOn)
    if skillatk2.evo_rank and skillatk2.evo_rank >= 1 then
      skillatk2.info = ed.wraptable(skillatk2.info, {
        ["Plus Ratio"] = skillatk2.evo_rank1["Script Arg1"]
      })
      skillatk2s.info = ed.wraptable(skillatk2s.info, {
        ["Plus Ratio"] = skillatk2.evo_rank1["Script Arg1"]
      })
    end
    if skillatk2.evo_rank and skillatk2.evo_rank >= 2 then
      local buff_info = skillatk2.info.buff_info
      skillatk2.info = ed.wraptable(skillatk2.info, {
        buff_info = ed.wraptable(buff_info, {
          Time = buff_info.Time + skillatk2.evo_rank2["Script Arg1"]
        }),
        ["Plus Ratio"] = skillatk2.evo_rank1["Script Arg1"]
      })
      skillatk2s.info = ed.wraptable(skillatk2s.info, {
        buff_info = ed.wraptable(buff_info, {
          Time = buff_info.Time + skillatk2.evo_rank2["Script Arg1"]
        }),
        ["Plus Ratio"] = skillatk2.evo_rank1["Script Arg1"]
      })
    end
    if skillatk2.evo_rank and skillatk2.evo_rank >= 3 then
      local buff_info = skillatk2.info.buff_info
      skillatk2.info = ed.wraptable(skillatk2.info, {
        ["Plus Ratio"] = skillatk2.evo_rank3["Script Arg1"]
      })
      skillatk2s.info = ed.wraptable(skillatk2s.info, {
        ["Plus Ratio"] = skillatk2.evo_rank3["Script Arg1"]
      })
    end
  end
  local skillatk3 = hero.skills.WW_atk3
  if skillatk3 then
    skillatk3.selectTarget = override(skillatk3.selectTarget, WW.skillatk3Andawake_selectTarget)
    skillatk3.createBuff = override(skillatk3.createBuff, WW.skillatk3_createBuff)
    skillatk3.canCastWithTarget = override(skillatk3.canCastWithTarget, WW.skillatk3_canCastWithTarget)
    hero.reset = override(hero.reset, WW.hero_reset)
    hero.setHP = override(hero.setHP, WW.setHP)
  end
  local skillatk4 = hero.skills.WW_atk4
  if skillatk4 then
    skillatk4.createProjectile = override(skillatk4.createProjectile, WW.skillatk4_createProjectile)
    skillatk4.createBuff = override(skillatk4.createBuff, WW.skillatk4_createBuff)
    if skillatk4.evo_rank and skillatk4.evo_rank >= 1 then
      skillatk4.info = ed.wraptable(skillatk4.info, {
        ["Script Arg2"] = skillatk4.evo_rank1["Script Arg1"]
      })
    end
    if skillatk4.evo_rank and skillatk4.evo_rank >= 2 then
      local buff_info = skillatk4.info.buff_info
      skillatk4.info = ed.wraptable(skillatk4.info, {
        buff_info = ed.wraptable(buff_info, {
          Time = buff_info.Time + skillatk4.evo_rank2["Script Arg1"]
        }),
        ["Script Arg2"] = skillatk4.evo_rank1["Script Arg1"]
      })
    end
  end
  local skillult = hero.skills.WW_ult
  local skillults = hero.skills.WW_ults
  if skillult then
    skillult.canCastWithTarget = override(skillult.canCastWithTarget, WW.skillult_canCastWithTarget)
    skillult.selectTarget = override(skillult.selectTarget, WW.skillult_selectTarget)
    skillult.takeEffectOn = override(skillult.takeEffectOn, WW.skillult_takeEffectOn)
    skillult.createBuff = override(skillult.createBuff, WW.skillult_createBuff)
    skillults.takeEffectOn = override(skillults.takeEffectOn, WW.skillults_takeEffectOn)
    skillults.createBuff = override(skillults.createBuff, WW.skillults_createBuff)
    if skillult.evo_rank and skillult.evo_rank >= 1 then
      local buff_info = skillult.info.buff_info
      skillult.info = ed.wraptable(skillult.info, {
        buff_info = ed.wraptable(buff_info, {
          ["HPR.a"] = -skillult.evo_rank1["Script Arg1"]
        })
      })
    end
    if skillult.evo_rank and skillult.evo_rank >= 2 then
      local buff_info = skillult.info.buff_info
      skillult.info = ed.wraptable(skillult.info, {
        buff_info = ed.wraptable(buff_info, {
          ["HPR.a"] = -skillult.evo_rank2["Script Arg1"]
        })
      })
    end
    if skillult.evo_rank and skillult.evo_rank >= 3 then
      local buff_info = skillult.info.buff_info
      skillult.info = ed.wraptable(skillult.info, {
        buff_info = ed.wraptable(buff_info, {
          ["HPR.a"] = -skillult.evo_rank2["Script Arg1"],
          Time = buff_info.Time + skillult.evo_rank3["Script Arg1"]
        })
      })
    end
  end
  if WW.fashion_id_1 and WW.fashion_id_1 == hero.fashion_id then
    if skillatk then
      hero.skills.WW_atk.info["Tile Art"] = "eff_tile_WW_fashion_1_atk.cha"
      hero.skills.WW_atk.info["Impact Effect"] = "eff_impact_WW_fashion_1_atk.cha"
    end
    if skillult then
      hero.skills.WW_ult.info["Impact Effect"] = "eff_impact_WW_fashion_1_ult.cha"
    end
    if skillatk2 then
      hero.skills.WW_atk2.info["Impact Effect"] = "eff_impact_WW_fashion_1_atk2.cha"
      hero.skills.WW_atk2.info["Tile Art"] = "eff_tile_WW_fashion_1_atk2.cha"
      hero.skills.WW_atk2s.info["Impact Effect"] = "eff_impact_WW_fashion_1_atk2s.cha"
      hero.skills.WW_atk2s.info["Tile Art"] = "eff_tile_WW_fashion_1_atk2s.cha"
    end
    if skillatk4 then
      hero.skills.WW_atk4.info["Impact Effect"] = "eff_impact_WW_fashion_1_atk.cha"
    end
  end
  return hero
end

return WW.init_hero
