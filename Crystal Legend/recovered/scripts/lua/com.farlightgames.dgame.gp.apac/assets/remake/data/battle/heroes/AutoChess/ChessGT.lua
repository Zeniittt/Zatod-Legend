module("ed.battlehero", package.seeall)
local ed = ed
ChessGT = {}
ChessGT.mineRange = 80
ChessGT.hookRange = 80
ChessGT.mineLastTime = 15
ChessGT.mineStartTime = 0.5
ChessGT.damageMine = "damageMine"
ChessGT.stunMine = "stunMine"
ChessGT.noDamageBox = "noDamageBox"
ChessGT.interval = {
  {100, 20},
  {100, 5},
  {100, -15},
  {160, 20},
  {160, 5},
  {160, -15},
  {240, 20},
  {240, 5},
  {240, -15}
}

function ChessGT.skillatk5_takeEffectAt(basefunc, skill, location, source)
  local caster = skill.caster
  if not source or source.mineType == ChessGT.noDamageBox then
  elseif source.mineType == ChessGT.damageMine then
    local originfo = skill.info
    skill.info = ed.wraptable(originfo, {
      ["Buff ID"] = 0,
      ["Damage Type"] = "AP"
    })
    basefunc(skill, location, source)
    skill.info = originfo
    if ed.run_with_scene then
      local effect_name = "eff_point_burst.cha"
      local effect_z = 1
      ed.scene:playEffectOnScene(effect_name, location, {
        caster.direction * 0.8,
        0.8
      }, nil, effect_z)
    end
  elseif source.mineType == ChessGT.stunMine then
    basefunc(skill, location, source)
  end
end

function ChessGT.skillatk3_projectile_update(basefunc, projectile, dt)
  basefunc(projectile, dt)
  local caster = projectile.skill.caster
  if not projectile.totalTime then
    projectile.totalTime = dt
  else
    projectile.totalTime = projectile.totalTime + dt
  end
  if projectile.height < 20 then
    if ed.run_with_scene then
      ed.scene:playEffectOnScene("eff_point_GT_atk4.cha", {
        projectile.position[1],
        projectile.position[2] - 1
      }, {
        projectile.direction,
        1
      }, nil, 0)
    end
    projectile:terminate()
    local skill = caster.skills.GT_ultb
    if skill then
      local originfo = skill.info
      local pic = "eff_tile_GT_atk4_3.cha"
      skill.info = ed.wraptable(originfo, {
        ["Tile Art"] = pic
      })
      skill:selectTarget()
      local projectile2 = ed.ProjectileCreate(skill)
      projectile2.mineType = ChessGT.damageMine
      projectile2.height = 1
      projectile2.position = {
        projectile.position[1],
        projectile.position[2] - 20
      }
      projectile2.update = override(projectile2.update, ChessGT.atk2_mine_update)
      ed.engine:addProjectile(projectile2)
      skill.info = originfo
    end
  end
end

function ChessGT.atk2_mine_update(basefunc, projectile, dt)
  basefunc(projectile, dt)
  local skill = projectile.skill
  local mineRange = ChessGT.mineRange
  if projectile.mineType and projectile.mineType ~= ChessGT.noDamageBox then
    mineRange = ChessGT.hookRange
  end
  if not projectile.totalTime then
    projectile.totalTime = dt
  else
    projectile.totalTime = projectile.totalTime + dt
  end
  if projectile.totalTime > ChessGT.mineLastTime then
    skill:takeEffectAt(projectile.position, projectile)
    projectile:terminate()
  elseif projectile.totalTime > ChessGT.mineStartTime then
    for unit in ed.engine:foreachAliveUnit(skill:affectedCamp()) do
      if not unit.buff_effects.untargetable and not unit.buffManager.invisiblethen then
        local p = ed.edpSub(unit.position, projectile.position)
        if p[1] * p[1] + p[2] * p[2] <= mineRange * mineRange then
          skill:takeEffectAt(projectile.position, projectile)
          projectile:terminate()
          break
        end
      end
    end
  end
end

function ChessGT.skillatk3_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  local caster = skill.caster
  projectile.update = override(projectile.update, ChessGT.skillatk3_projectile_update)
  projectile.mineType = ChessGT.noDamageBox
  local h = projectile.height
  local v = projectile.zSpeed
  local a = skill.info["Tile Gravity"]
  local A = 0.5 * a
  local B = v
  local C = h
  local delta = B ^ 2 - 4 * A * C
  local t = (-B - delta ^ 0.5) / (2 * A)
  local ran = math.floor(ed.rand() * 9) + 1
  local target_position = {
    ChessGT.interval[ran][1] * caster.direction + caster.position[1],
    ChessGT.interval[ran][2]
  }
  if skill.target then
    target_position = {
      skill.target.position[1],
      skill.target.position[2]
    }
  end
  local distance = ed.edpSub(target_position, projectile.position)
  projectile.velocity = ed.edpMult(distance, 1 / t)
  return projectile
end

function ChessGT.skillatk_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  local h = projectile.height
  local v = projectile.zSpeed
  local a = skill.info["Tile Gravity"]
  local A = 0.5 * a
  local B = v
  local C = h
  local delta = B ^ 2 - 4 * A * C
  local t = (-B - delta ^ 0.5) / (2 * A)
  local target_position = skill.target.position
  local caster_position, height = skill:launchPoint()
  local distance = ed.edpSub(target_position, caster_position)
  projectile.velocity = ed.edpMult(distance, 1 / t)
  return projectile
end

function ChessGT.init_hero(hero)
  hero:setActionStageChangeByManual(true)
  local skillatk = hero.skills.GT_atk
  if skillatk then
    skillatk.createProjectile = override(skillatk.createProjectile, ChessGT.skillatk_createProjectile)
  end
  local skillult = hero.skills.GT_ult
  if skillult then
    skillult.createProjectile = override(skillult.createProjectile, ChessGT.skillatk3_createProjectile)
  end
  local skillultb = hero.skills.GT_ultb
  if skillultb then
    skillultb.takeEffectAt = override(skillultb.takeEffectAt, ChessGT.skillatk5_takeEffectAt)
  end
  return hero
end

return ChessGT.init_hero
