module("ed.battlehero", package.seeall)
local ed = ed
Bard = {}
Bard.atk2_chord_bid = 1058
Bard.atk3_chord_bid = 1059
Bard.atk2_chord_active_bid = 1096
Bard.atk3_chord_active_bid = 1097
Bard.atk3_stun_bid = 6
Bard.addition_effect_name = "eff_buff_Bard_addtrigger"
Bard.atk3_impact_effect_name = "eff_impact_Bard_atk3"
Bard.heal_effect_name = "eff_impact_heal"
Bard.ult_average_bid = 1098
Bard.ult_bid = 1091
Bard.chain_timer = 1

function Bard.addition_chord_random(threshold)
  local rand = ed.rand() * 100
  if threshold > rand then
    return true
  else
    return false
  end
end

function Bard.addition_chord_target(skill, list)
  local max = -math.huge
  local chosen
  local caster = skill.caster
  local caster_position = caster.position
  local enchanted = caster.buff_effects.enchanted
  local Ignore = skill:Ignore_Target_Type()
  for unit in ed.engine:foreachAliveUnit(skill:targetCamp()) do
    if not unit:isHero() then
    else
      for i, added in ipairs(list) do
        if unit == added then
          break
        end
      end
      if unit.buff_effects.untargetable then
      elseif unit.buffManager.invisible and unit.camp ~= caster.camp then
      elseif enchanted and unit == caster then
      else
        local distanceSQ = (unit.position[1] - caster_position[1]) ^ 2 + (unit.position[2] - caster_position[2]) ^ 2
        if distanceSQ >= skill.min_range_sq and distanceSQ <= skill.max_range_sq then
          local v = ed.rand(unit)
          local shouldIgnore = Ignore(unit)
          if max < v and not shouldIgnore then
            max = v
            chosen = unit
          end
        end
      end
    end
  end
  chosen = chosen or list[1]
  return chosen
end

function Bard.check_chordlist(chordlist, hero)
  for i, unit in ipairs(chordlist) do
    if hero == unit then
      return false
    end
  end
  return true
end

function Bard.add_addition_chord(skill, chordlist, bid)
  local caster = skill.caster
  if ed.run_with_scene then
    ed.scene:playEffectOnScene(Bard.addition_effect_name, caster.position, {
      -caster.direction,
      1
    }, nil, 1)
  end
  local addition_target = Bard.addition_chord_target(skill, chordlist)
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = ed.BuffCreate(binfo, addition_target, caster)
  local bsuccess = ed.Buff.checkAddBuff(binfo, skill.level, addition_target, caster)
  local check_chordlist = Bard.check_chordlist(chordlist, addition_target)
  if bsuccess and check_chordlist then
    addition_target:addBuff(buff, caster)
    table.insert(chordlist, addition_target)
  end
end

function Bard.skillatk2_takeEffectOn(basefunc, skill, target, source)
  local caster = skill.caster
  if target:isAlive() and not skill.Bard_ult_trigger then
    local binfo = ed.lookupDataTable("Buff", nil, Bard.atk2_chord_bid)
    local buff = ed.BuffCreate(binfo, target, caster)
    local bsuccess = ed.Buff.checkAddBuff(binfo, skill.level, target, caster)
    local check_chordlist = Bard.check_chordlist(caster.atk2_chordlist, target)
    if bsuccess and check_chordlist then
      target:addBuff(buff, caster)
      table.insert(caster.atk2_chordlist, target)
    end
  end
  local caster = skill.caster
  local skillawake = caster.skills.Bard_awake
  if skillawake and not skill.Bard_ult_trigger then
    local threshold = skillawake.info["Script Arg1"]
    local addition_chord = Bard.addition_chord_random(threshold)
    if addition_chord then
      Bard.add_addition_chord(skill, caster.atk2_chordlist, Bard.atk2_chord_bid)
    end
  end
  skill.Bard_ult_trigger = nil
  basefunc(skill, target, source)
end

function Bard.skillatk3_takeEffectAt(basefunc, skill, location, source)
  local caster = skill.caster
  if not skill.Bard_ult_trigger then
    local target = skill.target
    local chord_binfo = ed.lookupDataTable("Buff", nil, Bard.atk3_chord_bid)
    local chord_buff = ed.BuffCreate(chord_binfo, skill.target, caster)
    local chord_bsuccess = ed.Buff.checkAddBuff(chord_binfo, skill.level, skill.target, caster)
    local check_chordlist = Bard.check_chordlist(caster.atk3_chordlist, target)
    if chord_bsuccess and check_chordlist then
      target:addBuff(chord_buff, caster)
      table.insert(caster.atk3_chordlist, target)
    end
  end
  local binfo = ed.lookupDataTable("Buff", nil, Bard.atk3_stun_bid)
  local buff = ed.BuffCreate(binfo, skill.target, caster)
  local bsuccess = ed.Buff.checkAddBuff(binfo, skill.level, skill.target, caster)
  if bsuccess then
    skill.target:addBuff(buff, caster)
  end
  local caster = skill.caster
  local skillawake = caster.skills.Bard_awake
  if skillawake and not skill.Bard_ult_trigger then
    local threshold = skillawake.info["Script Arg1"]
    local addition_chord = Bard.addition_chord_random(threshold)
    if addition_chord then
      Bard.add_addition_chord(skill, caster.atk3_chordlist, Bard.atk3_chord_bid)
    end
  end
  skill.Bard_ult_trigger = nil
  basefunc(skill, location, source)
