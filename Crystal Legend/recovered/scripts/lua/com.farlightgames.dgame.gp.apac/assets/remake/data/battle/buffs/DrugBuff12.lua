local function initBuff(buff)
  local owner = buff.owner
  
  owner.drugDamageRatio = 1 - ed.getDataTable("SoloCardSkill")[63]["Level Arg 1"][buff.rank] / 100
  return buff
end

return initBuff
