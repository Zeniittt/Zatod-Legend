local function initBuff(buff)
  local owner = buff.owner
  
  local atk_value = ed.getDataTable("SoloCardSkill")[5]["Level Arg 1"]
  buff:setAttribute("AD", atk_value[buff.rank] or 0)
  return buff
end

return initBuff
