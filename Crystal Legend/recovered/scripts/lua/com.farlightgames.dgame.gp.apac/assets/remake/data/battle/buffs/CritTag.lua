local function initBuff(buff)
  local owner = buff.owner
  
  buff:setAttribute("HP", 100 * buff.rank)
  local Cirt_values = ed.getDataTable("SoloCardTag")[3]["Star Bonus 1"]
  buff:setAttribute("CRIT", Cirt_values[buff.rank] or 0)
  return buff
end

return initBuff
