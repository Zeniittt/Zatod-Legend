module("ed.battlehero", package.seeall)
local ed = ed
ChessTitanPiggy = {}

function ChessTitanPiggy.skillult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.TitanPiggy_damage_time = 0
  buff.onDamaged = override(buff.onDamaged, ChessTitanPiggy.skillult_buff_onDamaged)
  return buff
end

function ChessTitanPiggy.skillult_buff_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred)
  local damage = basefunc(buff, damage, damage_type, source, skill, transferred)
  if buff.TitanPiggy_damage_time then
    buff.TitanPiggy_damage_time = buff.TitanPiggy_damage_time + 1
  else
    buff.TitanPiggy_damage_time = 1
  end
  local caster = buff.owner
  if caster then
    local skillultb = caster.skills.TitanPiggy_ultb
    local skillult = caster.skills.TitanPiggy_ult
    local damage_reduce = skillult.info["Script Arg2"]
    damage = damage * (1 - damage_reduce * 0.01)
    if skillultb and buff.TitanPiggy_damage_time >= 5 then
      buff.TitanPiggy_damage_time = 0
      skillultb.cd_remaining = 0.125
    end
  end
  return damage
end

function ChessTitanPiggy.hero_reset(basefunc, hero)
  basefunc(hero)
  local skillult = hero.skills.TitanPiggy_ult
  if skillult then
    skillult:takeEffectOn(hero, hero)
  end
end

function ChessTitanPiggy.init_hero(hero)
  hero.reset = override(hero.reset, ChessTitanPiggy.hero_reset)
  local skillult = hero.skills.TitanPiggy_ult
  if skillult then
    skillult.createBuff = override(skillult.createBuff, ChessTitanPiggy.skillult_createBuff)
  end
  return hero
end

return ChessTitanPiggy.init_hero
