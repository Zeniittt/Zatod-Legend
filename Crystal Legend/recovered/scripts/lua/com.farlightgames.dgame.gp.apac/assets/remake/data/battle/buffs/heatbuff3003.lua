local function heatbuff3003update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  buff.dt = buff.dt and buff.dt + dt or dt
  local owner = buff.owner
  local caster = buff.caster
  local buffid = buff.info.ID
  local level = buffid - 20030030
  if buff.dt == 1 then
    owner:setHP(owner.attribs.HP * (1 - 0.1 * level))
  end
end

local function initBuff(buff)
  buff.update = override(buff.update, heatbuff3003update)
  return buff
end

return initBuff
