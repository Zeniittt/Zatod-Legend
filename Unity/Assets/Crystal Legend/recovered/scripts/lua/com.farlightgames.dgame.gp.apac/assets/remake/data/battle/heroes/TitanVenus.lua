module("ed.battlehero", package.seeall)
local ed = ed
TitanVenus = {}
TitanVenus.atk3_buff = 4167
TitanVenus.atk3_buff_Arcana = 4437
TitanVenus.atk4_buff = 4168
TitanVenus.atk4_buff_Arcana = 4438
TitanVenus.atk_effect_1 = 4169
TitanVenus.atk_effect_2 = 4170
TitanVenus.atk_effect_3 = 4171

function TitanVenus.update(basefunc, hero, dt)
  basefunc(hero, dt)
  local skillatk3 = hero.skills.TitanVenus_atk3
  if skillatk3 then
    hero.TitanVenus_atk3_index = hero.TitanVenus_atk3_index + dt
    if hero.TitanVenus_atk3_index % 10 == 0 then
      local hp_least_Unit
      local least_hp = 9999999
      for unit in ed.engine:foreachAliveUnit(hero.camp) do
        if unit.info["Unit Type"] == "Hero" and unit ~= hero then
          local hp = unit.hp
          if least_hp > hp then
            hp_least_Unit = unit
            least_hp = hp
          end
        end
      end
      if hp_least_Unit then
        local bid = TitanVenus.atk3_buff
        if hero.TitanVenus_hasArcana and hero.TitanVenus_hasArcana > 1 then
          bid = TitanVenus.atk3_buff_Arcana
        end
        local binfo = ed.lookupDataTable("Buff", nil, bid)
        hero.TitanVenus_atk3_targethp_initial = hp_least_Unit.hp
        local buff = hp_least_Unit:addBuff(binfo, hero)
        if buff then
          buff.onRemoved = override(buff.onRemoved, TitanVenus.atk3_buffOnRemoved)
        end
      else
        local bid = TitanVenus.atk3_buff
        if hero.TitanVenus_hasArcana and hero.TitanVenus_hasArcana > 1 then
          bid = TitanVenus.atk3_buff_Arcana
        end
        local binfo = ed.lookupDataTable("Buff", nil, bid)
        hero.TitanVenus_atk3_targethp_initial = hero.hp
        local buff = hero:addBuff(binfo, hero)
        if buff then
          buff.onRemoved = override(buff.onRemoved, TitanVenus.atk3_buffOnRemoved)
        end
      end
    end
  end
  local skillatk4 = hero.skills.TitanVenus_atk4
  if skillatk4 then
    local atk4_multi = skillatk4.info["Script Arg2"] / 100
    if hero.hp <= 0.5 * (1 + atk4_multi) * hero.attribs.HP or hero.TitanVenus_hasArcana and hero.TitanVenus_hasArcana > 3 then
      if TitanVenus.if_atk4 == false then
        hero.atk4_buff = TitanVenus.AddBuff(hero, hero.TitanVenus_hasArcana and hero.TitanVenus_hasArcana > 3 and TitanVenus.atk4_buff_Arcana or TitanVenus.atk4_buff)
        if hero.atk4_buff then
          hero.atk4_buff.onRemoved = override(hero.atk4_buff.onRemoved, TitanVenus.skillult_buffOnRemoved)
        end
        TitanVenus.if_atk4 = true
      end
    elseif hero.atk4_buff then
      hero.atk4_buff.timer = 0
    end
  end
end

function TitanVenus.reset(basefunc, hero)
  basefunc(hero)
  hero.TitanVenus_atk3_index = 0
  hero.TitanVenus_atk4_index = 0
  TitanVenus.if_atk4 = false
  TitanVenus.atk_current_index = 1
end

function TitanVenus.skillult_buffOnRemoved(basefunc, buff)
  local caster = buff.caster
  if caster.atk4_buff then
    TitanVenus.if_atk4 = false
  end
  basefunc(buff)
end

function TitanVenus.skillatk_onAttackFrame(basefunc, skill)
  local target = skill.target
  if skill.current_phase_idx == 1 then
    if not target:isAlive() then
      skill:finish()
    end
    local originfo = skill.info
    skill.info = ed.wraptable(originfo, {
      ["Track Type"] = "projectile",
      ["Impact Effect"] = "eff_impact_TitanVenus_atk.cha",
      ["Tile Art"] = "eff_tile_TitanVenus_atk.cha",
      ["Tile XY Speed"] = 900,
      ["Aim Target"] = "YES"
    })
    basefunc(skill)
    skill.info = originfo
  elseif skill.current_phase_idx == 2 then
    if not target:isAlive() then
      skill:finish()
    end
    local originfo = skill.info
    skill.info = ed.wraptable(originfo, {
      ["Impact Effect"] = "eff_impact_TitanVenus_atk2.cha"
    })
    basefunc(skill)
    skill.info = originfo
  elseif skill.current_phase_idx == 3 then
    if not target:isAlive() then
      skill:finish()
    end
    local originfo = skill.info
    skill.info = ed.wraptable(originfo, {
      ["AOE Origin"] = "self",
      ["AOE Shape"] = "rectangle",
      ["Shape Arg1"] = 800,
      ["Shape Arg2"] = 200,
      ["Impact Effect"] = "eff_impact_TitanVenus_atk3.cha"
    })
    basefunc(skill)
    skill.info = originfo
  end
