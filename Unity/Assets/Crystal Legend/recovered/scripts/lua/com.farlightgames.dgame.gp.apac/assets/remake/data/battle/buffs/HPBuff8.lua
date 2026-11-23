local function initBuff(buff)
  local owner = buff.owner
  
  local count = 0
  for k, v in pairs(owner.cards) do
    local cardTb = ed.getDataTable("SoloCardSkill")[k]
    if cardTb.Tag1 == 2 or cardTb.Tag2 == 2 then
      count = count + 1
    end
  end
  local HPBuff7_values = ed.getDataTable("SoloCardSkill")[29]["Level Arg 1"]
  buff:setAttribute("HP", (HPBuff7_values[buff.rank] or 0) * count)
  return buff
end

return initBuff
