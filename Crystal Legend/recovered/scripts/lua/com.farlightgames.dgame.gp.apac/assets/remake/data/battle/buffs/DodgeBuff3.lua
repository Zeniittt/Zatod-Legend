local function DodgeBuff3_update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  local owner = buff.owner
  if not owner.DodgeBuff3 then
    owner.DodgeBuff3 = true
    local DodgeBuff3_values = ed.getDataTable("SoloCardSkill")[11]["Level Arg 1"]
    buff:setAttribute("DODG", DodgeBuff3_values[buff.rank] or 0)
    owner:resetBuffApply(buff)
  end
end

local function initBuff(buff)
  local owner = buff.owner
  if owner then
    owner.DodgeBuff3 = false
  end
  buff.update = override(buff.update, DodgeBuff3_update)
  return buff
end

return initBuff
