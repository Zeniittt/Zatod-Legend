module("ed.battlehero", package.seeall)
local ed = ed
TPflower = {}

function TPflower.skillatk_start(basefunc, skill, target)
  local caster = skill.caster
  local bid = 56
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
  basefunc(skill, target)
end

function TPflower.skillatk_createProjectile(basefunc, skill)
  local caster = skill.caster
  local summoner = caster.config.summoner
  local skill_Fashion = caster.skills.TPflower_atk_fashion
  local nearestUnit
  local nearestDistance = math.huge
  for unit in ed.engine:foreachAliveUnit(skill.caster.camp) do
    if not unit.buff_effects.untargetable and unit.info["Unit Type"] == "Hero" and unit ~= caster.father then
      local d = ed.edpDistanceSQ(unit.position, skill.caster.position)
      if nearestDistance > d and unit ~= skill.caster then
        nearestUnit = unit
        nearestDistance = d
      end
    end
  end
  for i = 1, 2 do
    if skill_Fashion and (summoner.fashion_id == 601 or summoner.fashion_id == 602) then
      skill_Fashion.target = summoner
      local projectile_Fashion = skill_Fashion:createProjectile()
      if i == 1 then
        caster.target = projectile_Fashion.skill.target
      elseif i == 2 and ed.protoSuperAwake(caster.father.proto, 60) then
        caster.target = nearestUnit
      end
      if not caster.target then
        return
      end
      projectile_Fashion:enableTrack(caster.target)
      if ed.protoSuperAwake(caster.father.proto, 60) then
        ed.engine:addProjectile(projectile_Fashion)
      else
        return projectile_Fashion
      end
    else
      local projectile = basefunc(skill)
      if i == 1 then
        caster.target = projectile.skill.target
      elseif i == 2 and ed.protoSuperAwake(caster.father.proto, 60) then
        caster.target = nearestUnit
      end
      if not caster.target then
        return
      end
      projectile:enableTrack(caster.target)
      if ed.protoSuperAwake(caster.father.proto, 60) then
        ed.engine:addProjectile(projectile)
      else
        return projectile
      end
    end
  end
  return nil
end

function TPflower.skillatk_takeEffectAt(basefunc, skill, location, source)
  basefunc(skill, location, source)
  local caster = skill.caster
  caster:die(source)
end

function TPflower.skillatk_selectTarget(basefunc, self, default)
  self.target = self.caster.father
  return self.target
end

function TPflower.init_hero(hero)
  local skill_atk = hero.skills.TPflower_atk
  local skill_Fashion = hero.skills.TPflower_atk_fashion
  local summoner = hero.config.summoner
  if skill_atk then
    skill_atk.selectTarget = override(skill_atk.selectTarget, TPflower.skillatk_selectTarget)
    if skill_Fashion and (summoner.fashion_id == 601 or summoner.fashion_id == 602) then
      skill_Fashion.selectTarget = override(skill_Fashion.selectTarget, TPflower.skillatk_selectTarget)
    end
    skill_atk.createProjectile = override(skill_atk.createProjectile, TPflower.skillatk_createProjectile)
  end
  return hero
end

return TPflower.init_hero
