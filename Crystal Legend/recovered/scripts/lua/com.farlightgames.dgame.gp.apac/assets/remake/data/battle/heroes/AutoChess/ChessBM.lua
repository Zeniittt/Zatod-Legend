module("ed.battlehero", package.seeall)
local ed = ed
ChessBM = {}
ChessBM.name = "BM"
ChessBM.skill3_h1 = 58
ChessBM.skill3_h2 = 75
ChessBM.chess_damage_ratio = {
  0.1,
  0.2,
  0.3
}

function ChessBM.skill3_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  if attack_counter == 0 then
    basefunc(skill)
  else
    attack_counter = attack_counter + 1
    skill.attack_counter = attack_counter
  end
end

function ChessBM.skill3_projectile_terminate(basefunc, projectile)
  local projectile2 = projectile.skill:createProjectile(projectile)
  projectile2.position = projectile.position
  local v = projectile2.velocity
  projectile2.velocity = {
    -v[1],
    0
  }
  projectile2.zSpeed = (ChessBM.skill3_h2 - projectile.height) / projectile.t0
  projectile2.max_distance = math.abs(projectile2.position[1] - projectile.skill.caster.position[1]) - 55
  ed.engine:addProjectile(projectile2)
  basefunc(projectile)
end

function ChessBM.skill3_projectile2_terminate(basefunc, projectile)
  local skill = projectile.skill
  local caster = skill.caster
  if caster.current_skill == skill and skill.attack_counter < 2 then
    skill:onAttackFrame()
    skill:gotoEventIdx(2)
  end
  basefunc(projectile)
end

function ChessBM.skill3_createProjectile(basefunc, skill, tile1)
  local caster = skill.caster
  local projectile = basefunc(skill)
  local target = skill.target
  if tile1 == nil then
    projectile.max_distance = math.max(10, math.abs(target.position[1] - skill.caster.position[1]))
    local t0 = projectile.max_distance / projectile.velocity[1]
    projectile.zSpeed = (ChessBM.skill3_h1 - projectile.height) / t0
    projectile.t0 = t0
    projectile.terminate = override(projectile.terminate, ChessBM.skill3_projectile_terminate)
  else
    projectile.height = ChessBM.skill3_h2
    projectile.terminate = override(projectile.terminate, ChessBM.skill3_projectile2_terminate)
  end
  return projectile
end

function ChessBM.skillult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.onDamaged = override(buff.onDamaged, ChessBM.ultbuff_onDamaged)
  return buff
end

function ChessBM.ultbuff_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred)
  local damage = basefunc(buff, damage, damage_type, source, skill, transferred)
  if source and buff.caster and source == buff.caster then
    damage = damage * (1 + ChessBM.chess_damage_ratio[source.chess_stars])
  end
  return damage
end

function ChessBM.init_hero(hero)
  hero.chess_stars = hero.info["Chess Stars"]
  local skillult = hero.skills[ChessBM.name .. "_ult"]
  if skillult then
    skillult.onAttackFrame = override(skillult.onAttackFrame, ChessBM.skill3_onAttackFrame)
    skillult.createProjectile = override(skillult.createProjectile, ChessBM.skill3_createProjectile)
    skillult.createBuff = override(skillult.createBuff, ChessBM.skillult_createBuff)
  end
  return hero
end

return ChessBM.init_hero
