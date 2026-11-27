module("ed.battlehero", package.seeall)
local ed = ed
TitanDR = {}
TitanDR.TitanDR_atk3BOMBdamage = 0
TitanDR.skillFashionId = 100781
TitanDR.atk3_silence_buffID = 4243

function TitanDR.TitanDR_reset(basefunc, unit)
  basefunc(unit)
  local skillatk = unit.skills.TitanDR_atk
  if skillatk then
    skillatk.cd_remaining = 999
  end
end

function TitanDR.skillult_onAttackFrame(basefunc, skill)
  local skillFashion = skill.caster.skills.TitanDR_Fashion
  if skill.attack_counter == 0 and ed.run_with_scene then
    local effect_name = "eff_point_TitanDR_ult.cha"
    if TitanDR.skillFashionId and TitanDR.skillFashionId == skill.caster.fashion_id then
      effect_name = "eff_point_TitanDRSkin_ult.cha"
    end
    if not effect_name then
      return
    end
    local scaleX = skill.caster.direction
    scaleX = scaleX or 1
    local effect = ed.scene:playEffectOnScene(effect_name, {400, -50}, {
      -scaleX,
      1
    }, nil, 1)
  end
  basefunc(skill)
end

function TitanDR.skillult_takeEffectOn(basefunc, skill, target, source, shift)
  basefunc(skill, target, source, shift)
  if skill.attack_counter == 9 and target and target:isAlive() then
    for i, buff in ipairs(target.buff_list) do
      if buff.info.ID == 964 and buff.timer > 0 then
        buff.timer = 0
        skill.TitanDR_Ecount = skill.TitanDR_Ecount + 1
      elseif buff.info.ID == 965 and buff.timer > 0 then
        buff.timer = 0
        skill.TitanDR_Dcount = skill.TitanDR_Dcount + 1
      elseif buff.info.ID == 966 and buff.timer > 0 then
        buff.timer = 0
        skill.TitanDR_Vcount = skill.TitanDR_Vcount + 1
      end
    end
  end
end

function TitanDR.skillFashion_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.timer = 1 + 0.2 * skill.caster.TitanDR_Fashionultcount
  return buff
end

function TitanDR.skillult_finish(basefunc, skill, reason)
  basefunc(skill, reason)
  local caster = skill.caster
  local skillsub, skillFashion
  if caster and caster:isAlive() then
    skillsub = caster.skills.TitanDR_ultsub
    if TitanDR.skillFashionId and TitanDR.skillFashionId == skill.caster.fashion_id then
      skillFashion = caster.skills.TitanDR_Fashion
    end
  end
  if reason ~= "interrupt" then
    local E = skill.TitanDR_Ecount
    local D = skill.TitanDR_Dcount
    local V = skill.TitanDR_Vcount
    local min = E < D and E or D
    min = V > min and min or V
    if 0 < min then
      caster.TitanDR_Fashionultcount = min
      for i = 1, min do
        skillsub:takeEffectAt(caster.position, caster)
      end
      if skillFashion then
        skillFashion:takeEffectAt(caster.position, caster)
      end
    end
  end
end

function TitanDR.addEDVbuff(target, ID, caster)
  local buff_Ether, buff_Dark, buff_Vacuum
  for i, buff in ipairs(target.buff_list) do
    if buff.info.ID == ID then
      return nil
    end
    if buff.info.ID == 964 then
      buff_Ether = buff
    elseif buff.info.ID == 965 then
      buff_Dark = buff
    elseif buff.info.ID == 966 then
      buff_Vacuum = buff
    end
  end
  local buff_A, buff_B
  local buff_TEMP = buff_Ether and buff_Dark and buff_Vacuum
  if buff_TEMP == buff_Ether then
    buff_A = buff_Dark
    buff_B = buff_Vacuum
  elseif buff_TEMP == buff_Dark then
    buff_A = buff_Ether
    buff_B = buff_Vacuum
  elseif buff_TEMP == buff_Vacuum then
    buff_A = buff_Ether
    buff_B = buff_Dark
  end
  if buff_A and buff_B then
    if buff_A.timer < buff_B.timer then
      buff_A.timer = 0
    else
      buff_B.timer = 0
    end
  end
  local binfo = ed.lookupDataTable("Buff", nil, ID)
  caster = caster or target
  local buff_add = ed.BuffCreate(binfo, target, caster)
  return buff_add
end

