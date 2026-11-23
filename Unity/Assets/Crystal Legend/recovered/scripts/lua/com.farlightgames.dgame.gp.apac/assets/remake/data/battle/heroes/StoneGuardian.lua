module("ed.battlehero", package.seeall)
local ed = ed
StoneGuardian = {}

function StoneGuardian.DOP_in_battlefield(caster, radius, camp)
  local position = {400, 0}
  local count = 0
  local maxcount = 0
  local distance = 0
  local mindistance = 9999
  for x = 0, 800, 25 do
    for y = -100, 100, 25 do
      for unit in ed.engine:foreachAliveUnit(camp) do
        local unitdistance = ed.edpDistanceSQ({x, y}, unit.position)
        if (unit.buffManager.invisible or unit.buff_effects.untargetable or unit.buff_effects.invulnerable) and unit.camp ~= caster.camp then
        elseif unitdistance <= radius * radius then
          count = count + 1
          distance = distance + unitdistance
        end
      end
      if maxcount < count then
        maxcount = count
        mindistance = distance
        position = {x, y}
      end
      if count == maxcount and distance < mindistance then
        mindistance = distance
        position = {x, y}
      end
      count = 0
      distance = 0
    end
  end
  if 0 < maxcount then
    return position
  else
    position = {400, 0}
    return position
  end
end

function StoneGuardian.skillatk2_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local attack_counter = skill.attack_counter
  if attack_counter then
    local attack_point = StoneGuardian.DOP_in_battlefield(caster, 140, caster.foecamp)
    if attack_counter == 0 then
      attack_point = StoneGuardian.DOP_in_battlefield(caster, 140, caster.foecamp)
      skill.attack_counter = skill.attack_counter + 1
    end
    if attack_counter == 1 then
      local effect_name = "eff_point_StoneGuardian_atk2.cha"
      if ed.run_with_scene and effect_name then
        ed.scene:playEffectOnScene(effect_name, attack_point, nil, nil, 1)
      end
      skill.attack_counter = skill.attack_counter + 1
    end
    if attack_counter == 2 then
      skill:takeEffectAt(attack_point, caster)
      skill.attack_counter = skill.attack_counter + 1
      skill:finish()
    end
  end
end

function StoneGuardian.skillatk3_onAttackFrame(basefunc, skill)
  basefunc(skill)
  skill.thrownUnit = skill.target
end

function StoneGuardian.skillatk3_update(basefunc, skill, dt_action, dt_cd)
  basefunc(skill, dt_action, dt_cd)
  if skill.thrownUnit and skill.thrownUnit.knockup_time <= 0 then
    local unit = skill.thrownUnit
    skill.thrownUnit = nil
    local info = skill.info
    skill.info = ed.wraptable(info, {
      ["Damage Type"] = "AP",
      ["Basic Num"] = info["Script Arg2"],
      ["Plus Ratio"] = info["Script Arg3"],
      ["AOE Origin"] = "target",
      ["Knock Up"] = 0,
      ["Knock Back"] = 0
    })
    skill:takeEffectAt(unit.position)
    skill.info = info
  end
end

function StoneGuardian.init_hero(hero)
  local skillatk2 = hero.skills.StoneGuardian_atk2
  local skillatk3 = hero.skills.StoneGuardian_atk3
  if skillatk2 then
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, StoneGuardian.skillatk2_onAttackFrame)
  end
  if skillatk3 then
    skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, StoneGuardian.skillatk3_onAttackFrame)
    skillatk3.update = override(skillatk3.update, StoneGuardian.skillatk3_update)
  end
  return hero
end

return StoneGuardian.init_hero
