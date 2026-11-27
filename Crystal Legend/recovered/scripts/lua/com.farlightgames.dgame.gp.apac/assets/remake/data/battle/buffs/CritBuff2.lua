local function CritBuff2_update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  local owner = buff.owner
  if not owner.CritBuff2 or owner.CritBuff2_last_crit ~= owner.attribs.CRIT then
    owner.CritBuff2 = true
    local CritBuff2_values = ed.getDataTable("SoloCardSkill")[17]["Level Arg 1"]
    local MCRIT = (CritBuff2_values[buff.rank] or 0) / 100 * owner.attribs.CRIT
    buff:setAttribute("MCRIT", math.max(0, MCRIT))
    owner:resetBuffApply(buff)
    owner:rebuild()
    owner.CritBuff2_last_crit = owner.attribs.CRIT
  end
end

local function initBuff(buff)
  local owner = buff.owner
  if owner then
    owner.CritBuff2 = false
    owner.CritBuff2_last_crit = owner.attribs.CRIT
  end
  buff.update = override(buff.update, CritBuff2_update)
  return buff
end

return initBuff
