module("ed.battlehero", package.seeall)
local ed = ed
randomAerolite = {}
randomAerolite.aeroliteEffectName = "eff_point_FieldNPC_randomAerolite.cha"
randomAerolite.damageDelayTime = 1
randomAerolite.aeroliteCd = 5.5

function randomAerolite.findTargetPosition(field)
  local maxDamage = -1
  local target
  for unit in ed.engine:foreachAliveUnit(ed.emCampBoth) do
    if unit == field then
    elseif unit.buff_effects.invulnerable then
    elseif unit.position[1] < ed.engine.stage_rect.minX then
    elseif unit.position[1] > ed.engine.stage_rect.maxX then
    elseif maxDamage <= unit.battledata.damage then
      maxDamage = unit.battledata.damage
      target = unit
    end
  end
  local position = target and target.position or nil
  return position
end

function randomAerolite.skill_update(basefunc, skill, dt_action, dt_cd)
  basefunc(skill, dt_action, dt_cd)
  local field = skill.caster
  if skill and not skill.field_aeroliteStart and skill.cd_remaining <= 0 then
    skill.field_aeroliteStart = true
    skill.field_aeroliteCd = randomAerolite.aeroliteCd
  end
  if skill.field_aeroliteCd then
    skill.field_aeroliteCd = skill.field_aeroliteCd - dt_cd
    if 0 >= skill.field_aeroliteCd and not skill.field_aeroliteDroping then
      skill.field_aeroliteTargetPos = randomAerolite.findTargetPosition(field)
      if skill.field_aeroliteTargetPos then
        skill.field_aeroliteCd = randomAerolite.aeroliteCd
        skill.field_aeroliteDropTime = randomAerolite.damageDelayTime
        skill.field_aeroliteDroping = true
        local scaleX = ed.rand() < 0.5 and 1.5 or -1.5
        if ed.run_with_scene then
          ed.scene:playEffectOnScene(randomAerolite.aeroliteEffectName, skill.field_aeroliteTargetPos, {scaleX, 1.5}, nil, 0)
        end
      end
    end
    if skill.field_aeroliteDropTime then
      skill.field_aeroliteDropTime = skill.field_aeroliteDropTime - dt_cd
      if 0 >= skill.field_aeroliteDropTime then
        local position = skill.field_aeroliteTargetPos
        if position then
          skill:takeEffectAt(position)
        end
        skill.field_aeroliteDroping = nil
        skill.field_aeroliteDropTime = nil
        skill.field_aeroliteTargetPos = nil
      end
    end
  end
end

function randomAerolite.init_fieldSkill(skill)
  skill.update = override(skill.update, randomAerolite.skill_update)
  return skill
end

return randomAerolite.init_fieldSkill
