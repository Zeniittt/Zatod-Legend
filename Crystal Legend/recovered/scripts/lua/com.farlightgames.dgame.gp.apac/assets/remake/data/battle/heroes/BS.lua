module("ed.battlehero", package.seeall)
local ed = ed
BS = {}
BS.fashionID1 = 100021

function BS.skillatk2_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  local target = skill.target
  local caster = skill.caster
  local direction = {
    caster.direction,
    0
  }
  local distance = 4
  if attack_counter == 2 then
    basefunc(skill)
    if target then
      if not target:isHasUncontrolBufEffect() then
        target:hurt()
      end
      local bid = 11000206
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, target, caster)
      target:addBuff(buff, caster)
    end
  elseif attack_counter == 3 then
    if target then
      target:knockup(0.008, ed.edpMult(direction, -distance), true)
    end
    basefunc(skill)
  elseif attack_counter == 4 then
    basefunc(skill)
    if target then
      target:knockup(0.015, ed.edpMult(direction, 12), true)
    end
  else
    basefunc(skill)
  end
end

function BS.skillatk2_finish(basefunc, skill)
  basefunc(skill)
  if skill.target then
    for i, buff in ipairs(skill.target.buff_list) do
      if buff.info.ID == 11000206 and buff.caster == skill.caster then
        buff.timer = 0
      end
    end
  end
end

function BS.skillatk2_getDamage(basefunc, skill, target, power, damage_type, field, source, crit_mod)
  local info = skill.info
  local caster = skill.caster
  local skillatk2s = caster.skills.BS_atk2s
  local dmg = basefunc(skill, target, power, damage_type, field, source, crit_mod)
  local heal = dmg * info["Script Arg2"] / 100
  if 0 < heal and skillatk2s then
    local originfo = skillatk2s.info
    skillatk2s.info = ed.wraptable(originfo, {
      ["Basic Num"] = heal
    })
    skillatk2s:takeEffectOn(caster, caster)
    skillatk2s.info = originfo
  end
  return dmg
end

function BS.hero_handleUnitDieEvent(basefunc, self, unit, killer_unit)
  basefunc(self, unit, killer_unit)
  local hero = self
  local skillatk3 = hero.skills.BS_atk3
  if skillatk3 and unit.camp ~= hero.camp and not unit.config.is_summoned then
    local originfo = skillatk3.info
    local healRatio = skillatk3.info["Script Arg2"] / 100
    if skillatk3.evo_rank and skillatk3.evo_rank >= 1 then
      healRatio = healRatio + skillatk3.evo_rank1["Script Arg1"] / 100
    end
    if skillatk3.evo_rank and skillatk3.evo_rank >= 2 then
      healRatio = healRatio + skillatk3.evo_rank2["Script Arg1"] / 100
    end
    local heal = unit.attribs.HP * healRatio
    if killer_unit == hero then
      heal = heal * 2
    end
    skillatk3.info = ed.wraptable(originfo, {
      ["Basic Num"] = heal
    })
    skillatk3:takeEffectOn(hero, hero)
    skillatk3.info = originfo
  end
end

function BS.skillatk23_takeEffectOn(basefunc, skill, target, source)
  local caster = skill.caster
  local skillatk3 = caster.skills.BS_atk3
  local heal = caster.attribs.HEAL or 0
  local power, coefficient = skill:power(source, target, "HP")
  local power = power * (1 + heal / 100)
  local amount = power * (math.max((target.attribs.HealRatio or 0) / 100, -1) + 1)
  local havebuff = false
  local buff
  for i, tbuff in ipairs(target.buff_list) do
    if tbuff.info.ID == 11000207 then
      havebuff = true
      buff = tbuff
    end
  end
  if skillatk3 and skillatk3.evo_rank and skillatk3.evo_rank >= 3 and target and target.hp + amount >= target.attribs.HP and not target.buff_effects.unheal then
    local ShieldIncrease = 0
    local ShieldWeak = 0
    if target.attribs.ShieldIncrease then
      ShieldIncrease = target.attribs.ShieldIncrease
    end
    if target.attribs.ShieldWeak then
      ShieldWeak = target.attribs.ShieldWeak
    end
    local shieldratio = math.max(0.01, 1 + (ShieldIncrease - ShieldWeak) / 100)
    local max = skillatk3.evo_rank3["Script Arg1"] / 100 * (caster.config.hp_mod or 1) * caster.attribs.HP
    if havebuff then
      buff.shield = buff.shield + amount * shieldratio
      if max < buff.shield then
        buff.shield = max
      end
      buff.timer = 7
    else
      local bid = 11000207
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, caster, caster)
      if BS.fashionID1 and BS.fashionID1 == caster.fashion_id then
        buff:setAttribute("Effect", "eff_buff_BS_protossShiled.cha")
      end
      target:addBuff(buff, caster)
      if buff then
        buff.shield = (target.hp + amount - target.attribs.HP) * shieldratio
        if max < buff.shield then
          buff.shield = max
        end
        buff.timer = 7
      end
    end
  end
  basefunc(skill, target)
