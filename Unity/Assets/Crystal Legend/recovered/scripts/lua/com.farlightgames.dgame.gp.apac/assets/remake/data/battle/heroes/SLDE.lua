module("ed.battlehero", package.seeall)
local ed = ed
SLDE = {}
SLDE.SLDE_changetime = 12

function SLDE.changehead(picname, unit)
  if ed.run_with_scene then
    local panel = unit.heroPanel
    if panel and unit.name == "SLDE" then
      panel:setPortrait("UI/DOTA-HERO/" .. picname)
    end
  end
end

function SLDE.reset(basefunc, unit)
  basefunc(unit)
  unit.SLDE_runeold = 999
  unit.SLDE_runenow = 999
  unit.SLDE_runetime = SLDE.SLDE_changetime
  local bookskill = unit.skills.SLDE_warschool
  if bookskill then
    for i = 1, 20 do
      ed.rand()
    end
    local caster = unit
    unit.SLDE_rune = math.floor(ed.rand() * 3)
    unit.SLDE_runeold = unit.SLDE_rune
    unit.SLDE_runenow = unit.SLDE_rune
    if caster.SLDE_runenow == 0 then
      if ed.protoAwake(caster.proto, 10005) then
        SLDE.changehead("SwitchSLDE_R.png", caster)
        caster:enterActionStageFromOneStage(6, 10005)
      else
        SLDE.changehead("SLDE_R.png", caster)
        caster:enterActionStageFromOneStage(2, 10005)
      end
      caster.SLDE_runeold = caster.SLDE_rune
    elseif caster.SLDE_runenow == 1 then
      if ed.protoAwake(caster.proto, 10005) then
        SLDE.changehead("SwitchSLDE_G.png", caster)
        caster:enterActionStageFromOneStage(7, 10005)
      else
        SLDE.changehead("SLDE_G.png", caster)
        caster:enterActionStageFromOneStage(3, 10005)
      end
      caster.SLDE_runeold = caster.SLDE_rune
    elseif caster.SLDE_runenow == 2 then
      if ed.protoAwake(caster.proto, 10005) then
        SLDE.changehead("SwitchSLDE_Y.png", caster)
        caster:enterActionStageFromOneStage(8, 10005)
      else
        SLDE.changehead("SLDE_Y.png", caster)
        caster:enterActionStageFromOneStage(4, 10005)
      end
    end
    unit.SLDE_runetime = bookskill.info["Script Arg1"]
  end
end

function SLDE.update(basefunc, unit, dt)
  basefunc(unit, dt)
  unit.SLDE_runetime = unit.SLDE_runetime - dt
  if unit.SLDE_runetime < 0 then
    local skillatk4 = unit.skills.SLDE_atk4
    skillatk4.cd_remaining = 0
    unit.SLDE_golbalcd = unit.global_cd
    unit.global_cd = 0
    if unit.SLDE_runeold == 999 then
      unit.SLDE_rune = math.floor(ed.rand() * 3)
    else
      unit.SLDE_rune = (unit.SLDE_runeold + 1) % 3
    end
    unit.SLDE_runetime = 99999999
  end
end

function SLDE.hero_enterActionStageFromOneStage(basefunc, self, nStage, name)
  if not self.isActionStageChangeByManual then
    local actionStage = nStage
    if actionStage then
      self.currentActionStage = actionStage
      self:enterActionStage(self.currentActionStage)
    end
  else
    self.currentActionStage = nStage
    self:enterActionStage(nStage)
  end
end

