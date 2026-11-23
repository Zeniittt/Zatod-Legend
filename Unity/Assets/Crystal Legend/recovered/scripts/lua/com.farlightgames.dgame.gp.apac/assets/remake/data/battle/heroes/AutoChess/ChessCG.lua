module("ed.battlehero", package.seeall)
local ed = ed
ChessCG = {}
ChessCG.ult_buffID = 6020
ChessCG.offset_list = {
  {0, 0},
  {-19, 5},
  {5, -14},
  {-36, 28},
  {39, -50}
}

function ChessCG.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local binfo = ed.lookupDataTable("Buff", nil, ChessCG.ult_buffID)
  local ultbuff = ed.BuffCreate(binfo, caster, caster)
  ultbuff.update = override(ultbuff.update, ChessCG.ultbuff_update)
  ultbuff.CG_buff_couter = 0
  caster:addBuff(ultbuff, caster)
end

function ChessCG.ultbuff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local caster = buff.owner
  local skillultb = caster.skills.CG_ultb
  buff.CG_buff_couter = buff.CG_buff_couter + dt
  if buff.CG_buff_couter > 0.7 then
    buff.CG_buff_couter = 0
    local target = skillultb:selectTarget()
    skillultb:createProjectile()
  end
end

function ChessCG.skillultb_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  local h = projectile.height
  local v = projectile.zSpeed
  local a = skill.info["Tile Gravity"]
  local A = 0.5 * a
  local B = v
  local C = h
  local delta = B ^ 2 - 4 * A * C
  local t = (-B - delta ^ 0.5) / (2 * A)
  local target = skill.target
  if not skill.target then
    for unit in ed.engine:foreachAliveUnit(skill:affectedCamp()) do
      target = unit
    end
  end
  if not target then
    return nil
  end
  local distance = ed.edpSub(target.position, skill.caster.position)
  projectile.velocity = ed.edpMult(distance, 1 / t)
  ed.engine:addProjectile(projectile)
  return nil
end

function ChessCG.init_hero(hero)
  local skillult = hero.skills.CG_ult
  local skillultb = hero.skills.CG_ultb
  if skillult then
    skillult.start = override(skillult.start, ChessCG.skillult_start)
    skillultb.createProjectile = override(skillultb.createProjectile, ChessCG.skillultb_createProjectile)
  end
  return hero
end

return ChessCG.init_hero
