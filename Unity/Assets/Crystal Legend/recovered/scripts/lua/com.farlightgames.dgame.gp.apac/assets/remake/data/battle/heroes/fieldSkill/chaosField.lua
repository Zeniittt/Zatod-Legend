module("ed.battlehero", package.seeall)
local ed = ed
chaosField = {}
chaosField.minX = ed.engine.stage_rect.minX
chaosField.maxX = ed.engine.stage_rect.maxX
chaosField.chaosEffectName = "eff_point_FieldNPC_chaosPosition.cha"
chaosField.imprisonmentBuffId = 886
chaosField.deltaX = 80
chaosField.deltaY = 50
chaosField.timePoint1 = 1
chaosField.timePoint2 = 1.75
chaosField.timePoint3 = 2.25

function chaosField.skill_update(basefunc, skill, dt_action, dt_cd)
  basefunc(skill, dt_action, dt_cd)
  local field = skill.caster
  if skill and skill.cd_remaining <= 0 and not skill.field_chaosStartTime and not skill.field_alreadyChaos then
    skill.field_chaosStartTime = 0
    for unit in ed.engine:foreachAliveUnit(ed.emCampBoth) do
      unit:setHpVisible(false)
    end
  end
  if skill.field_chaosStartTime then
    skill.field_chaosStartTime = skill.field_chaosStartTime + dt_cd
  end
  local time = skill.field_chaosStartTime or -1
  if time >= chaosField.timePoint1 and time < chaosField.timePoint2 and not skill.field_chaosPhase then
    skill.field_chaosPhase = "effect"
    if ed.run_with_scene then
      local origin = {
        chaosField.maxX / 2,
        0
      }
      local effect = ed.scene:playEffectOnScene(chaosField.chaosEffectName, origin, nil, nil, 1)
      local scaleX = effect:getScaleX()
      local scaleY = effect:getScaleY()
      effect:setScaleX(scaleX * 5)
      effect:setScaleY(scaleY * 5)
    end
  elseif time >= chaosField.timePoint2 and time < chaosField.timePoint3 and skill.field_chaosPhase == "effect" then
    skill.field_chaosPhase = "addbuff"
    for unit in ed.engine:foreachAliveUnit(ed.emCampBoth) do
      local binfo = ed.lookupDataTable("Buff", nil, chaosField.imprisonmentBuffId)
      local buff = unit:addBuff(binfo, field)
    end
  elseif time >= chaosField.timePoint3 and skill.field_chaosPhase == "addbuff" then
    for unit in ed.engine:foreachAliveUnit(ed.emCampBoth) do
      local newX = ed.rand() * (chaosField.maxX - chaosField.minX - 2 * chaosField.deltaX) + chaosField.minX + chaosField.deltaX
      local newY = ed.rand() * (2 * chaosField.deltaY) - chaosField.deltaY
      unit.position = {newX, newY}
      unit:setHpVisible(true)
      for _, buff in ipairs(unit.buff_list) do
        if buff.info.ID == chaosField.imprisonmentBuffId then
          buff.timer = 0
        end
      end
    end
    skill.field_chaosPhase = "end"
    skill.field_alreadyChaos = true
    skill.cd_remaining = 9999
    skill.field_chaosStartTime = nil
  end
end

function chaosField.init_fieldSkill(skill)
  skill.update = override(skill.update, chaosField.skill_update)
  return skill
end

return chaosField.init_fieldSkill
