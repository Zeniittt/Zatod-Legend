local function roguebuff5402_controlcdupdate(basefunc, buff, dt)
  basefunc(buff, dt)
  
  local owner = buff.owner
  if not owner.roguebuff5402_controlcd then
    buff.rogue5402attack_timer = buff.rogue5402attack_timer - dt
  end
  if buff.rogue5402attack_timer <= 0 then
    owner.roguebuff5402_controlcd = true
    buff.rogue5402attack_timer = 1
  end
end

local function initBuff(buff)
  local caster = buff.caster
  local owner = buff.owner
  buff.rogue5402attack_timer = 1
  owner.roguebuff5402_controlcd = false
  buff.update = override(buff.update, roguebuff5402_controlcdupdate)
  return buff
end

return initBuff
