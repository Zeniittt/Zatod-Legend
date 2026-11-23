local function initBuff(buff)
  local owner = buff.owner
  
  local dodg_value = ed.getDataTable("SoloCardSkill")[13]["Level Arg 1"]
  buff:setAttribute("DODG", dodg_value[buff.rank] or 0)
  return buff
end

return initBuff
