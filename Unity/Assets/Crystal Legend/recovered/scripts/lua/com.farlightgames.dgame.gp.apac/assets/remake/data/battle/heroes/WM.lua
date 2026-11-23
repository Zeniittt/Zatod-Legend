module("ed.battlehero", package.seeall)
local ed = ed
WM = {}
WM.ult_ARM_base = -1
WM.ult_MP_base = -0.5
WM.skilltag_times = 1
WM.skilltag_max = 4
WM.slash_self_ratio = 0.35
WM.dunt_target_ratio = 0.25
WM.stab_damage_ratio = 0.25
WM.shoot_all_ratio = 0.1
WM.slash_LFS = 1
WM.dunt_AD = 10
WM.stab_ARM = 3
WM.shoot_DODG = 1
WM.slash_awake_MPR = 0.05
WM.dunt_awake_HPR = 3
WM.stab_awake_ARM = 0.5
WM.shoot_awake_DODG = 0.2
WM.ult_position = {
  {150, 10},
  {75, 26},
  {25, -20},
  {43, -34},
  {-60, 4},
  {-15, -20},
  {-120, -14},
  {-150, 22}
}

function WM.selectbufftoCast(hero)
  local temp_taglist = {}
  local k = 1
  for i = 1, 4 do
    if hero.WM_tagbuff_list[i] then
      temp_taglist[k] = hero.WM_tagbuff_list[i]
      k = k + 1
    end
  end
  table.sort(temp_taglist, function(a, b)
    return a.MW_buff_order < b.MW_buff_order
  end)
  hero.onecombo_list = {
    temp_taglist[1].WM_bufftype,
    temp_taglist[2].WM_bufftype,
    temp_taglist[3].WM_bufftype
  }
  for i = 1, 3 do
    if temp_taglist[i] then
      temp_taglist[i].timer = 0
      temp_taglist[i].WM_tagused = true
      table.insert(hero.WM_skilltags_allcount, temp_taglist[i].WM_bufftype)
    end
  end
  for i, tbuff in ipairs(hero.WM_tagbuff_list) do
    if tbuff.WM_tagused then
      hero.WM_tagbuff_list[i] = nil
    end
  end
  hero.WM_tagbuff_amount = hero.WM_tagbuff_amount - 3
end

function WM.skilltag_addbuff(hero, buffID, bufftype)
  for i = 1, 4 do
    if not hero.WM_tagbuff_list[i] then
      buffID = buffID + 4 * (i - 1)
      break
    end
  end
  local bid = buffID
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = ed.BuffCreate(binfo, hero, hero)
  local skillawake = hero.skills.WM_awake
  if skillawake then
    if bufftype == "slash" then
      buff:setAttribute("MPR", WM.slash_awake_MPR * skillawake.level)
    elseif bufftype == "dunt" then
      buff:setAttribute("HPR", WM.dunt_awake_HPR * skillawake.level)
    elseif bufftype == "stab" then
      buff:setAttribute("ARM", WM.stab_awake_ARM * skillawake.level)
    elseif bufftype == "shoot" then
      buff:setAttribute("DODG", WM.shoot_awake_DODG * skillawake.level)
    end
  end
  buff.WM_bufftype = bufftype
  local buffresult = hero:addBuff(buff, hero)
  if buffresult then
    hero.WM_tagbuff_amount = hero.WM_tagbuff_amount + 1
    buffresult.MW_buff_order = hero.WM_tagbuff_markNo
    hero.WM_tagbuff_markNo = hero.WM_tagbuff_markNo + 1
    for i = 1, 4 do
      if not hero.WM_tagbuff_list[i] then
        hero.WM_tagbuff_list[i] = buffresult
        break
      end
    end
  end
end

