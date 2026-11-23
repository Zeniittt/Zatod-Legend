local function initBuff(buff)
  local owner = buff.owner
  
  local atkCardCount = 0
  for k, v in pairs(owner.cards) do
    local cardTb = ed.getDataTable("SoloCardSkill")[k]
    if cardTb.Tag1 == 1 or cardTb.Tag2 == 1 then
      atkCardCount = atkCardCount + 1
    end
  end
  local HPBuff7_values = ed.getDataTable("SoloCardSkill")[28]["Level Arg 1"]
  buff:setAttribute("HP", (HPBuff7_values[buff.rank] or 0) * atkCardCount)
  return buff
end

return initBuff
