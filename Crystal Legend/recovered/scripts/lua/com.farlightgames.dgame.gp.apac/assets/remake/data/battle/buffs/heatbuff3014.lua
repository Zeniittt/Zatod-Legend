local function heatbuff3014update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  buff.dt = buff.dt and buff.dt + dt or dt
  local owner = buff.owner
  local caster = buff.caster
  local buffid = buff.info.ID
  local level = buffid - 20030140
  if buff.dt == 1 then
    buff:setAttribute("AD", 0.05 * level * owner.attribs.AD)
    owner:rebuild()
  end
end

local function initBuff(buff)
  buff.update = override(buff.update, heatbuff3014update)
  return buff
end

return initBuff
