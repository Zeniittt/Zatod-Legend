local function initBuff(buff)
  local owner = buff.owner
  
  local value = ed.getDataTable("SoloCardSkill")[75]["Level Arg 1"][buff.rank]
  owner.deFrozenRatio = value / 100
  return buff
end

return initBuff
