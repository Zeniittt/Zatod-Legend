local function roguebuff5000_controlcdupdate(basefunc, buff, dt)
  basefunc(buff, dt)
  
  local owner = buff.owner
  if not owner.roguebuff5000_controlcd then
    buff.rogue5000attack_timer = buff.rogue5000attack_timer - dt
  end
  if buff.rogue5000attack_timer <= 0 then
    owner.roguebuff5000_controlcd = true
    buff.rogue5000attack_timer = 1
  end
end

local function initBuff(buff)
  local caster = buff.caster
  local owner = buff.owner
  buff.rogue5000attack_timer = 1
  owner.roguebuff5000_controlcd = false
  buff.update = override(buff.update, roguebuff5000_controlcdupdate)
  return buff
end

return initBuff
