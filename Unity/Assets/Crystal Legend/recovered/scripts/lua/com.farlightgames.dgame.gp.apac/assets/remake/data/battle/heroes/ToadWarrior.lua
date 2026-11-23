module("ed.ToadWarrior", package.seeall)
local ed = ed
ToadWarrior = {}

function ToadWarrior.skillatk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = buff.caster
  buff.onRemoved = override(buff.onRemoved, ToadWarrior.skillatk2_buffOnRemoved)
  caster.atk2buff = true
  return buff
end

function ToadWarrior.skillatk2_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  if skill.attack_counter == 0 then
    basefunc(skill)
  elseif skill.attack_counter == 1 then
    for i, buff in ipairs(caster.buff_list) do
      if buff.info.ID == 10036201 then
        buff.timer = 0
      end
    end
    skill.attack_counter = skill.attack_counter + 1
  end
end

function ToadWarrior.skillatk2_buffOnRemoved(basefunc, buff)
  local caster = buff.caster
  caster.atk2buff = nil
  basefunc(buff)
end

function ToadWarrior.getLostHPAfterImmunity(basefunc, hero, damage, immunity, damage_type, source)
  local lost = basefunc(hero, damage, immunity, damage_type, source)
  if hero.atk2buff and lost and 0 < lost and source and 0 > hero.direction * (hero.position[1] - source.position[1]) then
    local resist_value = 0.7
    local parry = lost * resist_value
    lost = lost - parry
  end
  return lost
end

function ToadWarrior.init_hero(hero)
  local skillatk2 = hero.skills.ToadWarrior_atk2
  if skillatk2 then
    skillatk2.createBuff = override(skillatk2.createBuff, ToadWarrior.skillatk2_createBuff)
    hero.getLostHPAfterImmunity = override(hero.getLostHPAfterImmunity, ToadWarrior.getLostHPAfterImmunity)
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, ToadWarrior.skillatk2_onAttackFrame)
  end
  return hero
end

return ToadWarrior.init_hero
