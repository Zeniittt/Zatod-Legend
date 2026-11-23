module("ed.battlehero", package.seeall)
local ed = ed
ChessTH = {}

function ChessTH.init_hero(hero)
  hero.chess_stars = hero.info["Chess Stars"]
  local skillult = hero.skills.TH_ult
  if skillult then
  end
  return hero
end

return ChessTH.init_hero
