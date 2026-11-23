local function HPBuff10_update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  local owner = buff.owner
  local skill = owner.basic_skill
  local target = skill:selectTarget()
  if target and not owner.HPBuff10 then
    owner.HPBuff10 = true
    local HP_Value = target.attribs.HP
    local HP_Steal_layers = math.floor(HP_Value / 1000)
    local HPBuff10_values = ed.getDataTable("SoloCardSkill")[31]["Level Arg 1"]
    local HPBuff10_Maxvalues = ed.getDataTable("SoloCardSkill")[31]["Level Arg 2"]
    local HP_Steal_Target = (HPBuff10_values[buff.rank] or 0) * HP_Value * 0.01 * HP_Steal_layers
    local HP_Steal_Max = (HPBuff10_Maxvalues[buff.rank] or 0) * HP_Value * 0.01
    local HP_Steal_Real = math.min(HP_Steal_Target, HP_Steal_Max)
    local Target_bid = 90000055
    local Target_binfo = ed.lookupDataTable("Buff", nil, Target_bid)
    local HP10_1Buff = ed.BuffCreate(Target_binfo, target, owner)
    HP10_1Buff:setAttribute("HP", -HP_Steal_Real)
    target:addBuff(HP10_1Buff, owner)
    target:resetBuffApply(buff)
    target:rebuild()
    target:setHP(target.attribs.HP)
    buff:setAttribute("HP", HP_Steal_Real)
    owner:resetBuffApply(buff)
    owner:rebuild()
    owner:setHP(owner.attribs.HP)
  end
end

local function initBuff(buff)
  local owner = buff.owner
  if owner then
    owner.HPBuff10 = false
  end
  buff.update = override(buff.update, HPBuff10_update)
  return buff
end

return initBuff
