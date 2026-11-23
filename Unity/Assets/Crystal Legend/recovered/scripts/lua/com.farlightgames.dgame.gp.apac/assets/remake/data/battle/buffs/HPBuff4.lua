local function HPBuff4_update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  local owner = buff.owner
  if not owner.HPBuff4 then
    owner.HPBuff4 = true
    local HPBuff4_values = ed.getDataTable("SoloCardSkill")[25]["Level Arg 1"]
    buff:setAttribute("MIMU", HPBuff4_values[buff.rank] or 0)
    owner:resetBuffApply(buff)
  end
end

local function initBuff(buff)
  local owner = buff.owner
  if owner then
    owner.HPBuff4 = false
  end
  buff.update = override(buff.update, HPBuff4_update)
  return buff
end

return initBuff
