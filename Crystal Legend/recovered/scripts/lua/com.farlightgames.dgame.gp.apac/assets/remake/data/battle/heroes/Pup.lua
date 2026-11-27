module("ed.battlehero", package.seeall)
local ed = ed
Pup = {}
Pup.Pup_unitID = 10047
Pup.Pup_unconBuffID = 1189
Pup.Pup_babyBuffID = 1194
Pup.Pup_babyID = 248
Pup.Pup_babyHPRatio = 0.8
Pup.Pup_babyHPLimit = 0.35
Pup.Pup_babyMPRatio = 0.5
Pup.Pup_babyCountStayTime = 0.75
Pup.Pup_babyCountFlyTime = 0.75
Pup.ghost_remianTime = 1.8
Pup.Pup_soulMarkBuffID = 1201
Pup.Pup_soulMarkSelfBuffID = 1237
Pup.Pup_soulhurtBuffID = 1202
Pup.Pup_soulhurtRatio = 0.35
Pup.Pup_outDamageHPRatio = 0.15
Pup.Pup_outDamageTimesLimit = 5
Pup.Pup_awakeBuffID = 1210
Pup.Pup_ultBuffID = 1212
Pup.Pup_ultcBuffID = 1213
Pup.Pup_ultdBuffID = 1214
Pup.Pup_ultDuration = 30
Pup.Pup_ultSelfDmg = 0.13

function Pup.Pup_setCustomSpeed(speedX, speedY)
  local Vx = speedX
  local Vy = speedY
  local xSpeedLimit = 399
  local ySpeedLimit = 99
  if speedX > xSpeedLimit then
    Vx = xSpeedLimit
  elseif speedX < -xSpeedLimit then
    Vx = -xSpeedLimit
  end
  if speedY > ySpeedLimit then
    Vy = ySpeedLimit
  elseif speedY < -ySpeedLimit then
    Vy = -ySpeedLimit
  end
  return {Vx, Vy}
end

function Pup.Pup_hpBarcustomPercent(basefunc, HpBar)
  local caster = HpBar.unit
  if caster.Pup_fakeHP then
    local customPercent = caster.Pup_fakeHP / caster.attribs.HP
    return customPercent
  end
end

function Pup.Pup_floatBarCustomPercent(basefunc, HpBar)
  local caster = HpBar.unit
  if caster.Pup_fakeHP then
    local customPercent = caster.Pup_fakeHP / caster.attribs.HP
    return customPercent
  end
end

function Pup.skillult_update(basefunc, skill, dt_action, dt_cd)
  local caster = skill.caster
  basefunc(skill, dt_action, dt_cd)
  if not caster.Pup_unconADD then
    local binfo = ed.lookupDataTable("Buff", nil, Pup.Pup_unconBuffID)
    local unconBuff = ed.BuffCreate(binfo, caster, caster)
    caster:addBuff(unconBuff, caster)
    caster.Pup_unconADD = true
  end
  if not caster.Pup_hpBarOverride then
    caster.Pup_hpBarOverride = true
    if ed.run_with_scene and caster.actor then
      if caster.heroPanel then
        caster.heroPanel.hp_bar.customPercent = override(caster.heroPanel.hp_bar.customPercent, Pup.Pup_hpBarcustomPercent)
      end
      caster.actor.bar_hp.customPercent = override(caster.actor.bar_hp.customPercent, Pup.Pup_floatBarCustomPercent)
    end
  end
end

function Pup.skillult_start(basefunc, skill, target)
  local caster = skill.caster
  local binfo = ed.lookupDataTable("Buff", nil, Pup.Pup_ultBuffID)
  local unconBuff = ed.BuffCreate(binfo, caster, caster)
  caster:addBuff(unconBuff, caster)
  basefunc(skill, target)
  caster.Pup_isMad = true
  caster.Pup_ultStartPos = {
    caster.position[1],
    caster.position[2]
  }
end

