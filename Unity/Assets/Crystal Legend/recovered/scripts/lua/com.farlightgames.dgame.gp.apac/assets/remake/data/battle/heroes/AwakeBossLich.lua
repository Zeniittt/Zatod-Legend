module("ed.battlehero", package.seeall)
local ed = ed
AwakeBossLich = {}
AwakeBossLich.atk3Evobuff = 10037203
AwakeBossLich.ultFrozenbuff = 10037205

function AwakeBossLich.projectile_hit(basefunc, tile, target)
  local skillult = tile.skill
  if skillult then
    local origin_info = skillult.info
    local caster = tile.caster
    local jumpSum = 5 - tile.jumps
    local addNumtime = skillult.evo_rank3["Script Arg1"] + skillult.evo_rank3["Script Arg2"] * caster.attribs.AP
    local addNum = addNumtime * jumpSum
    local basicNum = skillult.info["Basic Num"]
    skillult.info = ed.wraptable(skillult.info, {
      ["Basic Num"] = basicNum + addNum
    })
    basefunc(tile, target)
    skillult.info = origin_info
  end
end

function AwakeBossLich.skillult_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  projectile:enableJump(5)
  if skill.evo_rank and skill.evo_rank >= 3 then
    projectile.hit = override(projectile.hit, AwakeBossLich.projectile_hit)
  end
  projectile:enableTrack(skill.target)
  
  function projectile:findNextTaeget()
    local min = math.huge
    local ret
    for unit in ed.engine:foreachAliveUnit(self.skill:targetCamp()) do
      if unit == self.source then
      elseif unit.buff_effects.untargetable then
      elseif unit.buffManager.invisible and unit.camp ~= skill.caster.camp then
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

function AwakeBossLich.skillult_takeEffectOn(basefunc, skill, target, source, shift)
  local isHit, dmg = basefunc(skill, target, source, shift)
  local caster = skill.caster
  local rand = ed.rand()
  if isHit and 0.5 <= rand then
    local bid1 = AwakeBossLich.ultFrozenbuff
    local binfo1 = ed.lookupDataTable("Buff", nil, bid1)
    local buff1 = ed.BuffCreate(binfo1, target, caster)
    target:addBuff(buff1, caster)
  end
  return isHit, dmg
end

function AwakeBossLich.atk3buff_onDamaged(basefunc, buff, damage, damage_type, source)
  local buffDamage = basefunc(buff, damage, damage_type, source)
  local buffowner = buff.owner
  if buffDamage and source then
    local atk3debuff = ed.lookupDataTable("Buff", nil, AwakeBossLich.atk3Evobuff)
    source:addBuff(atk3debuff, buffowner)
  end
  return buffDamage
end

function AwakeBossLich.skillatk3_createBuff(basefunc, skill, target)
  local atk3buff = basefunc(skill, target)
  atk3buff.onDamaged = override(atk3buff.onDamaged, AwakeBossLich.atk3buff_onDamaged)
  return atk3buff
end

function AwakeBossLich.init_hero(hero)
  local skillult = hero.skills.AwakeBossLich_ult
  local skillatk2 = hero.skills.AwakeBossLich_atk2
  local skillatk3 = hero.skills.AwakeBossLich_atk3
  local skillemaura = hero.effect_enemy_aura_skill_list[1]
  if skillult then
    skillult.takeEffectOn = override(skillult.takeEffectOn, AwakeBossLich.skillult_takeEffectOn)
    skillult.createProjectile = override(skillult.createProjectile, AwakeBossLich.skillult_createProjectile)
  end
  if skillatk3 then
    skillatk3.createBuff = override(skillatk3.createBuff, AwakeBossLich.skillatk3_createBuff)
  end
  return hero
end

return AwakeBossLich.init_hero