end

function TitanVenus.atk3_buffOnRemoved(basefunc, buff)
  local caster = buff.caster
  local owner = buff.owner
  local skillatk3 = caster.skills.TitanVenus_atk3
  if owner.hp >= caster.TitanVenus_atk3_targethp_initial then
    local original_hp = owner.hp - caster.TitanVenus_atk3_targethp_initial
    if caster then
      caster:takeHeal(original_hp + skillatk3.info["Script Arg2"], "hp", caster)
    end
  elseif caster then
    caster:takeHeal(skillatk3.info["Script Arg2"], "hp", caster)
  end
  basefunc(buff)
end

function TitanVenus.AddBuff(hero, bid)
  local bid = bid
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = hero:addBuff(binfo, hero)
  return buff
end

function TitanVenus.AtkAddEffect(caster, target, bid)
  local bid = bid
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  target:addBuff(binfo, caster)
end

function TitanVenus.skillatk_reset(basefunc, skill)
  local caster = skill.caster
  local skillatk2 = caster.skills.TitanVenus_atk2
  if skillatk2 then
    local skillatk2 = caster.skills.TitanVenus_atk2
    local final_ratio = skill.info["Plus Ratio"] * (1 + skillatk2.info["Script Arg2"] / 100)
    skill.info = ed.wraptable(skill.info, {
      ["Plus Ratio"] = final_ratio
    })
  end
end

function TitanVenus.skillatk_takeEffectOn(basefunc, skill, target, source, shift)
  local caster = skill.caster
  local is_hit = basefunc(skill, target, source, shift)
  local skillatk2 = caster.skills.TitanVenus_atk2
  if skillatk2 and is_hit then
    if TitanVenus.if_atk4 == true then
      TitanVenus.AtkAddEffect(caster, target, TitanVenus.atk_effect_1)
      TitanVenus.AtkAddEffect(caster, target, TitanVenus.atk_effect_2)
      TitanVenus.AtkAddEffect(caster, target, TitanVenus.atk_effect_3)
    elseif target.hp < target.attribs.HP * 0.2 then
      TitanVenus.AtkAddEffect(caster, target, TitanVenus.atk_effect_1)
    elseif target.mp > 800 then
      TitanVenus.AtkAddEffect(caster, target, TitanVenus.atk_effect_2)
    else
      TitanVenus.AtkAddEffect(caster, target, TitanVenus.atk_effect_3)
    end
  end
end

function TitanVenus.skillult_takeEffectOn(basefunc, skill, target, source, shift)
  basefunc(skill, target, source, shift)
  local caster = skill.caster
  local skillatk2 = caster.skills.TitanVenus_atk2
  if skillatk2 then
    if TitanVenus.if_atk4 == true then
      TitanVenus.AtkAddEffect(caster, target, TitanVenus.atk_effect_1)
      TitanVenus.AtkAddEffect(caster, target, TitanVenus.atk_effect_2)
      TitanVenus.AtkAddEffect(caster, target, TitanVenus.atk_effect_3)
    elseif target.hp < target.attribs.HP * 0.2 then
      TitanVenus.AtkAddEffect(caster, target, TitanVenus.atk_effect_1)
    elseif target.mp > 800 then
      TitanVenus.AtkAddEffect(caster, target, TitanVenus.atk_effect_2)
    else
      TitanVenus.AtkAddEffect(caster, target, TitanVenus.atk_effect_3)
    end
  end
  if caster.TitanVenus_hasArcana and caster.TitanVenus_hasArcana > 2 then
    local bid = 4436
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    target:addBuff(binfo, caster)
  end
end

function TitanVenus.skillult_onAttackFrame(basefunc, skill)
  basefunc(skill)
  if ed.run_with_scene then
    ed.scene:playEffectOnScene("eff_point_TitanVenus_ult.cha", {400, 200}, {1, 1}, nil, 1)
  end
end

function TitanVenus.skillenter_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  caster.position[1] = ed.engine.stage_rect.maxX / 2 - 120 * caster:getInitDir()
end

function TitanVenus.init_hero(hero)
  local skillult = hero.skills.TitanVenus_ult
  local skillatk = hero.skills.TitanVenus_atk
  local skillenter = hero.skills.TitanVenus_enter
  hero.TitanVenus_hasArcana = ed.getProtoArcanaLevel(hero.proto)
  if skillatk then
    skillatk.reset = override(skillatk.reset, TitanVenus.skillatk_reset)
    skillatk.takeEffectOn = override(skillatk.takeEffectOn, TitanVenus.skillatk_takeEffectOn)
    skillatk.onAttackFrame = override(skillatk.onAttackFrame, TitanVenus.skillatk_onAttackFrame)
  end
  if skillult then
    skillult.takeEffectOn = override(skillult.takeEffectOn, TitanVenus.skillult_takeEffectOn)
    skillult.onAttackFrame = override(skillult.onAttackFrame, TitanVenus.skillult_onAttackFrame)
  end
  if skillenter then
    skillenter.info = ed.wraptable(skillenter.info, {
      ["Init CD"] = 0
    })
    skillenter.start = override(skillenter.start, TitanVenus.skillenter_start)
  end
  hero.update = override(hero.update, TitanVenus.update)
  hero.reset = override(hero.reset, TitanVenus.reset)
  return hero
end

return TitanVenus.init_hero
