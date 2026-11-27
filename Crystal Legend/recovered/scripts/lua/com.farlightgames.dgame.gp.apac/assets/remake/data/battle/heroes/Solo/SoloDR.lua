module("ed.battlehero", package.seeall)
local ed = ed
SoloDR = {}

function SoloDR.skillult_takeEffectOn(basefunc, skill, target, source)
  local isHit, dmg = basefunc(skill, target, source)
  local caster = skill.caster
  if target and target.frozenValue and isHit then
    local damage = 1 * target.frozenValue
    target:takeDamage({
      amount = damage,
      damage_type = "AD",
      field = "hp",
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

function SoloDR.skillatk_takeEffectOn(basefunc, skill, target, source)
  local isHit, dmg = basefunc(skill, target, source)
  local caster = skill.caster
  if target and isHit then
    target:addFrozen(25, {type = 2, id = 1}, caster)
  end
  return isHit, dmg
end

function SoloDR.hero_true_init(hero)
  local skillatk = hero.skills.DR_atk
  local skillult = hero.skills.DR_ult
  if skillatk then
    skillatk.takeEffectOn = override(skillatk.takeEffectOn, SoloDR.skillatk_takeEffectOn)
  end
  if skillult then
    skillult.takeEffectOn = override(skillult.takeEffectOn, SoloDR.skillult_takeEffectOn)
  end
  return hero
end

function SoloDR.init_hero(hero)
  SoloDR.hero_true_init(hero)
  return hero
end

return SoloDR.init_hero
