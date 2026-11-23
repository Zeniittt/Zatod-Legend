local function initBuff(buff)
  local Ult_values = {
    20,
    
    40,
    60,
    120
  }
  buff:setAttribute("HP", 100 * buff.rank)
  buff:setAttribute("UltRatio", Ult_values[buff.rank] or 0)
  return buff
end

return initBuff
