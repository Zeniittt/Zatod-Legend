module("ed.battlehero", package.seeall)
local ed = ed
Cat = {}
Cat.line_radius = 300
Cat.behitmax = 5
Cat.hplostmax = 0.1
Cat.atk4_CD = 10
Cat.line_clear_CD = 1
Cat.line_combo_time = 2
Cat.combo_plus = 0.2
Cat.Cat_getline_time = 9

function Cat.selectPosition(skill, r)
  local caster = skill.caster
  local count = 0
  local maxcount = 0
  local x = 0
  local distance = 0
  local mindistance = 99999
  for i = 100, 700, 50 do
    for unit in ed.engine:foreachAliveUnit(skill:targetCamp()) do
      local unitdistance = math.abs(unit.position[1] - i)
      if unit.buff_effects.untargetable then
      elseif unit.buffManager.invisible and unit.camp ~= caster.camp then
      elseif r >= unitdistance then
        count = count + 1
        distance = distance + unitdistance
      end
    end
    if maxcount < count then
      maxcount = count
      mindistance = distance
      x = i
    end
    if count == maxcount and distance < mindistance then
      mindistance = distance
      x = i
    end
    count = 0
    distance = 0
  end
  if 0 < maxcount then
    return x
  end
  if maxcount <= 0 then
    return false
  end
end

function Cat.selectPosition_atk4(skill, r)
  local caster = skill.caster
  local count = 0
  local mincount = 999999
  local x = 0
  local distance = 0
  local maxdistance = 0
  for i = 100, 700, 50 do
    for unit in ed.engine:foreachAliveUnit(-caster.camp) do
      local unitdistance = math.abs(unit.position[1] - i)
      if unit.buff_effects.untargetable then
      elseif unit.buffManager.invisible and unit.camp ~= caster.camp then
      elseif r >= unitdistance then
        count = count + 1
        distance = distance + unitdistance
      end
    end
    if mincount > count then
      mincount = count
      maxdistance = distance
      x = i
    end
    if count == mincount and distance > maxdistance then
      maxdistance = distance
      x = i
    end
    count = 0
    distance = 0
  end
  if 0 <= mincount then
    return x
  end
  if mincount < 0 then
    return false
  end
end

function Cat.chain_update(basefunc, self, dt)
  local target = self.target
  local sx, sy = target:getRuntimeScale()
  local endPos
  if target.actor then
    endPos = ed.toViewPosition({
      target.position[1],
      target.position[2] + 50
    }, target.actor.height + 48 * target:getUnitScale() * sy)
  else
    endPos = ed.toViewPosition({
      target.position[1],
      target.position[2] + 50
    }, 48 * target:getUnitScale() * sy)
  end
  local startPos = self.startPos
  local x0 = math.min(startPos.x, endPos.x)
  local width = math.abs(startPos.x - endPos.x)
  local y0 = math.min(startPos.y, endPos.y)
  local height = math.abs(startPos.y - endPos.y)
  self.node:setClipRect(CCRectMake(x0, y0 - 20, width, height + 40))
  self.node:setPosition(ed.ccpZero)
  self.content:setPosition(ccpMidpoint(startPos, endPos))
  local deg = -math.deg(math.atan2(endPos.y - startPos.y, endPos.x - startPos.x))
  self.content:setRotation(deg)
  self.content:update(dt)
  self.terminated = self.content:isTerminated()
end

function Cat.skillline999_launchPoint(basefunc, skill)
  local position, height = basefunc(skill)
  local direction = skill.caster.direction
  position = skill.start_unitpos
  height = 100
  return position, height
end