function TitanDR.skillatk2_takeEffectOn(basefunc, skill, target, source, shift)
  basefunc(skill, target, source, shift)
  local buff = TitanDR.addEDVbuff(target, 964, skill.caster)
  if buff and TitanDR.skillFashionId and TitanDR.skillFashionId == skill.caster.fashion_id then
    buff.info = ed.wraptable(buff.info, {
      Effect = "eff_buff_TitanDRSkin_atk2.cha"
    })
  end
  local buff_judge = false
  if buff and target.buff_effects then
    if not target.buff_effects.invulnerable then
      buff_judge = true
    end
  elseif buff and not target.buff_effects then
    buff_judge = true
  end
  if buff_judge == true then
    buff.TitanDR_Etimer = 20
    buff.onDamaged = override(buff.onDamaged, TitanDR.skillatk2_Ebuff_onDamaged)
    buff.update = override(buff.update, TitanDR.skillatk2buff_update)
    target:addBuff(buff, skill.caster)
  end
end

function TitanDR.skillatk2buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  buff.TitanDR_Etimer = buff.TitanDR_Etimer + 1
end

function TitanDR.skillatk2_Ebuff_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred)
  local damage = basefunc(buff, damage, damage_type, source, skill, transferred)
  if source and source:isAlive() and source.camp == buff.owner.foecamp then
    return damage
  end
  if 0 < damage and buff.TitanDR_Etimer > 8 then
    buff.TitanDR_Etimer = 0
    buff.TitanDR_overrited = true
    local caster = buff.caster
    local owner = buff.owner
    if source and source:isAlive() and 0 < damage then
      source:takeHeal(20, "mp")
    end
  end
  return damage
end

function TitanDR.skillatk2_power(basefunc, skill, source, target, damage_type)
  local power, coeff = basefunc(skill, source, target, damage_type)
  local APmultiplier = skill.info["Script Arg2"]
  local AP_attrib = skill.caster.attribs.AP
  if APmultiplier and AP_attrib then
    power = power + APmultiplier * AP_attrib
  end
  return power, coeff
end

function TitanDR.skillatk3_takeEffectOn(basefunc, skill, target, source, shift)
  basefunc(skill, target, source, shift)
  local info = skill.info
  local multiplier = info["Script Arg3"]
  local base_attrib = skill.caster.attribs.AD
  TitanDR.TitanDR_atk3BOMBdamage = multiplier * base_attrib + info["Basic Num"]
  local buff = TitanDR.addEDVbuff(target, 965, skill.caster)
  if buff and TitanDR.skillFashionId and TitanDR.skillFashionId == skill.caster.fashion_id then
    buff.info = ed.wraptable(buff.info, {
      Effect = "eff_buff_TitanDRSkin_atk3.cha"
    })
  end
  local buff_judge = false
  if buff and target.buff_effects then
    if not target.buff_effects.invulnerable then
      buff_judge = true
    end
  elseif buff and not target.buff_effects then
    buff_judge = true
  end
  if buff_judge == true then
    buff:setAttribute("HPR", skill.info["Script Arg3"])
    buff.TitanDR_Etimer = 17
    buff.onDamaged = override(buff.onDamaged, TitanDR.skillatk3_Dbuff_onDamaged)
    buff.update = override(buff.update, TitanDR.skillatk2buff_update)
    target:addBuff(buff, skill.caster)
  end
end

