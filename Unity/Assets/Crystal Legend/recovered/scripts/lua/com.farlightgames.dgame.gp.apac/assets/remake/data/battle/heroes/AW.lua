module("ed.battlehero", package.seeall)
local ed = ed
AW = {}
AW.mirror_time = 12
AW.BlackFishID = 220
AW.WhiteFishID = 221
AW.ultInviBuffID = 11002505
AW.battleEndBuffID = 11002506
AW.AWMirrorBuffID = 11002507
AW.AWMirrorBuffID_w = 11002508
AW.AWultMirrorAppear = 11002509
AW.ultUncoBuffID = 11002510
AW.mirrorMP = 20
AW.fashion_id1 = 100251

function AW.skillatk_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local originfo = skill.info
  local attack_counter = skill.attack_counter
  local effect_name = "eff_tile_AW_atkw.cha"
  if AW.fashion_id1 and AW.fashion_id1 == caster.fashion_id then
    effect_name = "eff_tile_AW_fashion_1_atkw.cha"
  end
  if attack_counter == 0 then
    skill.info = ed.wraptable(originfo, {
      ["Tile Art"] = effect_name
    })
  end
  basefunc(skill)
  skill.info = originfo
end

function AW.skillatk2_createProjectile(basefunc, skill)
  local attack_counter = skill.attack_counter
  local projectile
  if 3 < attack_counter or skill.ownerSkillCast then
    projectile = basefunc(skill)
  end
  local hero = skill.caster
  local sonSkill = skill.sonSkill
  if sonSkill and not skill.ownerSkillCast then
    sonSkill:selectTarget()
    if sonSkill.target then
      sonSkill:takeEffectOn(sonSkill.target)
    end
    hero:setMP(hero.mp + sonSkill.info["Gain MP"])
  end
  return projectile
end

function AW.returnBuff_onRemoved(basefunc, buff)
  basefunc(buff)
  local hero = buff.owner
  if hero.AW_origPosition then
    hero.position = {
      hero.AW_origPosition[1],
      hero.AW_origPosition[2]
    }
    if hero.actor then
      hero.actor.position = {
        hero.AW_origPosition[1],
        hero.AW_origPosition[2]
      }
    end
    if hero.BSultinvulnerable then
      hero.BSultinvulnerable = nil
      for i, tbuff in ipairs(hero.buff_list) do
        if tbuff.info.ID == 11000205 then
          tbuff.lastposition = {
            hero.position[1],
            hero.position[2]
          }
        end
      end
    end
  end
  if hero.actor then
    for i, tbuff in ipairs(hero.buff_list) do
      local info = tbuff.info
      if info.Effect then
        tbuff.effect_id = hero.actor:addEffect(info.Effect, info["Effect Zorder"])
      end
    end
  end
  hero.global_cd = hero.ori_globalcd
end

function AW.mirror_die(basefunc, hero, killer)
  hero.config.is_summoned = true
  hero.config.is_monster = true
  if not hero.AW_partnerFish:isAlive() then
    hero.AW_origSummoner:setHpVisible(true)
    hero.AW_origSummoner:setAllBuffVisible(true)
    hero.AW_origSummoner:setShieldVisible(true)
    hero.AW_origSummoner:setFuryVisible(true)
    if hero.AW_origSummoner.AW_origPosition then
      hero.AW_origSummoner.position = {
        hero.AW_origSummoner.AW_origPosition[1],
        hero.AW_origSummoner.AW_origPosition[2]
      }
      if ed.run_with_scene then
        local effect_name = "eff_point_AW_ult_return.cha"
        if AW.fashion_id1 and AW.fashion_id1 == hero.fashion_id then
          effect_name = "eff_point_AW_fashion_1_ult_return.cha"
        end
        if effect_name then
          ed.scene:playEffectOnScene(effect_name, hero.AW_origSummoner.AW_origPosition, {
            hero.direction,
            1
          }, nil, 1)
        end
      end
      if hero.BSultinvulnerable then
        hero.BSultinvulnerable = nil
        for i, tbuff in ipairs(hero.buff_list) do
          if tbuff.info.ID == 11000205 then
            tbuff.lastposition = {
              hero.position[1],
              hero.position[2]
            }
          end
        end
      end
    end
    for i, tbuff in ipairs(hero.AW_origSummoner.buff_list) do
      if tbuff.info.ID == AW.ultInviBuffID then
        tbuff.timer = 1
        hero.AW_origSummoner.AW_invisiableTime = 1
        tbuff.onRemoved = override(tbuff.onRemoved, AW.returnBuff_onRemoved)
      end
    end
    local AW_hero = hero.AW_origSummoner
  end
  basefunc(hero, killer)