function Cat.line_clear(caster, unit1, unit2)
  local skillline1 = caster.skills.Cat_line1
  local skillline2 = caster.skills.Cat_line2
  local skillline3 = caster.skills.Cat_line3
  for i, tbuff1 in ipairs(unit1.buff_list) do
    for k, tbuff2 in ipairs(unit2.buff_list) do
      if (tbuff1.info.ID == 1060 or tbuff1.info.ID == 1061 or tbuff1.info.ID == 1062) and tbuff1.info.ID == tbuff2.info.ID then
        tbuff1.timer = 0
        tbuff2.timer = 0
        if tbuff1.info.ID == 1060 then
          skillline1:takeEffectOn(unit1)
          skillline1:takeEffectOn(unit2)
        elseif tbuff1.info.ID == 1061 then
          skillline2:takeEffectOn(unit1)
          skillline2:takeEffectOn(unit2)
        elseif tbuff1.info.ID == 1062 then
          skillline3:takeEffectOn(unit1)
          skillline3:takeEffectOn(unit2)
        end
        if ed.run_with_scene then
          local effect_name1 = "eff_point_Cat_line" .. tbuff1.info.ID - 1059 .. "clear.cha"
          local effect_name2 = "eff_point_Cat_line" .. tbuff2.info.ID - 1059 .. "clear.cha"
          local effect_z = 1
          local effect_position1 = {
            unit1.position[1],
            -10
          }
          local effect_position2 = {
            unit2.position[1],
            -10
          }
          ed.scene:playEffectOnScene(effect_name1, effect_position1, {
            unit1.direction,
            1
          }, nil, effect_z)
          ed.scene:playEffectOnScene(effect_name2, effect_position2, {
            unit1.direction,
            1
          }, nil, effect_z)
        end
        local skillline999 = caster.skills.Cat_line999
        skillline999.target = unit2
        if skillline999 and skillline999.target then
          skillline999.start_unitpos = unit1.position
          local chain = skillline999:createChain()
          if ed.run_with_scene then
            local index = #ed.scene.effect_list
            local effect = ed.scene.effect_list[index]
            effect.update = override(effect.update, Cat.chain_update)
          end
          ed.engine:addChain(chain)
        end
        if 0 <= caster.line_combo_time then
          caster.combo_count = caster.combo_count + 1
          if caster.combo_count >= 2 and caster.combo_count <= 5 and ed.run_with_scene then
            local effect_name = "eff_point_Cat_linecombo" .. caster.combo_count .. ".cha"
            local effect_z = 0
            local effect_position = {
              (unit1.position[1] + unit2.position[1]) / 2,
              (unit1.position[2] + unit2.position[2]) / 2
            }
            ed.scene:playEffectOnScene(effect_name, effect_position, {1, 1}, nil, effect_z)
          end
          if caster.combo_count > 5 then
            caster.combo_count = 1
          end
        else
          caster.combo_count = 1
        end
        caster.line_clear_CD = Cat.line_clear_CD
        caster.line_combo_time = Cat.line_combo_time
        return true
      end
    end
  end
  return nil
end

function Cat.line_check(hero)
  local number = #hero.LineStore
  for i = 1, number do
    if hero.LineStore[i].unit:isAlive() then
      for k = i + 1, number do
        if hero.LineStore[k].unit:isAlive() then
          local p1 = hero.LineStore[i].unit.position[1] - hero.LineStore[k].unit.position[1]
          local p2 = hero.LineStore[i].unit.position[2] - hero.LineStore[k].unit.position[2]
          if p1 * p1 + p2 * p2 <= Cat.line_radius * Cat.line_radius then
            local unit1 = hero.LineStore[i].unit
            local unit2 = hero.LineStore[k].unit
            local result = Cat.line_clear(hero, unit1, unit2)
            if result then
              return
            end
          end
        end
      end
    end
  end
end

function Cat.skillawake_onDamaged(basefunc, buff, damage, damage_type, source)
  local owner = buff.owner
  local skillawake = owner.skills.Cat_awake
  local deathdmg = owner.hp * 1.9
  local defence, dd, dc, immunity, crit
  local level = owner.level
  if damage_type == "AD" then
    defence = math.max(0, owner.attribs.ARM - source.attribs.ARMP)
    crit = source.attribs.CRIT
    immunity = owner.attribs.PIMU or 0
    dd = defence * 8
    dc = defence * 8
  elseif damage_type == "AP" then
    defence = math.max(0, owner.attribs.MR - source.attribs.MRI)
    crit = source.attribs.MCRIT
    immunity = owner.attribs.MIMU or 0
    dd = defence * 12
    dc = defence * 2.5
  elseif damage_type == "Holy" then
    defence = 0
    crit = 0
    immunity = 0
    dd = 0
    dc = 0
  else
    EDDebug("Unknown Damage Type '" .. damage_type .. "'")
  end
  immunity = immunity + owner.attribs.ALLIMU
  local lastdamage = owner:getLostHPAfterImmunity(damage, immunity, damage_type)
  if not (not (deathdmg <= lastdamage) and not (lastdamage < owner.hp) and buff.caster:isAlive()) or 0 >= owner.Cat_life then
    return damage
  elseif deathdmg > lastdamage and lastdamage > owner.hp then
    damage = 0
    local hp = skillawake.info["Script Arg2"] * math.pow(0.9, 9 - owner.Cat_life)
    buff.owner:setHP(1)
    buff.owner:takeHeal(hp - 1, "hp", buff.caster)
    if ed.run_with_scene then
      local effect_night = "eff_point_IO_death.cha"
      local origin = buff.owner.position
      ed.scene:playEffectOnScene(effect_night, origin, nil, nil, 0)
    end
    owner.Cat_life = owner.Cat_life - 1
    return damage
  else
    return damage
  end
