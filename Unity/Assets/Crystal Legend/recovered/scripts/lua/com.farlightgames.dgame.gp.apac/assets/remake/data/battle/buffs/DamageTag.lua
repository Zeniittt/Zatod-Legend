local function AttackTag_update(basefunc, buff, dt)
  basefunc(buff, dt)
end

local function initBuff(buff)
  buff.update = override(buff.update, AttackTag_update)
  return buff
end

return initBuff
