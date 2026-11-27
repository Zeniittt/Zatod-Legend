local function initBuff(buff)
  local owner = buff.owner
  
  buff:setAttribute("HP", 100 * buff.rank)
  local SpeedUP_values = ed.getDataTable("SoloCardTag")[1]["Star Bonus 1"]
  buff:setAttribute("MSPD", SpeedUP_values[buff.rank] or 0)
  return buff
end

return initBuff