end

function Cat.hero_reset(basefunc, hero)
  basefunc(hero)
  local dir = hero:getInitDir()
  hero.Cat_behit = 0
  hero.firstlinemark = nil
  hero.Cat_behit = 0
  hero.Cat_atk4lost = 0
  hero.LineStore = {}
  hero.Cat_default_position = {
    400 - dir * 300,
    0
  }
  hero.atk4_CD = 0
  hero.Cat_atk2orginposition = {}
  hero.Cat_atk3orginposition = {}
  hero.combo_count = 1
  hero.combo_time = 0
  hero.line_clear_CD = Cat.line_clear_CD
  hero.line_combo_time = Cat.line_combo_time
  hero.Cat_life = 9
  hero.Cat_getline_time = Cat.Cat_getline_time
  for i, unit in ipairs(ed.engine.unit_list) do
    if (unit.camp == -hero.camp or unit.name == "Cat") and not unit.config.is_summoned then
      hero.LineStore[#hero.LineStore + 1] = {unit = unit}
    end
  end
  local skillawake = hero.skills.Cat_awake
  if skillawake then
    local bid = 1089
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, hero, hero)
    buff.onDamaged = override(buff.onDamaged, Cat.skillawake_onDamaged)
    local buffresult = hero:addBuff(buff, hero)
  end
end

function Cat.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  hero.atk4_CD = hero.atk4_CD - dt
  hero.line_clear_CD = hero.line_clear_CD - dt
  hero.line_combo_time = hero.line_combo_time - dt
  hero.Cat_getline_time = hero.Cat_getline_time - dt
  local skillatk4 = hero.skills.Cat_atk4s
  local skillatk44 = hero.skills.Cat_atk4
  local skillatk2 = hero.skills.Cat_atk2
  local skillatk3 = hero.skills.Cat_atk3
  local BeControlled
  if hero.buff_effects.stun or hero.buff_effects.silence or hero.buff_effects.doom or hero.buff_effects.enchanted or hero.buff_effects.frozen or hero.buff_effects.icefrozen then
    BeControlled = true
  end
  if not BeControlled and skillatk44 and hero.atk4_CD <= 0 and (hero.Cat_behit >= Cat.behitmax or hero.Cat_atk4lost >= hero.attribs.HP * Cat.hplostmax) and hero.current_skill ~= hero.manual_skill and hero.current_skill ~= skillatk4 and hero.current_skill ~= skillatk2 and hero.current_skill ~= skillatk3 then
    hero:castSkill(skillatk4, nil)
    hero.atk4_CD = Cat.atk4_CD
    hero.Cat_behit = 0
    hero.Cat_atk4lost = 0
  end
  if hero.line_clear_CD <= 0 and not hero.config.is_summoned then
    Cat.line_check(hero)
  end
  if hero.Cat_getline_time <= 0 and hero.name == "Cat" then
    local rand = math.floor(ed.rand() * 3) + 1
    local bid = 1059 + rand
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, hero, hero)
    local buffresult = hero:addBuff(buff, hero)
    hero.Cat_getline_time = Cat.Cat_getline_time
  end
end

