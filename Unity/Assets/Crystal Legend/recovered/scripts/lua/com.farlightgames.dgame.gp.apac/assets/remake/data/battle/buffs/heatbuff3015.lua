local function heatbuff3015update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  buff.dt = buff.dt and buff.dt + dt or dt
  local owner = buff.owner
  local caster = buff.caster
  local buffid = buff.info.ID
  local level = buffid - 20030150
  if buff.dt == 1 then
    buff:setAttribute("ARM", 0.1 * level * owner.attribs.ARM)
    owner:rebuild()
  end
end

local function initBuff(buff)
  buff.update = override(buff.update, heatbuff3015update)
  return buff
end

return initBuff
