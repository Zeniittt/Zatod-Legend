module("ed.battlehero", package.seeall)
local ed = ed
ChessTroll = {}
ChessTroll.chess_plus_ratio = {
  0.08,
  0.13,
  0.16
}
ChessTroll.chess_max_level = {
  5,
  8,
  10
}

function ChessTroll.skillatk_takeEffectOn(basefunc, skill, target, source, shift)
  local caster = skill.caster
  basefunc(skill, target, source, shift)
end

function ChessTroll.skillatk_power(basefunc, skill, source, target, damage_type)
  local power, coeff = basefunc(skill, source, target, damage_type)
  local caster = skill.caster
  local multi_ret = 1
  if not caster.Troll_last_enemy then
    caster.Troll_last_enemy = target
    caster.Troll_attack_time = 0
  elseif caster.Troll_last_enemy == target then
    caster.Troll_attack_time = math.min(ChessTroll.chess_max_level[caster.chess_stars], caster.Troll_attack_time + 1)
  elseif caster.Troll_last_enemy ~= target then
    caster.Troll_attack_time = 0
    caster.Troll_last_enemy = target
  end
  if caster.Troll_last_enemy then
    local x = 1 + ChessTroll.chess_plus_ratio[caster.chess_stars]
    local y = caster.Troll_attack_time
    multi_ret = math.pow(x, y)
  end
  power = power * multi_ret
  return power, coeff
end

function ChessTroll.init_hero(hero)
  hero.chess_stars = hero.info["Chess Stars"]
  local skillatk = hero.skills.Troll_atk
  local skillult = hero.skills.Troll_ult
  hero.Troll_attack_time = 0
  if skillult and hero.name == "Troll" then
    skillatk.takeEffectOn = override(skillatk.takeEffectOn, ChessTroll.skillatk_takeEffectOn)
    skillatk.power = override(skillatk.power, ChessTroll.skillatk_power)
  end
  return hero
end

return ChessTroll.init_hero