function WM.update(basefunc, hero, dt)
  basefunc(hero, dt)
  if hero.WM_tagbuff_amount >= 3 and not hero.combo_start and not hero.current_skill then
    WM.selectbufftoCast(hero)
    hero.combo_stage = 1
    local skill_combo1 = hero.skills["WM_combo_" .. hero.onecombo_list[1] .. "1"]
    if skill_combo1 then
      skill_combo1.cd_remaining = 0
    end
    hero.combo_start = true
  end
end

function WM.reset(basefunc, hero)
  basefunc(hero)
  hero.WM_skilltags_list = {}
  hero.WM_skilltags_count = {}
  hero.onecombo_list = {}
  hero.WM_skilltags_count.slash = 0
  hero.WM_skilltags_count.dunt = 0
  hero.WM_skilltags_count.stab = 0
  hero.WM_skilltags_count.shoot = 0
  hero.WM_tagbuff_amount = 0
  hero.WM_tagbuff_list = {}
  hero.WM_tagbuff_markNo = 1
  hero.combo_stage = 0
  hero.comboend_selfbuff = 1
  hero.comboend_targetbuff = 1
  hero.comboend_damage = 1
  hero.combo_start = nil
  hero.WM_skilltags_allcount = {
    "slash",
    "dunt",
    "stab",
    "shoot",
    "slash",
    "dunt",
    "stab",
    "shoot"
  }
  hero.WM_skilltags_ult8 = {}
end

function WM.collectSkill(basefunc, self, unit, skill, idx)
  if self.name == "WM" and self.camp == unit.camp and not self.config.is_summoned and idx == 1 then
    local skillTags = skill.info["Skill Tags"]
    for i, v in pairs(skillTags) do
      if v == "slash" then
        self.WM_skilltags_count.slash = self.WM_skilltags_count.slash + 1
        if self.WM_skilltags_count.slash >= WM.skilltag_times and self.WM_tagbuff_amount < WM.skilltag_max then
          WM.skilltag_addbuff(self, 680, v)
          self.WM_skilltags_count.slash = 0
        end
      elseif v == "dunt" then
        self.WM_skilltags_count.dunt = self.WM_skilltags_count.dunt + 1
        if self.WM_skilltags_count.dunt >= WM.skilltag_times and self.WM_tagbuff_amount < WM.skilltag_max then
          WM.skilltag_addbuff(self, 681, v)
          self.WM_skilltags_count.dunt = 0
        end
      elseif v == "stab" then
        self.WM_skilltags_count.stab = self.WM_skilltags_count.stab + 1
        if self.WM_skilltags_count.stab >= WM.skilltag_times and self.WM_tagbuff_amount < WM.skilltag_max then
          WM.skilltag_addbuff(self, 682, v)
          self.WM_skilltags_count.stab = 0
        end
      elseif v == "shoot" then
        self.WM_skilltags_count.shoot = self.WM_skilltags_count.shoot + 1
        if self.WM_skilltags_count.shoot >= WM.skilltag_times and self.WM_tagbuff_amount < WM.skilltag_max then
          WM.skilltag_addbuff(self, 683, v)
          self.WM_skilltags_count.shoot = 0
        end
      end
    end
  end
end

function WM.getskilltag(skill)
  local tag
  if skill.info.name == "WM_combo_slash1" or skill.info.name == "WM_combo_slash2" then
    tag = "slash"
  elseif skill.info.name == "WM_combo_dunt1" or skill.info.name == "WM_combo_dunt2" then
    tag = "dunt"
  elseif skill.info.name == "WM_combo_stab1" or skill.info.name == "WM_combo_stab2" then
    tag = "stab"
  else
    tag = "shoot"
  end
  return tag
end

function WM.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  skill.WM_projectile_count = 1
end