end

function AW.mirror_skillatk2_createProjectile(basefunc, skill)
  local ownerSkill = skill.ownerSkill
  local hero = skill.caster.AW_origSummoner
  skill:selectTarget()
  if skill.target then
    local p = basefunc(skill)
    p:enableTrack(skill.target)
    ed.engine:addProjectile(p)
    hero:setMP(hero.mp + AW.mirrorMP / 4)
    ownerSkill.ownerSkillCast = false
    ownerSkill.attack_counter = 0
  end
end

function AW.mirror_onAttackFrame(basefunc, skill)
  local ownerSkill = skill.ownerSkill
  local caster = skill.caster
  local hero = caster.AW_origSummoner
  skill:selectTarget()
  if skill.target then
    ownerSkill.target = ownerSkill:selectTarget()
    if skill == caster.skills.WhiteFish_atk4 and ownerSkill.target == caster and caster.AW_partnerFish and caster.AW_partnerFish:isAlive() then
      ownerSkill.target = caster.AW_partnerFish
    end
    ownerSkill.ownerSkillCast = true
    local originfo = ownerSkill.info
    if skill.info["Skill Name"] == "WhiteFish_atk2" then
      ownerSkill.info = ed.wraptable(originfo, {
        ["Gain MP"] = AW.mirrorMP / 7
      })
    else
      ownerSkill.info = ed.wraptable(originfo, {
        ["Gain MP"] = AW.mirrorMP
      })
    end
    ownerSkill.caster.DGultToAWultUnit = skill.caster
    ownerSkill:onAttackFrame()
    ownerSkill.caster.DGultToAWultUnit = nil
    ownerSkill.info = originfo
    ownerSkill.ownerSkillCast = false
    ownerSkill.attack_counter = 0
  end
end

function AW.mirror_atk_takeEffectOn(basefunc, skill, target, source, shift)
  if target and skill.ownerSkill then
    skill.ownerSkill.caster.DGultToAWultUnit = skill.caster
    skill.ownerSkill:takeEffectOn(target, source, shift)
    skill.ownerSkill.caster.DGultToAWultUnit = nil
  end
  if skill.caster.AW_origSummoner and skill.info["Skill Name"] ~= "BlackFish_atk2" then
    skill.caster.AW_origSummoner:setMP(skill.caster.AW_origSummoner.mp + AW.mirrorMP)
  end
end

function AW.Mirror_update(basefunc, unit, dt)
  unit.mDuration_Fish = unit.mDuration_Fish - dt
  local AW_orig = unit.AW_origSummoner
  if unit:isAlive() and (unit.mDuration_Fish <= 0 or not unit.AW_origSummoner:isAlive()) then
    unit:die()
  else
    basefunc(unit, dt)
  end
end