function SLDE.skillatk4_start(basefunc, self, target)
  local info = self.info
  if do_battle_log then
    btlog("%s began to cast %s --> %s", self.caster:display(), self:display(), target and target:display() or "nil")
  end
  self.target = target
  self:selectTarget(target)
  self.cd_remaining = info.CD
  self.casting = true
  self.attack_counter = 0
  local caster = self.caster
  if caster.SLDE_runeold == 999 and caster.SLDE_rune == 0 then
    self:startPhase(1)
    caster.SLDE_runenow = 0
  elseif caster.SLDE_runeold == 999 and caster.SLDE_rune == 1 then
    self:startPhase(2)
    caster.SLDE_runenow = 1
  elseif caster.SLDE_runeold == 999 and caster.SLDE_rune == 2 then
    self:startPhase(3)
    caster.SLDE_runenow = 2
  elseif caster.SLDE_runeold == 0 and caster.SLDE_rune == 1 then
    self:startPhase(4)
    caster.SLDE_runenow = 1
  elseif caster.SLDE_runeold == 1 and caster.SLDE_rune == 2 then
    self:startPhase(5)
    caster.SLDE_runenow = 2
  elseif caster.SLDE_runeold == 2 and caster.SLDE_rune == 0 then
    self:startPhase(6)
    caster.SLDE_runenow = 0
  end
  self.is_update = true
  local caster = self.caster
  caster.global_cd = info["Global CD"]
  caster:setMP(caster.mp - info["Cost MP"] * (1 - caster.attribs.CDR / 100))
  if caster.actor then
    local effect_name = info["Launch Effect"]
    if effect_name then
      caster.actor:addEffect(effect_name, -1)
    end
  end
  caster.SLDE_atkcd = caster.skills.SLDE_atk.cd_remaining
  caster.SLDE_atk2cd = caster.skills.SLDE_atk2.cd_remaining
  caster.SLDE_atk3cd = caster.skills.SLDE_atk3.cd_remaining
end

function SLDE.skillatk4_onPhaseFinished(basefunc, self)
  self:finish()
end

function SLDE.skillatk4_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  caster.changePeriod_SLDE = true
  local skillatk4c = caster.skills.SLDE_atk4c
  if skillatk4c then
    caster:addBuff(skillatk4c:createBuff(caster))
  end
end

function SLDE.skillatk4_finish(basefunc, skill)
  local caster = skill.caster
  if caster.changePeriod_SLDE then
    caster.SLDE_runetime = SLDE.SLDE_changetime
    if caster.SLDE_runenow == 0 then
      if ed.protoAwake(caster.proto, 10005) then
        SLDE.changehead("SwitchSLDE_R.png", caster)
        caster:enterActionStageFromOneStage(6, 10005)
      else
        SLDE.changehead("SLDE_R.png", caster)
        caster:enterActionStageFromOneStage(2, 10005)
      end
      caster.SLDE_runeold = caster.SLDE_rune
    elseif caster.SLDE_runenow == 1 then
      if ed.protoAwake(caster.proto, 10005) then
        SLDE.changehead("SwitchSLDE_G.png", caster)
        caster:enterActionStageFromOneStage(7, 10005)
      else
        SLDE.changehead("SLDE_G.png", caster)
        caster:enterActionStageFromOneStage(3, 10005)
      end
      caster.SLDE_runeold = caster.SLDE_rune
    elseif caster.SLDE_runenow == 2 then
      if ed.protoAwake(caster.proto, 10005) then
        SLDE.changehead("SwitchSLDE_Y.png", caster)
        caster:enterActionStageFromOneStage(8, 10005)
      else
        SLDE.changehead("SLDE_Y.png", caster)
        caster:enterActionStageFromOneStage(4, 10005)
      end
      caster.SLDE_runeold = caster.SLDE_rune
    end
  else
    caster.SLDE_runetime = SLDE.SLDE_changetime
  end
  caster.skills.SLDE_atk.cd_remaining = caster.SLDE_atkcd
  caster.skills.SLDE_atk2.cd_remaining = caster.SLDE_atk2cd
  caster.skills.SLDE_atk3.cd_remaining = caster.SLDE_atk3cd
  caster.global_cd = caster.SLDE_golbalcd
  basefunc(skill)
end

