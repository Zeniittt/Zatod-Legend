local function onStart(buff)
  if not buff.isTrigger then
    local owner = buff.owner
    
    local HP_values = ed.getDataTable("SoloCardTag")[4]["Star Bonus 1"]
    local HP_amount = (HP_values[buff.rank] or 0) / 100 * owner.attribs.HP
    owner.attribs.HP = owner.attribs.HP + HP_amount
    buff:setAttribute("HP", HP_amount + buff.rank * 100)
    buff.isTrigger = true
  end
end

local function initBuff(buff)
  local owner = buff.owner
  buff:setAttribute("HP", 100 * buff.rank)
  
  function buff.onStart(buff)
    onStart(buff)
  end
  
  return buff
end

return initBuff
