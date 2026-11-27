local function HPBuff11_update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  local owner = buff.owner
  local skill = owner.basic_skill
  local target = skill:selectTarget()
  if target and not owner.HPBuff11 then
    owner.HPBuff11 = true
    local HP_Value = owner.attribs.HP
    local HP_MP_layers = math.floor(HP_Value / 300)
    local HPBuff11_values = ed.getDataTable("SoloCardSkill")[32]["Level Arg 1"]
    local HPBuff11_Maxvalues = ed.getDataTable("SoloCardSkill")[32]["Level Arg 2"]
    local HP_MP_Amount = (HPBuff11_values[buff.rank] or 0) * HP_MP_layers
    local HP_MP_Max = HPBuff11_Maxvalues[buff.rank] or 0
    local HP_MP_Real = math.min(HP_MP_Amount, HP_MP_Max)
    buff:setAttribute("MPRatio", HP_MP_Real)
    buff:setAttribute("MPGainRatio", HP_MP_Real)
    owner:resetBuffApply(buff)
    owner:rebuild()
  end
end

local function initBuff(buff)
  local owner = buff.owner
  if owner then
    owner.HPBuff11 = false
  end
  buff.update = override(buff.update, HPBuff11_update)
  return buff
end

return initBuff
