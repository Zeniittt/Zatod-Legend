local function initBuff(buff)
  local owner = buff.owner
  
  buff:setAttribute("HP", 100 * buff.rank)
  local Heal_values = ed.getDataTable("SoloCardTag")[5]["Star Bonus 1"]
  buff:setAttribute("HealRatio", Heal_values[buff.rank] or 0)
  return buff
end

return initBuff