function WM.skillult_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local attack_counter = skill.attack_counter
  local skillultslash = caster.skills.WM_ultslash
  local skillultdunt = caster.skills.WM_ultdunt
  local skillultstab = caster.skills.WM_ultstab
  local skillultshoot = caster.skills.WM_ultshoot
  if attack_counter <= 3 then
    local k = #caster.WM_skilltags_allcount
    for i = 1, 2 do
      local n = skill.attack_counter * 2 + i
      if caster.WM_skilltags_allcount[n] and ed.run_with_scene then
        local effect_name = "eff_point_WM_ult_" .. caster.WM_skilltags_allcount[k - n + 1] .. ".cha"
        if not effect_name then
          return
        end
        ed.scene:playEffectOnScene(effect_name, {
          caster.position[1] + WM.ult_position[n][1],
          caster.position[2] + WM.ult_position[n][2]
        }, nil, nil, -1)
      end
      caster.WM_skilltags_ult8[n] = caster.WM_skilltags_allcount[k - n + 1]
    end
    skill.attack_counter = skill.attack_counter + 1
  end
  if 3 < attack_counter and attack_counter <= 11 then
    local tag = caster.WM_skilltags_ult8[skill.WM_projectile_count]
    skill.info["Tile Art"] = "eff_tile_WM_ult_" .. tag .. ".cha"
    basefunc(skill)
    skill.WM_projectile_count = skill.WM_projectile_count + 1
  end
end

function WM.skillult_projectile_hit(basefunc, projectile, target)
  basefunc(projectile, target)
  local skill = projectile.skill
  local caster = skill.caster
  local tag = caster.WM_skilltags_ult8[skill.WM_projectile_count]
  if target and target:isAlive() then
    local skilllevel = skill.level
    if tag == "slash" then
      target:takeHeal(WM.ult_MP_base * skilllevel, "mp", caster)
    elseif tag == "dunt" then
      local bid = 5
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = target:addBuff(binfo, caster)
    elseif tag == "stab" then
      local bid = 696
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, target, caster)
      buff:setAttribute("ARM", WM.ult_ARM_base * skilllevel)
      target:addBuff(buff, caster)
    elseif tag == "shoot" then
      local bid = 697
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, target, caster)
      target:addBuff(buff, caster)
    end
  end
end

function WM.skillult_createProjectile(basefunc, skill)
  local caster = skill.caster
  local ulttarget = skill:selectTarget(nil)
  local ultposition
  if ulttarget then
    ultposition = {
      ulttarget.position[1],
      ulttarget.position[2]
    }
  end
  local projectile = basefunc(skill)
  projectile.hit = override(projectile.hit, WM.skillult_projectile_hit)
  projectile.position = {
    caster.position[1] + WM.ult_position[skill.WM_projectile_count][1],
    caster.position[2] + WM.ult_position[skill.WM_projectile_count][2]
  }
  projectile.height = 300
  local targetpos = ulttarget.position
  local v = 1400
  local targetxyV = ed.edpSub(targetpos, projectile.position)
  local targetzV = -projectile.height
  local u = (targetxyV[1] * targetxyV[1] + targetxyV[2] * targetxyV[2] + targetzV * targetzV) ^ (-0.5)
  local targetV = {
    u * targetxyV[1],
    u * targetxyV[2],
    u * targetzV
  }
  projectile.velocity[1] = targetV[1] * v
  projectile.velocity[2] = targetV[2] * v
  projectile.zSpeed = targetV[3] * v
  return projectile
end

function WM.skillcombo_common_interrupt(basefunc, skill)
  skill.WM_combo_interrupt = true
  basefunc(skill)
end

function WM.skillcombo_common_start(basefunc, skill, target)
  local caster = skill.caster
  if caster.combo_stage == 1 then
    caster.combo_target = target
  end
  basefunc(skill, target)
end

