local function HPBuff3_update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  local owner = buff.owner
  local MAX_HP = owner.attribs.HP
  local HP_Dvalue = MAX_HP - owner.hp
  local power_ratio_layers = math.floor(HP_Dvalue / 400)
  owner.HP_PowerLayer = power_ratio_layers
  if owner.HP_PowerLayer ~= owner.Last_HP_PowerLayer then
    owner.Last_HP_PowerLayer = owner.HP_PowerLayer
    local HPBuff3_values = ed.getDataTable("SoloCardSkill")[24]["Level Arg 1"]
    buff:setAttribute("ADDP", HPBuff3_values[buff.rank] * owner.HP_PowerLayer or 0)
    buff:setAttribute("APDP", HPBuff3_values[buff.rank] * owner.HP_PowerLayer or 0)
    owner:resetBuffApply(buff)
    owner:rebuild()
  end
end

local function initBuff(buff)
  local owner = buff.owner
  owner.HP_PowerLayer = 0
  owner.Last_HP_PowerLayer = 0
  buff.update = override(buff.update, HPBuff3_update)
  return buff
end

return initBuff
