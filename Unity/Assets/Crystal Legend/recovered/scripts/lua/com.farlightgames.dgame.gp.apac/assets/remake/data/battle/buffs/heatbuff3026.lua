local function heatbuff3026update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  buff.dt = buff.dt and buff.dt + dt or dt
  local owner = buff.owner
  local caster = buff.caster
  local buffid = buff.info.ID
  local level = buffid - 20030260
  if buff.dt == 1 then
    buff:setAttribute("MR", 30 * level)
    owner:rebuild()
  end
end

local function initBuff(buff)
  buff.update = override(buff.update, heatbuff3026update)
  return buff
end

return initBuff