function Pup.skillult_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  if caster:isAlive() then
    for i, tbuff in ipairs(caster.buff_list) do
      if tbuff.info.ID == Pup.Pup_ultBuffID then
        tbuff.timer = 0
      end
    end
    if ed.protoAwake(caster.proto, Pup.Pup_unitID) then
      caster:enterActionStageFromOneStage(4, Pup.Pup_unitID)
    else
      caster:enterActionStageFromOneStage(3, Pup.Pup_unitID)
    end
    if caster.actor then
      caster.actor:update(0.016)
    end
    if ed.run_with_scene then
      local panel = caster.heroPanel
      if panel then
        if ed.protoAwake(caster.proto, Pup.Pup_unitID) then
          panel:setPortrait("UI/DOTA-HERO/SwitchPup_2.png")
        else
          panel:setPortrait("UI/DOTA-HERO/Pup_2.png")
        end
      end
    end
  end
end

function Pup.hero_setAction(basefunc, hero, action_name, loop, interrupt)
  if action_name == "Death" and (hero.currentActionStage == 3 or hero.currentActionStage == 4) then
    action_name = "ultc"
  end
  basefunc(hero, action_name, loop, interrupt)
end

function Pup.hero_updateUlt(basefunc, hero, dt)
  if hero.state == ed.emUnitState_Dying and (hero.currentActionStage == 3 or hero.currentActionStage == 4) then
    if not hero.dyingTimer_Pup then
      hero.dyingTimer_Pup = 2.1
    end
    hero.dyingTimer_Pup = hero.dyingTimer_Pup - dt
    if hero.dyingTimer_Pup <= 0 and not hero.CHEN_ult1time then
      hero.dyingTimer_Pup = 99999
      local skill = hero.skills.Pup_ultc
      if skill then
        local originInfo = skill.info
        local originRatio = skill.info["Plus Ratio"]
        skill.info = ed.wraptable(originInfo, {
          ["Plus Ratio"] = originRatio * 0.8
        })
        skill:takeEffectAt(hero.position)
        skill.info = originInfo
      end
    end
  end
  basefunc(hero, dt)
  if hero:isAlive() and hero.Pup_isMad then
    hero.Pup_madTime = hero.Pup_madTime + dt
    if hero.Pup_madTime >= Pup.Pup_ultDuration then
      if hero.current_skill then
        hero.current_skill:interrupt()
      end
      if ed.protoAwake(hero.proto, Pup.Pup_unitID) then
        hero:enterActionStageFromOneStage(2, Pup.Pup_unitID)
      else
        hero:enterActionStageFromOneStage(1, Pup.Pup_unitID)
      end
      if hero.actor then
        hero.actor:update(0.016)
      end
      if ed.run_with_scene then
        local panel = hero.heroPanel
        if panel then
          if ed.protoAwake(hero.proto, Pup.Pup_unitID) then
            panel:setPortrait("UI/DOTA-HERO/SwitchPup.png")
          else
            panel:setPortrait("UI/DOTA-HERO/Pup.png")
          end
        end
      end
      hero.Pup_isMad = false
      hero.Pup_madTime = 0
    end
  end
end

function Pup.skillulta_takeEffectAt(basefunc, skill, location, source)
  local caster = skill.caster
  if skill.attack_counter == 1 then
    if skill.target then
      local position1 = skill.target.position[1] + caster.direction * 30
      if skill.target.buff_effects.stable or position1 >= ed.engine.stage_rect.maxX or position1 <= ed.engine.stage_rect.minX then
        position1 = position1 - caster.direction * 60
      end
      caster:setPosition({
        position1,
        skill.target.position[2]
      })
      caster.direction = caster.position[1] - skill.target.position[1] <= 0 and 1 or -1
    end
  else
    basefunc(skill, location, source)
  end
end

function Pup.skillultb_onAttackFrame(basefunc, skill)
  if skill.attack_counter == 0 then
    local originInfo = skill.info
    local originPlus = skill.info["Plus Ratio"]
    skill.info = ed.wraptable(originInfo, {
      ["Knock Up"] = 0,
      ["Plus Ratio"] = originPlus * 0.3
    })
    basefunc(skill)
    skill.info = originInfo
  elseif skill.attack_counter == 1 then
    local originInfo = skill.info
    skill.info = ed.wraptable(originInfo, {
      ["Buff ID"] = 0
    })
    basefunc(skill)
    skill.info = originInfo
  end