function Cat.hero_takeDamage(basefunc, hero, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
  local lost = basefunc(hero, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
  if lost and 0 < lost then
    hero.Cat_behit = hero.Cat_behit + 1
    hero.Cat_atk4lost = hero.Cat_atk4lost + lost
  end
  return lost
end

function Cat.skillatk_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  local dir = skill.caster:getInitDir()
  local caster = skill.caster
  local h = projectile.height
  local v = projectile.zSpeed
  local a = skill.info["Tile Gravity"]
  local A = 0.5 * a
  local B = v
  local C = h
  local delta = B ^ 2 - 4 * A * C
  local t = (-B - delta ^ 0.5) / (2 * A)
  local target = skill:selectTarget()
  if target then
    local target_position = {
      target.position[1],
      target.position[2]
    }
    local launchposition, h = skill:launchPoint()
    local distance = ed.edpSub(target_position, {
      launchposition[1],
      launchposition[2]
    })
    projectile.velocity = ed.edpMult(distance, 1 / t)
    ed.engine:addProjectile(projectile)
  end
  return nil
end

function Cat.skillatk_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
end

function Cat.skillatk_onAttackFrame(basefunc, skill)
  local rand = math.floor(ed.rand() * 3) + 1
  local originfo = skill.info
  skill.atk_rand = rand
  skill.info = ed.wraptable(originfo, {
    ["Tile Art"] = "eff_tile_Cat_atk_" .. rand .. ".cha"
  })
  basefunc(skill)
  skill.info = originfo
end

function Cat.skillatk_takeEffectOn(basefunc, skill, target, source, shift)
  local result = basefunc(skill, target, source, shift)
  local caster = skill.caster
  if result then
    local bid = 1059 + skill.atk_rand
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, target, caster)
    local buffresult = target:addBuff(buff, caster)
  end
end

function Cat.skillatk3_buff_onRemoved(basefunc, buff)
  basefunc(buff)
  local caster = buff.caster
  local owner = buff.owner
end

function Cat.skillatk3_buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  buff.knocktime1 = buff.knocktime1 - dt
  local owner = buff.owner
  local caster = buff.caster
  if buff.knocktime1 <= 0.5 and buff.knocktime1 > 0 then
    owner:setPosition({
      caster.atk3_goposition[1],
      caster.atk3_goposition[2]
    })
    owner:moveDrop(500)
  elseif buff.knocktime1 <= 0 then
    if ed.run_with_scene then
      local effect_name = "eff_point_Cat_atk3.cha"
      local effect_z = 1
      local effect_position = {
        owner.position[1],
        25
      }
      ed.scene:playEffectOnScene(effect_name, effect_position, {
        caster.direction,
        1
      }, nil, effect_z)
    end
    buff.knocktime1 = 9999
  end
end

function Cat.skillatk3_buff2_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local owner = buff.owner
  local actor = owner.actor
  if actor then
    if buff.targetsmall[1] > 0.1 then
      buff.scale_id = actor:useScale(buff.targetsmall)
      buff.targetsmall[1] = buff.targetsmall[1] - 0.25
      buff.targetsmall[2] = buff.targetsmall[2] - 0.25
    else
      buff.scale_id = actor:useScale({1, 1})
    end
  end
end

function Cat.skillatk3_buff2_onRemoved(basefunc, buff)
  basefunc(buff)
  local caster = buff.caster
  local owner = buff.owner
end

function Cat.skillatk3_start(basefunc, skill, target)
  basefunc(skill, target)
  local owner = skill.caster
  local bid = 1078
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = owner:addBuff(binfo, owner)
end

function Cat.skillatk3_finish(basefunc, skill)
  basefunc(skill)
  local unit = skill.caster
  for i, tbuff in ipairs(unit.buff_list) do
    if tbuff.info.ID == 1078 then
      tbuff.timer = 0
    end
  end
end

function Cat.skillatk3_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  local caster = skill.caster
  local target = skill.target
  local dir
  local direction = {
    caster.direction,
    -1
  }
  local distance = 4
  caster.atk3_goposition = {400, 0}
  local dir = caster:getInitDir()
  if attack_counter == 0 then
    if target then
      if target.info["Position Type"] == T("\229\137\141\230\142\146") then
      elseif target.info["Position Type"] == T("\228\184\173\230\142\146") or target.info["Position Type"] == T("\229\144\142\230\142\146") then
        caster.atk3_goposition = dir == 1 and {280, 0} or {520, 0}
      end
      if target.position[1] >= caster.position[1] then
        dir = 1
        caster.direction = 1
      else
        dir = -1
        caster.direction = -1
      end
      caster.Cat_atk3orginposition[1] = target.position[1] - dir * 45
      caster.Cat_atk3orginposition[2] = target.position[2]
      caster:setPosition({
        caster.Cat_atk3orginposition[1],
        caster.Cat_atk3orginposition[2]
      })
    else
      caster.Cat_atk3orginposition[1] = caster.position[1]
      caster.Cat_atk3orginposition[2] = caster.position[2]
      skill:finish()
    end
    caster.Cat_atk3target = skill.target
    skill.attack_counter = skill.attack_counter + 1
  elseif attack_counter == 1 then
    basefunc(skill)
    if target then
      if not target:isHasUncontrolBufEffect() then
        target:hurt()
      end
      local bid = 1075
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, target, caster)
      local buffresult = target:addBuff(buff, caster)
    end
  elseif attack_counter == 2 then
    if target and target:isAlive() then
      target:knockup(0.008, ed.edpMult(direction, -distance), true)
      local bid = 1080
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, target, caster)
      buff.targetsmall = {1, 1}
      buff.update = override(buff.update, Cat.skillatk3_buff2_update)
      local buffresult = target:addBuff(buff, caster)
    end
    skill.attack_counter = skill.attack_counter + 1
  elseif attack_counter == 3 then
    if target and target:isAlive() then
      local bid = 1076
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, target, caster)
      buff.update = override(buff.update, Cat.skillatk3_buff_update)
      buff.knocktime1 = 1.7
      buff.knocktime2 = 1
      local buffresult = target:addBuff(buff, caster)
    end
    skill.attack_counter = skill.attack_counter + 1
  end