function SLDE.skill_takeEffectOn(basefunc, skill, target, source, shift)
  local caster = skill.caster
  local skillatk4 = caster.skills.SLDE_atk4
  local skillatk4b = caster.skills.SLDE_atk4b
  local skillawake = caster.skills.SLDE_awake
  local skillatk = caster.skills.SLDE_atk
  if caster.SLDE_runenow == 0 then
    local buff = skillatk4b:createBuff(caster)
    if skillawake and skill == skillatk then
      buff:setAttribute("LFS", buff.info.LFS * skillawake.info["Script Arg1"] / 100)
    end
    caster:addBuff(buff, caster)
    basefunc(skill, target)
    if buff then
      caster:removeBuff(buff)
    end
  elseif caster.SLDE_runenow == 1 then
    basefunc(skill, target)
  elseif caster.SLDE_runenow == 2 then
    local succ = basefunc(skill, target)
    if succ then
      local power = skillatk4.info["Script Arg3"]
      if skillawake and skill == skillatk then
        power = power * skillawake.info["Script Arg1"] / 100
      end
      target:takeDamage(power, "Holy", "mp", skill.caster)
    end
  else
    basefunc(skill, target)
  end
end

function SLDE.skill_getDamage(basefunc, skill, target, power, damage_type, field, source, crit_mod)
  local power2 = 0
  local powerfinal
  local caster = skill.caster
  local skillawake = caster.skills.SLDE_awake
  local skillatk = caster.skills.SLDE_atk
  if caster.SLDE_runenow == 1 then
    local skillatk4 = caster.skills.SLDE_atk4
    local ratio = skillatk4.info["Script Arg1"]
    local max = skillatk4.info["Script Arg2"]
    power2 = ratio * target.attribs.HP / 100
    if max <= power2 then
      power2 = max
    end
    if skillawake and skill == skillatk then
      power2 = power2 * skillawake.info["Script Arg1"] / 100
    end
  end
  powerfinal = power + power2
  return basefunc(skill, target, powerfinal, damage_type, field, source, crit_mod)
end

function SLDE.init_hero(hero)
  local skillult = hero.skills.SLDE_ult
  local skillatk = hero.skills.SLDE_atk
  local skillatk2 = hero.skills.SLDE_atk2
  local skillatk3 = hero.skills.SLDE_atk3
  local skillatk4 = hero.skills.SLDE_atk4
  local skillawake = hero.skills.SLDE_awake
  if skillatk4 then
    skillatk4.start = override(skillatk4.start, SLDE.skillatk4_start)
    skillatk4.finish = override(skillatk4.finish, SLDE.skillatk4_finish)
    skillatk4.onAttackFrame = override(skillatk4.start, SLDE.skillatk4_onAttackFrame)
    skillatk4.onPhaseFinished = override(skillatk4.onPhaseFinished, SLDE.skillatk4_onPhaseFinished)
    skillult.takeEffectOn = override(skillult.takeEffectOn, SLDE.skill_takeEffectOn)
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, SLDE.skill_takeEffectOn)
    skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, SLDE.skill_takeEffectOn)
    skillult.getDamage = override(skillult.getDamage, SLDE.skill_getDamage)
    skillatk2.getDamage = override(skillatk2.getDamage, SLDE.skill_getDamage)
    skillatk3.getDamage = override(skillatk3.getDamage, SLDE.skill_getDamage)
    hero.update = override(hero.update, SLDE.update)
    hero.reset = override(hero.reset, SLDE.reset)
    hero.enterActionStageFromOneStage = override(hero.enterActionStageFromOneStage, SLDE.hero_enterActionStageFromOneStage)
  end
  if skillawake then
    skillatk.getDamage = override(skillatk.getDamage, SLDE.skill_getDamage)
    skillatk.takeEffectOn = override(skillatk.takeEffectOn, SLDE.skill_takeEffectOn)
  end
  if ed.protoAwake(hero.proto, 10005) then
    hero:enterActionStageFromOneStage(5, 10005)
  end
  return hero
end

return SLDE.init_hero
