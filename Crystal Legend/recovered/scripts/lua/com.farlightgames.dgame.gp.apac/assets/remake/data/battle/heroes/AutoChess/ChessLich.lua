module("ed.battlehero", package.seeall)
local ed = ed
ChessLich = {}
ChessLich.Lichatk3DebuffID = 395
ChessLich.LichSuperawakeDebuffID = 547
ChessLich.chess_LichSuperJumpTimes = {
  6,
  9,
  12
}

function ChessLich.skillult_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  local caster = skill.caster
  projectile:enableJump(ChessLich.chess_LichSuperJumpTimes[caster.chess_stars])
  projectile:enableTrack(skill.target)
  
  function projectile:findNextTaeget()
    local min = math.huge
    local ret
    for unit in ed.engine:foreachAliveUnit(self.skill:targetCamp()) do
      if unit == self.source then
      elseif unit.buff_effects.untargetable then
      elseif unit.buffManager.invisible and unit.camp ~= caster.camp then
      else
        local distanceSQ = ed.edpDistanceSQ(unit.position, self.source.position)
        if min < distanceSQ then
        elseif distanceSQ > self.skill.min_range_sq and distanceSQ < self.skill.max_range_sq then
          ret = unit
          min = distanceSQ
        end
      end
    end
    return ret
  end
  
  return projectile
end

function ChessLich.init_hero(hero)
  hero.chess_stars = hero.info["Chess Stars"]
  local skillult = hero.skills.Lich_ult
  if skillult then
    skillult.createProjectile = override(skillult.createProjectile, ChessLich.skillult_createProjectile)
  end
  return hero
end

return ChessLich.init_hero