end

function Bard.atk3_projectile_hit(basefunc, self, target)
  if target == self.target then
    if ed.run_with_scene then
      ed.scene:playEffectOnScene(Bard.atk3_impact_effect_name, target.position, {
        self.direction,
        1
      }, nil, 1)
    end
    self.skill:takeEffectAt(target.position, self)
    if not self.terminated then
      self:terminate()
    end
  end
end

function Bard.skillatk3_createProjectile(basefunc, skill)
  local target = skill.target
  local projectile = basefunc(skill, target)
  projectile.target = target
  projectile.hit = override(projectile.hit, Bard.atk3_projectile_hit)
  return projectile
end

function Bard.skillult_chain_update(basefunc, self, dt)
  local info = self.skill.info
  self.jump_timer = self.jump_timer - dt
  if self.jump_timer <= 0 then
    if 0 < self.jumps_remaining then
      self.source = self.target
      self.target = self:findNextTaeget()
      if self.target then
        self:jump()
        return
      end
    end
    for i, unit in ipairs(self.Bard_hero_list) do
      if unit:isAlive() then
        for i, tbuff in ipairs(unit.buff_list) do
          if tbuff.info.ID == Bard.ult_average_bid then
            unit:removeBuff(tbuff)
          end
        end
      end
    end
    self:terminate()
  end
end

function Bard.skillult_chain_findNextTaeget(basefunc, self)
  local min = {
    math.huge,
    math.huge
  }
  local ret
  local jump_gap = 6400
  for i, unit in ipairs(self.Bard_hero_list) do
    if unit == self.source then
    elseif unit.buff_effects.untargetable then
    elseif unit.buffManager.invisible and unit.camp ~= self.skill.caster.camp then
    else
      local times = self.affect_times[unit] or 0
      if times > min[1] then
      else
        local distanceSQ = math.abs(ed.edpDistanceSQ(unit.position, self.source.position) - jump_gap)
        if distanceSQ > min[2] then
        else
          ret = unit
          min = {times, distanceSQ}
        end
      end
    end
  end
  return ret
end

function Bard.skillult_createChain(basefunc, skill)
  local chain = basefunc(skill)
  chain.Bard_hero_list = skill.Bard_hero_list
  chain.findNextTaeget = override(chain.findNextTaeget, Bard.skillult_chain_findNextTaeget)
  return chain
end

function Bard.chord_trigger_effects(skill)
  local caster = skill.caster
  local chordcount = 0
  local checkbid, addbid, chordlist
  if skill.info["Skill Name"] == "Bard_atk2" then
    checkbid = Bard.atk2_chord_bid
    addbid = Bard.atk2_chord_active_bid
    chordlist = caster.atk2_chordlist
  elseif skill.info["Skill Name"] == "Bard_atk3" then
    checkbid = Bard.atk3_chord_bid
    addbid = Bard.atk3_chord_active_bid
    chordlist = caster.atk3_chordlist
  end
  for i, unit in ipairs(chordlist) do
    if not unit:isAlive() then
    else
      for i, tbuff in ipairs(unit.buff_list) do
        if tbuff.info.ID == checkbid then
          unit:removeBuff(tbuff)
          skill.Bard_ult_trigger = true
          skill.target = unit
          chordcount = chordcount + 1
          local binfo = ed.lookupDataTable("Buff", nil, addbid)
          local buff = ed.BuffCreate(binfo, unit, caster)
          local bsuccess = ed.Buff.checkAddBuff(binfo, skill.level, unit, caster)
          if bsuccess then
            unit:addBuff(buff, caster)
          end
          if skill.info["Skill Name"] == "Bard_atk2" then
            skill:takeEffectOn(unit, caster)
          elseif skill.info["Skill Name"] == "Bard_atk3" then
            if ed.run_with_scene then
              ed.scene:playEffectOnScene(Bard.atk3_impact_effect_name, unit.position, {
                unit.direction,
                1
              }, nil, 1)
            end
            skill:takeEffectAt(unit.position, caster)
          end
        end
      end
    end
  end
  return chordcount
end

