local function initBuff(buff)
  local owner = buff.owner
  
  local value = ed.getDataTable("SoloCardSkill")[90]["Level Arg 1"][buff.rank]
  owner.deShieldRatio = value / 100
  return buff
end

return initBuff
