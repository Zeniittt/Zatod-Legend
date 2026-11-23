module("ed.battlehero", package.seeall)
local ed = ed
DK = {}
DK.name = "DK"
DK.ultinvBuffID = 10006704
DK.hitBuffID = 10006705
DK.battleendlistener = 10006707
DK.evoBuffID = 10006708

function DK.skillult_canCastWithTarget(basefunc, skill, target)
  local hero = skill.caster
  if not basefunc(skill, target) then
    return false
  elseif hero.DK_Form == "Dragon1" then
    return false
  elseif hero.manually_casting then
    return false
  elseif hero.ultnotfinished then
    return false
  end
  return true
end

function DK.update(basefunc, unit, dt)
  local skillpasv = unit.passive_skill_list[1]
  if skillpasv then
    if unit.pasvcd then
      unit.pasvcd = unit.pasvcd - dt
    end
    if skillpasv.evo_rank and skillpasv.evo_rank >= 2 then
      unit.dt = unit.dt and unit.dt + dt or dt
      if unit.dt == 1 then
        local binfo = ed.lookupDataTable("Buff", nil, DK.evoBuffID)
        local buff = ed.BuffCreate(binfo, unit, unit)
        buff:setAttribute("HPR", skillpasv.evo_rank2["Script Arg1"] * (1 + unit.attribs.HEAL / 100) + skillpasv.evo_rank2["Script Arg2"] * unit.attribs.HP)
        local buffevo = unit:addBuff(buff, unit)
        unit["Ult evo Buff"] = buffevo
      end
    end
  end
  basefunc(unit, dt)
  if unit.DK_Form == "Dragon1" then
    local skillultb = unit.skills[DK.name .. "_ultb"]
    if skillultb and skillultb.cd_remaining <= 0 then
      unit.global_cd = 0
    end
  end
end

function DK.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local unit = skill.caster
  if not unit["Ult Inv Buff"] then
    local binfo = ed.lookupDataTable("Buff", nil, DK.ultinvBuffID)
    local buff = unit:addBuff(binfo, unit)
    unit["Ult Inv Buff"] = buff
  end
  if not unit["Ult hit Buff"] then
    local binfo1 = ed.lookupDataTable("Buff", nil, DK.hitBuffID)
    local buff1 = ed.BuffCreate(binfo1, unit, unit)
    buff1:setAttribute("HIT", skill.info["Script Arg4"])
    local buffhit = unit:addBuff(buff1, unit)
    unit["Ult hit Buff"] = buffhit
  end
  unit.ultnotfinished = true
end

function DK.skillult_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local attack_counter = skill.attack_counter
  if attack_counter == 0 then
    local targetposition = {
      caster.position[1],
      caster.position[2]
    }
    if caster.direction == 1 then
      targetposition[1] = math.max(caster.position[1] - 150, 50)
    elseif caster.direction == -1 then
      targetposition[1] = math.min(caster.position[1] + 150, 750)
    end
    local d = ed.edpSub(targetposition, caster.position)
    if d[1] == 0 and d[2] == 0 then
      caster.knockup_v = {0, 0}
    else
      local d2 = ed.edpSub(d, ed.edpMult(ed.edpNormalize(d), 30))
      caster.knockup_v = {
        d2[1] / 1.2,
        d2[2] / 1.2
      }
    end
    skill.attack_counter = skill.attack_counter + 1
  end
  if attack_counter == 1 then
    basefunc(skill)
    if ed.run_with_scene then
      ed.scene:startCameraShakeAnimationY(10, 0.3, 5)
    end
    if ed.run_with_scene and caster.name == "DK" then
      local panel = caster.heroPanel
      if panel then
        local pic = "UI/DOTA-HERO/"
        pic = pic .. "DKult.png"
        panel:setPortrait(pic)
      end
    end
  end
  if attack_counter == 2 then
    caster.knockup_v = {0, 0}
    skill.attack_counter = skill.attack_counter + 1
  end
end

