module("ed.battlehero", package.seeall)
local ed = ed
MythBOSSTitanDR = {}
MythBOSSTitanDR.bossID = 3
MythBOSSTitanDR.MythBOSSTitanDR_atk3BOMBdamage = 0
MythBOSSTitanDR.atk3_silence_buffID = 4243

function MythBOSSTitanDR.MythBOSSTitanDR_reset(basefunc, unit)
  basefunc(unit)
  unit:setPosition({650, 0})
  local skillatk = unit.skills.MythBOSSTitanDR_atk
  if skillatk then
    skillatk.cd_remaining = 999
  end
  local info = ed.getDataTable("MythBossReward")
  unit.BossStageList = {}
  unit.BossTotalHp = unit.attribs.HP
  unit.Boss_nstage = 0
  unit.Boss_stageBuff = nil
  unit.mp = 1000
  for _, group in ipairs(info) do
    repeat
      if not group[MythBOSSTitanDR.bossID] then
      else
        if group[MythBOSSTitanDR.bossID]["Boss RewardLine ID"] == MythBOSSTitanDR.bossID then
          table.insert(unit.BossStageList, group)
        else
        end
        break -- pseudo-goto
      end
    until true
  end
end

function MythBOSSTitanDR.skillult_onAttackFrame(basefunc, skill)
  if skill.attack_counter == 0 and ed.run_with_scene then
    local effect_name = "eff_point_TitanDR_ult.cha"
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

function MythBOSSTitanDR.skillult_takeEffectOn(basefunc, skill, target, source, shift)
  basefunc(skill, target, source, shift)
  if skill.attack_counter == 9 and target and target:isAlive() then
    for i, buff in ipairs(target.buff_list) do
      if buff.info.ID == 964 and buff.timer > 0 then
        buff.timer = 0
        skill.MythBOSSTitanDR_Ecount = skill.MythBOSSTitanDR_Ecount + 1
      elseif buff.info.ID == 965 and buff.timer > 0 then
        buff.timer = 0
        skill.MythBOSSTitanDR_Dcount = skill.MythBOSSTitanDR_Dcount + 1
      elseif buff.info.ID == 966 and buff.timer > 0 then
        buff.timer = 0
        skill.MythBOSSTitanDR_Vcount = skill.MythBOSSTitanDR_Vcount + 1
      end
    end
  end
end

function MythBOSSTitanDR.skillult_finish(basefunc, skill, reason)
  basefunc(skill, reason)
  local caster = skill.caster
  local skillsub
  if caster and caster:isAlive() then
    skillsub = caster.skills.MythBOSSTitanDR_ultsub
  end
  if reason ~= "interrupt" then
    local E = skill.MythBOSSTitanDR_Ecount
    local D = skill.MythBOSSTitanDR_Dcount
    local V = skill.MythBOSSTitanDR_Vcount
    local min = E < D and E or D
    min = V > min and min or V
  end
end

function MythBOSSTitanDR.addEDVbuff(target, ID, caster)
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

function MythBOSSTitanDR.skillatk2_takeEffectOn(basefunc, skill, target, source, shift)
  basefunc(skill, target, source, shift)
  local buff = MythBOSSTitanDR.addEDVbuff(target, 964, skill.caster)
  local buff_judge = false
  if buff and target.buff_effects then
    if not target.buff_effects.invulnerable then
      buff_judge = true
    end
  elseif buff and not target.buff_effects then
    buff_judge = true
  end
  if buff_judge == true then
    buff.MythBOSSTitanDR_Etimer = 20
    buff.onDamaged = override(buff.onDamaged, MythBOSSTitanDR.skillatk2_Ebuff_onDamaged)
    buff.update = override(buff.update, MythBOSSTitanDR.skillatk2buff_update)
    target:addBuff(buff, skill.caster)
  end
end

function MythBOSSTitanDR.skillatk2buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  buff.MythBOSSTitanDR_Etimer = buff.MythBOSSTitanDR_Etimer + 1
end

function MythBOSSTitanDR.skillatk2_Ebuff_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred)
  local damage = basefunc(buff, damage, damage_type, source, skill, transferred)
  if source and source:isAlive() and source.camp == buff.owner.foecamp then
    return damage
  end
  if 0 < damage and buff.MythBOSSTitanDR_Etimer > 8 then
    buff.MythBOSSTitanDR_Etimer = 0
    buff.MythBOSSTitanDR_overrited = true
    local caster = buff.caster
    local owner = buff.owner
    if source and source:isAlive() and 0 < damage then
      source:takeHeal(20, "mp")
    end
  end
  return damage
end

function MythBOSSTitanDR.skillatk2_power(basefunc, skill, source, target, damage_type)
  local power, coeff = basefunc(skill, source, target, damage_type)
  local APmultiplier = skill.info["Script Arg2"]
  local AP_attrib = skill.caster.attribs.AP
  if APmultiplier and AP_attrib then
    power = power + APmultiplier * AP_attrib
  end
  return power, coeff
