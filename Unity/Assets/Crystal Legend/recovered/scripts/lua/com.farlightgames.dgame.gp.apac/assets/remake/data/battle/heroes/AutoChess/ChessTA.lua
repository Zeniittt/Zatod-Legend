module("ed.battlehero", package.seeall)
local ed = ed
ChessTA = {}
ChessTA.chess_damage_time = {
  4,
  6,
  8
}

function ChessTA.skillult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.TA_damage_time = ChessTA.chess_damage_time[skill.caster.chess_stars]
  buff.onDamaged = override(buff.onDamaged, ChessTA.buff_onDamaged)
  return buff
end

function ChessTA.buff_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred)
  local damage = basefunc(buff, damage, damage_type, source, skill, transferred)
  local caster = buff.owner
  if buff.TA_damage_time and buff.TA_damage_time > 0 then
    buff.TA_damage_time = buff.TA_damage_time - 1
    damage = 0
    local color = caster.camp == ed.emCampEnemy and "red" or "blue"
    if caster.actor then
      ed.PopupCreate("dodge", color, caster.actor, nil, "text")
    end
  else
    buff.timer = 0
  end
  return damage
end

function ChessTA.init_hero(hero)
  hero.chess_stars = hero.info["Chess Stars"]
  local skillult = hero.skills.TA_ult
  if skillult then
    skillult.createBuff = override(skillult.createBuff, ChessTA.skillult_createBuff)
  end
  return hero
end

return ChessTA.init_hero
