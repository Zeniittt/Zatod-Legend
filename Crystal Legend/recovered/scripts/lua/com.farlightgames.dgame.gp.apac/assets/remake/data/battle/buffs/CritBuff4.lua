local function CritBuff4_update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  local owner = buff.owner
  if not owner.CritBuff4 then
    owner.CritBuff4 = true
    local CritBuff4_values = ed.getDataTable("SoloCardSkill")[19]["Level Arg 1"]
    buff:setAttribute("CRIT", CritBuff4_values[buff.rank])
    owner:resetBuffApply(buff)
  end
end

local function initBuff(buff)
  local owner = buff.owner
  if owner then
    owner.CritBuff4 = false
  end
  buff.update = override(buff.update, CritBuff4_update)
  return buff
end

return initBuff
