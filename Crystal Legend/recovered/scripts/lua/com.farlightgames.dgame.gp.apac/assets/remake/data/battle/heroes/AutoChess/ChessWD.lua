module("ed.battlehero", package.seeall)
local ed = ed
ChessWD = {}
ChessWD.chess_jump_times = {
  5,
  7,
  9
}

function ChessWD.skill_ult_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  projectile:enableJump(ChessWD.chess_jump_times[skill.caster.chess_stars])
  projectile:enableTrack(skill.target)
  return projectile
end

function ChessWD.init_hero(hero)
  hero.chess_stars = hero.info["Chess Stars"]
  local skill_ult = hero.skills.WD_ult
  if skill_ult then
    skill_ult.createProjectile = override(skill_ult.createProjectile, ChessWD.skill_ult_createProjectile)
  end
  return hero
end

return ChessWD.init_hero