function AW.battleEnd_onRemoved(basefunc, buff)
  basefunc(buff)
  local hero = buff.owner
  hero.config.is_summoned = true
  hero.config.is_monster = true
  if hero:isAlive() then
    if do_battle_log then
      btlog("%s died.", hero:display())
    end
    hero.state = ed.emUnitState_Dying
    if hero.current_skill then
      hero.current_skill:interrupt()
    end
    if hero.manually_casting then
      hero.manually_casting = false
      ed.engine:unfreeze()
    end
    hero.can_cast_manual = false
    hero.walk_v = {0, 0}
    hero.hp = 0
    hero.mp = 0
    if not hero.isDeathWithEffect then
      hero:setAction("Death", false, true)
    else
      hero.action_name = nil
      hero.action_loop = false
      hero.action_duration = 0
      hero.action_elapsed = 0
      local origin = {
        hero.position[1],
        hero.position[2]
      }
      if ed.run_with_scene then
        local effect_name = "eff_point_mirror_die.cha"
        if effect_name then
          ed.scene:playEffectOnScene(effect_name, origin, {
            hero.direction * 0.85,
            0.85
          }, nil, 1)
        end
      end
    end
    ed.engine:onUnitDie(hero, nil)
    if hero.actor then
      hero.actor:onUnitDeath()
    end
    if not hero.AW_partnerFish:isAlive() then
      hero.AW_partnerFish.config.is_summoned = true
      hero.AW_partnerFish.config.is_monster = true
      if hero.AW_origSummoner.AW_origPosition then
        hero.AW_origSummoner.position = {
          hero.AW_origSummoner.AW_origPosition[1],
          hero.AW_origSummoner.AW_origPosition[2]
        }
        if hero.AW_origSummoner.actor then
          hero.AW_origSummoner.actor.position = {
            hero.AW_origSummoner.AW_origPosition[1],
            hero.AW_origSummoner.AW_origPosition[2]
          }
        end
        if hero.BSultinvulnerable then
          hero.BSultinvulnerable = nil
          for i, tbuff in ipairs(hero.buff_list) do
            if tbuff.info.ID == 11000205 then
              tbuff.lastposition = {
                hero.position[1],
                hero.position[2]
              }
            end
          end
        end
      end
    end
  end
end

function AW.skillult_canCastWithTarget(basefunc, skill, target)
  local result = basefunc(skill, target)
  local caster = skill.caster
  local haveInviBuff
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == AW.ultInviBuffID or tbuff.info.ID == AW.ultUncoBuffID then
      haveInviBuff = true
    end
  end
  if result and haveInviBuff then
    result = nil
  end
  return result
end

function AW.skillult_start(basefunc, skill, target)
  local bid = AW.ultUncoBuffID
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local caster = skill.caster
  caster:addBuff(binfo, caster)
  basefunc(skill, target)
end

function AW.skillult_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == AW.ultUncoBuffID then
      caster:removeBuff(tbuff)
    end
  end
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    tbuff:removeEffectAndShader()
  end
  if caster.AW_WhiteMirror and caster.AW_WhiteMirror:isAlive() and caster.AW_BlackMirror and caster.AW_BlackMirror:isAlive() then
    local bid = AW.ultInviBuffID
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local caster = skill.caster
    caster:addBuff(binfo, caster)
    local globalcd = caster.global_cd
    caster.ori_globalcd = globalcd
    caster.global_cd = 999
    caster:setHpVisible(false)
    caster:setAllBuffVisible(false)
    caster:setShieldVisible(false)
    caster:setFuryVisible(false)
  end
end

