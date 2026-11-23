module("ed.battlehero", package.seeall)
local ed = ed
ChessBatman = {}
ChessBatman.ult_buffID = 6024

function ChessBatman.skillult_onAttackFrame(basefunc, skill)
  basefunc(skill)
  if skill.target and ed.run_with_scene then
    local gap = 0
    if skill.caster.position[2] < -20 then
      gap = 10
    else
      gap = -10
    end
    local position = {
      skill.caster.position[1] + skill.caster.direction * 240,
      skill.caster.position[2] + gap
    }
    local effect_name = "eff_point_Batman_atk3"
    local effect = ed.scene:playEffectOnScene(effect_name, position, {
      skill.caster.direction,
      1
    }, nil, 0)
    local effect_name2 = "eff_point_Batman_atk3b"
    local effect = ed.scene:playEffectOnScene(effect_name2, position, {
      skill.caster.direction,
      1
    }, nil, -1)
  end
end

function ChessBatman.skillatk_getDamage(basefunc, skill, target, power, damage_type, field, source, crit_mod)
  if target and target:isAlive() then
    for i, buff in ipairs(target.buff_list) do
      if buff.info.ID == ChessBatman.ult_buffID and buff.timer > 0 then
        power = power + skill.info["Script Arg2"]
      end
    end
  end
  local dmg, Crit = basefunc(skill, target, power, damage_type, field, source, crit_mod)
  return dmg, Crit
end

function ChessBatman.init_hero(hero)
  local skillult = hero.skills.Batman_ult
  local skillatk = hero.skills.Batman_atk
  if skillult then
    skillult.onAttackFrame = override(skillult.onAttackFrame, ChessBatman.skillult_onAttackFrame)
    skillatk.getDamage = override(skillatk.getDamage, ChessBatman.skillatk_getDamage)
  end
  return hero
end

return ChessBatman.init_hero