function WM.skillcombo_common_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  if not skill.WM_combo_interrupt then
    if caster.combo_stage == 1 then
      if caster.combo_target then
        caster.combo_stage = 2
        local skill_combo1 = caster.skills["WM_combo_" .. caster.onecombo_list[2] .. "1"]
        skill_combo1.cd_remaining = 0
        if skill.info["Skill Group ID"] == 1312 then
          caster.comboend_selfbuff = caster.comboend_selfbuff + WM.slash_self_ratio
        elseif skill.info["Skill Group ID"] == 1313 then
          caster.comboend_targetbuff = caster.comboend_targetbuff + WM.dunt_target_ratio
        elseif skill.info["Skill Group ID"] == 1314 then
          caster.comboend_damage = caster.comboend_damage + WM.stab_damage_ratio
        else
          caster.comboend_selfbuff = caster.comboend_selfbuff + WM.shoot_all_ratio
          caster.comboend_targetbuff = caster.comboend_targetbuff + WM.shoot_all_ratio
          caster.comboend_damage = caster.comboend_damage + WM.shoot_all_ratio
        end
      end
    elseif caster.combo_stage == 2 then
      if caster.combo_target then
        caster.combo_stage = 3
        local skill_combo2 = caster.skills["WM_combo_" .. caster.onecombo_list[3] .. "2"]
        skill_combo2.cd_remaining = 0
        if skill.info["Skill Group ID"] == 1312 then
          caster.comboend_selfbuff = caster.comboend_selfbuff + WM.slash_self_ratio
        elseif skill.info["Skill Group ID"] == 1313 then
          caster.comboend_targetbuff = caster.comboend_targetbuff + WM.dunt_target_ratio
        elseif skill.info["Skill Group ID"] == 1314 then
          caster.comboend_damage = caster.comboend_damage + WM.stab_damage_ratio
        else
          caster.comboend_selfbuff = caster.comboend_selfbuff + WM.shoot_all_ratio
          caster.comboend_targetbuff = caster.comboend_targetbuff + WM.shoot_all_ratio
          caster.comboend_damage = caster.comboend_damage + WM.shoot_all_ratio
        end
      end
    else
      caster.combo_start = nil
      caster.comboend_selfbuff = 1
      caster.comboend_targetbuff = 1
      caster.comboend_damage = 1
    end
  else
    skill.WM_combo_interrupt = nil
    caster.combo_start = nil
    caster.comboend_selfbuff = 1
    caster.comboend_targetbuff = 1
    caster.comboend_damage = 1
  end
end

function WM.skillcombo_slash_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  local caster = skill.caster
  local dir = 1
  if caster.combo_target then
    skill.target = caster.combo_target
  end
  local target = skill.target
  if caster.combo_stage == 3 then
    if attack_counter == 0 then
      local bid = 1002
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = caster:addBuff(binfo, caster)
      caster.origin_position = {
        caster.position[1],
        caster.position[2]
      }
      if target then
        if target.position[1] >= caster.position[1] then
          dir = 1
          caster.direction = 1
        else
          dir = -1
          caster.direction = -1
        end
        caster:setPosition({
          target.position[1] - dir * 75,
          target.position[2]
        })
      else
        skill:finish()
      end
      caster.combo_slash_final_target = skill.target
      skill.attack_counter = skill.attack_counter + 1
    elseif attack_counter == 1 and caster.combo_slash_final_target == skill.target then
      local skilllevel = caster.skills.WM_combo_slash1.level
      local bid = 673
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, caster, caster)
      local bookskill = caster.skills.WM_warschool
      local ratio = 1
      if bookskill then
        ratio = 1 + bookskill.info["Script Arg1"] / 100
      end
      buff:setAttribute("LFS", WM.slash_LFS * skilllevel * caster.comboend_selfbuff * ratio)
      local buffresult = caster:addBuff(buff, caster)
      basefunc(skill)
      if buffresult then
        buffresult.timer = 0
      end
    elseif attack_counter == 2 then
      caster:setPosition({
        caster.origin_position[1],
        caster.origin_position[2]
      })
      for i, tbuff in ipairs(caster.buff_list) do
        if tbuff.info.ID == 1002 then
          tbuff.timer = 0.1
        end
      end
    end
  else
    if attack_counter == 0 then
      if ed.run_with_scene then
        local effect_name = "eff_point_WM_slash1.cha"
        if not effect_name then
          return
        end
        ed.scene:playEffectOnScene(effect_name, skill.target.position, nil, nil, 1)
      end
      skill.attack_counter = skill.attack_counter + 1
    end
    if attack_counter == 1 then
      local skilllevel = caster.skills.WM_combo_slash1.level
      local bid = 673
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, caster, caster)
      buff:setAttribute("LFS", WM.slash_LFS * skilllevel)
      local buffresult = caster:addBuff(buff, caster)
      basefunc(skill)
      if buffresult then
        buffresult.timer = 0
      end
    end
  end
