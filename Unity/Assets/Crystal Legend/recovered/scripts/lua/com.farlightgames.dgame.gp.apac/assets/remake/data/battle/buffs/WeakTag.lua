local function initBuff(buff)
  local owner = buff.owner
  
  local value = ed.getDataTable("SoloCardTag")[10]["Star Bonus 1"][buff.rank]
  owner.weakRatioPlus = owner.weakRatioPlus + value / 100
  buff:setAttribute("HP", 100 * buff.rank)
  return buff
end

return initBuff
