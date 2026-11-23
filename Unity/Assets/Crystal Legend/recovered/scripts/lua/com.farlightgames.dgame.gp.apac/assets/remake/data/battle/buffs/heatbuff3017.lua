local function heatbuff3017update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  buff.dt = buff.dt and buff.dt + dt or dt
  local owner = buff.owner
  local caster = buff.caster
  local buffid = buff.info.ID
  local level = buffid - 20030170
  if buff.dt == 1 then
    buff:setAttribute("DODG", 0.5 * level * owner.attribs.DODG)
    owner:rebuild()
  end
end

local function initBuff(buff)
  buff.update = override(buff.update, heatbuff3017update)
  return buff
end

return initBuff
