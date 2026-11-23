module("ed.battlehero", package.seeall)
local ed = ed
ChessMor = {}
ChessMor.mp_damage = {
  80,
  120,
  160
}

function ChessMor.skillult_start(basefunc, skill, target)
  local hero = skill.caster
  local bid = 390
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  hero:addBuff(binfo, hero)
  basefunc(skill, target)
end

function ChessMor.skillult_finish(basefunc, skill)
  basefunc(skill)
  for i, buff in ipairs(skill.caster.buff_list) do
    if buff.info.ID == 390 then
      buff.owner:removeBuff(buff)
    end
  end
end

function ChessMor.skillult_takeEffectOn(basefunc, skill, target, source, shift)
  local ret, dmg, Crit, lfs_amount = basefunc(skill, target, source, shift)
  if target and target:isAlive() then
    target:takeDamage(ChessMor.mp_damage[skill.caster.chess_stars], "Holy", "mp", skill.caster)
  end
  return ret, dmg, Crit, lfs_amount
end

function ChessMor.init_hero(hero)
  hero.chess_stars = hero.info["Chess Stars"]
  local skillult = hero.skills.Mor_ult
  if skillult then
    skillult.start = override(skillult.start, ChessMor.skillult_start)
    skillult.finish = override(skillult.finish, ChessMor.skillult_finish)
    skillult.takeEffectOn = override(skillult.takeEffectOn, ChessMor.skillult_takeEffectOn)
  end
  return hero
end

return ChessMor.init_hero