end

function WM.skillcombo_dunt_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  local caster = skill.caster
  skill.target = caster.combo_target
  if caster.combo_stage == 3 then
    if attack_counter == 0 then
      if ed.run_with_scene then
        local effect_name = "eff_point_WM_dunt2_1.cha"
        if not effect_name then
          return
        end
        ed.scene:playEffectOnScene(effect_name, caster.position, {0.7, 0.5}, nil, 1)
      end
      skill.attack_counter = skill.attack_counter + 1
    end
    if attack_counter == 1 then
      if ed.run_with_scene then
        local effect_name = "eff_point_WM_dunt2_2.cha"
        if not effect_name then
          return
        end
        ed.scene:playEffectOnScene(effect_name, skill.target.position, {0.7, 0.7}, nil, 1)
      end
      local skilllevel = caster.skills.WM_combo_slash1.level
      local bid = 674
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, caster, caster)
      local bookskill = caster.skills.WM_warschool
      local ratio = 1
      if bookskill then
        ratio = 1 + bookskill.info["Script Arg1"] / 100
      end
      buff:setAttribute("AD", WM.dunt_AD * skilllevel * caster.comboend_selfbuff * ratio)
      local buffresult = caster:addBuff(buff, caster)
      basefunc(skill)
    end
  else
    if attack_counter == 0 and ed.run_with_scene then
      local effect_name = "eff_point_WM_dunt1.cha"
      if not effect_name then
        return
      end
      ed.scene:playEffectOnScene(effect_name, skill.target.position, {0.7, 0.7}, nil, 1)
    end
    skill.attack_counter = skill.attack_counter + 1
    if attack_counter == 1 then
      basefunc(skill)
    end
  end
end

function WM.skillcombo_stab_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  if caster.combo_stage == 3 then
    local skilllevel = caster.skills.WM_combo_slash1.level
    local bid = 676
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, caster, caster)
    local bookskill = caster.skills.WM_warschool
    local ratio = 1
    if bookskill then
      ratio = 1 + bookskill.info["Script Arg1"] / 100
    end
    buff:setAttribute("ARM", WM.stab_ARM * skilllevel * caster.comboend_selfbuff * ratio)
    local buffresult = caster:addBuff(buff, caster)
  end
  skill.target = caster.combo_target
  basefunc(skill)
end

function WM.skillcombo_shoot_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  if caster.combo_stage == 3 then
    local skilllevel = caster.skills.WM_combo_slash1.level
    local bid = 678
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, caster, caster)
    local bookskill = caster.skills.WM_warschool
    local ratio = 1
    if bookskill then
      ratio = 1 + bookskill.info["Script Arg1"] / 100
    end
    buff:setAttribute("DODG", WM.shoot_DODG * skilllevel * caster.comboend_selfbuff * ratio)
    local buffresult = caster:addBuff(buff, caster)
  end
  skill.target = caster.combo_target
  basefunc(skill)
end

function WM.skillcombo_common_projectile_hit(basefunc, projectile, target)
  local skill = projectile.skill
  if target == skill.target then
    basefunc(projectile, target)
    projectile:terminate()
  end
end