end

function MythBOSSTitanDR.skillatk3_takeEffectOn(basefunc, skill, target, source, shift)
  basefunc(skill, target, source, shift)
  local info = skill.info
  local multiplier = info["Script Arg3"]
  local base_attrib = skill.caster.attribs.AD
  MythBOSSTitanDR.MythBOSSTitanDR_atk3BOMBdamage = multiplier * base_attrib + info["Basic Num"]
  local buff = MythBOSSTitanDR.addEDVbuff(target, 965, skill.caster)
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
    buff.MythBOSSTitanDR_Etimer = 17
    buff.onDamaged = override(buff.onDamaged, MythBOSSTitanDR.skillatk3_Dbuff_onDamaged)
    buff.update = override(buff.update, MythBOSSTitanDR.skillatk2buff_update)
    target:addBuff(buff, skill.caster)
  end
end

function MythBOSSTitanDR.skillatk3_Dbuff_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred)
  local damage = basefunc(buff, damage, damage_type, source, skill, transferred)
  if source and source:isAlive() and source.camp ~= buff.owner.foecamp then
    return damage
  end
  local hpr = buff.info.HPR * 0.125
  if buff.MythBOSSTitanDR_Etimer > 16 then
    buff.MythBOSSTitanDR_Stimer = buff.MythBOSSTitanDR_Stimer and buff.MythBOSSTitanDR_Stimer + 1 or 1
    buff.MythBOSSTitanDR_Etimer = 0
    buff.MythBOSSTitanDR_overrited = true
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
        targetUnit.MythBOSSTitanDR_takeBomb = true
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
        if buff.MythBOSSTitanDR_Stimer > 1 then
          buff.MythBOSSTitanDR_Stimer = nil
          local binfo = ed.lookupDataTable("Buff", nil, MythBOSSTitanDR.atk3_silence_buffID)
          targetUnit:addBuff(binfo, targetUnit)
        end
        if buffBomb == true or buffID == nil then
          targetUnit:takeDamage(MythBOSSTitanDR.MythBOSSTitanDR_atk3BOMBdamage, "Holy", "hp", caster, 1, 1, 0)
        else
          local Spread = MythBOSSTitanDR.addEDVbuff(targetUnit, buffID, caster)
          if Spread.MythBOSSTitanDR_overrited and Spread.MythBOSSTitanDR_overrited == true then
            return
          end
          Spread.MythBOSSTitanDR_Etimer = 20
          if buffID == 964 then
            Spread.onDamaged = override(Spread.onDamaged, MythBOSSTitanDR.skillatk2_Ebuff_onDamaged)
            Spread.update = override(Spread.update, MythBOSSTitanDR.skillatk2buff_update)
          elseif buffID == 965 then
            Spread.onDamaged = override(Spread.onDamaged, MythBOSSTitanDR.skillatk3_Dbuff_onDamaged)
            Spread.update = override(Spread.update, MythBOSSTitanDR.skillatk2buff_update)
          elseif buffID == 966 then
            Spread.onDamaged = override(Spread.onDamaged, MythBOSSTitanDR.skillatk4_Vbuff_onDamaged)
            Spread.update = override(Spread.update, MythBOSSTitanDR.skillatk2buff_update)
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

function MythBOSSTitanDR.skillatk4_start(basefunc, skill, target)
  basefunc(skill, target)
  skill.MythBOSSTitanDR_atk4_finish = false
end

function MythBOSSTitanDR.skillatk4_takeEffectOn(basefunc, skill, target, source, shift)
  local skillatk4sub2 = skill.caster.skills.MythBOSSTitanDR_atk4sub2
  local skillatk4sub3 = skill.caster.skills.MythBOSSTitanDR_atk4sub3
  if skill.attack_counter == 1 and target then
    target.notPopupBattleInfo = true
    basefunc(skill, target, source, shift)
    target.notPopupBattleInfo = false
    if skill.attack_counter == 1 then
      if ed.run_with_scene then
        local effect_name = "eff_point_TitanDR_atk4.cha"
        local effect_aura_name = "eff_point_TitanDR_atk4_2.cha"
        if not effect_name then
          return
        end
        if skill.MythBOSSTitanDR_atk4_finish ~= nil and skill.MythBOSSTitanDR_atk4_finish == false then
          local scaleX = skill.caster.direction
          scaleX = scaleX or 1
          skillatk4sub3.MythBOSSTitanDR_Matrix = ed.scene:playEffectOnScene(effect_name, target.position, {
            -scaleX,
            1
          }, nil, 1)
          skillatk4sub3.MythBOSSTitanDR_Aura = ed.scene:playEffectOnScene(effect_aura_name, target.position, {
            -scaleX,
            1
          }, nil, -1)
          skill.MythBOSSTitanDR_Matrix = skillatk4sub3.MythBOSSTitanDR_Matrix
          skill.MythBOSSTitanDR_Aura = skillatk4sub3.MythBOSSTitanDR_Aura
          skill.MythBOSSTitanDR_atk4_finish = nil
        end
      end
      skillatk4sub2:takeEffectAt(target.position, skill.caster)
      skill.Matrix_position[1] = target.position[1]
      skill.Matrix_position[2] = target.position[2]
      skillatk4sub3.Matrix_position = skill.Matrix_position
    end
  end
