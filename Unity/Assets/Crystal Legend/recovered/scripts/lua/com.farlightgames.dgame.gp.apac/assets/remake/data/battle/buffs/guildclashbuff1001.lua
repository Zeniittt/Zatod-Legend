local function guildclashbuff1001_update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  buff.dt = buff.dt and buff.dt + dt or dt
  local owner = buff.owner
  local winTimes = buff.params.winTimes
  local reduceratio = 0
  if buff.dt == dt then
    local hppercent = owner.hp / owner.attribs.HP
    if 5 <= winTimes and winTimes <= 9 then
      reduceratio = 0.07 * (winTimes - 4)
    end
    if 10 <= winTimes then
      reduceratio = 0.35
    end
    buff:setAttribute("AD", -reduceratio * owner.attribs.AD)
    buff:setAttribute("AP", -reduceratio * owner.attribs.AP)
    buff:setAttribute("HP", -reduceratio * owner.attribs.HP / owner.config.hp_mod)
    buff:setAttribute("ARM", -reduceratio * owner.attribs.ARM)
    buff:setAttribute("MR", -reduceratio * owner.attribs.MR)
    owner:rebuild()
    owner:setHP(hppercent * owner.attribs.HP)
  end
end

local function initBuff(buff)
  buff.update = override(buff.update, guildclashbuff1001_update)
  buff.unremoveable = true
  return buff
end

return initBuff
