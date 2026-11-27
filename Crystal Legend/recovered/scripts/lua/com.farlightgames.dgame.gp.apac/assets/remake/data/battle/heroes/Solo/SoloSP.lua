module("ed.battlehero", package.seeall)
local ed = ed
SoloSP = {}

function SoloSP.skillult_onAttackFrame(basefunc, skill, target, source)
  basefunc(skill)
  local caster = skill.caster
  caster:takeHeal(200, "hp", caster, nil, {
    type = 2,
    id = skill.info.Slot
  })
end

function SoloSP.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  local skillpasv = hero.skills.SP_pasv
  if skillpasv then
    if not hero.HealTime then
      hero.HealTime = 0
    end
    if hero.HealTime then
      hero.HealTime = hero.HealTime + dt
      if hero.HealTime >= 1 then
        local HealPower = 16
        hero:takeHeal(HealPower, "hp", hero, nil, {
          type = 2,
          id = skillpasv.info.Slot
        })
        hero.HealTime = 0
      end
    end
  end
end

function SoloSP.hero_true_init(hero)
  hero.update = override(hero.update, SoloSP.hero_update)
  local skillult = hero.skills.SP_ult
  if skillult then
    skillult.onAttackFrame = override(skillult.onAttackFrame, SoloSP.skillult_onAttackFrame)
  end
  return hero
end

function SoloSP.init_hero(hero)
  SoloSP.hero_true_init(hero)
  return hero
end

return SoloSP.init_hero
