module("ed.battlehero", package.seeall)
local ed = ed
SoloSven = {}

function SoloSven.skillatk_ult_takeEffectOn(basefunc, skill, target, source, shift)
  local isHit, dmg, bCrit = basefunc(skill, target, source, shift)
  local caster = skill.caster
  local skillpasv = caster.skills.Sven_pasv
  if bCrit and skillpasv then
    local bid = 100000013
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local Buff = ed.BuffCreate(binfo, caster, caster)
    caster:addBuff(Buff)
    caster:setHP(caster.hp + 10)
  end
  return isHit, dmg, bCrit
end

function SoloSven.skillult_power(basefunc, skill, source, target, damage_type)
  local power = basefunc(skill, source, target, damage_type)
  local caster = skill.caster
  local CasterHP = caster.attribs.HP
  local TargetHP = target.attribs.HP
  local HPPower = math.max(CasterHP - TargetHP, 0) * 0.1
  power = power + HPPower
  return power, 1
end

function SoloSven.init_hero(hero)
  local skillatk = hero.skills.Sven_atk
  local skillult = hero.skills.Sven_ult
  if skillatk then
    skillatk.takeEffectOn = override(skillatk.takeEffectOn, SoloSven.skillatk_ult_takeEffectOn)
  end
  if skillult then
    skillult.power = override(skillult.power, SoloSven.skillult_power)
    skillult.takeEffectOn = override(skillult.takeEffectOn, SoloSven.skillatk_ult_takeEffectOn)
  end
  return hero
end

return SoloSven.init_hero
