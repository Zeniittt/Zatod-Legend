local function heatbuff3016update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  buff.dt = buff.dt and buff.dt + dt or dt
  local owner = buff.owner
  local caster = buff.caster
  local buffid = buff.info.ID
  local level = buffid - 20030160
  if buff.dt == 1 then
    buff:setAttribute("MR", 0.1 * level * owner.attribs.MR)
    owner:rebuild()
  end
end

local function initBuff(buff)
  buff.update = override(buff.update, heatbuff3016update)
  return buff
end

return initBuff
