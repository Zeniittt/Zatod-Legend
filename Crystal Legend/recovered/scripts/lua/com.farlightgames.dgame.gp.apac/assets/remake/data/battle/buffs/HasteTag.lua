local function initBuff(buff)
  local owner = buff.owner
  
  local value = ed.getDataTable("SoloCardTag")[11]["Star Bonus 1"][buff.rank]
  owner.hasteRatioPlus = owner.hasteRatioPlus + value / 100
  buff:setAttribute("HP", 100 * buff.rank)
  return buff
end

return initBuff