end

function Pup.skillultc_start(basefunc, skill, target)
  local caster = skill.caster
  local binfo = ed.lookupDataTable("Buff", nil, Pup.Pup_ultcBuffID)
  local unconBuff = ed.BuffCreate(binfo, caster, caster)
  caster:addBuff(unconBuff, caster)
  basefunc(skill, target)
end

function Pup.skillultc_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  if caster:isAlive() then
    local remainHP = caster.hp - caster.attribs.HP * Pup.Pup_ultSelfDmg
    if remainHP <= 0 then
      remainHP = 10
    end
    caster:setHP(remainHP)
    caster.Pup_fakeHP = 9
    if ed.run_with_scene then
      local neweffect = "eff_point_Pup_ulte.cha"
      ed.scene:playEffectOnScene(neweffect, {
        caster.position[1],
        caster.position[2] - 1
      }, {0.9, 0.9}, nil, 1)
    end
  end
end

function Pup.skillultc_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  if caster:isAlive() then
    local skillultd = caster.skills.Pup_ultd
    if skillultd then
      caster:castSkill(skillultd, caster)
    end
  end
  if caster:isAlive() then
    for i, tbuff in ipairs(caster.buff_list) do
      if tbuff.info.ID == Pup.Pup_ultcBuffID then
        tbuff.timer = 0
      end
    end
  end
end

function Pup.skillultd_start(basefunc, skill, target)
  local caster = skill.caster
  local binfo = ed.lookupDataTable("Buff", nil, Pup.Pup_ultdBuffID)
  local unconBuff = ed.BuffCreate(binfo, caster, caster)
  caster:addBuff(unconBuff, caster)
  basefunc(skill, target)
end

function Pup.skillultd_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  if caster:isAlive() then
    if ed.protoAwake(caster.proto, Pup.Pup_unitID) then
      caster:enterActionStageFromOneStage(2, Pup.Pup_unitID)
    else
      caster:enterActionStageFromOneStage(1, Pup.Pup_unitID)
    end
    if caster.actor then
      caster.actor:update(0.016)
    end
    if ed.run_with_scene then
      local panel = caster.heroPanel
      if panel then
        if ed.protoAwake(caster.proto, Pup.Pup_unitID) then
          panel:setPortrait("UI/DOTA-HERO/SwitchPup.png")
        else
          panel:setPortrait("UI/DOTA-HERO/Pup.png")
        end
      end
    end
    caster.Pup_isMad = false
    caster.Pup_madTime = 0
    caster.Pup_fakeHP = nil
  end
  if caster:isAlive() then
    for i, tbuff in ipairs(caster.buff_list) do
      if tbuff.info.ID == Pup.Pup_ultdBuffID then
        tbuff.timer = 0
      end
    end
  end
end

function Pup.skillultd_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  if skill.attack_counter == 1 then
    caster.Pup_fakeHP = caster.hp
  end
  if skill.attack_counter == 2 then
    caster:setPosition({
      caster.Pup_ultStartPos[1],
      caster.Pup_ultStartPos[2]
    })
    caster.direction = caster:getInitDir()
  end
end

function Pup.Pup_markBuffRemoved(basefunc, buff)
  basefunc(buff)
  if buff.DadBuff and buff.DadBuff.timer and buff.DadBuff.timer > 0 then
    buff.DadBuff.timer = 0
  end
end

