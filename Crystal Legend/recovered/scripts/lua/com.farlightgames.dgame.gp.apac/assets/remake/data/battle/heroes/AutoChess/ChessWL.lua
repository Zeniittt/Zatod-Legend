module("ed.battlehero", package.seeall)
local ed = ed
ChessWL = {}
ChessWL.infernalAttribs = 7006

function ChessWL.skillult_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  local v = 900
  local caster = skill.caster
  local target = projectile.skill.target
  if not target then
    return
  end
  projectile:enableTrack(target)
  projectile.height = 300
  projectile.position = {
    caster.position[1],
    caster.position[2]
  }
  local targetposx = target.position[1] - 60 * caster.direction
  if 800 <= targetposx then
    targetposx = 750
  elseif targetposx <= 0 then
    targetposx = 50
  end
  skill.targetpos = {
    targetposx,
    target.position[2]
  }
  local targetxyV = ed.edpSub(skill.targetpos, projectile.position)
  local targetzV = -projectile.height
  local u = (targetxyV[1] * targetxyV[1] + targetxyV[2] * targetxyV[2] + targetzV * targetzV) ^ (-0.5)
  local targetV = {
    u * targetxyV[1],
    u * targetxyV[2],
    u * targetzV
  }
  projectile.velocity[1] = targetV[1] * v
  projectile.velocity[2] = targetV[2] * v
  projectile.zSpeed = targetV[3] * v
  return projectile
end

function ChessWL.skillult_takeEffectAt(basefunc, skill, location, source)
  local caster = skill.caster
  local infernal = caster.infernal
  if infernal and infernal:isAlive() then
    infernal:die()
  end
  if caster and caster:isAlive() then
    local proto = {
      _tid = 50300 + caster.chess_stars,
      _level = skill.level or 1,
      _stars = caster.chess_stars
    }
    local config = {
      is_monster = true,
      estimate_rank = true,
      hp_mod = 1,
      summoner = caster
    }
    local infernal = ed.ChessUnitCreate(proto, caster.camp, config)
    infernal.direction = caster.direction
    ed.engine:summonUnit(infernal, skill.targetpos, caster)
    caster.infernal = infernal
  end
  basefunc(skill, location, source)
end

function ChessWL.hero_die(basefunc, hero, killer)
  if hero.infernal and hero.infernal:isAlive() then
    hero.infernal:die()
  end
  basefunc(hero, killer)
end

function ChessWL.init_hero(hero)
  local skillult = hero.skills.WL_ult
  hero.chess_stars = hero.info["Chess Stars"]
  hero.die = override(hero.die, ChessWL.hero_die)
  if skillult then
    skillult.createProjectile = override(skillult.createProjectile, ChessWL.skillult_createProjectile)
    skillult.takeEffectAt = override(skillult.takeEffectAt, ChessWL.skillult_takeEffectAt)
  end
  ed.PreloadPuppetRcs("Infernal")
  return hero
end

return ChessWL.init_hero
