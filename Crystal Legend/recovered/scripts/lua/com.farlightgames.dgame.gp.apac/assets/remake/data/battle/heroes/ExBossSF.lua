module("ed.battlehero", package.seeall)
local ed = ed
ExBossSF = {}

function ExBossSF.hero_reset(basefunc, hero)
  basefunc(hero)
  if not hero.has_resetted then
    hero.has_resetted = true
    local owner = hero
    local bid1 = 152
    local binfo1 = ed.lookupDataTable("Buff", nil, bid1)
    local buff1 = ed.BuffCreate(binfo1, owner, owner)
    owner:addBuff(buff1, owner)
    local bid2 = 296
    local binfo2 = ed.lookupDataTable("Buff", nil, bid2)
    local buff2 = ed.BuffCreate(binfo2, owner, owner)
    owner:addBuff(buff2, owner)
  end
end

function ExBossSF.getLostHPAfterImmunity(basefunc, self, damage, immunity)
  local immunity = 92
  return basefunc(self, damage, immunity)
end

function ExBossSF.update(basefunc, self, dt)
  if self.state == ed.emUnitState_Dying then
    if not self.dyingTimer then
      self.dyingTimer = 0.8
    end
    self.dyingTimer = self.dyingTimer - dt
    if self.dyingTimer <= 0 then
      self.dyingTimer = 99999
      local skill = self.skills.ExBossSF_ult
      skill:takeEffectAt(self.position)
    end
  else
    self.dyingTimer = nil
  end
  basefunc(self, dt)
end

function ExBossSF.hero_handleUnitDieEvent(basefunc, self, unit, killer_unit)
  basefunc(self, unit, killer_unit)
  local skillatk3 = self.skills.ExBossSF_atk3
  local skillatk3s = self.skills.ExBossSF_atk3s
  if skillatk3 and not unit.config.is_summoned then
    skillatk3:takeEffectOn(self, self)
  end
  if skillatk3 and unit.camp ~= self.camp and unit.config.is_summoned then
    local losthp = self.hp * 0.08
    self:setHP(self.hp - losthp)
    skillatk3s:takeEffectOn(self, self)
  end
end

function ExBossSF.skill5_power(basefunc, skill, source, target, damage_type)
  local caster = skill.caster
  local info = caster.skills.ExBossSF_atk2.info
  local multiplier = info["Plus Ratio"]
  local base_attrib = caster.attribs[info["Plus Attr"]]
  local power = multiplier * base_attrib + info["Basic Num"]
  return power, 1
end

function ExBossSF.skill2_finish(basefunc, skill)
  skill.currentNum = skill.currentNum + 1
  if skill.currentNum >= 3 then
    skill.currentNum = 0
    skill.cd_remaining = 9
  end
  basefunc(skill)
end

function ExBossSF.skill2_takeEffectAt(basefunc, skill, location, source)
  local originfo = skill.info
  skill.info = ed.wraptable(originfo, {
    ["X Shift"] = originfo["X Shift"] + skill.currentNum * 100
  })
  basefunc(skill, location, source)
  skill.info = originfo
end

function ExBossSF.init_hero(hero)
  hero.reset = override(hero.reset, ExBossSF.hero_reset)
  hero.getLostHPAfterImmunity = override(hero.getLostHPAfterImmunity, ExBossSF.getLostHPAfterImmunity)
  hero.update = override(hero.update, ExBossSF.update)
  hero.handleUnitDieEventToAll = override(hero.handleUnitDieEventToAll, ExBossSF.hero_handleUnitDieEvent)
  local skill2 = hero.skills.ExBossSF_atk2
  if skill2 then
    skill2.takeEffectAt = override(skill2.takeEffectAt, ExBossSF.skill2_takeEffectAt)
    skill2.finish = override(skill2.finish, ExBossSF.skill2_finish)
    skill2.currentNum = 0
  end
  return hero
end

return ExBossSF.init_hero
