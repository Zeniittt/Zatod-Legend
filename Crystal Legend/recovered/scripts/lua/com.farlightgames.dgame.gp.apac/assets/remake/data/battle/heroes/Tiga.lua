module("ed.battlehero", package.seeall)
local ed = ed
Tiga = {}
Tiga.buff_summoned_id = 502
Tiga.buff_stun0 = 35

function Tiga.skillult_onAttackFrame(basefunc, skill)
  if skill.attack_counter == 0 then
    basefunc(skill)
  elseif skill.target and not skill.target:isAlive() then
    skill:finish()
  else
    basefunc(skill)
  end
end

function Tiga.skillult_takeEffectOn(basefunc, skill, target, source, shift)
  local is_damage, num_damage = basefunc(skill, target, source, shift)
  if is_damage then
    if target:isAlive() then
      local buff_stun_info = ed.lookupDataTable("Buff", nil, buff_stun0)
      local bSucess = ed.Buff.checkAddBuff(buff_stun_info, skill.level, target, caster)
      if bSucess then
        target:addBuff(buff_stun_info, skill.caster)
      end
    end
    if not target:isAlive() and target.killer and target.killer == skill.caster then
      local caster = skill.caster
      local explode_pos = target.position
      local skillultb = caster.skills.Tiga_ultb
      if skillultb then
        skillultb:takeEffectAt(explode_pos)
      end
    end
    return true, num_damage
  else
    return false
  end
end

function Tiga.skillultb_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff:setAttribute("fearrange", 5)
  return buff
end

function Tiga.skillatk3_takeEffectOn(basefunc, skill, target, source, shift)
  local is_damage, num_damage = basefunc(skill, target, source, shift)
  if is_damage then
    if target.config.is_summoned and target:isAlive() then
      local caster = skill.caster
      local binfo_summoned = ed.lookupDataTable("Buff", nil, buff_summoned_id)
      local bSucess, reason = ed.Buff.checkAddBuff(binfo_summoned, skill.level, target, caster)
      if bSucess then
        target:addBuff(binfo_summoned, caster)
      else
        local color = target.camp == ed.emCampEnemy and "red" or "blue"
        local text = reason == "resist" and "resist" or "miss"
        if target.actor then
          ed.PopupCreate(text, color, target.actor, nil, "text")
        end
      end
    end
    return true, num_damage
  else
    return false
  end
end

function Tiga.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  local skillatk4 = hero.skills.Tiga_atk4
  if skillatk4 then
    if not hero.Tiga_shieldtimer then
      hero.Tiga_shieldtimer = 5
    end
    hero.Tiga_shieldtimer = hero.Tiga_shieldtimer - dt
    if hero.Tiga_shieldtimer <= 0 and hero:isAlive() then
      local didShield = skillatk4:takeEffectOn(hero)
      if didShield then
        hero.Tiga_shieldtimer = 15
      end
    end
  end
  local skillawake = hero.skills.Tiga_awake
  if skillawake and not hero.Tiga_didRed then
    if not hero.Tiga_redtimer then
      hero.Tiga_redtimer = 0
    end
    hero.Tiga_redtimer = hero.Tiga_redtimer + dt
    if (hero.Tiga_redtimer >= 25 or ed.engine.ticks >= 200) and hero:isAlive() then
      local didRed = skillawake:takeEffectOn(hero)
      if didRed then
        hero.Tiga_didRed = true
        if ed.run_with_scene and hero.actor then
          local Tiga_actor = hero.actor
          Tiga_actor:addEffectToComponent("eff_buff_Tiga_flash.cha", "shenti2", 0, {
            x = 2.5,
            y = 2,
            inherit_rotation = true,
            inherit_visible = true
          })
        end
      end
    end
  end
end

function Tiga.hero_reset(basefunc, hero)
  hero.Tiga_redtimer = nil
  hero.Tiga_didRed = nil
  hero.Tiga_shieldtimer = nil
  hero.Tiga_atkbRandom = nil
  basefunc(hero)
end

function Tiga.hero_usePuppet(basefunc, hero)
  basefunc(hero)
  if ed.run_with_scene and hero.Tiga_didRed then
    local Tiga_actor = hero.actor
    Tiga_actor:addEffectToComponent("eff_buff_Tiga_flash.cha", "shenti2", 0, {
      x = 2.5,
      y = 2,
      inherit_rotation = true,
      inherit_visible = true
    })
  end
end

function Tiga.skillatkb_startPhase(basefunc, skill, idx)
  local phaseNum = idx
  local caster = skill.caster
  if not caster.Tiga_atkbRandom then
    caster.Tiga_atkbRandom = {
      [1] = 2,
      [2] = 2
    }
  end
  local randNum = ed.rand()
  if 0.5 < randNum then
    phaseNum = phaseNum + 1
  end
  if phaseNum ~= 1 and phaseNum ~= 2 then
    phaseNum = 2
  end
  if caster.Tiga_atkbRandom[1] == caster.Tiga_atkbRandom[2] then
    phaseNum = caster.Tiga_atkbRandom[1] % 2 + 1
  end
  caster.Tiga_atkbRandom[1] = caster.Tiga_atkbRandom[2]
  caster.Tiga_atkbRandom[2] = phaseNum
  basefunc(skill, phaseNum)
end

function Tiga.skillatkb_onPhaseFinished(basefunc, skill)
  skill:finish()
end

function Tiga.init_hero(hero)
  local skillult = hero.skills.Tiga_ult
  if skillult then
    skillult.onAttackFrame = override(skillult.onAttackFrame, Tiga.skillult_onAttackFrame)
    skillult.takeEffectOn = override(skillult.takeEffectOn, Tiga.skillult_takeEffectOn)
  end
  local skillultb = hero.skills.Tiga_ultb
  if skillultb then
    skillultb.createBuff = override(skillultb.createBuff, Tiga.skillultb_createBuff)
  end
  local skillatk3 = hero.skills.Tiga_atk3
  if skillatk3 then
    skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, Tiga.skillatk3_takeEffectOn)
  end
  local skillatk4 = hero.skills.Tiga_atk4
  local skillawake = hero.skills.Tiga_awake
  if skillatk4 or skillawake then
    hero.update = override(hero.update, Tiga.hero_update)
    hero.reset = override(hero.reset, Tiga.hero_reset)
    hero.usePuppet = override(hero.usePuppet, Tiga.hero_usePuppet)
  end
  local skillatkb = hero.skills.Tiga_atkb
  if skillatkb then
    skillatkb.startPhase = override(skillatkb.startPhase, Tiga.skillatkb_startPhase)
    skillatkb.onPhaseFinished = override(skillatkb.onPhaseFinished, Tiga.skillatkb_onPhaseFinished)
  end
  return hero
end

return Tiga.init_hero