function TitanDR.skillatk3_Dbuff_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred)
  local damage = basefunc(buff, damage, damage_type, source, skill, transferred)
  if source and source:isAlive() and source.camp ~= buff.owner.foecamp then
    return damage
  end
  local hpr = buff.info.HPR * 0.125
  if buff.TitanDR_Etimer > 16 then
    buff.TitanDR_Stimer = buff.TitanDR_Stimer and buff.TitanDR_Stimer + 1 or 1
    buff.TitanDR_Etimer = 0
    buff.TitanDR_overrited = true
    local caster = buff.caster
    local targetUnit
    local owner = buff.owner
    if 0 < damage then
      for unit in ed.engine:foreachAliveUnit(owner.camp) do
        if 0 <= unit.position[1] and unit.position[1] <= 800 and unit ~= owner then
          local rand = ed.rand() * 2
          if 1 < rand then
            targetUnit = unit
            break
          end
          targetUnit = unit
        end
      end
      if targetUnit then
        targetUnit.TitanDR_takeBomb = true
        local SpreadBuff_list = {}
        for i, Spreadbuff in ipairs(owner.buff_list) do
          if Spreadbuff.info.ID == 964 then
            table.insert(SpreadBuff_list, 964)
          elseif Spreadbuff.info.ID == 965 then
            table.insert(SpreadBuff_list, 965)
          elseif Spreadbuff.info.ID == 966 then
            table.insert(SpreadBuff_list, 966)
          end
        end
        local tableLen = table.getn(SpreadBuff_list)
        local rand = math.floor(ed.rand() * tableLen) + 1
        local buffID = SpreadBuff_list[rand]
        local buffBomb = false
        for i, OriBuff in ipairs(targetUnit.buff_list) do
          if OriBuff.info.ID == buffID then
            buffBomb = true
          end
        end
        if buff.TitanDR_Stimer > 1 then
          buff.TitanDR_Stimer = nil
          local binfo = ed.lookupDataTable("Buff", nil, TitanDR.atk3_silence_buffID)
          targetUnit:addBuff(binfo, targetUnit)
        end
        if buffBomb == true or buffID == nil then
          targetUnit:takeDamage(TitanDR.TitanDR_atk3BOMBdamage, "Holy", "hp", caster, 1, 1, 0)
        else
          local Spread = TitanDR.addEDVbuff(targetUnit, buffID, caster)
          if Spread.TitanDR_overrited and Spread.TitanDR_overrited == true then
            return
          end
          Spread.TitanDR_Etimer = 20
          if buffID == 964 then
            Spread.onDamaged = override(Spread.onDamaged, TitanDR.skillatk2_Ebuff_onDamaged)
            Spread.update = override(Spread.update, TitanDR.skillatk2buff_update)
            if Spread and TitanDR.skillFashionId and TitanDR.skillFashionId == caster.fashion_id then
              buff.info = ed.wraptable(buff.info, {
                Effect = "eff_buff_TitanDRSkin_atk2.cha"
              })
            end
          elseif buffID == 965 then
            Spread.onDamaged = override(Spread.onDamaged, TitanDR.skillatk3_Dbuff_onDamaged)
            Spread.update = override(Spread.update, TitanDR.skillatk2buff_update)
            if Spread and TitanDR.skillFashionId and TitanDR.skillFashionId == caster.fashion_id then
              buff.info = ed.wraptable(buff.info, {
                Effect = "eff_buff_TitanDRSkin_atk3.cha"
              })
            end
          elseif buffID == 966 then
            Spread.onDamaged = override(Spread.onDamaged, TitanDR.skillatk4_Vbuff_onDamaged)
            Spread.update = override(Spread.update, TitanDR.skillatk2buff_update)
            if Spread and TitanDR.skillFashionId and TitanDR.skillFashionId == caster.fashion_id then
              buff.info = ed.wraptable(buff.info, {
                Effect = "eff_buff_TitanDRSkin_atk4.cha"
              })
            end
          end
          local buff_judge = false
          if Spread and targetUnit.buff_effects then
            if not targetUnit.buff_effects.invulnerable then
              buff_judge = true
            end
          elseif Spread and not targetUnit.buff_effects then
            buff_judge = true
          end
          if buff_judge == true then
            targetUnit:addBuff(Spread, caster)
          end
        end
      end
    end
  end
  return damage
end

function TitanDR.skillatk4_start(basefunc, skill, target)
  basefunc(skill, target)
  skill.TitanDR_atk4_finish = false
end

