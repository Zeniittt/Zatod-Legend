module("ed.battlehero", package.seeall)
local ed = ed
ChessQOP = {}
ChessQOP.ratio = 0.01

function ChessQOP.init_hero(hero)
  return hero
end

return ChessQOP.init_hero
