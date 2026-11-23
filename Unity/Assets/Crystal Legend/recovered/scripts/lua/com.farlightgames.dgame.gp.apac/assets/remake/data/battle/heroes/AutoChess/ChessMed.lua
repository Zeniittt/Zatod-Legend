module("ed.battlehero", package.seeall)
local ed = ed
ChessMed = {}
ChessMed.Med_ultend_buffID = 6005
ChessMed.Med_ultstone_buffID = 6006

function ChessMed.skillult_takeEffectAt(basefunc, skill, location, source)
  skill.caster.ult_counter = skill.info["Script Arg3"]
  basefunc(skill, location, source)
end

function ChessMed.skillult_takeEffectOn(basefunc, skill, target, source, shift)
  local caster = skill.caster
  if caster.ult_counter == 0 then
    return false
  end
  local out, dmg, Crit, lfs_amount = basefunc(skill, target, source, shift)
  caster.ult_counter = caster.ult_counter - 1
  return out, dmg, Crit, lfs_amount
end

function ChessMed.init_hero(hero)
  hero.ult_counter = 0
  local skillult = hero.skills.Med_ult
  if skillult then
    skillult.takeEffectAt = override(skillult.takeEffectAt, ChessMed.skillult_takeEffectAt)
    skillult.takeEffectOn = override(skillult.takeEffectOn, ChessMed.skillult_takeEffectOn)
  end
  return hero
end

return ChessMed.init_hero