function Pup.ghost_update(basefunc, projectile, dt)
  if projectile.boss:isAlive() and not projectile.terminated and not projectile.boss.buff_effects.untargetable then
    projectile.durTime = projectile.durTime + dt
    if projectile.durTime >= Pup.ghost_remianTime then
      if projectile.PupBaby_DAD and projectile.PupBaby_DAD:isAlive() then
        projectile.PupBaby_DAD:takeHeal(projectile.PupBaby_HP, "hp", projectile.PupBaby_DAD)
        projectile.PupBaby_DAD:takeHeal(projectile.PupBaby_MP, "mp", projectile.PupBaby_DAD)
        if ed.run_with_scene then
          local neweffect = "eff_impact_Pup_atk3b.cha"
          ed.scene:playEffectOnScene(neweffect, {
            projectile.PupBaby_DAD.position[1],
            projectile.PupBaby_DAD.position[2] - 1
          }, {0.9, 0.9}, nil, 1)
        end
        if projectile.PupBaby_Victim and projectile.PupBaby_Victim:isAlive() then
          local binfo = ed.lookupDataTable("Buff", nil, Pup.Pup_soulMarkBuffID)
          local markBuff = ed.BuffCreate(binfo, projectile.PupBaby_Victim, projectile.PupBaby_DAD)
          local selfbinfo = ed.lookupDataTable("Buff", nil, Pup.Pup_soulMarkSelfBuffID)
          local selfBuff = ed.BuffCreate(selfbinfo, projectile.PupBaby_DAD, projectile.PupBaby_DAD)
          projectile.PupBaby_DAD:addBuff(selfBuff, projectile.PupBaby_DAD)
          markBuff.DadBuff = selfBuff
          markBuff.onRemoved = override(markBuff.onRemoved, Pup.Pup_markBuffRemoved)
          projectile.PupBaby_Victim:addBuff(markBuff, projectile.PupBaby_DAD)
          local hasVic = false
          for k, v in ipairs(projectile.PupBaby_DAD.Pup_victimList) do
            if v == projectile.PupBaby_Victim then
              hasVic = true
              break
            end
          end
          if not hasVic then
            table.insert(projectile.PupBaby_DAD.Pup_victimList, projectile.PupBaby_Victim)
          end
        end
        projectile:terminate()
      end
    else
      local remianTime = Pup.ghost_remianTime - projectile.durTime
      local dis = ed.edpSub(projectile.boss.position, projectile.position)
      if projectile.durTime <= 0.625 then
        projectile.velocity = ed.edpMult(dis, 1 / (remianTime * 2.5))
      else
        projectile.velocity = ed.edpMult(dis, 1 / (remianTime * 0.85))
      end
    end
  else
    projectile:terminate()
  end
  basefunc(projectile, dt)
end

function Pup.ghost_hit(basefunc, projectile, target)
  return
end

function Pup.skillatk3_takeEffectOn(basefunc, skill, target, source, shift)
  local ret, dmg, crit, lfs = basefunc(skill, target, source, shift)
  local caster = skill.caster
  if ret then
    local costMP = skill.info["Script Arg6"]
    target:takeDamage(costMP, "Holy", "mp", caster)
    if ed.run_with_scene then
      local neweffect = "eff_impact_Pup_atk3.cha"
      ed.scene:playEffectOnScene(neweffect, {
        target.position[1],
        target.position[2] - 1
      }, {0.9, 0.9}, nil, 1)
    end
    local skillatk3a = caster.skills.Pup_atk3a
    if skillatk3a then
      skillatk3a.target = caster
      local ghost = skillatk3a:createProjectile()
      ghost.PupBaby_DAD = caster
      ghost.PupBaby_Victim = target
      ghost.PupBaby_CountTime = 0
      ghost.PupBaby_MP = costMP * Pup.Pup_babyMPRatio
      if dmg * Pup.Pup_babyHPRatio < caster.attribs.HP * Pup.Pup_babyHPLimit then
        ghost.PupBaby_HP = dmg * Pup.Pup_babyHPRatio
      else
        ghost.PupBaby_HP = caster.attribs.HP * Pup.Pup_babyHPLimit
      end
      ghost.boss = caster
      ghost.track_target = caster
      ghost.durTime = 0
      ghost.position = {
        target.position[1],
        target.position[2]
      }
      ghost.height = 30
      ghost.update = override(ghost.update, Pup.ghost_update)
      ghost.hit = override(ghost.hit, Pup.ghost_hit)
      ed.engine:addProjectile(ghost)
    end
  end
  return ret, dmg, crit, lfs
end