function AW.skillult_onAttackFrame(basefunc, skill)
  skill.attack_counter = skill.attack_counter + 1
  local caster = skill.caster
  local skillevel = {
    skill.level,
    skill.level,
    skill.level,
    skill.level
  }
  local protob = {
    _tid = AW.BlackFishID,
    _level = skill.level or 1,
    _stars = caster.stars,
    _rank = caster.rank,
    _skill_levels = skillevel
  }
  local configb = {
    is_monster = false,
    estimate_rank = true,
    hp_mod = caster.config.hp_mod or 1,
    dps_mod = caster.config.dps_mod or 1
  }
  local BlackMirror = ed.UnitCreate(protob, caster.camp, configb)
  local BWattribs = skill.info["Script Arg2"] / 100
  local bid = AW.AWMirrorBuffID
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  AW.changeBuffInfo(binfo, BWattribs, BlackMirror)
  local buff = ed.BuffCreate(binfo, BlackMirror, caster)
  if AW.fashion_id1 and AW.fashion_id1 == caster.fashion_id then
    buff:setAttribute("Effect", "eff_buff_AW_fashion_1_ult.cha")
  end
  BlackMirror:addBuff(buff, caster)
  BlackMirror.mDuration_Fish = AW.mirror_time
  if skill.evo_rank and 1 <= skill.evo_rank then
    BlackMirror.mDuration_Fish = 15
  end
  if skill.evo_rank and skill.evo_rank >= 2 then
    BlackMirror.mDuration_Fish = 18
  end
  BlackMirror.update = override(BlackMirror.update, AW.Mirror_update)
  BlackMirror.die = override(BlackMirror.die, AW.mirror_die)
  BlackMirror:setDeathWithEffectOrNot(true)
  BlackMirror.direction = caster.direction
  BlackMirror.AW_origSummoner = caster
  caster.AW_BlackMirror = BlackMirror
  local bid2 = AW.battleEndBuffID
  local binfo2 = ed.lookupDataTable("Buff", nil, bid2)
  local buff3 = BlackMirror:addBuff(binfo2, caster)
  buff3.onRemoved = override(buff3.onRemoved, AW.battleEnd_onRemoved)
  local protow = {
    _tid = AW.WhiteFishID,
    _level = skill.level or 1,
    _stars = caster.stars,
    _rank = caster.rank,
    _skill_levels = skillevel
  }
  local configw = {
    is_monster = false,
    estimate_rank = true,
    hp_mod = caster.config.hp_mod or 1,
    dps_mod = caster.config.dps_mod or 1
  }
  local WhiteMirror = ed.UnitCreate(protow, caster.camp, configw)
  local bidw = AW.AWMirrorBuffID_w
  local binfow = ed.lookupDataTable("Buff", nil, bidw)
  AW.changeBuffInfo(binfow, BWattribs, WhiteMirror)
  local buffw = ed.BuffCreate(binfo, WhiteMirror, caster)
  if AW.fashion_id1 and AW.fashion_id1 == caster.fashion_id then
    buff:setAttribute("Effect", "eff_buff_AW_fashion_1_ultw.cha")
  end
  WhiteMirror:addBuff(buffw, caster)
  WhiteMirror.mDuration_Fish = AW.mirror_time
  if skill.evo_rank and 1 <= skill.evo_rank then
    WhiteMirror.mDuration_Fish = 15
  end
  if skill.evo_rank and skill.evo_rank >= 2 then
    WhiteMirror.mDuration_Fish = 18
  end
  WhiteMirror.update = override(WhiteMirror.update, AW.Mirror_update)
  WhiteMirror.die = override(WhiteMirror.die, AW.mirror_die)
  WhiteMirror:setDeathWithEffectOrNot(true)
  WhiteMirror.direction = caster.direction
  WhiteMirror.AW_origSummoner = caster
  caster.AW_WhiteMirror = WhiteMirror
  local buff4 = WhiteMirror:addBuff(binfo2, caster)
  buff4.onRemoved = override(buff4.onRemoved, AW.battleEnd_onRemoved)
  WhiteMirror.AW_partnerFish = BlackMirror
  BlackMirror.AW_partnerFish = WhiteMirror
  local skillatk = caster.skills.AW_atk
  local skillatk_b = BlackMirror.skills.BlackFish_atk
  local skillatk_w = WhiteMirror.skills.WhiteFish_atk
  if skillatk then
    skillatk_b.ownerSkill = skillatk
    skillatk_w.ownerSkill = skillatk
    skillatk_b.takeEffectOn = override(skillatk_b.takeEffectOn, AW.mirror_atk_takeEffectOn)
    skillatk_w.takeEffectOn = override(skillatk_w.takeEffectOn, AW.mirror_atk_takeEffectOn)
    if AW.fashion_id1 and AW.fashion_id1 == caster.fashion_id then
      skillatk_b.info = ed.wraptable(skillatk_b.info, {
        ["Tile Art"] = "eff_tile_AW_fashion_1_atk.cha"
      })
      skillatk_w.info = ed.wraptable(skillatk_w.info, {
        ["Tile Art"] = "eff_tile_AW_fashion_1_atkw.cha"
      })
    end
  else
    skillatk_b = 999
    skillatk_w = 999
  end
  local skillatk2 = caster.skills.AW_atk2
  local skillatk2_b = BlackMirror.skills.BlackFish_atk2
  local skillatk2_w = WhiteMirror.skills.WhiteFish_atk2
  if skillatk2 then
    skillatk2_b.ownerSkill = skillatk2
    skillatk2_w.ownerSkill = skillatk2.sonSkill
    skillatk2_b.createProjectile = override(skillatk2_b.createProjectile, AW.mirror_skillatk2_createProjectile)
    skillatk2_b.takeEffectOn = override(skillatk2_b.takeEffectOn, AW.mirror_atk_takeEffectOn)
    skillatk2_w.onAttackFrame = override(skillatk2_w.onAttackFrame, AW.mirror_onAttackFrame)
    if skillatk2.evo_rank and 1 <= skillatk2.evo_rank then
      skillatk2_b.info = ed.wraptable(skillatk2_b.info, {
        ["Plus Ratio"] = skillatk2.evo_rank1["Script Arg1"]
      })
    end
    if skillatk2.evo_rank and skillatk2.evo_rank >= 2 then
      skillatk2_b.info = ed.wraptable(skillatk2_b.info, {
        ["Plus Ratio"] = skillatk2.evo_rank2["Script Arg1"]
      })
    end
    if skillatk2.evo_rank and skillatk2.evo_rank >= 3 then
      skillatk2_b.info = ed.wraptable(skillatk2_b.info, {
        ["Plus Ratio"] = skillatk2.evo_rank3["Script Arg1"]
      })
    end
    if AW.fashion_id1 and AW.fashion_id1 == caster.fashion_id then
      skillatk2_b.info = ed.wraptable(skillatk2_b.info, {
        ["Tile Art"] = "eff_tile_AW_fashion_1_atk2.cha"
      })
    end
  else
    skillatk2_b.cd_remaining = 999
    skillatk2_w.cd_remaining = 999
  end
  local skillatk3 = caster.skills.AW_atk3
  local skillatk3_b = BlackMirror.skills.BlackFish_atk3
  local skillatk3_w = WhiteMirror.skills.WhiteFish_atk3
  if skillatk3 then
    skillatk3_b.ownerSkill = skillatk3
    skillatk3_w.ownerSkill = skillatk3.sonSkill
    skillatk3_b.onAttackFrame = override(skillatk3_b.onAttackFrame, AW.mirror_onAttackFrame)
    skillatk3_w.onAttackFrame = override(skillatk3_w.onAttackFrame, AW.mirror_onAttackFrame)
    skillatk3_b.createBuff = override(skillatk3_b.createBuff, AW.skillatk3_createBuff)
    if skillatk3.evo_rank and 1 <= skillatk3.evo_rank then
      skillatk3_b.info = ed.wraptable(skillatk3_b.info, {
        ["Plus Ratio"] = skillatk3.evo_rank1["Script Arg1"]
      })
    end
    if skillatk3.evo_rank and skillatk3.evo_rank >= 2 then
      skillatk3_b.info = ed.wraptable(skillatk3_b.info, {
        ["Plus Ratio"] = skillatk3.evo_rank2["Script Arg1"]
      })
    end
    if skillatk3.evo_rank and skillatk3.evo_rank >= 3 then
      skillatk3_w.createBuff = override(skillatk3_w.createBuff, AW.skillatk3w_createBuff)
    end
  else
    skillatk3_b.cd_remaining = 999
    skillatk3_w.cd_remaining = 999
  end
  local skillatk4 = caster.skills.AW_atk4
  local skillatk4_b = BlackMirror.skills.BlackFish_atk4
  local skillatk4_w = WhiteMirror.skills.WhiteFish_atk4
  if skillatk4 then
    skillatk4_b.ownerSkill = skillatk4
    skillatk4_w.ownerSkill = skillatk4.sonSkill
    skillatk4_b.onAttackFrame = override(skillatk4_b.onAttackFrame, AW.mirror_onAttackFrame)
    skillatk4_w.onAttackFrame = override(skillatk4_w.onAttackFrame, AW.mirror_onAttackFrame)
    if skillatk4.evo_rank and 1 <= skillatk4.evo_rank then
      skillatk4_b.evo_rank = skillatk4.evo_rank
      skillatk4_b.createBuff = override(skillatk4_b.createBuff, AW.skillatk4_createBuff)
    end
    if skillatk4.evo_rank and skillatk4.evo_rank >= 2 then
      skillatk4_w.evo_rank = skillatk4.evo_rank
      skillatk4_w.createBuff = override(skillatk4_w.createBuff, AW.skillatk4_createBuff)
    end
  else
    skillatk4_b.cd_remaining = 999
    skillatk4_w.cd_remaining = 999
  end
  if AW.fashion_id1 and AW.fashion_id1 == caster.fashion_id then
    BlackMirror:pushPuppet("AW_fashion_1b.cha")
    WhiteMirror:pushPuppet("AW_fashion_1w.cha")
  end
  ed.engine:summonUnit(BlackMirror, {
    caster.position[1] + caster.direction * 100,
    caster.position[2]
  }, caster)
  ed.engine:summonUnit(WhiteMirror, {
    caster.position[1] - caster.direction * 80,
    caster.position[2]
  }, caster)
  local bidu = AW.AWultMirrorAppear
  local binfou = ed.lookupDataTable("Buff", nil, bidu)
  local buffu = BlackMirror:addBuff(binfou, caster)
  local buffu2 = WhiteMirror:addBuff(binfou, caster)
  BlackMirror:takeHeal(BlackMirror.attribs.HP, "hp")
  WhiteMirror:takeHeal(WhiteMirror.attribs.HP, "hp")
  BlackMirror.config.is_summoned = false
  WhiteMirror.config.is_summoned = false
  if skill.evo_rank and skill.evo_rank >= 3 then
    local bid_con = 11002511
    local binfo_con = ed.lookupDataTable("Buff", nil, bid_con)
    BlackMirror:addBuff(binfo_con, caster)
    WhiteMirror:addBuff(binfo_con, caster)
  end
  caster.AW_origPosition = {
    caster.position[1],
    caster.position[2]
  }