end

function BS.skillatk4s_start(basefunc, skill, target)
  local hero = skill.caster
  local bid = 11000202
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = hero:addBuff(binfo, hero)
  buff.timer = 1
  basefunc(skill, target)
end

function BS.skillatk4s_selectTarget(basefunc, self, default)
  local selector = self:target_selector()
  local hero = self.caster
  if selector then
    self.target = hero.BSatk4Target
    return self.target
  end
  return nil
end

function BS.skillatk4s_takeEffectOn(basefunc, skill, target, source)
  local hero = skill.caster
  local skillatk4 = hero.skills.BS_atk4
  local succ = basefunc(skill, target, source)
  if succ then
    for i, buff in ipairs(target.buff_list) do
      if buff.info.ID == 11000204 and buff.caster == hero then
        local buff_berserker = skillatk4:createBuff(hero)
        hero:addBuff(buff_berserker)
        hero.BSCastatk4 = true
        return
      end
    end
    hero.BSCastatk4 = false
  else
    hero.BSCastatk4 = false
  end
end

function BS.skillatk4s_finish(basefunc, skill)
  basefunc(skill)
  local hero = skill.caster
  for i, buff in ipairs(hero.buff_list) do
    if buff.info.ID == 11000202 then
      buff.timer = 0
    end
  end
end

function BS.BSatk4s_buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local owner = buff.owner
  if owner.position[1] < ed.engine.stage_rect.minX or owner.position[1] > ed.engine.stage_rect.maxX or owner.position[2] < ed.engine.stage_rect.minY or owner.position[2] > ed.engine.stage_rect.maxY then
    buff.timer = -1
  end
  if owner.buff_effects.hide and owner.buff_effects.invulnerable then
    buff.timer = -1
  end
end

function BS.BSatk4s_buff_OnRemoved(basefunc, buff)
  basefunc(buff)
  local hero = buff.caster
  for i, buff in ipairs(hero.buff_list) do
    if buff.info.ID == 11000203 and buff.caster == hero then
      buff.timer = 0
    end
  end
end

function BS.skillatk4s_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.onRemoved = override(buff.onRemoved, BS.BSatk4s_buff_OnRemoved)
  buff.update = override(buff.update, BS.BSatk4s_buff_update)
  return buff
end

function BS.BSatk4_buff_OnRemoved(basefunc, buff)
  basefunc(buff)
  local hero = buff.caster
  hero.BSCastatk4 = false
  local target = hero.BS_atk4BuffTarget
  for i, buff in ipairs(target.buff_list) do
    if buff.info.ID == 11000204 and buff.caster == hero then
      buff.timer = 0
    end
  end
  hero.BSatk4Target = nil
end

function BS.skillatk4_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = buff.caster
  local owner = buff.owner
  caster.BS_atk4BuffTarget = owner
  buff.onRemoved = override(buff.onRemoved, BS.BSatk4_buff_OnRemoved)
  if skill.evo_rank and skill.evo_rank >= 1 then
    local HAST = buff.info.HAST
    local MSPD = buff.info.HAST
    buff:setAttribute("HAST", HAST + skill.evo_rank1["Script Arg1"])
    buff:setAttribute("MSPD", MSPD + skill.evo_rank1["Script Arg1"])
  end
  if skill.evo_rank and skill.evo_rank >= 2 then
    local AD = buff.info.AD
    buff:setAttribute("AD", AD + skill.evo_rank2["Script Arg1"])
  end
  if skill.evo_rank and skill.evo_rank >= 3 then
    local PIMU = buff.info.PIMU
    local MIMU = buff.info.MIMU
    buff:setAttribute("MIMU", MIMU + skill.evo_rank3["Script Arg1"])
    buff:setAttribute("PIMU", PIMU + skill.evo_rank3["Script Arg1"])
  end
  return buff
end

