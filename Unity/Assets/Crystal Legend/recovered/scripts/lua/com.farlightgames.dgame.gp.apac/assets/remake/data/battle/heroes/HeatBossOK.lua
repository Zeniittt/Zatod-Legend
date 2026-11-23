module("ed.battlehero", package.seeall)
local ed = ed
HeatBossOK = {}
HeatBossOK.HeatBossQOPdyingbuff = 10036506
HeatBossOK.sacrifice = 10036603
HeatBossOK.atk4buff = 10036604

function HeatBossOK.update(basefunc, unit, dt)
  for u in ed.engine:foreachAliveUnit(unit.camp) do
    if u.tid == 365 and u:isAlive() then
      for i, tbuff in ipairs(u.buff_list) do
        if tbuff.info.ID == HeatBossOK.HeatBossQOPdyingbuff and unit:isAlive() and not unit.havecastatk4 then
          local skillatk4 = unit.skills.HeatBossOK_atk4
          if skillatk4 then
            unit.global_cd = 0
            skillatk4.cd_remaining = 0
            local list = unit.buff_list
            local debuff_list = {}
            for i = 1, #list do
              local buff = list[i]
              if buff and buff.caster ~= unit then
                debuff_list[#debuff_list + 1] = buff
              end
            end
            for i = 1, #debuff_list do
              debuff_list[i].timer = -1
            end
            unit.havecastatk4 = true
            local bid = HeatBossOK.atk4buff
            local binfo = ed.lookupDataTable("Buff", nil, bid)
            local caster = unit
            caster:addBuff(binfo, caster)
            local bid1 = 10006509
            local binfo1 = ed.lookupDataTable("Buff", nil, bid1)
            local buff1 = caster:addBuff(binfo1, caster)
          end
        end
      end
    end
  end
  basefunc(unit, dt)
end

function HeatBossOK.skillatk4_start(basefunc, skill, target)
  basefunc(skill, target)
  local self = skill.caster
  local list = self.buff_list
  local debuff_list = {}
  for i = 1, #list do
    local buff = list[i]
    if buff and buff.caster ~= self then
      debuff_list[#debuff_list + 1] = buff
    end
  end
  for i = 1, #debuff_list do
    debuff_list[i].timer = -1
  end
end

function HeatBossOK.skillatk4_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  local hero = skill.caster
  local target = skill.target
  if attack_counter == 0 then
    ed.engine:freeze(hero.camp)
    hero:unfreeze()
    for u in ed.engine:foreachAliveUnit(hero.camp) do
      if u.tid == 365 and u:isAlive() then
        u:unfreeze()
      end
    end
    local bid = HeatBossOK.sacrifice
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, hero, hero)
    hero:addBuff(buff, hero)
    skill.attack_counter = skill.attack_counter + 1
  elseif attack_counter == 1 then
    basefunc(skill)
  elseif attack_counter == 2 then
    ed.engine:unfreeze()
    skill.attack_counter = skill.attack_counter + 1
  elseif attack_counter == 3 then
    for u in ed.engine:foreachAliveUnit(hero.camp) do
      if u.tid == 365 and u:isAlive() then
        local bid = 10036509
        local binfo = ed.lookupDataTable("Buff", nil, bid)
        local buff = ed.BuffCreate(binfo, u, u)
        buff:setAttribute("AD", u.level * 12.5)
        buff:setAttribute("AP", u.level * 12.5)
        buff:setAttribute("ARM", u.level * 3)
        buff:setAttribute("AP", u.level * 3)
        u:addBuff(buff, u)
      end
    end
  end
end

function HeatBossOK.skillatk4_takeEffectOn(basefunc, skill, target, source, shift)
  basefunc(skill, target, source, shift)
  local caster = skill.caster
  local list = target.buff_list
  local buff_list = {}
  local myenemycamp = caster.foecamp
  for i = 1, #list do
    local buff = list[i]
    if buff and (not buff.caster or buff.caster.camp == myenemycamp) and buff.info.Dispel == "YES" then
      buff_list[#buff_list + 1] = buff
    end
  end
  for i = 1, #buff_list do
    target:removeBuff(buff_list[i])
  end
  target:takeDamage(1000, "Holy", "mp", caster)
  caster.skillatk4_takeeffecton = true
  if not caster.HeatBossQOPhaverebirth then
    for unit in ed.engine:foreachAliveUnit(caster.camp) do
      if unit.tid == 365 and unit:isAlive() then
        unit.heatbossoksacrifice = true
        local hpheal = 0.3
        for i, tbuff in ipairs(unit.buff_list) do
          if tbuff.info.ID == 20050091 then
            hpheal = 0.4
          end
          if tbuff.info.ID == 20050092 then
            hpheal = 0.5
          end
          if tbuff.info.ID == 20050093 then
            hpheal = 0.6
          end
          if tbuff.info.ID == 20050094 then
            hpheal = 0.7
          end
        end
        unit:takeHeal(unit.attribs.HP * hpheal, "hp", caster)
        unit:takeHeal(1000, "mp", caster)
        caster.HeatBossQOPhaverebirth = true
      end
    end
  end
end

function HeatBossOK.skillatk4_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  caster:die()
end

function HeatBossOK.die(basefunc, self, killer)
  if not self:isAlive() then
    return
  end
  self.unitonDying = false
  if do_battle_log then
    btlog("%s died.", self:display())
  end
  self.state = ed.emUnitState_Dying
  self.killer = killer
  if self.current_skill then
    self.current_skill:interrupt()
  end
  if self.manually_casting then
    self.manually_casting = false
    ed.engine:unfreeze()
  end
  self:removeSignedBuffer()
  self.can_cast_manual = false
  self.walk_v = {0, 0}
  self.hp = 0
  self.mp = 0
  if not self.skillatk4_takeeffecton then
    self:setAction("Death", false, true)
  else
    self.action_name = nil
    self.action_loop = false
    self.action_duration = 0
    self.action_elapsed = 0
  end
  for unit in ed.engine:foreachAliveUnit(self.camp) do
    if unit.tid == 365 and unit:isAlive() then
      local heatbossqopdying = false
      for i, tbuff in ipairs(unit.buff_list) do
        if tbuff.info.ID == HeatBossOK.HeatBossQOPdyingbuff then
          heatbossqopdying = true
        end
      end
      if not self.skillatk4_takeeffecton then
        if heatbossqopdying then
          unit:die()
        else
          local hpheal = 0.3
          for i, tbuff in ipairs(unit.buff_list) do
            if tbuff.info.ID == 20050091 then
              hpheal = 0.4
            end
            if tbuff.info.ID == 20050092 then
              hpheal = 0.5
            end
            if tbuff.info.ID == 20050093 then
              hpheal = 0.6
            end
            if tbuff.info.ID == 20050094 then
              hpheal = 0.7
            end
          end
          unit:takeHeal(unit.attribs.HP * hpheal, "hp", self)
          unit:takeHeal(1000, "mp", self)
          local bid = 10036509
          local binfo = ed.lookupDataTable("Buff", nil, bid)
          local buff = ed.BuffCreate(binfo, unit, self)
          buff:setAttribute("AD", unit.level * 12.5)
          buff:setAttribute("AP", unit.level * 12.5)
          buff:setAttribute("ARM", unit.level * 3)
          buff:setAttribute("AP", unit.level * 3)
          unit:addBuff(buff, self)
        end
      end
    end
  end
  local sureKMPR = ed.rand() < self.attribs.KMPR / 100
  ed.engine:onUnitDie(self, self.killer, sureKMPR)
  self:applyAuraSkill()
  if self.actor then
    local model = self.actor.model
    local duration = model.action_duration
    local delay = 0
    if model.isDeathWithEffect then
      delay = 0
    end
    if duration + delay <= 0 then
      self.actor.node:setVisible(false)
      self.actor.is_terminated = true
    elseif model.isDisapearWhenDie or nil == model.isDisapearWhenDie then
      self.actor.puppet:runAction(CCSequence:create(ccArrayMake(CCDelayTime:create(duration + delay), CCFadeOut:create(1), CCCallFunc:create(function()
        self.actor.node:setVisible(false)
        self.actor.is_terminated = true
      end))))
    end
    self.actor.isDied = true
    self.actor.puppet:setActionSpeeder(1)
    self.actor.offline = true
    self.actor.puppet:setLoop(false)
    self.actor.velocity = {0, 0}
    self.actor:playGoldDropEffect()
  end
end

function HeatBossOK.reset(basefunc, hero)
  basefunc(hero)
  hero.skillatk4_takeeffecton = false
  hero.HeatBossQOPhaverebirth = false
  hero.havecastatk4 = false
end

function HeatBossOK.skillult_takeEffectOn(basefunc, skill, target, source, shift)
  local isHit, dmg = basefunc(skill, target, source, shift)
  local skillults = skill.caster.skills.HeatBossOK_ults
  if skillults and isHit then
    skillults:takeEffectAt(skill.target.position)
  end
  return isHit, dmg
end

function HeatBossOK.init_hero(hero)
  local skillult = hero.skills.HeatBossOK_ult
  local skillatk = hero.skills.HeatBossOK_atk
  local skillatk2 = hero.skills.HeatBossOK_atk2
  local skillatk3 = hero.skills.HeatBossOK_atk3
  local skillatk4 = hero.skills.HeatBossOK_atk4
  if skillult then
    skillult.takeEffectOn = override(skillult.takeEffectOn, HeatBossOK.skillult_takeEffectOn)
  end
  if skillatk4 then
    hero.update = override(hero.update, HeatBossOK.update)
    hero.reset = override(hero.reset, HeatBossOK.reset)
    hero.die = override(hero.die, HeatBossOK.die)
    skillatk4.start = override(skillatk4.start, HeatBossOK.skillatk4_start)
    skillatk4.takeEffectOn = override(skillatk4.takeEffectOn, HeatBossOK.skillatk4_takeEffectOn)
    skillatk4.onAttackFrame = override(skillatk4.onAttackFrame, HeatBossOK.skillatk4_onAttackFrame)
    skillatk4.finish = override(skillatk4.finish, HeatBossOK.skillatk4_finish)
  end
  return hero
end

return HeatBossOK.init_hero
