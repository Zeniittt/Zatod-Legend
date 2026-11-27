module("ed.battlehero", package.seeall)
local ed = ed
ChessNEC = {}

function ChessNEC.skillult_createProjectile(basefunc, skill)
  local shape = "circle"
  local arg1 = 220
  local arg2 = 0
  local caster = skill.caster
  skill:takeEffectOn(caster)
  for unit in ed.engine:foreachAliveUnit(skill:affectedCamp()) do
    local p2 = ed.edpSub(unit.position, caster.position)
    if not unit.buff_effects.untargetable and not unit.buff_effects.invulnerable and unit ~= caster and ed.Skill.testPointInShape(p2, shape, arg1, arg2) then
      local projectile = basefunc(skill)
      projectile:enableTrack(unit)
      ed.engine:addProjectile(projectile)
    end
  end
  return nil
end

function ChessNEC.skillult_takeEffectOn(basefunc, skill, target)
  local caster = skill.caster
  if caster.camp == target.camp then
    skill.info["Damage Type"] = "Heal"
    skill.info["Impact Effect"] = "eff_impact_heal.cha"
  else
    skill.info["Damage Type"] = "AP"
    skill.info["Impact Effect"] = "eff_impact_slash.cha"
  end
  basefunc(skill, target)
end

function ChessNEC.skillult_start(basefunc, skill)
  skill.NEC_ult_effect = nil
  basefunc(skill)
end

function ChessNEC.init_hero(hero)
  local skillult = hero.skills.NEC_ult
  if skillult then
    skillult.takeEffectOn = override(skillult.takeEffectOn, ChessNEC.skillult_takeEffectOn)
    skillult.createProjectile = override(skillult.createProjectile, ChessNEC.skillult_createProjectile)
  end
  return hero
end

return ChessNEC.init_hero
