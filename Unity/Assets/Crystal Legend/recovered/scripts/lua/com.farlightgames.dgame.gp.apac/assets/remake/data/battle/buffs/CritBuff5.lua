local function initBuff(buff)
  local owner = buff.owner
  
  local CRIT_value = ed.getDataTable("SoloCardSkill")[20]["Level Arg 1"]
  buff:setAttribute("CRIT", CRIT_value[buff.rank] or 0)
  return buff
end

return initBuff