end

function MythBOSSTitanDR.skillatk4_Vbuff_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred)
  local damage = basefunc(buff, damage, damage_type, source, skill, transferred)
  if source and source:isAlive() and source.camp == buff.owner.foecamp and source.camp ~= buff.owner.camp and 0 < damage and buff.MythBOSSTitanDR_Etimer > 16 then
    buff.MythBOSSTitanDR_Etimer = 0
    buff.MythBOSSTitanDR_overrited = true
    local caster = buff.caster
    local owner = buff.owner
    if caster and owner then
      local skillatk4sub = caster.skills.MythBOSSTitanDR_atk4sub
      local skillatk4 = caster.skills.MythBOSSTitanDR_atk4
      owner:takeDamage(skillatk4.info["Script Arg4"], "Holy", "mp", caster)
      skillatk4sub:takeEffectAt(owner.position, caster)
    end
  end
  return damage
end

function MythBOSSTitanDR.skillatk4_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local skillatk4sub3 = caster.skills.MythBOSSTitanDR_atk4sub3
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
    skill.MythBOSSTitanDR_atk4_move = true
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

function MythBOSSTitanDR.skillatk4_createProjectile(basefunc, skill)
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

function MythBOSSTitanDR.skillatk4_projectilecollideCheck(basefunc, projectile, unit)
  local t = basefunc(projectile, unit)
  if unit ~= projectile.skill.target then
    t = 2
  else
    t = 0.5
  end
  return t
end

function MythBOSSTitanDR.skillatk4sub3_createProjectile(basefunc, skill)
  local caster = skill.caster
  local skillatk4 = caster.skills.MythBOSSTitanDR_atk4
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
  projectile.hit = override(projectile.hit, MythBOSSTitanDR.skillatk4_pHit)
  projectile.terminate = override(projectile.terminate, MythBOSSTitanDR.skillatk4_pTerminate)
  ed.engine:addProjectile(projectile)
  return nil
end

function MythBOSSTitanDR.skillatk4_finish(basefunc, skill, reason)
  if skill.MythBOSSTitanDR_Matrix then
    ed.scene:removeEffect(skill.MythBOSSTitanDR_Matrix, 1)
  end
  if skill.MythBOSSTitanDR_Aura then
    ed.scene:removeEffect(skill.MythBOSSTitanDR_Aura, -1)
  end
  basefunc(skill, reason)
  local caster = skill.caster
  if skill.MythBOSSTitanDR_atk4_move and skill.MythBOSSTitanDR_atk4_move == true then
    local pos_move = 0
    pos_move = caster.direction * 75
    caster.position[1] = caster.position[1] - pos_move
    skill.MythBOSSTitanDR_atk4_move = nil
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
  skill.MythBOSSTitanDR_atk4_finish = true
end

function MythBOSSTitanDR.skillatk4sub1_takeEffectOn(basefunc, skill, target, source, shift)
  basefunc(skill, target, source, shift)
  local skillatk4 = skill.caster.skills.MythBOSSTitanDR_atk4
  local pos_move = 0
  if target and skillatk4.Matrix_position and math.abs(skillatk4.Matrix_position[1] - target.position[1]) > 20 then
    pos_move = skillatk4.Matrix_position[1] - target.position[1] - 20 * (skillatk4.Matrix_position[1] - target.position[1]) / math.abs(skillatk4.Matrix_position[1] - target.position[1])
    target.position[1] = target.position[1] + pos_move
  end
  local buff = MythBOSSTitanDR.addEDVbuff(target, 966, skill.caster)
  local buff_judge = false
  if buff and target.buff_effects then
    if not target.buff_effects.invulnerable then
      buff_judge = true
    end
  elseif buff and not target.buff_effects then
    buff_judge = true
  end
  if buff_judge == true then
    buff.MythBOSSTitanDR_Etimer = 20
    buff.onDamaged = override(buff.onDamaged, MythBOSSTitanDR.skillatk4_Vbuff_onDamaged)
    buff.update = override(buff.update, MythBOSSTitanDR.skillatk2buff_update)
    target:addBuff(buff, skill.caster)
  end
end