end

function Cat.skillatk2_start(basefunc, skill, target)
  basefunc(skill, target)
  local owner = skill.caster
  local bid = 1079
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = owner:addBuff(binfo, owner)
end

function Cat.skillatk2_finish(basefunc, skill)
  basefunc(skill)
  local unit = skill.caster
  for i, tbuff in ipairs(unit.buff_list) do
    if tbuff.info.ID == 1079 then
      tbuff.timer = 0
    end
  end
end

function Cat.skillatk2_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  local caster = skill.caster
  local target = skill.target
  local dir
  local originfo = skill.info
  if attack_counter == 0 then
    if target then
      if target.position[1] >= caster.position[1] then
        dir = 1
        caster.direction = 1
      else
        dir = -1
        caster.direction = -1
      end
      caster.Cat_atk2orginposition[1] = target.position[1] - dir * 65
      caster.Cat_atk2orginposition[2] = target.position[2]
      caster:setPosition({
        caster.Cat_atk2orginposition[1],
        caster.Cat_atk2orginposition[2]
      })
    else
      caster.Cat_atk2orginposition[1] = caster.position[1]
      caster.Cat_atk2orginposition[2] = caster.position[2]
      skill:finish()
    end
    caster.Cat_atk2target = skill.target
    skill.attack_counter = skill.attack_counter + 1
  elseif attack_counter == 1 or attack_counter == 2 then
    basefunc(skill)
  end
end

function Cat.skillatk2_takeEffectOn(basefunc, skill, target, source, shift)
  local result = basefunc(skill, target, source, shift)
  local caster = skill.caster
  if result then
    local rand = math.floor(ed.rand() * 3) + 1
    local bid = 1059 + rand
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, target, caster)
    local buffresult = target:addBuff(buff, caster)
  end
end

function Cat.skillatk4_start(basefunc, skill, target)
  basefunc(skill, target)
  local owner = skill.caster
  local bid = 1077
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = owner:addBuff(binfo, owner)
end

function Cat.skillatk4_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  local caster = skill.caster
  local target = skill.target
  if attack_counter == 0 then
    local escapeX = Cat.selectPosition_atk4(skill, 175)
    local escape_position
    if escapeX then
      escape_position = {escapeX, 0}
    else
      escape_position = caster.Cat_default_position
    end
    caster:setPosition({
      escape_position[1],
      escape_position[2]
    })
  end
end

function Cat.skillatk4_finish(basefunc, skill)
  basefunc(skill)
  local unit = skill.caster
  for i, tbuff in ipairs(unit.buff_list) do
    if tbuff.info.ID == 1077 then
      tbuff.timer = 0
    end
  end
end

function Cat:skillult_basefunc()
  if self.caster.manually_casting then
    ed.engine:unfreeze()
    self.caster.manually_casting = false
  end
  self.attack_counter = self.attack_counter + 1
  if self.info["Target Type"] == "random" or self.target == nil or not self.target:isAlive() then
    self:selectTarget(nil)
  end
  if not self.target then
    return
  end
  local info = self.info
  local caster = self.caster
  self:takeEffectAt(caster.ult_position)
  caster:setMP(caster.mp + info["Gain MP"] * ed.engine.mp_bonus)
  if info["Move Forward"] ~= 0 then
    caster.position[1] = caster.position[1] + info["Move Forward"] * caster.direction
  end
end