function BS.skillult_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  local caster = skill.caster
  if attack_counter == 0 then
    if ed.run_with_scene then
      local effect_eye = "eff_point_BS_ulteyes.cha"
      local effect_red = "eff_point_BS_ultred"
      local origin1 = {
        ed.engine.stage_rect.maxX / 2,
        0
      }
      local origin2 = caster.position
      ed.scene:playEffectOnScene(effect_eye, origin2, nil, nil, -1)
      ed.scene:playEffectOnScene(effect_red, origin1, nil, nil, -1)
    end
    if skill.caster.manually_casting then
      ed.engine:unfreeze()
      skill.caster.manually_casting = false
    end
    skill.attack_counter = skill.attack_counter + 1
  elseif attack_counter == 1 then
    basefunc(skill)
  else
    basefunc(skill)
  end
end

function BS.skillult_buff_update(basefunc, buff, dt)
  local caster = buff.caster
  local owner = buff.owner
  local skillults = caster.skills.BS_ults
  if not buff.lastposition then
    buff.lastposition = {
      owner.position[1],
      owner.position[2]
    }
  end
  if buff.lastposition[1] ~= owner.position[1] or buff.lastposition[2] ~= owner.position[2] then
    owner.distanceSQ = ((owner.position[1] - buff.lastposition[1]) ^ 2 + (owner.position[2] - buff.lastposition[2]) ^ 2) ^ 0.5
    owner.TotaldistanceSQ = owner.distanceSQ + owner.TotaldistanceSQ
    buff.lastposition = {
      owner.position[1],
      owner.position[2]
    }
  end
  if owner.BS_ultCD then
    owner.BS_ultCD = owner.BS_ultCD + dt
  end
  if owner.BS_ultCD >= 3 then
    skillults:takeEffectOn(owner)
    owner.BS_ultCD = 0
    owner.TotaldistanceSQ = 0
  end
  basefunc(buff, dt)
end

function BS.BSult_buff_OnRemoved(basefunc, buff)
  basefunc(buff)
  buff.lastposition = nil
end

function BS.skillult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  local caster = buff.caster
  local buffInfo = buff.info
  local attribName = buffInfo.Tenacity
  local TEN_final = ed.Buff.getTenValue(buffInfo, owner, caster)
  owner.TotaldistanceSQ = 0
  owner.BS_ultCD = 0
  buff.update = override(buff.update, BS.skillult_buff_update)
  buff.onRemoved = override(buff.onRemoved, BS.BSult_buff_OnRemoved)
  if skill.evo_rank and skill.evo_rank >= 3 then
    buff.timer = buff.timer + skill.evo_rank3["Script Arg1"]
  end
  return buff
end

function BS.skillults_takeEffectOn(basefunc, skill, target, source)
  local caster = skill.caster
  local AD = caster.attribs.AD
  if target and target:isAlive() and not (target.position[1] < ed.engine.stage_rect.minX) and not (target.position[1] > ed.engine.stage_rect.maxX) and not (target.position[2] < ed.engine.stage_rect.minY) and not (target.position[2] > ed.engine.stage_rect.maxY) then
    if target.TotaldistanceSQ and target.TotaldistanceSQ > 0 then
      skill.info["Basic Num"] = target.TotaldistanceSQ * 0.01 * AD
    else
      return
    end
    basefunc(skill, target, source)
  end
end

function BS.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.BSCastatk4 = false
  hero.BSatk4Target = nil
end

function BS.hero_update(basefunc, hero, dt)
  hero.dt = hero.dt and hero.dt + dt or dt
  if hero.dt == 1 and ed.engine.rogue_mode and ed.engine.rogueSkillMgr:getCharm(28) then
    local charmEffect = ed.engine.rogueSkillMgr:getCharm(28)
    local skillult = hero.skills.BS_ult
    local skillults = hero.skills.BS_ults
    local skillatk2 = hero.skills.BS_atk2
    local lfsratio = charmEffect.info["Script Arg" .. charmEffect.level]
    if lfsratio then
      if skillult then
        skillult.info = ed.wraptable(skillult.info, {
          ["LFS%"] = lfsratio
        })
      end
      if skillults then
        skillults.info = ed.wraptable(skillults.info, {
          ["LFS%"] = lfsratio
        })
      end
      if skillatk2 then
        skillatk2.info = ed.wraptable(skillatk2.info, {
          ["LFS%"] = lfsratio
        })
      end
    end
  end
  local skillatk4 = hero.skills.BS_atk4
  local skillatk4s = hero.skills.BS_atk4s
  if skillatk4 and not hero.BSCastatk4 and skillatk4s then
    local MinHpUnit
    local MinHp = math.huge
    for unit in ed.engine:foreachAliveUnit(-hero.camp) do
      if unit.hp / unit.attribs.HP < 0.4 and unit:isAlive() and not unit.config.is_summoned and not unit.buff_effects.untargetable and not unit.buff_effects.uncontrollable and not unit.buff_effects.invulnerable and hero.current_skill ~= hero.skills.BS_ult and hero.current_skill ~= hero.skills.BS_atk2 and hero.current_skill ~= hero.skills.BS_atk4s and not (unit.position[1] < ed.engine.stage_rect.minX) and not (unit.position[1] > ed.engine.stage_rect.maxX) and not (unit.position[2] < ed.engine.stage_rect.minY) and not (unit.position[2] > ed.engine.stage_rect.maxY) and (not MinHpUnit or MinHp > unit.hp) then
        MinHpUnit = unit
        MinHp = unit.hp
      end
    end
    hero.BSatk4Target = MinHpUnit
    if hero.BSatk4Target and hero.BSatk4Target:isAlive() then
      hero:castSkill(skillatk4s, hero.BSatk4Target)
    end
  end
  basefunc(hero, dt)
