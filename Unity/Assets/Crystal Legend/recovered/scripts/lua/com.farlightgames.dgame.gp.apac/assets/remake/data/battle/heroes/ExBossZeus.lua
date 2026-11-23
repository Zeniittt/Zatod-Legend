module("ed.battlehero", package.seeall)
local ed = ed
ExBossZeus = {}

function ExBossZeus.hero_reset(basefunc, hero)
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
  hero.ZeusStayTime = 0
  hero.ZeusTakeLightning = 0
end

function ExBossZeus.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  hero.ZeusStayTime = hero.ZeusStayTime + dt
end

function ExBossZeus.skillult_takeEffectOn(basefunc, skill, target)
  local caster = skill.caster
  local staytime = caster.ZeusStayTime
  local skillult = caster.skills.ExBossZeus_ult
  if skillult then
    local Power = staytime * caster.level * 2
    skill.info["Basic Num"] = Power
    basefunc(skill, target)
  end
end

function ExBossZeus.skillatk2_takeEffectOn(basefunc, skill, target)
  local caster = skill.caster
  local staytime = caster.ZeusStayTime
  local skillult = caster.skills.ExBossZeus_atk2
  if skillult then
    local Power = staytime * caster.level * 1
    skill.info["Basic Num"] = Power
    basefunc(skill, target)
  end
end

function ExBossZeus.skillatk3_takeEffectOn(basefunc, skill, target)
  local caster = skill.caster
  local staytime = caster.ZeusStayTime
  local skillult = caster.skills.ExBossZeus_atk3
  if skillult then
    local Power = staytime * caster.level * 2
    skill.info["Basic Num"] = Power
    basefunc(skill, target)
  end
end

function ExBossZeus.skill_getLostHPAfterImmunity(basefunc, self, damage, immunity)
  damage = damage and math.max(damage - self.attribs.AP * 0.4, 1)
  return basefunc(self, damage, immunity)
end

function ExBossZeus.init_hero(hero)
  hero.update = override(hero.update, ExBossZeus.hero_update)
  hero.reset = override(hero.reset, ExBossZeus.hero_reset)
  hero.getLostHPAfterImmunity = override(hero.getLostHPAfterImmunity, ExBossZeus.skill_getLostHPAfterImmunity)
  local skillult = hero.skills.ExBossZeus_ult
  if skillult then
    skillult.takeEffectOn = override(skillult.takeEffectOn, ExBossZeus.skillult_takeEffectOn)
  end
  local skillatk2 = hero.skills.ExBossZeus_atk2
  if skillatk2 then
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, ExBossZeus.skillatk2_takeEffectOn)
  end
  local skillatk3 = hero.skills.ExBossZeus_atk3
  if skillatk3 then
    skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, ExBossZeus.skillatk3_takeEffectOn)
  end
  return hero
end

return ExBossZeus.init_hero
