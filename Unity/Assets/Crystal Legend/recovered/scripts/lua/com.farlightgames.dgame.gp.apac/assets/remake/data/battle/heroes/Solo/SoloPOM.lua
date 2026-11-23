module("ed.battlehero", package.seeall)
local ed = ed
SoloPOM = {}

function SoloPOM.hero_reset(basefunc, hero)
  basefunc(hero)
end

function SoloPOM.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  local skillpasv = hero.skills.POM_pasv
  if skillpasv then
    if not hero.HealTime then
      hero.HealTime = 0
    end
    if hero.HealTime then
      hero.HealTime = hero.HealTime + dt
      if hero.HealTime >= 1 then
        hero:addHaste(5 + hero.level * 2, {
          type = 2,
          id = skillpasv.info.Slot
        }, hero)
        hero.HealTime = 0
      end
    end
  end
end

function SoloPOM.skillult_power(basefunc, skill, source, target, damage_type)
  local power, coeff = basefunc(skill, source, target, damage_type)
  local caster = skill.caster
  local ult_powerPlus = caster.hasteValue
  power = power + ult_powerPlus
  return power, coeff
end

function SoloPOM.hero_true_init(hero)
  local skillult = hero.skills.POM_ult
  if skillult then
    skillult.power = override(skillult.power, SoloPOM.skillult_power)
  end
  hero.update = override(hero.update, SoloPOM.hero_update)
  hero.reset = override(hero.reset, SoloPOM.hero_reset)
  return hero
end

function SoloPOM.init_hero(hero)
  SoloPOM.hero_true_init(hero)
  return hero
end

return SoloPOM.init_hero
