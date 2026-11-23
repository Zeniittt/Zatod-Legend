local function UltBuff5_update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  local owner = buff.owner
  if not owner.UltBuff5 then
    owner.UltBuff5 = true
    local UltBuff5_values = ed.getDataTable("SoloCardSkill")[47]["Level Arg 1"]
    buff:setAttribute("MPR", UltBuff5_values[buff.rank], owner)
    owner:resetBuffApply(buff)
  end
end

local function initBuff(buff)
  local owner = buff.owner
  if owner then
    owner.UltBuff5 = false
  end
  buff.update = override(buff.update, UltBuff5_update)
  return buff
end

return initBuff
