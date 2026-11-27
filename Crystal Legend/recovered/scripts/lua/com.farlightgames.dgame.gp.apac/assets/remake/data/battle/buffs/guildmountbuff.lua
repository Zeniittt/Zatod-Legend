local function guildmountbuff_update(basefunc, buff, dt)
  buff.dt = buff.dt and buff.dt + dt or dt
  
  local owner = buff.owner
  if buff.dt == dt then
    local ten = 0
    if owner.level > 50 and owner.level < 70 then
      ten = 25
    end
    if owner.level > 70 and owner.level < 90 then
      ten = 40
    end
    if owner.level >= 90 then
      ten = 50
    end
    if owner.GuildMountControl == true then
      ten = 0
    end
    buff:setAttribute("TEN", ten)
    owner:rebuild()
  end
end

local function initBuff(buff)
  buff.update = override(buff.update, guildmountbuff_update)
  buff.unremoveable = true
  return buff
end

return initBuff
