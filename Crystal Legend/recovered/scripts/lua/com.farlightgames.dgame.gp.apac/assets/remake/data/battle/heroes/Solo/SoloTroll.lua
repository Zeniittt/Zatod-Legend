module("ed.battlehero", package.seeall)
local ed = ed
SoloTroll = {}
SoloTroll._plus_ratio = {
  0.15,
  0.2,
  0.25
}
SoloTroll._max_level = {
  6,
  9,
  12
}
SoloTroll.max_attack_stack = 35

function SoloTroll.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local bid = 100000011
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local TrolSelfBuff = ed.BuffCreate(binfo, caster, caster)
  caster:addBuff(TrolSelfBuff)
end

function SoloTroll.skillatk_takeEffectOn(basefunc, skill, target, source, shift)
  local caster = skill.caster
  if caster.SoloTroll_last_enemy ~= target then
    caster.SoloTroll_attack_time = 0
  end
  local out, dmg, Crit, lfs_amount = basefunc(skill, target, source, shift)
  if out then
    if not caster.SoloTroll_last_enemy then
      caster.SoloTroll_last_enemy = target
    elseif caster.SoloTroll_last_enemy == target then
      caster.SoloTroll_attack_time = math.min(SoloTroll.max_attack_stack, caster.SoloTroll_attack_time + 1)
    else
      caster.SoloTroll_attack_time = 1
      caster.SoloTroll_last_enemy = target
    end
  end
  return out, dmg, Crit, lfs_amount
end

function SoloTroll.skillatk_power(basefunc, skill, source, target, damage_type)
  local power, coeff = basefunc(skill, source, target, damage_type)
  local caster = skill.caster
  local multi_ret = 1
  if caster.SoloTroll_last_enemy then
    local x = 1.02
    local y = caster.SoloTroll_attack_time
    multi_ret = x ^ y
  end
  power = power * multi_ret
  return power, coeff
end

function SoloTroll.hero_true_init(hero)
  local skillatk = hero.skills.Troll_atk
  local skillult = hero.skills.Troll_ult
  hero.SoloTroll_attack_time = 0
  if skillatk then
    skillatk.takeEffectOn = override(skillatk.takeEffectOn, SoloTroll.skillatk_takeEffectOn)
    skillatk.power = override(skillatk.power, SoloTroll.skillatk_power)
  end
  if skillult then
    skillult.start = override(skillult.start, SoloTroll.skillult_start)
  end
  return hero
end

function SoloTroll.init_hero(hero)
  SoloTroll.hero_true_init(hero)
  return hero
end

return SoloTroll.init_hero
