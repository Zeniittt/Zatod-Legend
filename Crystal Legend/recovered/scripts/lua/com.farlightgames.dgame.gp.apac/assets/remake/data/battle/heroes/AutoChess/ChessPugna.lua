module("ed.battlehero", package.seeall)
local ed = ed
ChessPugna = {}

function ChessPugna.skillult_power(basefunc, self, source, target, damage_type)
  local power, i = basefunc(self, source, target, damage_type)
  local caster = self.caster
  return power, i
end

function ChessPugna.init_hero(hero)
  local skillult = hero.skills.Pugna_ult
  if skillult then
    skillult.power = override(skillult.power, ChessPugna.skillult_power)
  end
  return hero
end

return ChessPugna.init_hero