end

function BS.hero_true_init(hero)
  local skillult = hero.skills.BS_ult
  local skillults = hero.skills.BS_ults
  local skillatk2 = hero.skills.BS_atk2
  local skillatk2s = hero.skills.BS_atk2s
  local skillatk3 = hero.skills.BS_atk3
  local skillatk4 = hero.skills.BS_atk4
  local skillatk4s = hero.skills.BS_atk4s
  hero.reset = override(hero.reset, BS.hero_reset)
  hero.update = override(hero.update, BS.hero_update)
  if skillatk2 then
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, BS.skillatk2_onAttackFrame)
    skillatk2.getDamage = override(skillatk2.getDamage, BS.skillatk2_getDamage)
    skillatk2.finish = override(skillatk2.finish, BS.skillatk2_finish)
    if skillatk2.evo_rank and skillatk2.evo_rank >= 1 then
      skillatk2.info = ed.wraptable(skillatk2.info, {
        ["Plus Ratio"] = skillatk2.evo_rank1["Script Arg1"]
      })
    end
    if skillatk2.evo_rank and skillatk2.evo_rank >= 2 then
      skillatk2.info = ed.wraptable(skillatk2.info, {
        ["Plus Ratio"] = skillatk2.evo_rank2["Script Arg1"]
      })
    end
    if skillatk2.evo_rank and skillatk2.evo_rank >= 3 then
      skillatk2.info = ed.wraptable(skillatk2.info, {
        ["Plus Ratio"] = skillatk2.evo_rank3["Script Arg1"]
      })
    end
  end
  if skillatk2s then
    skillatk2s.takeEffectOn = override(skillatk2s.takeEffectOn, BS.skillatk23_takeEffectOn)
  end
  if skillatk3 then
    hero.handleUnitDieEventToAll = override(hero.handleUnitDieEventToAll, BS.hero_handleUnitDieEvent)
    skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, BS.skillatk23_takeEffectOn)
  end
  if skillatk4 then
    skillatk4.createBuff = override(skillatk4.createBuff, BS.skillatk4_createBuff)
  end
  if skillatk4s then
    skillatk4s.start = override(skillatk4s.start, BS.skillatk4s_start)
    skillatk4s.selectTarget = override(skillatk4s.selectTarget, BS.skillatk4s_selectTarget)
    skillatk4s.takeEffectOn = override(skillatk4s.takeEffectOn, BS.skillatk4s_takeEffectOn)
    skillatk4s.createBuff = override(skillatk4s.createBuff, BS.skillatk4s_createBuff)
    skillatk4s.finish = override(skillatk4s.finish, BS.skillatk4s_finish)
  end
  if skillult then
    hero:preloadEffect("eff_point_BS_ulteyes.cha")
    hero:preloadEffect("eff_point_BS_ultred.cha")
    skillult.onAttackFrame = override(skillult.onAttackFrame, BS.skillult_onAttackFrame)
    skillult.createBuff = override(skillult.createBuff, BS.skillult_createBuff)
    if skillult.evo_rank and skillult.evo_rank >= 1 then
      skillult.info = ed.wraptable(skillult.info, {
        ["Plus Ratio"] = skillult.evo_rank1["Script Arg1"]
      })
    end
    if skillult.evo_rank and skillult.evo_rank >= 2 then
      skillult.info = ed.wraptable(skillult.info, {
        ["Plus Ratio"] = skillult.evo_rank2["Script Arg1"]
      })
    end
  end
  if skillults then
    skillults.takeEffectOn = override(skillults.takeEffectOn, BS.skillults_takeEffectOn)
  end
  return hero
end

function BS.init_hero(hero)
  BS.hero_true_init(hero)
  return hero
end

return BS.init_hero
