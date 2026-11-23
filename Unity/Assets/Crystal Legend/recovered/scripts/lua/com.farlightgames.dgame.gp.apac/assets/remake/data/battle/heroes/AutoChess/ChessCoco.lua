module("ed.battlehero", package.seeall)
local ed = ed
ChessCoco = {}

function ChessCoco.launchPoint(basefunc, skill)
  local position, height = basefunc(skill)
  local direction = skill.caster.direction
  position[1] = position[1] - 400 * direction
  if position[1] < 0 or position[1] > 800 then
    position[1] = 400 - 400 * direction
  end
  position[2] = 0
  height = 10
  return position, height
end

function ChessCoco.init_hero(hero)
  local skillult = hero.skills.Coco_ult
  if skillult then
    skillult.launchPoint = override(skillult.launchPoint, ChessCoco.launchPoint)
  end
  return hero
end

return ChessCoco.init_hero
