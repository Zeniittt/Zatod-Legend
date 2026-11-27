local function heatbuff3028update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  buff.dt = buff.dt and buff.dt + dt or dt
  local owner = buff.owner
  local caster = buff.caster
  local buffid = buff.info.ID
  local level = buffid - 20030280
  if buff.dt == 1 then
    buff:setAttribute("TEN", 20 * level)
    owner:rebuild()
  end
end

local function initBuff(buff)
  buff.update = override(buff.update, heatbuff3028update)
  return buff
end

return initBuff