function Cat.skillult_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local attack_counter = skill.attack_counter
  caster.ult_position = {}
  caster.ult_position[1] = Cat.selectPosition(skill, 200) or 400
  caster.ult_position[2] = 0
  if attack_counter == 0 then
    skill.attack_counter = skill.attack_counter + 1
    if ed.run_with_scene then
      local effect_name = "eff_impact_Cat_ult.cha"
      local effect_z = 1
      local effect_position = caster.ult_position
      ed.scene:playEffectOnScene(effect_name, effect_position, {
        caster.direction,
        1
      }, nil, effect_z)
    end
  elseif 0 < attack_counter then
    if skill.caster.manually_casting and skill.attack_counter == 1 then
      ed.engine:unfreeze()
      skill.caster.manually_casting = false
    end
    skill:takeEffectAt(caster.ult_position)
    skill.attack_counter = skill.attack_counter + 1
  end
end

function Cat.skillult_takeEffectOn(basefunc, skill, target, source, shift)
  local caster = skill.caster
  local result = basefunc(skill, target, source, shift)
  if result then
    local rand = math.floor(ed.rand() * 3) + 1
    local bid = 1059 + rand
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, target, caster)
    local buffresult = target:addBuff(buff, caster)
  end
end

function Cat.skillline12_power(basefunc, skill, source, target, damage_type)
  local power = basefunc(skill, source, target, damage_type)
  local caster = skill.caster
  local power2 = power * (1 + caster.combo_count * Cat.combo_plus)
  return power2
end

function Cat.skillline3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  buff.timer = buff.timer * (1 + caster.combo_count * Cat.combo_plus)
  return buff
end

function Cat.skillline123_takeEffectOn(basefunc, skill, target)
  if target.camp == skill.caster.camp then
  else
    basefunc(skill, target)
  end
end

function Cat.init_hero(hero)
  local skillult = hero.skills.Cat_ult
  local skillatk = hero.skills.Cat_atk
  local skillatk2 = hero.skills.Cat_atk2
  local skillatk3 = hero.skills.Cat_atk3
  local skillatk4 = hero.skills.Cat_atk4s
  local skillline1 = hero.skills.Cat_line1
  local skillline2 = hero.skills.Cat_line2
  local skillline3 = hero.skills.Cat_line3
  local skillline999 = hero.skills.Cat_line999
  if skillult then
    skillult.onAttackFrame = override(skillult.onAttackFrame, Cat.skillult_onAttackFrame)
    skillult.takeEffectOn = override(skillult.takeEffectOn, Cat.skillult_takeEffectOn)
    skillline1.power = override(skillline1.power, Cat.skillline12_power)
    skillline2.power = override(skillline2.power, Cat.skillline12_power)
    skillline3.createBuff = override(skillline3.createBuff, Cat.skillline3_createBuff)
    skillline1.takeEffectOn = override(skillline1.takeEffectOn, Cat.skillline123_takeEffectOn)
    skillline2.takeEffectOn = override(skillline2.takeEffectOn, Cat.skillline123_takeEffectOn)
    skillline3.takeEffectOn = override(skillline3.takeEffectOn, Cat.skillline123_takeEffectOn)
    skillline999.launchPoint = override(skillline999.launchPoint, Cat.skillline999_launchPoint)
  end
  if skillatk then
    skillatk.onAttackFrame = override(skillatk.onAttackFrame, Cat.skillatk_onAttackFrame)
    skillatk.start = override(skillatk.start, Cat.skillatk_start)
    skillatk.takeEffectOn = override(skillatk.takeEffectOn, Cat.skillatk_takeEffectOn)
    skillatk.createProjectile = override(skillatk.createProjectile, Cat.skillatk_createProjectile)
  end
  if skillatk2 then
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, Cat.skillatk2_onAttackFrame)
    skillatk2.start = override(skillatk2.start, Cat.skillatk2_start)
    skillatk2.finish = override(skillatk2.finish, Cat.skillatk2_finish)
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, Cat.skillatk2_takeEffectOn)
  end
  if skillatk3 then
    skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, Cat.skillatk3_onAttackFrame)
    skillatk3.start = override(skillatk3.start, Cat.skillatk3_start)
    skillatk3.finish = override(skillatk3.finish, Cat.skillatk3_finish)
    skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, Cat.skillatk2_takeEffectOn)
  end
  if skillatk4 then
    skillatk4.onAttackFrame = override(skillatk4.onAttackFrame, Cat.skillatk4_onAttackFrame)
    skillatk4.start = override(skillatk4.start, Cat.skillatk4_start)
    skillatk4.finish = override(skillatk4.finish, Cat.skillatk4_finish)
  end
  hero.reset = override(hero.reset, Cat.hero_reset)
  hero.update = override(hero.update, Cat.hero_update)
  hero.takeDamage = override(hero.takeDamage, Cat.hero_takeDamage)
  return hero
end

return Cat.init_hero
