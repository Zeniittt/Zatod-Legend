module("ed.battlehero", package.seeall)
local ed = ed
AwakeBossViper = {}
AwakeBossViper.pasvEvobuff = 10035903

function AwakeBossViper.skillult_createProjectile(basefunc, skill)
  local shape = "circle"
  local arg1 = 800
  local arg2 = 0
  local caster = skill.caster
  for unit in ed.engine:foreachAliveUnit(skill:targetCamp()) do
    local p2 = ed.edpSub(unit.position, caster.position)
    if not unit.buff_effects.untargetable and not unit.buff_effects.invulnerable and ed.Skill.testPointInShape(p2, shape, arg1, arg2) then
      local projectile = basefunc(skill)
      projectile:enableTrack(unit)
      ed.engine:addProjectile(projectile)
    end
  end
end

function AwakeBossViper.skillatk_takeEffectOn(basefunc, skill, target)
  local caster = skill.caster
  local skillpasv2 = caster.skills.AwakeBossViper_pasv2
  if skillpasv2 then
    local HPloss = 1 - target.hp / target.attribs.HP
    local LowPower = skillpasv2.info["Basic Num"]
    local Powermax = skillpasv2.info["Script Arg2"]
    local Power = HPloss * Powermax
    if LowPower > Power then
      Power = LowPower
    end
    skill.info["Basic Num"] = Power
    basefunc(skill, target)
  end
  if not skillpasv2 then
    basefunc(skill, target)
  end
end

function AwakeBossViper.skillatk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local buffInfo = buff.info
  local owner = buff.owner
  local caster = buff.caster
  local casterap = caster.attribs.AP
  local hpr = buff.info.HPR
  return buff
end

function AwakeBossViper.hero_takeDamage(basefunc, self, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
  local lost = basefunc(self, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
  local dt = damage_type or struct_table.damage_type
  local s = source or struct_table.source
  if lost and dt == "AD" and 0 < lost and s and s:isAlive() then
    local bid = AwakeBossViper.pasvEvobuff
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, s, self)
    s:addBuff(buff, self)
  end
  return lost
end

function AwakeBossViper.init_hero(hero)
  local skillult = hero.skills.AwakeBossViper_ult
  local skillatk = hero.skills.AwakeBossViper_atk
  local skillatk2 = hero.skills.AwakeBossViper_atk2
  local skillpasv = hero.passive_skill_list[1]
  local skillpasv2 = hero.skills.AwakeBossViper_pasv2
  if skillult then
    skillult.createProjectile = override(skillult.createProjectile, AwakeBossViper.skillult_createProjectile)
  end
  if skillatk2 then
    skillatk2.createBuff = override(skillatk2.createBuff, AwakeBossViper.skillatk2_createBuff)
  end
  if skillpasv then
    hero.takeDamage = override(hero.takeDamage, AwakeBossViper.hero_takeDamage)
  end
  if skillatk then
    skillatk.takeEffectOn = override(skillatk.takeEffectOn, AwakeBossViper.skillatk_takeEffectOn)
  end
  return hero
end

return AwakeBossViper.init_hero
