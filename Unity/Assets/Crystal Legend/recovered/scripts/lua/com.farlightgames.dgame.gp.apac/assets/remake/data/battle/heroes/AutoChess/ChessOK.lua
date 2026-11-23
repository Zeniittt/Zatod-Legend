module("ed.battlehero", package.seeall)
local ed = ed
ChessOK = {}

function ChessOK.skillult_takeEffectOn(basefunc, skill, target, source, shift)
  local isHit, dmg, Crit, lfs_amount = basefunc(skill, target, source, shift)
  local caster = skill.caster
  local skillultb = caster.skills.OK_ultb
  if skillultb and target and isHit then
    skillultb:takeEffectAt(target.position, caster)
  end
  return isHit, dmg, Crit, lfs_amount
end

function ChessOK.init_hero(hero)
  local skillult = hero.skills.OK_ult
  if skillult then
    skillult.takeEffectOn = override(skillult.takeEffectOn, ChessOK.skillult_takeEffectOn)
  end
  return hero
end

return ChessOK.init_hero