function TitanDR.skillatk4_takeEffectOn(basefunc, skill, target, source, shift)
  local skillatk4sub2 = skill.caster.skills.TitanDR_atk4sub2
  local skillatk4sub3 = skill.caster.skills.TitanDR_atk4sub3
  local skillFashion = skill.caster.skills.TitanDR_Fashion
  if skill.attack_counter == 1 and target then
    target.notPopupBattleInfo = true
    basefunc(skill, target, source, shift)
    target.notPopupBattleInfo = false
    if skill.attack_counter == 1 then
      if ed.run_with_scene then
        local effect_name = "eff_point_TitanDR_atk4.cha"
        local effect_aura_name = "eff_point_TitanDR_atk4_2.cha"
        if TitanDR.skillFashionId and TitanDR.skillFashionId == skill.caster.fashion_id then
          effect_name = "eff_point_TitanDRSkin_atk4.cha"
          effect_aura_name = "eff_point_TitanDRSkin_atk4_2.cha"
        end
        if not effect_name then
          return
        end
        if skill.TitanDR_atk4_finish ~= nil and skill.TitanDR_atk4_finish == false then
          local scaleX = skill.caster.direction
          scaleX = scaleX or 1
          skillatk4sub3.TitanDR_Matrix = ed.scene:playEffectOnScene(effect_name, target.position, {
            -scaleX,
            1
          }, nil, 1)
          skillatk4sub3.TitanDR_Aura = ed.scene:playEffectOnScene(effect_aura_name, target.position, {
            -scaleX,
            1
          }, nil, -1)
          skill.TitanDR_Matrix = skillatk4sub3.TitanDR_Matrix
          skill.TitanDR_Aura = skillatk4sub3.TitanDR_Aura
          skill.TitanDR_atk4_finish = nil
        end
      end
      skillatk4sub2:takeEffectAt(target.position, skill.caster)
      skill.Matrix_position[1] = target.position[1]
      skill.Matrix_position[2] = target.position[2]
      skillatk4sub3.Matrix_position = skill.Matrix_position
    end
  end
end

function TitanDR.skillatk4_Vbuff_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred)
  local damage = basefunc(buff, damage, damage_type, source, skill, transferred)
  if source and source:isAlive() and source.camp == buff.owner.foecamp and source.camp ~= buff.owner.camp and 0 < damage and buff.TitanDR_Etimer > 16 then
    buff.TitanDR_Etimer = 0
    buff.TitanDR_overrited = true
    local caster = buff.caster
    local owner = buff.owner
    if caster and owner then
      local skillatk4sub = caster.skills.TitanDR_atk4sub
      local skillatk4 = caster.skills.TitanDR_atk4
      owner:takeDamage(skillatk4.info["Script Arg4"], "Holy", "mp", caster)
      skillatk4sub:takeEffectAt(owner.position, caster)
    end
  end
  return damage
end

function TitanDR.skillatk4_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local skillatk4sub3 = caster.skills.TitanDR_atk4sub3
  skill.attack_counter = skill.attack_counter + 1
  if skill.attack_counter == 1 then
    if skill.target then
      skill.Matrix_position[1] = skill.target.position[1]
      skill.Matrix_position[2] = skill.target.position[2]
      skillatk4sub3.Matrix_position = skill.Matrix_position
    end
    skill.attack_counter = skill.attack_counter - 1
    basefunc(skill)
  elseif skill.attack_counter == 2 then
    skill.TitanDR_atk4_move = true
    if caster.manually_casting then
      ed.engine:unfreeze()
      caster.manually_casting = false
    end
    local info = skillatk4sub3.info
    local ttype = info["Track Type"]
    local MPGR = caster.attribs.MPGainRatio
    local projectile = skillatk4sub3:createProjectile()
    ed.engine:addProjectile(projectile)
    if MPGR == nil or MPGR == 1 then
      caster:setMP(caster.mp + info["Gain MP"] * ed.engine.mp_bonus)
    else
      caster:setMP(caster.mp + info["Gain MP"] * ed.engine.mp_bonus * (1 + MPGR / 100))
    end
    if info["Move Forward"] ~= 0 then
      caster.position[1] = caster.position[1] + info["Move Forward"] * caster.direction
    end
  end
end

function TitanDR.skillatk4_createProjectile(basefunc, skill)
  local caster = skill.caster
  local projectile = basefunc(skill)
  local h = projectile.height
  local v = projectile.zSpeed
  local a = skill.info["Tile Gravity"]
  local A = 0.5 * a
  local B = v
  local C = h
  local delta = B ^ 2 - 4 * A * C
  local t = (-B - delta ^ 0.5) / (2 * A)
  local target_position = {
    skill.target.position[1],
    skill.target.position[2]
  }
  local distance = ed.edpSub(target_position, projectile.position)
  projectile.velocity = ed.edpMult(distance, 1 / t)
  projectile.track_target = skill.target
  ed.engine:addProjectile(projectile)
  return nil
end

function TitanDR.skillatk4_projectilecollideCheck(basefunc, projectile, unit)
  local t = basefunc(projectile, unit)
  if unit ~= projectile.skill.target then
    t = 2
  else
    t = 0.5
  end
  return t
end

