module("ed.battlehero", package.seeall)
local ed = ed
SoloAM = {}

function SoloAM.skillult_power(basefunc, skill, source, target, damage_type)
  local power, coeff = basefunc(skill, source, target, damage_type)
  local caster = skill.caster
  local caster_dodg = caster.attribs.DODG
  local target_dodg = target.attribs.DODG
  power = power + math.max(caster_dodg - target_dodg, 0) * 5
  return power, coeff
end

function SoloAM.skillatk_takeEffectOn(basefunc, skill, target, source)
  local isHit, dmg = basefunc(skill, target, source)
  local caster = skill.caster
  local rand = ed.rand()
  if caster and isHit and 0.2 <= rand then
    target:takeDamage({
      amount = 10,
      damage_type = "Holy",
      field = "mp",
      source = caster,
      coefficient = 1,
      soloParams = {
        type = 2,
        id = skill.info.Slot
      }
    })
  end
  return isHit, dmg
end

function SoloAM.skillult_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  if attack_counter == 1 then
    basefunc(skill)
  else
    skill.attack_counter = skill.attack_counter + 1
  end
end

function SoloAM.hero_true_init(hero)
  local skillult = hero.skills.AM_ult
  if skillult then
    skillult.power = override(skillult.power, SoloAM.skillult_power)
    skillult.onAttackFrame = override(skillult.onAttackFrame, SoloAM.skillult_onAttackFrame)
  end
  local skillatk = hero.skills.AM_atk
  if skillatk then
    skillatk.takeEffectOn = override(skillatk.takeEffectOn, SoloAM.skillatk_takeEffectOn)
  end
  return hero
end

function SoloAM.init_hero(hero)
  SoloAM.hero_true_init(hero)
  return hero
end

return SoloAM.init_hero