function DK.skillult_finish(basefunc, skill)
  basefunc(skill)
  local unit = skill.caster
  local skillult = unit.skills[DK.name .. "_ult"]
  local skillultb = unit.skills[DK.name .. "_ultb"]
  local skillpasv = unit.passive_skill_list[1]
  local nextPeriodID = 2
  unit:enterActionStageFromOneStage(nextPeriodID, 67)
  unit.DK_Form = "Dragon1"
  unit.ultnotfinished = false
  local dragontime = skillult.info["Script Arg2"]
  if skillult.evo_rank and skillult.evo_rank >= 3 then
    dragontime = dragontime + skillult.evo_rank3["Script Arg1"]
  end
  if skillultb then
    skillultb.cd_remaining = dragontime
  end
  local buff_inv = unit["Ult Inv Buff"]
  if buff_inv then
    buff_inv.timer = -1
    unit["Ult Inv Buff"] = nil
  end
  if skillpasv and skillpasv.evo_rank and 2 <= skillpasv.evo_rank and unit["Ult evo Buff"] then
    unit["Ult evo Buff"]:setAttribute("HPR", 2 * (skillpasv.evo_rank2["Script Arg1"] * (1 + unit.attribs.HEAL / 100) + skillpasv.evo_rank2["Script Arg2"] * unit.attribs.HP))
    if skillpasv.evo_rank and skillpasv.evo_rank >= 3 then
      unit["Ult evo Buff"]:setAttribute("DOTRES", skillpasv.evo_rank3["Script Arg1"])
    end
    unit:resetBuffApply(unit["Ult evo Buff"])
  end
end

function DK.skillultb_start(basefunc, skill, target)
  basefunc(skill, target)
  local unit = skill.caster
  if not unit["Ultb Inv Buff"] then
    local binfo = ed.lookupDataTable("Buff", nil, DK.ultinvBuffID)
    local buff = unit:addBuff(binfo, unit)
    unit["Ultb Inv Buff"] = buff
  end
end

function DK.skillultb_interrupt(basefunc, skill)
  basefunc(skill)
  local unit = skill.caster
  if unit.DK_Form == "Dragon1" then
    local skillultb = unit.skills[DK.name .. "_ultb"]
    skillultb.cd_remaining = 0
    unit.global_cd = 0
  end
end

function DK.skillultb_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local unit = skill.caster
  local skillpasv = unit.passive_skill_list[1]
  unit:enterActionStageFromOneStage(1, 67)
  unit.DK_Form = "Human"
  local buff_inv = unit["Ultb Inv Buff"]
  if buff_inv then
    buff_inv.timer = -1
    unit["Ultb Inv Buff"] = nil
  end
  local buff_hit = unit["Ult hit Buff"]
  if buff_hit then
    buff_hit.timer = -1
    unit["Ult hit Buff"] = nil
  end
  if unit["Ult evo Buff"] then
    unit["Ult evo Buff"]:setAttribute("HPR", skillpasv.evo_rank2["Script Arg1"] * (1 + unit.attribs.HEAL / 100) + skillpasv.evo_rank2["Script Arg2"] * unit.attribs.HP)
    if skillpasv.evo_rank and skillpasv.evo_rank >= 3 then
      unit["Ult evo Buff"]:setAttribute("DOTRES", 0)
    end
    unit:resetBuffApply(unit["Ult evo Buff"])
  end
  if ed.run_with_scene then
    local panel = unit.heroPanel
    if panel and unit.name == "DK" then
      local pic = "UI/DOTA-HERO/"
      pic = pic .. "DK.png"
      panel:setPortrait(pic)
    end
  end
end

function DK.skillatk3b_takeEffectOn(basefunc, self, target, source, shift)
  local info = self.info
  local caster = self.caster
  local delta_position = math.abs(self.caster.position[1] - target.position[1])
  if delta_position then
    local limit_down = 150
    local limit_up = 240
    local range = self.info["Shape Arg1"] or 250
    local coef = (limit_up - limit_down) / range
    local rand = ed.rand() * 10 - 5
    info["Knock Back"] = math.max(10, limit_down + delta_position * coef + rand - delta_position)
  end
  basefunc(self, target, source, shift)
end

function DK.skillatk3b_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local attack_counter = skill.attack_counter
  if caster and attack_counter == 0 then
    basefunc(skill)
    if ed.run_with_scene then
      ed.scene:startCameraShakeAnimationY(20, 0.3, 5)
    end
  end
end

function DK.reset(basefunc, unit)
  basefunc(unit)
  if unit.DK_Form and unit.DK_Form ~= "Human" then
    unit:enterActionStageFromOneStage(1, 67)
    unit.DK_Form = "Human"
    if ed.run_with_scene then
      local panel = unit.heroPanel
      if panel and unit.name == "DK" then
        local pic = "UI/DOTA-HERO/"
        if ed.protoAwake(unit.proto, 67) then
          pic = pic .. "Switch"
        end
        pic = pic .. "DK.png"
        panel:setPortrait(pic)
      end
    end
  end
  unit.pasvcd = 0
  unit.dt = nil
  unit.ultnotfinished = false
end

