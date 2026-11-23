local function onAttackSlot5(buff, skill)
  local arg = ed.getDataTable("SoloCardSkill")[1]["Level Arg 1"][1]
  
  if arg > ed.rand() * 100 then
    skill:createTrackType(skill.info["Track Type"])
    if ed.run_with_scene then
      local isPlayer = true
      if buff.owner.camp ~= 1 then
        isPlayer = false
      end
      local battleData = ed.SoloModel:getFactionBattleData(1, isPlayer)
      if battleData then
        battleData:addValue(1, 1, 1)
      end
      ed.scene:playEffectOnScene("eff_point_solo_card1_1.cha", buff.owner.position, {
        buff.owner.direction,
        1
      }, nil, 1)
      ed.scene:playEffectOnScene("eff_point_solo_card1_2.cha", buff.owner.position, {
        buff.owner.direction,
        1
      }, nil, -1)
    end
  end
end

local function initBuff(buff)
  function buff.onAttackSlot5(skill)
    onAttackSlot5(buff, skill)
  end
  
  return buff
end

return initBuff
