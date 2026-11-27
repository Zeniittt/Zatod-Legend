local function initBuff(buff)
  local owner = buff.owner
  
  buff:setAttribute("HP", 100 * buff.rank)
  local dodge_values = ed.getDataTable("SoloCardTag")[2]["Star Bonus 1"]
  buff:setAttribute("DODG", dodge_values[buff.rank] or 0)
  local PIMU_value = ed.getDataTable("SoloCardTag")[2]["Star Bonus 2"]
  buff:setAttribute("PIMU", PIMU_value[buff.rank] or 0)
  return buff
end

return initBuff