end

function AW.changeBuffInfo(buffInfo, enhance, target)
  local attrib_temp = {}
  local summoner = target.config.summoner
  for _, name in ipairs(ed.attrib_names) do
    local value = buffInfo[name] or 0
    local ele = buffInfo[name .. ".x"]
    if value ~= 0 or ele then
      attrib_temp[name] = true
    end
  end
  for name, _ in pairs(attrib_temp) do
    local x = buffInfo[name .. ".x"]
    if x then
      buffInfo[name .. ".a"] = enhance
      if name == "HP" then
        buffInfo[name .. ".a"] = buffInfo[name .. ".a"] / target.config.hp_mod
      end
    end
  end
end

function AW.skillatk4_takeEffectOn(basefunc, skill, target, source, shift)
  basefunc(skill, target, source, shift)
  local caster = skill.caster
  if caster.camp == target.camp then
    local list = target.buff_list
    local debuff_list = {}
    local my_camp = caster.camp
    for i = 1, #list do
      local buff = list[i]
      if buff and (not buff.caster or buff.caster.camp ~= my_camp) and buff.info.Dispel == "YES" then
        debuff_list[#debuff_list + 1] = buff
      end
    end
    for i = 1, #debuff_list do
      target:removeBuff(debuff_list[i])
    end
    if ed.run_with_scene then
      local effect_name = "eff_impact_AW_atk4w.cha"
      if AW.fashion_id1 and AW.fashion_id1 == caster.fashion_id then
        effect_name = "eff_impact_AW_fashion_1_atk4w.cha"
      end
      ed.scene:playEffectOnScene(effect_name, target.position, {
        skill.caster.direction,
        1
      }, nil, 1)
      local effect_name_back = "eff_impact_AW_atk4w_2.cha"
      if AW.fashion_id1 and AW.fashion_id1 == caster.fashion_id then
        effect_name_back = "eff_impact_AW_fashion_1_atk4w_2.cha"
      end
      ed.scene:playEffectOnScene(effect_name_back, target.position, {
        skill.caster.direction,
        1
      }, nil, -1)
    end
    return ed.BuffCreate(skill.info.buff_info, target, skill.caster)
  else
    local list = target.buff_list
    local debuff_list = {}
    local my_camp = caster.camp
    for i = 1, #list do
      local buff = list[i]
      if buff and (not buff.caster or buff.caster.camp ~= my_camp) and buff.info.Dispel == "YES" then
        debuff_list[#debuff_list + 1] = buff
      end
    end
    for i = 1, #debuff_list do
      target:removeBuff(debuff_list[i])
    end
  end
end

function AW.skill_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local sonSkill = skill.sonSkill
  if sonSkill and not skill.ownerSkillCast then
    sonSkill:selectTarget()
    sonSkill:onAttackFrame()
  end
end

function AW.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  if hero.AW_invisiableTime == 999 then
    hero.AW_invisiableTime = hero.AW_invisiableTime
  elseif hero.AW_invisiableTime <= 1 and hero.AW_invisiableTime > 0 then
    hero.AW_invisiableTime = hero.AW_invisiableTime and hero.AW_invisiableTime - dt or dt
  end
end

function AW.hero_reset(basefunc, hero)
  basefunc(hero)
  local skillatk2 = hero.skills.AW_atk2
  local skillatk3 = hero.skills.AW_atk3
  local skillatk4 = hero.skills.AW_atk4
  hero.AW_BlackMirror = nil
  hero.AW_WhiteMirror = nil
  hero.AW_invisiableTime = 999
end

function AW.skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  if AW.fashion_id1 and AW.fashion_id1 == caster.fashion_id then
    buff:setAttribute("Effect", "eff_buff_AW_fashion_1_atk3.cha")
  end
  return buff
end

function AW.skillatk3w_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  buff:setAttribute("MSPD", 18)
  buff:setAttribute("HAST", 18)
  if AW.fashion_id1 and AW.fashion_id1 == caster.fashion_id then
    buff:setAttribute("Effect", "eff_buff_AW_fashion_1_atk3w.cha")
  end
  return buff
end

function AW.skillatk4_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local buffInfo = buff.info
  local owner = buff.owner
  local caster = buff.caster
  local ad = buffInfo.AD
  local ap = buffInfo.AP
  local skillatk4 = caster.skills.AW_atk4
  local skillatk4w = caster.skills.AW_atk4_w
  buff:setAttribute("AD", ad * 1.25)
  buff:setAttribute("AP", ap * 1.25)
  if skill.evo_rank and skill.evo_rank >= 3 then
    buff.timer = 8
  end
  if AW.fashion_id1 and AW.fashion_id1 == caster.fashion_id and skill.info["Skill Name"] == skillatk4.info["Skill Name"] then
    buff:setAttribute("Effect", "eff_buff_AW_fashion_1_atk4.cha")
  end
  if AW.fashion_id1 and AW.fashion_id1 == caster.fashion_id and skill.info["Skill Name"] == skillatk4w.info["Skill Name"] then
    buff:setAttribute("Effect", "eff_buff_AW_fashion_1_atk4w.cha")
  end
  return buff
end

function AW.hero_true_init(hero)
  hero.update = override(hero.update, AW.hero_update)
  hero.reset = override(hero.reset, AW.hero_reset)
  local skillult = hero.skills.AW_ult
  if skillult then
    skillult.canCastWithTarget = override(skillult.canCastWithTarget, AW.skillult_canCastWithTarget)
    skillult.onAttackFrame = override(skillult.onAttackFrame, AW.skillult_onAttackFrame)
    skillult.finish = override(skillult.finish, AW.skillult_finish)
    skillult.start = override(skillult.start, AW.skillult_start)
  end
  local skillatk = hero.skills.AW_atk
  if skillatk then
    skillatk.onAttackFrame = override(skillatk.onAttackFrame, AW.skillatk_onAttackFrame)
    if AW.fashion_id1 and AW.fashion_id1 == hero.fashion_id then
      skillatk.info = ed.wraptable(skillatk.info, {
        ["Tile Art"] = "eff_tile_AW_fashion_1_atk.cha"
      })
    end
  end
  local skillatk2 = hero.skills.AW_atk2
  local skillatk2w = hero.skills.AW_atk2_w
  if skillatk2 then
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
    if AW.fashion_id1 and AW.fashion_id1 == hero.fashion_id then
      skillatk2.info = ed.wraptable(skillatk2.info, {
        ["Tile Art"] = "eff_tile_AW_fashion_1_atk2.cha",
        ["Impact Effect"] = "eff_impact_AW_fashion_1_atk2"
      })
    end
    skillatk2.createProjectile = override(skillatk2.createProjectile, AW.skillatk2_createProjectile)
    skillatk2.sonSkill = skillatk2w
  end
  local skillatk3 = hero.skills.AW_atk3
  local skillatk3w = hero.skills.AW_atk3_w
  if skillatk3 then
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
    skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, AW.skill_onAttackFrame)
    skillatk3.createBuff = override(skillatk3.createBuff, AW.skillatk3_createBuff)
    skillatk3.sonSkill = skillatk3w
    if skillatk3.evo_rank and skillatk3.evo_rank >= 3 then
      skillatk3w.createBuff = override(skillatk3w.createBuff, AW.skillatk3w_createBuff)
    end
  end
  local skillatk4 = hero.skills.AW_atk4
  local skillatk4w = hero.skills.AW_atk4_w
  if skillatk4 then
    skillatk4.onAttackFrame = override(skillatk4.onAttackFrame, AW.skill_onAttackFrame)
    skillatk4.takeEffectOn = override(skillatk4.takeEffectOn, AW.skillatk4_takeEffectOn)
    skillatk4w.takeEffectOn = override(skillatk4w.takeEffectOn, AW.skillatk4_takeEffectOn)
    skillatk4.sonSkill = skillatk4w
    if skillatk4.evo_rank and skillatk4.evo_rank >= 1 then
      skillatk4w.evo_rank = skillatk4.evo_rank
      skillatk4.createBuff = override(skillatk4.createBuff, AW.skillatk4_createBuff)
    end
    if skillatk4.evo_rank and skillatk4.evo_rank >= 2 then
      skillatk4w.evo_rank = skillatk4.evo_rank
      skillatk4w.createBuff = override(skillatk4w.createBuff, AW.skillatk4_createBuff)
    end
  end
  return hero
end

function AW.init_hero(hero)
  AW.hero_true_init(hero)
  return hero
end

return AW.init_hero
