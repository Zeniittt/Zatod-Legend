module("ed.battlehero", package.seeall)
local ed = ed
Stone = {}

function Stone.skillatk_takeEffectAt(basefunc, skill, location, source)
  basefunc(skill, location, source)
  local caster = skill.caster
  caster.atk = true
  caster:die(source)
end

function Stone.skillatk2_onAttackFrame(basefunc, skill)
  if skill.caster.manually_casting then
    ed.engine:unfreeze()
    skill.caster.manually_casting = false
  end
  skill.attack_counter = skill.attack_counter + 1
  if skill.info["Target Type"] == "random" or skill.target == nil or not skill.target:isAlive() then
    skill:selectTarget(nil)
  end
  if not skill.target then
    return
  end
  local info = skill.info
  local caster = skill.caster
  local ttype = info["Track Type"]
  if ttype == "projectile" then
    local projectile = skill:createProjectile()
    ed.engine:addProjectile(projectile)
  elseif ttype == "chain" then
    local chain = skill:createChain()
    ed.engine:addChain(chain)
  elseif ttype == "region" then
    local region = skill:createRegion()
    table.insert(caster.stone_region, region)
    ed.engine:addRegion(region)
  elseif ttype == nil then
    skill:takeEffectAt(skill.target.position)
  else
    EDDebug("Unkonwn Track Type: '" .. ttype .. "'")
  end
  caster:setMP(caster.mp + info["Gain MP"] * ed.engine.mp_bonus)
  if info["Move Forward"] ~= 0 then
    caster.position[1] = caster.position[1] + info["Move Forward"] * caster.direction
  end
end

function Stone.hero_die(basefunc, hero, killer)
  for _, region in pairs(hero.stone_region) do
    region:finish()
  end
  if hero.father then
    local father = hero.father
    local bookskill = father.skills.Earth_warschool
    if bookskill then
      father:addBuff(bookskill:createBuff(father))
    end
  end
  basefunc(hero, killer)
end

function Stone.init_hero(hero)
  hero.stone_region = {}
  hero.die = override(hero.die, Stone.hero_die)
  local skillatk = hero.skills.Stone_atk
  if skillatk then
    skillatk.takeEffectAt = override(skillatk.takeEffectAt, Stone.skillatk_takeEffectAt)
  end
  local skillatk2 = hero.skills.Stone_atk2
  if skillatk2 then
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, Stone.skillatk2_onAttackFrame)
  end
  return hero
end

return Stone.init_hero
