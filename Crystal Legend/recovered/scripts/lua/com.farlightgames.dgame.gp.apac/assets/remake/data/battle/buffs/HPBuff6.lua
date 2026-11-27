local function initBuff(buff)
  local owner = buff.owner
  
  local hp_value = ed.getDataTable("SoloCardSkill")[27]["Level Arg 1"]
  buff:setAttribute("HP", hp_value[buff.rank] or 0)
  return buff
end

return initBuff
