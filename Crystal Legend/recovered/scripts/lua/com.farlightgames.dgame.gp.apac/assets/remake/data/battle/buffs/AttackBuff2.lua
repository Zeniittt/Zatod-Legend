local function AttackBuff2_update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  local owner = buff.owner
  if not owner.AttackBuff2 then
    owner.AttackBuff2 = true
    local args = ed.getDataTable("SoloCardSkill")[2]["Level Arg 1"]
    buff:setAttribute("AD", args[buff.rank] or 0)
    owner:resetBuffApply(buff)
  end
end

local function initBuff(buff)
  local owner = buff.owner
  if owner then
    owner.AttackBuff2 = false
  end
  buff.update = override(buff.update, AttackBuff2_update)
  return buff
end

return initBuff
