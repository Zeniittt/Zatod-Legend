local function dungeonbuff1002_update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  buff.dt = buff.dt and buff.dt + dt or dt
  local owner = buff.owner
  local caster = buff.caster
  local buffid = buff.info.ID
  local level = buffid - 40010020
  if buff.dt == dt then
    buff:setAttribute("AD", -0.2 * level * owner.attribs.AD)
    buff:setAttribute("AP", -0.2 * level * owner.attribs.AP)
    buff:setAttribute("HP", -0.2 * level * owner.attribs.HP / owner.config.hp_mod)
    owner:rebuild()
    owner:setHP(owner.attribs.HP)
  end
end

local function initBuff(buff)
  buff.update = override(buff.update, dungeonbuff1002_update)
  buff.unremoveable = true
  return buff
end

return initBuff