function Bard.skillult_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local skillatk2 = caster.skills.Bard_atk2
  local skillatk3 = caster.skills.Bard_atk3
  local skillatk4 = caster.skills.Bard_atk4
  local hero_list = {}
  if skill.attack_counter == 0 then
    local hptotal = 0
    local hpremaintotal = 0
    local remainhero = 0
    for unit in ed.engine:foreachAliveUnit(caster.camp) do
      if not unit:isHero() then
      elseif unit.buff_effects.invulnerable then
      elseif 5 <= remainhero then
      else
        table.insert(hero_list, unit)
        hptotal = hptotal + unit.attribs.HP
        hpremaintotal = hpremaintotal + unit.hp
        remainhero = remainhero + 1
      end
    end
    if #hero_list == 0 then
      table.insert(hero_list, caster)
      hptotal = hptotal + caster.attribs.HP
      hpremaintotal = hpremaintotal + caster.hp
      remainhero = remainhero + 1
    end
    skill.Bard_hero_list = hero_list
    skill.Bard_remainhero = remainhero
    if caster.manually_casting then
      ed.engine:unfreeze()
      caster.manually_casting = false
    end
    if 1 < #hero_list then
      for i, unit in ipairs(hero_list) do
        if unit.name ~= caster.name then
          skill.target = unit
        end
      end
      local chain = skill:createChain()
      chain.jumps_remaining = #hero_list - 1
      ed.engine:addChain(chain)
    end
    for i, unit in ipairs(skill.Bard_hero_list) do
      local binfo = ed.lookupDataTable("Buff", nil, Bard.ult_bid)
      local buff = ed.BuffCreate(binfo, unit, caster)
      if unit:isAlive() then
        unit:setHP(unit.attribs.HP * hpremaintotal / hptotal)
        unit:addBuff(buff, caster)
      end
    end
    skill.attack_counter = skill.attack_counter + 1
  elseif skill.attack_counter <= 4 then
    if #skill.Bard_hero_list >= skill.attack_counter + 1 then
      for i, unit in ipairs(skill.Bard_hero_list) do
        if unit.name ~= caster.name then
          skill.target = unit
        end
      end
      local chain = skill:createChain()
      chain.jumps_remaining = #skill.Bard_hero_list - 1
      ed.engine:addChain(chain)
    end
    skill.attack_counter = skill.attack_counter + 1
  elseif skill.attack_counter == 5 then
    for i, unit in ipairs(skill.Bard_hero_list) do
      if unit:isAlive() then
        for i, tbuff in ipairs(unit.buff_list) do
          if tbuff.info.ID == Bard.ult_average_bid then
            unit:removeBuff(tbuff)
          end
        end
      end
    end
    local chordcount = 0
    if skillatk2 then
      chordcount = chordcount + Bard.chord_trigger_effects(skillatk2)
      caster.atk2_chordlist = {}
    end
    if skillatk3 then
      chordcount = chordcount + Bard.chord_trigger_effects(skillatk3)
      caster.atk3_chordlist = {}
    end
    for i, unit in ipairs(skill.Bard_hero_list) do
      if skillatk4 then
        local chordheal = skillatk4.info["Script Arg1"]
        if ed.protoSuperAwake(caster.proto, 10039) then
          local skillsawake = caster.skills.Bard_sawake
          chordheal = chordheal + skillsawake.info["Script Arg2"] + 170
        end
        local healperhero = chordheal * chordcount / skill.Bard_remainhero
        unit:takeHeal(healperhero, "hp", caster)
        if ed.run_with_scene then
          ed.scene:playEffectOnScene(Bard.heal_effect_name, unit.position, {
            unit.direction,
            1
          }, nil, 1)
        end
      end
    end
    skill.Bard_hero_list = nil
    skill.Bard_remainhero = nil
  end
end

function Bard.skillult_finish(basefunc, skill)
  local caster = skill.caster
  for unit in ed.engine:foreachAliveUnit(caster.camp) do
    if not unit:isHero() then
    else
      for i, buff in ipairs(unit.buff_list) do
        if buff.info.ID == Bard.ult_average_bid then
          unit:removeBuff(buff)
          break
        end
      end
    end
  end
  basefunc(skill)
end

function Bard.reset(basefunc, hero)
  basefunc(hero)
  hero.atk2_chordlist = {}
  hero.atk3_chordlist = {}
  local skillatk = hero.skills.Bard_atk2
  local skillatk2 = hero.skills.Bard_atk2
  local skillatk3 = hero.skills.Bard_atk3
  if ed.protoSuperAwake(hero.proto, 10039) then
    skillatk.info = ed.wraptable(skillatk.info, {
      ["Gain MP"] = 180
    })
    skillatk2.info = ed.wraptable(skillatk2.info, {
      ["Gain MP"] = 230
    })
    skillatk3.info = ed.wraptable(skillatk3.info, {
      ["Gain MP"] = 230
    })
  end
end

function Bard.init_hero(hero)
  hero.reset = override(hero.reset, Bard.reset)
  local skillult = hero.skills.Bard_ult
  local skillatk2 = hero.skills.Bard_atk2
  local skillatk3 = hero.skills.Bard_atk3
  if skillult then
    skillult.onAttackFrame = override(skillult.onAttackFrame, Bard.skillult_onAttackFrame)
    skillult.createChain = override(skillult.createChain, Bard.skillult_createChain)
    skillult.finish = override(skillult.finish, Bard.skillult_finish)
  end
  if skillatk2 then
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, Bard.skillatk2_takeEffectOn)
  end
  if skillatk3 then
    skillatk3.takeEffectAt = override(skillatk3.takeEffectAt, Bard.skillatk3_takeEffectAt)
    skillatk3.createProjectile = override(skillatk3.createProjectile, Bard.skillatk3_createProjectile)
  end
  return hero
end

return Bard.init_hero