function WM.skillcombo_common_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  projectile.hit = override(projectile.hit, WM.skillcombo_common_projectile_hit)
  if skill.info["Skill Group ID"] == 1319 then
    local caster = skill.caster
    local targetpos = caster.combo_target.position
    local v = 1000
    local targetxyV = ed.edpSub(targetpos, projectile.position)
    local targetzV = -projectile.height
    local u = (targetxyV[1] * targetxyV[1] + targetxyV[2] * targetxyV[2] + targetzV * targetzV) ^ (-0.5)
    local targetV = {
      u * targetxyV[1],
      u * targetxyV[2],
      u * targetzV
    }
    projectile.velocity[1] = targetV[1] * v
    projectile.velocity[2] = targetV[2] * v
    projectile.zSpeed = targetV[3] * v
  end
  return projectile
end

function WM.skillult_createProjectile(basefunc, skill)
  local caster = skill.caster
  local ulttarget = skill:selectTarget(nil)
  local ultposition
  if ulttarget then
    ultposition = {
      ulttarget.position[1],
      ulttarget.position[2]
    }
  else
    return
  end
  local projectile = basefunc(skill)
  projectile.hit = override(projectile.hit, WM.skillult_projectile_hit)
  projectile.position = {
    caster.position[1] + WM.ult_position[skill.WM_projectile_count][1],
    caster.position[2] + WM.ult_position[skill.WM_projectile_count][2]
  }
  projectile.height = 300
  local targetpos = ulttarget.position
  local v = 1200
  local targetxyV = ed.edpSub(targetpos, projectile.position)
  local targetzV = -projectile.height
  local u = (targetxyV[1] * targetxyV[1] + targetxyV[2] * targetxyV[2] + targetzV * targetzV) ^ (-0.5)
  local targetV = {
    u * targetxyV[1],
    u * targetxyV[2],
    u * targetzV
  }
  projectile.velocity[1] = targetV[1] * v
  projectile.velocity[2] = targetV[2] * v
  projectile.zSpeed = targetV[3] * v
  return projectile
end

function WM.skillcombo_commonfinal_getDamage(basefunc, skill, target, power, damage_type, field, source, crit_mod)
  local power2 = power
  local caster = skill.caster
  local comboend_damage = caster.comboend_damage
  if 0 < comboend_damage then
    power2 = power * comboend_damage
  end
  local bookskill = caster.skills.WM_warschool
  if bookskill then
    local ratio = 1 + bookskill.info["Script Arg1"] / 100
    power2 = power2 * ratio
  end
  return basefunc(skill, target, power2, damage_type, field, source, crit_mod)
end

function WM.skillcombo_commonfinal_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local comboend_selfbuff = caster.comboend_selfbuff
  local comboend_targetbuff = caster.comboend_targetbuff
  local bookskill = caster.skills.WM_warschool
  local ratio = 1
  if bookskill then
    ratio = 1 + bookskill.info["Script Arg1"] / 100
  end
  if 0 < comboend_targetbuff then
    if WM.getskilltag(skill) == "slash" then
    end
    if WM.getskilltag(skill) == "dunt" then
      buff.timer = buff.timer * comboend_targetbuff * ratio
    end
    if WM.getskilltag(skill) == "stab" then
      buff:setAttribute("ARM", buff.info.ARM * comboend_targetbuff * ratio)
    end
    if WM.getskilltag(skill) == "shoot" then
      buff:setAttribute("HAST", buff.info.HAST * comboend_targetbuff * ratio)
      buff:setAttribute("MSPD", buff.info.MSPD * comboend_targetbuff * ratio)
    end
  end
  return buff
end

function WM.skillcombo_slash_takeEffectOn(basefunc, skill, target, source, shift)
  local result = basefunc(skill, target, source, shift)
  local skillcombo_slashMP = skill.caster.skills.WM_combo_slashMP
  if result and target then
    skillcombo_slashMP:takeEffectOn(target)
  end
end

function WM.skillcombo_slashMP_getDamage(basefunc, skill, target, power, damage_type, field, source, crit_mod)
  local power2 = power
  local caster = skill.caster
  local comboend_targetbuff = caster.comboend_targetbuff
  if 0 < comboend_targetbuff then
    power2 = power * comboend_targetbuff
  end
  local bookskill = caster.skills.WM_warschool
  if bookskill then
    local ratio = 1 + bookskill.info["Script Arg1"] / 100
    power2 = power2 * ratio
  end
  return basefunc(skill, target, power2, damage_type, field, source, crit_mod)
