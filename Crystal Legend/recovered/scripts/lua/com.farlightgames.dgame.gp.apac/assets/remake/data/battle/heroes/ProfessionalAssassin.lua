module("ed.ProfessionalAssassin", package.seeall)
local ed = ed
ProfessionalAssassin = {}

function ProfessionalAssassin.skillatk2_start(basefunc, skill, target)
  local caster = skill.caster
  local originfo = skill.info
  if target then
    local bid = 10034703
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    caster:addBuff(binfo, caster)
  end
  basefunc(skill, target)
end

function ProfessionalAssassin.skillatk2_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  local hero = skill.caster
  local target = skill.target
  local blink_distance = 70
  if attack_counter == 0 then
    local direction = 0 < target.position[1] - hero.position[1] and -1 or 1
    hero.direction = direction
    local position1 = target.position[1] - direction * blink_distance
    if target.buff_effects.stable or 799 < position1 or position1 < 1 then
      position1 = position1 + 2 * direction * blink_distance
      hero.direction = -direction
    end
    hero.position = {
      position1,
      target.position[2]
    }
    skill.attack_counter = skill.attack_counter + 1
  else
    basefunc(skill)
    for i, tbuff in ipairs(hero.buff_list) do
      if tbuff.info.ID == 10034703 then
        tbuff.timer = -1
      end
    end
  end
end

function ProfessionalAssassin.init_hero(hero)
  local skillatk2 = hero.skills.ProfessionalAssassin_atk2
  if skillatk2 then
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, ProfessionalAssassin.skillatk2_onAttackFrame)
    skillatk2.start = override(skillatk2.start, ProfessionalAssassin.skillatk2_start)
  end
  return hero
end

return ProfessionalAssassin.init_hero
