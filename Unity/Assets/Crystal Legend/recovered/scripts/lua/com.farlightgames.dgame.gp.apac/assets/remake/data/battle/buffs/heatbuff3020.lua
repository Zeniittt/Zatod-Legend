local function heatbuff3020update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  buff.dt = buff.dt and buff.dt + dt or dt
  local owner = buff.owner
  local caster = buff.caster
  local buffid = buff.info.ID
  local level = buffid - 20030200
  if buff.dt == 1 then
    buff:setAttribute("AP", 0.1 * level * owner.attribs.AP)
    owner:rebuild()
  end
end

local function initBuff(buff)
  buff.update = override(buff.update, heatbuff3020update)
  return buff
end

return initBuff
