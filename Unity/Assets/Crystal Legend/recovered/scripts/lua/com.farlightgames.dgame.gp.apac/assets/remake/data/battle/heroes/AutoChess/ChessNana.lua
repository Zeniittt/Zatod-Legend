module("ed.battlehero", package.seeall)
local ed = ed
ChessNana = {}

function ChessNana.buff_check(target)
  local isBuff
  local enhance_effects = {
    frozen = true,
    stun = true,
    silence = true,
    imprisonment = true,
    fear = true,
    polymorph = true,
    doom = true,
    icefrozen = true
  }
  for k, v in pairs(target.buff_effects) do
    if enhance_effects[k] then
      isBuff = true
      break
    end
  end
  return isBuff
end

function ChessNana.skillblink_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  local hero = skill.caster
  local target = skill.target
  local blink_distance = 42
  if attack_counter == 0 then
    if target then
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
    end
    skill.attack_counter = skill.attack_counter + 1
    local bid = 848
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    hero:addBuff(binfo, hero)
  else
    basefunc(skill)
  end
end

function ChessNana.skill_selectTarget(basefunc, self, default)
  local selector = self:target_selector()
  if selector then
    local max = -math.huge
    local chosen
    local caster = self.caster
    local caster_position = caster.position
    local enchanted = caster.buff_effects.enchanted
    for unit in ed.engine:foreachAliveUnit(self:targetCamp()) do
      if unit.config.is_summoned then
      elseif unit.buff_effects.untargetable then
      elseif unit.buffManager.invisible and unit.camp ~= caster.camp then
      elseif enchanted and unit == caster then
      else
        local distanceSQ = (unit.position[1] - caster_position[1]) ^ 2 + (unit.position[2] - caster_position[2]) ^ 2
        if distanceSQ >= self.min_range_sq and distanceSQ <= self.max_range_sq then
          local v = selector(unit)
          if max < v then
            max = v
            chosen = unit
          end
        end
      end
    end
    self.target = chosen
    return self.target
  end
end

function ChessNana.init_hero(hero)
  local skillult = hero.skills.Nana_ult
  if skillult then
    skillult.selectTarget = override(skillult.selectTarget, ChessNana.skill_selectTarget)
    skillult.onAttackFrame = override(skillult.onAttackFrame, ChessNana.skillblink_onAttackFrame)
  end
  return hero
end

return ChessNana.init_hero
