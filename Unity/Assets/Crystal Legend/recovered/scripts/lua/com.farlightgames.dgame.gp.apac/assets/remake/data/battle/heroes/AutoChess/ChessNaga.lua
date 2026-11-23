module("ed.battlehero", package.seeall)
local ed = ed
ChessNaga = {}

function ChessNaga.skillult_buff_onDamaged(basefunc, buff, damage, damage_type)
  local owner = buff.owner
  local remaindamage = basefunc(buff, damage, damage_type)
  buff.timer = 0
  return remaindamage
end

function ChessNaga.skillult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  buff.onDamaged = override(buff.onDamaged, ChessNaga.skillult_buff_onDamaged)
  return buff
end

function ChessNaga.init_hero(hero)
  local skillult = hero.skills.Naga_ult
  if skillult then
    skillult.createBuff = override(skillult.createBuff, ChessNaga.skillult_createBuff)
  end
  return hero
end

return ChessNaga.init_hero
