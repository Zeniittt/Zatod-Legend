module("ed.battlehero", package.seeall)
local ed = ed
ChessAV = {}

function ChessAV.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local position = {
    caster.position[1],
    caster.position[2]
  }
  if skill.target then
    position = {
      skill.target.position[1],
      skill.target.position[2]
    }
  end
  skill.caster.origin_AV = {
    position[1],
    position[2]
  }
  skill:selectTarget(target)
  if ed.run_with_scene then
    local effect_name = "eff_launch_AV_ult.cha"
    if not effect_name then
      return
    end
    ed.scene:playEffectOnScene(effect_name, skill.caster.origin_AV, nil, nil, -1)
  end
end

function ChessAV.skillult_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  projectile.height = 300
  projectile.position = skill.caster.origin_AV
  return projectile
end

function ChessAV.skillult_willCast(basefunc, skill)
  local flag = true
  return basefunc(skill) and flag
end

function ChessAV.init_hero(hero)
  local skillult = hero.skills.AV_ult
  if skillult then
    hero:preloadEffect("eff_launch_AV_ult.cha")
    skillult.start = override(skillult.start, ChessAV.skillult_start)
    skillult.createProjectile = override(skillult.createProjectile, ChessAV.skillult_createProjectile)
    skillult.willCast = override(skillult.willCast, ChessAV.skillult_willCast)
  end
  return hero
end

return ChessAV.init_hero