function TitanDR.skillatk4sub3_createProjectile(basefunc, skill)
  local caster = skill.caster
  local skillatk4 = caster.skills.TitanDR_atk4
  local projectile = basefunc(skill)
  if (not (skill.Matrix_position and skill.Matrix_position[1]) or not skill.Matrix_position[2]) and skill.target then
    skill.Matrix_position[1] = skill.target.position[1]
    skill.Matrix_position[2] = skill.target.position[2]
  end
  projectile.position, projectile.height = skillatk4:launchPoint()
  local d = {
    skill.Matrix_position[1] - projectile.position[1],
    skill.Matrix_position[2] - projectile.position[2]
  }
  projectile.zSpeed = (skill.Matrix_position[2] - projectile.height) / math.abs((skill.Matrix_position[1] - projectile.position[1]) / skill.info["Tile XY Speed"])
  projectile.velocity = ed.edpMult(ed.edpNormalize(d), skill.info["Tile XY Speed"])
  projectile.max_distance = math.abs(projectile.position[1] - skill.Matrix_position[1])
  projectile.hit = override(projectile.hit, TitanDR.skillatk4_pHit)
  projectile.terminate = override(projectile.terminate, TitanDR.skillatk4_pTerminate)
  ed.engine:addProjectile(projectile)
  return nil
end

function TitanDR.skillatk4_finish(basefunc, skill, reason)
  if skill.TitanDR_Matrix then
    ed.scene:removeEffect(skill.TitanDR_Matrix, 1)
  end
  if skill.TitanDR_Aura then
    ed.scene:removeEffect(skill.TitanDR_Aura, -1)
  end
  basefunc(skill, reason)
  local caster = skill.caster
  if skill.TitanDR_atk4_move and skill.TitanDR_atk4_move == true then
    local pos_move = 0
    pos_move = caster.direction * 75
    caster.position[1] = caster.position[1] - pos_move
    skill.TitanDR_atk4_move = nil
  end
  if 0 > caster.position[1] then
    caster.position[1] = 10
    caster:walkTowards({
      100,
      caster.position[2]
    })
  elseif caster.position[1] > 800 then
    caster.position[1] = 790
    caster:walkTowards({
      700,
      caster.position[2]
    })
  end
  skill.TitanDR_atk4_finish = true
end

function TitanDR.skillatk4sub1_takeEffectOn(basefunc, skill, target, source, shift)
  basefunc(skill, target, source, shift)
  local skillatk4 = skill.caster.skills.TitanDR_atk4
  local pos_move = 0
  if target and skillatk4.Matrix_position and math.abs(skillatk4.Matrix_position[1] - target.position[1]) > 20 then
    pos_move = skillatk4.Matrix_position[1] - target.position[1] - 20 * (skillatk4.Matrix_position[1] - target.position[1]) / math.abs(skillatk4.Matrix_position[1] - target.position[1])
    target.position[1] = target.position[1] + pos_move
  end
  local buff = TitanDR.addEDVbuff(target, 966, skill.caster)
  if buff and TitanDR.skillFashionId and TitanDR.skillFashionId == skill.caster.fashion_id then
    buff.info = ed.wraptable(buff.info, {
      Effect = "eff_buff_TitanDRSkin_atk4.cha"
    })
  end
  local buff_judge = false
  if buff and target.buff_effects then
    if not target.buff_effects.invulnerable then
      buff_judge = true
    end
  elseif buff and not target.buff_effects then
    buff_judge = true
  end
  if buff_judge == true then
    buff.TitanDR_Etimer = 20
    buff.onDamaged = override(buff.onDamaged, TitanDR.skillatk4_Vbuff_onDamaged)
    buff.update = override(buff.update, TitanDR.skillatk2buff_update)
    target:addBuff(buff, skill.caster)
  end
end

function TitanDR.skillatk4_pHit(basefunc, pjct, target)
  pjct.TitanDR_atk4_hitunit = target
end

function TitanDR.skillatk4_pTerminate(basefunc, pjct)
  basefunc(pjct)
  local skillatk4sub1
  if pjct.skill.TitanDR_Matrix then
    ed.scene:removeEffect(pjct.skill.TitanDR_Matrix, 1)
  end
  if pjct.skill.TitanDR_Aura then
    ed.scene:removeEffect(pjct.skill.TitanDR_Aura, -1)
  end
  local effect_name = "eff_impact_TitanDR_atk4.cha"
  if ed.run_with_scene then
    ed.scene:playEffectOnScene(effect_name, pjct.skill.Matrix_position, {-1, 1}, nil, 1)
  end
  if pjct.caster then
    skillatk4sub1 = pjct.caster.skills.TitanDR_atk4sub1
    skillatk4sub1:takeEffectAt(pjct.skill.Matrix_position, pjct.caster)
  end