function DK.hero_takeDamage(basefunc, self, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
  local amount = struct_table
  local lost = basefunc(self, amount, damage_type, field, source, coefficient, crit_mod, transferred)
  if lost and 0 < lost then
    local skillpasv = self.passive_skill_list[1]
    if skillpasv then
      local amount = struct_table
      if type(struct_table) == "table" then
        damage_type = struct_table.damage_type
        amount = struct_table.amount
      end
      if 0 < lost and damage_type == "AD" and 0 >= self.pasvcd then
        self.pasvcd = skillpasv["Script Arg5"]
        local hpheal = skillpasv["Script Arg2"] + skillpasv["Script Arg3"] * self.attribs.HP
        local mp_gain = skillpasv["Script Arg4"]
        self:takeHeal(mp_gain, "mp", self)
        self:takeHeal(hpheal, "hp", self)
      end
    end
  end
  return lost
end

function DK.init_hero(hero)
  hero:setActionStageChangeByManual(true)
  local skillult = hero.skills.DK_ult
  local skillultb = hero.skills.DK_ultb
  local skillatkb = hero.skills.DK_atkb
  local skillatk2 = hero.skills.DK_atk2
  local skillatk2b = hero.skills.DK_atk2b
  local skillatk3 = hero.skills.DK_atk3
  local skillatk3b = hero.skills.DK_atk3b
  local skillpasv = hero.passive_skill_list[1]
  hero.update = override(hero.update, DK.update)
  hero.reset = override(hero.reset, DK.reset)
  if skillult then
    if skillatkb then
      if skillult.evo_rank and 1 <= skillult.evo_rank then
        skillatkb.info = ed.wraptable(skillatkb.info, {
          ["Plus Ratio"] = skillult.evo_rank1["Script Arg1"]
        })
      end
      if skillult.evo_rank and skillult.evo_rank >= 2 then
        skillatkb.info = ed.wraptable(skillatkb.info, {
          ["Plus Ratio"] = skillult.evo_rank2["Script Arg1"]
        })
      end
    end
    skillult.canCastWithTarget = override(skillult.canCastWithTarget, DK.skillult_canCastWithTarget)
    skillult.start = override(skillult.start, DK.skillult_start)
    skillult.onAttackFrame = override(skillult.onAttackFrame, DK.skillult_onAttackFrame)
    skillult.finish = override(skillult.finish, DK.skillult_finish)
  end
  if skillultb then
    skillultb.start = override(skillultb.start, DK.skillultb_start)
    skillultb.interrupt = override(skillultb.interrupt, DK.skillultb_interrupt)
    skillultb.onAttackFrame = override(skillultb.onAttackFrame, DK.skillultb_onAttackFrame)
  end
  if skillatk2 and skillatk2b then
    if skillatk2.evo_rank and 1 <= skillatk2.evo_rank then
      skillatk2.info = ed.wraptable(skillatk2.info, {
        ["Plus Ratio"] = skillatk2.evo_rank1["Script Arg1"]
      })
    end
    if skillatk2.evo_rank and skillatk2.evo_rank >= 2 then
      skillatk2b.info = ed.wraptable(skillatk2b.info, {
        ["Plus Ratio"] = skillatk2.evo_rank2["Script Arg1"]
      })
    end
    if skillatk2.evo_rank and skillatk2.evo_rank >= 3 then
      skillatk2b.info = ed.wraptable(skillatk2b.info, {
        ["Plus Ratio"] = skillatk2.evo_rank3["Script Arg1"]
      })
    end
  end
  if skillatk3 and skillatk3b then
    if skillatk3.evo_rank and 1 <= skillatk3.evo_rank then
      skillatk3.info = ed.wraptable(skillatk3.info, {
        ["Plus Ratio"] = skillatk3.evo_rank1["Script Arg1"]
      })
    end
    if skillatk3.evo_rank and skillatk3.evo_rank >= 2 then
      skillatk3b.info = ed.wraptable(skillatk3b.info, {
        ["Plus Ratio"] = skillatk3.evo_rank2["Script Arg1"]
      })
    end
    if skillatk3.evo_rank and skillatk3.evo_rank >= 3 then
      skillatk3b.info = ed.wraptable(skillatk3b.info, {
        ["Shape Arg1"] = 250
      })
    end
    skillatk3b.takeEffectOn = override(skillatk3b.takeEffectOn, DK.skillatk3b_takeEffectOn)
    skillatk3b.onAttackFrame = override(skillatk3b.onAttackFrame, DK.skillatk3b_onAttackFrame)
  end
  if skillpasv then
    hero.takeDamage = override(hero.takeDamage, DK.hero_takeDamage)
    if skillpasv.evo_rank and 1 <= skillpasv.evo_rank then
      skillpasv["Basic Num"] = skillpasv["Basic Num"] + skillpasv.evo_rank1["Script Arg1"] + skillpasv.evo_rank1["Script Arg2"] * hero.attribs.STR
    end
    hero:rebuild()
  end
  return hero
end

return DK.init_hero