end

function WM.skillatk_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local count = 0
  local caster = skill.caster
  for unit in ed.engine:foreachAliveUnit(caster.camp) do
    if unit.name ~= "WM" then
      count = count + 1
    end
  end
  if count == 0 and caster.WM_tagbuff_amount < WM.skilltag_max then
    local tagnum = math.floor(ed.rand() * 4) + 1
    if tagnum == 1 then
      WM.skilltag_addbuff(caster, 680, "slash")
    elseif tagnum == 2 then
      WM.skilltag_addbuff(caster, 681, "dunt")
    elseif tagnum == 3 then
      WM.skilltag_addbuff(caster, 682, "stab")
    elseif tagnum == 4 then
      WM.skilltag_addbuff(caster, 683, "shoot")
    end
  end
end

function WM.init_hero(hero)
  local skillult = hero.skills.WM_ult
  local skillatk = hero.skills.WM_atk
  local skillcombo_slash1 = hero.skills.WM_combo_slash1
  local skillcombo_dunt1 = hero.skills.WM_combo_dunt1
  local skillcombo_stab1 = hero.skills.WM_combo_stab1
  local skillcombo_shoot1 = hero.skills.WM_combo_shoot1
  local skillcombo_slash2 = hero.skills.WM_combo_slash2
  local skillcombo_dunt2 = hero.skills.WM_combo_dunt2
  local skillcombo_stab2 = hero.skills.WM_combo_stab2
  local skillcombo_shoot2 = hero.skills.WM_combo_shoot2
  if skillult then
    skillult.onAttackFrame = override(skillult.onAttackFrame, WM.skillult_onAttackFrame)
    skillult.start = override(skillult.start, WM.skillult_start)
    skillult.createProjectile = override(skillult.createProjectile, WM.skillult_createProjectile)
  end
  if skillatk then
    skillatk.onAttackFrame = override(skillatk.onAttackFrame, WM.skillatk_onAttackFrame)
  end
  if skillcombo_slash1 then
    skillcombo_slash1.onAttackFrame = override(skillcombo_slash1.onAttackFrame, WM.skillcombo_slash_onAttackFrame)
    skillcombo_slash1.finish = override(skillcombo_slash1.finish, WM.skillcombo_common_finish)
    skillcombo_slash1.start = override(skillcombo_slash1.start, WM.skillcombo_common_start)
    skillcombo_slash1.interrupt = override(skillcombo_slash1.interrupt, WM.skillcombo_common_interrupt)
  end
  if skillcombo_dunt1 then
    skillcombo_dunt1.onAttackFrame = override(skillcombo_dunt1.onAttackFrame, WM.skillcombo_dunt_onAttackFrame)
    skillcombo_dunt1.finish = override(skillcombo_dunt1.finish, WM.skillcombo_common_finish)
    skillcombo_dunt1.start = override(skillcombo_dunt1.start, WM.skillcombo_common_start)
    skillcombo_dunt1.interrupt = override(skillcombo_dunt1.interrupt, WM.skillcombo_common_interrupt)
  end
  if skillcombo_stab1 then
    skillcombo_stab1.onAttackFrame = override(skillcombo_stab1.onAttackFrame, WM.skillcombo_stab_onAttackFrame)
    skillcombo_stab1.finish = override(skillcombo_stab1.finish, WM.skillcombo_common_finish)
    skillcombo_stab1.createProjectile = override(skillcombo_stab1.createProjectile, WM.skillcombo_common_createProjectile)
    skillcombo_stab1.start = override(skillcombo_stab1.start, WM.skillcombo_common_start)
    skillcombo_stab1.interrupt = override(skillcombo_stab1.interrupt, WM.skillcombo_common_interrupt)
  end
  if skillcombo_shoot1 then
    skillcombo_shoot1.onAttackFrame = override(skillcombo_shoot1.onAttackFrame, WM.skillcombo_shoot_onAttackFrame)
    skillcombo_shoot1.finish = override(skillcombo_shoot1.finish, WM.skillcombo_common_finish)
    skillcombo_shoot1.createProjectile = override(skillcombo_shoot1.createProjectile, WM.skillcombo_common_createProjectile)
    skillcombo_shoot1.start = override(skillcombo_shoot1.start, WM.skillcombo_common_start)
    skillcombo_shoot1.interrupt = override(skillcombo_shoot1.interrupt, WM.skillcombo_common_interrupt)
  end
  if skillcombo_slash2 then
    skillcombo_slash2.onAttackFrame = override(skillcombo_slash2.onAttackFrame, WM.skillcombo_slash_onAttackFrame)
    skillcombo_slash2.finish = override(skillcombo_slash2.finish, WM.skillcombo_common_finish)
    skillcombo_slash2.getDamage = override(skillcombo_slash2.getDamage, WM.skillcombo_commonfinal_getDamage)
    skillcombo_slash2.createBuff = override(skillcombo_slash2.createBuff, WM.skillcombo_commonfinal_createBuff)
    skillcombo_slash2.takeEffectOn = override(skillcombo_slash2.takeEffectOn, WM.skillcombo_slash_takeEffectOn)
  end
  if skillcombo_dunt2 then
    skillcombo_dunt2.onAttackFrame = override(skillcombo_dunt2.onAttackFrame, WM.skillcombo_dunt_onAttackFrame)
    skillcombo_dunt2.finish = override(skillcombo_dunt2.finish, WM.skillcombo_common_finish)
    skillcombo_dunt2.getDamage = override(skillcombo_dunt2.getDamage, WM.skillcombo_commonfinal_getDamage)
    skillcombo_dunt2.createBuff = override(skillcombo_dunt2.createBuff, WM.skillcombo_commonfinal_createBuff)
  end
  if skillcombo_stab2 then
    skillcombo_stab2.onAttackFrame = override(skillcombo_stab2.onAttackFrame, WM.skillcombo_stab_onAttackFrame)
    skillcombo_stab2.finish = override(skillcombo_stab2.finish, WM.skillcombo_common_finish)
    skillcombo_stab2.getDamage = override(skillcombo_stab2.getDamage, WM.skillcombo_commonfinal_getDamage)
    skillcombo_stab2.createBuff = override(skillcombo_stab2.createBuff, WM.skillcombo_commonfinal_createBuff)
    skillcombo_stab2.createProjectile = override(skillcombo_stab2.createProjectile, WM.skillcombo_common_createProjectile)
  end
  if skillcombo_shoot2 then
    skillcombo_shoot2.onAttackFrame = override(skillcombo_shoot2.onAttackFrame, WM.skillcombo_shoot_onAttackFrame)
    skillcombo_shoot2.finish = override(skillcombo_shoot2.finish, WM.skillcombo_common_finish)
    skillcombo_shoot2.getDamage = override(skillcombo_shoot2.getDamage, WM.skillcombo_commonfinal_getDamage)
    skillcombo_shoot2.createBuff = override(skillcombo_shoot2.createBuff, WM.skillcombo_commonfinal_createBuff)
    skillcombo_shoot2.createProjectile = override(skillcombo_shoot2.createProjectile, WM.skillcombo_common_createProjectile)
  end
  local skillcombo_slashMP = hero.skills.WM_combo_slashMP
  if skillcombo_slashMP then
    skillcombo_slashMP.getDamage = override(skillcombo_slashMP.getDamage, WM.skillcombo_slashMP_getDamage)
  end
  hero.collectSkill = override(hero.collectSkill, WM.collectSkill)
  hero.reset = override(hero.reset, WM.reset)
  hero.update = override(hero.update, WM.update)
  return hero
end

return WM.init_hero