function Pup.hero_takeDamageAtk3(basefunc, hero, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
  local heroHPLeft = hero.hp
  local lost, bCrit = basefunc(hero, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
  if lost and hero:isAlive() and hero.Pup_damageStat then
    local damageNum = heroHPLeft >= lost and lost or heroHPLeft
    hero.Pup_damageStat[2] = hero.Pup_damageStat[2] + damageNum
  end
  return lost, bCrit
end

function Pup.hero_updateAtk3(basefunc, hero, dt)
  basefunc(hero, dt)
  if hero:isAlive() then
    local newVictimList = {}
    for _, unit in ipairs(hero.Pup_victimList) do
      if not unit:isAlive() then
      else
        for _, buff in ipairs(unit.buff_list) do
          if buff.info.ID == Pup.Pup_soulMarkBuffID and buff.caster == hero then
            table.insert(newVictimList, unit)
            break
          end
        end
      end
    end
    hero.Pup_victimList = newVictimList
    if 1 <= #newVictimList then
      if not hero.Pup_damageStat then
        hero.Pup_damageStat = {
          0,
          0,
          0
        }
      else
        hero.Pup_damageStat[1] = hero.Pup_damageStat[1] + hero.Pup_damageStat[2]
        hero.Pup_damageStat[2] = 0
        hero.Pup_damageStat[3] = hero.Pup_damageStat[3] + dt
        if 1 <= hero.Pup_damageStat[3] then
          if hero.Pup_damageStat[1] > 0 then
            for _, unit in ipairs(hero.Pup_victimList) do
              local binfo = ed.lookupDataTable("Buff", nil, Pup.Pup_soulhurtBuffID)
              local dotBuff = ed.BuffCreate(binfo, unit, hero)
              local durTime = dotBuff.info.Time
              local dotDamage = -(Pup.Pup_soulhurtRatio * hero.Pup_damageStat[1]) / durTime
              dotBuff:setAttribute("HPR", dotDamage)
              unit:addBuff(dotBuff, hero)
            end
            hero.Pup_damageStat[1] = 0
          end
          hero.Pup_damageStat[3] = 0
        end
      end
    elseif hero.Pup_damageStat then
      hero.Pup_damageStat = false
    end
  end
end

function Pup.skillatk2_takeEffectOn(basefunc, skill, target, source, shift)
  local caster = skill.caster
  local distance = math.pow(ed.edpDistanceSQ(caster.position, target.position), 0.5)
  local ratioMult = (distance - 340) / 360 + 0.6
  ratioMult = 0.6 <= ratioMult and ratioMult or 0.6
  ratioMult = ratioMult <= 1 and ratioMult or 1
  local rangeEffect = "eff_impact_Pup_atk2.cha"
  if ratioMult <= 0.7 then
    rangeEffect = "eff_impact_Pup_atk2b.cha"
  end
  local originInfo = skill.info
  local basicRatio = originInfo["Plus Ratio"]
  local basicNum = originInfo["Basic Num"]
  skill.info = ed.wraptable(originInfo, {
    ["Plus Ratio"] = basicRatio * ratioMult,
    ["Basic Num"] = basicNum * ratioMult,
    ["Impact Effect"] = rangeEffect
  })
  basefunc(skill, target, source, shift)
  skill.info = originInfo
end

function Pup.skillatk2_createBuff(basefunc, skill, target)
  local slowBuff = basefunc(skill, target)
  local caster = skill.caster
  local distance = math.pow(ed.edpDistanceSQ(caster.position, target.position), 0.5)
  local ratioMult = (distance - 300) / 360 + 0.5
  ratioMult = 0.5 <= ratioMult and ratioMult or 0.5
  ratioMult = ratioMult <= 1 and ratioMult or 1
  slowBuff.timer = slowBuff.timer * ratioMult
  return slowBuff
end

function Pup.hero_takeDamageAwake(basefunc, hero, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
  local heroHPLeft = hero.hp
  local lost, bCrit = basefunc(hero, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
  if lost and hero:isAlive() then
    local damageNum = heroHPLeft >= lost and lost or heroHPLeft
    if not hero.Pup_outDamageStat then
      hero.Pup_outDamageStat = 0
    end
    hero.Pup_outDamageStat = hero.Pup_outDamageStat + damageNum
    if hero.Pup_outDamageStat >= hero.attribs.HP * Pup.Pup_outDamageHPRatio and hero.Pup_outDamageBuffTimes < Pup.Pup_outDamageTimesLimit then
      local binfo = ed.lookupDataTable("Buff", nil, Pup.Pup_awakeBuffID)
      local unconBuff = ed.BuffCreate(binfo, hero, hero)
      hero:addBuff(unconBuff, hero)
      hero.Pup_outDamageBuffTimes = hero.Pup_outDamageBuffTimes + 1
      hero.Pup_outDamageStat = hero.Pup_outDamageStat - hero.attribs.HP * Pup.Pup_outDamageHPRatio
      local componentIndex = hero.Pup_outDamageBuffTimes
      if hero.actor and componentIndex <= #hero.Pup_outDamageList then
        for i, comp in ipairs(hero.Pup_outDamageList[hero.Pup_outDamageBuffTimes][3]) do
          local newComponent = hero.Pup_outDamageList[hero.Pup_outDamageBuffTimes][3][i] .. "_s_dmg"
          hero.actor.puppet:setComponent(hero.Pup_outDamageList[hero.Pup_outDamageBuffTimes][3][i], newComponent)
        end
        if hero.puppet_stack[#hero.puppet_stack] == "Pup2.cha" or hero.puppet_stack[#hero.puppet_stack] == "PupMad2.cha" then
          hero.actor:addEffectToComponent("eff_impact_Pup_awake.cha", hero.Pup_outDamageList[hero.Pup_outDamageBuffTimes][3][1], 0, {
            x = 0,
            y = 0,
            inherit_rotation = true,
            inherit_visible = true
          })
        end
        local actionName = hero.actor:getActionName(hero.action_name)
        hero.actor.puppet:setAction(actionName)
        hero.actor.puppet:setLoop(hero.action_loop)
        hero.actor.puppet:setActionElapsed(hero.action_elapsed)
        hero.Pup_outDamageList[componentIndex][1] = true
      end
    end
  end
  return lost, bCrit
end

function Pup.caster_actor_usePuppet(basefunc, actor)
  local caster = actor.model
  basefunc(actor)
  if caster.Pup_outDamageList and (caster.puppet_stack[#caster.puppet_stack] == "Pup2.cha" or caster.puppet_stack[#caster.puppet_stack] == "PupMad2.cha") then
    for i, item in ipairs(caster.Pup_outDamageList) do
      if item[1] == true and caster.actor then
        for j, comp in ipairs(item[3]) do
          local newComponent = item[3][j] .. "_s_dmg"
          caster.actor.puppet:setComponent(item[3][j], newComponent)
        end
      end
    end
  end
end

function Pup.skillatk4_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  if ed.run_with_scene then
    local effect_name = "eff_point_Pup_atk4b.cha"
    local scene_effect = ed.scene:playEffectOnScene(effect_name, caster.position, {
      0.9 * caster.direction,
      0.9
    }, nil, 0)
  end
end

function Pup.skillatk4_takeEffectAt(basefunc, skill, location, source)
  basefunc(skill, location, source)
  local caster = skill.caster
  local info = skill.info
  if ed.run_with_scene then
    local origin = {
      location[1] + caster.direction,
      location[2] - 10
    }
    local effect_name = "eff_point_Pup_atk4.cha"
    local scene_effect = ed.scene:playEffectOnScene(effect_name, origin, {
      0.9 * caster.direction,
      0.9
    }, nil, 0)
  end
end

function Pup.skillawake_update(basefunc, skill, dt_action, dt_cd)
  local caster = skill.caster
  basefunc(skill, dt_action, dt_cd)
  local nunUse = ed.rand()
  if not caster.Pup_outDamageListInit then
    caster.Pup_outDamageListInit = true
    caster.Pup_outDamageList = {
      {
        false,
        ed.rand(),
        {
          "RArm",
          "RArmQ",
          "RArmQ2"
        }
      },
      {
        false,
        ed.rand(),
        {
          "TorsoBottom_2Q",
          "LLeg_1"
        }
      },
      {
        false,
        ed.rand(),
        {
          "LArm_1",
          "LArm",
          "LForearm",
          "LArm_1Q"
        }
      },
      {
        false,
        ed.rand(),
        {"Head", "tou2"}
      },
      {
        false,
        ed.rand(),
        {"Head_1", "Head_6"}
      }
    }
    if caster.actor then
      caster.actor.usePuppet = override(caster.actor.usePuppet, Pup.caster_actor_usePuppet)
    end
  end
end

function Pup.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.Pup_unconADD = false
  hero.Pup_victimList = {}
  hero.Pup_damageStat = false
  hero.Pup_haveVictiim = false
  hero.Pup_outDamageStat = false
  hero.Pup_outDamageListInit = false
  hero.Pup_outDamageList = {}
  hero.Pup_outDamageBuffTimes = 0
  hero.Pup_isMad = false
  hero.Pup_madTime = 0
  hero.Pup_ultStartPos = nil
  hero.dyingTimer_Pup = nil
  hero.Pup_hpBarOverride = nil
  hero.Pup_fakeHP = nil
  if ed.protoAwake(hero.proto, Pup.Pup_unitID) then
    hero:enterActionStageFromOneStage(2, Pup.Pup_unitID)
  else
    hero:enterActionStageFromOneStage(1, Pup.Pup_unitID)
  end
end

function Pup.init_hero(hero)
  hero:setActionStageChangeByManual(true)
  local skillult = hero.skills.Pup_ult
  if skillult then
    skillult.update = override(skillult.update, Pup.skillult_update)
    skillult.start = override(skillult.start, Pup.skillult_start)
    skillult.finish = override(skillult.finish, Pup.skillult_finish)
    hero.setAction = override(hero.setAction, Pup.hero_setAction)
    hero.update = override(hero.update, Pup.hero_updateUlt)
    local skillulta = hero.skills.Pup_ulta
    if skillulta then
      skillulta.takeEffectAt = override(skillulta.takeEffectAt, Pup.skillulta_takeEffectAt)
    end
    local skillultb = hero.skills.Pup_ultb
    if skillultb then
      skillultb.onAttackFrame = override(skillultb.onAttackFrame, Pup.skillultb_onAttackFrame)
    end
    local skillultc = hero.skills.Pup_ultc
    if skillultc then
      skillultc.start = override(skillultc.start, Pup.skillultc_start)
      skillultc.onAttackFrame = override(skillultc.onAttackFrame, Pup.skillultc_onAttackFrame)
      skillultc.finish = override(skillultc.finish, Pup.skillultc_finish)
    end
    local skillultd = hero.skills.Pup_ultd
    if skillultd then
      skillultd.start = override(skillultd.start, Pup.skillultd_start)
      skillultd.finish = override(skillultd.finish, Pup.skillultd_finish)
      skillultd.onAttackFrame = override(skillultd.onAttackFrame, Pup.skillultd_onAttackFrame)
    end
  end
  local skillatk3 = hero.skills.Pup_atk3
  if skillatk3 then
    skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, Pup.skillatk3_takeEffectOn)
    hero.takeDamage = override(hero.takeDamage, Pup.hero_takeDamageAtk3)
    hero.update = override(hero.update, Pup.hero_updateAtk3)
  end
  local skillatk2 = hero.skills.Pup_atk2
  if skillatk2 then
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, Pup.skillatk2_takeEffectOn)
    skillatk2.createBuff = override(skillatk2.createBuff, Pup.skillatk2_createBuff)
  end
  local skillatk4 = hero.skills.Pup_atk4
  if skillatk4 then
    skillatk4.start = override(skillatk4.start, Pup.skillatk4_start)
    skillatk4.takeEffectAt = override(skillatk4.takeEffectAt, Pup.skillatk4_takeEffectAt)
  end
  local skillawake = hero.skills.Pup_awake
  if skillawake then
    hero.takeDamage = override(hero.takeDamage, Pup.hero_takeDamageAwake)
    skillawake.update = override(skillawake.update, Pup.skillawake_update)
  end
  hero.reset = override(hero.reset, Pup.hero_reset)
  if ed.protoAwake(hero.proto, Pup.Pup_unitID) then
    hero:enterActionStageFromOneStage(2, Pup.Pup_unitID)
  end
  return hero
end

return Pup.init_hero
