local function roguebuff5313_controlcdupdate(basefunc, buff, dt)
  basefunc(buff, dt)
  
  local owner = buff.owner
  if not owner.roguebuff5313_controlcd then
    buff.rogue5313attack_timer = buff.rogue5313attack_timer - dt
  end
  if buff.rogue5313attack_timer <= 0 then
    owner.roguebuff5313_controlcd = true
    buff.rogue5313attack_timer = 1
  end
end

local function initBuff(buff)
  local caster = buff.caster
  local owner = buff.owner
  buff.rogue5313attack_timer = 1
  owner.roguebuff5313_controlcd = false
  buff.update = override(buff.update, roguebuff5313_controlcdupdate)
  return buff
end

return initBuff
