local function AttackBuff3_update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  local owner = buff.owner
  if not owner.AttackBuff3 then
    owner.AttackBuff3 = true
    local args = ed.getDataTable("SoloCardSkill")[3]["Level Arg 1"]
    buff:setAttribute("MSPD", args[buff.rank] or 0)
    owner:resetBuffApply(buff)
  end
end

local function initBuff(buff)
  buff.update = override(buff.update, AttackBuff3_update)
  return buff
end

return initBuff
