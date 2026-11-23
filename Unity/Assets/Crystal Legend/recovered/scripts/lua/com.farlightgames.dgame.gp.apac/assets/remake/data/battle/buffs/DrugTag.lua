local function initBuff(buff)
  local owner = buff.owner
  
  local value = ed.getDataTable("SoloCardTag")[7]["Star Bonus 1"][buff.rank]
  owner.drugRatioPlus = owner.drugRatioPlus + value / 100
  buff:setAttribute("HP", 100 * buff.rank)
  return buff
end

return initBuff
