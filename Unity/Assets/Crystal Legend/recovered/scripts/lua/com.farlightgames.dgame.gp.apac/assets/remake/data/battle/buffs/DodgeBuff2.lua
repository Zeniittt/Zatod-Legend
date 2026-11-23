local function DodgeBuff2_update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  local owner = buff.owner
  local Dodgebuff2_values = ed.getDataTable("SoloCardSkill")[10]["Level Arg 1"]
  local MDODG = (Dodgebuff2_values[buff.rank] or 0) / 100 * owner.attribs.DODG
  buff:setAttribute("MDODG", MDODG)
  owner:resetBuffApply(buff)
end

local function initBuff(buff)
  buff.update = override(buff.update, DodgeBuff2_update)
  return buff
end

return initBuff