end

function TitanDR.init_hero(hero)
  local skillult = hero.skills.TitanDR_ult
  local skillatk = hero.skills.TitanDR_atk
  local skillatk2 = hero.skills.TitanDR_atk2
  local skillatk3 = hero.skills.TitanDR_atk3
  local skillatk4 = hero.skills.TitanDR_atk4
  local skillatk4sub = hero.skills.TitanDR_atk4sub
  local skillatk4sub1 = hero.skills.TitanDR_atk4sub1
  local skillatk4sub3 = hero.skills.TitanDR_atk4sub3
  local skillFashion = hero.skills.TitanDR_Fashion
  if skillult then
    skillult.onAttackFrame = override(skillult.onAttackFrame, TitanDR.skillult_onAttackFrame)
    skillult.takeEffectOn = override(skillult.takeEffectOn, TitanDR.skillult_takeEffectOn)
    skillult.finish = override(skillult.finish, TitanDR.skillult_finish)
    skillult.TitanDR_Ecount = 0
    skillult.TitanDR_Dcount = 0
    skillult.TitanDR_Vcount = 0
  end
  if skillatk2 then
    hero.reset = override(hero.reset, TitanDR.TitanDR_reset)
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, TitanDR.skillatk2_takeEffectOn)
    skillatk2.power = override(skillatk2.power, TitanDR.skillatk2_power)
  end
  if skillatk3 then
    skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, TitanDR.skillatk3_takeEffectOn)
  end
  if skillatk4 then
    skillatk4.Matrix_position = {}
    skillatk4sub3.Matrix_position = {}
    skillatk4.start = override(skillatk4.start, TitanDR.skillatk4_start)
    skillatk4.onAttackFrame = override(skillatk4.onAttackFrame, TitanDR.skillatk4_onAttackFrame)
    skillatk4.takeEffectOn = override(skillatk4.takeEffectOn, TitanDR.skillatk4_takeEffectOn)
    skillatk4.createProjectile = override(skillatk4.createProjectile, TitanDR.skillatk4_createProjectile)
    skillatk4sub3.createProjectile = override(skillatk4sub3.createProjectile, TitanDR.skillatk4sub3_createProjectile)
    skillatk4sub1.takeEffectOn = override(skillatk4sub1.takeEffectOn, TitanDR.skillatk4sub1_takeEffectOn)
    skillatk4.finish = override(skillatk4.finish, TitanDR.skillatk4_finish)
  end
  if TitanDR.skillFashionId and TitanDR.skillFashionId == hero.fashion_id then
    if skillatk then
      skillatk.info = ed.wraptable(skillatk.info, {
        ["Tile Art"] = "eff_tile_TitanDRSkin_atk.cha"
      })
    end
    if skillatk2 then
      skillatk2.info = ed.wraptable(skillatk2.info, {
        ["Impact Effect"] = "eff_impact_TitanDRSkin_atk2.cha",
        ["Tile Art"] = "eff_tile_TitanDRSkin_atk.cha"
      })
    end
    if skillatk3 then
      skillatk3.info = ed.wraptable(skillatk3.info, {
        ["Impact Effect"] = "eff_impact_TitanDRSkin_atk3.cha"
      })
    end
    if skillatk4 then
      skillatk4.info = ed.wraptable(skillatk4.info, {
        ["Tile Art"] = "eff_tile_TitanDRSkin_atk4.cha",
        ["Impact Effect"] = "eff_impact_TitanDRSkin_atk4.cha"
      })
      skillatk4sub3.info = ed.wraptable(skillatk4sub3.info, {
        ["Tile Art"] = "eff_tile_TitanDRSkin_atk.cha"
      })
    end
    if skillult then
      skillult.info = ed.wraptable(skillult.info, {
        ["Impact Effect"] = "eff_impact_TitanDRSkin_atk2.cha"
      })
    end
    if skillFashion then
      skillFashion.createBuff = override(skillFashion.createBuff, TitanDR.skillFashion_createBuff)
    end
  end
  return hero
end

return TitanDR.init_hero
