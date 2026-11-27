module("ed.battlehero", package.seeall)
local ed = ed
ChessAM = {}

function ChessAM.skillult_takeEffectAt(basefunc, skill, location, source)
  local caster = skill.caster
  if skill.attack_counter == 1 then
    if skill.target then
      local position1 = skill.target.position[1] + caster.direction * 30
      if 799 < position1 or position1 < 1 then
        position1 = position1 - caster.direction * 30
      end
      caster:setPosition({
        position1,
        skill.target.position[2]
      })
    end
  else
    basefunc(skill, location, source)
  end
end

function ChessAM.init_hero(hero)
  local skillult = hero.skills.AM_ult
  if skillult then
    skillult.takeEffectAt = override(skillult.takeEffectAt, ChessAM.skillult_takeEffectAt)
  end
  return hero
end

return ChessAM.init_hero