function MythBOSSTitanDR.skillatk4_pHit(basefunc, pjct, target)
  pjct.MythBOSSTitanDR_atk4_hitunit = target
end

function MythBOSSTitanDR.skillatk4_pTerminate(basefunc, pjct)
  basefunc(pjct)
  local skillatk4sub1
  if pjct.skill.MythBOSSTitanDR_Matrix then
    ed.scene:removeEffect(pjct.skill.MythBOSSTitanDR_Matrix, 1)
  end
  if pjct.skill.MythBOSSTitanDR_Aura then
    ed.scene:removeEffect(pjct.skill.MythBOSSTitanDR_Aura, -1)
  end
  local effect_name = "eff_impact_TitanDR_atk4.cha"
  if ed.run_with_scene then
    ed.scene:playEffectOnScene(effect_name, pjct.skill.Matrix_position, {-1, 1}, nil, 1)
  end
  if pjct.caster then
    skillatk4sub1 = pjct.caster.skills.MythBOSSTitanDR_atk4sub1
    skillatk4sub1:takeEffectAt(pjct.skill.Matrix_position, pjct.caster)
  end
end

function MythBOSSTitanDR.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  local lostHp = hero.BossTotalHp - hero.hp
  local stagechange
  for i, Hpstage in ipairs(hero.BossStageList) do
    if lostHp >= Hpstage[MythBOSSTitanDR.bossID]["Damage Value"] and i > hero.Boss_nstage then
      hero.Boss_nstage = i
      stagechange = true
    end
  end
  if stagechange then
    if hero.Boss_stageBuff then
      hero.Boss_stageBuff.timer = -1
    end
    local binfo = ed.lookupDataTable("Buff", nil, hero.BossStageList[hero.Boss_nstage][MythBOSSTitanDR.bossID]["Buff ID"])
    local buff = ed.BuffCreate(binfo, hero, hero)
    hero.Boss_stageBuff = hero:addBuff(buff, hero)
  end
end

function MythBOSSTitanDR.init_hero(hero)
  local skillult = hero.skills.MythBOSSTitanDR_ult
  local skillatk = hero.skills.MythBOSSTitanDR_atk
  local skillatk2 = hero.skills.MythBOSSTitanDR_atk2
  local skillatk3 = hero.skills.MythBOSSTitanDR_atk3
  local skillatk4 = hero.skills.MythBOSSTitanDR_atk4
  local skillatk4sub = hero.skills.MythBOSSTitanDR_atk4sub
  local skillatk4sub1 = hero.skills.MythBOSSTitanDR_atk4sub1
  local skillatk4sub3 = hero.skills.MythBOSSTitanDR_atk4sub3
  hero.update = override(hero.update, MythBOSSTitanDR.hero_update)
  if skillult then
    skillult.onAttackFrame = override(skillult.onAttackFrame, MythBOSSTitanDR.skillult_onAttackFrame)
    skillult.takeEffectOn = override(skillult.takeEffectOn, MythBOSSTitanDR.skillult_takeEffectOn)
    skillult.finish = override(skillult.finish, MythBOSSTitanDR.skillult_finish)
    skillult.MythBOSSTitanDR_Ecount = 0
    skillult.MythBOSSTitanDR_Dcount = 0
    skillult.MythBOSSTitanDR_Vcount = 0
  end
  if skillatk2 then
    hero.reset = override(hero.reset, MythBOSSTitanDR.MythBOSSTitanDR_reset)
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, MythBOSSTitanDR.skillatk2_takeEffectOn)
    skillatk2.power = override(skillatk2.power, MythBOSSTitanDR.skillatk2_power)
  end
  if skillatk3 then
    skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, MythBOSSTitanDR.skillatk3_takeEffectOn)
  end
  if skillatk4 then
    skillatk4.Matrix_position = {}
    skillatk4sub3.Matrix_position = {}
    skillatk4.start = override(skillatk4.start, MythBOSSTitanDR.skillatk4_start)
    skillatk4.onAttackFrame = override(skillatk4.onAttackFrame, MythBOSSTitanDR.skillatk4_onAttackFrame)
    skillatk4.takeEffectOn = override(skillatk4.takeEffectOn, MythBOSSTitanDR.skillatk4_takeEffectOn)
    skillatk4.createProjectile = override(skillatk4.createProjectile, MythBOSSTitanDR.skillatk4_createProjectile)
    skillatk4sub3.createProjectile = override(skillatk4sub3.createProjectile, MythBOSSTitanDR.skillatk4sub3_createProjectile)
    skillatk4sub1.takeEffectOn = override(skillatk4sub1.takeEffectOn, MythBOSSTitanDR.skillatk4sub1_takeEffectOn)
    skillatk4.finish = override(skillatk4.finish, MythBOSSTitanDR.skillatk4_finish)
  end
  return hero
end

return MythBOSSTitanDR.init_hero
